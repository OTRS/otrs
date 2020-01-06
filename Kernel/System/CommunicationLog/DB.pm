# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::CommunicationLog::DB;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::DB',
    'Kernel::System::Main',
    'Kernel::System::DateTime',
);

=head1 NAME

Kernel::System::CommunicationLog::DB - Database interface to Communication Log

=head1 DESCRIPTION

Global module to handle all the Database operations for the Communication Log.

=head1 PUBLIC INTERFACE

=head2 new()

Create a Communication Log Database object. Do not use it directly, instead use:

    my $CommunicationDBObject = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 CommunicationCreate()

Create a new communication element.

    my $CommunicationID = $CommunicationDBObject->CommunicationCreate(
        Transport       => '...',
        Direction       => '...',
        Status          => '...',
        AccountType     => '...',
        AccountID       => '...',
    );

Returns the created ID.

=cut

sub CommunicationCreate {
    my ( $Self, %Param ) = @_;

    # Check for required data.
    for my $Argument (qw(Transport Direction Status)) {
        if ( !$Param{$Argument} ) {
            return $Self->_LogError("Need $Argument!");
        }
    }

    return if !$Self->_IsValidStatus( Status => $Param{Status} );

    return if !$Self->_IsValidDirection( Direction => $Param{Direction} );

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
            \$Param{Transport},
            \$Param{Direction},
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
        return $Self->_LogError("Could not create a Communication element.");
    }

    return $CommunicationID;
}

=head2 CommunicationUpdate()

Update Communication elements.

    my $Result = $CommunicationDBObject->CommunicationUpdate(
        CommunicationID => '...',
        Status         => '[Successful|Warning|Failed]',
    );

Returns 1 or undef.

=cut

sub CommunicationUpdate {
    my ( $Self, %Param, ) = @_;

    for my $Argument (qw(CommunicationID Status)) {
        if ( !$Param{$Argument} ) {
            return $Self->_LogError("Need $Argument!");
        }
    }

    # Check if is a valid status.
    return if !$Self->_IsValidStatus( Status => $Param{Status} );

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            UPDATE communication_log
            SET status = ?, end_time = current_timestamp
            WHERE id = ?
        ',
        Bind => [
            \$Param{Status}, \$Param{CommunicationID},
        ],
    );

    return 1;
}

=head2 CommunicationList()

List communication entries. If parameters are given, the listing will be filtered,
otherwise all available entries will be returned.

    my $CommunicationList = $CommunicationDBObject->CommunicationList(
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

    $CommunicationList = [
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

    my $DurationSQL = $Self->_DurationSQL(
        Start => 'c.start_time',
        End   => 'c.end_time'
    );
    my $SQL = "
        SELECT c.id, c.transport, c.direction, c.status, c.account_type, c.account_id,
               c.start_time, c.end_time, (${ DurationSQL })
        FROM communication_log c
    ";

    # prepare possible where clause
    my @FilterFields;
    my @Bind;

    if ( $Param{CommunicationID} ) {
        push @FilterFields, ' (c.id = ?) ';
        push @Bind,         \$Param{CommunicationID};
    }

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
        CommunicationID => 'c.id',
        Transport       => 'c.transport',
        Direction       => 'c.direction',
        Status          => 'c.status',
        AccountType     => 'c.account_type',
        AccountID       => 'c.account_id',
        StartTime       => 'c.start_time',
        EndTime         => 'c.end_time',
        Duration        => $DurationSQL,
    );

    my $SortBy  = $OrderByMap{ $Param{SortBy} } || 'c.status';
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

        my %Communication = (
            CommunicationID => $Row[0],
            Transport       => $Row[1],
            Direction       => $Row[2],
            Status          => $Row[3],
            AccountType     => $Row[4],
            AccountID       => $Row[5],
            StartTime       => $Row[6],
            EndTime         => $Row[7],
            Duration        => $Row[7] ? $Row[8] : undef,
        );

        push @CommunicationList, \%Communication;

        if ( $Param{Result} eq 'AVERAGE' && $Row[8] ) {
            $ProcessingTime += $Row[8];
        }
    }

    # Compute average processing time by dividing sum of durations with number of communications.
    if ( $Param{Result} eq 'AVERAGE' ) {
        return 0 if !@CommunicationList;
        return sprintf( "%.1f", ( $ProcessingTime / scalar @CommunicationList ) );
    }

    return \@CommunicationList;
}

