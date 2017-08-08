# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CommunicationLog::LogModule::Base;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::DateTime',
);

=head1 NAME

Kernel::System::CommunicationLog::LogModule::Base - base class for communication log modules

=head1 DESCRIPTION

This is a base class for communication log modules and should not be instantiated directly.

    package Kernel::System::CommunicationLog::LogModule::MyLogModule;
    use strict;
    use warnings;

    use parent qw(Kernel::System::CommunicationLog::LogModule::Base);

    # methods go here

=cut

=head1 PUBLIC INTERFACE

=head2 new()

Do not instantiate this class, instead use the real communication log classes.
Also, don't use the constructor directly, use the ObjectManager instead:

    my $SpecificLogModuleObject = $Kernel::OM->Get('Kernel::System::CommunicationLog::LogModule::MyLogModule');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Die if someone tries to instantiate the base class.
    if ( $Type eq __PACKAGE__ ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            'Priority' => 'Error',
            'Message'  => 'CommunicationLog::LogModule::Base, Instantiation not allowed, use it only as base class.',
        );
        return;
    }

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 ObjectLogStart()

Start the logging for a specific communication object.

    my $ObjectID = $LogModuleObject->ObjectLogStart(
        CommunicationID => 123,          # (required) The CommunicationID of the related ongoing communication.
        ObjectType      => 'Connection', # (required) Must be 'Connection' or 'Message'.
        Status          => 'Processing', # (optional) Needs to be either 'Successful', 'Processing' or 'Failed'
    );

=cut

sub ObjectLogStart {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(CommunicationID ObjectType)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    $Param{Status} //= 'Processing';

    # Check if is a valid status.
    return if !$Self->_IsValidStatus(%Param);

    my $RandomString = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
        Length => 32,
    );
    my $InsertFingerprint = $$ . '-' . $RandomString;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $Result = $DBObject->Do(
        SQL => '
            INSERT INTO communication_log_object (
                insert_fingerprint, communication_id, object_type, status, start_time
            )
            VALUES ( ?, ?, ?, ?, current_timestamp )
        ',
        Bind => [
            \$InsertFingerprint,
            \$Param{CommunicationID},
            \$Param{ObjectType},
            \$Param{Status},
        ],
    );

    if ( !$Result ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => sprintf(
                q{Error while starting object type '%s' for CommunicationID '%s'},
                $Param{ObjectType},
                $Param{CommunicationID},
            ),
        );

        return;
    }

    # get communication id
    return if !$DBObject->Prepare(
        SQL => 'SELECT id FROM communication_log_object
            WHERE insert_fingerprint = ?
            ORDER BY id DESC',
        Bind  => [ \$InsertFingerprint ],
        Limit => 1,
    );

    my $ObjectID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ObjectID = $Row[0];
    }

    # return if there is not article created
    if ( !$ObjectID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't get ObjectID from object log start with CommunicationID '$Param{CommunicationID}'!",
        );
        return;
    }

    return $ObjectID;
}

=head2 ObjectLogStop()

Stop the logging for a specific communication object.

    my $Result = $LogModuleObject->ObjectLogStop(
        CommunicationID => 123,  # (required) The CommunicationID of the related ongoing communication.
        ObjectID        => 234,  # (required) The ObjectID to be used
        ObjectType      => 'Connection',                        # (required) Must be 'Connection' or 'Message'.
        Status          => 'Processing',                        # (optional) Needs to be either 'Successful', 'Processing' or 'Failed'
    );

=cut

sub ObjectLogStop {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(ObjectID CommunicationID ObjectType Status)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # Check if is a valid status.
    return if !$Self->_IsValidStatus(%Param);

    my $Result = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            UPDATE communication_log_object
            SET status = ?, end_time = current_timestamp
            WHERE id = ? and communication_id = ? and object_type = ?
        ',
        Bind => [
            \$Param{Status},
            \$Param{ObjectID},
            \$Param{CommunicationID},
            \$Param{ObjectType},
        ],
    );

    if ( !$Result ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => sprintf(
                q{Error while stopping object '%s' (%s) for Communication '%s'},
                $Param{ObjectID},
                $Param{ObjectType},
                $Param{CommunicationID},
            ),
        );

        return;
    }

    return 1;
}

