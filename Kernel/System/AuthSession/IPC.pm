# --
# Kernel/System/AuthSession/IPC.pm - provides session IPC/Mem backend
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: IPC.pm,v 1.11.2.1 2003-05-01 21:46:16 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::AuthSession::IPC;

use strict;
use IPC::SysV qw(IPC_PRIVATE IPC_RMID S_IRWXU);
use Digest::MD5;
use MIME::Base64;

use vars qw($VERSION);
$VERSION = '$Revision: 1.11.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;
 
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
    foreach (qw(LogObject ConfigObject DBObject)) {
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
    $Self->{IPCKeyMeta} = "444421$Self->{SystemID}"; 
    $Self->{IPCSizeMeta} = 20;
    $Self->{IPCKey} = "444422$Self->{SystemID}"; 
    $Self->{IPCAddBufferSize} = 4*1024;
    $Self->{IPCSize} = 80*1024;
    $Self->{IPCSizeMax} = (180*1024) - $Self->{IPCAddBufferSize};
    $Self->{CMD} = $Param{CMD} || 0;
    $Self->InitSHM();

    return $Self;
}
# --
sub InitSHM {
    my $Self = shift;
    # init meta data mem
    $Self->{KeyMeta} = shmget($Self->{IPCKeyMeta}, $Self->{IPCSizeMeta}, 0777 | 0001000) || die $!;
    # init session data mem
    $Self->{Key} = shmget($Self->{IPCKey}, $Self->GetSHMDataSize(), 0777 | 0001000) || die $!;
}
# --
sub WriteSHM {
    my $Self = shift;
    my %Param = @_;
    # get size of data
    my $DataSize = (length($Param{Data})+1);
    my $AddBuffer = 4000;
    my $CurrentDataSize = $Self->GetSHMDataSize();
    # overwrite with new session data
    if ($Self->{CMD} || $DataSize < $CurrentDataSize || $DataSize > $Self->{IPCSizeMax}) {
        shmwrite($Self->{Key}, $Param{Data}, 0, $CurrentDataSize) || die $!;
        if ($DataSize > $Self->{IPCSizeMax}) {
            $Self->{LogObject}->Log(
              Priority => 'error',
              Message => "Can't write session data. Max. size ".
                "($Self->{IPCSizeMax} Bytes) of SessionData reached! Drop old sessions!",
            );
        }
    }
    else {
        my $NewIPCSize = $DataSize + $Self->{IPCAddBufferSize};
        if ($NewIPCSize > $Self->{IPCSizeMax}) {
            $NewIPCSize = $Self->{IPCSizeMax};
        } 
        # delete old shm
        shmctl($Self->{Key}, IPC_RMID, 0) || die "$!";
        # init new mem
        $Self->{Key} = shmget($Self->{IPCKey}, $NewIPCSize, 0777 | 0001000) || die $!;
        # write session data to mem
        shmwrite($Self->{Key}, $Param{Data}, 0, $NewIPCSize) || die $!;
        # write new meta data
        $Self->SetSHMDataSize($NewIPCSize);
    }
}
# --
sub ReadSHM {
    my $Self = shift;
    # read session data from mem
    my $String = '';
    shmread($Self->{Key}, $String, 0, $Self->GetSHMDataSize()) || die "$!";
    my @Lines = split(/\n/, $String);
    $String = '';
    foreach (@Lines) {
        if ($_ =~ /^SessionID/) {
            $String .= $_."\n";
        }
    }
    return $String;
}
# --
sub SetSHMDataSize {
    my $Self = shift;
    my $Size = shift || return;
    # read meta data from mem
    shmwrite($Self->{KeyMeta}, $Size.";", 0, $Self->{IPCSizeMeta}) || die $!;
    return 1;
}
# --
sub GetSHMDataSize {
    my $Self = shift;
    # read meta data from mem
    my $MetaString = '';
    shmread($Self->{KeyMeta}, $MetaString, 0, $Self->{IPCSizeMeta}) || die "$!";
    my @Items = split(/;/, $MetaString);
    if ($MetaString !~ /;/) {
        $Items[0] = $Self->{IPCSize};
    }
    return $Items[0];
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
         $Kernel::System::AuthSession::CheckSessionID = 'Session has timed out. Please log in again.';
         $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "SessionID ($SessionID) too old (". int((time() - $Data{UserSessionStart})/(60*60)) 
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
sub GetSessionIDData {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = $Param{SessionID} || '';
    my $SessionIDBase64 = encode_base64($SessionID, '');
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
    my $String = $Self->ReadSHM();
    if (!$String) {
        return;
    }
    # --
    # split data
    # --
    my @Items = split(/\n/, $String);
    foreach my $Item (@Items) {
        my @PaarData = split(/;/, $Item);
        if ($PaarData[0]) {
            if ($Item =~ /^SessionID:$SessionIDBase64;/) {
                foreach (@PaarData) {
                    my ($Key, $Value) = split(/:/, $_);
                    $Data{$Key} = decode_base64($Value); 
                }
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
    # HTTP_USER_AGENT
    # --
    my $RemoteUserAgent = $ENV{HTTP_USER_AGENT} || 'none';
    # --
    # create SessionID
    # --
    my $md5 = Digest::MD5->new();
    my $SessionID = $md5->add(
        (time() . int(rand(999999999)) . $Self->{SystemID}) . $RemoteAddr . $RemoteUserAgent
    );
    $SessionID = $Self->{SystemID} . $md5->hexdigest;
    my $SessionIDBase64 = encode_base64($SessionID, '');
    # --
    # data 2 strg
    # --
    my $DataToStore = "SessionID:". encode_base64($SessionID, '') .";";
    foreach (keys %Param) {
        if (defined($Param{$_})) {
            $Param{$_} = encode_base64($Param{$_}, '');
            $DataToStore .= "$_:". $Param{$_} .";";
        }
    }
    $DataToStore .= "UserSessionStart:". encode_base64(time(), '') .";";
    $DataToStore .= "UserRemoteAddr:". encode_base64($RemoteAddr, '') .";";
    $DataToStore .= "UserRemoteUserAgent:". encode_base64($RemoteUserAgent, '') .";\n";
    # --
    # read old session data (the rest)
    # --
    my $String = $Self->ReadSHM();
    # --
    # split data
    # --
    my @Items = split(/\n/, $String); 
    foreach my $Item (@Items) {
        if ($Item !~ /^SessionID:$SessionIDBase64;/) {
            $DataToStore .= $Item ."\n";
        }
    }
    # --
    # store SessionID + data
    # --
    $Self->WriteSHM(Data => $DataToStore);
    return $SessionID;
}
# --
sub RemoveSessionID {
    my $Self = shift;
    my %Param = @_;
    my $SessionID = $Param{SessionID};
    my $SessionIDBase64 = encode_base64($SessionID, '');
    # --
    # read old session data (the rest)
    # --
    my $DataToStore = '';
    my $String = $Self->ReadSHM();
    # --
    # split data
    # --
    my @Items = split(/\n/, $String); 
    foreach my $Item (@Items) {
        if ($Item !~ /^SessionID:$SessionIDBase64;/) {
            $DataToStore .= $Item ."\n";
        }
    }
    # --
    # update shm
    # --
    $Self->WriteSHM(Data => $DataToStore);
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
    my $Value = defined($Param{Value}) ? $Param{Value} : '';
    my $SessionID = $Param{SessionID} || die 'No SessionID!';
    my %SessionData = $Self->GetSessionIDData(SessionID => $SessionID);
    # --
    # check needed update! (no changes)
    # --
    if (((exists $SessionData{$Key}) && $SessionData{$Key} eq $Value) 
      || (!exists $SessionData{$Key} && $Value eq '')) {
        return 1;
    }
    # --
    # update the value 
    # --
    if (defined($Value)) {
        $SessionData{$Key} = $Value; 
    }
    else {
        delete $SessionData{$Key};
    }
    # --
    # set new data sting
    # -- 
    my $NewDataToStore = "SessionID:". encode_base64($SessionID, '').";";
    foreach (keys %SessionData) {
        $SessionData{$_} = encode_base64($SessionData{$_}, '');
        $NewDataToStore .= "$_:$SessionData{$_};";
        chomp ($SessionData{$_});
        # Debug
        if ($Self->{Debug}) {
            $Self->{LogObject}->Log(
              Priority => 'debug',
              Message => "UpdateSessionID: $_=$SessionData{$_}",
            );
        }
    }
    $NewDataToStore .= "\n";
    # --
    # read old session data (the rest)
    # --
    my $String = $Self->ReadSHM();
    # --
    # split data
    # --
    my @Items = split(/\n/, $String); 
    foreach my $Item (@Items) {
        my $SessionIDBase64 = encode_base64($SessionID, '');
        if ($Item !~ /^SessionID:$SessionIDBase64;/) {
            $NewDataToStore .= $Item ."\n";
        }
    }
    # --
    # update shm
    # --
    $Self->WriteSHM(Data => $NewDataToStore);

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
    my $String = $Self->ReadSHM();
    if (!$String) {
        return;
    }
    # --
    # split data
    # --
    my @Items = split(/\n/, $String);
    foreach my $Item (@Items) {
        my @PaarData = split(/;/, $Item);
        if ($PaarData[0]) {
            my ($Key, $Value) = split(/:/, $PaarData[0]);
            if ($Value) {
                my $SessionID = decode_base64($Value);
                push (@SessionIDs, $SessionID);
            }
        }
    }
    return @SessionIDs;
}
# --

1;
