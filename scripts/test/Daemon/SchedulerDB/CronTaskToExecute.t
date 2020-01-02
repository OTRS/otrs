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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $Home   = $ConfigObject->Get('Home');
my $Daemon = $Home . '/bin/otrs.Daemon.pl';

# Get current daemon status.
my $PreviousDaemonStatus = `$Daemon status`;

# Check if there is permissions for daemon commands.
if ( !defined $PreviousDaemonStatus ) {
    $Self->False(
        0,
        'Permission denied for deamon commands, skipping test',
    );
    return 1;
}

# Stop daemon if it was already running before this test.
if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    `$^X $Daemon stop`;

    my $SleepTime = 2;

    # Wait to get daemon fully stopped before test continues.
    print "A running Daemon was detected and need to be stopped...\n";
    print 'Sleeping ' . $SleepTime . "s\n";
    sleep $SleepTime;
}

my $TaskWorkerObject  = $Kernel::OM->Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker');
my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

my $RunTasks = sub {

    local $SIG{CHLD} = "IGNORE";

    # Wait until task is executed.
    my $AllTaskIsDone = 1;
    ACTIVESLEEP:
    for my $Sec ( 1 .. 120 ) {

        # Run the worker
        $TaskWorkerObject->Run();
        $TaskWorkerObject->_WorkerPIDsCheck();

        my @List = $SchedulerDBObject->TaskList();

        last ACTIVESLEEP if !scalar @List;

        sleep 1;

        print "Waiting $Sec secs for scheduler tasks to be executed\n";

        if ( $Sec == 120 && scalar @List ) {
            $AllTaskIsDone = 0;
        }
    }

    return $AllTaskIsDone;
};

my $AllTaskIsDone = $RunTasks->();
if ( !$AllTaskIsDone ) {
    $Self->False(
        0,
        'There are active tasks, skipping test',
    );
    return 1;
}

# Remove all Cron jobs from config
$ConfigObject->Set(
    Key   => 'Daemon::SchedulerCronTaskManager::Task',
    Value => {},
);

my @Tests = (
    {
        Name              => 'No Tasks',
        Config            => {},
        ExpectedTaskCount => 0,
    },
    {
        Name   => '1 Task',
        Config => {
            Task1 => {
                TaskName                 => 'Task1',
                Schedule                 => '* * * * *',
                MaximumParallelInstances => '1',
                Module                   => 'Kernel::System::Console::Command::Admin::Queue::List',
                Function                 => 'Execute',
                Params                   => [],
            },
        },
        ExpectedTaskCount => 1,
    },
    {
        Name   => '5 Tasks',
        Config => {
            Task1 => {
                TaskName                 => 'Task1',
                Schedule                 => '* * * * *',
                MaximumParallelInstances => '1',
                Module                   => 'Kernel::System::Console::Command::Admin::Queue::List',
                Function                 => 'Execute',
                Params                   => [],
            },
            Task2 => {
                TaskName                 => 'Task2',
                Schedule                 => '* * * * *',
                MaximumParallelInstances => '1',
                Module                   => 'Kernel::System::Console::Command::Admin::Queue::List',
                Function                 => 'Execute',
                Params                   => [],
            },
            Task3 => {
                TaskName                 => 'Task3',
                Schedule                 => '* * * * *',
                MaximumParallelInstances => '1',
                Module                   => 'Kernel::System::Console::Command::Admin::Queue::List',
                Function                 => 'Execute',
                Params                   => [],
            },
            Task4 => {
                TaskName                 => 'Task4',
                Schedule                 => '* * * * *',
                MaximumParallelInstances => '1',
                Module                   => 'Kernel::System::Console::Command::Admin::Queue::List',
                Function                 => 'Execute',
                Params                   => [],
            },
            Task5 => {
                TaskName                 => 'Task5',
                Schedule                 => '* * * * *',
                MaximumParallelInstances => '1',
                Module                   => 'Kernel::System::Console::Command::Admin::Queue::List',
                Function                 => 'Execute',
                Params                   => [],
            },
        },
        ExpectedTaskCount => 5,
    },
    {
        Name   => '2 Tasks but duplicate name',
        Config => {
            Task1 => {
                TaskName                 => 'Task1',
                Schedule                 => '* * * * *',
                MaximumParallelInstances => '1',
                Module                   => 'Kernel::System::Console::Command::Admin::Queue::List',
                Function                 => 'Execute',
                Params                   => [],
            },
            Task2 => {
                TaskName                 => 'Task1',
                Schedule                 => '* * * * *',
                MaximumParallelInstances => '1',
                Module                   => 'Kernel::System::Console::Command::Admin::Queue::List',
                Function                 => 'Execute',
                Params                   => [],
            },
        },
        ExpectedTaskCount => 1,
    },

);

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
$Helper->FixedTimeSet();

for my $Test (@Tests) {

    # Set new config.
    $ConfigObject->Set(
        Key   => 'Daemon::SchedulerCronTaskManager::Task',
        Value => $Test->{Config},
    );

    # Populate the DB (there will no tasks to execute at this time)
    my $Success = $SchedulerDBObject->CronTaskToExecute(
        NodeID => 1,
        PID    => 456,
    );

    # Add more than 1 minute in order to set task to execute.
    $Helper->FixedTimeAddSeconds(62);

    # With DB populated and time passed set tasks to execute again.
    $Success = $SchedulerDBObject->CronTaskToExecute(
        NodeID => 1,
        PID    => 456,
    );

    my @List = $SchedulerDBObject->TaskList();

    $Self->Is(
        scalar @List,
        $Test->{ExpectedTaskCount},
        "$Test->{Name} - CronTaskToExecute() Task Count"
    );

    $RunTasks->();
}

my @List = $SchedulerDBObject->RecurrentTaskList();

for my $Task (@List) {
    my $Success = $SchedulerDBObject->RecurrentTaskDelete(
        TaskID => $Task->{TaskID},
    );
}

1;
