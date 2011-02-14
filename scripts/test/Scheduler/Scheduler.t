# --
# Scheduler.t - Scheduler tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Scheduler.t,v 1.2 2011-02-14 20:14:59 cr Exp $
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
                Type    => 'Test',
                Success => 1,
                Input   => { Success => 0 },
                Result  => 0,
            },
            {
                Type    => 'TestNotExisting',
                Success => 1,
                Input   => { Success => 1 },
                Result  => 0,
            },
            {
                Type    => 'Test',
                Success => 1,
                Input   => { Success => 0 },
                Result  => 0,
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
                Type    => 'Test',
                Success => 1,
                Input   => { Success => 0 },
                Result  => 0,
            },
        ],
    },
    {
        Name  => 'test 4',
        Tasks => [
            {
                Type    => 'TestNotExisting',
                Success => 1,
                Input   => { Success => 1 },
                Result  => 0,
            },
        ],
    },
);

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
        for my $Task ( @{ $Test->{Tasks} } ) {
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
    }

    # run tasks
    if ( $Test->{Tasks} ) {
        for my $Task ( @{ $Test->{Tasks} } ) {
            my $Success = $SchedulerObject->Run();
            if ( $Task->{Result} ) {
                $Self->False(
                    $Success,
                    "$Test->{Name} - Kernel::Scheduler->Run()",
                );
            }
            else {
                $Self->False(
                    $Success,
                    "$Test->{Name} - Kernel::Scheduler->Run()",
                );
            }
        }
    }

    # check if tasks are dropped from task list
    my @List = $TaskManagerObject->TaskList();
    $Self->False(
        scalar @List,
        "$Test->{Name} - check if tasks are dropped from task list",
    );

    # check result of execution witout tasks
    my $Success = $SchedulerObject->Run();
    $Self->True(
        $Success,
        "$Test->{Name} - Kernel::Scheduler->Run() - check result of execution without tasks",
    );
}

1;
