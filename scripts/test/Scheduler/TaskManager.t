# --
# TaskManager.t - TaskManager tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: TaskManager.t,v 1.5 2011-02-15 20:54:29 mb Exp $
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
);

my @TaskIDs;
for my $Test (@Tests) {

    # add config
    my $TaskID = $TaskManagerObject->TaskAdd(
        Data => $Test->{Data},
        Type => $Test->{Type},
    );
    if ( !$Test->{Success} ) {
        $Self->False(
            $TaskID,
            "$Test->{Name} - TaskAdd()",
        );
        next;
    }
    else {
        $Self->True(
            $TaskID,
            "$Test->{Name} - TaskAdd()",
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
}

# list check
my @List  = $TaskManagerObject->TaskList();
my $Count = 0;
for my $TaskIDFromList (@List) {
    $Self->Is(
        $TaskIDFromList->{ID},
        $TaskIDs[$Count],
        "TaskList() Is",
    );
    $Count++;
}
$Count = 0;
for my $TaskIDFromList ( reverse @List ) {
    $Self->IsNot(
        $TaskIDFromList->{ID},
        $TaskIDs[$Count],
        "TaskList() - IsNot",
    );
    $Count++;
}

# delete config
for my $TaskID (@TaskIDs) {
    my $Success = $TaskManagerObject->TaskDelete(
        ID => $TaskID,
    );
    $Self->True(
        $Success,
        'TaskDelete()',
    );
    $Success = $TaskManagerObject->TaskDelete(
        ID => $TaskID,
    );
    $Self->False(
        $Success,
        'TaskDelete()',
    );
}

1;