=head2 ObjectLog()

Create a log entry for the specific communication object.

    my $Result = $LogModuleObject->ObjectLog(
        CommunicationID => '...',
        ObjectID        => '...',
        Key             => '...',
        Value           => '...',
        Priority        => '...',
    );

=cut

sub ObjectLog {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(ObjectID Key Value)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    $Param{Priority} //= 'Info';

    # Check is priority if valid.
    my %ValidPriorities = (
        Error  => 1,
        Warn   => 1,
        Notice => 1,
        Info   => 1,
        Debug  => 1,
        Trace  => 1,
    );
    if ( !$ValidPriorities{ $Param{Priority} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => sprintf( q{Invalid Priority '%s'!}, $Param{Priority} ),
        );
        return;
    }

    # Insert log in database.
    my $Result = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            INSERT INTO communication_log_object_entry (
                communication_log_object_id, log_key, log_value, priority, create_time )
            VALUES ( ?, ?, ?, ?, current_timestamp )
        ',
        Bind => [
            \$Param{ObjectID}, \$Param{Key}, \$Param{Value}, \$Param{Priority},
        ],
    );

    if ( !$Result ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => sprintf(
                q{Error while creating log for Communication object '%s': Key: %s, Value: %s, Priority: %s},
                $Param{ObjectID},
                $Param{Key},
                $Param{Value},
                $Param{Priority},
            ),
        );

        return;
    }

    return 1;
}

=head2 ObjectLogList()

Get the logging list for a specific communication.

    my $Result = $LogModuleObject->ObjectLogList(
        CommunicationID  => '...',
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
        OrderBy          => 'Down',  # (optional) Down|Up; Default: Down
        SortBy           => 'LogID',    # (optional) ObjectID|ObjectType|ObjectStartTime|ObjectEndTime|ObjectStatus|LogID|LogKey|LogPriority|LogCreateTime; Default: LogID
    );

=cut

