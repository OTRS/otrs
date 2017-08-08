# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CommunicationLog;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our %ObjectManagerFlags = (
    NonSingleton            => 1,
    AllowConstructorFailure => 1,
);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::DB',
    'Kernel::System::DateTime',
    'Kernel::System::Main',
);

=head1 PUBLIC INTERFACE

=head2 new()

Creates a CommunicationLog object. Do not use new() directly, instead use the object manager.
This is a class which represents a complete communication. Therefore the created
instances must not be shared between processes of different communications.

Please use the object manager as follows for this class:

    # Create an object, representing a new communication:
    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Email',
            Direction => 'Incoming',
            Start     => 1 # (optional) Immediately start the communication after object creation (Status: Processing). Default: 0
        }
    );

    # Create an object for an already existing communication:
    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            CommunicationID => 123,
        }
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # indicates if a communication is already started
    $Self->{CommunicationStarted} = 0;

    if ( IsStringWithData( $Param{CommunicationID} ) || IsStringWithData( $Param{ObjectID} ) ) {
        delete $Param{Start};
        $Self->_RecoverCommunicationObject(%Param);
    }
    else {
        for my $Argument (qw(Transport Direction)) {
            if ( !$Param{$Argument} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Need $Argument!",
                );
                return;
            }
        }

        $Self->{Transport} = $Param{Transport};

        # validate given direction
        my %DirectionMap = (
            Incoming => 1,
            Outgoing => 1,
        );

        if ( !$DirectionMap{ $Param{Direction} } ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Direction needs to be either 'Incoming' or 'Outgoing'!",
            );
            return;
        }

        $Self->{Direction} = $Param{Direction};
    }

    # get the log module (driver) configuration
    my $LogModuleConfigs = $Kernel::OM->Get('Kernel::Config')->Get('CommunicationLog::LogModule');

    if ( !IsHashRefWithData($LogModuleConfigs) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Log module configurations not found!",
        );
        return;
    }

    if ( !IsHashRefWithData( $LogModuleConfigs->{ $Self->{Transport} } ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not determine log module configuration for module '$Self->{Transport}'!",
        );
        return;
    }

    # setup empty container for log modules instances
    $Self->{LogModule} = {};

    # check if the communication should be started immediately
    if ( $Param{Start} ) {
        $Self->CommunicationStart(
            AccountID   => $Param{AccountID},
            AccountType => $Param{AccountType},
            )
    }

    return $Self;
}

=head2 CommunicationStart()

Create a new communication entry.

    my $Success = $CommunicationLogObject->CommunicationStart(
        Status => 'Processing', # (optional) Needs to be either 'Successful', 'Processing', 'Warning' or 'Failed'
                                # In most of the cases, just 'Processing' will make sense at the very beginning
                                # of a communication (Default: 'Processing').
        AccountType =>          # (optional) The used account type
        AccountID   =>          # (optional) The used account id
    );

Returns:

    1 in case of success, 0 in case of errors

=cut

sub CommunicationStart {
    my ( $Self, %Param ) = @_;

    if ( $Self->{CommunicationStarted} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Communication with id '$Self->{CommunicationID}' is already started!",
        );
        return;
    }

    my %CommunicationData = $Self->CommunicationGet();

    if ( !$Self->{CommunicationStarted} && %CommunicationData ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Already closed communication with id '$Self->{CommunicationID}' cannot be restarted!",
        );
        return;
    }

    my %StatusMap = (
        Successful => 1,
        Processing => 1,
        Warning    => 1,
        Failed     => 1,
    );

    $Param{Status} //= 'Processing';

    if ( !$StatusMap{ $Param{Status} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Status needs to be either 'Successful', 'Processing' or 'Failed'!",
        );
        return;
    }

    my $RandomString = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
        Length => 32,
    );
    my $InsertFingerprint = $$ . '-' . $RandomString;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Do(
        SQL => '
            INSERT INTO communication_log
            (insert_fingerprint, transport, direction, status, account_type, account_id, start_time)
            VALUES ( ?, ?, ?, ?, ?, ?, current_timestamp )
        ',
        Bind => [
            \$InsertFingerprint,
            \$Self->{Transport},
            \$Self->{Direction},
            \$Param{Status},
            \$Param{AccountType},
            \$Param{AccountID},
        ],
    );

    # get communication id
    return if !$DBObject->Prepare(
        SQL => 'SELECT id FROM communication_log
            WHERE insert_fingerprint = ?
            ORDER BY id DESC',
        Bind  => [ \$InsertFingerprint ],
        Limit => 1,
    );

    my $CommunicationID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $CommunicationID = $Row[0];
    }

    # return if there is not article created
    if ( !$CommunicationID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't get CommunicationID from communication start!",
        );
        return;
    }

    # remember the new communication id
    $Self->{CommunicationID} = $CommunicationID;

    # mark communication as active
    $Self->{CommunicationStarted} = 1;

    # Remember status
    $Self->{Status} = $Param{Status};

    return $CommunicationID;
}