=head2 CommunicationDelete()

Deletes a Communication entry if specified. Otherwise deletes all communications.

    my $Result = $CommunicationDBObject->CommunicationDelete(
        CommunicationID => 1,            # (optional) Communication ID
        Status          => 'Processing', # (optional) 'Successful', 'Processing' or 'Failed'
                                         # for example, using '!Processing', means different from
        Date            => '2017-07-03', # (optional) Delete communications just from the given date.
        OlderThan       => '2017-07-03', # (optional) Delete communications older than the given date.
    );

Returns:

    C<undef> - in case of error
    1        - in case of success

=cut

sub CommunicationDelete {
    my ( $Self, %Param ) = @_;

    my $SQL = 'DELETE FROM communication_log';

    # Prepare possible where clause.
    my @FilterFields;
    my @Bind;

    if ( $Param{CommunicationID} ) {
        push @FilterFields, ' (id = ?) ';
        push @Bind,         \$Param{CommunicationID};
    }

    if ( $Param{Status} ) {
        my $Operator = '=';
        my $Status   = $Param{Status};
        if ( substr( $Status, 0, 1 ) eq '!' ) {
            $Operator = '!=';
            $Status   = substr( $Status, 1, );
        }

        push @FilterFields, " (status ${ Operator } ?) ";
        push @Bind,         \$Status;
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

            push @FilterFields, ' (start_time BETWEEN ? and ?) ';
            push @Bind, \$DateTimeObject->Format( Format => '%Y-%m-%d' ), \$NextDayObj->Format( Format => '%Y-%m-%d' );
        }
    }

    if ( $Param{OlderThan} ) {

        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{OlderThan}
            },
        );

        if ($DateTimeObject) {
            push @FilterFields, ' (start_time < ?) ';
            push @Bind,         \$Param{OlderThan};
        }
    }

    # Delete communication dependencies.
    my $DependenciesDeleteResult = 1;
    if (@FilterFields) {
        my $Where = 'WHERE ' . join ' AND ', @FilterFields;
        $SQL .= " ${ Where }";

        $DependenciesDeleteResult = $Self->ObjectLogDelete(
            CommunicationFilters => {
                Where => $Where,
                Binds => \@Bind,
            },
        );
    }
    else {
        $DependenciesDeleteResult = $Self->ObjectLogDelete();
    }

    if ( !$DependenciesDeleteResult ) {
        $Self->_LogError( "Error deleting communication(s) dependencies!", );
        return;
    }

    # Delete the communication records.
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $Result   = $DBObject->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    if ( !$Result ) {
        $Self->_LogError( "Error deleting the communications: ${ SQL }", );
    }

    return 1;
}

=head2 CommunicationGet()

Get a communication entry data.

    my $CommunicationData = $CommunicationDBObject->CommunicationGet(
        CommunicationID => 123, # Required
    );

Returns:

    $CommunicationData = {
        CommunicationID => 123,
        Transport       => 'Email',
        Direction       => 'Incoming',
        Status          => 'Processing',
        StartTime       => '2017-05-31 09:26:20',
        EndTime         => '2017-05-31 09:30:15',
        Duration        => 235,
    };

=cut

sub CommunicationGet {
    my ( $Self, %Param, ) = @_;

    # Check for required data.
    if ( !$Param{CommunicationID} ) {
        return $Self->_LogError("Need CommunicationID!");
    }

    my $List = $Self->CommunicationList( CommunicationID => $Param{CommunicationID} );

    return $List->[0] if IsArrayRefWithData($List);

    return {};
}

=head2 CommunicationAccountLinkGet()

Get relative link information if AccountType and AccountID are present.

    my $ParamString = $CommunicationDBObject->CommunicationAccountLinkGet();

Returns something like this:

    $ParamString = "Action=AdminMailAccount;Subaction=Update;ID=2";

=cut

sub CommunicationAccountLinkGet {
    my ( $Self, %Param ) = @_;

    my $TransportModule = $Self->_GetTransportModule(%Param);
    return if !$TransportModule;

    return $TransportModule->CommunicationAccountLinkGet(%Param);
}

