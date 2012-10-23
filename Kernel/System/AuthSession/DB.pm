# --
# Kernel/System/AuthSession/DB.pm - provides session db backend
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: DB.pm,v 1.53 2012-10-23 08:24:19 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::AuthSession::DB;

use strict;
use warnings;

use Digest::MD5;
use Storable;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.53 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject ConfigObject DBObject TimeObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # get system id
    $Self->{SystemID} = $Self->{ConfigObject}->Get('SystemID');

    # get session table
    $Self->{SessionTable} = $Self->{ConfigObject}->Get('SessionTable') || 'sessions';

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
                . "different from registered IP ($RemoteAddr). Invalidating session!"
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
    return %{ $Self->{Cache}->{ $Param{SessionID} } }
        if $Self->{Cache}->{ $Param{SessionID} };

    # read data
    $Self->{DBObject}->Prepare(
        SQL  => "SELECT data_key, data_value, serialized FROM $Self->{SessionTable} WHERE id = ?",
        Bind => [ \$Param{SessionID} ],
    );

    my %Session;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        # deserialize data if needed
        if ( $Row[2] ) {
            my $Value = eval { Storable::thaw( $Row[1] ) };

            $Self->{EncodeObject}->EncodeOutput( \$Value );

            $Session{ $Row[0] } = $Value;
        }
        else {
            $Session{ $Row[0] } = $Row[1];
        }
    }

    if ( !%Session ) {
        delete $Self->{Cache}->{ $Param{SessionID} };
        return;
    }

    # cache result
    $Self->{Cache}->{ $Param{SessionID} } = \%Session;

    return %Session;
}

sub CreateSessionID {
    my ( $Self, %Param ) = @_;

    # get remote address and the http user agent
    my $RemoteAddr      = $ENV{REMOTE_ADDR}     || 'none';
    my $RemoteUserAgent = $ENV{HTTP_USER_AGENT} || 'none';

    # get system time
    my $TimeNow = $Self->{TimeObject}->SystemTime();

    # create session id
    my $md5 = Digest::MD5->new();
    $md5->add(
        ( $TimeNow . int( rand(999999999) ) . $Self->{SystemID} ) . $RemoteAddr . $RemoteUserAgent
    );
    my $SessionID = $Self->{SystemID} . $md5->hexdigest;

    # create challenge token
    $md5 = Digest::MD5->new();
    $md5->add( $TimeNow . $SessionID );
    my $ChallengeToken = $md5->hexdigest;

    my %Data;
    KEY:
    for my $Key ( keys %Param ) {

        next KEY if !defined $Param{$Key};

        $Data{$Key} = $Param{$Key};
    }

    $Data{UserSessionStart}    = $TimeNow;
    $Data{UserRemoteAddr}      = $RemoteAddr;
    $Data{UserRemoteUserAgent} = $RemoteUserAgent;
    $Data{UserChallengeToken}  = $ChallengeToken;

    my $SQLData = '';
    my @Bind;

    # create sql data
    $Self->_SQLCreate(
        Data      => \%Data,
        SQLData   => \$SQLData,
        Bind      => \@Bind,
        SessionID => $SessionID,
    );

    # remove the last character
    chop $SQLData;

    return if !@Bind;

    # store session id and data
    return if !$Self->{DBObject}->Do(
        SQL => "INSERT INTO $Self->{SessionTable} (id, data_key, data_value, serialized) VALUES "
            . $SQLData,
        Bind => \@Bind,
    );

    # set cache
    $Self->{Cache}->{$SessionID} = \%Data;

    return $SessionID;
}

sub RemoveSessionID {
    my ( $Self, %Param ) = @_;

    # check session id
    if ( !$Param{SessionID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Got no SessionID!!' );
        return;
    }

    # delete session from the database
    return if !$Self->{DBObject}->Do(
        SQL  => "DELETE FROM $Self->{SessionTable} WHERE id = ?",
        Bind => [ \$Param{SessionID} ],
    );

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

        $Self->{Cache}->{ $Param{SessionID} } = \%SessionData;
    }

    # update the value, set cache
    $Self->{Cache}->{ $Param{SessionID} }->{ $Param{Key} } = $Param{Value};

    return 1;
}

sub GetAllSessionIDs {
    my ( $Self, %Param ) = @_;

    # get all session ids from the database
    return if !$Self->{DBObject}->Prepare(
        SQL => "SELECT DISTINCT(id) FROM $Self->{SessionTable}",
    );

    # fetch the result
    my @SessionIDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @SessionIDs, $Row[0];
    }

    return @SessionIDs;
}

sub CleanUp {
    my ( $Self, %Param ) = @_;

    # delete all session data from database
    return if !$Self->{DBObject}->Do( SQL => "DELETE FROM $Self->{SessionTable}" );
    return 1;
}

sub _SQLCreate {
    my ( $Self, %Param ) = @_;

    return if !$Param{SessionID};
    return if !defined $Param{SQLData};
    return if !$Param{Data};
    return if ref $Param{Data} ne 'HASH';
    return if !$Param{Bind};
    return if ref $Param{Bind} ne 'ARRAY';

    KEY:
    for my $Key ( sort keys %{ $Param{Data} } ) {

        next KEY if !$Key;
        next KEY if !defined $Param{Data}->{$Key};

        my $Value      = $Param{Data}->{$Key};
        my $Serialized = 0;

        if ( ref $Param{Data}->{$Key} eq 'HASH' || ref $Param{Data}->{$Key} eq 'ARRAY' ) {

            # dump the data
            $Value      = Storable::nfreeze( $Param{Data}->{$Key} );
            $Serialized = 1;
        }

        push @{ $Param{Bind} }, \$Param{SessionID};
        push @{ $Param{Bind} }, \$Key;
        push @{ $Param{Bind} }, \$Value;
        push @{ $Param{Bind} }, \$Serialized;

        ${ $Param{SQLData} } .= '(?,?,?,?),';
    }

    return 1;
}

sub DESTROY {
    my ( $Self, %Param ) = @_;

    return 1 if !$Self->{Cache};

    SESSIONID:
    for my $SessionID ( sort keys %{ $Self->{Cache} } ) {

        next SESSIONID if !$SessionID;

        my $SQLData = '';
        my @Bind;

        # create sql data
        $Self->_SQLCreate(
            Data      => $Self->{Cache}->{$SessionID},
            SQLData   => \$SQLData,
            Bind      => \@Bind,
            SessionID => $SessionID,
        );

        # remove the last character
        chop $SQLData;

        # delete old session data from the database
        return if !$Self->{DBObject}->Do(
            SQL  => "DELETE FROM $Self->{SessionTable} WHERE id = ?",
            Bind => [ \$SessionID ],
        );

        next SESSIONID if !@Bind;

        # store session id and data
        return if !$Self->{DBObject}->Do(
            SQL =>
                "INSERT INTO $Self->{SessionTable} (id, data_key, data_value, serialized) VALUES "
                . $SQLData,
            Bind => \@Bind,
        );
    }

    # remove cached data
    delete $Self->{Cache};

    return 1;
}

1;
