# --
# Run.t - Scheduler tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Storable qw();

use Kernel::Scheduler;
use Kernel::System::Scheduler::TaskManager;
use Kernel::System::PID;

my @Tests = (
    {
        Name  => 'Nonexisting backend',
        Tasks => [
            {
                Type => 'TestNotExisting',
                Data => {
                    Success => 1,
                },
                Result => 0,
            },
        ],
    },
    {
        Name  => 'Single test task',
        Tasks => [
            {
                Type => 'Test',
                Data => {
                    Success => 0,
                },
                Result => 0,
            },
        ],
    },
    {
        Name  => 'Multiple tasks',
        Tasks => [
            {
                Type => 'Test',
                Data => {
                    Success => 0,
                },
                Result => 0,
            },
            {
                Type => 'TestNotExisting',
                Data => {
                    Success => 1,
                },
                Result => 0,
            },
            {
                Type => 'Test',
                Data => {
                    Success => 0,
                },
                Result => 0,
            },
        ],
    },
);

my $Home = $Self->{ConfigObject}->Get('Home');

# check if scheduler is running (start, if neccessary)
my $Scheduler = $Home . '/bin/otrs.Scheduler.pl';
if ( $^O =~ /^mswin/i ) {
    $Scheduler = "\"$^X\" " . $Home . '/bin/otrs.Scheduler4win.pl';
    $Scheduler =~ s{/}{\\}g
}
my $PreviousSchedulerStatus = `$Scheduler -a status`;

if ( !$PreviousSchedulerStatus ) {
    $Self->False(
        1,
        "Could not determine current scheduler status!",
    );
    die "Could not determine current scheduler status!";
}

if ( $PreviousSchedulerStatus =~ /^not running/i ) {
    if ( $PreviousSchedulerStatus =~ m{registered}i ) {

        # force stop
        `$Scheduler -a stop -f 1`;
        $Self->True(
            1,
            "Force stoping due to bad status...",
        );

        # Wait for slow systems
        my $SleepTime = 120;
        print "Waiting at most $SleepTime s until scheduler stops\n";
        ACTIVESLEEP:
        for my $Seconds ( 1 .. $SleepTime ) {
            my $SchedulerStatus = `$Scheduler -a status`;
            if ( $SchedulerStatus !~ m{\A running }msxi ) {
                last ACTIVESLEEP;
            }
            print "Sleeping for $Seconds seconds...\n";
            sleep 1;
        }
    }

    my $ResultMessage = `$Scheduler -a start 2>&1`;
    $Self->Is(
        $?,
        0,
        "Scheduler start call returned successfully.",
    );

    # give some visibility if the test fail when it should not
    if ($?) {
        $Self->True(
            0,
            "Scheduler start DETECTED $ResultMessage",
        );
    }
}
else {
    $Self->True(
        1,
        "Scheduler was already running.",
    );
}

# Wait for slow systems
my $SleepTime = 120;
print "Waiting at most $SleepTime s until scheduler starts\n";
ACTIVESLEEP:
for my $Seconds ( 1 .. $SleepTime ) {
    my $SchedulerStatus = `$Scheduler -a status`;
    if ( $SchedulerStatus =~ m{\A running }msxi ) {
        last ACTIVESLEEP;
    }
    print "Sleeping for $Seconds seconds...\n";
    sleep 1;
}

my $CurrentSchedulerStatus = `$Scheduler -a status`;

$Self->True(
    int $CurrentSchedulerStatus =~ /^running/i,
    "Scheduler is running",
);

if ( $CurrentSchedulerStatus !~ /^running/i ) {
    die "Scheduler could not be started.";
}

my $SchedulerObject   = Kernel::Scheduler->new( %{$Self} );
my $TaskManagerObject = Kernel::System::Scheduler::TaskManager->new( %{$Self} );
my $PIDObject         = Kernel::System::PID->new( %{$Self} );

# define global wait times (Secs)
my $TotalWaitToExecute    = 125;
my $TotalWaitToCheck      = 110;
my $TotalWaitToStop       = 140;
my $TotalWaitToReSchedule = 130;