sub ObjectLogList {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(CommunicationID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my @SQL = (
        'SELECT clo.id, clo.communication_id, clo.object_type, clo.status, clo.start_time, clo.end_time',
        ',cloe.id, cloe.log_key, cloe.log_value, cloe.priority, cloe.create_time',
        'FROM communication_log_object clo JOIN communication_log_object_entry cloe',
        'ON cloe.communication_log_object_id = clo.id',
    );

    # prepare possible where clause
    my @FilterFields = (' clo.communication_id = ? ');
    my @Bind         = ( \$Param{CommunicationID} );

    my @PossibleFilters = (
        {
            Param  => 'ObjectID',
            DBName => 'clo.id'
        },
        {
            Param  => 'ObjectType',
            DBName => 'clo.object_type'
        },
        {
            Param  => 'ObjectStartTime',
            DBName => 'clo.start_time'
        },
        {
            Param  => 'ObjectEndTime',
            DBName => 'clo.end_time'
        },
        {
            Param  => 'ObjectStatus',
            DBName => 'clo.status'
        },
        {
            Param  => 'LogID',
            DBName => 'cloe.id'
        },
        {
            Param  => 'LogKey',
            DBName => 'cloe.log_key'
        },
        {
            Param  => 'LogValue',
            DBName => 'cloe.log_value'
        },
        {
            Param  => 'LogPriority',
            DBName => 'cloe.priority'
        },
        {
            Param  => 'LogCreateTime',
            DBName => 'cloe.create_time'
        },
    );

    my %OrderByMap = map { $_->{Param} => $_->{DBName} } @PossibleFilters;
    delete $OrderByMap{LogValue};

    for my $PossibleFilter (@PossibleFilters) {
        my $Value = $Param{ $PossibleFilter->{Param} };
        if ($Value) {
            push @FilterFields, sprintf( ' (%s = ?) ', $PossibleFilter->{DBName} );
            push @Bind, \$Value;
        }
    }

    if (@FilterFields) {
        push @SQL, 'WHERE';
        push @SQL, join( ' AND ', @FilterFields );
    }

    # Very flexibile Filters. (HOLD)
    #my $Conditions = $Param{Conditions} || [];
    #push @{$Conditions}, 'CommunicationID' => $Param{CommunicationID};

    #my ( $SQLWhere, $Bind ) = $Self->_LogListWhereClause( Conditions => $Conditions );

    #if ($SQLWhere) {
    #    push @SQL, 'WHERE', $SQLWhere;
    #}

    my $SortBy = $OrderByMap{ $Param{SortBy} || 'LogID' };
    my $OrderBy = $Param{OrderBy} && lc $Param{OrderBy} eq 'up' ? 'ASC' : 'DESC';

    push @SQL, "ORDER BY $SortBy $OrderBy";

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL   => join( q{ }, @SQL ),
        Bind  => \@Bind,
        Limit => $Param{Limit},
    );

    my @List = ();
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @List, {
            ObjectID        => $Row[0],
            CommunicationID => $Row[1],
            ObjectType      => $Row[2],
            ObjectStatus    => $Row[3],
            ObjectStartTime => $Row[4],
            ObjectEndTime   => $Row[5],
            LogID           => $Row[6],
            LogKey          => $Row[7],
            LogValue        => $Row[8],
            LogPriority     => $Row[9],
            LogCreateTime   => $Row[10],
        };
    }

    return \@List;
}

=head2 ObjectGet()

Returns the Communication Object by ID

    my $Result = $LogModuleObject->ObjectGet(
        CommunicationID  => '...',
        ID               => '...',
    );

=cut

