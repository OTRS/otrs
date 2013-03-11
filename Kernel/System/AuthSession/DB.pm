# --
# Kernel/System/AuthSession/DB.pm - provides session db backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject ConfigObject DBObject TimeObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "No $_!";
    }

    # get more common params
    $Self->{SessionTable}         = $Self->{ConfigObject}->Get('SessionTable') || 'sessions';
    $Self->{SystemID}             = $Self->{ConfigObject}->Get('SystemID');
    $Self->{AgentSessionLimit}    = $Self->{ConfigObject}->Get('AgentSessionLimit');
    $Self->{CustomerSessionLimit} = $Self->{ConfigObject}->Get('CustomerSessionLimit');
    $Self->{SessionActiveTime}    = $Self->{ConfigObject}->Get('SessionActiveTime') || 60 * 10;

    # get database type
    $Self->{DBType} = $Self->{DBObject}->{'DB::Type'} || '';
    $Self->{DBType} = lc $Self->{DBType};

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
    $Self->{SessionIDErrorMessage} = 'Session invalid. Please log in again.';

    # get session data
    my %Data = $Self->GetSessionIDData( SessionID => $Param{SessionID} );

    if ( !$Data{UserID} || !$Data{UserLogin} ) {
        $Self->{SessionIDErrorMessage} = 'Session invalid. Please log in again.';
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
                . "different from registered IP ($RemoteAddr). Invalidating session! "
                . "Disable config 'SessionCheckRemoteIP' if you don't want this!",
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

        $Self->{SessionIDErrorMessage} = 'Session has timed out. Please log in again.';

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

        $Self->{SessionIDErrorMessage} = 'Session has timed out. Please log in again.';

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

sub SessionIDErrorMessage {
    my ( $Self, %Param ) = @_;

    return $Self->{SessionIDErrorMessage} || '';
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
        SQL => "
            SELECT id, data_key, data_value, serialized
            FROM $Self->{SessionTable}
            WHERE session_id = ?
            ORDER BY id ASC",
        Bind => [ \$Param{SessionID} ],
    );

    my %Session;
    my %SessionID;
    ROW:
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        # deserialize data if needed
        if ( $Row[3] ) {
            my $Value = eval { Storable::thaw( $Row[2] ) };

            # workaround for the oracle problem with empty
            # strings and NULL values in VARCHAR columns
            if ( $Value && ref $Value eq 'SCALAR' ) {
                $Value = ${$Value};
            }

            $Self->{EncodeObject}->EncodeOutput( \$Value );

            $Session{ $Row[1] } = $Value;
        }
        else {
            $Session{ $Row[1] } = $Row[2];
        }

        $SessionID{ $Row[1] } = $Row[0];
    }

    if ( !%Session ) {
        delete $Self->{Cache}->{ $Param{SessionID} };
        delete $Self->{CacheID}->{ $Param{SessionID} };
        delete $Self->{CacheUpdate}->{ $Param{SessionID} };
        return;
    }

    # cache result
    $Self->{Cache}->{ $Param{SessionID} }   = \%Session;
    $Self->{CacheID}->{ $Param{SessionID} } = \%SessionID;

    return %Session;
}