=head2 CommunicationAccountLabelGet()

Get related account label if AccountType and AccountID are present.

    my $AccountLabel = $CommunicationDBObject->CommunicationAccountLabelGet();

Returns something like this:

    $AccountLabel = "Example.com / Alice (IMAPS)";

=cut

sub CommunicationAccountLabelGet {
    my ( $Self, %Param ) = @_;

    my $TransportModule = $Self->_GetTransportModule(%Param);
    return if !$TransportModule;

    return $TransportModule->CommunicationAccountLabelGet(%Param);
}

=head2 ObjectLogCreate()

Creates the logging for a specific communication object.

    my $ObjectLogID = $CommunicationDBObject->ObjectLogCreate(
        CommunicationID => 123,          # (required) The CommunicationID of the related ongoing communication.
        ObjectLogType   => 'Connection', # (required) Must be 'Connection' or 'Message'.
        Status          => 'Processing', # (optional) Needs to be either 'Successful', 'Processing' or 'Failed'
    );

=cut

sub ObjectLogCreate {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(CommunicationID ObjectLogType)) {
        if ( !$Param{$Argument} ) {
            return $Self->_LogError("Need $Argument!");
        }
    }

    $Param{Status} //= 'Processing';

    # Check if is a valid status.
    return if !$Self->_IsValidStatus( Status => $Param{Status} );

    # Check if is a valid ObjectLogType.
    return if !$Self->_IsValidObjectLogType( ObjectLogType => $Param{ObjectLogType} );

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
            \$Param{ObjectLogType},
            \$Param{Status},
        ],
    );

    if ( !$Result ) {
        return $Self->_LogError(
            sprintf(
                q{Error while starting object log type '%s' for CommunicationID '%s'},
                $Param{ObjectLogType},
                $Param{CommunicationID},
            )
        );
    }

    # get communication id
    return if !$DBObject->Prepare(
        SQL => 'SELECT id FROM communication_log_object
            WHERE insert_fingerprint = ?
            ORDER BY id DESC',
        Bind  => [ \$InsertFingerprint ],
        Limit => 1,
    );

    my $ObjectLogID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ObjectLogID = $Row[0];
    }

    # return if there is not article created
    if ( !$ObjectLogID ) {
        return $Self->_LogError(
            "Can't get ObjectLogID from object log start with CommunicationID '$Param{CommunicationID}'!"
        );
    }

    return $ObjectLogID;
}

=head2 ObjectLogUpdate()

Stop the logging for a specific communication object.

    my $Result = $CommunicationDBObject->ObjectLogUpdate(
        CommunicationID => 123,             # (required) The CommunicationID of the related ongoing communication.
        ObjectLogID     => 234,             # (required) The ObjectLogID to be used
        ObjectLogType   => 'Connection',    # (required) Must be 'Connection' or 'Message'.
        Status          => 'Processing',    # (optional) Needs to be either 'Successful', 'Processing' or 'Failed'
    );

=cut

sub ObjectLogUpdate {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(ObjectLogID CommunicationID ObjectLogType Status)) {
        if ( !$Param{$Argument} ) {
            return $Self->_LogError("Need $Argument!");
        }
    }

    # Check if is a valid status.
    return if !$Self->_IsValidStatus( Status => $Param{Status} );

    # Check if is a valid ObjectLogType.
    return if !$Self->_IsValidObjectLogType( ObjectLogType => $Param{ObjectLogType} );

    my $Result = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            UPDATE communication_log_object
            SET status = ?, end_time = current_timestamp
            WHERE id = ? and communication_id = ? and object_type = ?
        ',
        Bind => [
            \$Param{Status},
            \$Param{ObjectLogID},
            \$Param{CommunicationID},
            \$Param{ObjectLogType},
        ],
    );

    if ( !$Result ) {
        return $Self->_LogError(
            sprintf(
                q{Error while stopping object '%s' (%s) for Communication '%s'},
                $Param{ObjectLogID},
                $Param{ObjectLogType},
                $Param{CommunicationID},
            )
        );
    }

    return 1;
}

=head2 ObjectLogList()

