# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Daemon::SchedulerDB;

use strict;
use warnings;

use MIME::Base64;
use Time::HiRes;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::CronEvent',
    'Kernel::System::DateTime',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::GenericAgent',
    'Kernel::System::Main',
    'Kernel::System::Log',
    'Kernel::System::Storable',
);

=head1 NAME

Kernel::System::Daemon::SchedulerDB - Scheduler database lib

=head1 DESCRIPTION

Includes all scheduler related database functions.

=head1 PUBLIC INTERFACE

=head2 new()

create a scheduler database object. Do not use it directly, instead use:

    my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 TaskAdd()

add a new task to scheduler task list

    my $TaskID = $SchedulerDBObject->TaskAdd(
        Type                     => 'GenericInterface',     # e. g. GenericInterface, Test
        Name                     => 'any name',             # optional
        Attempts                 => 5,                      # optional (default 1)
        MaximumParallelInstances => 2,                      # optional (default 0), number of tasks
                                                            #   with the same type (and name if
                                                            #   provided) that can exists at the same
                                                            #   time, value of 0 means unlimited
        Data => {                                           # data payload
            ...
        },
    );

Returns:

    my $TaskID = 123;  # false in case of an error or -1 in case of reach MaximumParallelInstances

=cut

sub TaskAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(Type Data)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );

            return;
        }
    }

    if ( $Param{MaximumParallelInstances} && $Param{MaximumParallelInstances} =~ m{\A \d+ \z}msx ) {

        # get the list of all worker tasks for the specified task type
        my @List = $Self->TaskList(
            Type => $Param{Type},
        );

        my @FilteredList = @List;

        if ( $Param{Name} ) {

            # remove all tasks that does not match specified task name
            @FilteredList = grep { $_->{Name} eq $Param{Name} } @List;
        }

        # compare the number of task with the maximum parallel limit
        return -1 if scalar @FilteredList >= $Param{MaximumParallelInstances};
    }

    # set default of attempts parameter
    $Param{Attempts} ||= 1;

    # serialize data as string
    my $Data = $Kernel::OM->Get('Kernel::System::Storable')->Serialize(
        Data => $Param{Data},
    );

    # encode task data
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput($Data);
    $Data = encode_base64($Data);

    # get needed objects
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $Identifier;
    TRY:
    for my $Try ( 1 .. 10 ) {

        # calculate a task identifier
        $Identifier = $Self->_GetIdentifier();

        # insert the task (initially locked with lock_key = 1 so it will not be taken by any worker
        #   at this moment)
        last TRY if $DBObject->Do(
            SQL => '
                INSERT INTO scheduler_task
                    (ident, name, task_type, task_data, attempts, lock_key, create_time)
                VALUES
                    (?, ?, ?, ?, ?, 1, current_timestamp)',
            Bind => [
                \$Identifier,
                \$Param{Name},
                \$Param{Type},
                \$Data,
                \$Param{Attempts},
            ],
        );
    }

    # get task id
    $DBObject->Prepare(
        SQL  => 'SELECT id FROM scheduler_task WHERE ident = ?',
        Bind => [ \$Identifier ],
    );

    # fetch the task id
    my $TaskID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $TaskID = $Row[0];
    }

    # unlock the task, for now on the task can be taken by any worker
    $DBObject->Do(
        SQL => '
            UPDATE scheduler_task
            SET lock_key = 0
            WHERE lock_key = 1 AND id = ?',
        Bind => [
            \$TaskID,
        ],
    );

    # delete task list cache
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => 'SchedulerDB',
        Key  => 'TaskListUnlocked',
    );

    return $TaskID;
}

=head2 TaskGet()

get scheduler task

    my %Task = $SchedulerDBObject->TaskGet(
        TaskID => 123,
    );

Returns:

    %Task = (
        TaskID         => 123,
        Name           => 'any name',
        Type           => 'GenericInterface',
        Data           => $DataRef,
        Attempts       => 10,
        LockKey        => 'XYZ',
        LockTime       => '2011-02-08 15:08:01',
        LockUpdateTime => '2011-02-08 15:08:01',
        CreateTime     => '2011-02-08 15:08:00',
    );

=cut

sub TaskGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TaskID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TaskID!',
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get task from database
    return if !$DBObject->Prepare(
        SQL => '
            SELECT name, task_type, task_data, attempts, lock_key, lock_time, lock_update_time,
                create_time
            FROM scheduler_task
            WHERE id = ?',
        Bind => [ \$Param{TaskID} ],
    );

    # get storable object
    my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');

    my %Task;
    while ( my @Data = $DBObject->FetchrowArray() ) {

        # decode task data
        my $DecodedData = decode_base64( $Data[2] );

        # deserialize data
        my $DataParam = $StorableObject->Deserialize( Data => $DecodedData );

        if ( !$DataParam ) {

            # error log
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Task data is not in a correct storable format! TaskID: ' . $Param{TaskID},
            );

            # remove damaged task
            $Self->TaskDelete(
                TaskID => $Param{TaskID},
            );

            return;
        }

        %Task = (
            TaskID         => $Param{TaskID},
            Name           => $Data[0],
            Type           => $Data[1],
            Data           => $DataParam || {},
            Attempts       => $Data[3],
            LockKey        => $Data[4] // 0,
            LockTime       => $Data[5] // '',
            LockUpdateTime => $Data[6] // '',
            CreateTime     => $Data[7],
        );
    }

    return %Task;
}

=head2 TaskDelete()

delete a task from scheduler task list

    my $Success = $SchedulerDBObject->TaskDelete(
        TaskID => 123,
    );

=cut

sub TaskDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TaskID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TaskID!',
        );
        return;
    }

    # delete task from the list
    $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM scheduler_task WHERE id = ?',
        Bind => [ \$Param{TaskID} ],
    );

    # delete task list cache
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => 'SchedulerDB',
        Key  => 'TaskListUnlocked',
    );

    return 1;
}

=head2 TaskList()

get the list of scheduler tasks

    my @List = $SchedulerDBObject->TaskList(
        Type => 'some type',  # optional
    );

Returns:

    @List = (
        {
            TaskID => 123,
            Name   => 'any name',
            Type   => 'GenericInterface',
        },
        {
            TaskID => 456,
            Name   => 'any other name',
            Type   => 'GenericInterface',
        },
        # ...
    );

=cut

sub TaskList {
    my ( $Self, %Param ) = @_;

    my $SQL = 'SELECT id, name, task_type FROM scheduler_task';
    my @Bind;

    # add type
    if ( $Param{Type} ) {
        $SQL .= ' WHERE task_type = ?';
        @Bind = ( \$Param{Type} );
    }

    $SQL .= ' ORDER BY id ASC';

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask the database
    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    # fetch the result
    my @List;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        push @List, {
            TaskID => $Row[0],
            Name   => $Row[1],
            Type   => $Row[2],
        };
    }

    return @List;
}

=head2 TaskListUnlocked()

get a list of unlocked tasks

    my @TaskList = $SchedulerDBObject->TaskListUnlocked();