$Self->Is(
    ref $SchedulerObject,
    'Kernel::Scheduler',
    "Kernel::Scheduler->new()",
);

$Self->Is(
    ref $TaskManagerObject,
    'Kernel::System::Scheduler::TaskManager',
    "Kernel::System::Scheduler::TaskManager->new()",
);

$Self->Is(
    scalar $TaskManagerObject->TaskList(),
    0,
    "Initial task list is empty",
);

# round 1: task execution asap
for my $Test (@Tests) {

    # make a deep copy to avoid changing the definition
    $Test = Storable::dclone($Test);

    my $ResultMessage = `$Scheduler -a stop -f 1 2>&1`;
    $Self->Is(
        $?,
        0,
        "Scheduler stop before register asap tasks.",
    );

    # give some visibility if the test fail when it should not
    if ($?) {
        $Self->True(
            0,
            "Scheduler stop DETECTED $ResultMessage"
        );
    }

    # wait for scheduler to stop
    WAITSTOP:
    for my $Wait ( 1 .. $TotalWaitToStop ) {
        print "Waiting for Scheduler to stop, $Wait seconds\n";
        sleep 1;

        my $SchedulerStatus = `$Scheduler -a status`;

        if ( $SchedulerStatus =~ m{\ANot}i ) {
            $Self->True(
                1,
                "$Test->{Name} - Scheduler is stoped",
            );
            last WAITSTOP;
        }

        next WAITSTOP if $Wait < $TotalWaitToExecute;

        $Self->True(
            0,
            "$Test->{Name} - Scheduler didn't stop after $TotalWaitToExecute seconds!",
        );
    }

    # register tasks
    my @FileRemember;
    my $TaskCounter;
    for my $Task ( @{ $Test->{Tasks} } ) {

        if ( $Task->{Type} eq 'Test' ) {
            my $File = $Self->{ConfigObject}->Get('Home') . '/var/tmp/task_' . int rand 1000000;
            if ( -e $File ) {
                unlink $File;
            }
            push @FileRemember, $File;
            $Task->{Data}->{File} = $File;
        }
        my $TaskID = $SchedulerObject->TaskRegister(
            Type => $Task->{Type},
            Data => $Task->{Data},
        );

        $TaskCounter++;

        $Self->IsNot(
            $TaskID,
            undef,
            "$Test->{Name} - asap- Kernel::Scheduler->TaskRegister() Count:$TaskCounter Type:$Task->{Type} TaskID",
        );

        # for debuging, could be removed if needed
        # try to investigate why the task could not be registered
        if ( !$TaskID ) {

            # get last log entry (this might help)
            my $Message = $Self->{LogObject}->GetLogEntry(
                Type => 'error',        # error|info|notice
                What => 'Traceback',    # Message|Traceback
            );

            # output message as error (to be shown in UT servers)
            $Self->True(
                0,
                "Last log entry after TaskRegister(): $Message",
            );
        }
    }

    # check task list
    $Self->Is(
        scalar $TaskManagerObject->TaskList(),
        scalar @{ $Test->{Tasks} },
        "Tasks registered",
    );

    $ResultMessage = `$Scheduler -a start 2>&1`;
    $Self->Is(
        $?,
        0,
        "Scheduler start after register asap tasks.",
    );

    # give some visibility if the test fail when it should not
    if ($?) {
        $Self->True(
            0,
            "Scheduler start DETECTED $ResultMessage"
        );
    }

    # wait for scheduler to execute tasks
    WAITEXECUTE:
    for my $Wait ( 1 .. $TotalWaitToExecute ) {
        print "Waiting for Scheduler to execute tasks, $Wait seconds\n";
        sleep 1;

        my @List = $TaskManagerObject->TaskList();

        if ( scalar @List eq 0 ) {
            $Self->True(
                1,
                "$Test->{Name} - asap - all tasks are dropped from task list",
            );
            last WAITEXECUTE;
        }

        next WAITEXECUTE if $Wait < $TotalWaitToExecute;

        $Self->True(
            0,
            "$Test->{Name} - asap - all tasks are not dropped from task list after $TotalWaitToExecute seconds!",
        );
    }

    # check if files are there
    for my $FileToCheck (@FileRemember) {

        # Wait for slow systems
        $SleepTime = 20;
        print "Waiting at most $TotalWaitToCheck s until task executes\n";
        ACTIVESLEEP:
        for my $Seconds ( 1 .. $TotalWaitToCheck ) {
            if ( -e $FileToCheck ) {
                last ACTIVESLEEP;
            }
            print "Sleeping for $Seconds seconds...\n";
            sleep 1;
        }

        $Self->True(
            -e $FileToCheck,
            "$Test->{Name} - asap - test backend executed correctly (found file $FileToCheck)",
        );
        unlink $FileToCheck;
    }
}

