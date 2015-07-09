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

# get a list of all existing tasks
my @List = $SchedulerDBObject->TaskList();

# cleanup tasklist to start testing
TASK:
for my $Task (@List) {

    next TASK if !$Task;
    next TASK if ref $Task ne 'HASH';
    next TASK if !$Task->{TaskID};

    my $Success = $SchedulerDBObject->TaskDelete(
        TaskID => $Task->{TaskID},
    );
}

# add first task
my $TaskID1 = $SchedulerDBObject->TaskAdd(
    Type     => 'Unittest',
    Name     => 'TestTask1',
    Attempts => 2,
    Data     => {
        TestData => 12345,
    },
);

$Self->True(
    $TaskID1,
    "TaskAdd() - Added first test task",
);

# get all existing tasks
my @List1 = $SchedulerDBObject->TaskList();

$Self->IsDeeply(
    \@List1,
    [
        {
            TaskID => $TaskID1,
            Name   => 'TestTask1',
            Type   => 'Unittest',
        }
    ],
    'TaskList() - List 1 content',
);

# get unlocked task list
my @List1Unlocked = $SchedulerDBObject->TaskListUnlocked();

$Self->IsDeeply(
    \@List1Unlocked,
    [$TaskID1],
    'TaskList() - List 1 unlocked content',
);

# get task 1
my %Task1 = $SchedulerDBObject->TaskGet(
    TaskID => $TaskID1,
);

delete $Task1{CreateTime};

$Self->IsDeeply(
    \%Task1,
    {
        TaskID         => $TaskID1,
        Type           => 'Unittest',
        Name           => 'TestTask1',
        Attempts       => 2,
        LockKey        => 0,
        LockTime       => '',
        LockUpdateTime => '',
        Data           => {
            TestData => 12345,
        },
    },
    'TaskGet() - Task 1 content',
);

# lock task 1
my $Success1 = $SchedulerDBObject->TaskLock(
    TaskID => $TaskID1,
    NodeID => 1,
    PID    => $$,
);

$Self->True(
    $Success1,
    "TaskLock() - Lock task 1",
);

# get task 1 again
%Task1 = $SchedulerDBObject->TaskGet(
    TaskID => $TaskID1,
);

$Self->True(
    $Task1{LockKey},
    "TaskGet() - LockKey is set",
);
$Self->True(
    $Task1{LockTime},
    "TaskGet() - LockTime is set",
);
$Self->True(
    $Task1{Attempts} eq 1,
    "TaskGet() - Attempts is decremented",
);

# get all existing tasks
my @List2 = $SchedulerDBObject->TaskList();

$Self->IsDeeply(
    \@List2,
    [
        {
            TaskID => $TaskID1,
            Name   => 'TestTask1',
            Type   => 'Unittest',
        },
    ],
    'TaskList() - List 2 content',
);

# get unlocked task list
my @List2Unlocked = $SchedulerDBObject->TaskListUnlocked();

$Self->IsDeeply(
    \@List2Unlocked,
    [],
    'TaskList() - List 2 unlocked content',
);

# try to lock task 1 with same PID
my $Success2 = $SchedulerDBObject->TaskLock(
    TaskID => $TaskID1,
    NodeID => 1,
    PID    => $$,
);

$Self->True(
    $Success2,
    "TaskLock() - Lock task 1 needs to be successfull",
);

# try to lock task 1 with different PID
my $Success3 = $SchedulerDBObject->TaskLock(
    TaskID => $TaskID1,
    NodeID => 1,
    PID    => ( $$ - 1 ),
);

$Self->False(
    $Success3,
    "TaskLock() - Lock task 1 needs to be unsuccessfull",
);

# try to lock task 1 with different NodeID
my $Success4 = $SchedulerDBObject->TaskLock(
    TaskID => $TaskID1,
    NodeID => 2,
    PID    => $$,
);

$Self->False(
    $Success4,
    "TaskLock() - Lock task 1 needs to be unsuccessfull",
);

