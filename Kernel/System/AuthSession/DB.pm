# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::AuthSession::DB;

use strict;
use warnings;

use MIME::Base64 qw();

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DateTime',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Storable',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{SessionTable} = $Kernel::OM->Get('Kernel::Config')->Get('SessionTable') || 'sessions';

    # get database type
    $Self->{DBType} = $Kernel::OM->Get('Kernel::System::DB')->{'DB::Type'} || '';
    $Self->{DBType} = lc $Self->{DBType};

    return $Self;
}

sub CheckSessionID {
    my ( $Self, %Param ) = @_;

    # check session id
    if ( !$Param{SessionID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no SessionID!!'
        );
        return;
    }
    my $RemoteAddr = $ENV{REMOTE_ADDR} || 'none';

    # set default message
    $Self->{SessionIDErrorMessage} = Translatable('Session invalid. Please log in again.');

    # get session data
    my %Data = $Self->GetSessionIDData( SessionID => $Param{SessionID} );

    if ( !$Data{UserID} || !$Data{UserLogin} ) {
        $Self->{SessionIDErrorMessage} = Translatable('Session invalid. Please log in again.');
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "SessionID: '$Param{SessionID}' is invalid!!!",
        );
        return;
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # remote ip check
    if (
        $Data{UserRemoteAddr} ne $RemoteAddr
        && $ConfigObject->Get('SessionCheckRemoteIP')
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "RemoteIP of '$Param{SessionID}' ($Data{UserRemoteAddr}) is "
                . "different from registered IP ($RemoteAddr). Invalidating session! "
                . "Disable config 'SessionCheckRemoteIP' if you don't want this!",
        );

        # delete session id if it isn't the same remote ip?
        if ( $ConfigObject->Get('SessionDeleteIfNotRemoteID') ) {
            $Self->RemoveSessionID( SessionID => $Param{SessionID} );
        }

        return;
    }

    # check session idle time
    my $TimeNow            = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
    my $MaxSessionIdleTime = $ConfigObject->Get('SessionMaxIdleTime');

    if ( ( $TimeNow - $MaxSessionIdleTime ) >= $Data{UserLastRequest} ) {

        $Self->{SessionIDErrorMessage} = Translatable('Session has timed out. Please log in again.');

        my $Timeout = int( ( $TimeNow - $Data{UserLastRequest} ) / ( 60 * 60 ) );

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message =>
                "SessionID ($Param{SessionID}) idle timeout ($Timeout h)! Don't grant access!!!",
        );

        # delete session id if too old?
        if ( $ConfigObject->Get('SessionDeleteIfTimeToOld') ) {
            $Self->RemoveSessionID( SessionID => $Param{SessionID} );
        }

        return;
    }

    # check session time
    my $MaxSessionTime = $ConfigObject->Get('SessionMaxTime');

    if ( ( $TimeNow - $MaxSessionTime ) >= $Data{UserSessionStart} ) {

        $Self->{SessionIDErrorMessage} = Translatable('Session has timed out. Please log in again.');

        my $Timeout = int( ( $TimeNow - $Data{UserSessionStart} ) / ( 60 * 60 ) );

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "SessionID ($Param{SessionID}) too old ($Timeout h)! Don't grant access!!!",
        );

        # delete session id if too old
        if ( $ConfigObject->Get('SessionDeleteIfTimeToOld') ) {
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no SessionID!'
        );
        return;
    }

    return %{ $Self->{Cache}->{ $Param{SessionID} } } if $Self->{Cache}->{ $Param{SessionID} };

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # read data
    $DBObject->Prepare(
        SQL => "
            SELECT id, data_key, data_value, serialized
            FROM $Self->{SessionTable}
            WHERE session_id = ?
            ORDER BY id ASC",
        Bind => [ \$Param{SessionID} ],
    );

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # get storable object
    my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');

    my %Session;
    my %SessionID;
    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # deserialize data if needed
        if ( $Row[3] ) {
            my $Value = eval {
                $StorableObject->Deserialize( Data => MIME::Base64::decode_base64( $Row[2] ) );
            };

            # workaround for the oracle problem with empty
            # strings and NULL values in VARCHAR columns
            if ( $Value && ref $Value eq 'SCALAR' ) {
                $Value = ${$Value};
            }

            $EncodeObject->EncodeOutput( \$Value );

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

    my $TimeNow = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

    # get remote address and the http user agent
    my $RemoteAddr      = $ENV{REMOTE_ADDR}     || 'none';
    my $RemoteUserAgent = $ENV{HTTP_USER_AGENT} || 'none';

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # create session id
    my $SessionID = $MainObject->GenerateRandomString(
        Length => 32,
    );

    # create challenge token
    my $ChallengeToken = $MainObject->GenerateRandomString(
        Length => 32,
    );

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

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # create sql data
    my @SQLs;
    $Self->_SQLCreate(
        Data      => \%Data,
        SQLs      => \@SQLs,
        SessionID => $SessionID,
    );

    return if !@SQLs;

    # delete old session data with the same session id
    $DBObject->Do(
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

        $DBObject->Do(
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no SessionID!!'
        );
        return;
    }

    # delete session from the database
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => "DELETE FROM $Self->{SessionTable} WHERE session_id = ?",
        Bind => [ \$Param{SessionID} ],
    );

    # reset cache
    delete $Self->{Cache}->{ $Param{SessionID} };
    delete $Self->{CacheID}->{ $Param{SessionID} };
    delete $Self->{CacheUpdate}->{ $Param{SessionID} };

    # log event
    $Kernel::OM->Get('Kernel::System::Log')->Log(
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
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

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get all session ids from the database
    return if !$DBObject->Prepare(
        SQL => "SELECT DISTINCT(session_id) FROM $Self->{SessionTable}",
    );

    # fetch the result
    my @SessionIDs;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @SessionIDs, $Row[0];
    }

    return @SessionIDs;
}