Get the object list for a specific communication.

    my $Result = $CommunicationDBObject->ObjectLogList(
        CommunicationID    => '123',         # (optional)
        ObjectLogID        => '123',         # (optional)
        ObjectLogType      => 'Connection',  # (optional)
        StartDate          => '2017-07-03',  # (optional) List communications starting from the given date.
        ObjectLogStartTime => '2017-07-03',  # (optional)
        ObjectLogEndTime   => '2017-07-03',  # (optional)
        ObjectLogStatus    => 'Successful',  # (optional)
        OrderBy            => 'Down',        # (optional) Down|Up; Default: Down
        SortBy             => 'ID',          # (optional) ID|CommunicationID|ObjectLogType|StartTime|EndTime|Status|Duration, default: ID
    );

Returns:

    $Result = [
        {
            ObjectLogID        => '19',
            CommunicationID    => '11',
            ObjectLogStatus    => 'Successful',
            ObjectLogType      => 'Connection',
            ObjectLogStartTime => '2017-07-20 10:50:22',
            ObjectLogEndTime   => '2017-07-20 10:50:22',
            ObjectLogDuration  => '0',
        },
        {
            ObjectLogID        => '18',
            CommunicationID    => '11',
            ObjectLogType      => 'Message',
            ObjectLogStatus    => 'Successful',
            ObjectLogStartTime => '2017-07-20 10:50:21',
            ObjectLogEndTime   => '2017-07-20 10:50:22',
            ObjectLogDuration  => '1',
        },
    ];

=cut

sub ObjectLogList {
    my ( $Self, %Param ) = @_;

    my $DurationSQL = $Self->_DurationSQL(
        Start => 'clo.start_time',
        End   => 'clo.end_time'
    );
    my @SQL = (
        "SELECT clo.id, clo.communication_id, clo.object_type, clo.status,
            clo.start_time, clo.end_time, (${ DurationSQL })",
        'FROM communication_log_object clo',
    );

    # prepare possible where clause
    my @FilterFields;
    my @Bind;

    my @PossibleFilters = (
        {
            Param  => 'ObjectLogID',
            DBName => 'clo.id'
        },
        {
            Param  => 'CommunicationID',
            DBName => 'clo.communication_id'
        },
        {
            Param  => 'ObjectLogType',
            DBName => 'clo.object_type'
        },
        {
            Param  => 'ObjectLogStartTime',
            DBName => 'clo.start_time'
        },
        {
            Param  => 'ObjectLogEndTime',
            DBName => 'clo.end_time'
        },
        {
            Param  => 'ObjectLogDuration',
            DBName => $DurationSQL,
        },
        {
            Param  => 'ObjectLogStatus',
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
            push @Bind,         \$Value;
        }
    }

    if (@FilterFields) {
        push @SQL, 'WHERE';
        push @SQL, join( ' AND ', @FilterFields );
    }

    my $SortBy  = $OrderByMap{ $Param{SortBy} || 'ObjectLogID' };
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
            ObjectLogID        => $Row[0],
            CommunicationID    => $Row[1],
            ObjectLogType      => $Row[2],
            ObjectLogStatus    => $Row[3],
            ObjectLogStartTime => $Row[4],
            ObjectLogEndTime   => $Row[5],
            ObjectLogDuration  => $Row[5] ? $Row[6] : undef,
        };
    }

    return \@List;
}

=head2 ObjectLogDelete()

Delete the logging.

    my $Result = $CommunicationDBObject->ObjectLogDelete(
        CommunicationID => '...',    # optional
        ObjectLogID     => '...',    # optional
        ObjectLogStatus => '...',    # optional
    );

=cut