Returns:

    @TaskList = ( 456, 789, 395 );

=cut

sub TaskListUnlocked {
    my ( $Self, %Param ) = @_;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # read cache
    my $Cache = $CacheObject->Get(
        Type           => 'SchedulerDB',
        Key            => 'TaskListUnlocked',
        CacheInMemory  => 0,
        CacheInBackend => 1,
    );
    return @{$Cache} if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask the database
    return if !$DBObject->Prepare(
        SQL => 'SELECT id FROM scheduler_task WHERE lock_key = 0 ORDER BY id ASC',
    );

    # fetch the result
    my @List;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @List, $Row[0];
    }

    # set cache
    $CacheObject->Set(
        Type           => 'SchedulerDB',
        Key            => 'TaskListUnlocked',
        TTL            => 10,
        Value          => \@List,
        CacheInMemory  => 0,
        CacheInBackend => 1,
    );

    return @List;
}

=head2 TaskLock()

locks task to a specific PID

    my $Success = $SchedulerDBObject->TaskLock(
        TaskID => 123,
        NodeID => 1,    # the id on the node in a cluster environment
        PID    => 456,  # the process ID of the worker that is locking the task
    );

=cut

sub TaskLock {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(TaskID NodeID PID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );

            return;
        }
    }

    # create the lock key
    my $LockKeyNodeID = sprintf "%03d", $Param{NodeID};
    my $LockKeyPID    = sprintf "%08d", $Param{PID};
    my $LockKey       = '1' . $LockKeyNodeID . $LockKeyPID;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get locked task
    return if !$DBObject->Prepare(
        SQL  => 'SELECT lock_key FROM scheduler_task WHERE id = ?',
        Bind => [ \$Param{TaskID} ],
    );

    # fetch the result
    my $LockKeyFromDBBefore = '';
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $LockKeyFromDBBefore = $Data[0] || '';
    }

    return 1 if $LockKeyFromDBBefore eq $LockKey;

    # lock the task in database
    return if !$DBObject->Do(
        SQL => '
            UPDATE scheduler_task
            SET lock_key = ?, lock_time = current_timestamp, lock_update_time = current_timestamp
            WHERE lock_key = 0 AND id = ?',
        Bind => [
            \$LockKey,
            \$Param{TaskID},
        ],
    );

    # get locked task
    return if !$DBObject->Prepare(
        SQL  => 'SELECT lock_key, attempts FROM scheduler_task WHERE id = ?',
        Bind => [ \$Param{TaskID} ],
    );

    # fetch the result
    my $LockKeyFromDB = '';
    my $Attempts      = 0;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $LockKeyFromDB = $Data[0];
        $Attempts      = $Data[1];
    }

    return if $LockKeyFromDB ne $LockKey;

    # remove task if attempts is 0
    if ( !$Attempts ) {
        $Self->TaskDelete(
            TaskID => $Param{TaskID},
        );

        return;
    }
    else {

        $Attempts--;

        # decrement number of attempts
        $DBObject->Do(
            SQL => '
                UPDATE scheduler_task
                SET attempts = ?
                WHERE lock_key = ? AND id = ?',
            Bind => [
                \$Attempts,
                \$LockKey,
                \$Param{TaskID},
            ],
        );
    }

    # delete list cache
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => 'SchedulerDB',
        Key  => 'TaskListUnlocked',
    );

    return 1;
}

=head2 TaskCleanup()

deletes obsolete worker tasks

    my $Success = $SchedulerDBObject->TaskCleanup();

=cut

sub TaskCleanup {
    my ( $Self, %Param ) = @_;

    my @List = $Self->TaskList();

    TASKITEM:
    for my $TaskItem (@List) {

        my %Task = $Self->TaskGet(
            TaskID => $TaskItem->{TaskID},
        );

        # skip if task does not have a lock key
        next TASKITEM if !$Task{LockKey};

        # skip if the lock key is invalid
        next TASKITEM if $Task{LockKey} < 1;

        # get system time
        my $SystemTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

        # get expiration time. 7 days ago system time
        my $ExpiredTime = $SystemTime - ( 60 * 60 * 24 * 7 );

        my $LockTime = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Task{LockTime},
            },
        );

        $LockTime = $LockTime ? $LockTime->ToEpoch() : 0;

        # skip if task is not expired
        next TASKITEM if $LockTime > $ExpiredTime;

        my $Success = $Self->TaskDelete(
            TaskID => $Task{TaskID},
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not delete task $Task{Name}-$Task{Type} ($Task{TaskID})\n",
            );
        }
    }

    return 1;
}

=head2 TaskSummary()

get a summary of the tasks from the worker task table divided into handled and unhandled

    my @Summary = $SchedulerDBObject->TaskSummary();

=cut

sub TaskSummary {
    my ( $Self, %Param ) = @_;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask the database
    return () if !$DBObject->Prepare(
        SQL => '
            SELECT id, name, task_type, lock_key, lock_time, create_time
            FROM scheduler_task
            ORDER BY id ASC',
    );

    # fetch the result
    my @List;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @List, {
            Name       => $Row[1],
            Type       => $Row[2],
            LockKey    => $Row[3] // 0,
            LockTime   => $Row[4] // '',
            CreateTime => $Row[5],
        };
    }

    my @HandledTasks;
    my @UnhandledTasks;

    my $SystemTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

    TASK:
    for my $Task (@List) {

        # check if the task is unlocked or lock key is not valid (unhandled tasks)
        if ( $Task->{LockKey} < 1 ) {
            push @UnhandledTasks, {
                Name       => $Task->{Name},
                Type       => $Task->{Type},
                CreateTime => $Task->{CreateTime},
            };
        }
        else {

            # extract the NodeID and ProcessID from the lock key
            my ( $NodeID, $ProcessID ) = $Task->{LockKey} =~ m{\A 1 (\d{3}) (\d{8}) \z}msx;

            # calculate duration from lock time
            my $CurrentDuration;
            if ( defined $Task->{LockTime} ) {
                my $LockSystemTime = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $Task->{LockTime},
                    },
                );
                $LockSystemTime = $LockSystemTime ? $LockSystemTime->ToEpoch() : 0;

                $CurrentDuration = $Self->_Seconds2String( $SystemTime - $LockSystemTime );
            }

            push @HandledTasks, {
                Name            => $Task->{Name},
                Type            => $Task->{Type},
                NodeID          => $NodeID,
                ProcessID       => $ProcessID,
                LockTime        => $Task->{LockTime},
                CreateTime      => $Task->{CreateTime},
                CurrentDuration => $CurrentDuration
            };
        }
    }

    return (
        {
            Header => 'Unhandled Worker Tasks:',
            Column => [
                {
                    Name        => 'Name',
                    DisplayName => 'Name',
                    Size        => 40,
                },
                {
                    Name        => 'Type',
                    DisplayName => 'Type',
                    Size        => 20,
                },
                {
                    Name        => 'CreateTime',
                    DisplayName => 'Create Time',
                    Size        => 20,
                },
            ],
            Data          => \@UnhandledTasks,
            NoDataMessage => 'There are currently no tasks waiting to be executed.',
        },
        {
            Header => 'Handled Worker Tasks:',
            Column => [
                {
                    Name        => 'Name',
                    DisplayName => 'Name',
                    Size        => 40,
                },
                {
                    Name        => 'Type',
                    DisplayName => 'Type',
                    Size        => 20,
                },
                {
                    Name        => 'NodeID',
                    DisplayName => 'NID',
                    Size        => 4,
                },
                {
                    Name        => 'ProcessID',
                    DisplayName => 'PID',
                    Size        => 9,
                },
                {
                    Name        => 'CurrentDuration',
                    DisplayName => 'Duration',
                    Size        => 20,
                },
            ],
            Data          => \@HandledTasks,
            NoDataMessage => 'There are currently no tasks being executed.',
        },
    );
}

