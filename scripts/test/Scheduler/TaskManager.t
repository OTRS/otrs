# --
# TaskManager.t - TaskManager tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: TaskManager.t,v 1.7 2011-03-10 14:00:16 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::System::Scheduler::TaskManager;

my $TaskManagerObject = Kernel::System::Scheduler::TaskManager->new( %{$Self} );

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

1;
