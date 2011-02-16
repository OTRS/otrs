# --
# Scheduler.t - Scheduler tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Scheduler.t,v 1.4 2011-02-16 19:34:48 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::Scheduler;
use Kernel::System::Scheduler::TaskManager;

my @Tests = (
    {
        Name  => 'test 1',
        Tasks => [
            {
                Type      => 'Test',
                Success   => 1,
                FileCheck => 1,
                Input     => { Success => 0 },
                Result    => 0,
            },
            {
                Type      => 'TestNotExisting',
                Success   => 1,
                FileCheck => 0,
                Input     => { Success => 1 },
                Result    => 0,
            },
            {
                Type      => 'Test',
                Success   => 1,
                FileCheck => 1,
                Input     => { Success => 0 },
                Result    => 0,
            },
        ],
    },
    {
        Name => 'test 2',
    },
    {
        Name  => 'test 3',
        Tasks => [
            {
                Type      => 'Test',
                Success   => 1,
                FileCheck => 1,
                Input     => { Success => 0 },
                Result    => 0,
            },
        ],
    },
    {
        Name  => 'test 4',
        Tasks => [
            {
                Type      => 'TestNotExisting',
                Success   => 1,
                FileCheck => 0,
                Input     => { Success => 1 },
                Result    => 0,
            },
        ],
    },
);

# check if scheduler is running (in case start)
my $Home      = $Self->{ConfigObject}->Get('Home');
my $Scheduler = $Home . '/bin/otrs.Scheduler.pl';
if ( $^O =~ /^win/i ) {
    $Scheduler = $Home . '/bin/otrs.Scheduler4win.pl';
}
my $SchedulerStatus = `$Scheduler -a status`;
if ( $SchedulerStatus =~ /not running/i ) {
    `$Scheduler -a start`;
}

for my $Test (@Tests) {

    my $SchedulerObject   = Kernel::Scheduler->new( %{$Self} );
    my $TaskManagerObject = Kernel::System::Scheduler::TaskManager->new( %{$Self} );

    if ( !$SchedulerObject ) {
        $Self->True(
            0,
            "$Test->{Name} - Kernel::Scheduler->new() - object not created",
        );
        next;
    }
    $Self->True(
        $SchedulerObject,
        "$Test->{Name} - Kernel::Scheduler->new()",
    );

    # register tasks
    if ( $Test->{Tasks} ) {
        my @FileRemember;
        for my $Task ( @{ $Test->{Tasks} } ) {
            if ( $Task->{FileCheck} ) {
                my $File = $Self->{ConfigObject}->Get('Home') . '/var/tmp/task_' . rand(1000000);
                if ( -e $File ) {
                    unlink $File;
                }
                push @FileRemember, $File;
                $Task->{Input}->{File} = $File;
            }
            my $TaskID = $SchedulerObject->TaskRegister(
                Type => $Task->{Type},
                Data => $Task->{Input}
            );
            if ( $Task->{Success} ) {
                $Self->True(
                    $TaskID,
                    "$Test->{Name} - Kernel::Scheduler->TaskRegister()",
                );
            }
            else {
                $Self->False(
                    $TaskID,
                    "$Test->{Name} - Kernel::Scheduler->TaskRegister()",
                );
            }
        }

        # run tasks via Scheduler
        sleep 8 * scalar @{ $Test->{Tasks} };

        # check if files are there
        for my $FileToCheck (@FileRemember) {
            if ( -e $FileToCheck ) {
                unlink $FileToCheck;
                $Self->True(
                    1,
                    "$Test->{Name} - test backend is executed correctly",
                );
            }
            else {
                $Self->True(
                    0,
                    "$Test->{Name} - test backend is executed not correctly",
                );
            }
        }
    }

    # check if tasks are dropped from task list
    my @List = $TaskManagerObject->TaskList();
    $Self->Is(
        scalar @List,
        0,
        "$Test->{Name} - check if tasks are dropped from task list",
    );
}

# in case stop scheduler
if ( $SchedulerStatus =~ /not running/i ) {
    `$Scheduler -a stop`;
}

1;