# add second task
my $TaskID2 = $SchedulerDBObject->TaskAdd(
    Type => 'Unittest',
    Name => 'TestTask2',
    Data => {
        TestData1 => 77777777,
        TestData2 => 88888888,
        TestData3 => 99999999,
    },
);

$Self->True(
    $TaskID2,
    "TaskAdd() - Added second test task",
);

# get all existing tasks
my @List3 = $SchedulerDBObject->TaskList();

$Self->IsDeeply(
    \@List3,
    [
        {
            TaskID => $TaskID1,
            Name   => 'TestTask1',
            Type   => 'Unittest',
        },
        {
            TaskID => $TaskID2,
            Name   => 'TestTask2',
            Type   => 'Unittest',
        },
    ],
    'TaskList() - List 3 content',
);

# get unlocked task list
my @List3Unlocked = $SchedulerDBObject->TaskListUnlocked();

$Self->IsDeeply(
    \@List3Unlocked,
    [$TaskID2],
    'TaskList() - List 3 unlocked content',
);

# get task 2
my %Task2 = $SchedulerDBObject->TaskGet(
    TaskID => $TaskID2,
);

delete $Task2{CreateTime};

$Self->IsDeeply(
    \%Task2,
    {
        TaskID         => $TaskID2,
        Type           => 'Unittest',
        Name           => 'TestTask2',
        Attempts       => 1,
        LockKey        => 0,
        LockTime       => '',
        LockUpdateTime => '',
        Data           => {
            TestData1 => 77777777,
            TestData2 => 88888888,
            TestData3 => 99999999,
        },
    },
    'TaskGet() - Task 2 content',
);

# lock task 2
my $Success5 = $SchedulerDBObject->TaskLock(
    TaskID => $TaskID2,
    NodeID => 1,
    PID    => $$,
);

$Self->True(
    $Success5,
    "TaskLock() - Lock task 2",
);

# get task 2 again
%Task2 = $SchedulerDBObject->TaskGet(
    TaskID => $TaskID2,
);

$Self->True(
    $Task2{LockKey},
    "TaskGet() - LockKey is set",
);
$Self->True(
    $Task2{LockTime},
    "TaskGet() - LockTime is set",
);
$Self->False(
    $Task2{Attempts},
    "TaskGet() - Attempts needs to be 0",
);

# get all existing tasks
my @List4 = $SchedulerDBObject->TaskList();

$Self->IsDeeply(
    \@List4,
    [
        {
            TaskID => $TaskID1,
            Name   => 'TestTask1',
            Type   => 'Unittest',
        },
        {
            TaskID => $TaskID2,
            Name   => 'TestTask2',
            Type   => 'Unittest',
        },
    ],
    'TaskList() - List 4 content',
);

# get unlocked task list
my @List4Unlocked = $SchedulerDBObject->TaskListUnlocked();

$Self->IsDeeply(
    \@List4Unlocked,
    [],
    'TaskList() - List 4 unlocked content',
);

# try to lock task 2 with same PID
my $Success6 = $SchedulerDBObject->TaskLock(
    TaskID => $TaskID2,
    NodeID => 1,
    PID    => $$,
);

$Self->True(
    $Success6,
    "TaskLock() - Lock task 2 needs to be successfull",
);

# try to lock task 2 with different PID
my $Success7 = $SchedulerDBObject->TaskLock(
    TaskID => $TaskID2,
    NodeID => 1,
    PID    => ( $$ - 1 ),
);

$Self->False(
    $Success7,
    "TaskLock() - Lock task 2 needs to be unsuccessfull",
);

# try to lock task 2 with different NodeID
my $Success8 = $SchedulerDBObject->TaskLock(
    TaskID => $TaskID2,
    NodeID => 2,
    PID    => $$,
);

$Self->False(
    $Success8,
    "TaskLock() - Lock task 2 needs to be unsuccessfull",
);

# get all existing tasks
my @List5 = $SchedulerDBObject->TaskList();