=head2 CommunicationStop()

Update the status of a communication entry.

    my $Success = $CommunicationLogObject->CommunicationStop(
        Status => 'Successful', # (required) Needs to be either 'Successful', 'Warning' or 'Failed'
    );

Returns:

    1 in case of success, 0 in case of errors

=cut

sub CommunicationStop {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(Status)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    if ( !$Self->{CommunicationStarted} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Communication with id '$Self->{CommunicationID}' is not started!",
        );
        return;
    }

    my %StatusMap = (
        Successful => 1,
        Warning    => 1,
        Failed     => 1,
    );

    if ( !$StatusMap{ $Param{Status} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Status needs to be either 'Successful' or 'Failed'!",
        );
        return;
    }

    # close open object types before
    for my $ObjectType ( sort keys %{ $Self->{Object} } ) {
        return if !$Self->ObjectLogStop( ObjectType => $ObjectType );
    }

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            UPDATE communication_log
            SET status = ?, end_time = current_timestamp
            WHERE id = ?
        ',
        Bind => [
            \$Param{Status}, \$Self->{CommunicationID},
        ],
    );

    # Remember status
    $Self->{Status} = $Param{Status};

    return 1;
}

=head2 CommunicationGet()

Get a communication entry data.

    my %CommunicationData = $CommunicationLogObject->CommunicationGet(
        CommunicationID => 123, # (optional) Default: The CommunicationID set in the object
    );

Returns:

    %CommunicationData = (
        CommunicationID => 123,
        Transport       => 'Email',
        Direction       => 'Incoming',
        Status          => 'Processing',
        StartTime       => '2017-05-31 09:26:20',
        EndTime         => '2017-05-31 09:30:15',
        Duration        => 235,
    );

=cut

sub CommunicationGet {
    my ( $Self, %Param ) = @_;

    $Param{CommunicationID} //= $Self->{CommunicationID};

    return if !$Param{CommunicationID};

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => 'SELECT c.id, c.transport, c.direction, c.status, c.account_type,
                       c.account_id, c.start_time, c.end_time, c.end_time - c.start_time
                FROM communication_log c
                WHERE c.id = ?',
        Bind  => [ \$Param{CommunicationID} ],
        Limit => 1,
    );

    if ( my @Row = $DBObject->FetchrowArray() ) {

        # Certain database backends might return duration as a formatted HH:MM:SS string.
        #   In this case, normalize the value in seconds.
        my $Duration = $Self->_NormalizeDuration( Duration => $Row[8] );

        return (
            CommunicationID => $Row[0],
            Transport       => $Row[1],
            Direction       => $Row[2],
            Status          => $Row[3],
            AccountType     => $Row[4],
            AccountID       => $Row[5],
            StartTime       => $Row[6],
            EndTime         => $Row[7],
            Duration        => $Row[7] ? $Duration : undef,
        );
    }

    return;
}

=head2 CommunicationGetByObjectID()

Get a communication entry data by a communication object id.

    my %CommunicationData = $CommunicationLogObject->CommunicationGetByObjectID(
        ObjectID => 123,
    );

Returns:

    %CommunicationData = (
        CommunicationID => 123,
        Transport       => 'Email',
        Direction       => 'Incoming',
        Status          => 'Processing',
        StartTime       => '2017-05-31 09:26:20',
        EndTime         => '2017-05-31 09:30:15',
    );

=cut