sub ObjectLogDelete {
    my ( $Self, %Param ) = @_;

    my $ExecDeleteStmt = sub {
        my %LocalParam = @_;

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Result   = $DBObject->Do(
            SQL  => $LocalParam{SQL},
            Bind => $LocalParam{Bind},
        );

        if ( !$Result ) {
            $Self->_LogError( $LocalParam{ErrorMessage} );
            return;
        }

        return 1;
    };

    my %SQL = (
        Objects => {
            Stmt  => 'DELETE FROM communication_log_object',
            Binds => [],
        },
        Entries => {
            Stmt  => 'DELETE FROM communication_log_object_entry',
            Binds => [],
        },
        Lookup => {
            Stmt  => 'DELETE FROM communication_log_obj_lookup',
            Binds => [],
        },
    );
    my @DeleteOrder = qw( Lookup Entries Objects );
    my %DBNames     = (
        CommunicationID => 'communication_id',
        ObjectLogStatus => 'status',
        ObjectLogID     => {
            Objects => 'id',
            Default => 'communication_log_object_id',
        },
    );

    my @PossibleFilters = qw( CommunicationFilters CommunicationID ObjectLogStatus ObjectLogID );
    POSSIBLE_FILTER:
    for my $PossibleFilter (@PossibleFilters) {
        my $Value = $Param{$PossibleFilter};
        next POSSIBLE_FILTER if !( defined $Value ) || !( length $Value );

        ITEM:
        for my $Item (@DeleteOrder) {
            my $ItemSQL    = $SQL{$Item}->{Stmt};
            my $WhereORAnd = ( $ItemSQL =~ m/\s+where\s+/i ) ? 'AND' : 'WHERE';

            if ( $PossibleFilter eq 'CommunicationFilters' ) {
                my $CommunicationSELECT = 'SELECT id FROM communication_log ' . $Value->{Where};

                if ( $Item eq 'Objects' ) {
                    $ItemSQL .= " ${ WhereORAnd } communication_id IN (${ CommunicationSELECT })";
                }
                else {
                    $ItemSQL
                        .= " ${ WhereORAnd } communication_log_object_id IN (SELECT id FROM communication_log_object WHERE communication_id IN (${ CommunicationSELECT }))";
                }

                $SQL{$Item}->{Stmt} = $ItemSQL;
                push @{ $SQL{$Item}->{Binds} }, @{ $Value->{Binds} };

                next ITEM;
            }

            my $ColumnDBName = $DBNames{$PossibleFilter};
            if ( ref $ColumnDBName ) {
                $ColumnDBName = $ColumnDBName->{$Item} || $ColumnDBName->{Default};
            }

            if ( $Item eq 'Objects' ) {
                $ItemSQL .= " ${ WhereORAnd } ${ ColumnDBName } = ?";
            }
            else {
                $ItemSQL
                    .= " ${ WhereORAnd } communication_log_object_id IN (SELECT id FROM communication_log_object WHERE ${ ColumnDBName } = ?)";
            }

            $SQL{$Item}->{Stmt} = $ItemSQL;
            push @{ $SQL{$Item}->{Binds} }, \$Value;
        }
    }

    for my $Item ( sort keys %SQL ) {
        return if !$ExecDeleteStmt->(
            SQL  => $SQL{$Item}->{Stmt},
            Bind => $SQL{$Item}->{Binds},
            ErrorMessage =>
                sprintf(
                q{Error deleting communication log %s: %s},
                lc($Item),
                $SQL{$Item}->{Stmt},
                ),
        );
    }

    return 1;
}

=head2 ObjectLogGet()

Returns the Communication Log Object by ID

    my $Result = $CommunicationDBObject->ObjectLogGet(
        CommunicationID  => '...',
        ObjectLogID      => '...',
    );

    Returns something like:

    $Result = {
        ObjectLogID        => '18',
        CommunicationID    => '11',
        ObjectLogType      => 'Message',
        ObjectLogStatus    => 'Successful',
        ObjectLogStartTime => '2017-07-20 10:50:21',
        ObjectLogEndTime   => '2017-07-20 10:50:22',
        ObjectLogDuration  => '1',
    };

=cut

sub ObjectLogGet {

    my ( $Self, %Param ) = @_;

    for my $Argument (qw(ObjectLogID)) {
        if ( !$Param{$Argument} ) {
            return $Self->_LogError("Need $Argument!");
        }
    }

    my $Result = $Self->ObjectLogList(
        ObjectLogID => $Param{ObjectLogID},
    );

    return              if !$Result;
    return $Result->[0] if IsArrayRefWithData($Result);
    return {};
}

=head2 ObjectLogEntryCreate()

Create a log entry for the specific communication object.

    my $Result = $CommunicationDBObject->ObjectLogEntryCreate(
        ObjectLogID => '...', # required
        Key         => '...', # required
        Value       => '...', # required
        Priority    => '...', # required
    );

    Returns 1 on success.

=cut