sub CreateSessionID {
    my ( $Self, %Param ) = @_;

    # get system time
    my $TimeNow = $Self->{TimeObject}->SystemTime();

    # get session limit config
    my $SessionLimit;
    if ( $Param{UserType} && $Param{UserType} eq 'User' && $Self->{AgentSessionLimit} ) {
        $SessionLimit = $Self->{AgentSessionLimit};
    }
    elsif ( $Param{UserType} && $Param{UserType} eq 'Customer' && $Self->{CustomerSessionLimit} ) {
        $SessionLimit = $Self->{CustomerSessionLimit};
    }

    if ($SessionLimit) {

        # get all needed timestamps to investigate the expired sessions
        $Self->{DBObject}->Prepare(
            SQL => "
                SELECT session_id, data_key, data_value
                FROM $Self->{SessionTable}
                WHERE data_key = 'UserType'
                    OR data_key = 'UserLastRequest'
                ORDER BY id ASC",
        );

        my %SessionData;
        ROW:
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

            next ROW if !$Row[0];
            next ROW if !$Row[1];

            $SessionData{ $Row[0] }->{ $Row[1] } = $Row[2];
        }

        my $ActiveSessionCount = 0;
        SESSIONID:
        for my $SessionID ( sort keys %SessionData ) {

            next SESSIONID if !$SessionID;
            next SESSIONID if !$SessionData{$SessionID};

            # get needed data
            my $UserType        = $SessionData{$SessionID}->{UserType}        || '';
            my $UserLastRequest = $SessionData{$SessionID}->{UserLastRequest} || $TimeNow;

            next SESSIONID if $UserType ne $Param{UserType};

            next SESSIONID if ( $UserLastRequest + $Self->{SessionActiveTime} ) < $TimeNow;

            $ActiveSessionCount++;

            next SESSIONID if $ActiveSessionCount < $SessionLimit;

            $Self->{SessionIDErrorMessage} = 'Session limit reached! Please try again later.';

            return;
        }
    }

    # get remote address and the http user agent
    my $RemoteAddr      = $ENV{REMOTE_ADDR}     || 'none';
    my $RemoteUserAgent = $ENV{HTTP_USER_AGENT} || 'none';

    # create session id
    my $MD5 = Digest::MD5->new();
    $MD5->add(
        ( $TimeNow . int( rand 999999999 ) . $Self->{SystemID} ) . $RemoteAddr . $RemoteUserAgent
    );
    my $SessionID = $Self->{SystemID} . $MD5->hexdigest();

    # create challenge token
    $MD5 = Digest::MD5->new();
    $MD5->add( $TimeNow . $SessionID );
    my $ChallengeToken = $MD5->hexdigest();

    my %Data;
    KEY:
    for my $Key ( sort keys %Param ) {

        next KEY if !$Key;

        $Data{$Key} = $Param{$Key};
    }

    $Data{UserSessionStart}    = $TimeNow;
    $Data{UserRemoteAddr}      = $RemoteAddr;
    $Data{UserRemoteUserAgent} = $RemoteUserAgent;
    $Data{UserChallengeToken}  = $ChallengeToken;

    # create sql data
    my @SQLs;
    $Self->_SQLCreate(
        Data      => \%Data,
        SQLs      => \@SQLs,
        SessionID => $SessionID,
    );

    return if !@SQLs;

    # delete old session data with the same session id
    $Self->{DBObject}->Do(
        SQL => "
            DELETE FROM $Self->{SessionTable}
            WHERE session_id = ?",
        Bind => [ \$SessionID, ],
    );

    # store session id and data
    ROW:
    for my $Row (@SQLs) {

        next ROW if !$Row;
        next ROW if ref $Row ne 'HASH';
        next ROW if !$Row->{SQL};
        next ROW if !$Row->{Bind};
        next ROW if ref $Row->{Bind} ne 'ARRAY';

        $Self->{DBObject}->Do(
            SQL  => $Row->{SQL},
            Bind => $Row->{Bind},
        );
    }

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
        SQL  => "DELETE FROM $Self->{SessionTable} WHERE session_id = ?",
        Bind => [ \$Param{SessionID} ],
    );

    # reset cache
    delete $Self->{Cache}->{ $Param{SessionID} };
    delete $Self->{CacheID}->{ $Param{SessionID} };
    delete $Self->{CacheUpdate}->{ $Param{SessionID} };

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
    $Self->{Cache}->{ $Param{SessionID} }->{ $Param{Key} }       = $Param{Value};
    $Self->{CacheUpdate}->{ $Param{SessionID} }->{ $Param{Key} } = $Param{Value};

    return 1;
}

sub GetAllSessionIDs {
    my ( $Self, %Param ) = @_;

    # get all session ids from the database
    return if !$Self->{DBObject}->Prepare(
        SQL => "SELECT DISTINCT(session_id) FROM $Self->{SessionTable}",
    );

    # fetch the result
    my @SessionIDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @SessionIDs, $Row[0];
    }

    return @SessionIDs;
}