sub CommunicationGetByObjectID {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(ObjectID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => '
            SELECT c.id, c.transport, c.direction, c.status, c.account_type,
                   c.account_id, c.start_time, c.start_time, c.end_time
            FROM communication_log c
            JOIN communication_log_object clo ON clo.communication_id = c.id
            WHERE clo.id = ?
        ',
        Bind  => [ \$Param{ObjectID} ],
        Limit => 1,
    );

    if ( my @Row = $DBObject->FetchrowArray() ) {
        return (
            CommunicationID => $Row[0],
            Transport       => $Row[1],
            Direction       => $Row[2],
            Status          => $Row[3],
            AccountType     => $Row[4],
            AccountID       => $Row[5],
            StartTime       => $Row[6],
            EndTime         => $Row[7],
        );
    }

    return;
}

=head2 CommunicationList()

List communication entries. If parameters are given, the listing will be filtered,
otherwise all available entries will be returned.

    my @CommunicationList = $CommunicationLogObject->CommunicationList(
        Transport   => 'Email',      # (optional) Log type/transport/module
        Direction   => 'Incoming',   # (optional) 'Incoming' or 'Outgoing'
        Status      => 'Processing', # (optional) 'Successful', 'Processing' or 'Failed'
        Date        => '2017-07-03', # (optional) List communications just from the given date.
        StartDate   => '2017-07-03', # (optional) List communications starting from the given date.
        OlderThan   => '2017-07-03', # (optional) List communications older than the given date.
        Result      => 'ARRAY'       # (optional) Can be ARRAY or AVERAGE. ARRAY returns the results as
                                     #            an array while AVERAGE returns the communication average in seconds.
                                     #            Default: ARRAY
        OrderBy     => 'Down',       # (optional) Down|Up; Default: Down
        SortBy      => 'StartTime',  # (optional) Transport|Direction|Status|StartTime|EndTime|Duration, default: StartTime
        AccountType => 'POP3',       # (optional) The used account type
        AccountID   => 123,          # (optional) The used account id
    );

Returns:

    @CommunicationList = (
        {
            CommunicationID => 33,
            Transport       => 'Email',
            Direction       => 'Incoming',
            Status          => 'Failed',
            AccountType     => 'IMAPS',
            AccountID       => 1,
            StartTime       => '2017-07-20 08:57:56',
            EndTime         => '2017-07-20 08:57:57',
            Duration        => 1,
        },
        {
            CommunicationID => 34,
            Transport       => 'Email',
            Direction       => 'Outgoing',
            Status          => 'Successful',
            AccountType     => 'DoNotSendEmail',
            AccountID       => undef,
            StartTime       => '2017-07-20 08:58:43',
            EndTime         => '2017-07-20 08:58:49'
            Duration        => 6,
        },
    ];

=cut