sub ObjectLogEntryCreate {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(ObjectLogID Key Value Priority)) {
        if ( !$Param{$Argument} ) {
            return $Self->_LogError("Need $Argument!");
        }
    }

    # Check if priority is valid.
    my %ValidPriorities = (
        Error  => 1,
        Warn   => 1,
        Notice => 1,
        Info   => 1,
        Debug  => 1,
        Trace  => 1,
    );

    if ( !$ValidPriorities{ $Param{Priority} } ) {
        return $Self->_LogError( sprintf( q{Invalid Priority '%s'!}, $Param{Priority} ) );
    }

    # Insert log in database.
    my $Result = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            INSERT INTO communication_log_object_entry (
                communication_log_object_id, log_key, log_value, priority, create_time )
            VALUES ( ?, ?, ?, ?, current_timestamp )
        ',
        Bind => [
            \$Param{ObjectLogID}, \$Param{Key}, \$Param{Value}, \$Param{Priority},
        ],
    );

    if ( !$Result ) {
        return $Self->_LogError(
            sprintf(
                q{Error while creating log for Communication object '%s': Key: %s, Value: %s, Priority: %s},
                $Param{ObjectLogID},
                $Param{Key},
                $Param{Value},
                $Param{Priority},
            )
        );
    }

    return 1;
}

=head2 ObjectLogEntryList()

Get the logging list for a specific communication.

    my $Result = $CommunicationDBObject->ObjectLogEntryList(
        CommunicationID     => '...',
        ObjectLogID         => '...',   # optional
        ObjectLogType       => '...',   # optional
        ObjectLogStartTime  => '...',   # optional
        ObjectLogEndTime    => '...',   # optional
        ObjectLogStatus     => '...',   # optional
        LogID               => '...',   # optional
        LogKey              => '...',   # optional
        LogValue            => '...',   # optional
        LogPriority         => '...',   # optional
        LogCreateTime       => '...',   # optional
        OrderBy             => 'Down',  # (optional) Down|Up; Default: Down
        SortBy              => 'LogID',    # (optional) ObjectLogID|ObjectLogType|ObjectStartTime|ObjectEndTime|ObjectStatus|LogID|LogKey|LogPriority|LogCreateTime; Default: LogID
    );

=cut

sub ObjectLogEntryList {
    my ( $Self, %Param ) = @_;

    my @SQL = (
        'SELECT clo.id, clo.communication_id, clo.object_type, clo.status, clo.start_time, clo.end_time',
        ',cloe.id, cloe.log_key, cloe.log_value, cloe.priority, cloe.create_time',
        'FROM communication_log_object clo JOIN communication_log_object_entry cloe',
        'ON cloe.communication_log_object_id = clo.id',
    );

    # prepare possible where clause
    my @FilterFields = ();
    my @Bind         = ();

    my @PossibleFilters = (
        {
            Param  => 'CommunicationID',
            DBName => 'clo.communication_id'
        },
        {
            Param  => 'ObjectLogID',
            DBName => 'clo.id'
        },
        {
            Param  => 'ObjectLogType',
            DBName => 'clo.object_type'
        },
        {
            Param  => 'ObjectLogStartTime',
            DBName => 'clo.start_time'
        },
        {
            Param  => 'ObjectLogEndTime',
            DBName => 'clo.end_time'
        },
        {
            Param  => 'ObjectLogStatus',
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
            push @Bind,         \$Value;
        }
    }

    if (@FilterFields) {
        push @SQL, 'WHERE';
        push @SQL, join( ' AND ', @FilterFields );
    }

    my $SortBy  = $OrderByMap{ $Param{SortBy} || 'LogID' };
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
            ObjectLogID        => $Row[0],
            CommunicationID    => $Row[1],
            ObjectLogType      => $Row[2],
            ObjectLogStatus    => $Row[3],
            ObjectLogStartTime => $Row[4],
            ObjectLogEndTime   => $Row[5],
            LogID              => $Row[6],
            LogKey             => $Row[7],
            LogValue           => $Row[8],
            LogPriority        => $Row[9],
            LogCreateTime      => $Row[10],
        };
    }

    return \@List;
}

=head2 GetConnectionsObjectsAndCommunications()