sub GetExpiredSessionIDs {
    my ( $Self, %Param ) = @_;

    # get config
    my $MaxSessionTime     = $Self->{ConfigObject}->Get('SessionMaxTime');
    my $MaxSessionIdleTime = $Self->{ConfigObject}->Get('SessionMaxIdleTime');

    # get current time
    my $TimeNow = $Self->{TimeObject}->SystemTime();

    # get all needed timestamps to investigate the expired sessions
    $Self->{DBObject}->Prepare(
        SQL => "
            SELECT session_id, data_key, data_value
            FROM $Self->{SessionTable}
            WHERE data_key = 'UserSessionStart'
                OR data_key = 'UserLastRequest'
            ORDER BY id ASC",
    );

    my %SessionData;
    ROW:
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        next ROW if !$Row[0];
        next ROW if !$Row[1];

        $SessionData{ $Row[0] }->{ $Row[1] } = $Row[2];
    }

    my @ExpiredSession;
    my @ExpiredIdle;
    SESSIONID:
    for my $SessionID ( sort keys %SessionData ) {

        next SESSIONID if !$SessionID;
        next SESSIONID if !$SessionData{$SessionID};

        # get needed timestamps
        my $UserSessionStart = $SessionData{$SessionID}->{UserSessionStart} || $TimeNow;
        my $UserLastRequest  = $SessionData{$SessionID}->{UserLastRequest}  || $TimeNow;

        # time calculation
        my $ValidTime     = $UserSessionStart + $MaxSessionTime - $TimeNow;
        my $ValidIdleTime = $UserLastRequest + $MaxSessionIdleTime - $TimeNow;

        # delete invalid session time
        if ( $ValidTime <= 0 ) {
            push @ExpiredSession, $SessionID;
        }

        # delete invalid idle session time
        elsif ( $ValidIdleTime <= 0 ) {
            push @ExpiredIdle, $SessionID;
        }
    }

    return ( \@ExpiredSession, \@ExpiredIdle );
}

sub CleanUp {
    my ( $Self, %Param ) = @_;

    # use trancate if possible to reset the auto increment value
    if (
        $Self->{DBType} eq 'mysql'
        || $Self->{DBType} eq 'postgresql'
        || $Self->{DBType} eq 'oracle'
        || $Self->{DBType} eq 'mssql'
        )
    {

        return if !$Self->{DBObject}->Do( SQL => "TRUNCATE TABLE $Self->{SessionTable}" );
    }
    else {
        return if !$Self->{DBObject}->Do( SQL => "DELETE FROM $Self->{SessionTable}" );
    }

    # remove cached data
    delete $Self->{Cache};
    delete $Self->{CacheID};
    delete $Self->{CacheUpdate};

    return 1;
}

sub DESTROY {
    my ( $Self, %Param ) = @_;

    return 1 if !$Self->{CacheUpdate};

    SESSIONID:
    for my $SessionID ( sort keys %{ $Self->{CacheUpdate} } ) {

        next SESSIONID if !$SessionID;

        # extract session data to update
        my $Data = $Self->{CacheUpdate}->{$SessionID};

        next SESSIONID if !$Data;
        next SESSIONID if ref $Data ne 'HASH';
        next SESSIONID if !%{$Data};

        # create sql data
        my @SQLs;
        $Self->_SQLCreate(
            Data      => $Data,
            SQLs      => \@SQLs,
            SessionID => $SessionID,
        );

        next SESSIONID if !@SQLs;

        # store session id and data
        ROW:
        for my $Row (@SQLs) {

            next ROW if !$Row;
            next ROW if ref $Row ne 'HASH';
            next ROW if !$Row->{SQL};
            next ROW if !$Row->{Bind};
            next ROW if ref $Row->{Bind} ne 'ARRAY';

            $Self->{DBObject}->Do(
                SQL  => $Row->{SQL},
                Bind => $Row->{Bind},
            );
        }

        KEY:
        for my $Key ( sort keys %{ $Self->{CacheUpdate}->{$SessionID} } ) {

            next KEY if !$Key;

            # extract database id
            my $ID = $Self->{CacheID}->{$SessionID}->{$Key} || 1;

            # delete old session data from the database
            $Self->{DBObject}->Do(
                SQL => "
                    DELETE FROM $Self->{SessionTable}
                    WHERE session_id = ?
                        AND data_key = ?
                        AND id <= ?",
                Bind => [ \$SessionID, \$Key, \$ID ],
            );
        }
    }

    # remove cached data
    delete $Self->{Cache};
    delete $Self->{CacheID};
    delete $Self->{CacheUpdate};

    return 1;
}