# round 2: task execution in future
for my $Test (@Tests) {

    # make a deep copy to avoid changing the definition
    $Test = Storable::dclone($Test);

    my $DueTime = $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => ( $Self->{TimeObject}->SystemTime() + 9 ),
    );

    # register tasks
    my @FileRemember;
    my $TaskCounter;
    for my $Task ( @{ $Test->{Tasks} } ) {
        if ( $Task->{Type} eq 'Test' ) {
            my $File = $Self->{ConfigObject}->Get('Home') . '/var/tmp/task_' . int rand 1000000;
            if ( -e $File ) {
                unlink $File;
            }
            push @FileRemember, $File;
            $Task->{Data}->{File} = $File;
        }
        my $TaskID = $SchedulerObject->TaskRegister(
            Type    => $Task->{Type},
            Data    => $Task->{Data},
            DueTime => $DueTime,
        );

        $TaskCounter++;
        $Self->IsNot(
            $TaskID,
            undef,
            "$Test->{Name} - future - Kernel::Scheduler->TaskRegister() Count:$TaskCounter Type$Task->{Type} TaskID",
        );
    }

    # check task list
    $Self->Is(
        scalar $TaskManagerObject->TaskList(),
        scalar @{ $Test->{Tasks} },
        "$Test->{Name} - future - Tasks registered",
    );

    # wait for scheduler, it will not execute the tasks yet
    print "Sleeping 3s\n";
    sleep 3;

    # check task list again
    $Self->Is(
        scalar $TaskManagerObject->TaskList(),
        scalar @{ $Test->{Tasks} },
        "$Test->{Name} - future - Tasks registered are still there",
    );

    # check if files are not yet there
    for my $FileToCheck (@FileRemember) {
        $Self->False(
            -e $FileToCheck,
            "$Test->{Name} - future - test backend did not execute yet (not found file $FileToCheck)",
        );
    }

    # wait for scheduler to execute tasks
    WAITEXECUTE:
    for my $Wait ( 1 .. $TotalWaitToExecute ) {
        print "Waiting for Scheduler to execute tasks, $Wait seconds\n";
        sleep 1;

        my @List = $TaskManagerObject->TaskList();

        if ( scalar @List eq 0 ) {
            $Self->True(
                1,
                "$Test->{Name} - future - all tasks are dropped from task list",
            );
            last WAITEXECUTE;
        }

        next WAITEXECUTE if $Wait < $TotalWaitToExecute;

        $Self->True(
            0,
            "$Test->{Name} - future - all tasks are not dropped from task list after $TotalWaitToExecute seconds!",
        );
    }

    # check if files are there
    for my $FileToCheck (@FileRemember) {

        # Wait for slow systems
        print "Waiting at most $TotalWaitToCheck s until task executes\n";
        ACTIVESLEEP:
        for my $Seconds ( 1 .. $TotalWaitToCheck ) {
            if ( -e $FileToCheck ) {
                last ACTIVESLEEP;
            }
            print "Sleeping for $Seconds seconds...\n";
            sleep 1;
        }

        $Self->True(
            -e $FileToCheck,
            "$Test->{Name} - future - test backend executed correctly (found file $FileToCheck)",
        );
        unlink $FileToCheck;
    }
}

