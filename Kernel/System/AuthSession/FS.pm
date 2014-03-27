# --
# Kernel/System/AuthSession/FS.pm - provides session filesystem backend
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: FS.pm,v 1.43 2010-06-28 08:17:00 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::AuthSession::FS;

use strict;
use warnings;
use Digest::MD5;
use MIME::Base64;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.43 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject ConfigObject DBObject TimeObject MainObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # get more common params
    $Self->{SessionSpool} = $Self->{ConfigObject}->Get('SessionDir');
    $Self->{SystemID}     = $Self->{ConfigObject}->Get('SystemID');

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    return $Self;
}

sub CheckSessionID {
    my ( $Self, %Param ) = @_;

    # check session id
    if ( !$Param{SessionID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Got no SessionID!!' );
        return;
    }
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'none';

    # set default message
    $Self->{CheckSessionIDMessage} = 'SessionID is invalid!!!';

    # session id check
    my %Data = $Self->GetSessionIDData( SessionID => $Param{SessionID} );

    if ( !$Data{UserID} || !$Data{UserLogin} ) {
        $Self->{CheckSessionIDMessage} = 'SessionID invalid! Need user data!';
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "SessionID: '$Param{SessionID}' is invalid!!!",
        );
        return;
    }

    # remote ip check
    if (
        $Data{UserRemoteAddr} ne $RemoteAddr
        && $Self->{ConfigObject}->Get('SessionCheckRemoteIP')
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "RemoteIP of '$Param{SessionID}' ($Data{UserRemoteAddr}) is "
                . "different with the request IP ($RemoteAddr). Don't grant access!!!"
                . " Disable config 'SessionCheckRemoteIP' if you don't want this!",
        );

        # delete session id if it isn't the same remote ip?
        if ( $Self->{ConfigObject}->Get('SessionDeleteIfNotRemoteID') ) {
            $Self->RemoveSessionID( SessionID => $Param{SessionID} );
        }
        return;
    }

    # check session idle time
    my $TimeNow            = $Self->{TimeObject}->SystemTime();
    my $MaxSessionIdleTime = $Self->{ConfigObject}->Get('SessionMaxIdleTime');
    if ( ( $TimeNow - $MaxSessionIdleTime ) >= $Data{UserLastRequest} ) {
        $Self->{CheckSessionIDMessage} = 'Session has timed out. Please log in again.';
        my $Timeout = int( ( $TimeNow - $Data{UserLastRequest} ) / ( 60 * 60 ) );
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message =>
                "SessionID ($Param{SessionID}) idle timeout ($Timeout h)! Don't grant access!!!",
        );

        # delete session id if too old?
        if ( $Self->{ConfigObject}->Get('SessionDeleteIfTimeToOld') ) {
            $Self->RemoveSessionID( SessionID => $Param{SessionID} );
        }
        return;
    }

    # check session time
    my $MaxSessionTime = $Self->{ConfigObject}->Get('SessionMaxTime');
    if ( ( $TimeNow - $MaxSessionTime ) >= $Data{UserSessionStart} ) {
        $Self->{CheckSessionIDMessage} = 'Session has timed out. Please log in again.';
        my $Timeout = int( ( $TimeNow - $Data{UserSessionStart} ) / ( 60 * 60 ) );
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "SessionID ($Param{SessionID}) too old ($Timeout h)! Don't grant access!!!",
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

    # check session id
    if ( !$Param{SessionID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Got no SessionID!!' );
        return;
    }

    # check cache
    if ( $Self->{Cache}->{ $Param{SessionID} } ) {
        return %{ $Self->{Cache}->{ $Param{SessionID} } };
    }

    # read data
    my $ContentRef = $Self->{MainObject}->FileRead(
        Directory => $Self->{SessionSpool},
        Filename  => $Param{SessionID},
        Mode      => 'utf8',                  # optional - binmode|utf8
        Result    => 'ARRAY',
    );
    if ( !$ContentRef ) {
        return;
    }
    my %Data;
    for my $Line ( @{$ContentRef} ) {
        chomp $Line;

        # split data
        my @PaarData = split( /:/, $Line );
        $Data{ $PaarData[0] } = ${ $Self->_Decode( \$PaarData[1] ) };

        # Debug
        if ( $Self->{Debug} ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "GetSessionIDData: '$PaarData[0]:$Data{ $PaarData[0] }'",
            );
        }
    }

    # cache result
    $Self->{Cache}->{ $Param{SessionID} } = \%Data;
    return %Data;
}