sub CommunicationList {
    my ( $Self, %Param ) = @_;

    $Param{Result}  ||= 'ARRAY';
    $Param{OrderBy} ||= 'Down';
    $Param{SortBy}  ||= 'StartTime';

    my $SQL = '
        SELECT c.id, c.transport, c.direction, c.status, c.account_type, c.account_id,
               c.start_time, c.end_time, (c.end_time - c.start_time)
        FROM communication_log c
    ';

    # prepare possible where clause
    my @FilterFields;
    my @Bind;

    if ( $Param{Transport} ) {
        push @FilterFields, ' (c.transport = ?) ';
        push @Bind,         \$Param{Transport};
    }

    if ( $Param{Direction} ) {
        push @FilterFields, ' (c.direction = ?) ';
        push @Bind,         \$Param{Direction};
    }

    if ( $Param{Status} ) {
        push @FilterFields, ' (c.status = ?) ';
        push @Bind,         \$Param{Status};
    }

    if ( $Param{AccountType} ) {
        push @FilterFields, ' (c.account_type = ?) ';
        push @Bind,         \$Param{AccountType};
    }

    if ( $Param{AccountID} ) {
        push @FilterFields, ' (c.account_id = ?) ';
        push @Bind,         \$Param{AccountID};
    }

    if ( $Param{Date} ) {

        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{Date}
            },
        );

        if ($DateTimeObject) {
            my $NextDayObj = $DateTimeObject->Clone();
            $NextDayObj->Add( Days => 1 );

            push @FilterFields, ' (c.start_time BETWEEN ? and ?) ';
            push @Bind, \$DateTimeObject->Format( Format => '%Y-%m-%d' ), \$NextDayObj->Format( Format => '%Y-%m-%d' );
        }
    }

    if ( $Param{StartDate} ) {

        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{StartDate}
            },
        );

        if ($DateTimeObject) {
            push @FilterFields, ' (c.start_time >= ?) ';
            push @Bind,         \$Param{StartDate};
        }
    }

    if ( $Param{OlderThan} ) {

        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{OlderThan}
                }
        );

        if ($DateTimeObject) {
            push @FilterFields, ' (c.start_time < ?) ';
            push @Bind,         \$Param{OlderThan};
        }
    }

    if (@FilterFields) {
        $SQL .= ' WHERE ' . join ' AND ', @FilterFields;
    }

    my %OrderByMap = (
        Transport   => 'c.transport',
        Direction   => 'c.direction',
        Status      => 'c.status',
        AccountType => 'c.account_type',
        AccountID   => 'c.account_id',
        StartTime   => 'c.start_time',
        EndTime     => 'c.end_time',
        Duration    => 'c.end_time - c.start_time',
    );

    my $SortBy = $OrderByMap{ $Param{SortBy} } || 'c.status';
    my $OrderBy = lc $Param{OrderBy} eq 'up' ? 'ASC' : 'DESC';

    $SQL .= "ORDER BY $SortBy $OrderBy";

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my @CommunicationList;
    my $ProcessingTime = 0;

    while ( my @Row = $DBObject->FetchrowArray() ) {

        # Certain database backends might return duration as a formatted HH:MM:SS string.
        #   In this case, normalize the value in seconds.
        my $Duration = $Self->_NormalizeDuration( Duration => $Row[8] );

        push @CommunicationList, {
            CommunicationID => $Row[0],
            Transport       => $Row[1],
            Direction       => $Row[2],
            Status          => $Row[3],
            AccountType     => $Row[4],
            AccountID       => $Row[5],
            StartTime       => $Row[6],
            EndTime         => $Row[7],
            Duration        => $Row[7] ? $Duration : undef,
        };

        if ( $Param{Result} eq 'AVERAGE' && $Duration ) {
            $ProcessingTime += $Duration;
        }
    }

    # Compute average processing time by dividing sum of durations with number of communications.
    if ( $Param{Result} eq 'AVERAGE' ) {
        return 0 if !@CommunicationList;
        return sprintf( "%.1f", ( $ProcessingTime / scalar @CommunicationList ) );
    }

    return @CommunicationList;
}

=head2 CommunicationDelete()

Create a new log entry.

    my $Success = $CommunicationLogObject->CommunicationDelete(
        CommunicationID => 123, # (required)
    );

Returns:

    1 in case of success, 0 in case of errors

=cut

sub CommunicationDelete {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(CommunicationID)) {
        if ( !$Param{$Argument} ) {
            return {
                Status  => 'Failed',
                Message => "Need $Argument.",
            };
        }
    }

    if ( !$Self->ObjectLogDelete(%Param) ) {
        return {
            Status  => 'Failed',
            Message => "Could not delete depending object log entries for CommunicationID '$Param{CommunicationID}'!",
        };
    }

    my $Result = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => 'DELETE FROM communication_log
                WHERE id = ?',
        Bind => [
            \$Param{CommunicationID},
        ],
    );

    if ( !$Result ) {
        return {
            Status  => 'Failed',
            Message => "Could not delete Communication ID '$Param{CommunicationID}'",
            }
    }
    return { Status => 'Success' };
}

=head2 CommunicationIDGet()

Returns the communication id.

    my $CommunicationID = $CommunicationLogObject->CommunicationIDGet();

Returns:

The communication id of the current communication represented by this object.

=cut

sub CommunicationIDGet {
    my ( $Self, %Param ) = @_;

    return $Self->{CommunicationID};
}

=head2 TransportGet()

Returns the used transport.

    my $Transport = $CommunicationLogObject->TransportGet();

Returns:

The transport of the current communication represented by this object.

=cut

sub TransportGet {
    my ( $Self, %Param ) = @_;

    return $Self->{Transport};
}

=head2 DirectionGet()

Returns the used direction.

    my $Direction = $CommunicationLogObject->DirectionGet();

Returns:

The direction of the current communication represented by this object.

=cut

