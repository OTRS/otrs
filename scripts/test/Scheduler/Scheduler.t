# --
# Scheduler.t - Scheduler tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Scheduler.t,v 1.8 2011-03-11 09:11:24 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Storable ();

use Kernel::Scheduler;
use Kernel::System::Scheduler::TaskManager;

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
if ( $^O =~ /^win/i ) {
    $Scheduler = $Home . '/bin/otrs.Scheduler4win.pl';
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
    my $Result = system("$Scheduler -a start");
    $Self->Is(
        $Result,
        0,
        "Scheduler start call returned successfully.",
    );
}
else {
    $Self->True(
        1,
        "Scheduler was already running.",
    );
}

my $CurrentSchedulerStatus = `$Scheduler -a status`;

$Self->True(
    $CurrentSchedulerStatus =~ /^running/i,
    "Scheduler is running",
);

if ( $CurrentSchedulerStatus !~ /^running/i ) {
    die "Scheduler could not be started.";
}

my $SchedulerObject   = Kernel::Scheduler->new( %{$Self} );
my $TaskManagerObject = Kernel::System::Scheduler::TaskManager->new( %{$Self} );

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

    # register tasks
    my @FileRemember;
    for my $Task ( @{ $Test->{Tasks} } ) {

        if ( $Task->{Type} eq 'Test' ) {
            my $File = $Self->{ConfigObject}->Get('Home') . '/var/tmp/task_' . rand(1000000);
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

        $Self->True(
            $TaskID,
            "$Test->{Name} - asap- Kernel::Scheduler->TaskRegister() success",
        );
    }

    # check task list
    $Self->Is(
        scalar $TaskManagerObject->TaskList(),
        scalar @{ $Test->{Tasks} },
        "Tasks registered",
    );

    # wait for scheduler to execute tasks
    sleep 2;

    # check if files are there
    for my $FileToCheck (@FileRemember) {
        $Self->True(
            -e $FileToCheck,
            "$Test->{Name} - asap - test backend executed correctly (found file $FileToCheck)",
        );
        unlink $FileToCheck;
    }

    $Self->Is(
        scalar $TaskManagerObject->TaskList(),
        0,
        "$Test->{Name} - asap - all tasks are dropped from task list",
    );
}

# round 2: task execution in future
for my $Test (@Tests) {

    # make a deep copy to avoid changing the definition
    $Test = Storable::dclone($Test);

    my $DueTime = $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => ( $Self->{TimeObject}->SystemTime() + 4 ),
    );

    # register tasks
    my @FileRemember;
    for my $Task ( @{ $Test->{Tasks} } ) {
        if ( $Task->{Type} eq 'Test' ) {
            my $File = $Self->{ConfigObject}->Get('Home') . '/var/tmp/task_' . rand(1000000);
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

        $Self->True(
            $TaskID,
            "$Test->{Name} - future - Kernel::Scheduler->TaskRegister() success",
        );
    }

    # check task list
    $Self->Is(
        scalar $TaskManagerObject->TaskList(),
        scalar @{ $Test->{Tasks} },
        "$Test->{Name} - future - Tasks registered",
    );

    # wait for scheduler, it will not execute the tasks yet
    sleep 2;

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
            "$Test->{Name} - future - test backend did not execute yet",
        );
    }

    # wait for scheduler to execute tasks
    sleep 4;

    # check if files are there
    for my $FileToCheck (@FileRemember) {
        $Self->True(
            -e $FileToCheck,
            "$Test->{Name} - future - test backend executed correctly (found file $FileToCheck)",
        );
        unlink $FileToCheck;
    }

    $Self->Is(
        scalar $TaskManagerObject->TaskList(),
        0,
        "$Test->{Name} - future - all tasks are dropped from task list",
    );
}

# round 3: task rescheduling
for my $Test (@Tests) {

    # make a deep copy to avoid changing the definition
    $Test = Storable::dclone($Test);

    my $DueTime = $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => ( $Self->{TimeObject}->SystemTime() + 4 ),
    );

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
            my $File = $Self->{ConfigObject}->Get('Home') . '/var/tmp/task_' . rand(1000000);
            if ( -e $File ) {
                unlink $File;
            }
            push @FileRemember, $File;
            $Task->{Data}->{File} = $File;

            my $RescheduleFile
                = $Self->{ConfigObject}->Get('Home') . '/var/tmp/task_' . rand(1000000);
            if ( -e $RescheduleFile ) {
                unlink $RescheduleFile;
            }
            push @RescheduleFileRemember, $File;
            $Task->{Data}->{ReScheduleData}->{File} = $File;
        }

        my $TaskID = $SchedulerObject->TaskRegister(
            Type => $Task->{Type},
            Data => $Task->{Data},
        );

        $Self->True(
            $TaskID,
            "$Test->{Name} - re-schedule - Kernel::Scheduler->TaskRegister() success",
        );
    }

    # check task list
    $Self->Is(
        scalar $TaskManagerObject->TaskList(),
        scalar $TaskCount,
        "$Test->{Name} - re-schedule - Tasks registered",
    );

    # wait for scheduler to execute and reschedule the tasks
    sleep 2;

    # check task list again
    $Self->Is(
        scalar $TaskManagerObject->TaskList(),
        scalar $TaskCount,
        "$Test->{Name} - re-schedule - tasks are re-scheduled",
    );

    # check if files are there
    for my $FileToCheck (@FileRemember) {
        $Self->True(
            -e $FileToCheck,
            "$Test->{Name} - re-schedule - original tasks executed successfully",
        );
        unlink $FileToCheck;
    }

    # check if re-scheduled files are not yet there
    for my $FileToCheck (@RescheduleFileRemember) {
        $Self->False(
            -e $FileToCheck,
            "$Test->{Name} - re-schedule - re-scheduled tasks did not execute yet",
        );
    }

    # wait for scheduler to execute tasks
    sleep 4;

    # check if files are there
    for my $FileToCheck (@RescheduleFileRemember) {
        $Self->True(
            -e $FileToCheck,
            "$Test->{Name} - re-schedule - re-scheduled tasks executed correctly (found file $FileToCheck)",
        );
        unlink $FileToCheck;
    }

    $Self->Is(
        scalar $TaskManagerObject->TaskList(),
        0,
        "$Test->{Name} - re-schedule - all tasks are dropped from task list",
    );
}

# stop scheduler if it was not already running before this test
if ( $PreviousSchedulerStatus =~ /^not running/i ) {
    my $Result = system("$Scheduler -a stop");
    $Self->Is(
        $Result,
        0,
        "Scheduler start call returned successfully.",
    );

}

$CurrentSchedulerStatus = `$Scheduler -a status`;

$Self->Is(
    $CurrentSchedulerStatus,
    $PreviousSchedulerStatus,
    "Scheduler has original state again.",
);

1;