sub ObjectGet {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(CommunicationID ID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $Result = $Self->ObjectList(
        CommunicationID => $Param{CommunicationID},
        ID              => $Param{ID}
    );

    return $Result->[0] if IsArrayRefWithData($Result);

    return;
}

=head2 ObjectLogDelete()

Delete the logging for a specific communication.

    my $Result = $LogModuleObject->ObjectLogDelete(
        CommunicationID => '...',
        ObjectID        => '...',    # optional
        Status          => '...',    # optional
        Key             => '...',    # optional
    );

=cut

sub ObjectLogDelete {
    my ( $Self, %Param ) = @_;

    if ( !$Param{CommunicationID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need CommunicationID!",
        );
        return;
    }

    my $ExecDeleteStmt = sub {
        my %LocalParam = @_;

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Result   = $DBObject->Do(
            SQL  => $LocalParam{SQL},
            Bind => $LocalParam{Bind},
        );
        if ( !$Result ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $LocalParam{ErrorMessage},
            );
        }

        return 1;
    };

    if ( $Param{Key} ) {

        # Only delete the communication_object_log that has this key.
        return if !$ExecDeleteStmt->(
            SQL => '
                DELETE FROM communication_log_object_entry
                WHERE communication_log_object_id IN (
                    SELECT id FROM communication_log_object clo
                    WHERE clo.communication_id = ?
                )
                AND log_key = ?
            ',
            Bind => [
                \$Param{CommunicationID}, \$Param{Key},
            ],
            ErrorMessage => sprintf(
                q{Error while deleting log for Communication object '%s': Key: %s},
                $Param{CommunicationID},
                $Param{Key},
            ),
        );

        return 1;
    }

    if ( $Param{Status} ) {

        # DELETE communication_object that has this status and all its logs.

        # Delete all communication-log-object logging entries.
        return if !$ExecDeleteStmt->(
            SQL => '
                DELETE FROM communication_log_object_entry
                WHERE communication_log_object_id IN (
                    SELECT id FROM communication_log_object WHERE status = ? AND communication_id = ?
                )
            ',
            Bind => [
                \$Param{Status}, \$Param{CommunicationID},
            ],
            ErrorMessage => sprintf(
                q{Error while deleting log for Communication log '%s' with Status '%s'!},
                $Param{CommunicationID},
                $Param{Status},
            ),
        );

        # Delete lookup information.
        return if !$ExecDeleteStmt->(
            SQL => '
                DELETE FROM communication_log_obj_lookup
                WHERE communication_log_object_id IN (
                    SELECT id FROM communication_log_object WHERE status = ? AND communication_id = ?
                )
            ',
            Bind => [
                \$Param{Status}, \$Param{CommunicationID},
            ],
            ErrorMessage => sprintf(
                q{Error while deleting lookup for Communication log '%s' with Status '%s'!},
                $Param{CommunicationID},
                $Param{Status},
            ),
        );

        # Delete all communication_objects.
        return if !$ExecDeleteStmt->(
            SQL => '
                DELETE FROM communication_log_object
                WHERE status = ? and communication_id = ?
            ',
            Bind => [
                \$Param{Status}, \$Param{CommunicationID},
            ],
            ErrorMessage => sprintf(
                q{Error while deleting objects for Communication id '%s': Status: '%s'},
                $Param{CommunicationID}, $Param{Status},
            ),
        );

        return 1;
    }

    if ( $Param{ObjectID} ) {

        # Delete all the Logs of the Object.
        return if !$ExecDeleteStmt->(
            SQL => '
                DELETE FROM communication_log_object_entry
                WHERE communication_log_object_id = ?
            ',
            Bind => [
                \$Param{ObjectID},
            ],
            ErrorMessage => sprintf(
                q{<>Error while deleting log for Communication object id '%s'},
                $Param{ObjectID}
            ),
        );

        # Delete lookup information.
        return if !$ExecDeleteStmt->(
            SQL => '
                DELETE FROM communication_log_obj_lookup
                WHERE communication_log_object_id = ?
            ',
            Bind         => [ \$Param{ObjectID}, ],
            ErrorMessage => sprintf(
                q{Error while deleting lookup for Communication log '%s' with Status '%s'!},
                $Param{ObjectID},
            ),
        );

        # Delete the Object itself.
        return if !$ExecDeleteStmt->(
            SQL => '
                DELETE FROM communication_log_object
                WHERE id = ?
            ',
            Bind         => [ \$Param{ObjectID}, ],
            ErrorMessage => sprintf(
                q{Error while deleting object '%s' with Communication id '%s'.},
                $Param{ObjectID}, $Param{CommunicationID},
            ),
        );

        return 1;
    }

    # Delete all communication objects and their logs.

    # Delete all communication log entries.
    return if !$ExecDeleteStmt->(
        SQL => '
            DELETE FROM communication_log_object_entry
            WHERE communication_log_object_id IN (
                SELECT id FROM communication_log_object WHERE communication_id = ?
            )
        ',
        Bind         => [ \$Param{CommunicationID} ],
        ErrorMessage => sprintf(
            q{Error while deleting log for Communication ID '%s'},
            $Param{CommunicationID},
        ),
    );

    # Delete lookup information.
    return if !$ExecDeleteStmt->(
        SQL => '
            DELETE FROM communication_log_obj_lookup
            WHERE communication_log_object_id IN (
                SELECT id FROM communication_log_object WHERE communication_id = ?
            )
        ',
        Bind         => [ \$Param{CommunicationID}, ],
        ErrorMessage => sprintf(
            q{Error while deleting lookup for Communication ID '%s'!},
            $Param{CommunicationID},
        ),
    );

    # Delete all communication_objects.
    return if !$ExecDeleteStmt->(
        SQL => '
            DELETE FROM communication_log_object
            WHERE communication_id = ?
        ',
        Bind => [
            \$Param{CommunicationID},
        ],
        ErrorMessage => sprintf(
            q{Error while deleting objects for Communication ID '%s'},
            $Param{CommunicationID},
        ),
    );

    return 1;
}

