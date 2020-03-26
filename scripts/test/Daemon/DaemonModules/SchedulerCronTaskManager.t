# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

# Broken on certain Perl 5.28 versions due to a Perl crash that we can't work around.
my @BlacklistPerlVersions = (
    v5.26.1,
    v5.26.3,
    v5.28.1,
    v5.28.2,
    v5.30.0,
    v5.30.1,
    v5.30.2,
);

if ( grep { $^V eq $_ } @BlacklistPerlVersions ) {
    $Self->True( 1, "Current Perl version $^V is known to be buggy for this test, skipping." );
    return 1;
}

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $Home   = $ConfigObject->Get('Home');
my $Daemon = $Home . '/bin/otrs.Daemon.pl';

# get current daemon status
my $PreviousDaemonStatus = `$Daemon status`;

# stop daemon if it was already running before this test
if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    `$^X $Daemon stop`;

    my $SleepTime = 2;

    # wait to get daemon fully stopped before test continues
    print "A running Daemon was detected and need to be stopped...\n";
    print 'Sleeping ' . $SleepTime . "s\n";
    sleep $SleepTime;
}

# get needed objects
my $TaskWorkerObject  = $Kernel::OM->Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker');
my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');
my $Helper            = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RunTasks = sub {

    local $SIG{CHLD} = "IGNORE";

    # wait until task is executed
    ACTIVESLEEP:
    for my $Sec ( 1 .. 120 ) {

        # run the worker
        $TaskWorkerObject->Run();
        $TaskWorkerObject->_WorkerPIDsCheck();

        my @List = $SchedulerDBObject->TaskList();

        last ACTIVESLEEP if !scalar @List;

        sleep 1;

        print "Waiting $Sec secs for scheduler tasks to be executed\n";
    }
};

$RunTasks->();

# get original Cron settings
my $OriginalSettings = $ConfigObject->Get('Daemon::SchedulerCronTaskManager::Task') || {};

# remove all Cron jobs from config
$ConfigObject->Set(
    Key   => 'Daemon::SchedulerCronTaskManager::Task',
    Value => {},
);

# freeze time
$Helper->FixedTimeSet();

my $CurSysDTObject = $Kernel::OM->Create('Kernel::System::DateTime');

# go back in time to have 0 seconds in the current minute
$Helper->FixedTimeAddSeconds( $CurSysDTObject->Get()->{Second} - 60 );

# get random ID
my $RandomID = $Helper->GetRandomID();

my @Tests = (
    {
        Name    => 'No Schedule',
        CronJob => {
            Name => 'NoSchedule' . $RandomID,
            Data => {
                TaskName => 'NoSchedule' . $RandomID,
                Module   => 'Admin::Package::List',
                Function => 'run',
            },
        },
        TaskAdd => 0,
    },
    {
        Name    => 'Wrong Schedule',
        CronJob => {
            Name => 'WrongSchedue' . $RandomID,
            Data => {
                TaskName => 'NoSchedule' . $RandomID,
                Module   => 'Admin::Package::List',
                Function => 'run',
                Schedule => '\1 * * * *',
            },
        },
        TaskAdd => 0,
    },

    # Test block (this tests needs to be run together in the same order)
    {
        Name    => 'All Minutes',
        CronJob => {
            Name => 'CronAllMinutes' . $RandomID,
            Data => {
                TaskName => 'CronAllMinutes' . $RandomID,
                Module   => 'Admin::Package::List',
                Function => 'run',
                Schedule => '* * * * *',
            },
        },
        TaskAdd  => 1,
        KeepCron => 1,
    },
    {
        Name       => 'All Minutes (same minute)',
        CronName   => 'CronAllMinutes' . $RandomID,
        TaskAdd    => 0,
        SecondsAdd => 50,
        KeepCron   => 1,
    },
    {
        Name     => 'All Minutes (same minute w/o cache)',
        CronName => 'CronAllMinutes' . $RandomID,
        TaskAdd  => 0,
        NoCache  => 1,
        KeepCron => 1,
    },
    {
        Name       => 'All Minutes (next minute)',
        CronName   => 'CronAllMinutes' . $RandomID,
        TaskAdd    => 1,
        SecondsAdd => 10,
    },

    # Test block end

);

# get needed objects
my $TaskManagerObject = $Kernel::OM->Get('Kernel::System::Daemon::DaemonModules::SchedulerCronTaskManager');
my $CacheObject       = $Kernel::OM->Get('Kernel::System::Cache');

