# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my $Daemon = $Home . '/bin/otrs.Daemon.pl';

# get current daemon status
my $PreviousDaemonStatus = `$Daemon status`;

# stop daemon if it was already running before this test
if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    `$Daemon stop`;

    my $SleepTime = 2;

    # wait to get daemon fully stopped before test continues
    print "A running Daemon was detected and need to be stopped...\n";
    print 'Sleeping ' . $SleepTime . "s\n";
    sleep $SleepTime;
}

# get needed objects
my $TaskWorkerObject  = $Kernel::OM->Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker');
my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

# wait until task is executed
ACTIVESLEEP:
for my $Sec ( 1 .. 120 ) {

    # run the worker
    $TaskWorkerObject->Run();

    my @List = $SchedulerDBObject->TaskList();

    last ACTIVESLEEP if !scalar @List;

    sleep 1;

    print "Waiting $Sec secs for scheduler tasks to be executed\n";
}

# get helper object
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# freeze time
$HelperObject->FixedTimeSet();

my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay ) = $TimeObject->SystemTime2Date(
    SystemTime => $TimeObject->SystemTime(),
);

my $SecsDiff = $Sec - 60;

# go back in time to have 0 seconds in the current minute
$HelperObject->FixedTimeAddSeconds($SecsDiff);

# get random ID
my $RandomID = $HelperObject->GetRandomID();

my @Tests = (
    {
        Name  => 'No Schedule',
        GAJob => {
            Name => 'GANoSchedue' . $RandomID,
            Data => {
                Title     => 'GA' . $RandomID,
                NewDelete => 0,
                Valid     => 1,
            },
        },
        TaskAdd => 0,
    },
    {
        Name  => 'No Minutes',
        GAJob => {
            Name => 'GANoMinutes' . $RandomID,
            Data => {
                ScheduleHours => [ 0 .. 23 ],
                ScheduleDays  => [ 0 .. 6 ],
                Title         => 'GA' . $RandomID,
                NewDelete     => 0,
                Valid         => 1,
            },
        },
        TaskAdd => 0,
    },
    {
        Name  => 'No Hours',
        GAJob => {
            Name => 'GANoHours' . $RandomID,
            Data => {
                ScheduleMinutes => [ 0 .. 59 ],
                ScheduleDays    => [ 0 .. 6 ],
                Title           => 'GA' . $RandomID,
                NewDelete       => 0,
                Valid           => 1,
            },
        },
        TaskAdd => 0,
    },
    {
        Name  => 'No Days',
        GAJob => {
            Name => 'GANoHours' . $RandomID,
            Data => {
                ScheduleMinutes => [ 0 .. 59 ],
                ScheduleHours   => [ 0 .. 23 ],
                Title           => 'GA' . $RandomID,
                NewDelete       => 0,
                Valid           => 1,
            },
        },
        TaskAdd => 0,
    },
    {
        Name  => 'Wrong Schedule Format string',
        GAJob => {
            Name => 'GAAllWrongSchedueFormat' . $RandomID,
            Data => {
                ScheduleMinutes => 'a',
                ScheduleHours   => [ 0 .. 23 ],
                ScheduleDays    => [ 0 .. 6 ],
                Title           => 'GA' . $RandomID,
                NewDelete       => 0,
                Valid           => 1,
            },
        },
        TaskAdd => 0,
    },
    {
        Name  => 'Wrong Schedule Format array',
        GAJob => {
            Name => 'GAAllWrongSchedueFormat' . $RandomID,
            Data => {
                ScheduleMinutes => ['a'],
                ScheduleHours   => [ 0 .. 23 ],
                ScheduleDays    => [ 0 .. 6 ],
                Title           => 'GA' . $RandomID,
                NewDelete       => 0,
                Valid           => 1,
            },
        },
        TaskAdd => 0,
    },

    # Test block (this tests needs to be run together in the same order)
    {
        Name  => 'All Minutes',
        GAJob => {
            Name => 'GAAllMinutes' . $RandomID,
            Data => {
                ScheduleMinutes => [ 0 .. 59 ],
                ScheduleHours   => [ 0 .. 23 ],
                ScheduleDays    => [ 0 .. 6 ],
                Title           => 'GA' . $RandomID,
                NewDelete       => 0,
                Valid           => 1,
            },
        },
        TaskAdd => 1,
        KeepJob => 1,
    },
    {
        Name       => 'All Minutes (same minute)',
        JobName    => 'GAAllMinutes' . $RandomID,
        TaskAdd    => 0,
        SecondsAdd => 50,
        KeepJob    => 1,
    },
    {
        Name    => 'All Minutes (same minute w/o cache)',
        JobName => 'GAAllMinutes' . $RandomID,
        TaskAdd => 0,
        NoCache => 1,
        KeepJob => 1,
    },
    {
        Name       => 'All Minutes (next minute)',
        JobName    => 'GAAllMinutes' . $RandomID,
        TaskAdd    => 1,
        SecondsAdd => 10,
    },

    # Test block end

);

