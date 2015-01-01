# --
# TaskManager.t - TaskManager tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::System::Scheduler::TaskManager;

my $TaskManagerObject = Kernel::System::Scheduler::TaskManager->new( %{$Self} );

my $Home = $Self->{ConfigObject}->Get('Home');

my $Scheduler = $Home . '/bin/otrs.Scheduler.pl';
if ( $^O =~ /^mswin/i ) {
    $Scheduler = "\"$^X\" " . $Home . '/bin/otrs.Scheduler4win.pl';
    $Scheduler =~ s{/}{\\}g
}

# get scheduler status
my $PreviousSchedulerStatus = `$Scheduler -a status`;

# stop scheduler if it was already running before this test
if ( $PreviousSchedulerStatus =~ /^running/i ) {
    `$Scheduler -a stop`;

    # wait to get scheduler fully stoped before test continues
    my $SleepTime = 1;
    if ( $^O =~ /^mswin/i ) {
        $SleepTime = 5;
    }

    print "A running Scheduler was detected and need to be stopped...\n";
    print 'Sleeping ' . $SleepTime . "s\n";
    sleep $SleepTime;
}

$Self->Is(
    ref $TaskManagerObject,
    'Kernel::System::Scheduler::TaskManager',
    "Kernel::System::Scheduler::TaskManager->new()",
);

# get task list
my @TaskList = $TaskManagerObject->TaskList();

# check if there is a remaining task from prior tests (look for type Test)
TASK:
for my $Task (@TaskList) {
    next TASK if $Task->{Type} ne 'Test';

    # delete all remaning Tests tasks
    # this is needed because if prior tests left tasks un proceces this test will also fail
    my $TaskDelete = $TaskManagerObject->TaskDelete( ID => $Task->{ID} );

    $Self->True(
        $TaskDelete,
        "Warning: Task deleted from a prior failed test Task ID $Task->{ID}"
    );
}

$Self->Is(
    scalar $TaskManagerObject->TaskList(),
    0,
    "Initial task list is empty",
);

my $CurrentTime = $Self->{TimeObject}->CurrentTimestamp();

my @Tests = (
    {
        Name    => 'test 1',
        Success => 1,
        Data    => {
            Name        => 'Nagios',
            Description => 'Connector to send and receive date from Nagios.',
            Provider    => {
                Module => 'Kernel::GenericInterface::Transport::HTTP::SOAP',
                Config => {},
            },
        },
        Type => 'SomeType',
    },
    {
        Name    => 'test 2',
        Success => 1,
        Data    => {
            Name        => 'Nagios',
            Description => 'Connector to send and receive date from Nagios 2.',
            Provider    => {
                Config => {
                    NameSpace  => '!"§$%&/()=?Ü*ÄÖL:L@,.-',
                    SOAPAction => '',
                    Encoding   => '',
                    Endpoint =>
                        'iojfoiwjeofjweoj ojerojgv oiaejroitjvaioejhtioja viorjhiojgijairogj aiovtq348tu 08qrujtio juortu oquejrtwoiajdoifhaois hnaeruoigbo eghjiob jaer89ztuio45u603u4i9tj340856u903 jvipojziopeji',
                },
            },
        },
        Type => 'SomeType',
    },
    {
        Name    => 'test 3',
        Success => 1,
        Data    => {},
        Type    => 'SomeType',
    },
    {
        Name    => 'test 4',
        Success => 1,
        Data    => {
            Name        => 'Nagios',
            Description => 'Connector to send and receive date from Nagios 2.'
                . "\nasdkaosdkoa\tsada\n",
            Provider => {},
        },
        Type => 'SomeType',
    },
    {
        Name    => 'test 5',
        Success => 0,
        Data    => undef,
        Type    => 'SomeType',
    },
    {
        Name    => 'test 6',
        Success => 1,
        Data    => {},
        Type    => 'SomeType',
        DueTime => $CurrentTime,
    },
    {
        Name    => 'test 7',
        Success => 0,
        Data    => {},
        Type    => 'SomeType',
        DueTime => 'today',
    },
    {
        Name    => 'test 8',
        Success => 1,
        Data    => {},
        Type    => 'SomeType',
        DueTime => undef,
    },
    {
        Name    => 'test 9 (too large task)',
        Success => 0,
        Data    => {
            Name        => 'Nagios',
            Description => 'Connector to send and receive date from Nagios 2.'
                . "\nasdkaosdkoa\tsada\n",
            LargeContent => "abcdefghij\n" x 10_000,
        },
        Type => 'SomeType',
    },

);

my @TaskIDs;

TEST:
for my $Test (@Tests) {

    # add config
    my $TaskID = $TaskManagerObject->TaskAdd(
        Data    => $Test->{Data},
        Type    => $Test->{Type},
        DueTime => $Test->{DueTime},
    );
    if ( !$Test->{Success} ) {
        $Self->False(
            $TaskID,
            "$Test->{Name} - TaskAdd() success",
        );
        next TEST;
    }
    else {
        $Self->True(
            $TaskID,
            "$Test->{Name} - TaskAdd() failure",
        );
    }

    # remember id to delete it later
    push @TaskIDs, $TaskID;

    # get config
    my %Task = $TaskManagerObject->TaskGet(
        ID => $TaskID,
    );

    # verify config
    $Self->Is(
        $Test->{Type},
        $Task{Type},
        "$Test->{Name} - TaskGet() - Type",
    );
    $Self->IsDeeply(
        $Test->{Data},
        $Task{Data},
        "$Test->{Name} - TaskGet() - Data",
    );

    if ( $Test->{DueTime} ) {
        $Self->Is(
            $Test->{DueTime},
            $Task{DueTime},
            "$Test->{Name} - TaskGet() - DueTime set",
        );
    }
    else {
        $Self->True(
            $Task{DueTime},
            "$Test->{Name} - TaskGet() - DueTime default",
        );
    }
}

