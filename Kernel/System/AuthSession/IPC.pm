# --
# Kernel/System/AuthSession/IPC.pm - provides session IPC/Mem backend
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: IPC.pm,v 1.30 2007-10-05 11:22:37 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::AuthSession::IPC;

use strict;
use warnings;

use IPC::SysV qw(IPC_PRIVATE IPC_RMID S_IRWXU);
use Digest::MD5;
use MIME::Base64;
use Kernel::System::Encode;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.30 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject ConfigObject DBObject TimeObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    # encode object
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);

    # get more common params
    $Self->{SystemID} = $Self->{ConfigObject}->Get('SystemID');

    # ipc stuff
    $Self->{IPCKeyMeta}       = "444421$Self->{SystemID}";
    $Self->{IPCSizeMeta}      = 20;
    $Self->{IPCKey}           = "444422$Self->{SystemID}";
    $Self->{IPCAddBufferSize} = 10 * 1024;
    $Self->{IPCSize}          = 80 * 1024;
    $Self->{IPCSizeMax}       = ( 2048 * 1024 ) - $Self->{IPCAddBufferSize};
    $Self->{CMD}              = $Param{CMD} || 0;
    $Self->_InitSHM();

    return $Self;
}

sub _InitSHM {
    my ($Self) = @_;

    # init meta data mem
    $Self->{KeyMeta} = shmget( $Self->{IPCKeyMeta}, $Self->{IPCSizeMeta}, oct(1777) ) || die $!;

    # init session data mem
    $Self->{Key} = shmget( $Self->{IPCKey}, $Self->_GetSHMDataSize(), oct(1777) ) || die $!;
    return 1;
}

sub _WriteSHM {
    my ( $Self, %Param ) = @_;

    # get size of data
    my $DataSize        = ( length( $Param{Data} ) + 1 );
    my $AddBuffer       = 4000;
    my $CurrentDataSize = $Self->_GetSHMDataSize();

    # overwrite with new session data
    if ( $Self->{CMD} || $DataSize < $CurrentDataSize || $DataSize > $Self->{IPCSizeMax} ) {
        shmwrite( $Self->{Key}, $Param{Data}, 0, $CurrentDataSize ) || die $!;
        if ( $DataSize > $Self->{IPCSizeMax} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't write session data. Max. size "
                    . "($Self->{IPCSizeMax} Bytes) of SessionData reached! Drop old sessions!",
            );
        }
        return;
    }
    else {
        my $NewIPCSize = $DataSize + $Self->{IPCAddBufferSize};
        if ( $NewIPCSize > $Self->{IPCSizeMax} ) {
            $NewIPCSize = $Self->{IPCSizeMax};
        }

        # delete old shm
        shmctl( $Self->{Key}, IPC_RMID, 0 ) || die "$!";

        # init new mem
        $Self->{Key} = shmget( $Self->{IPCKey}, $NewIPCSize, oct(1777) ) || die $!;

        # write session data to mem
        shmwrite( $Self->{Key}, $Param{Data}, 0, $NewIPCSize ) || die $!;

        # write new meta data
        $Self->_SetSHMDataSize($NewIPCSize);
        return 1;
    }
}

sub _ReadSHM {
    my ($Self) = @_;

    # read session data from mem
    my $String = '';
    shmread( $Self->{Key}, $String, 0, $Self->_GetSHMDataSize() ) || die "$!";
    my @Lines = split( /\n/, $String );
    $String = '';
    for (@Lines) {
        if ( $_ =~ /^SessionID/ ) {
            $String .= $_ . "\n";
        }
    }
    return $String;
}

sub _SetSHMDataSize {
    my ( $Self, $Size ) = @_;
    if ( !$Size ) {
        return;
    }

    # read meta data from mem
    shmwrite( $Self->{KeyMeta}, $Size . ";", 0, $Self->{IPCSizeMeta} ) || die $!;
    return 1;
}

sub _GetSHMDataSize {
    my ($Self) = @_;

    # read meta data from mem
    my $MetaString = '';
    shmread( $Self->{KeyMeta}, $MetaString, 0, $Self->{IPCSizeMeta} ) || die "$!";
    my @Items = split( /;/, $MetaString );
    if ( $MetaString !~ /;/ ) {
        $Items[0] = $Self->{IPCSize};
    }
    return $Items[0];
}