# get needed objects
my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');
my $TaskManagerObject  = $Kernel::OM->Get('Kernel::System::Daemon::DaemonModules::SchedulerGenericAgentTaskManager');
my $CacheObject        = $Kernel::OM->Get('Kernel::System::Cache');

TESTCASE:
for my $Test (@Tests) {

    my $JobName;

    # create a GA job if needed
    if ( $Test->{GAJob} ) {
        my $JobAdd = $GenericAgentObject->JobAdd(
            %{ $Test->{GAJob} },
            UserID => 1,
        );
        $Self->True(
            $JobAdd,
            "$Test->{Name} JobAdd() - for GA job '$Test->{GAJob}->{Name}' with true",
        );

        $JobName = $Test->{GAJob}->{Name};

        # run the task manager
        my $RunSuccess = $TaskManagerObject->Run();
        $Self->True(
            $RunSuccess,
            "$Test->{Name} task manager Run() - with true (this will create the recurrent task but not execution)",
        );

        my $StartSystemTime = $TimeObject->SystemTime();
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay ) = $TimeObject->SystemTime2Date(
            SystemTime => $StartSystemTime,
        );
        my $SecondsAdd = ( 60 - $Sec );
        $HelperObject->FixedTimeAddSeconds($SecondsAdd);
        my $EndSystemTime = $TimeObject->SystemTime();
        print("  Added $SecondsAdd seconds to time (initial adjustment) form $StartSystemTime to $EndSystemTime\n");

    }

    $JobName //= $Test->{JobName} || '';

    # add seconds if needed
    if ( $Test->{SecondsAdd} ) {
        my $StartSystemTime = $TimeObject->SystemTime();
        $HelperObject->FixedTimeAddSeconds( $Test->{SecondsAdd} );
        my $EndSystemTime = $TimeObject->SystemTime();
        print("  Added $Test->{SecondsAdd} seconds to time form $StartSystemTime to $EndSystemTime\n");
    }

    # cleanup Task Manager Cache
    my $Cache;
    if ( $Test->{NoCache} ) {
        $Cache = $CacheObject->Get(
            Type           => 'SchedulerDBRecurrentTaskExecute',
            Key            => $JobName . '::GenericAgent',
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );
        $CacheObject->CleanUp(
            Type => 'SchedulerDBRecurrentTaskExecute',
        );
        print "  Cache cleared before task manager execution...\n"
    }

    # run the task manager
    my $RunSuccess = $TaskManagerObject->Run();
    $Self->True(
        $RunSuccess,
        "$Test->{Name} task manager Run() - with true",
    );

    # return the cache as it was
    if ( $Test->{NoCache} ) {
        $CacheObject->Set(
            Type           => 'SchedulerDBRecurrentTaskExecute',
            Key            => $JobName . '::GenericAgent',
            Value          => $Cache,
            TTL            => 60 * 5,
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );
        print "  Cache restored after task manager execution...\n";
    }

    my @List = $SchedulerDBObject->TaskList(
        Type => 'GenericAgent',
    );

    my @FilteredList = grep { $_->{Name} eq $JobName } @List;

    if ( $Test->{TaskAdd} ) {
        $Self->Is(
            scalar @FilteredList,
            1,
            "$Test->{Name} - task manager creates one task",
        );

        # wait until task is executed
        ACTIVESLEEP:
        for my $Sec ( 1 .. 120 ) {

            # run the worker
            $TaskWorkerObject->Run();

            @List = $SchedulerDBObject->TaskList(
                Type => 'GenericAgent',
            );

            @FilteredList = grep {$JobName} @List;

            last ACTIVESLEEP if !scalar @FilteredList;

            sleep 1;

            print "  Waiting $Sec secs for the task to be executed\n";
        }

        @List = $SchedulerDBObject->TaskList(
            Type => 'GenericAgent',
        );

        @FilteredList = grep {$JobName} @List;
        $Self->Is(
            scalar @FilteredList,
            0,
            "$Test->{Name} - task worker execute the task",
        );

    }
    else {
        $Self->Is(
            scalar @FilteredList,
            0,
            "$Test->{Name} - task manager should not create any tasks"
        );

    }

    next TESTCASE if $Test->{KeepJob};

    my $JobDelete = $GenericAgentObject->JobDelete(
        Name   => ($JobName),
        UserID => 1,
    );
    $Self->True(
        $JobDelete,
        "$Test->{Name} JobDelete() - for GA job '$JobName' with true",
    );

    # recurrent task delete
    @List = $SchedulerDBObject->RecurrentTaskList(
        Type => 'GenericAgent',
    );

    @FilteredList = grep { $_->{Name} eq $JobName } @List;

    TASK:
    for my $Task (@FilteredList) {
        next TASK if $Task->{Type} ne 'GenericAgent';
        next TASK if $Task->{Name} ne $JobName;

        my $TaskID = $Task->{TaskID};

        my $Success = $SchedulerDBObject->RecurrentTaskDelete(
            TaskID => $TaskID,
        );
        $Self->True(
            $Success,
            "RecurrentTaskDelete() - for $TaskID with true",
        );
    }
}

