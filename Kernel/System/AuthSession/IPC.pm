# --
# Kernel/System/AuthSession/IPC.pm - provides session IPC/Mem backend
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: IPC.pm,v 1.1 2002-08-03 11:52:53 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::AuthSession::IPC;

use strict;
use Digest::MD5;
use MIME::Base64;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;
 
# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # --
    # check needed objects
    # --
    foreach ('LogObject', 'ConfigObject', 'DBObject') {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }
    # --
    # Debug 0=off 1=on
    # --
    $Self->{Debug} = 0;    

    # --
    # get more common params
    # --
    $Self->{SystemID} = $Self->{ConfigObject}->Get('SystemID');
    # --
    # ipc stuff
    # --
    $Self->{IPCKey} = 444422; 
    $Self->{IPCSize} = 80*1024;

    $Self->InitSHM();

    return $Self;
}
# --
sub InitSHM {
    my $Self = shift;
    my %Param = @_;
    $Self->{Key} = shmget($Self->{IPCKey}, $Self->{IPCSize}, 0777 | 0001000) || die $!;
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
          Message => "SessionID: '$SessionID' is invalid!!!",
        );
        return;
    }
    # --
    # ip check
    # --
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
    # --
    # check session time
    # --
    my $MaxSessionTime = $Self->{ConfigObject}->Get('SessionMaxTime');
    if ( (time() - $MaxSessionTime) >= $Data{UserSessionStart} ) {
         $Kernel::System::AuthSession::CheckSessionID = "Session to old!";
         $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "SessionID ($SessionID) to old (". int((time() - $Data{UserSessionStart})/(60*60)) 
          ."h)! Don't grant access!!!",
        );
        # delete session id if to old?
        if ($Self->{ConfigObject}->Get('SessionDeleteIfTimeToOld')) {
            $Self->RemoveSessionID(SessionID => $SessionID);
        }
        return;
    }
    return 1;
}
# --
sub GetSessionIDData {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = $Param{SessionID} || '';
    my $String = '';
    my %Data;
    # --
    # check session id
    # -- 
    if (!$SessionID) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Got no SessionID!!");
        return;
    }

    # --
    # read data
    # --
    shmread($Self->{Key}, $String, 0, $Self->{IPCSize}) || die "$!";
    if (!$String) {
        return;
    }
    chomp $String;
    # --
    # split data
    # --
    my @Items = split(/\n/, $String);
    foreach my $Item (@Items) {
        my @PaarData = split(/:/, $Item);
        if ($PaarData[0] && $PaarData[1] && $PaarData[2]) {
            if ($PaarData[0] eq $SessionID) {
                $Data{$PaarData[1]} = decode_base64($PaarData[2]) || '';
                # Debug
                if ($Self->{Debug}) {
                  $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "GetSessionIDData: '$PaarData[1]:".decode_base64($PaarData[2])."'",
                  );
                }
            }
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
        if ($Param{$_}) {
            $Param{$_} = encode_base64($Param{$_});
            $DataToStore .= "$SessionID:$_:". $Param{$_} ."";
        }
    }
    $DataToStore .= "$SessionID:UserSessionStart:". encode_base64(time()) ."";
    $DataToStore .= "$SessionID:UserRemoteAddr:". encode_base64($RemoteAddr) ."";
    $DataToStore .= "$SessionID:UserRemoteUserAgent:". encode_base64($RemoteUserAgent) ."";
    # --
    # read old session data (the rest)
    # --
    my $String = '';
    shmread($Self->{Key}, $String, 0, $Self->{IPCSize}) || die "$!";
    chomp $String;
    # --
    # split data
    # --
    my @Items = split(/\n/, $String); 
    foreach my $Item (@Items) {
        my @PaarData = split(/:/, $Item);
        if ($PaarData[0] && $PaarData[1] && $PaarData[2]) {
            if ($PaarData[0] ne $SessionID) {
                $DataToStore .= $Item ."\n";
            }
        }
    }
    # --
    # store SessionID + data
    # --
    shmwrite($Self->{Key}, $DataToStore, 0, length($DataToStore)) || die $!; 

    return $SessionID;
}
# --
sub RemoveSessionID {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = $Param{SessionID};
    # --
    # read old session data (the rest)
    # --
    my $DataToStore = '';
    my $String = '';
    shmread($Self->{Key}, $String, 0, $Self->{IPCSize}) || die "$!";
    chomp $String;
    # --
    # split data
    # --
    my @Items = split(/\n/, $String); 
    foreach my $Item (@Items) {
        my @PaarData = split(/:/, $Item);
        if ($PaarData[0] && $PaarData[1] && $PaarData[2]) {
            if ($PaarData[0] ne $SessionID) {
                $DataToStore .= $Item ."\n";
            }
        }
    }
    # --
    # update shm
    # --
    shmwrite($Self->{Key}, $DataToStore, 0, $Self->{IPCSize}) || die $!;

    # log event
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message => "Removed SessionID $Param{SessionID}."
    );

    return 1;
}
# --
sub UpdateSessionID {
    my $Self = shift;
    my %Param = @_;
    my $Key = $Param{Key} || die 'No Key!';
    my $Value = $Param{Value} || '';
    my $SessionID = $Param{SessionID} || die 'No SessionID!';
    my %SessionData = $Self->GetSessionIDData(SessionID => $SessionID);
    # --
    # update the value 
    # --
    if ($Value) {
        $SessionData{$Key} = $Value; 
    }
    else {
        delete $SessionData{$Key};
    }
    # --
    # set new data sting
    # -- 
    my $NewDataToStore = '';
    foreach (keys %SessionData) {
        $SessionData{$_} = encode_base64($SessionData{$_});
        $NewDataToStore .= "$SessionID:$_:$SessionData{$_}";
        # Debug
        if ($Self->{Debug}) {
            $Self->{LogObject}->Log(
              Priority => 'debug',
              Message => "UpdateSessionID: $_=$SessionData{$_}",
            );
        }
    }
    # --
    # read old session data (the rest)
    # --
    my $String = '';
    shmread($Self->{Key}, $String, 0, $Self->{IPCSize}) || die "$!";
    chomp $String;
    # --
    # split data
    # --
    my @Items = split(/\n/, $String);
    foreach my $Item (@Items) {
        my @PaarData = split(/:/, $Item);
        if ($PaarData[0] && $PaarData[1] && $PaarData[2]) {
            if ($PaarData[0] ne $SessionID) {
                $NewDataToStore .= $Item ."\n";
            }
        }
    }
    # --
    # update shm
    # --
    shmwrite($Self->{Key}, $NewDataToStore, 0, $Self->{IPCSize}) || die $!;

    return 1;
}
# --
sub GetAllSessionIDs {
    my $Self = shift;
    my %Param = @_;
    my @SessionIDs = ();
    # --
    # read data
    # --
    my $String;
    shmread($Self->{Key}, $String, 0, $Self->{IPCSize}) || die "$!";
    if (!$String) {
        return;
    }
    chomp $String;
    # --
    # split data
    # --
    my %Sessions = ();
    my @Items = split(/\n/, $String);
    foreach my $Item (@Items) {
        my @PaarData = split(/:/, $Item);
        if ($PaarData[0] && $PaarData[1] && $PaarData[2]) {
            $Sessions{$PaarData[0]} = 1;
        }
    }
    foreach my $SessionID (keys %Sessions) {
       push (@SessionIDs, $SessionID);
    }
    return @SessionIDs;
}
# --

1;