sub CreateSessionID {
    my ( $Self, %Param ) = @_;

    # REMOTE_ADDR
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'none';

    # HTTP_USER_AGENT
    my $RemoteUserAgent = $ENV{HTTP_USER_AGENT} || 'none';

    # create session id
    my $TimeNow = $Self->{TimeObject}->SystemTime();
    my $md5     = Digest::MD5->new();
    $md5->add(
        ( $TimeNow . int( rand(999999999) ) . $Self->{SystemID} ) . $RemoteAddr . $RemoteUserAgent
    );
    my $SessionID = $Self->{SystemID} . $md5->hexdigest;

    # create challenge token
    $md5 = Digest::MD5->new();
    $md5->add( $TimeNow . $SessionID );
    my $ChallengeToken = $md5->hexdigest;

    # data 2 strg
    my $DataToStore = '';
    for my $Key ( keys %Param ) {
        next if !defined $Param{$Key};
        $DataToStore .= $Self->_Encode( $Key, $Param{$Key} );
    }
    $DataToStore .= $Self->_Encode( 'UserSessionStart',    $TimeNow );
    $DataToStore .= $Self->_Encode( 'UserRemoteAddr',      $RemoteAddr );
    $DataToStore .= $Self->_Encode( 'UserRemoteUserAgent', $RemoteUserAgent );
    $DataToStore .= $Self->_Encode( 'UserChallengeToken',  $ChallengeToken );

    # store SessionID + data
    return $Self->{MainObject}->FileWrite(
        Directory => $Self->{SessionSpool},
        Filename  => $SessionID,
        Content   => \$DataToStore,
        Mode      => 'utf8',
    );
}

sub RemoveSessionID {
    my ( $Self, %Param ) = @_;

    # check session id
    if ( !$Param{SessionID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Got no SessionID!!' );
        return;
    }

    # delete fs file
    my $Delete = $Self->{MainObject}->FileDelete(
        Directory => $Self->{SessionSpool},
        Filename  => $Param{SessionID},
    );
    return if !$Delete;

    # reset cache
    delete $Self->{Cache}->{ $Param{SessionID} };

    # log event
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "Removed SessionID $Param{SessionID}."
    );
    return 1;
}

sub UpdateSessionID {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(SessionID Key)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check cache
    if ( !$Self->{Cache}->{ $Param{SessionID} } ) {
        my %SessionData = $Self->GetSessionIDData( SessionID => $Param{SessionID} );
    }

    # update the value, set cache
    $Self->{Cache}->{ $Param{SessionID} }->{ $Param{Key} } = $Param{Value};

    return 1;
}

sub GetAllSessionIDs {
    my ( $Self, %Param ) = @_;

    # read data
    my @List = $Self->{MainObject}->DirectoryRead(
        Directory => $Self->{SessionSpool},
        Filter    => "$Self->{SystemID}*",
    );

    my @SessionIDs;
    for my $SessionID (@List) {
        $SessionID =~ s!^.*/!!;
        push @SessionIDs, $SessionID;
    }
    return @SessionIDs;
}

sub CleanUp {
    my ( $Self, %Param ) = @_;

    # delete fs files
    my @SessionIDs = $Self->GetAllSessionIDs();
    for my $SessionID (@SessionIDs) {
        return if !$Self->RemoveSessionID( SessionID => $SessionID );
    }
    return 1;
}

sub _Encode {
    my ( $Self, $Key, $Value ) = @_;

    # set to bin string
    $Self->{EncodeObject}->EncodeOutput( \$Value );

    # encode data
    my $Data = "$Key:" . encode_base64( $Value, '' ) . "\n";
    return $Data;
}

sub _Decode {
    my ( $Self, $Value ) = @_;

    # check empty case
    my $Empty = '';
    return \$Empty if ( !defined ${$Value} || ${$Value} eq '' );

    # decode and return
    ${$Value} = decode_base64( ${$Value} );
    $Self->{EncodeObject}->EncodeInput($Value);
    return $Value;
}

sub _SyncToStorage {
    my ( $Self, %Param ) = @_;

    return 1 if !$Self->{Cache};

    for my $SessionID ( keys %{ $Self->{Cache} } ) {
        my %SessionData = %{ $Self->{Cache}->{$SessionID} };

        # set new data sting
        my $Data = '';
        for my $Key ( keys %SessionData ) {
            next if !defined $SessionData{$Key};
            $Data .= $Self->_Encode( $Key, $SessionData{$Key} );

            # Debug
            if ( $Self->{Debug} ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "UpdateSessionID: $Key=$SessionData{$Key}",
                );
            }
        }

        # store SessionID + data
        return $Self->{MainObject}->FileWrite(
            Directory => $Self->{SessionSpool},
            Filename  => $SessionID,
            Content   => \$Data,
            Mode      => 'utf8',
        );
    }
    return 1;
}

sub DESTROY {
    my ( $Self, %Param ) = @_;

    $Self->_SyncToStorage();

    return 1;
}

1;