sub CheckSessionID {
    my ( $Self, %Param ) = @_;

    # check session id
    if ( !$Param{SessionID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Got no SessionID!!" );
        return;
    }
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'none';

    # set default message
    $Self->{CheckSessionIDMessage} = "SessionID is invalid!!!";

    # session id check
    my %Data = $Self->GetSessionIDData( SessionID => $Param{SessionID} );

    if ( !$Data{UserID} || !$Data{UserLogin} ) {
        $Self->{CheckSessionIDMessage} = "SessionID invalid! Need user data!";
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "SessionID: '$Param{SessionID}' is invalid!!!",
        );
        return;
    }

    # remote ip check
    if (   $Data{UserRemoteAddr} ne $RemoteAddr
        && $Self->{ConfigObject}->Get('SessionCheckRemoteIP') )
    {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "RemoteIP of '$Param{SessionID}' ($Data{UserRemoteAddr}) is "
                . "different with the request IP ($RemoteAddr). Don't grant access!!!",
        );

        # delete session id if it isn't the same remote ip?
        if ( $Self->{ConfigObject}->Get('SessionDeleteIfNotRemoteID') ) {
            $Self->RemoveSessionID( SessionID => $Param{SessionID} );
        }
        return;
    }

    # check session idle time
    my $MaxSessionIdleTime = $Self->{ConfigObject}->Get('SessionMaxIdleTime');
    if ( ( $Self->{TimeObject}->SystemTime() - $MaxSessionIdleTime ) >= $Data{UserLastRequest} ) {
        $Self->{CheckSessionIDMessage} = 'Session has timed out. Please log in again.';
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "SessionID ($Param{SessionID}) idle timeout ("
                . int(
                ( $Self->{TimeObject}->SystemTime() - $Data{UserLastRequest} ) / ( 60 * 60 ) )
                . "h)! Don't grant access!!!",
        );

        # delete session id if too old?
        if ( $Self->{ConfigObject}->Get('SessionDeleteIfTimeToOld') ) {
            $Self->RemoveSessionID( SessionID => $Param{SessionID} );
        }
        return;
    }

    # check session time
    my $MaxSessionTime = $Self->{ConfigObject}->Get('SessionMaxTime');
    if ( ( $Self->{TimeObject}->SystemTime() - $MaxSessionTime ) >= $Data{UserSessionStart} ) {
        $Self->{CheckSessionIDMessage} = 'Session has timed out. Please log in again.';
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "SessionID ($Param{SessionID}) too old ("
                . int(
                ( $Self->{TimeObject}->SystemTime() - $Data{UserSessionStart} ) / ( 60 * 60 )
                )
                . "h)! Don't grant access!!!",
        );

        # delete session id if too old?
        if ( $Self->{ConfigObject}->Get('SessionDeleteIfTimeToOld') ) {
            $Self->RemoveSessionID( SessionID => $Param{SessionID} );
        }
        return;
    }
    return 1;
}

sub CheckSessionIDMessage {
    my ( $Self, %Param ) = @_;

    return $Self->{CheckSessionIDMessage} || '';
}

sub GetSessionIDData {
    my ( $Self, %Param ) = @_;

    my %Data;

    # check session id
    if ( !$Param{SessionID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Got no SessionID!!" );
        return;
    }

    # check cache
    if ( $Self->{"Cache::$Param{SessionID}"} ) {
        return %{ $Self->{"Cache::$Param{SessionID}"} };
    }
    my $SessionIDBase64 = encode_base64( $Param{SessionID}, '' );

    # read data
    my $String = $Self->_ReadSHM();
    if ( !$String ) {
        return;
    }

    # split data
    my @Items = split( /\n/, $String );
    for my $Item (@Items) {
        my @PaarData = split( /;/, $Item );
        if ( $PaarData[0] ) {
            if ( $Item =~ /^SessionID:$SessionIDBase64;/ ) {
                for (@PaarData) {
                    my ( $Key, $Value ) = split( /:/, $_ );
                    $Data{$Key} = decode_base64($Value);
                    $Self->{EncodeObject}->Encode( \$Data{$Key} );
                }

                # Debug
                if ( $Self->{Debug} ) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message  => "GetSessionIDData: '$PaarData[1]:"
                            . decode_base64( $PaarData[2] ) . "'",
                    );
                }
            }
        }
    }

    # cache result
    $Self->{"Cache::$Param{SessionID}"} = \%Data;
    return %Data;
}

sub CreateSessionID {
    my ( $Self, %Param ) = @_;

    # get REMOTE_ADDR
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'none';

    # get HTTP_USER_AGENT
    my $RemoteUserAgent = $ENV{HTTP_USER_AGENT} || 'none';

    # create SessionID
    my $md5 = Digest::MD5->new();
    $md5->add( ( $Self->{TimeObject}->SystemTime() . int( rand(999999999) ) . $Self->{SystemID} )
        . $RemoteAddr
            . $RemoteUserAgent );
    my $SessionID = $Self->{SystemID} . $md5->hexdigest;
    my $SessionIDBase64 = encode_base64( $SessionID, '' );

    # data 2 strg
    my $DataToStore = "SessionID:" . encode_base64( $SessionID, '' ) . ";";
    for ( keys %Param ) {
        if ( defined( $Param{$_} ) ) {
            $Self->{EncodeObject}->EncodeOutput( \$Param{$_} );
            $DataToStore .= "$_:" . encode_base64( $Param{$_}, '' ) . ";";
        }
    }
    $DataToStore
        .= "UserSessionStart:" . encode_base64( $Self->{TimeObject}->SystemTime(), '' ) . ";";
    $DataToStore .= "UserRemoteAddr:" . encode_base64( $RemoteAddr,           '' ) . ";";
    $DataToStore .= "UserRemoteUserAgent:" . encode_base64( $RemoteUserAgent, '' ) . ";\n";

    # read old session data (the rest)
    my $String = $Self->_ReadSHM();

    # split data
    my @Items = split( /\n/, $String );
    for my $Item (@Items) {
        if ( $Item !~ /^SessionID:$SessionIDBase64;/ ) {
            $DataToStore .= $Item . "\n";
        }
    }

    # store SessionID + data
    $Self->_WriteSHM( Data => $DataToStore );
    return $SessionID;
}