# cleanup
my $CleanupSuccess = $SchedulerDBObject->GenericAgentTaskCleanup();
$Self->True(
    $CleanupSuccess,
    "GenericAgentTaskCleanup() - executed with true",
);

# GenericAgentTaskToExecute() tests
my $JobName = 'GAAllMinutes' . $RandomID;

my $JobAdd = $GenericAgentObject->JobAdd(
    Name => $JobName,
    Data => {
        ScheduleMinutes => [ 0 .. 59 ],
        ScheduleHours   => [ 0 .. 23 ],
        ScheduleDays    => [ 0 .. 6 ],
        Title           => 'GA' . $RandomID,
        NewDelete       => 0,
        Valid           => 1,
    },
    UserID => 1,
);
$Self->True(
    $JobAdd,
    "JobAdd() - for GA job '$JobName' with true",
);

my %TestJobNames = (
    "GAAllMinutes$RandomID" => 1,
    "UnitTest$RandomID"     => 1,
    "Test$RandomID"         => 1,
    "SafeToDelete$RandomID" => 1,
);

# get db object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

my $SystemTime = $TimeObject->SystemTime();

# add tasks
for my $Name ( sort keys %TestJobNames ) {
    my $AddSucess = $DBObject->Do(
        SQL => "
            INSERT INTO scheduler_recurrent_task
                (name, task_type, last_execution_time, lock_key, create_time, change_time)
            VALUES
                (?, ?, current_timestamp, 0, current_timestamp, current_timestamp)",
        Bind => [
            \$Name,
            \'GenericAgent',
        ],
    );
    $Self->True(
        $AddSucess,
        "Recurrent task added - for GA job '$Name' with true",
    );
}

# make sure all task are listed
my @List = $SchedulerDBObject->RecurrentTaskList(
    Type => 'GenericAgent',
);

my %FilteredTaskNames = map { $_->{Name} => 1 } grep { $TestJobNames{ $_->{Name} } } @List;

for my $Name ( sort keys %TestJobNames ) {
    $Self->True(
        $FilteredTaskNames{$Name},
        "Task $Name exists with true",
    );
}

# remove fake test tasks
$CleanupSuccess = $SchedulerDBObject->GenericAgentTaskCleanup();
$Self->True(
    $CleanupSuccess,
    "GenericAgentTaskCleanup() - executed with true",
);

# make sure only GAAllMinutes is listed
@List = $SchedulerDBObject->RecurrentTaskList(
    Type => 'GenericAgent',
);

%FilteredTaskNames = map { $_->{Name} => 1 } grep { $TestJobNames{ $_->{Name} } } @List;

for my $Name ( sort keys %TestJobNames ) {
    if ( $Name eq "GAAllMinutes$RandomID" ) {
        $Self->True(
            $FilteredTaskNames{$Name},
            "Task $Name exists with true",
        );
    }
    else {
        $Self->False(
            $FilteredTaskNames{$Name},
            "Task $Name exists with False",
        );
    }
}

my $JobDelete = $GenericAgentObject->JobDelete(
    Name   => $JobName,
    UserID => 1,
);
$Self->True(
    $JobDelete,
    "JobDelete() - for GA job '$JobName' with true",
);

# also remove the task form the just deleted GenericAgen job
$CleanupSuccess = $SchedulerDBObject->GenericAgentTaskCleanup();
$Self->True(
    $CleanupSuccess,
    "GenericAgentTaskCleanup() - executed with true",
);

# start daemon if it was already running before this test
if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    system("$Daemon start");
}

1;