=head2 TaskLockUpdate()

sets the task lock update time as current time for the specified tasks

    my $Success = $SchedulerDBObject->TaskLockUpdate(
        TaskIDs => [123, 456],
    );

=cut

sub TaskLockUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !IsArrayRefWithData( $Param{TaskIDs} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "TaskIDs is missing or invalid!",
        );

        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $TaskIDs = join ',', map { $DBObject->Quote( $_, 'Integer' ) } @{ $Param{TaskIDs} };

    return 1 if !$TaskIDs;

    # set lock update time in database
    return if !$DBObject->Do(
        SQL => "
            UPDATE scheduler_task
            SET lock_update_time = current_timestamp
            WHERE id IN ( $TaskIDs )",
    );

    return 1;
}

=head2 TaskUnlockExpired()

remove lock status for working tasks that has not been updated its lock update time for more than 5 minutes

    my $Success = $SchedulerDBObject->TaskUnlockExpired();

=cut

sub TaskUnlockExpired {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask the database (get all worker tasks with a lock key different than 0)
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, name, lock_update_time
            FROM scheduler_task
            WHERE lock_key <> 0
                AND lock_key <> 1
            ORDER BY id ASC',
    );

    # fetch the result
    my @List;
    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # get current system time
        my $SystemTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

        # convert lock update time stamp to a system time
        my $LockUpdateTime = 0;

        if ( $Row[2] ) {
            $LockUpdateTime = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Row[2],
                },
            );
            $LockUpdateTime = $LockUpdateTime ? $LockUpdateTime->ToEpoch() : 0;
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Lock Update Time missing for task $Row[1]! ($Row[0])",
            );
        }

        # skip task if it has been locked update time is in within the last 5 minutes
        next ROW if $SystemTime - $LockUpdateTime < ( 60 * 5 );

        push @List, {
            TaskID   => $Row[0],
            Name     => $Row[1],
            LockTime => $Row[2],
        };
    }

    # stop if there are no tasks to unlock
    return 1 if !@List;

    for my $Task (@List) {

        # unlock all the task that has been locked for more than 1 minute
        return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => '
                UPDATE scheduler_task
                SET lock_key = 0, lock_time = NULL, lock_update_time = NULL
                WHERE id = ?',
            Bind => [ \$Task->{TaskID}, ],
        );
    }

    return 1;
}

=head2 FutureTaskAdd()

add a new task to scheduler future task list

    my $TaskID = $SchedulerDBObject->FutureTaskAdd(
        ExecutionTime            => '2015-01-01 00:00:00',
        Type                     => 'GenericInterface',  # e. g. GenericInterface, Test
        Name                     => 'any name',          # optional
        Attempts                 => 5,                   # optional (default 1)
        MaximumParallelInstances => 2,                   # optional (default 0), number of tasks
                                                         #   with the same type (and name if provided)
                                                         #   that can exists at the same time,
                                                         #   value of 0 means unlimited
        Data => {                                        # data payload
            ...
        },
    );

Returns:

    my $TaskID = 123;  # or false in case of an error

=cut

sub FutureTaskAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ExecutionTime Type Data)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );

            return;
        }
    }

    # check valid ExecutionTime

    my $SystemTime = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Param{ExecutionTime},
        },
    );

    if ( !$SystemTime ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "ExecutionTime is invalid!",
        );

        return;
    }
    $SystemTime = $SystemTime->ToEpoch();

    if ( $Param{MaximumParallelInstances} && $Param{MaximumParallelInstances} =~ m{\A \d+ \z}msx ) {

        # get the list of all future tasks for the specified task type
        my @List = $Self->FutureTaskList(
            Type => $Param{Type},
        );

        my @FilteredList = @List;
        if ( $Param{Name} && @List ) {

            # remove all tasks that does not match specified task name
            @FilteredList = grep { ( $_->{Name} || '' ) eq $Param{Name} } @List;
        }

        # compare the number of task with the maximum parallel limit
        return -1 if scalar @FilteredList >= $Param{MaximumParallelInstances};
    }

    # set default of attempts parameter
    $Param{Attempts} ||= 1;

    # serialize data as string
    my $Data = $Kernel::OM->Get('Kernel::System::Storable')->Serialize(
        Data => $Param{Data},
    );

    # encode task data
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput($Data);
    $Data = encode_base64($Data);

    # get needed objects
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $Identifier;
    TRY:
    for my $Try ( 1 .. 10 ) {

        # calculate a task identifier
        $Identifier = $Self->_GetIdentifier();

        # insert the future task (initially locked with lock_key = 1 so it will not be taken by any
        #    moved into worker task list at this moment)
        last TRY if $DBObject->Do(
            SQL => '
                INSERT INTO scheduler_future_task
                    (ident, execution_time, name, task_type, task_data, attempts, lock_key, create_time)
                VALUES
                    (?, ?, ?, ?, ?, ?, 1, current_timestamp)',
            Bind => [
                \$Identifier,
                \$Param{ExecutionTime},
                \$Param{Name},
                \$Param{Type},
                \$Data,
                \$Param{Attempts},
            ],
        );
    }

    # get task id
    $DBObject->Prepare(
        SQL  => 'SELECT id FROM scheduler_future_task WHERE ident = ?',
        Bind => [ \$Identifier ],
    );

    # fetch the task id
    my $TaskID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $TaskID = $Row[0];
    }

    # unlock the task, for now on the task can be moved to the worker task list
    $DBObject->Do(
        SQL => '
            UPDATE scheduler_future_task
            SET lock_key = 0
            WHERE lock_key = 1 AND id = ?',
        Bind => [
            \$TaskID,
        ],
    );

    # delete future task list cache
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => 'SchedulerDB',
        Key  => 'FutureTaskListUnlocked',    # TODO FIXME
    );

    return $TaskID;
}

=head2 FutureTaskGet()

get scheduler future task

    my %Task = $SchedulerDBObject->FutureTaskGet(
        TaskID => 123,
    );