Method specifically created for optimization purposes for the Support Data Collector.
Joins the Communication Log Object and Communications.

    my $Result = $CommunicationDBObject->GetConnectionsObjectsAndCommunications(
        ObjectLogStartDate => '...',    # Required
        Status             => '...',    # Optional
    );

Returns Arrayref of Hashes.

    $Result = [
        {
            CommunicationID => '...',
            ObjectLogStatus => '...',
            AccountType     => '...',
            AccountID       => '...',
        },
        {...},
    ];

=cut

sub GetConnectionsObjectsAndCommunications {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{ObjectLogStartDate} ) {
        return $Self->_LogError("Need ObjectLogStartDate!");
    }

    my $SQL = "SELECT c.id, clo.status, c.account_type, c.account_id, c.transport
    FROM communication_log_object clo
    JOIN communication_log c on c.id = clo.communication_id
    WHERE clo.object_type = 'Connection'";

    my @Binds;
    if ( $Param{ObjectLogStartDate} ) {
        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{ObjectLogStartDate},
            },
        );

        return if !$DateTimeObject;

        $SQL .= "AND clo.start_time >= ?";
        push @Binds, \$Param{ObjectLogStartDate};
    }

    # Add Status where clause if there is a given valid status.
    if ( $Param{Status} ) {
        return if !$Self->_IsValidStatus( Status => $Param{Status} );
        $SQL .= " AND clo.status = ?";
        push @Binds, \$Param{Status};
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Bind  => \@Binds,
        Limit => $Param{Limit},
    );

    my @List = ();
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @List, {
            CommunicationID => $Row[0],
            ObjectLogStatus => $Row[1],
            AccountType     => $Row[2] || 'Unknown',
            AccountID       => $Row[3],
            Transport       => $Row[4],
        };
    }

    return \@List;
}

=head2 ObjectLookupSet()

Inserts or updates a lookup information.

    my $Result = $CommunicationDBObject->ObjectLookupSet(
        ObjectLogID      => '123',     # (required)
        TargetObjectType => 'Article', # (required)
        TargetObjectID   => '123',     # (required)
    );

Returns:

    1 in case of success, <undef> in case of errors

=cut

sub ObjectLookupSet {
    my ( $Self, %Param ) = @_;

    # Check for required arguments.
    for my $Argument (qw(ObjectLogID TargetObjectType TargetObjectID)) {
        if ( !$Param{$Argument} ) {
            return $Self->_LogError("Need $Argument!");
        }
    }

    my $SQL = '
        INSERT INTO communication_log_obj_lookup (communication_log_object_id, object_type, object_id)
        VALUES (?, ?, ?)
    ';

    my @Bind = (
        \$Param{ObjectLogID},
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

    my $List = $CommunicationDBObject->ObjectLookupSearch(
        ObjectLogID      => '123',     # (optional)
        ObjectLogType    => 'Message', # (optional)
        TargetObjectType => 'Article', # (optional)
        TargetObjectID   => '123',     # (optional)
        CommunicationID  => '123',     # (optional)
    );

Returns:

    <undef> - if any error occur
    An arrayref of object lookup - in case of success
    $List = [
        {
            ObjectLogID      => '...',
            TargetObjectType => '...',
            TargetObjectID   => '...',
        },
        ...
    ];

=cut

sub ObjectLookupSearch {
    my ( $Self, %Param ) = @_;

    my @SQL = (
        'SELECT clo.communication_id, clol.communication_log_object_id, clol.object_type',
        ',clol.object_id',
        'FROM communication_log_obj_lookup clol',
        'JOIN communication_log_object clo ON clol.communication_log_object_id = clo.id'
    );

    my %PossibleFilters = (
        ObjectLogID      => 'clol.communication_log_object_id',
        ObjectLogType    => 'clo.object_type',
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
        push @Bind,         \$Value;
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
            CommunicationID  => $Row[0],
            ObjectLogID      => $Row[1],
            TargetObjectType => $Row[2],
            TargetObjectID   => $Row[3],
        };
    }

    return \@List;
}

=head2 ObjectLookupGet()

Gets the object lookup information.

    my $Result = $CommunicationDBObject->ObjectLookupGet(
        ObjectLogID      => '123',         # (optional)
        TargetObjectID   => '123',         # (optional)
        TargetObjectType => '123',         # (optional)
    );

Returns:

    $Result = {
        CommunicationID  => '...',
        ObjectLogID      => '...',
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
        [qw( ObjectLogID TargetObjectType )],
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

        return $Self->_LogError( join ' ', @ErrorMessage );
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

=head2 CommunicationGetByObjectLogID()

Get a communication entry data by a communication object id.

    my %CommunicationData = $CommunicationDBObject->CommunicationGetByObjectLogID(
        ObjectLogID => 123,
    );

Returns:

    %CommunicationData = (
        CommunicationID => 123,
        Transport       => 'Email',
        Direction       => 'Incoming',
        Status          => 'Processing',
        AccountType     => '...',
        AccountID       => '...',
        StartTime       => '2017-05-31 09:26:20',
        EndTime         => '2017-05-31 09:30:15',
    );

=cut

sub CommunicationGetByObjectLogID {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ObjectLogID} ) {
        return $Self->_LogError("Need ObjectLogID!");
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
        Bind  => [ \$Param{ObjectLogID} ],
        Limit => 1,
    );

    if ( my @Row = $DBObject->FetchrowArray() ) {
        return {
            CommunicationID => $Row[0],
            Transport       => $Row[1],
            Direction       => $Row[2],
            Status          => $Row[3],
            AccountType     => $Row[4],
            AccountID       => $Row[5],
            StartTime       => $Row[6],
            EndTime         => $Row[7],
        };
    }

    return {};

}

