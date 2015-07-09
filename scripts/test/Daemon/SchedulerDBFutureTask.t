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

# get scheduler database object
my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

$Self->Is(
    ref $SchedulerDBObject,
    'Kernel::System::Daemon::SchedulerDB',
    "Kernel::System::Daemon::SchedulerDB->new()",
);

# get HelperObject;
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# freeze time
$HelperObject->FixedTimeSet();

# get current time stamp
my $TimeStamp = $Kernel::OM->Get('Kernel::System::Time')->CurrentTimestamp();

# FutureTaskAdd()
my @Tests = (
    {
        Name    => 'Empty Call',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing ExecutionTime',
        Config => {
            Type => 'Test',
            Data => {
                TestData1 => 77777777,
                TestData2 => 88888888,
                TestData3 => 99999999,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong ExecutionTime',
        Config => {
            ExecutionTime => '123',
            Type          => 'Test',
            Data          => {
                TestData1 => 77777777,
                TestData2 => 88888888,
                TestData3 => 99999999,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing Type',
        Config => {
            ExecutionTime => '2020-12-12 12:00:00',
            Data          => {
                TestData1 => 77777777,
                TestData2 => 88888888,
                TestData3 => 99999999,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Min Params',
        Config => {
            ExecutionTime => '2020-12-12 12:00:00',
            Type          => 'Unittest',
            Data          => {
                TestData1 => 77777777,
                TestData2 => 88888888,
                TestData3 => 99999999,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Full Params',
        Config => {
            ExecutionTime => '2020-12-12 12:00:00',
            Type          => 'Unittest',
            Name          => 'any name',
            Attempts      => 5,
            Data          => {
                TestData1 => 77777777,
                TestData2 => 88888888,
                TestData3 => 99999999,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Full Params UTF8',
        Config => {
            ExecutionTime => '2020-12-12 12:00:00',
            Type          => 'Unittest2',
            Name          => 'any name',
            Attempts      => 5,
            Data          => {
                TestData1 => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                TestData2 => 88888888,
                TestData3 => 99999999,
            },
        },
        Success => 1,
    },
);

my @AddedTasksIDs;

TESTCASE:
for my $Test (@Tests) {
    my $TaskID = $SchedulerDBObject->FutureTaskAdd( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->Is(
            $TaskID,
            undef,
            "$Test->{Name} FutureTaskAdd() - should be undef",
        );

        next TESTCASE;
    }

    $Self->IsNot(
        $TaskID,
        undef,
        "$Test->{Name} FutureTaskAdd() - should not be undef",
    );

    push @AddedTasksIDs, $TaskID;
}

# FutureTaskGet() tests.
@Tests = (
    {
        Name    => 'Empty Call',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Wrong TaskID',
        Config => {
            TaskID => -1,
        },
        Success => 0,
    },
    {
        Name   => 'Min Params',
        Config => {
            TaskID => $AddedTasksIDs[0],
        },
        ExpectedResults => {
            TaskID        => $AddedTasksIDs[0],
            ExecutionTime => '2020-12-12 12:00:00',
            Name          => undef,
            Type          => 'Unittest',
            Data          => {
                TestData1 => 77777777,
                TestData2 => 88888888,
                TestData3 => 99999999,
            },
            Attempts                 => 1,
            MaximumParallelInstances => 0,
            LockKey                  => 0,
            LockTime                 => '',
            CreateTime               => $TimeStamp,
        },
        Success => 1,
    },
    {
        Name   => 'Full Params',
        Config => {
            TaskID => $AddedTasksIDs[1],
        },
        ExpectedResults => {
            TaskID        => $AddedTasksIDs[1],
            ExecutionTime => '2020-12-12 12:00:00',
            Name          => 'any name',
            Type          => 'Unittest',
            Data          => {
                TestData1 => 77777777,
                TestData2 => 88888888,
                TestData3 => 99999999,
            },
            Attempts                 => 5,
            MaximumParallelInstances => 0,
            LockKey                  => 0,
            LockTime                 => '',
            CreateTime               => $TimeStamp,
        },
        Success => 1,
    },
    {
        Name   => 'Full Params UTF8',
        Config => {
            TaskID => $AddedTasksIDs[2],
        },
        ExpectedResults => {
            TaskID                   => $AddedTasksIDs[2],
            ExecutionTime            => '2020-12-12 12:00:00',
            Name                     => 'any name',
            Type                     => 'Unittest2',
            Attempts                 => 5,
            MaximumParallelInstances => 0,
            Data                     => {
                TestData1 => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                TestData2 => 88888888,
                TestData3 => 99999999,
            },
            LockKey    => 0,
            LockTime   => '',
            CreateTime => $TimeStamp,
        },
        Success => 1,
    },
);

TESTCASE:
for my $Test (@Tests) {
    my %Task = $SchedulerDBObject->FutureTaskGet( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->False(
            $Task{TaskID},
            "$Test->{Name} FutureTaskGet() - with false",
        );
        next TESTCASE;
    }

    $Self->IsDeeply(
        \%Task,
        $Test->{ExpectedResults},
        "$Test->{Name} FutureTaskGet() - result",
    );
}

# FutureTaskDelete() tests.
@Tests = (
    {
        Name    => 'Empty Call',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Wrong TaskID',
        Config => {
            TaskID => -1,
        },
        Success => 1,
    },
);

TESTCASE:
for my $Test (@Tests) {

    my $Success = $SchedulerDBObject->FutureTaskDelete( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->False(
            $Success,
            "$Test->{Name} FutureTaskDelete() - with false",
        );
        next TESTCASE;
    }
    $Self->True(
        $Success,
        "$Test->{Name} FutureTaskDelete() - with true",
    );
}

#FutureTaskList() tests
my @List = $SchedulerDBObject->FutureTaskList();
my %ListLookup = map { $_->{TaskID} => $_ } @List;
for my $TaskID (@AddedTasksIDs) {
    $Self->True(
        $ListLookup{$TaskID},
        "FutureTaskList() - (all) $TaskID is present with true",
    );
}

@List = $SchedulerDBObject->FutureTaskList(
    Type => 'Unittest',
);
%ListLookup = map { $_->{TaskID} => $_ } @List;
TASK:
for my $TaskID (@AddedTasksIDs) {
    if ( $TaskID == $AddedTasksIDs[2] ) {
        $Self->False(
            $ListLookup{$TaskID},
            "FutureTaskList() - (Unittest) $TaskID is present with false",
        );
        next TASK;
    }
    $Self->True(
        $ListLookup{$TaskID},
        "FutureTaskList() - (Unittest) $TaskID is present with true",
    );
}

@List = $SchedulerDBObject->FutureTaskList(
    Type => 'Unittest2',
);
%ListLookup = map { $_->{TaskID} => $_ } @List;
TASK:
for my $TaskID (@AddedTasksIDs) {
    if ( $TaskID != $AddedTasksIDs[2] ) {
        $Self->False(
            $ListLookup{$TaskID},
            "FutureTaskList() - (Unittest2) $TaskID is present with false",
        );
        next TASK;
    }
    $Self->True(
        $ListLookup{$TaskID},
        "FutureTaskList() - (Unittest2) $TaskID is present with true",
    );
}

my $RandomID = $HelperObject->GetRandomID();

# FutureTaskToExecute() tests
my $TaskID = $SchedulerDBObject->FutureTaskAdd(
    ExecutionTime => $TimeStamp,
    Type          => "Unittest-$RandomID",
    Name          => 'any name',
    Attempts      => 5,
    Data          => {
        TestData1 => 77777777,
        TestData2 => 88888888,
        TestData3 => 99999999,
    },
);
$Self->IsNot(
    $TaskID,
    undef,
    "FutureTaskAdd() for FutureTaskToExecute() - should not be undef",
);

@Tests = (
    {
        Name    => 'Empty Call',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing NodeID',
        Config => {
            PID => 123,
        },
        Success => 0,
    },
    {
        Name   => 'Missing PID',
        Config => {
            NodeID => 123,
        },
        Success => 0,
    },
    {
        Name   => 'Correct Call',
        Config => {
            NodeID => 123,
            PID    => 123,
        },
        Success => 1,
    },
);

TESTCASE:
for my $Test (@Tests) {
    my $Success = $SchedulerDBObject->FutureTaskToExecute( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->False(
            $Success,
            "$Test->{Name} FutureTaskToExecute() - with false",
        );
        my @List = $SchedulerDBObject->FutureTaskList();
        my %ListLookup = map { $_->{TaskID} => $_ } @List;
        $Self->True(
            $ListLookup{$TaskID},
            "FutureTaskList() for FutureTaskToExecute() - $TaskID is present with true",
        );
        @List = $SchedulerDBObject->TaskList(
            Type => "Unittest-$RandomID",
        );
        $Self->Is(
            scalar @List,
            0,
            "TaskList() for FutureTaskToExecute() - No elements for the task type Unittest-$RandomID",
        );
        next TESTCASE;
    }

    $Self->True(
        $Success,
        "$Test->{Name} FutureTaskToExecute() - with true",
    );
    my @List = $SchedulerDBObject->FutureTaskList();
    my %ListLookup = map { $_->{TaskID} => $_ } @List;
    $Self->False(
        $ListLookup{$TaskID},
        "FutureTaskList() for FutureTaskToExecute() - $TaskID is present with false",
    );
    @List = $SchedulerDBObject->TaskList(
        Type => "Unittest-$RandomID",
    );
    $Self->Is(
        scalar @List,
        1,
        "TaskList() for FutureTaskToExecute() - One element for the task type Unittest-$RandomID",
    );

    for my $Task (@List) {
        my $TaskID = $Task->{TaskID};

        my $Success = $SchedulerDBObject->TaskDelete(
            TaskID => $TaskID,
        );
        $Self->True(
            $Success,
            "TaskDelete() for FutureTaskToExecute() - for task $TaskID with true",
        );
    }
}

# MaximumParallelInstances tests
my $TaskCleanup = sub {
    my %Param = @_;

    my $Message = $Param{Message} || '';

    # cleanup (RecurrentTaksDelete() positive results)
    my @List = $SchedulerDBObject->FutureTaskList(
        Type => 'UnitTest',
    );

    TASK:
    for my $Task (@List) {
        next TASK if $Task->{Type} ne 'UnitTest';

        my $TaskID = $Task->{TaskID};

        my $Success = $SchedulerDBObject->FutureTaskDelete(
            TaskID => $TaskID,
        );
        $Self->True(
            $Success,
            "$Message FuitureTaskDelete() - for $TaskID with true",
        );
    }

    # remove also worker tasks
    @List = $SchedulerDBObject->TaskList(
        Type => 'UnitTest',
    );

    TASK:
    for my $Task (@List) {
        next TASK if $Task->{Type} ne 'UnitTest';

        my $TaskID = $Task->{TaskID};

        my $Success = $SchedulerDBObject->TaskDelete(
            TaskID => $TaskID,
        );
        $Self->True(
            $Success,
            "$Message TaskDelete() - for $TaskID with true",
        );
    }
};

$TaskCleanup->(
    Message => 'Cleanup',
);

# MaximumParallelTask feature test
my %TaskTemplate = (
    Name          => 'UniqueTaskName',
    Type          => 'UnitTest',
    Attempts      => 1,
    ExecutionTime => '2014-01-01 00:00:00',
    Data          => {},
);
@Tests = (
    {
        Name                     => "1 task",
        MaximumParallelInstances => 1,
    },
    {
        Name                     => "5 tasks",
        MaximumParallelInstances => 5,
    },
    {
        Name                     => "9 tasks",
        MaximumParallelInstances => 9,
    },
    {
        Name                     => "10 tasks",
        MaximumParallelInstances => 10,
    },
    {
        Name                     => "Unlimited tasks",
        MaximumParallelInstances => 10,
    },
);

for my $Test (@Tests) {

    for my $Counter ( 0 .. 10 ) {

        my $Success = $SchedulerDBObject->FutureTaskAdd(
            %TaskTemplate,
            MaximumParallelInstances => $Test->{MaximumParallelInstances},
        );
        $Self->True(
            $Success,
            "$Test->{Name} TaskAdd() - result with true",
        );

        $HelperObject->FixedTimeAddSeconds(60);
    }

    my $Success = $SchedulerDBObject->FutureTaskToExecute(
        NodeID => 1,
        PID    => 456,
    );
    $Self->True(
        $Success,
        "$Test->{Name} FutureTaskToExecute() - result with true",
    );

    my @List = $SchedulerDBObject->TaskList(
        Type => 'UnitTest',
    );

    my @FilteredList = grep { $_->{Name} eq $TaskTemplate{Name} } @List;

    my $ExpectedTaskNumber = $Test->{MaximumParallelInstances} || 10;

    if ( $ExpectedTaskNumber > 10 ) {
        $ExpectedTaskNumber = 10;
    }

    $Self->Is(
        scalar @FilteredList,
        $ExpectedTaskNumber,
        "$Test->{Name} TaskList() - Number of worker tasks",
    );

    $TaskCleanup->(
        Message => "$Test->{Name}"
    );
}

# cleanup (FutureTaksDelete() positive results)
for my $TaskID (@AddedTasksIDs) {
    my $Success = $SchedulerDBObject->FutureTaskDelete(
        TaskID => $TaskID,
    );
    $Self->True(
        $Success,
        "FutureTaskDelete() - for $TaskID with true",
    );
}

# start daemon if it was already running before this test
if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    system("$Daemon start");
}

1;