sub GetActiveSessions {
    my ( $Self, %Param ) = @_;

    my $MaxSessionIdleTime = $Kernel::OM->Get('Kernel::Config')->Get('SessionMaxIdleTime');

    # get system time
    my $TimeNow = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    $DBObject->Prepare(
        SQL => "
            SELECT session_id, data_key, data_value
            FROM $Self->{SessionTable}
            WHERE data_key = 'UserType'
                OR data_key = 'UserLastRequest'
                OR data_key = 'UserLogin'
                OR data_key = 'SessionSource'
            ORDER BY id ASC",
    );

    my %SessionData;
    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {

        next ROW if !$Row[0];
        next ROW if !$Row[1];

        $SessionData{ $Row[0] }->{ $Row[1] } = $Row[2];
    }

    my $ActiveSessionCount = 0;
    my %ActiveSessionPerUserCount;
    SESSIONID:
    for my $SessionID ( sort keys %SessionData ) {

        next SESSIONID if !$SessionID;
        next SESSIONID if !$SessionData{$SessionID};

        # Don't count session from source 'GenericInterface'
        my $SessionSource = $SessionData{$SessionID}->{SessionSource} || '';

        next SESSIONID if $SessionSource eq 'GenericInterface';

        # get needed data
        my $UserType        = $SessionData{$SessionID}->{UserType}        || '';
        my $UserLastRequest = $SessionData{$SessionID}->{UserLastRequest} || $TimeNow;
        my $UserLogin       = $SessionData{$SessionID}->{UserLogin};

        next SESSIONID if $UserType ne $Param{UserType};

        next SESSIONID if ( $UserLastRequest + $MaxSessionIdleTime ) < $TimeNow;

        $ActiveSessionCount++;

        $ActiveSessionPerUserCount{$UserLogin} || 0;
        $ActiveSessionPerUserCount{$UserLogin}++;
    }

    my %Result = (
        Total   => $ActiveSessionCount,
        PerUser => \%ActiveSessionPerUserCount,
    );

    return %Result;
}

sub GetExpiredSessionIDs {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get config
    my $MaxSessionTime     = $ConfigObject->Get('SessionMaxTime');
    my $MaxSessionIdleTime = $ConfigObject->Get('SessionMaxIdleTime');

    # get current time
    my $TimeNow = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get all needed timestamps to investigate the expired sessions
    $DBObject->Prepare(
        SQL => "
            SELECT session_id, data_key, data_value
            FROM $Self->{SessionTable}
            WHERE data_key = 'UserSessionStart'
                OR data_key = 'UserLastRequest'
            ORDER BY id ASC",
    );

    my %SessionData;
    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {

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

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # use 'truncate table' if possible in order to reset the auto increment value
    if (
        $Self->{DBType} eq 'mysql'
        || $Self->{DBType} eq 'postgresql'
        || $Self->{DBType} eq 'oracle'
        || $Self->{DBType} eq 'mssql'
        )
    {

        return if !$DBObject->Do( SQL => "TRUNCATE TABLE $Self->{SessionTable}" );
    }
    else {
        return if !$DBObject->Do( SQL => "DELETE FROM $Self->{SessionTable}" );
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

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

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

            $DBObject->Do(
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
            $DBObject->Do(
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

    my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');

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
                $Value = MIME::Base64::encode_base64(
                    $StorableObject->Serialize( Data => $Value )
                );
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
        my $SQL = '';
        my @Bind;
        my $Counter = 0;

        KEY:
        for my $Key ( sort keys %{ $Param{Data} } ) {

            next KEY if !$Key;

            $Counter++;

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
                $Value = MIME::Base64::encode_base64(
                    $StorableObject->Serialize( Data => $Value )
                );
                $Serialized = 1;
            }

            $SQL ||= 'INSERT ALL ';
            $SQL .= "INTO $Self->{SessionTable} "
                . "(session_id, data_key, data_value, serialized) VALUES (?,?,?,?) ";

            push @Bind, \$Param{SessionID};
            push @Bind, \$Key;
            push @Bind, \$Value;
            push @Bind, \$Serialized;

            # split SQLs with more than 4k charecters
            next KEY if $Counter < 40;

            # copy bind to be able to clean the array reference
            my @BindCopy = @Bind;

            $SQL .= 'SELECT * FROM dual';

            my %Row = (
                SQL  => $SQL,
                Bind => \@BindCopy,
            );

            push @{ $Param{SQLs} }, \%Row;

            # clean variable
            $SQL     = '';
            @Bind    = ();
            $Counter = 0;
        }

        if ( $SQL && @Bind ) {

            $SQL .= 'SELECT * FROM dual';

            my %Row = (
                SQL  => $SQL,
                Bind => \@Bind,
            );

            push @{ $Param{SQLs} }, \%Row;
        }

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
                $Value = MIME::Base64::encode_base64(
                    $StorableObject->Serialize( Data => $Value )
                );
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