Returns:

    %Task = (
        TaskID        => 123,
        ExecutionTime => '2015-01-01 00:00:00',
        Name          => 'any name',
        Type          => 'GenericInterface',
        Data          => $DataRef,
        Attempts      => 10,
        LockKey       => 'XYZ',
        LockTime      => '2011-02-08 15:08:01',
        CreateTime    => '2011-02-08 15:08:00',
    );

=cut

sub FutureTaskGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TaskID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TaskID!',
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get task from database
    return if !$DBObject->Prepare(
        SQL =>
            'SELECT execution_time, name, task_type, task_data, attempts, lock_key, lock_time, create_time
            FROM scheduler_future_task
            WHERE id = ?',
        Bind => [ \$Param{TaskID} ],
    );

    # get storable object
    my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');

    my %Task;
    while ( my @Data = $DBObject->FetchrowArray() ) {

        # decode task data
        my $DecodedData = decode_base64( $Data[3] );

        # deserialize data
        my $DataParam = $StorableObject->Deserialize( Data => $DecodedData );

        if ( !$DataParam ) {

            # error log
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Future task data is not in a correct storable format! TaskID: ' . $Param{TaskID},
            );

            # remove damaged future task
            $Self->FutureTaskDelete(
                TaskID => $Param{TaskID},
            );

            return;
        }

        %Task = (
            TaskID        => $Param{TaskID},
            ExecutionTime => $Data[0],
            Name          => $Data[1],
            Type          => $Data[2],
            Data          => $DataParam || {},
            Attempts      => $Data[4],
            LockKey       => $Data[5] // 0,
            LockTime      => $Data[6] // '',
            CreateTime    => $Data[7],
        );
    }

    return %Task;
}

=head2 FutureTaskDelete()

delete a task from scheduler future task list

    my $Success = $SchedulerDBObject->FutureTaskDelete(
        TaskID => 123,
    );

=cut

sub FutureTaskDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TaskID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TaskID!',
        );
        return;
    }

    # delete task from the future list
    $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM scheduler_future_task WHERE id = ?',
        Bind => [ \$Param{TaskID} ],
    );

    # delete future task list cache
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => 'SchedulerDB',
        Key  => 'FutureTaskListUnlocked',    # TODO FIXME
    );

    return 1;
}

=head2 FutureTaskList()

get the list of scheduler future tasks

    my @List = $SchedulerDBObject->FutureTaskList(
        Type => 'some type',  # optional
    );

Returns:

    @List = (
        {
            TaskID        => 123,
            ExecutionTime => '2015-01-01 00:00:00',
            Name          => 'any name',
            Type          => 'GenericInterface',
        },
        {
            TaskID        => 456,
            ExecutionTime => '2015-01-01 00:00:00',
            Name          => 'any other name',
            Type          => 'GenericInterface',
        },
        # ...
    );

=cut

sub FutureTaskList {
    my ( $Self, %Param ) = @_;

    my $SQL = 'SELECT id, execution_time, name, task_type FROM scheduler_future_task';
    my @Bind;

    # add type
    if ( $Param{Type} ) {
        $SQL .= ' WHERE task_type = ?';
        @Bind = ( \$Param{Type} );
    }

    $SQL .= ' ORDER BY id ASC';

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask the database
    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    # fetch the result
    my @List;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        push @List, {
            TaskID        => $Row[0],
            ExecutionTime => $Row[1],
            Name          => $Row[2],
            Type          => $Row[3],
        };
    }

    return @List;
}

=head2 FutureTaskToExecute()

moves all future tasks with reached execution time to the task table to execute

    my $Success = $SchedulerDBObject->FutureTaskToExecute(
        NodeID => 1,    # the ID of the node in a cluster environment
        PID    => 456,  # the process ID of the daemon that is moving the tasks to execution
    );

=cut

sub FutureTaskToExecute {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(NodeID PID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );

            return;
        }
    }

    # create the lock key
    my $LockKeyNodeID = sprintf "%03d", $Param{NodeID};
    my $LockKeyPID    = sprintf "%08d", $Param{PID};
    my $LockKey       = '1' . $LockKeyNodeID . $LockKeyPID;

    # get needed objects
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get current time
    my $CurrentTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

    # lock the task in database
    return if !$DBObject->Do(
        SQL => '
            UPDATE scheduler_future_task
            SET lock_key = ?, lock_time = current_timestamp
            WHERE lock_key = 0 AND execution_time <= ?',
        Bind => [
            \$LockKey,
            \$CurrentTime,
        ],
    );

    # get all locked future tasks
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, name, task_type, task_data, attempts
            FROM scheduler_future_task
            WHERE lock_key = ?
            ORDER BY execution_time ASC',
        Bind => [ \$LockKey ],
    );

    # get storable object
    my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');

    # fetch the result
    my @FutureTaskList;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # decode task data
        my $DecodedData = decode_base64( $Row[3] );

        # deserialize data
        my $DataParam = $StorableObject->Deserialize( Data => $DecodedData );

        if ( !$DataParam ) {

            # error log
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Future task data is not in a correct storable format! TaskID: ' . $Param{TaskID},
            );

            # remove damaged future task
            $Self->FutureTaskDelete(
                TaskID => $Param{TaskID},
            );

            return;
        }

        my %Task = (
            TaskID   => $Row[0],
            Name     => $Row[1],
            Type     => $Row[2],
            Data     => $DataParam || {},
            Attempts => $Row[4],
        );

        push @FutureTaskList, \%Task;
    }

    # move tasks to the execution task list
    for my $FutureTask (@FutureTaskList) {

        my %Task = %{$FutureTask};

        delete $Task{TaskID};

        # add task to the list
        $Self->TaskAdd(%Task);

        # remove future task
        $Self->FutureTaskDelete(
            TaskID => $FutureTask->{TaskID},
        );
    }

    return 1;
}

=head2 FutureTaskSummary()

get a summary of the tasks from the future task table

    my @Summary = $SchedulerDBObject->FutureTaskSummary();

=cut

sub FutureTaskSummary {
    my ( $Self, %Param ) = @_;

    my @List = $Self->FutureTaskList();

    return (
        {
            Header => 'Tasks to be executed in future:',
            Column => [
                {
                    Name        => 'Name',
                    DisplayName => 'Name',
                    Size        => 40,
                },
                {
                    Name        => 'Type',
                    DisplayName => 'Type',
                    Size        => 20,
                },
                {
                    Name        => 'ExecutionTime',
                    DisplayName => 'To Execute At',
                    Size        => 20,
                },
            ],
            Data          => \@List,
            NoDataMessage => 'There are currently no tasks to be executed in future.',
        },
    );
}

=head2 CronTaskToExecute()

creates cron tasks that needs to be run in the current time into the task table to execute

    my $Success = $SchedulerDBObject->CronTaskToExecute(
        NodeID => 1,    # the ID of the node in a cluster environment
        PID    => 456,  # the process ID of the daemon that is creating the tasks to execution
    );

=cut