# round 3: task rescheduling
for my $Test (@Tests) {

    # make a deep copy to avoid changing the definition
    $Test = Storable::dclone($Test);

    my $DueTime = $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => ( $Self->{TimeObject}->SystemTime() + 9 ),
    );

    # stop scheduler to prevent the early execution of tasks
    my $ResultMessage = `$Scheduler -a stop -f 1 2>&1`;
    $Self->Is(
        $?,
        0,
        "Scheduler stop before register re-schedule tasks.",
    );

    # give some visibility if the test fail when it should not
    if ($?) {
        $Self->True(
            0,
            "Scheduler stop DETECTED $ResultMessage"
        );
    }

    # wait for scheduler to stop
    WAITSTOP:
    for my $Wait ( 1 .. $TotalWaitToStop ) {
        print "Waiting for Scheduler to stop, $Wait seconds\n";
        sleep 1;

        my $SchedulerStatus = `$Scheduler -a status`;

        if ( $SchedulerStatus =~ m{\ANot}i ) {
            $Self->True(
                1,
                "$Test->{Name} - Scheduler is stoped",
            );
            last WAITSTOP;
        }

        next WAITSTOP if $Wait < $TotalWaitToExecute;

        $Self->True(
            0,
            "$Test->{Name} - Scheduler didn't stop after $TotalWaitToExecute seconds!",
        );
    }

    # register tasks
    my ( @RescheduleFileRemember, @FileRemember );

    my $TaskCount = 0;

    TASK:
    for my $Task ( @{ $Test->{Tasks} } ) {

        # only the test backend is able to reschedule tasks, ignore others
        next TASK if $Task->{Type} ne 'Test';

        $TaskCount++;

        $Task->{Data}->{ReSchedule}        = 1;
        $Task->{Data}->{ReScheduleData}    = {};
        $Task->{Data}->{ReScheduleSuccess} = $Task->{Data}->{Success};
        $Task->{Data}->{ReScheduleDueTime} = $DueTime;

        if ( $Task->{Type} eq 'Test' ) {
            my $File = $Self->{ConfigObject}->Get('Home') . '/var/tmp/task_' . int rand 1000000;
            if ( -e $File ) {
                unlink $File;
            }
            push @FileRemember, $File;
            $Task->{Data}->{File} = $File;

            my $RescheduleFile
                = $Self->{ConfigObject}->Get('Home')
                . '/var/tmp/task_reschedule_'
                . int rand 1000000;
            if ( -e $RescheduleFile ) {
                unlink $RescheduleFile;
            }
            push @RescheduleFileRemember, $RescheduleFile;
            $Task->{Data}->{ReScheduleData}->{File} = $RescheduleFile;
        }

        my $TaskID = $SchedulerObject->TaskRegister(
            Type => $Task->{Type},
            Data => $Task->{Data},
        );

        $Self->IsNot(
            $TaskID,
            undef,
            "$Test->{Name} - re-schedule - Kernel::Scheduler->TaskRegister() Count:$TaskCount Type:$Task->{Type} TaskID",
        );
    }

    # check task list
    $Self->Is(
        scalar $TaskManagerObject->TaskList(),
        $TaskCount,
        "$Test->{Name} - re-schedule - Tasks registered",
    );

    # start scheduler again to execute tasks
    $ResultMessage = `$Scheduler -a start 2>&1`;
    $Self->Is(
        $?,
        0,
        "Scheduler start after register re-schedule tasks.",
    );

    # give some visibility if the test fail when it should not
    if ($?) {
        $Self->True(
            0,
            "Scheduler start DETECTED $ResultMessage"
        );
    }

    # wait for scheduler to execute and reschedule the tasks
    WAITRESCHEDULE:
    for my $Wait ( 1 .. $TotalWaitToReSchedule ) {
        print "Waiting for Scheduler to execute and re-schedule tasks, $Wait seconds\n";
        sleep 1;

        my @List = $TaskManagerObject->TaskList();

        if ( scalar @List eq $TaskCount ) {
            $Self->True(
                1,
                "$Test->{Name} - re-schedule - tasks are re-scheduled",
            );
            last WAITRESCHEDULE;
        }

        next WAITRESCHEDULE if $Wait < $TotalWaitToReSchedule;

        $Self->True(
            0,
            "$Test->{Name} - re-schedule - tasks was not re-scheduled $TotalWaitToReSchedule seconds!",
        );
    }

    # check if files are there
    for my $FileToCheck (@FileRemember) {

        # Wait for slow systems
        print "Waiting at most $TotalWaitToCheck s until task executes\n";
        ACTIVESLEEP:
        for my $Seconds ( 1 .. $TotalWaitToCheck ) {
            if ( -e $FileToCheck ) {
                last ACTIVESLEEP;
            }
            print "Sleeping for $Seconds seconds...\n";
            sleep 1;
        }

        $Self->True(
            -e $FileToCheck,
            "$Test->{Name} - re-schedule - original tasks executed successfully (found file $FileToCheck)",
        );
        unlink $FileToCheck;
    }

    # check if re-scheduled files are not yet there
    for my $FileToCheck (@RescheduleFileRemember) {
        $Self->False(
            -e $FileToCheck,
            "$Test->{Name} - re-schedule - re-scheduled tasks did not execute yet (not found file $FileToCheck)",
        );
    }

    # wait for scheduler to execute tasks
    WAITEXECUTE:
    for my $Wait ( 1 .. $TotalWaitToExecute ) {
        print "Waiting for Scheduler to execute tasks, $Wait seconds\n";
        sleep 1;

        my @List = $TaskManagerObject->TaskList();

        if ( scalar @List eq 0 ) {
            $Self->True(
                1,
                "$Test->{Name} - re-schedule - all tasks are dropped from task list",
            );
            last WAITEXECUTE;
        }

        next WAITEXECUTE if $Wait < $TotalWaitToExecute;

        $Self->True(
            0,
            "$Test->{Name} - re-schedule - all tasks are not dropped from task list after $TotalWaitToExecute seconds!",
        );
    }

    # check if files are there
    for my $FileToCheck (@RescheduleFileRemember) {

        # Wait for slow systems
        print "Waiting at most $TotalWaitToCheck s until task executes\n";
        ACTIVESLEEP:
        for my $Seconds ( 1 .. $TotalWaitToCheck ) {
            if ( -e $FileToCheck ) {
                last ACTIVESLEEP;
            }
            print "Sleeping for $Seconds seconds...\n";
            sleep 1;
        }

        $Self->True(
            -e $FileToCheck,
            "$Test->{Name} - re-schedule - re-scheduled tasks executed correctly (found file $FileToCheck)",
        );
        unlink $FileToCheck;
    }
}