TESTCASE:
for my $Test (@Tests) {

    my $CronName;

    # create a Cron job if needed
    if ( $Test->{CronJob} ) {
        my $CronAdd = $ConfigObject->Set(
            Key   => "Daemon::SchedulerCronTaskManager::Task###$Test->{CronJob}->{Name}",
            Value => $Test->{CronJob}->{Data},
        );
        $Self->True(
            $CronAdd,
            "$Test->{Name} Cron setting added - for Cron job '$Test->{CronJob}->{Name}' with true",
        );

        $CronName = $Test->{CronJob}->{Name};

        # run the task manager
        my $RunSuccess = $TaskManagerObject->Run();
        $Self->True(
            $RunSuccess,
            "$Test->{Name} task manager Run() - with true (this will create the recurrent task but not execution)",
        );

        my $StartSystemTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        my $SecondsAdd            = ( 60 - $StartSystemTimeObject->Get()->{Second} );

        $Helper->FixedTimeAddSeconds($SecondsAdd);

        my $EndSystemTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

        printf(
            "Added %s seconds to time (initial adjustment) from %s to %s\n",
            $SecondsAdd,
            $StartSystemTimeObject->ToEpoch(),
            $EndSystemTimeObject->ToEpoch(),
        );
    }

    $CronName //= $Test->{CronName} || '';

    # add seconds if needed
    if ( $Test->{SecondsAdd} ) {
        my $StartSystemTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
        $Helper->FixedTimeAddSeconds( $Test->{SecondsAdd} );
        my $EndSystemTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
        printf(
            "  Added %s seconds to time from %s to %s\n",
            $Test->{SecondsAdd},
            $StartSystemTime,
            $EndSystemTime,
        );
    }

    # cleanup Task Manager Cache
    my $Cache;
    if ( $Test->{NoCache} ) {
        $Cache = $CacheObject->Get(
            Type           => 'SchedulerDBRecurrentTaskExecute',
            Key            => $CronName . '::Cron',
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );
        $CacheObject->CleanUp(
            Type => 'SchedulerDBRecurrentTaskExecute',
        );
        print "  Cache cleared before task manager execution...\n";
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
            Key            => $CronName . '::Cron',
            Value          => $Cache,
            TTL            => 60 * 5,
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );
        print "  Cache restored after task manager execution...\n";
    }

    my @List = $SchedulerDBObject->TaskList(
        Type => 'Cron',
    );

    my @FilteredList = grep { $_->{Name} eq $CronName } @List;

    if ( $Test->{TaskAdd} ) {
        $Self->Is(
            scalar @FilteredList,
            1,
            "$Test->{Name} - task manager creates one task",
        );

        local $SIG{CHLD} = "IGNORE";

        # wait until task is executed
        ACTIVESLEEP:
        for my $Sec ( 1 .. 120 ) {

            # run the worker
            $TaskWorkerObject->Run();
            $TaskWorkerObject->_WorkerPIDsCheck();

            @List = $SchedulerDBObject->TaskList(
                Type => 'Cron',
            );

            @FilteredList = grep {$CronName} @List;

            last ACTIVESLEEP if !scalar @FilteredList;

            sleep 1;

            print "  Waiting $Sec secs for the task to be executed\n";
        }

        @List = $SchedulerDBObject->TaskList(
            Type => 'Cron',
        );

        @FilteredList = grep {$CronName} @List;
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

    next TESTCASE if $Test->{KeepCron};

    # remove all Cron jobs from config
    my $CronDelete = $ConfigObject->Set(
        Key   => 'Daemon::SchedulerCronTaskManager::Task',
        Value => {},
    );
    $Self->True(
        $CronDelete,
        "$Test->{Name} Delete Cron Tasks - with true",
    );

    # recurrent task delete
    @List = $SchedulerDBObject->RecurrentTaskList(
        Type => 'Cron',
    );

    @FilteredList = grep { $_->{Name} eq $CronName } @List;

    TASK:
    for my $Task (@FilteredList) {
        next TASK if $Task->{Type} ne 'Cron';
        next TASK if $Task->{Name} ne $CronName;

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
my $CleanupSuccess = $SchedulerDBObject->CronTaskCleanup();
$Self->True(
    $CleanupSuccess,
    "CronTaskCleanup() - executed with true",
);

# CronTaskToExecute() tests
my $CronName = 'CronAllMinutes' . $RandomID;

my $CronAdd = $ConfigObject->Set(
    Key   => "Daemon::SchedulerCronTaskManager::Task###$CronName",
    Value => {
        TaskName => $CronName,
        Module   => 'Admin::Package::List',
        Function => 'run',
        Schedule => '* * * * *',
    },
);
$Self->True(
    $CronAdd,
    "Cron setting added - for Cron job '$CronName' with true",
);

my %TestJobNames = (
    "CronAllMinutes$RandomID" => 1,
    "UnitTest$RandomID"       => 1,
    "Test$RandomID"           => 1,
    "SafeToDelete$RandomID"   => 1,
);

# get db object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

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
            \'Cron',
        ],
    );
    $Self->True(
        $AddSucess,
        "Recurrent task added - for Cron job '$Name' with true",
    );
}

# make sure all task are listed
my @List = $SchedulerDBObject->RecurrentTaskList(
    Type => 'Cron',
);

my %FilteredTaskNames = map { $_->{Name} => 1 } grep { $TestJobNames{ $_->{Name} } } @List;

for my $Name ( sort keys %TestJobNames ) {
    $Self->True(
        $FilteredTaskNames{$Name},
        "Task $Name exists with true",
    );
}

# remove fake test tasks
$CleanupSuccess = $SchedulerDBObject->CronTaskCleanup();
$Self->True(
    $CleanupSuccess,
    "CronTaskCleanup() - executed with true",
);

# make sure only CronAllMinutes is listed
@List = $SchedulerDBObject->RecurrentTaskList(
    Type => 'Cron',
);

%FilteredTaskNames = map { $_->{Name} => 1 } grep { $TestJobNames{ $_->{Name} } } @List;

for my $Name ( sort keys %TestJobNames ) {
    if ( $Name eq "CronAllMinutes$RandomID" ) {
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

# remove all Cron jobs from config
my $JobDelete = $ConfigObject->Set(
    Key   => 'Daemon::SchedulerCronTaskManager::Task',
    Value => {},
);
$Self->True(
    $JobDelete,
    "Removed all cron task settings - executed with true",
);

# remove all cron jobs from config
$ConfigObject->Set(
    Key   => 'Daemon::SchedulerCronTaskManager::Task',
    Value => $OriginalSettings,
);

# re-create original tasks
my $RunSuccess = $TaskManagerObject->Run();
$Self->True(
    $RunSuccess,
    "Task manager Run() - with true",
);

# also remove the task form the just removed Cron job
$CleanupSuccess = $SchedulerDBObject->CronTaskCleanup();
$Self->True(
    $CleanupSuccess,
    "CronTaskCleanup() - executed with true",
);

# start daemon if it was already running before this test
if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    system("$^X $Daemon start");
}

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

1;