$Self->IsDeeply(
    \@List5,
    [
        {
            TaskID => $TaskID1,
            Name   => 'TestTask1',
            Type   => 'Unittest',
        },
        {
            TaskID => $TaskID2,
            Name   => 'TestTask2',
            Type   => 'Unittest',
        },
    ],
    'TaskList() - List 5 content',
);

# get all existing unittest tasks
my @List5b = $SchedulerDBObject->TaskList(
    Type => 'Unittest',
);

$Self->IsDeeply(
    \@List5b,
    [
        {
            TaskID => $TaskID1,
            Name   => 'TestTask1',
            Type   => 'Unittest',
        },
        {
            TaskID => $TaskID2,
            Name   => 'TestTask2',
            Type   => 'Unittest',
        },
    ],
    'TaskList() - List 5b content',
);

# get unlocked task list
my @List5Unlocked = $SchedulerDBObject->TaskListUnlocked();

$Self->IsDeeply(
    \@List5Unlocked,
    [],
    'TaskList() - List 5 unlocked content',
);

# remove first task from database
my $Success9 = $SchedulerDBObject->TaskDelete(
    TaskID => $TaskID1,
);

$Self->True(
    $Success9,
    "TaskDelete() - Delete task 1",
);

# get all existing tasks
my @List6 = $SchedulerDBObject->TaskList();

$Self->IsDeeply(
    \@List6,
    [
        {
            TaskID => $TaskID2,
            Name   => 'TestTask2',
            Type   => 'Unittest',
        },
    ],
    'TaskList() - List 6 content',
);

# get unlocked task list
my @List6Unlocked = $SchedulerDBObject->TaskListUnlocked();

$Self->IsDeeply(
    \@List6Unlocked,
    [],
    'TaskList() - List 6 unlocked content',
);

# remove second task from database
my $Success10 = $SchedulerDBObject->TaskDelete(
    TaskID => $TaskID2,
);

$Self->True(
    $Success10,
    "TaskDelete() - Delete task 2",
);

# get all existing tasks
my @List7 = $SchedulerDBObject->TaskList();

$Self->IsDeeply(
    \@List7,
    [],
    'TaskList() - List 7 content',
);

# get unlocked task list
my @List7Unlocked = $SchedulerDBObject->TaskListUnlocked();

$Self->IsDeeply(
    \@List7Unlocked,
    [],
    'TaskList() - List 7 unlocked content',
);

# get a list of all existing tasks
@List = $SchedulerDBObject->TaskList();

# cleanup tasklist
TASK:
for my $Task (@List) {

    next TASK if !$Task;
    next TASK if ref $Task ne 'HASH';
    next TASK if !$Task->{TaskID};

    my $Success = $SchedulerDBObject->TaskDelete(
        TaskID => $Task->{TaskID},
    );
}

# TaskCleanup() tests
# get helper object
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# freeze the current time
$HelperObject->FixedTimeSet();

my %TaskTemplate = (
    Type     => 'UnitTest',
    Name     => 'UnitTest',
    Attempts => 5,
    Data     => {},
);

my @Tests = (
    {
        Name           => "Task in current time",
        PastSecondsAdd => 0,
        TaskAdd        => 1,
        TaskPersist    => 1,
    },
    {
        Name           => "Task 3 days ago",
        PastSecondsAdd => 60 * 60 * 24 * 3,
        TaskAdd        => 1,
        TaskPersist    => 1,
    },
    {
        Name           => "Task 6 days 59 min 59 secs ago",
        PastSecondsAdd => ( 60 * 60 * 24 * 7 ) - 1,
        TaskAdd        => 1,
        TaskPersist    => 1,
    },
    {
        Name           => "Task 7 days ago",
        PastSecondsAdd => 60 * 60 * 24 * 7,
        TaskAdd        => 1,
        TaskPersist    => 0,
    },
    {
        Name           => "Task 30 days ago",
        PastSecondsAdd => 60 * 60 * 24 * 30,
        TaskAdd        => 1,
        TaskPersist    => 0,
    },
    {
        Name           => "Task 6 months ago",
        PastSecondsAdd => 60 * 60 * 24 * 30 * 6,
        TaskAdd        => 1,
        TaskPersist    => 0,
    },
    {
        Name           => "Task 1 year ago",
        PastSecondsAdd => 60 * 60 * 24 * 30 * 12,
        TaskAdd        => 1,
        TaskPersist    => 0,
    },
);

