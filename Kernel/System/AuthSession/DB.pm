# --
# Kernel/System/AuthSession/DB.pm - provides session db backend
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: DB.pm,v 1.37 2009-02-17 22:18:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::AuthSession::DB;

use strict;
use warnings;
use Digest::MD5;
use MIME::Base64;
use Kernel::System::Encode;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.37 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject ConfigObject DBObject TimeObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # encode object
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);

    # get more common params
    $Self->{SystemID} = $Self->{ConfigObject}->Get('SystemID');

    # Debug 0=off 1=on
    $Self->{Debug} = 0;

    # session table data
    $Self->{SQLSessionTable} = $Self->{ConfigObject}->Get('SessionTable') || 'sessions';

    # id row
    $Self->{SQLSessionTableID} = $Self->{ConfigObject}->Get('SessionTableID') || 'session_id';

    # value row
    $Self->{SQLSessionTableValue} = $Self->{ConfigObject}->Get('SessionTableValue')
        || 'session_value';

    return $Self;
}

sub CheckSessionID {
    my ( $Self, %Param ) = @_;

    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'none';

    # check session id
    if ( !$Param{SessionID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Got no SessionID!!' );
        return;
    }

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
                . "different with the request IP ($RemoteAddr). Don't grant access!!!",
        );

        # delete session id if it isn't the same remote ip?
        if ( $Self->{ConfigObject}->Get('SessionDeleteIfNotRemoteID') ) {
            $Self->RemoveSessionID( SessionID => $Param{SessionID} );
        }
        return;
    }

    # check session idle time
    my $TimeNow = $Self->{TimeObject}->SystemTime();
    my $MaxSessionIdleTime = $Self->{ConfigObject}->Get('SessionMaxIdleTime');
    if ( ( $TimeNow - $MaxSessionIdleTime ) >= $Data{UserLastRequest} ) {
        $Self->{CheckSessionIDMessage} = 'Session has timed out. Please log in again.';
        my $Timeout = int( ( $TimeNow - $Data{UserLastRequest} ) / ( 60 * 60 ) );
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "SessionID ($Param{SessionID}) idle timeout ($Timeout h)! Don't grant access!!!",
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

    my $Strg = '';
    my %Data;

    # check session id
    if ( !$Param{SessionID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Got no SessionID!!' );
        return;
    }

    # check cache
    if ( $Self->{"Cache::$Param{SessionID}"} ) {
        return %{ $Self->{"Cache::$Param{SessionID}"} };
    }

    # read data
    $Self->{DBObject}->Prepare(
        SQL => "SELECT $Self->{SQLSessionTableValue} FROM "
            . " $Self->{SQLSessionTable} WHERE $Self->{SQLSessionTableID} = ?",
        Bind => [ \$Param{SessionID} ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Strg = $Row[0];
    }

    # split data
    my @StrgData = split( /;/, $Strg );
    for (@StrgData) {
        my @PaarData = split( /:/, $_ );
        if ( $PaarData[1] ) {
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

    # return data
    return %Data;
}

sub CreateSessionID {
    my ( $Self, %Param ) = @_;

    # get REMOTE_ADDR
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'none';

    # get HTTP_USER_AGENT
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
    for ( keys %Param ) {
        if ( defined $Param{$_} ) {
            $Self->{EncodeObject}->EncodeOutput( \$Param{$_} );
            $DataToStore .= "$_:" . encode_base64( $Param{$_}, '' ) . ":;";
        }
    }
    $DataToStore .= "UserSessionStart:" . encode_base64( $TimeNow, '' ) . ":;";
    $DataToStore .= "UserRemoteAddr:" . encode_base64( $RemoteAddr, '' ) . ":;";
    $DataToStore .= "UserRemoteUserAgent:" . encode_base64( $RemoteUserAgent, '' ) . ":;";
    $DataToStore .= "UserChallengeToken:" . encode_base64( $ChallengeToken, '' ) . ":;";

    # store SessionID + data
    return if !$Self->{DBObject}->Do(
        SQL => "INSERT INTO $Self->{SQLSessionTable} "
            . " ($Self->{SQLSessionTableID}, $Self->{SQLSessionTableValue}) VALUES (?, ?)",
        Bind => [ \$SessionID, \$DataToStore ],
    );

    return $SessionID;
}

sub RemoveSessionID {
    my ( $Self, %Param ) = @_;

    # check session id
    if ( !$Param{SessionID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Got no SessionID!!' );
        return;
    }

    # delete db recode
    return if !$Self->{DBObject}->Do(
        SQL  => "DELETE FROM $Self->{SQLSessionTable} WHERE $Self->{SQLSessionTableID} = ?",
        Bind => [ \$Param{SessionID} ],
    );

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

    my $Key   = defined( $Param{Key} )   ? $Param{Key}   : '';
    my $Value = defined( $Param{Value} ) ? $Param{Value} : '';

    # check session id
    if ( !$Param{SessionID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Got no SessionID!!' );
        return;
    }
    my %SessionData = $Self->GetSessionIDData( SessionID => $Param{SessionID} );

    # check needed update! (no changes)
    if (
        ( ( exists $SessionData{$Key} ) && $SessionData{$Key} eq $Value )
        || ( !exists $SessionData{$Key} && $Value eq '' )
        )
    {
        return 1;
    }

    # update the value
    $SessionData{$Key} = $Value;

    # set new data sting
    my $NewDataToStore = '';
    for ( keys %SessionData ) {
        $Self->{EncodeObject}->EncodeOutput( \$SessionData{$_} );
        $NewDataToStore .= "$_:" . encode_base64( $SessionData{$_}, '' ) . ':;';

        # Debug
        if ( $Self->{Debug} ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "UpdateSessionID: $_=$SessionData{$_}",
            );
        }
    }

    # update db enrty
    return if !$Self->{DBObject}->Do(
        SQL => "UPDATE $Self->{SQLSessionTable} SET "
            . " $Self->{SQLSessionTableValue} = ? WHERE $Self->{SQLSessionTableID} = ?",
        Bind => [ \$NewDataToStore, \$Param{SessionID} ],
    );

    # reset cache
    if ( $Self->{"Cache::$Param{SessionID}"} ) {
        delete $Self->{"Cache::$Param{SessionID}"};
    }
    return 1;
}

sub GetAllSessionIDs {
    my ( $Self, %Param ) = @_;

    my @SessionIDs = ();

    # read data
    $Self->{DBObject}->Prepare(
        SQL => "SELECT $Self->{SQLSessionTableID} FROM $Self->{SQLSessionTable}",
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @SessionIDs, $Row[0];
    }
    return @SessionIDs;
}

sub CleanUp {
    my ( $Self, %Param ) = @_;

    # delete db recodes
    return $Self->{DBObject}->Do( SQL => "DELETE FROM $Self->{SQLSessionTable}" );
}

1;