sub _SQLCreate {
    my ( $Self, %Param ) = @_;

    return if !$Param{Data};
    return if ref $Param{Data} ne 'HASH';
    return if !%{ $Param{Data} };
    return if !$Param{SessionID};
    return if !$Param{SQLs};
    return if ref $Param{SQLs} ne 'ARRAY';

    if ( $Self->{DBType} eq 'mysql' || $Self->{DBType} eq 'postgresql' ) {

        # define row
        my $SQL = "INSERT INTO $Self->{SessionTable} "
            . "(session_id, data_key, data_value, serialized) VALUES ";
        my @Bind;

        KEY:
        for my $Key ( sort keys %{ $Param{Data} } ) {

            next KEY if !$Key;

            my $Value      = $Param{Data}->{$Key};
            my $Serialized = 0;

            if (
                ref $Value eq 'HASH'
                || ref $Value eq 'ARRAY'
                || ref $Value eq 'SCALAR'
                )
            {

                # dump the data
                $Value      = Storable::nfreeze($Value);
                $Serialized = 1;
            }

            push @Bind, \$Param{SessionID};
            push @Bind, \$Key;
            push @Bind, \$Value;
            push @Bind, \$Serialized;

            $SQL .= '(?,?,?,?),';
        }

        # remove the last character
        chop $SQL;

        my %Row = (
            SQL  => $SQL,
            Bind => \@Bind,
        );

        push @{ $Param{SQLs} }, \%Row;

        return 1;
    }
    elsif ( $Self->{DBType} eq 'oracle' ) {

        # define row
        my $SQL = 'INSERT ALL ';
        my @Bind;

        KEY:
        for my $Key ( sort keys %{ $Param{Data} } ) {

            next KEY if !$Key;

            my $Value      = $Param{Data}->{$Key};
            my $Serialized = 0;

            if (
                !defined $Value
                || $Value eq ''
                || ref $Value eq 'HASH'
                || ref $Value eq 'ARRAY'
                || ref $Value eq 'SCALAR'
                )
            {

                # workaround for the oracle problem with empty strings
                # and NULL values in VARCHAR columns
                if ( !defined $Value ) {

                    my $Empty = undef;
                    $Value = \$Empty;
                }
                elsif ( $Value eq '' ) {

                    my $Empty = '';
                    $Value = \$Empty;
                }

                # dump the data
                $Value      = Storable::nfreeze($Value);
                $Serialized = 1;
            }

            push @Bind, \$Param{SessionID};
            push @Bind, \$Key;
            push @Bind, \$Value;
            push @Bind, \$Serialized;

            $SQL .= "INTO $Self->{SessionTable} "
                . "(session_id, data_key, data_value, serialized) VALUES (?,?,?,?) ";
        }

        $SQL .= 'SELECT * FROM dual';

        my %Row = (
            SQL  => $SQL,
            Bind => \@Bind,
        );

        push @{ $Param{SQLs} }, \%Row;

        return 1;
    }
    else {

        KEY:
        for my $Key ( sort keys %{ $Param{Data} } ) {

            next KEY if !$Key;

            my $Value      = $Param{Data}->{$Key};
            my $Serialized = 0;

            if (
                ref $Value eq 'HASH'
                || ref $Value eq 'ARRAY'
                || ref $Value eq 'SCALAR'
                )
            {

                # dump the data
                $Value      = Storable::nfreeze($Value);
                $Serialized = 1;
            }

            my @Bind;
            push @Bind, \$Param{SessionID};
            push @Bind, \$Key;
            push @Bind, \$Value;
            push @Bind, \$Serialized;

            my $SQL = "INSERT INTO $Self->{SessionTable} "
                . "(session_id, data_key, data_value, serialized) VALUES (?,?,?,?)";

            my %Row = (
                SQL  => $SQL,
                Bind => \@Bind,
            );

            push @{ $Param{SQLs} }, \%Row;
        }

        return 1;
    }
}

1;