sub CronTaskToExecute {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(NodeID PID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );

            return;
        }
    }

    # get cron config
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get('Daemon::SchedulerCronTaskManager::Task') || {};

    # do noting if there are no cron tasks definitions in SysConfig
    return 1 if !IsHashRefWithData($Config);

    # get needed objects
    my $CronEventObject = $Kernel::OM->Get('Kernel::System::CronEvent');

    my %UsedTaskNames;

    CRONJOBKEY:
    for my $CronjobKey ( sort keys %{$Config} ) {

        next CRONJOBKEY if !$CronjobKey;

        # extract config
        my $JobConfig = $Config->{$CronjobKey};

        next CRONJOBKEY if !IsHashRefWithData($JobConfig);

        for my $Needed (qw(Module TaskName Function)) {
            if ( !$JobConfig->{$Needed} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Config option Daemon::SchedulerCronTaskManager::Task###$CronjobKey is invalid."
                        . " Need '$Needed' parameter!",
                );
                next CRONJOBKEY;
            }
        }

        if ( $UsedTaskNames{ $JobConfig->{TaskName} } ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Config option Daemon::SchedulerCronTaskManager::Task###$CronjobKey is invalid."
                    . " TaskName parameter '$JobConfig->{TaskName}' is already used by another task!",
            );
            next CRONJOBKEY;
        }

        # calculate last cron time
        my $PreviousEventTimestamp = $CronEventObject->PreviousEventGet(
            Schedule => $JobConfig->{Schedule},
        );

        next CRONJOBKEY if !$PreviousEventTimestamp;

        # execute recurrent tasks
        $Self->RecurrentTaskExecute(
            NodeID                   => $Param{NodeID},
            PID                      => $Param{PID},
            TaskName                 => $JobConfig->{TaskName},
            TaskType                 => 'Cron',
            PreviousEventTimestamp   => $PreviousEventTimestamp,
            MaximumParallelInstances => $JobConfig->{MaximumParallelInstances},
            Data                     => {
                Module   => $JobConfig->{Module}   || '',
                Function => $JobConfig->{Function} || '',
                Params   => $JobConfig->{Params}   || '',
            },
        );
        $UsedTaskNames{ $JobConfig->{TaskName} } = 1;
    }

    return 1;
}

=head2 CronTaskCleanup()

removes recurrent tasks that does not have a matching a cron tasks definition in SysConfig

    my $Success = $SchedulerDBObject->CronTaskCleanup();

=cut

sub CronTaskCleanup {
    my ( $Self, %Param ) = @_;

    # get cron config
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get('Daemon::SchedulerCronTaskManager::Task') || {};

    # do noting if there are no cron tasks definitions in SysConfig
    return 1 if !IsHashRefWithData($Config);

    # get needed objects
    my $CronEventObject = $Kernel::OM->Get('Kernel::System::CronEvent');

    my %CronJobLookup;

    CRONJOBKEY:
    for my $CronjobKey ( sort keys %{$Config} ) {

        next CRONJOBKEY if !$CronjobKey;

        # extract config
        my $JobConfig = $Config->{$CronjobKey};

        next CRONJOBKEY if !IsHashRefWithData($JobConfig);

        next CRONJOBKEY if ( !$JobConfig->{Module} );

        next CRONJOBKEY if ( $JobConfig->{Module} && !$JobConfig->{Function} );

        # calculate last cron time
        my $PreviousEventTimestamp = $CronEventObject->PreviousEventGet(
            Schedule => $JobConfig->{Schedule},
        );

        next CRONJOBKEY if !$PreviousEventTimestamp;

        $CronJobLookup{ $JobConfig->{TaskName} } = 1;
    }

    # get a list of all generic agent recurrent tasks
    my @TaskList = $Self->RecurrentTaskList(
        Type => 'Cron',
    );

    TASK:
    for my $Task (@TaskList) {

        # skip if task has an active generic agent job in the DB
        next TASK if $CronJobLookup{ $Task->{Name} };

        my $Success = $Self->RecurrentTaskDelete(
            TaskID => $Task->{TaskID},
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Task $Task->{Name}-$Task->{Type} ($Task->{TaskID}) could not be deleted!",
            );
        }
    }

    return 1;
}

=head2 CronTaskSummary()

get a summary of the cron tasks from the recurrent task table

    my @Summary = $SchedulerDBObject->CronTaskSummary();

=cut

sub CronTaskSummary {
    my ( $Self, %Param ) = @_;

    # get cron jobs from the SysConfig
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get('Daemon::SchedulerCronTaskManager::Task') || {};

    my %TaskLookup;

    JOBNAME:
    for my $JobName ( sort keys %{$Config} ) {

        my $JobConfig = $Config->{$JobName};

        next JOBNAME if !$JobConfig;
        next JOBNAME if !$JobConfig->{Schedule};

        $TaskLookup{$JobName} = $JobConfig->{Schedule};
    }

    return $Self->RecurrentTaskSummary(
        Type        => 'Cron',
        DisplayType => 'cron',
        TaskLookup  => \%TaskLookup,
    );
}

=head2 GenericAgentTaskToExecute()

creates generic agent tasks that needs to be run in the current time into the task table to execute

    my $Success = $SchedulerDBObject->GenericAgentTaskToExecute(
        NodeID => 1,    # the ID of the node in a cluster environment
        PID    => 456,  # the process ID of the daemon that is creating the tasks to execution
    );

=cut

sub GenericAgentTaskToExecute {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(NodeID PID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );

            return;
        }
    }

    # get generic agent object
    my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

    # get a list of generic agent jobs
    my %JobList = $GenericAgentObject->JobList();

    # do noting if there are no generic agent jobs
    return 1 if !%JobList;

    # get CRON event objects
    my $CronEventObject = $Kernel::OM->Get('Kernel::System::CronEvent');

    JOBNAME:
    for my $JobName ( sort keys %JobList ) {

        # get job
        my %Job = $GenericAgentObject->JobGet(
            Name => $JobName,
        );

        # skip if job is invalid
        next JOBNAME if !$Job{Valid};

        # get required params
        my $ScheduleCheck = 1;
        for my $Key (qw( ScheduleDays ScheduleMinutes ScheduleHours )) {
            if ( !$Job{$Key} ) {
                $ScheduleCheck = 0;
            }
        }

        # skip if job is not time based
        next JOBNAME if !$ScheduleCheck;

        # get CRON tab for Generic Agent Schedule
        my $Schedule = $CronEventObject->GenericAgentSchedule2CronTab(%Job);

        next JOBNAME if !$Schedule;

        # get the last time the GenericAgent job should be executed, this returns even THIS minute
        my $PreviousEventTimestamp = $CronEventObject->PreviousEventGet(
            Schedule => $Schedule,
        );

        next JOBNAME if !$PreviousEventTimestamp;

        # execute recurrent tasks
        $Self->RecurrentTaskExecute(
            NodeID                   => $Param{NodeID},
            PID                      => $Param{PID},
            TaskName                 => $JobName,
            TaskType                 => 'GenericAgent',
            PreviousEventTimestamp   => $PreviousEventTimestamp,
            MaximumParallelInstances => 1,
            Data                     => \%Job,
        );
    }

    return 1;
}