sub DirectionGet {
    my ( $Self, %Param ) = @_;

    return $Self->{Direction};
}

=head2 StatusGet()

Returns the current Status.

    my $Direction = $CommunicationLogObject->StatusGet();

Returns:

The status of the current communication represented by this object.

=cut

sub StatusGet {
    my ( $Self, %Param ) = @_;

    return $Self->{Status};
}

=head2 ObjectLogStart()

Starts a log object of a given object type.

    my $ObjectID = $CommunicationLogObject->ObjectLogStart(
        ObjectType => 'Connection' # (required) Can be 'Connection' or 'Message'
    );

Returns:

    1 in case of success, 0 in case of errors

=cut

sub ObjectLogStart {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(ObjectType)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    if ( !$Self->{CommunicationStarted} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "Communication with id '$Self->{CommunicationID}' needs to be started before starting a log object!",
        );
        return;
    }

    my %ObjectTypeMap = (
        Connection => 1,
        Message    => 1,
    );

    if ( !$ObjectTypeMap{ $Param{ObjectType} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "ObjectType needs to be either 'Connection' or 'Message'!",
        );
        return;
    }

    return if !$Self->_SetupLogModule();

    my $ObjectID = $Self->{LogModule}->{ $Self->{Transport} }->ObjectLogStart(
        CommunicationID => $Self->{CommunicationID},
        ObjectType      => $Param{ObjectType},
        %Param,
    );

    return if !$ObjectID;

    return $ObjectID;
}

=head2 ObjectLogStop()

Stops a log object of a given object type.

    my $Success = $CommunicationLogObject->ObjectLogStop(
        ObjectType => 'Connection'                        # (required) Can be 'Connection' or 'Message'
        ObjectID   => 123, # (required) The ObjectID of the started object type
    );

Returns:

    1 in case of success, 0 in case of errors

=cut