# stop scheduler if it was not already running before this test
if ( $PreviousSchedulerStatus =~ /^not running/i ) {
    my $ResultMessage = `$Scheduler -a stop -f 1 2>&1`;
    $Self->Is(
        $?,
        0,
        "Scheduler stop call returned successfully.",
    );

    # give some visibility if the test fail when it should not
    if ($?) {
        $Self->True(
            0,
            "Scheduler start DETECTED $ResultMessage"
        );
    }

    # wait for scheduler to stop
    WAITSTOP:
    for my $Wait ( 1 .. $TotalWaitToStop ) {
        print "Waiting for Scheduler to stop, $Wait seconds\n";
        sleep 1;

        my $SchedulerStatus = `$Scheduler -a status`;

        if ( $SchedulerStatus =~ m{\ANot}i ) {
            $Self->True(
                1,
                "Scheduler is stoped",
            );
            last WAITSTOP;
        }

        next WAITSTOP if $Wait < $TotalWaitToExecute;

        $Self->True(
            0,
            "Scheduler didn't stop after $TotalWaitToExecute seconds!",
        );
    }

    # get the process ID
    my %PID = $PIDObject->PIDGet(
        Name => 'otrs.Scheduler',
    );

    # verify that PID is removed
    $Self->False(
        $PID{PID},
        "Scheduler PID was correctly removed from DB",
    );
}

$CurrentSchedulerStatus = `$Scheduler -a status`;

# check if the scheduler status is the same as before the test
$PreviousSchedulerStatus =~ s{\d}{}g;
$CurrentSchedulerStatus =~ s{\d}{}g;

$Self->Is(
    $CurrentSchedulerStatus,
    $PreviousSchedulerStatus,
    "Scheduler has original state again.",
);

1;
