# --
# Kernel/System/AuthSession/FS.pm - provides session filesystem backend
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: FS.pm,v 1.27 2007-10-02 10:35:44 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::AuthSession::FS;

use strict;
use warnings;
use Digest::MD5;
use MIME::Base64;
use Kernel::System::Encode;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.27 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject ConfigObject DBObject TimeObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # encode object
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);

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

    my $Strg = '';
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
    for ( @{$ContentRef} ) {
        chomp;

        # split data
        my @PaarData = split( /:/, $_ );
        if ( defined( $PaarData[1] ) ) {
            $Data{ $PaarData[0] } = decode_base64( $PaarData[1] );
            $Self->{EncodeObject}->Encode( \$Data{ $PaarData[0] } );
        }
        else {
            $Data{ $PaarData[0] } = '';
        }

        # Debug
        if ( $Self->{Debug} ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "GetSessionIDData: '$PaarData[0]:" . decode_base64( $PaarData[1] ) . "'",
            );
        }
    }

    # cache result
    $Self->{"Cache::$Param{SessionID}"} = \%Data;
    return %Data;
}

sub CreateSessionID {
    my ( $Self, %Param ) = @_;

    # REMOTE_ADDR
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'none';

    # HTTP_USER_AGENT
    my $RemoteUserAgent = $ENV{HTTP_USER_AGENT} || 'none';

    # create SessionID
    my $md5 = Digest::MD5->new();
    $md5->add( ( $Self->{TimeObject}->SystemTime() . int( rand(999999999) ) . $Self->{SystemID} )
        . $RemoteAddr
            . $RemoteUserAgent );
    my $SessionID = $Self->{SystemID} . $md5->hexdigest;

    # data 2 strg
    my $DataToStore = '';
    for ( keys %Param ) {
        if ( defined( $Param{$_} ) ) {
            $Self->{EncodeObject}->EncodeOutput( \$Param{$_} );
            $DataToStore .= "$_:" . encode_base64( $Param{$_}, '' ) . "\n";
        }
    }
    $DataToStore
        .= "UserSessionStart:" . encode_base64( $Self->{TimeObject}->SystemTime(), '' ) . "\n";
    $DataToStore .= "UserRemoteAddr:" . encode_base64( $RemoteAddr,           '' ) . "\n";
    $DataToStore .= "UserRemoteUserAgent:" . encode_base64( $RemoteUserAgent, '' ) . "\n";

    # store SessionID + data
    return $Self->{MainObject}->FileWrite(
        Directory => $Self->{SessionSpool},
        Filename  => $SessionID,
        Content   => \$DataToStore,
        Mode      => 'utf8',                  # optional - binmode|utf8
    );
}

sub RemoveSessionID {
    my ( $Self, %Param ) = @_;

    # check session id
    if ( !$Param{SessionID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Got no SessionID!!" );
        return;
    }

    # delete fs file
    if ($Self->{MainObject}->FileDelete(
            Directory => $Self->{SessionSpool},
            Filename  => $Param{SessionID},
        )
        )
    {

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
    else {
        return;
    }
}

sub UpdateSessionID {
    my ( $Self, %Param ) = @_;

    my $Key   = defined( $Param{Key} )   ? $Param{Key}   : '';
    my $Value = defined( $Param{Value} ) ? $Param{Value} : '';

    # check session id
    if ( !$Param{SessionID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Got no SessionID!!" );
        return;
    }
    my %SessionData = $Self->GetSessionIDData( SessionID => $Param{SessionID} );

    # update the value
    $SessionData{$Key} = $Value;

    # set new data sting
    my $NewDataToStore = '';
    for ( keys %SessionData ) {
        $Self->{EncodeObject}->EncodeOutput( \$SessionData{$_} );
        $NewDataToStore .= "$_:" . encode_base64( $SessionData{$_}, '' ) . "\n";

        # Debug
        if ( $Self->{Debug} ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "UpdateSessionID: $_=$SessionData{$_}",
            );
        }
    }

    # reset cache
    if ( $Self->{"Cache::$Param{SessionID}"} ) {
        delete( $Self->{"Cache::$Param{SessionID}"} );
    }

    # update fs file
    return $Self->{MainObject}->FileWrite(
        Directory => $Self->{SessionSpool},
        Filename  => $Param{SessionID},
        Content   => \$NewDataToStore,
        Mode      => 'utf8',                  # optional - binmode|utf8
    );
}

sub GetAllSessionIDs {
    my ( $Self, %Param ) = @_;

    my @SessionIDs = ();

    # read data
    my @List = glob("$Self->{SessionSpool}/$Self->{SystemID}*");
    for my $SessionID (@List) {
        $SessionID =~ s!^.*/!!;
        push( @SessionIDs, $SessionID );
    }
    return @SessionIDs;
}

sub CleanUp {
    my ( $Self, %Param ) = @_;

    # delete fs files
    my @SessionIDs = $Self->GetAllSessionIDs();
    for (@SessionIDs) {
        if ( !$Self->RemoveSessionID( SessionID => $_ ) ) {
            return;
        }
    }
    return 1;
}

1;
