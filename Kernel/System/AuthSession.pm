# --
# AuthSession.pm - provides session check and session data
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AuthSession.pm,v 1.7 2002-01-23 23:02:59 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::AuthSession; 

use strict;
use Digest::MD5;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;
 
# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # get log object
    $Self->{LogObject} = $Param{LogObject} || die 'No LogObject!';

    # get config data
    $Self->{ConfigObject} = $Param{ConfigObject} || die 'No ConfigObject!'; 

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

    # --
    # set default message
    # --
    $Kernel::System::AuthSession::CheckSessionID = "SessionID is invalid!!!";

    # --
    # session id check
    # --
    my %Data = $Self->GetSessionIDData(SessionID => $SessionID); 

    if (!$Data{UserID} || !$Data{UserLogin}) {
        $Kernel::System::AuthSession::CheckSessionID = "SessionID invalid! Need user data!";
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "SessionID: '$SessionID' is invalid!!!",
        );
        return;
    }
    # --
    # ip check
    # --
    if ($Data{UserRemoteAddr} ne $RemoteAddr) {
        $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "RemoteIP of '$SessionID' ($Data{UserRemoteAddr}) is different with the ".
           "request IP ($RemoteAddr). Don't grant access!!!",
        );
        return;
    }
    # --
    # check session time
    # --
    my $MaxSessionTime = $Self->{ConfigObject}->Get('MaxSessionTime');
    if ( (time() - $MaxSessionTime) >= $Data{UserSessionStart} ) {
         $Kernel::System::AuthSession::CheckSessionID = "Session to old!";
         $Self->{LogObject}->Log(
          Priority => 'notice',
          MSG => "SessionID ($SessionID) to old (". int((time() - $Data{UserSessionStart})/(60*60)) 
          ."h)! Don't grant access!!!",
        );
        return;
    }
    return 1;
}
# --
sub GetSessionIDData {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = $Param{SessionID} || die 'Got no SessionID!';
    my $Strg = '';
    my %Data;

    # --
    # FIXME!
    # read data
    # --
    open (SESSION, "< $Self->{SessionSpool}/$SessionID") 
        || print STDERR "Can't open $Self->{SessionSpool}/$SessionID: $!\n";
    while (<SESSION>) {
        chomp;
        $Strg = $_;
    }
    close (SESSION);

    # --
    # split data
    # --
    my @StrgData = split(/;/, $Strg); 
    foreach (@StrgData) {
         my @PaarData = split(/=/, $_);
         $Data{$PaarData[0]} = $PaarData[1] || '';
         # Debug
         if ($Self->{Debug}) {
             $Self->{LogObject}->Log(
                Priority => 'debug',
                MSG => "GetSessionIDData: '$PaarData[0]=$PaarData[1]'",
             );
         } 
    }

    return %Data;
}
# --
sub CreateSessionID {
    my $Self = shift;
    my %Param = @_;
    # --
    # REMOTE_ADDR
    # --
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'none';
    # --
    # REMOTE_USER_AGENT
    # --
    my $RemoteUserAgent = $ENV{REMOTE_USER_AGENT} || 'none';
    # --
    # create SessionID
    # --
    my $md5 = Digest::MD5->new();
    my $SessionID = $md5->add(
        (time() . int(rand(999999999)) . $Self->{SystemID}) . $RemoteAddr . $RemoteUserAgent
    );
    $SessionID = $Self->{SystemID} . $md5->hexdigest;

    # --
    # store SessionID + data
    # FIXME!
    # --
    open (SESSION, ">> $Self->{SessionSpool}/$SessionID") 
        || die "Can't create $Self->{SessionSpool}/$SessionID: $!"; 
    foreach (keys %Param) {
        print SESSION "$_=$Param{$_};";
    }
    print SESSION "UserSessionStart=" . time() . ";";
    print SESSION "UserRemoteAddr=" . $RemoteAddr . ";\n";
    close (SESSION);

    return $SessionID;
}
# --
sub RemoveSessionID {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = $Param{SessionID};

    # FIXME!
    system ("rm $Self->{SessionSpool}/$SessionID");

    return 1;
}
# --
sub UpdateSessionID {
    my $Self = shift;
    my %Param = @_;
    my $Key = $Param{Key} || die 'No Key!';
    my $Value = $Param{Value} || die 'No Value!';
    my $SessionID = $Param{SessionID} || die 'No SessionID!';

    my %SessionData = $Self->GetSessionIDData(SessionID => $SessionID);

    # update the value 
    $SessionData{$Key} = $Value; 
    
    open (SESSION, "> $Self->{SessionSpool}/$SessionID") 
         || die "Can't write $Self->{SessionSpool}/$SessionID: $!";
    foreach (keys %SessionData) {
        print SESSION "$_=$SessionData{$_};";
        # Debug
        if ($Self->{Debug}) {
            print STDERR "UpdateSessionID: $_=$SessionData{$_}\n";
        }

    }
    close (SESSION);

    return 1;
}
# --

1;