for my $Test (@Tests) {

    if ( $Test->{PastSecondsAdd} ) {
        $HelperObject->FixedTimeAddSeconds( -$Test->{PastSecondsAdd} );
        print "  Set $Test->{PastSecondsAdd} seconds into the past.\n";
    }

    my @AddedTasks;
    if ( $Test->{TaskAdd} ) {

        my $TaskID = $SchedulerDBObject->TaskAdd(%TaskTemplate);
        $Self->IsNot(
            $TaskID,
            undef,
            "$Test->{Name} Worker TaskAdd() - result should not be undef",
        );

        push @AddedTasks, $TaskID;

        my $Success = $SchedulerDBObject->TaskLock(
            TaskID => $TaskID,
            NodeID => 1,
            PID    => 456,
        );
        $Self->True(
            $Success,
            "$Test->{Name} Worker TaskLock() - for TaskID $TaskID with true",
        );
    }

    if ( $Test->{PastSecondsAdd} ) {
        $HelperObject->FixedTimeAddSeconds( $Test->{PastSecondsAdd} );
        print "  Restored time.\n";
    }

    my $Success = $SchedulerDBObject->TaskCleanup();
    $Self->Is(
        $Success,
        1,
        "$Test->{Name} TaskCleanup - result",
    );

    for my $TaskID (@AddedTasks) {
        my %Task = $SchedulerDBObject->TaskGet(
            TaskID => $TaskID,
        );
        if ( $Test->{TaskPersist} ) {
            $Self->IsNotDeeply(
                \%Task,
                {},
                "$Test->{Name} Worker TaskGet()",
            );
        }
        else {
            $Self->IsDeeply(
                \%Task,
                {},
                "$Test->{Name} Worker TaskGet()",
            );
        }
    }
}

@List = $SchedulerDBObject->TaskList(
    Type => 'UnitTest',
);

@Tests = (
    {
        Name          => 'Initial update task 1, 2 and 3',
        TaskIDs       => [ $List[0]->{TaskID}, $List[1]->{TaskID}, $List[2]->{TaskID}, ],
        LockedTaskIDs => [ $List[0]->{TaskID}, $List[1]->{TaskID}, $List[2]->{TaskID}, ],
    },
    {
        Name          => 'After 4 minutes update task 1 and 2',
        AddSeconds    => 60 * 4,
        TaskIDs       => [ $List[0]->{TaskID}, $List[1]->{TaskID}, ],
        LockedTaskIDs => [ $List[0]->{TaskID}, $List[1]->{TaskID}, $List[2]->{TaskID}, ],
    },
    {
        Name          => 'After 4:59 minutes update task 1 and 2',
        AddSeconds    => 59,
        TaskIDs       => [ $List[0]->{TaskID}, $List[1]->{TaskID}, ],
        LockedTaskIDs => [ $List[0]->{TaskID}, $List[1]->{TaskID}, $List[2]->{TaskID}, ],
    },
    {
        Name          => 'After 5 minutes update task 1 and 2',
        AddSeconds    => 1,
        TaskIDs       => [ $List[0]->{TaskID}, $List[1]->{TaskID}, ],
        LockedTaskIDs => [ $List[0]->{TaskID}, $List[1]->{TaskID} ],
    },
);

# get time object
my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

my $OriginalTimeStamp = $TimeObject->CurrentTimestamp();