=head2 GenericAgentTaskCleanup()

removes recurrent tasks that does not have a matching generic agent job

    my $Success = $SchedulerDBObject->GenericAgentTaskCleanup();

=cut

sub GenericAgentTaskCleanup {
    my ( $Self, %Param ) = @_;

    # get generic agent object
    my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

    # get a list of generic agent jobs
    my %JobList = $GenericAgentObject->JobList();

    # do noting if there are no generic agent jobs
    return 1 if !%JobList;

    my %GenericAgentJobLookup;

    # get CRON event objects
    my $CronEventObject = $Kernel::OM->Get('Kernel::System::CronEvent');

    JOBNAME:
    for my $JobName ( sort keys %JobList ) {

        # get job
        my %Job = $GenericAgentObject->JobGet(
            Name => $JobName,
        );

        # skip if job is invalid
        next JOBNAME if !$Job{Valid};

        # get required params
        my $ScheduleCheck = 1;
        for my $Key (qw( ScheduleDays ScheduleMinutes ScheduleHours )) {
            if ( !$Job{$Key} ) {
                $ScheduleCheck = 0;
            }
        }

        # skip if job is not time based
        next JOBNAME if !$ScheduleCheck;

        # get CRON tab for Generic Agent Schedule
        my $Schedule = $CronEventObject->GenericAgentSchedule2CronTab(%Job);

        next JOBNAME if !$Schedule;

        $GenericAgentJobLookup{$JobName} = 1;
    }

    # get a list of all generic agent recurrent tasks
    my @TaskList = $Self->RecurrentTaskList(
        Type => 'GenericAgent',
    );

    TASK:
    for my $Task (@TaskList) {

        # skip if task has an active generic agent job in the DB
        next TASK if $GenericAgentJobLookup{ $Task->{Name} };

        my $Success = $Self->RecurrentTaskDelete(
            TaskID => $Task->{TaskID},
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Task $Task->{Name}-$Task->{Type} ($Task->{TaskID}) could not be deleted!",
            );
        }
    }

    return 1;
}

=head2 GenericAgentTaskSummary()

get a summary of the generic agent tasks from the recurrent task table

    my @Summary = $SchedulerDBObject->GenericAgentTaskSummary();

=cut

sub GenericAgentTaskSummary {
    my ( $Self, %Param ) = @_;

    # get generic agent object
    my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

    # get a list of generic agent jobs from the DB
    my %JobList = $GenericAgentObject->JobList();

    # get cron event object
    my $CronEventObject = $Kernel::OM->Get('Kernel::System::CronEvent');

    my %TaskLookup;

    JOBNAME:
    for my $JobName ( sort keys %JobList ) {

        # get job
        my %JobConfig = $GenericAgentObject->JobGet(
            Name => $JobName,
        );

        next JOBNAME if !%JobConfig;
        next JOBNAME if !$JobConfig{Valid};

        # get required params
        my $ScheduleCheck = 1;
        for my $Key (qw( ScheduleDays ScheduleMinutes ScheduleHours )) {
            if ( !$JobConfig{$Key} ) {
                $ScheduleCheck = 0;
            }
        }

        # skip if job is not time based
        next JOBNAME if !$ScheduleCheck;

        # get CRON tab for Generic Agent Schedule
        my $Schedule = $CronEventObject->GenericAgentSchedule2CronTab(%JobConfig);

        next JOBNAME if !$Schedule;

        $TaskLookup{$JobName} = $Schedule;
    }

    return $Self->RecurrentTaskSummary(
        Type        => 'GenericAgent',
        DisplayType => 'generic agent',
        TaskLookup  => \%TaskLookup,
    );
}

=head2 RecurrentTaskGet()

get scheduler recurrent task

    my %Task = $SchedulerDBObject->RecurrentTaskGet(
        TaskID => 123,
    );

Returns:

    %Task = (
        TaskID            => 123,
        Name              => 'any name',
        Type              => 'GenericInterface',
        LastExecutionTime => '2015-01-01 00:00:00',
        LockKey           => 'XYZ',
        LockTime          => '2015-01-02 00:00:00'
        CreateTime        => '2015-01-01 00:00:00'
        ChangeTime        => '2015-01-02 00:00:00'
    );

=cut

sub RecurrentTaskGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TaskID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TaskID!',
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get task from database
    return if !$DBObject->Prepare(
        SQL => 'SELECT name, task_type, last_execution_time, lock_key, lock_time, create_time, change_time
            FROM scheduler_recurrent_task
            WHERE id = ?',
        Bind => [ \$Param{TaskID} ],
    );

    my %Task;
    while ( my @Data = $DBObject->FetchrowArray() ) {

        %Task = (
            TaskID            => $Param{TaskID},
            Name              => $Data[0],
            Type              => $Data[1],
            LastExecutionTime => $Data[2],
            LockKey           => $Data[3] // 0,
            LockTime          => $Data[4] // '',
            CreateTime        => $Data[5],
            ChangeTime        => $Data[6]
        );
    }

    return %Task;
}

=head2 RecurrentTaskList()

get the list of scheduler recurrent tasks

    my @List = $SchedulerDBObject->RecurrentTaskList(
        Type => 'some type',  # optional
    );

Returns:

    @List = (
        {
            TaskID            => 123,
            Name              => 'any name',
            Type              => 'GenericInterface',
            LastExecutionTime => '2015-01-01 00:00:00',
            LockKey           => 'XYZ',
            LockTime          => '2015-01-02 00:00:00'
            CreateTime        => '2015-01-01 00:00:00'
            ChangeTime        => '2015-01-02 00:00:00'
        },
        {
            TaskID            => 456,
            Name              => 'any other name',
            Type              => 'GenericInterface',
            LastExecutionTime => '2015-01-01 00:00:00',
            LockKey           => 'XYZ',
            LockTime          => '2015-01-02 00:00:00'
            CreateTime        => '2015-01-01 00:00:00'
            ChangeTime        => '2015-01-02 00:00:00'
        },
        # ...
    );

=cut

sub RecurrentTaskList {
    my ( $Self, %Param ) = @_;

    my $SQL = '
        SELECT id, name, task_type, last_execution_time, lock_key, lock_time, create_time,
            change_time
        FROM scheduler_recurrent_task';
    my @Bind;

    # add type
    if ( $Param{Type} ) {
        $SQL .= ' WHERE task_type = ?';
        @Bind = ( \$Param{Type} );
    }

    $SQL .= ' ORDER BY id ASC';

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask the database
    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    # fetch the result
    my @List;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        push @List, {
            TaskID            => $Row[0],
            Name              => $Row[1],
            Type              => $Row[2],
            LastExecutionTime => $Row[3],
            LockKey           => $Row[4] // 0,
            LockTime          => $Row[5] // '',
            CreateTime        => $Row[6],
            ChangeTime        => $Row[7],
        };
    }

    return @List;
}