sub RemoveSessionID {
    my ( $Self, %Param ) = @_;

    # check session id
    if ( !$Param{SessionID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Got no SessionID!!" );
        return;
    }
    my $SessionIDBase64 = encode_base64( $Param{SessionID}, '' );

    # read old session data (the rest)
    my $DataToStore = '';
    my $String      = $Self->_ReadSHM();

    # split data
    my @Items = split( /\n/, $String );
    for my $Item (@Items) {
        if ( $Item !~ /^SessionID:$SessionIDBase64;/ ) {
            $DataToStore .= $Item . "\n";
        }
    }

    # update shm
    $Self->_WriteSHM( Data => $DataToStore );

    # reset cache
    if ( $Self->{"Cache::$Param{SessionID}"} ) {
        delete( $Self->{"Cache::$Param{SessionID}"} );
    }

    # log event
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "Removed SessionID $Param{SessionID}."
    );
    return 1;
}

sub UpdateSessionID {
    my ( $Self, %Param ) = @_;

    # check session id
    if ( !$Param{SessionID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Got no SessionID!!" );
        return;
    }
    my $Key   = defined( $Param{Key} )   ? $Param{Key}   : '';
    my $Value = defined( $Param{Value} ) ? $Param{Value} : '';
    my %SessionData = $Self->GetSessionIDData( SessionID => $Param{SessionID} );

    # check needed update! (no changes)
    if (   ( ( exists $SessionData{$Key} ) && $SessionData{$Key} eq $Value )
        || ( !exists $SessionData{$Key} && $Value eq '' ) )
    {
        return 1;
    }

    # update the value
    if ( defined($Value) ) {
        $SessionData{$Key} = $Value;
    }
    else {
        delete $SessionData{$Key};
    }

    # set new data sting
    my $NewDataToStore = "SessionID:" . encode_base64( $Param{SessionID}, '' ) . ";";
    for ( keys %SessionData ) {
        $Self->{EncodeObject}->EncodeOutput( \$SessionData{$_} );
        $SessionData{$_} = encode_base64( $SessionData{$_}, '' );
        $NewDataToStore .= "$_:$SessionData{$_};";
        chomp( $SessionData{$_} );

        # Debug
        if ( $Self->{Debug} ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "UpdateSessionID: $_=$SessionData{$_}",
            );
        }
    }
    $NewDataToStore .= "\n";

    # read old session data (the rest)
    my $String = $Self->_ReadSHM();

    # split data
    my @Items = split( /\n/, $String );
    for my $Item (@Items) {
        my $SessionIDBase64 = encode_base64( $Param{SessionID}, '' );
        if ( $Item !~ /^SessionID:$SessionIDBase64;/ ) {
            $NewDataToStore .= $Item . "\n";
        }
    }

    # update shm
    $Self->_WriteSHM( Data => $NewDataToStore );

    # reset cache
    if ( $Self->{"Cache::$Param{SessionID}"} ) {
        delete( $Self->{"Cache::$Param{SessionID}"} );
    }
    return 1;
}

sub GetAllSessionIDs {
    my ( $Self, %Param ) = @_;

    my @SessionIDs = ();

    # read data
    my $String = $Self->_ReadSHM();
    if ( !$String ) {
        return;
    }

    # split data
    my @Items = split( /\n/, $String );
    for my $Item (@Items) {
        my @PaarData = split( /;/, $Item );
        if ( $PaarData[0] ) {
            my ( $Key, $Value ) = split( /:/, $PaarData[0] );
            if ($Value) {
                my $SessionID = decode_base64($Value);
                push( @SessionIDs, $SessionID );
            }
        }
    }
    return @SessionIDs;
}

sub CleanUp {
    my ($Self) = @_;

    # remove ipc meta data mem
    if ( !shmctl( $Self->{KeyMeta}, IPC_RMID, 0 ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't remove shm for session meta data: $!",
        );
        return;
    }

    # remove ipc session data mem
    if ( !shmctl( $Self->{Key}, IPC_RMID, 0 ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't remove shm for session data: $!",
        );
        return;
    }
    return 1;
}

1;