=head2 ObjectList()

Get the object list for a specific communication.

    my $Result = $LogModuleObject->ObjectList(
        CommunicationID  => '123',         # (optional)
        ID               => '123',         # (optional)
        Type             => 'Connection',  # (optional)
        StartDate        => '2017-07-03',  # (optional) List communications starting from the given date.
        StartTime        => '2017-07-03',  # (optional)
        EndTime          => '2017-07-03',  # (optional)
        Status           => 'Successful',  # (optional)
        OrderBy          => 'Down',        # (optional) Down|Up; Default: Down
        SortBy           => 'ID',          # (optional) ID|CommunicationID|ObjectType|StartTime|EndTime|Status|Duration, default: ID
    );

Returns:

    $Result = [
        {
            ID              => '19',
            CommunicationID => '11',
            Status          => 'Successful',
            ObjectType      => 'Connection',
            StartTime       => '2017-07-20 10:50:22',
            EndTime         => '2017-07-20 10:50:22',
            Duration        => '0',
        },
        {
            ID              => '18',
            CommunicationID => '11',
            ObjectType      => 'Message',
            Status          => 'Successful',
            StartTime       => '2017-07-20 10:50:21',
            EndTime         => '2017-07-20 10:50:22',
            Duration        => '1',
        },
    ];

=cut

sub ObjectList {
    my ( $Self, %Param ) = @_;

    my @SQL = (
        'SELECT clo.id, clo.communication_id, clo.object_type, clo.status,
            clo.start_time, clo.end_time, clo.end_time - clo.start_time',
        'FROM communication_log_object clo',
    );

    # prepare possible where clause
    my @FilterFields;
    my @Bind;

    my @PossibleFilters = (
        {
            Param  => 'ID',
            DBName => 'clo.id'
        },
        {
            Param  => 'CommunicationID',
            DBName => 'clo.communication_id'
        },
        {
            Param  => 'ObjectType',
            DBName => 'clo.object_type'
        },
        {
            Param  => 'StartTime',
            DBName => 'clo.start_time'
        },
        {
            Param  => 'EndTime',
            DBName => 'clo.end_time'
        },
        {
            Param  => 'Duration',
            DBName => 'clo.end_time - clo.start_time'
        },
        {
            Param  => 'Status',
            DBName => 'clo.status'
        },
    );

    my %OrderByMap = map { $_->{Param} => $_->{DBName} } @PossibleFilters;

    if ( $Param{StartDate} ) {

        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{StartDate},
            },
        );

        if ($DateTimeObject) {
            push @FilterFields, ' (clo.start_time >= ?) ';
            push @Bind,         \$Param{StartDate};
        }
    }

    for my $PossibleFilter (@PossibleFilters) {
        my $Value = $Param{ $PossibleFilter->{Param} };
        if ($Value) {
            push @FilterFields, sprintf( ' (%s = ?) ', $PossibleFilter->{DBName} );
            push @Bind, \$Value;
        }
    }

    if (@FilterFields) {
        push @SQL, 'WHERE';
        push @SQL, join( ' AND ', @FilterFields );
    }

    my $SortBy = $OrderByMap{ $Param{SortBy} || 'ID' };
    my $OrderBy = $Param{OrderBy} && lc $Param{OrderBy} eq 'up' ? 'ASC' : 'DESC';

    push @SQL, "ORDER BY $SortBy $OrderBy";

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    return if !$DBObject->Prepare(
        SQL   => join( q{ }, @SQL ),
        Bind  => \@Bind,
        Limit => $Param{Limit},
    );

    my @List = ();
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # Depending on the database backend will return duration in a different format.
        #   Normalize the value in seconds.
        my $Duration = $Self->_NormalizeDuration( Duration => $Row[6] );

        push @List, {
            ID              => $Row[0],
            CommunicationID => $Row[1],
            ObjectType      => $Row[2],
            Status          => $Row[3],
            StartTime       => $Row[4],
            EndTime         => $Row[5],
            Duration        => $Row[5] ? $Duration : undef,
        };
    }

    return \@List;
}