# list check
my @List  = $TaskManagerObject->TaskList();
my $Count = 0;
for my $TaskIDFromList (@List) {
    $Self->Is(
        $TaskIDFromList->{ID},
        $TaskIDs[$Count],
        "TaskList() entry",
    );
    $Count++;
}

$Self->Is(
    scalar @List,
    scalar @TaskIDs,
    "TaskList() size",
);

# basic update test
sleep 1;
my %OriginalTask = (
    Data => {
        Name => 'Just a Test',
    },
    Type    => 'Test',
    DueTime => '2013-12-12 12:00:00',
);
my $TaskID = $TaskManagerObject->TaskAdd(%OriginalTask);

if ( !$TaskID ) {
    my $Message = $Self->{LogObject}->GetLogEntry(
        Type => 'error',
        What => 'Message',
    );
    $Self->False(
        1,
        "TaskAdd() not added because: $Message",
    );
}

$Self->IsNot(
    $TaskID,
    undef,
    "TaskAdd() for TaskUpdate() should not be undefined",
);
push @TaskIDs, $TaskID;

my %Task = $TaskManagerObject->TaskGet(
    ID => $TaskID,
);

for my $Attribute (qw(Type DueTime)) {
    $Self->Is(
        $Task{$Attribute},
        $OriginalTask{$Attribute},
        "TaskGet() $Attribute before Update",
    );
}
$Self->IsDeeply(
    $Task{Data},
    $OriginalTask{Data},
    "TaskGet() Data before Update",
);

@Tests = (
    {
        Name    => 'Empty',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Wrong DueTime',
        Config => {
            ID      => $TaskID,
            DueTime => '123',
        },
        Success => 0,
    },
    {
        Name   => 'Only ID',
        Config => {
            ID => $TaskID,
        },
        Success => 1,
    },
    {
        Name   => 'Update Type',
        Config => {
            ID   => $TaskID,
            Type => 'Any Type',
        },
        Success => 1,
    },
    {
        Name   => 'Update DueTime',
        Config => {
            ID      => $TaskID,
            DueTime => '2013-12-12 13:00:00',
        },
        Success => 1,
    },
    {
        Name   => 'Update Data',
        Config => {
            ID   => $TaskID,
            Data => {
                Other => 'Other',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Update All',
        Config => {
            ID      => $TaskID,
            Type    => 'Ultimate',
            DueTime => '2013-08-21 16:00:00',
            Data    => {
                Data => 'Data',
            },
        },
        Success => 1,
    },
);

for my $Test (@Tests) {
    my $Success = $TaskManagerObject->TaskUpdate( %{ $Test->{Config} } );

    %Task = $TaskManagerObject->TaskGet(
        ID => $TaskID,
    );

    if ( !$Test->{Success} ) {
        $Self->False(
            $Success,
            "$Test->{Name} TaskUpdate() - With False",
        );

        for my $Attribute (qw(Type DueTime)) {
            $Self->Is(
                $Task{$Attribute},
                $OriginalTask{$Attribute},
                "$Test->{Name} TaskGet() $Attribute after Update",
            );
        }
        $Self->IsDeeply(
            $Task{Data},
            $OriginalTask{Data},
            "$Test->{Name} TaskGet() Data after Update",
        );
    }
    else {
        $Self->True(
            $Success,
            "$Test->{Name} TaskUpdate() - With True",
        );

        for my $Attribute (qw(Type DueTime)) {
            my $ExpectedAttribute = $OriginalTask{$Attribute};
            if ( $Test->{Config}->{$Attribute} ) {
                $ExpectedAttribute = $Test->{Config}->{$Attribute};
            }
            $Self->Is(
                $Task{$Attribute},
                $ExpectedAttribute,
                "$Test->{Name} TaskGet() $Attribute after Update",
            );
        }
        my $ExpectedData = $OriginalTask{Data};
        if ( $Test->{Config}->{Data} ) {
            $ExpectedData = $Test->{Config}->{Data};
        }
        $Self->IsDeeply(
            $Task{Data},
            $ExpectedData,
            "$Test->{Name} TaskGet() Data after Update",
        );
    }

    # restore task
    $Success = $TaskManagerObject->TaskUpdate(
        ID => $TaskID,
        %OriginalTask,
    );
    $Self->True(
        $Success,
        "$Test->{Name} TaskUpdate() - for restore With True",
    );
}

# delete config
for my $TaskID (@TaskIDs) {
    my $Success = $TaskManagerObject->TaskDelete(
        ID => $TaskID,
    );
    $Self->True(
        $Success,
        'TaskDelete() success',
    );
    $Success = $TaskManagerObject->TaskDelete(
        ID => $TaskID,
    );
    $Self->False(
        $Success,
        'TaskDelete() failure',
    );
}

$Self->Is(
    scalar $TaskManagerObject->TaskList(),
    0,
    "TaskList() empty",
);

# start scheduler if it was already running before this test
if ( $PreviousSchedulerStatus =~ /^running/i ) {
    `$Scheduler -a start`;
}

1;