for my $Test (@Tests) {
    if ( $Test->{AddSeconds} ) {
        $HelperObject->FixedTimeAddSeconds( $Test->{AddSeconds} );
    }

    my $CurrentTimeStamp = $TimeObject->CurrentTimestamp();

    my $Success = $SchedulerDBObject->TaskLockUpdate(
        TaskIDs => $Test->{TaskIDs},
    );
    $Self->True(
        $Success,
        "$Test->{Name} - TaskLockUpdate() with true",
    );

    my %TaskLookup = map { $_ => 1 } @{ $Test->{TaskIDs} || {} };

    for my $TaskItem (@List) {
        my $TaskID = $TaskItem->{TaskID};

        my %Task = $SchedulerDBObject->TaskGet(
            TaskID => $TaskID,
        );

        if ( $TaskLookup{$TaskID} ) {
            $Self->Is(
                $Task{LockUpdateTime},
                $CurrentTimeStamp,
                "$Test->{Name} - TaskLockUpdate() LockUpdateTime (updated) TaskID: $TaskID",
            );
        }
        else {
            $Self->Is(
                $Task{LockUpdateTime},
                $OriginalTimeStamp,
                "$Test->{Name} - TaskLockUpdate() LockUpdateTime (not updated) TaskID: $TaskID",
            );
        }
    }

    $Success = $SchedulerDBObject->TaskUnlockExpired();
    $Self->True(
        $Success,
        "$Test->{Name} - TaskUnlockExpired() with true",
    );

    %TaskLookup = map { $_ => 1 } @{ $Test->{LockedTaskIDs} || {} };

    for my $TaskItem (@List) {
        my $TaskID = $TaskItem->{TaskID};

        my %Task = $SchedulerDBObject->TaskGet(
            TaskID => $TaskID,
        );

        if ( $TaskLookup{$TaskID} ) {
            $Self->IsNot(
                $Task{LockKey},
                0,
                "$Test->{Name} - TaskUnlockExpired() LockKey (updated) TaskID: $TaskID",
            );
            $Self->IsNot(
                $Task{LockUpdateTime},
                '',
                "$Test->{Name} - TaskUnlockExpired() LockUpdateTime (updated) TaskID: $TaskID",
            );

        }
        else {
            $Self->Is(
                $Task{LockKey},
                0,
                "$Test->{Name} - TaskUnlockExpired() LockKey (not updated) TaskID: $TaskID",
            );
            $Self->Is(
                $Task{LockUpdateTime},
                '',
                "$Test->{Name} - TaskUnlockExpired() LockUpdateTime (not updated) TaskID: $TaskID",
            );
        }
    }
}

my $TaskCleanup = sub {
    my %Param = @_;

    my $Message = $Param{Message} || '';

    my @List = $SchedulerDBObject->TaskList(
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
%TaskTemplate = (
    NodeID => 1,
    PID    => 456,
    Name   => 'UniqueTaskName',
    Type   => 'UnitTest',
    Data   => {},
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

        my $TaskID = $SchedulerDBObject->TaskAdd(
            %TaskTemplate,
            MaximumParallelInstances => $Test->{MaximumParallelInstances},
        );
        $Self->IsNot(
            $TaskID,
            undef,
            "$Test->{Name} TaskAdd() - result should not be undef",
        );

        $HelperObject->FixedTimeAddSeconds(60);
    }

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

my $TaskID = $SchedulerDBObject->TaskAdd(
    %TaskTemplate,
);
$Self->IsNot(
    $TaskID,
    undef,
    "TaskAdd() - result should not be undef",
);

$TaskID = $SchedulerDBObject->TaskAdd(
    %TaskTemplate,
    Name                     => undef,
    MaximumParallelInstances => 1,
);
$Self->Is(
    $TaskID,
    -1,
    "TaskAdd() - MaximumParallelInstances without name should be -1",
);

# cleanup
@List = $SchedulerDBObject->TaskList(
    Type => 'UnitTest',
);
for my $Task (@List) {

    my $TaskID = $Task->{TaskID};

    my $Success = $SchedulerDBObject->TaskDelete(
        TaskID => $TaskID,
    );

    $Self->True(
        $Success,
        "Worker TaskDelete() - for TaskID $TaskID with true",
    );
}

# start daemon if it was already running before this test
if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    system("$Daemon start");
}

1;