=head2 RecurrentTaskDelete()

delete a task from scheduler recurrent task list

    my $Success = $SchedulerDBObject->RecurrentTaskDelete(
        TaskID => 123,
    );

=cut

sub RecurrentTaskDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TaskID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TaskID!',
        );
        return;
    }

    # get task to delete cache
    my %Task = $Self->RecurrentTaskGet(
        TaskID => $Param{TaskID},
    );

    # delete task from the recurrent task list
    $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM scheduler_recurrent_task WHERE id = ?',
        Bind => [ \$Param{TaskID} ],
    );

    # delete cache if task exits before the delete
    if (%Task) {

        my $CacheKey = "$Task{Name}::$Task{Type}";

        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'SchedulerDBRecurrentTaskExecute',
            Key  => '$CacheKey',
        );
    }

    return 1;
}

=head2 RecurrentTaskExecute()

executes recurrent tasks like cron or generic agent tasks

    my $Success = $SchedulerDBObject->RecurrentTaskExecute(
        NodeID                   => 1,                 # the ID of the node in a cluster environment
        PID                      => 456,               # the process ID of the daemon that is creating
                                                       #    the tasks to execution
        TaskName                 => 'UniqueTaskName',
        TaskType                 => 'Cron',
        PreviousEventTimestamp   => 1433212343,
        MaximumParallelInstances => 1,                 # optional (default 0) number of tasks with the
                                                       #    same name and type that can be in execution
                                                       #    table at the same time, value of 0 means
                                                       #    unlimited
        Data                   => {                    # data payload
            ...
        },
    );

=cut

sub RecurrentTaskExecute {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(NodeID PID TaskName TaskType PreviousEventTimestamp Data)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );

            return;
        }
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheKey = "$Param{TaskName}::$Param{TaskType}";

    # read cache
    my $Cache = $CacheObject->Get(
        Type           => 'SchedulerDBRecurrentTaskExecute',
        Key            => $CacheKey,
        CacheInMemory  => 0,
        CacheInBackend => 1,
    );

    return 1 if $Cache && $Cache eq $Param{PreviousEventTimestamp};

    # get needed objects
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $LastExecutionTimeStamp;

    # get entry id and last execution time from database
    my $EntryID;
    TRY:
    for my $Try ( 1 .. 10 ) {

        # insert entry if not exists
        if ( $Try ne 1 ) {

            return if !$DBObject->Do(
                SQL => "
                    INSERT INTO scheduler_recurrent_task
                        (name, task_type, last_execution_time, lock_key, create_time, change_time)
                    VALUES
                        (?, ?, ?, 0, current_timestamp, current_timestamp)",
                Bind => [
                    \$Param{TaskName},
                    \$Param{TaskType},
                    \$Param{PreviousEventTimestamp},
                ],
            );
        }

        # get entry id
        next TRY if !$DBObject->Prepare(
            SQL => "
                SELECT id, last_execution_time
                FROM scheduler_recurrent_task
                WHERE task_type = ? AND name = ?",
            Bind => [
                \$Param{TaskType},
                \$Param{TaskName},
            ],
        );

        # fetch the entry id
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $EntryID                = $Row[0];
            $LastExecutionTimeStamp = $Row[1];
        }

        last TRY if $EntryID;
    }

    return if !$EntryID;

    if ( $LastExecutionTimeStamp eq $Param{PreviousEventTimestamp} ) {

        # set cache
        $CacheObject->Set(
            Type           => 'SchedulerDBRecurrentTaskExecute',
            Key            => $CacheKey,
            TTL            => 60 * 5,
            Value          => $Param{PreviousEventTimestamp},
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );

        return 1;
    }

    # create the lock key
    my $LockKeyNodeID = sprintf "%03d", $Param{NodeID};
    my $LockKeyPID    = sprintf "%08d", $Param{PID};
    my $LockKey       = '1' . $LockKeyNodeID . $LockKeyPID;

    # lock the entry in database
    return if !$DBObject->Do(
        SQL => '
            UPDATE scheduler_recurrent_task
            SET lock_key = ?, lock_time = current_timestamp, change_time = current_timestamp
            WHERE lock_key = 0 AND id = ?',
        Bind => [
            \$LockKey,
            \$EntryID,
        ],
    );

    # get locked entry
    $DBObject->Prepare(
        SQL  => 'SELECT lock_key FROM scheduler_recurrent_task WHERE id = ?',
        Bind => [ \$EntryID ],
    );

    # fetch the result
    my $LockKeyFromDB = '';
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $LockKeyFromDB = $Data[0];
    }

    return 1 if $LockKeyFromDB ne $LockKey;

    # set cache
    $CacheObject->Set(
        Type           => 'SchedulerDBRecurrentTaskExecute',
        Key            => $CacheKey,
        TTL            => 60 * 5,
        Value          => $Param{PreviousEventTimestamp},
        CacheInMemory  => 0,
        CacheInBackend => 1,
    );

    # add the task
    my $TaskID = $Self->TaskAdd(
        Type                     => $Param{TaskType},
        Name                     => $Param{TaskName},
        Attempts                 => 1,
        MaximumParallelInstances => $Param{MaximumParallelInstances},
        Data                     => $Param{Data},
    );

    # unlock the task
    if ( IsPositiveInteger($TaskID) ) {
        $DBObject->Do(
            SQL => '
                UPDATE scheduler_recurrent_task
                SET lock_key = 0, lock_time = NULL, last_execution_time = ?, last_worker_task_id = ?,
                    change_time = current_timestamp
                WHERE lock_key = ? AND id = ?',
            Bind => [
                \$Param{PreviousEventTimestamp},
                \$TaskID,
                \$LockKey,
                \$EntryID,
            ],
        );
    }
    else {
        $DBObject->Do(
            SQL => '
                UPDATE scheduler_recurrent_task
                SET lock_key = 0, lock_time = NULL, change_time = current_timestamp
                WHERE lock_key = ? AND id = ?',
            Bind => [
                \$LockKey,
                \$EntryID,
            ],
        );
    }

    return 1 if $TaskID;

    # error handling
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => "Could not create new scheduler recurrent task $Param{TaskName}!",
    );

    return;
}

=head2 RecurrentTaskSummary()

get a summary of the recurring tasks for the specified task type

    my @Summary = $SchedulerDBObject->RecurrentTaskSummary(
        Type         => 'some_type',
        DisplayType  => 'some type',
        TaskLookup   => {                       # only tasks with names in this table will be shown
            TaskName1 => '* * * * *',           #   the value of the items in this table is a crontab
            TaskName3 => '*/1 3,4 * * * 0',     #   format schedule
        }
    );

=cut

