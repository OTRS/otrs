# --
# Kernel/System/AuthSession/FS.pm - provides session filesystem backend
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: FS.pm,v 1.19 2006-08-29 17:31:42 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::AuthSession::FS;

use strict;
use Digest::MD5;
use MIME::Base64;
use Kernel::System::Encode;

use vars qw($VERSION);
$VERSION = '$Revision: 1.19 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(LogObject ConfigObject DBObject TimeObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }
    # encode object
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);
    # get more common params
    $Self->{SessionSpool} = $Self->{ConfigObject}->Get('SessionDir');
    $Self->{SystemID} = $Self->{ConfigObject}->Get('SystemID');

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    return $Self;
}
# --
sub CheckSessionID {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = $Param{SessionID};
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'none';
    # set default message
    $Self->{CheckSessionIDMessage} = "SessionID is invalid!!!";
    # session id check
    my %Data = $Self->GetSessionIDData(SessionID => $SessionID);

    if (!$Data{UserID} || !$Data{UserLogin}) {
        $Self->{CheckSessionIDMessage} = "SessionID invalid! Need user data!";
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "SessionID: '$SessionID' is invalid!!!",
        );
        return;
    }
    # remote ip check
    if ( $Data{UserRemoteAddr} ne $RemoteAddr &&
          $Self->{ConfigObject}->Get('SessionCheckRemoteIP') ) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "RemoteIP of '$SessionID' ($Data{UserRemoteAddr}) is different with the ".
           "request IP ($RemoteAddr). Don't grant access!!!",
        );
        # delete session id if it isn't the same remote ip?
        if ($Self->{ConfigObject}->Get('SessionDeleteIfNotRemoteID')) {
            $Self->RemoveSessionID(SessionID => $SessionID);
        }
        return;
    }
    # check session idle time
    my $MaxSessionIdleTime = $Self->{ConfigObject}->Get('SessionMaxIdleTime');
    if ( ($Self->{TimeObject}->SystemTime() - $MaxSessionIdleTime) >= $Data{UserLastRequest} ) {
         $Self->{CheckSessionIDMessage} = 'Session has timed out. Please log in again.';
         $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "SessionID ($SessionID) idle timeout (". int(($Self->{TimeObject}->SystemTime() - $Data{UserLastRequest})/(60*60))
          ."h)! Don't grant access!!!",
        );
        # delete session id if too old?
        if ($Self->{ConfigObject}->Get('SessionDeleteIfTimeToOld')) {
            $Self->RemoveSessionID(SessionID => $SessionID);
        }
        return;
    }
    # check session time
    my $MaxSessionTime = $Self->{ConfigObject}->Get('SessionMaxTime');
    if ( ($Self->{TimeObject}->SystemTime() - $MaxSessionTime) >= $Data{UserSessionStart} ) {
         $Self->{CheckSessionIDMessage} = 'Session has timed out. Please log in again.';
         $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "SessionID ($SessionID) too old (". int(($Self->{TimeObject}->SystemTime() - $Data{UserSessionStart})/(60*60))
          ."h)! Don't grant access!!!",
        );
        # delete session id if too old?
        if ($Self->{ConfigObject}->Get('SessionDeleteIfTimeToOld')) {
            $Self->RemoveSessionID(SessionID => $SessionID);
        }
        return;
    }
    return 1;
}
# --
sub CheckSessionIDMessage {
    my $Self = shift;
    my %Param = @_;
    return $Self->{CheckSessionIDMessage} || '';
}
# --
sub GetSessionIDData {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = $Param{SessionID} || '';
    my $Strg = '';
    my %Data;
    # check session id
    if (!$SessionID) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Got no SessionID!!");
        return;
    }
    # read data
    open (SESSION, "< $Self->{SessionSpool}/$SessionID")
            || warn "Can't open $Self->{SessionSpool}/$SessionID: $!\n";
    while (<SESSION>) {
        chomp;
        # split data
        my @PaarData = split(/:/, $_);
        $Data{$PaarData[0]} = decode_base64($PaarData[1]);
        $Self->{EncodeObject}->Encode(\$Data{$PaarData[0]});
        # Debug
        if ($Self->{Debug}) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "GetSessionIDData: '$PaarData[0]:".decode_base64($PaarData[1])."'",
            );
        }
    }
    close (SESSION);

    return %Data;
}
# --
sub CreateSessionID {
    my $Self = shift;
    my %Param = @_;
    # REMOTE_ADDR
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'none';
    # HTTP_USER_AGENT
    my $RemoteUserAgent = $ENV{HTTP_USER_AGENT} || 'none';
    # create SessionID
    my $md5 = Digest::MD5->new();
    $md5->add(
        ($Self->{TimeObject}->SystemTime() . int(rand(999999999)) . $Self->{SystemID}) . $RemoteAddr . $RemoteUserAgent
    );
    my $SessionID = $Self->{SystemID} . $md5->hexdigest;
    # data 2 strg
    my $DataToStore = '';
    foreach (keys %Param) {
        if (defined($Param{$_})) {
            $Self->{EncodeObject}->EncodeOutput(\$Param{$_});
            $DataToStore .= "$_:". encode_base64($Param{$_}, '') ."\n";
        }
    }
    $DataToStore .= "UserSessionStart:". encode_base64($Self->{TimeObject}->SystemTime(), '') ."\n";
    $DataToStore .= "UserRemoteAddr:". encode_base64($RemoteAddr, '') ."\n";
    $DataToStore .= "UserRemoteUserAgent:". encode_base64($RemoteUserAgent, '') ."\n";
    # store SessionID + data
    open (SESSION, ">> $Self->{SessionSpool}/$SessionID")
            || die "Can't create $Self->{SessionSpool}/$SessionID: $!";
    print SESSION "$DataToStore";
    close (SESSION);

    return $SessionID;
}
# --
sub RemoveSessionID {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = $Param{SessionID};
    # delete fs file
    if (unlink("$Self->{SessionSpool}/$SessionID")) {
        # log event
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Removed SessionID $Param{SessionID}."
        );
        return 1;
    }
    else {
        # log event
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't delete file $Self->{SessionSpool}/$SessionID: $!"
        );
        return 0;
    }
}
# --
sub UpdateSessionID {
    my $Self = shift;
    my %Param = @_;
    my $Key = $Param{Key} || die 'No Key!';
    my $Value = defined($Param{Value}) ? $Param{Value} : '';
    my $SessionID = $Param{SessionID} || die 'No SessionID!';
    my %SessionData = $Self->GetSessionIDData(SessionID => $SessionID);
    # update the value
    $SessionData{$Key} = $Value;
    # set new data sting
    my $NewDataToStore = '';
    foreach (keys %SessionData) {
        $Self->{EncodeObject}->EncodeOutput(\$SessionData{$_});
        $NewDataToStore .= "$_:".encode_base64($SessionData{$_}, '')."\n";
        # Debug
        if ($Self->{Debug}) {
            $Self->{LogObject}->Log(
              Priority => 'debug',
              Message => "UpdateSessionID: $_=$SessionData{$_}",
            );
        }
    }
    # update fs file
    open (SESSION, "> $Self->{SessionSpool}/$SessionID")
         || die "Can't write $Self->{SessionSpool}/$SessionID: $!";
    print SESSION "$NewDataToStore";
    close (SESSION);

    return 1;
}
# --
sub GetAllSessionIDs {
    my $Self = shift;
    my %Param = @_;
    my @SessionIDs = ();
    # read data
    my @List = glob("$Self->{SessionSpool}/$Self->{SystemID}*");
    foreach my $SessionID (@List) {
       $SessionID =~ s!^.*/!!;
       push (@SessionIDs, $SessionID);
    }
    return @SessionIDs;
}
# --
sub CleanUp {
    my $Self = shift;
    my %Param = @_;
    # delete fs files
    my @SessionIDs = $Self->GetAllSessionIDs();
    foreach (@SessionIDs) {
        if (!$Self->RemoveSessionID(SessionID => $_)) {
            return;
        }
    }
    return 1;
}
# --

1;
