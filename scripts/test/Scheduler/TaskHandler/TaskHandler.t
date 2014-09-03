# --
# TaskHandler.t - TaskHandler tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::Scheduler::TaskHandler;

my @Tests = (
    {
        Name               => 'Nonexisting backend',
        TaskHandlerType    => 'TestNotExisting',
        ConstructorSuccess => 0,
        TaskData           => {
            Success => 1
        },
        Result => 0,
    },
    {
        Name               => 'Empty backend',
        TaskHandlerType    => '',
        ConstructorSuccess => 0,
        TaskData           => {
            Success => 1
        },
        Result => 0,
    },
    {
        Name               => 'Normal, success',
        TaskHandlerType    => 'Test',
        ConstructorSuccess => 1,
        TaskData           => {
            Success => 1
        },
        Result => 1,
    },
    {
        Name               => 'Normal, fail',
        TaskHandlerType    => 'Test',
        ConstructorSuccess => 1,
        TaskData           => {
            Success => 0
        },
        Result => 0,
    },
    {
        Name               => 'Normal, re-schedule success',
        TaskHandlerType    => 'Test',
        ConstructorSuccess => 1,
        TaskData           => {
            Success           => 1,
            ReSchedule        => 1,
            ReScheduleDueTime => '2010-01-01 01:01:01',
            ReScheduleData    => {
                Success => 1,
            },
        },
        Result => 1,
    },
    {
        Name               => 'Normal, re-schedule failure',
        TaskHandlerType    => 'Test',
        ConstructorSuccess => 1,
        TaskData           => {
            Success           => 0,
            ReSchedule        => 1,
            ReScheduleDueTime => '2010-01-02 02:02:02',
            ReScheduleData    => {
                Success => 0,
            },
        },
        Result => 0,
    },
);

TEST:
for my $Test (@Tests) {

    my $Object = Kernel::System::Scheduler::TaskHandler->new(
        TaskHandlerType => $Test->{TaskHandlerType},
    );

    $Self->Is(
        $Object ? 1 : 0,
        $Test->{ConstructorSuccess},
        "$Test->{Name} - new() result",
    );

    next TEST if !$Object;

    my $Result = $Object->Run( Data => $Test->{TaskData} );
    $Self->Is(
        $Result->{Success},
        $Test->{Result},
        "$Test->{Name} - Run() success",
    );

    $Self->Is(
        $Result->{ReSchedule},
        $Test->{TaskData}->{ReSchedule},
        "$Test->{Name} - Run() re-scheduled",
    );

    $Self->IsDeeply(
        $Result->{Data},
        $Test->{TaskData}->{ReScheduleData},
        "$Test->{Name} - Run() re-schedule data",
    );

    $Self->Is(
        $Result->{DueTime},
        $Test->{TaskData}->{ReScheduleDueTime},
        "$Test->{Name} - Run() re-schedule DueTime",
    );
}

1;