sub RecurrentTaskSummary {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Type DisplayType TaskLookup)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return ();
        }
    }

    if ( ref $Param{TaskLookup} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "TaskLookup is invalid!",
        );

        return ();
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask the database
    return () if !$DBObject->Prepare(
        SQL => '
            SELECT id, name, task_type, last_execution_time, last_worker_status, last_worker_running_time
            FROM scheduler_recurrent_task
            WHERE task_type = ?
            ORDER BY id ASC',
        Bind => [ \$Param{Type} ],
    );

    # get needed objects
    my $CronEventObject = $Kernel::OM->Get('Kernel::System::CronEvent');

    # fetch the result
    my @List;
    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # skip tasks that are not registered in the TaskLookup table
        my $Schedule = $Param{TaskLookup}->{ $Row[1] };

        next ROW if !$Schedule;

        # calculate next cron event time
        my $NextExecutionTime = $CronEventObject->NextEventGet(
            Schedule => $Schedule,
        );

        my $LastWorkerStatus;
        if ( defined $Row[4] ) {
            $LastWorkerStatus = $Row[4] ? 'Success' : 'Fail';
        }

        my $LastWorkerRunningTime;
        if ( defined $Row[5] ) {
            $LastWorkerRunningTime = $Self->_Seconds2String( $Row[5] );
        }

        push @List, {
            Name                  => $Row[1],
            Type                  => $Row[2],
            LastExecutionTime     => $Row[3] // '',
            NextExecutionTime     => $NextExecutionTime // '',
            LastWorkerStatus      => $LastWorkerStatus // 'N/A',
            LastWorkerRunningTime => $LastWorkerRunningTime // 'N/A',
        };
    }

    return (
        {
            Header => "Recurrent $Param{DisplayType} tasks:",
            Column => [
                {
                    Name        => 'Name',
                    DisplayName => 'Name',
                    Size        => 40,
                },
                {
                    Name        => 'LastExecutionTime',
                    DisplayName => 'Last Execution',
                    Size        => 20,
                },
                {
                    Name        => 'LastWorkerStatus',
                    DisplayName => 'Last Status',
                    Size        => 12,
                },
                {
                    Name        => 'LastWorkerRunningTime',
                    DisplayName => 'Last Duration',
                    Size        => 18,
                },
                {
                    Name        => 'NextExecutionTime',
                    DisplayName => 'Next Execution',
                    Size        => 20,
                },
            ],
            Data          => \@List,
            NoDataMessage => "There are currently no $Param{DisplayType} recurring tasks configured.",
        },
    );
}

=head2 RecurrentTaskWorkerInfoSet()

sets last worker information (success status and running time) to a recurrent task

    my $Success = $SchedulerDBObject->RecurrentTaskWorkerInfoSet(
        LastWorkerTaskID      => 123,        # the task ID from the worker table that is performing the
                                             #      recurring task
        LastWorkerStatis      => 1,          # optional 1 or 0, defaults to 0, 1 means success
        LastWorkerRunningTime => 123,        # optional, defaults to 0, the number in seconds a worker took
                                             #      to complete the task
    );

=cut

sub RecurrentTaskWorkerInfoSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{LastWorkerTaskID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need LastWorkerTaskID!",
        );

        return;
    }

    my $LastWorkerStatus      = $Param{LastWorkerStatus} ? 1 : 0;
    my $LastWorkerRunningTime = $Param{LastWorkerRunningTime} // 0;

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            UPDATE scheduler_recurrent_task
            SET last_worker_status = ?, last_worker_running_time = ?, change_time = current_timestamp
            WHERE last_worker_task_id = ?',
        Bind => [
            \$LastWorkerStatus,
            \$LastWorkerRunningTime,
            \$Param{LastWorkerTaskID},
        ],
    );

    return 1;
}

=head2 RecurrentTaskUnlockExpired()

remove lock status for recurring tasks that has been locked for more than 1 minutes

    my $Success = $SchedulerDBObject->RecurrentTaskUnlockExpired(
        Type => 'some_type',
    );

=cut

sub RecurrentTaskUnlockExpired {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Type} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Type",
        );
    }

    # get needed objects
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask the database (get all recurrent tasks for the given type with a lock key different than 0)
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, name, lock_time
            FROM scheduler_recurrent_task
            WHERE task_type = ?
                AND lock_key <> 0
            ORDER BY id ASC',
        Bind => [ \$Param{Type} ],
    );

    # fetch the result
    my @List;
    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # get current system time
        my $SystemTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

        # convert lock time stamp to a system time
        my $LockTime = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Row[2],
            },
        );
        $LockTime = $LockTime ? $LockTime->ToEpoch() : 0;

        # skip task if it has been locked within the last minute
        next ROW if $SystemTime - $LockTime < 60;

        push @List, {
            TaskID   => $Row[0],
            Name     => $Row[1],
            LockTime => $Row[2],
        };
    }

    # stop if there are no tasks to unlock
    return 1 if !@List;

    for my $Task (@List) {

        # unlock all the task that has been locked for more than 1 minute
        return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => '
                UPDATE scheduler_recurrent_task
                SET lock_key = 0, lock_time = NULL, change_time = current_timestamp
                WHERE id = ?',
            Bind => [ \$Task->{TaskID}, ],
        );
    }

    return 1;
}

=head1 PRIVATE INTERFACE

=head2 _Seconds2String()

convert an amount of seconds to a more human readable format, e.g. < 1 Second, 5 Minutes

    my $String = $SchedulerDBObject->_Seconds2String(.2);

returns

    $String = '< 1 Second';

or

    my $String = $SchedulerDBObject->_Seconds2String(8);

returns

    $String = '8 Second(s)';

or

    my $String = $SchedulerDBObject->_Seconds2String(62);

returns

    $String = '1 Minute(s)';

or

    my $String = $SchedulerDBObject->_Seconds2String(3610);

returns

    $String = '1 Hour(s)';

or

    my $String = $SchedulerDBObject->_Seconds2String(86_640);

returns

    $String = '1 Day(s)';

=cut

sub _Seconds2String {
    my ( $Self, $Seconds ) = @_;

    return '< 1 Second' if $Seconds < 1;

    if ( $Seconds >= 24 * 60 * 60 ) {
        return sprintf '%.1f Day(s)', $Seconds / ( 24 * 60 * 60 );
    }
    elsif ( $Seconds >= 60 * 60 ) {
        return sprintf '%.1f Hour(s)', $Seconds / ( 60 * 60 );
    }
    elsif ( $Seconds >= 60 ) {
        return sprintf '%.1f Minute(s)', $Seconds / (60);
    }
    else {
        return sprintf '%.1f Second(s)', $Seconds;
    }
}

=head2 _GetIdentifier()

calculate a task identifier.

    my $Identifier = $SchedulerDBObject->_GetIdentifier();

returns

    $Identifier = 1234456789;

=cut

sub _GetIdentifier {
    my ( $Self, %Param ) = @_;

    my ( $Seconds, $Microseconds ) = Time::HiRes::gettimeofday();
    my $ProcessID = $$;

    my $Identifier = $ProcessID . $Microseconds;

    my $RandomString = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
        Length     => 18 - length $Identifier,
        Dictionary => [ 0 .. 9 ],                # numeric
    );

    $Identifier .= $RandomString;

    return $Identifier;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