=head2 ObjectLookupSet()

Inserts or updates a lookup information.

    my $Result = $LogModuleObject->ObjectLookupSet(
        ObjectID         => '123',     # (required)
        TargetObjectType => 'Article', # (required)
        TargetObjectID   => '123',     # (required)
    );

Returns:

    1 in case of success, <undef> in case of errors

=cut

sub ObjectLookupSet {
    my ( $Self, %Param ) = @_;

    # Check for required arguments.
    for my $Argument (qw(ObjectID TargetObjectType TargetObjectID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $SQL = '
        INSERT INTO communication_log_obj_lookup (communication_log_object_id, object_type, object_id)
        VALUES (?, ?, ?)
    ';

    my @Bind = (
        \$Param{ObjectID},
        \$Param{TargetObjectType},
        \$Param{TargetObjectID},
    );

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Check if the record already exists.
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id FROM communication_log_obj_lookup
            WHERE object_type = ? AND object_id = ?
        ',
        Bind  => [ \$Param{TargetObjectType}, \$Param{TargetObjectID}, ],
        Limit => 1,
    );

    if ( my @Row = $DBObject->FetchrowArray() ) {

        # Record already exists, lets just update it.
        $SQL = '
            UPDATE communication_log_obj_lookup
            SET communication_log_object_id = ?
            WHERE object_type = ? AND object_id = ?
        ';
    }

    return if !$DBObject->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    return 1;
}

=head2 ObjectLookupSearch()

Get a list of the objects lookup information.

    my $List = $LogModuleObject->ObjectLookupSearch(
        ObjectID         => '123',     # (optional)
        ObjectType       => 'Message', # (optional)
        TargetObjectType => 'Article', # (optional)
        TargetObjectID   => '123',     # (optional)
        CommunicationID  => '123',     # (optional)
    );

Returns:

    <undef> - if any error occur
    An arrayref of object lookup - in case of success
    $List = [
        {
            ObjectID         => '...',
            TargetObjectType => '...',
            TargetObjectID   => '...',
        },
        ...
    ];

=cut

sub ObjectLookupSearch {
    my ( $Self, %Param ) = @_;

    my @SQL = (
        'SELECT clol.communication_log_object_id, clol.object_type, clol.object_id',
        'FROM communication_log_obj_lookup clol',
        '   JOIN communication_log_object clo ON clol.communication_log_object_id = clo.id'
    );

    my %PossibleFilters = (
        ObjectID         => 'clol.communication_log_object_id',
        ObjectType       => 'clo.object_type',
        TargetObjectType => 'clol.object_type',
        TargetObjectID   => 'clol.object_id',
        CommunicationID  => 'clo.communication_id',
    );

    my @FilterFields = ();
    my @Bind         = ();

    POSSIBLE_FILTER:
    for my $PossibleFilter ( sort keys %PossibleFilters ) {
        my $Value = $Param{$PossibleFilter};
        if ( !defined $Value || !length $Value ) {
            next POSSIBLE_FILTER;
        }

        my $FilterDBName = $PossibleFilters{$PossibleFilter};

        push @FilterFields, sprintf( '(%s = ?)', $FilterDBName );
        push @Bind, \$Value;
    }

    if (@FilterFields) {
        my $FilterSQL = join ' AND ', @FilterFields;
        push @SQL, 'WHERE', $FilterSQL;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    return if !$DBObject->Prepare(
        SQL   => join( ' ', @SQL ),
        Bind  => \@Bind,
        Limit => $Param{Limit},
    );

    my @List = ();
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @List, {
            ObjectID         => $Row[0],
            TargetObjectType => $Row[1],
            TargetObjectID   => $Row[2],
        };
    }

    return \@List;
}

=head2 ObjectLookupGet()

Gets the object lookup information.

    my $Result = $LogModuleObject->ObjectLookupGet(
        ObjectID         => '123',         # (optional)
        TargetObjectID   => '123',         # (optional)
        TargetObjectType => '123',         # (optional)
    );

Returns:

    $Result = {
        ObjectID         => '...',
        TargetObjectType => '...',
        TargetObjectID   => '...',
    }

    <undef> - if any error occur
    An hashref with object lookup information - in case info exists
    An empty hasref                           - in case info doesn't exists

=cut

sub ObjectLookupGet {
    my ( $Self, %Param ) = @_;

    # Check for required arguments.
    my @RequiredCombinations = (
        [qw( ObjectID TargetObjectType )],
        [qw( TargetObjectID TargetObjectType )],
    );

    my $MatchedCombination;
    REQUIRED_COMBINATION:
    for my $RequiredCombination (@RequiredCombinations) {
        $MatchedCombination = $RequiredCombination;
        for my $RequiredParam ( @{$RequiredCombination} ) {
            if ( !$Param{$RequiredParam} ) {
                $MatchedCombination = undef;
            }
        }

        last REQUIRED_COMBINATION if $MatchedCombination;
    }

    if ( !$MatchedCombination ) {
        my @ErrorMessage = (
            'Need',
            ( join ' OR ', map { join ' and ', @{$_} } @RequiredCombinations ),
            '!',
        );

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => ( join ' ', @ErrorMessage ),
        );
        return;
    }

    my $List = $Self->ObjectLookupSearch(
        CommunicationID => $Param{CommunicationID},
        map { $_ => $Param{$_} } @{$MatchedCombination},
    );

    if ($List) {
        return $List->[0] if IsArrayRefWithData($List);
        return {};    # Record not found.
    }

    return;           # Some error occurred.
}

