# --
# AuthSession.pm - provides session check and session data
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AuthSession.pm,v 1.9 2002-04-08 13:38:12 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::AuthSession; 

use strict;
use Digest::MD5;

use vars qw($VERSION);
$VERSION = '$Revision: 1.9 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;
 
# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # check needed objects
    foreach ('LogObject', 'ConfigObject', 'DBObject') {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # get more common params
    $Self->{SessionSpool} = $Self->{ConfigObject}->Get('SessionDir');
    $Self->{SystemID} = $Self->{ConfigObject}->Get('SystemID');
 
    # Debug 0=off 1=on
    $Self->{Debug} = 0;    

    # session table data
    $Self->{SQLSessionTable} = $Self->{ConfigObject}->Get('DatabaseSessionTable') 
     || 'session';
    # id row
    $Self->{SQLSessionTableID} = $Self->{ConfigObject}->Get('DatabaseSessionTableID') 
     || 'session_id';
    # value row
    $Self->{SQLSessionTableValue} = $Self->{ConfigObject}->Get('DatabaseSessionTableValue') 
     || 'value';

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
    if ( $Data{UserRemoteAddr} ne $RemoteAddr && 
          $Self->{ConfigObject}->Get('CheckRemoteIP') ) {
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
    # read data
    # --
    if ($Self->{ConfigObject}->Get('SessionDriver') eq 'sql') {
        # --
        # db driver
        # --
        my $SQL = "SELECT $Self->{SQLSessionTableValue} ".
          " FROM ".
          " $Self->{SQLSessionTable} ".
          " WHERE ".
          " $Self->{SQLSessionTableID} = '$SessionID'";
        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
             $Strg = $RowTmp[0];
        } 
    }
    elsif ($Self->{ConfigObject}->Get('SessionDriver') eq 'fs') {
        # --
        # fs driver
        # --
        open (SESSION, "< $Self->{SessionSpool}/$SessionID") 
            || die "Can't open $Self->{SessionSpool}/$SessionID: $!\n";
        while (<SESSION>) {
            chomp;
            $Strg = $_;
        }
        close (SESSION);
    }
    else {
        # --
        # else!? Panic!
        # --
        die "Unknown SessionDriver (".$Self->{ConfigObject}->Get('SessionDriver').")!"; 
    }

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
    # data 2 strg
    # --
    my $DataToStore = '';
    foreach (keys %Param) {
        $DataToStore .= "$_=$Param{$_};";
    }
    $DataToStore .= "UserSessionStart=" . time() . ";";
    $DataToStore .= "UserRemoteAddr=" . $RemoteAddr . ";";
    $DataToStore .= "UserRemoteUserAgent=". $RemoteUserAgent . ";";

    # --
    # store SessionID + data
    # --
    if ($Self->{ConfigObject}->Get('SessionDriver') eq 'sql') {
        # --
        # db driver
        # --
        my $SQL = "INSERT INTO $Self->{SQLSessionTable} ".
           " ($Self->{SQLSessionTableID}, $Self->{SQLSessionTableValue}) ".
           " VALUES ".
           " ('$SessionID', '$DataToStore')";
        $Self->{DBObject}->Do(SQL => $SQL) || die "Can't insert session id!";
    }
    elsif ($Self->{ConfigObject}->Get('SessionDriver') eq 'fs') {
        # --
        # fs driver
        # FIXME!
        # --
        open (SESSION, ">> $Self->{SessionSpool}/$SessionID") 
            || die "Can't create $Self->{SessionSpool}/$SessionID: $!"; 
        print SESSION "$DataToStore\n";
        close (SESSION);
    }
    else {
        # --
        # else!? Panic!
        # --
        die "Unknown SessionDriver (".$Self->{ConfigObject}->Get('SessionDriver').")!";
    }

    return $SessionID;
}
# --
sub RemoveSessionID {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = $Param{SessionID};

    if ($Self->{ConfigObject}->Get('SessionDriver') eq 'sql') {
        # --
        # delete db recode
        # -- 
        $Self->{DBObject}->Do(
         SQL => "DELETE FROM $Self->{SQLSessionTable} ".
                " WHERE $Self->{SQLSessionTableID} = '$SessionID'"
        ) 
          || return 0; 
    }
    elsif ($Self->{ConfigObject}->Get('SessionDriver') eq 'fs') {
        # --
        # delete fs file
        # FIXME!
        # --
        system ("rm $Self->{SessionSpool}/$SessionID") 
           || return 0;
    }
    else {
        # --
        # else!? Panic!
        # --
        die "Unknown SessionDriver (".$Self->{ConfigObject}->Get('SessionDriver').")!";
    }

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

    # --
    # update the value 
    # --
    $SessionData{$Key} = $Value; 
   
    # --
    # set new data sting
    # -- 
    my $NewDataToStore = '';
    foreach (keys %SessionData) {
        $NewDataToStore .= "$_=$SessionData{$_};";
        # Debug
        if ($Self->{Debug}) {
            $Self->{LogObject}->Log(
              Priority => 'debug',
              MSG => "UpdateSessionID: $_=$SessionData{$_}",
            );
        }
    }

    if ($Self->{ConfigObject}->Get('SessionDriver') eq 'sql') {
        # --
        # update db enrty
        # --
        my $SQL = "UPDATE $Self->{SQLSessionTable} ".
            " SET ".
            " $Self->{SQLSessionTableValue} = '$NewDataToStore' ".
            " WHERE ".
            " $Self->{SQLSessionTableID} = '$SessionID'";
        $Self->{DBObject}->Do(SQL => $SQL) 
           || die "Can't update session table!";
    }
    elsif ($Self->{ConfigObject}->Get('SessionDriver') eq 'fs') {
        # --
        # update fs file
        # --
        open (SESSION, "> $Self->{SessionSpool}/$SessionID")
         || die "Can't write $Self->{SessionSpool}/$SessionID: $!";
        print SESSION "$NewDataToStore";
        close (SESSION);
    }
    else {
        # --
        # else!? Panic!
        # --
        die "Unknown SessionDriver (".$Self->{ConfigObject}->Get('SessionDriver').")!";
    }

    return 1;
}
# --

1;