sub ObjectLogStop {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(ObjectType ObjectID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my %ObjectTypeMap = (
        Connection => 1,
        Message    => 1,
    );

    if ( !$ObjectTypeMap{ $Param{ObjectType} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "ObjectType needs to be either 'Connection' or 'Message'!",
        );
        return;
    }

    return if !$Self->_SetupLogModule();

    return if !$Self->{LogModule}->{ $Self->{Transport} }->ObjectLogStop(
        CommunicationID => $Self->{CommunicationID},
        ObjectID        => $Param{ObjectID},
        ObjectType      => $Param{ObjectType},
        %Param,
    );

    return 1;
}

=head2 ObjectLog()

Adds a log entry for a certain log object.

    my $Success = $CommunicationLogObject->ObjectLog(
        ObjectType => '...' # (required) To be defined by the related LogObject
        ObjectID   => 123, # (required) The ObjectID of the started object type
    );

Returns:

    1 in case of success, 0 in case of errors

=cut

sub ObjectLog {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(ObjectType ObjectID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my %ObjectTypeMap = (
        Connection => 1,
        Message    => 1,
    );

    if ( !$ObjectTypeMap{ $Param{ObjectType} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "ObjectType needs to be either 'Connection' or 'Message'!",
        );
        return;
    }

    return if !$Self->_SetupLogModule();

    return $Self->{LogModule}->{ $Self->{Transport} }->ObjectLog(
        CommunicationID => $Self->{CommunicationID},
        ObjectID        => $Param{ObjectID},
        ObjectType      => $Param{ObjectType},
        %Param,
    );
}

=head2 ObjectLogList()

List the log entries

    my $List = $CommunicationLogObject->ObjectLogList(
        ObjectID         => '...',   # optional
        ObjectType       => '...',   # optional
        ObjectStartTime  => '...',   # optional
        ObjectEndTime    => '...',   # optional
        ObjectStatus     => '...',   # optional
        LogID            => '...',   # optional
        LogKey           => '...',   # optional
        LogValue         => '...',   # optional
        LogPriority      => '...',   # optional
        LogCreateTime    => '...',   # optional
    );

Returns:

    <undef> - if any error occur
    An arrayref of object log entries - in case of success

=cut

sub ObjectLogList {
    my ( $Self, %Param ) = @_;

    return if !$Self->_SetupLogModule();

    return $Self->{LogModule}->{ $Self->{Transport} }->ObjectLogList(
        CommunicationID => $Self->{CommunicationID},
        %Param,
    );
}

=head2 ObjectLogDelete()

Delete log entries

    my $List = $CommunicationLogObject->ObjectLogDelete(
        CommunicationID => 123, # Either CommunicationID or ObjectID must be passed
        ObjectID        => 123,
    );

Returns:

    1 in case of success, 0 in case of errors

=cut

sub ObjectLogDelete {
    my ( $Self, %Param ) = @_;

    return if !$Self->_SetupLogModule();

    return $Self->{LogModule}->{ $Self->{Transport} }->ObjectLogDelete(
        CommunicationID => $Self->{CommunicationID},
        %Param
    );
}

=head2 ObjectGet()

Get the information relative to a communication object.

=cut

sub ObjectGet {
    my ( $Self, %Param ) = @_;

    return if !$Self->_SetupLogModule();

    return $Self->{LogModule}->{ $Self->{Transport} }->ObjectGet(
        CommunicationID => $Self->{CommunicationID},
        %Param,
    );
}

=head2 ObjectList()

List the objects information relative to a communication.

=cut

sub ObjectList {
    my ( $Self, %Param ) = @_;

    return if !$Self->_SetupLogModule();

    return $Self->{LogModule}->{ $Self->{Transport} }->ObjectList(
        CommunicationID => $Self->{CommunicationID},
        %Param,
    );
}

=head2 ObjectLookupSet()

Inserts or updates a lookup information.

    my $Result = $CommunicationLogObject->ObjectLookupSet(
        ObjectID         => 123,       # (required)
        TargetObjectType => 'Article', # (required)
        TargetObjectID   => 123,       # (required)
    );

Returns:

    <undef> - if any error occur
          1 - in case of success

=cut

sub ObjectLookupSet {
    my ( $Self, %Param ) = @_;

    return if !$Self->_SetupLogModule();

    return $Self->{LogModule}->{ $Self->{Transport} }->ObjectLookupSet(
        CommunicationID => $Self->{CommunicationID},
        %Param
    );
}

=head2 ObjectLookupSearch()

Get a list of the objects lookup information.

    my $List = $CommunicationLogObject->ObjectLookupSearch(
        ObjectID         => '123',     # (optional)
        ObjectType       => 'Message', # (optional)
        TargetObjectType => 'Article', # (optional)
        TargetObjectID   => '123',     # (optional)
        CommunicationID  => '123',     # (optional)
    );

Returns:

    <undef> - if any error occur
    An arrayref of object lookup - in case of success

=cut

sub ObjectLookupSearch {
    my ( $Self, %Param ) = @_;

    return if !$Self->_SetupLogModule();

    return $Self->{LogModule}->{ $Self->{Transport} }->ObjectLookupSearch(
        CommunicationID => $Self->{CommunicationID},
        %Param
    );
}

=head2 ObjectLookupGet()

Gets the object lookup information.

    my $Result = $CommunicationLogObject->ObjectLookupGet(
        TargetObjectID   => '...',
        TargetObjecttype => '...',
    );

Returns:

    <undef> - if any error occur
    An hashref with object lookup information - in case info exists
    An empty hasref                           - in case info doesn't exists

=cut

sub ObjectLookupGet {
    my ( $Self, %Param ) = @_;

    return if !$Self->_SetupLogModule();

    return $Self->{LogModule}->{ $Self->{Transport} }->ObjectLookupGet(
        CommunicationID => $Self->{CommunicationID},
        %Param
    );
}

=head2 GetConnectionsObjectsAndCommunications()

Method specifically created for optimization purposes for the Support Data Collector.
Relays the method for the specific LogModule Transport Module.

=cut

sub GetConnectionsObjectsAndCommunications {
    my ( $Self, %Param ) = @_;

    return if !$Self->_SetupLogModule();

    return $Self->{LogModule}->{ $Self->{Transport} }->GetConnectionsObjectsAndCommunications(
        %Param,
    );

}

=head2 ObjectAccountLinkGet()

Returns relative link information if AccountType and AccountID are present.

=cut

sub ObjectAccountLinkGet {
    my ( $Self, %Param ) = @_;

    return if !$Self->_SetupLogModule();

    return $Self->{LogModule}->{ $Self->{Transport} }->ObjectAccountLinkGet(%Param);
}

=head2 ObjectAccountLabelGet()

Returns related account label if AccountType and AccountID are present.

=cut

sub ObjectAccountLabelGet {
    my ( $Self, %Param ) = @_;

    return if !$Self->_SetupLogModule();

    return $Self->{LogModule}->{ $Self->{Transport} }->ObjectAccountLabelGet(%Param);
}

=head2 PRIVATE INTERFACE

Private methods

=cut

=head2 _SetupLogModule()

Setup the needed log module instance, based on the current transport.

=cut

sub _SetupLogModule {
    my ( $Self, %Param ) = @_;

    # get the communication log module (driver) configuration
    my $LogModuleConfigs = $Kernel::OM->Get('Kernel::Config')->Get('CommunicationLog::LogModule');
    my $LogModule        = $LogModuleConfigs->{ $Self->{Transport} }->{Module};

    # check if we already have a proper log module instance
    if (
        $Self->{LogModule}->{ $Self->{Transport} }
        && ref $Self->{LogModule}->{ $Self->{Transport} } eq $LogModule
        )
    {
        return 1;
    }

    $Self->{LogModule}->{ $Self->{Transport} } = $Kernel::OM->Get($LogModule);

    if ( !$Self->{LogModule}->{ $Self->{Transport} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Couldn't create a backend object for log module '$Self->{Transport}'!",
        );
        return;
    }

    if ( ref $Self->{LogModule}->{ $Self->{Transport} } ne $LogModule ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Object for log module backend '$Self->{Transport}' was not created successfuly!",
        );
        return;
    }

    return 1;
}

=head2 _RecoverCommunciationObject()

Recover a Communication object given an CommunicationID or ObjectID.

=cut

sub _RecoverCommunicationObject {
    my ( $Self, %Param ) = @_;

    my %CommunicationData = ();
    my $ErrorMessage      = "Could not restore the communication with %s '%s'!";

    if ( $Param{CommunicationID} ) {
        $ErrorMessage = sprintf $ErrorMessage, 'CommunicationID', $Param{CommunicationID};
        %CommunicationData = $Self->CommunicationGet(
            CommunicationID => $Param{CommunicationID},
        );
    }
    else {
        $ErrorMessage = sprintf $ErrorMessage, 'ObjectID', $Param{ObjectID};
        %CommunicationData = $Self->CommunicationGetByObjectID(
            ObjectID => $Param{ObjectID},
        );
    }

    if ( !%CommunicationData ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            'Priority' => 'Error',
            'Message'  => $ErrorMessage,
        );
        return;
    }

    $Self->{CommunicationID} = $CommunicationData{CommunicationID};
    $Self->{Transport}       = $CommunicationData{Transport};
    $Self->{Direction}       = $CommunicationData{Direction};
    $Self->{Status}          = $CommunicationData{Status};

    # Communication seems to be still active.
    if ( $CommunicationData{Status} eq 'Processing' ) {
        $Self->{CommunicationStarted} = 1;
    }

    return $Self;
}