=head2 _GetTransportModule()

Lookup for the transport module.

Returns:

    undef  - case not found
    module - case found

=cut

sub _GetTransportModule {
    my ( $Self, %Param ) = @_;

    my $Transport = $Param{Transport};
    return if !$Transport;

    # Get the communication log transport configuration.
    my $ModuleConfigs = $Kernel::OM->Get('Kernel::Config')->Get('CommunicationLog::Transport');
    my $Module        = $ModuleConfigs->{$Transport};
    if ( !$Module || !$Module->{Module} ) {
        return $Self->_LogError("Couldn't create a backend object for transport '${ Transport }'!");
    }

    return $Kernel::OM->Get( $Module->{Module} );
}

=head2 _LogError()

Helper Method for logging.

=cut

sub _LogError {
    my ( $Self, $Message ) = @_;

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => $Message,
    );

    return;
}

=head2 _IsValidDirection()

Check if the given direction is valid.

    my $Result = $LogModuleObject->_IsValidDirection(
        Direction => '...',
    );

=cut

sub _IsValidDirection {
    my ( $Self, %Param ) = @_;

    my $Direction    = $Param{Direction};
    my %DirectionMap = (
        Incoming => 1,
        Outgoing => 1,
    );

    if ( !$DirectionMap{$Direction} ) {
        return $Self->_LogError("Invalid Direction '${ Direction }'!");
    }

    return 1;
}

=head2 _IsValidObjectLogType()

Check if the given Object Log Type is valid.

    my $Result = $LogModuleObject->_IsValidObjectLogType(
        ObjectLogType => '...',
    );

=cut

sub _IsValidObjectLogType {
    my ( $Self, %Param ) = @_;

    my $ObjectLogType = $Param{ObjectLogType};
    my %TypeMap       = (
        Connection => 1,
        Message    => 1,
    );

    if ( !$TypeMap{$ObjectLogType} ) {
        return $Self->_LogError("Invalid ObjectLogType '${ ObjectLogType }'!");
    }

    return 1;
}

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
        return $Self->_LogError("Invalid Status '${ Status }'!");
    }

    return 1;
}

=head2 _DurationSQL()

Return the SQL expression to get the difference between two dates in seconds.

=cut

sub _DurationSQL {
    my ( $Self, %Param ) = @_;

    my $DBType = $Kernel::OM->Get('Kernel::System::DB')->{'DB::Type'};
    my $Start  = $Param{Start};
    my $End    = $Param{End};

    my %Templates = (
        oracle     => q{EXTRACT(SECOND FROM(%s - %s) DAY TO SECOND)},
        mysql      => q{TIME_TO_SEC(TIMEDIFF(%s, %s))},
        postgresql => q{EXTRACT(EPOCH FROM(%s - %s))},
    );

    return sprintf( $Templates{$DBType}, $End, $Start );
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