=head2 GetConnectionsObjectsAndCommunications()

Method specifically created for optimization purposes for the Support Data Collector.
Joins the Communication Log Object and Communications.

Must be given a Start Date.

Returns Array of Hashes.

=cut

sub GetConnectionsObjectsAndCommunications {
    my ( $Self, %Param ) = @_;

    if ( !$Param{StartDate} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need StartDate!",
        );
        return;
    }

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Param{StartDate},
        },
    );

    return if !$DateTimeObject;

    my $SQL = "SELECT c.id, clo.status, c.account_type, c.account_id
FROM communication_log_object clo
JOIN communication_log c on c.id = clo.communication_id
WHERE clo.object_type = 'Connection' AND clo.start_time >= ?";

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Bind  => [ \$Param{StartDate} ],
        Limit => $Param{Limit},
    );

    my @List = ();
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @List, {
            CommunicationID => $Row[0],
            Status          => $Row[1],
            AccountType     => $Row[2],
            AccountID       => $Row[3],
        };
    }

    return \@List;

}

=head2 PRIVATE INTERFACE

Private methods

=cut

=head2 _IsValidStatus()

Check if the given status is valid.

    my $Result = $LogModuleObject->_IsValidStatus(
        Status => '...',
    );

=cut

sub _IsValidStatus {
    my ( $Self, %Param ) = @_;

    my $Status    = $Param{Status};
    my %StatusMap = (
        Successful => 1,
        Processing => 1,
        Warning    => 1,
        Failed     => 1,
    );

    if ( !$StatusMap{$Status} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Invalid Status '${ Status }'!",
        );
        return;
    }

    return 1;
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
        else {
            $Duration = 0;
        }
    }

    return $Duration;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