=head2 _NormalizeDuration()

Normalize formatted duration string such as C<HH:MM:SS> in seconds.

=cut

sub _NormalizeDuration {
    my ( $Self, %Param ) = @_;

    my $Duration = $Param{Duration};

    my $DBType = $Kernel::OM->Get('Kernel::System::DB')->{'DB::Type'};

    # PostgreSQL will return duration values as HH:MM:SS formatted strings. Match the integers and calculate duration
    #   value in seconds.
    if ( $DBType eq 'postgresql' ) {
        if (
            !IsNumber($Duration)
            && $Duration
            && $Duration =~ m{^ (?<Hours> \d+ ) : (?<Minutes> \d+ ) : (?<Seconds> \d+ ) $}x
            )
        {
            $Duration = $+{Hours} * 60 * 60 + $+{Minutes} * 60 + $+{Seconds};
        }
    }

    # Oracle will return duration values in days. In this case, simply multiply by number of hours, minutes and seconds
    #   to get normalized value.
    elsif ( $DBType eq 'oracle' ) {
        if ( IsNumber($Duration) ) {
            $Duration *= 24 * 60 * 60;
        }

        # Oracle also likes to return undef instead of zero values, make sure to explicitly set it.
        else {
            $Duration = 0;
        }
    }

    return $Duration;
}

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
