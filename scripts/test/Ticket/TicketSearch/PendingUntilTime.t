# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my @TicketIDs;

# Create some test tickets for the test.
for my $Counter ( 1 .. 4 ) {
    my $TicketID = $TicketObject->TicketCreate(
        Title        => "My ticket created by Agent",
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'new',
        CustomerID   => 'example',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );

    $Self->True(
        $TicketID,
        "TicketCreate() for test - $TicketID",
    );
    push @TicketIDs, $TicketID;
}

my @Tests = (
    {
        Description        => "Test search param 'TicketPendingTimeNewerDate' without a ticket with a set pending time",
        TicketUpdate       => {},
        TicketSearchConfig => {
            TicketPendingTimeNewerDate => '2016-12-01 12:00:00',
        },
        ExpectedResultTicketIDs => [],
    },
    {
        Description =>
            "Test search param 'TicketPendingTimeNewerDate' with tickets which have a pending time, but wrong state",
        TimeStamp    => '2015-11-30 08:00:00',
        TicketUpdate => {
            $TicketIDs[0] => {
                PendingTime => '2015-12-01 13:00:00',
            },
            $TicketIDs[3] => {
                PendingTime => '2015-12-03 13:00:00',
            },
        },
        TicketSearchConfig => {
            TicketPendingTimeNewerDate => '2015-12-01 14:00:00',
        },
        ExpectedResultTicketIDs => [],
    },
    {
        Description =>
            "Test search param 'TicketPendingTimeNewerDate' with tickets which have a pending time and correct state",
        TimeStamp    => '2015-11-30 08:00:00',
        TicketUpdate => {
            $TicketIDs[0] => {
                PendingTime => '2015-12-01 13:00:00',
                State       => 'pending reminder',
            },
            $TicketIDs[3] => {
                PendingTime => '2015-12-03 12:00:00',
                State       => 'pending reminder',
            },
        },
        TicketSearchConfig => {
            TicketPendingTimeNewerDate => '2015-12-01 14:00:00',
        },
        ExpectedResultTicketIDs => [ $TicketIDs[3], ],
    },
    {
        Description =>
            "Test search param 'TicketPendingTimeOlderDate' with tickets which have a pending time, but wrong state",
        TimeStamp    => '2015-11-20 08:00:00',
        TicketUpdate => {
            $TicketIDs[1] => {
                PendingTime => '2015-11-10 13:00:00',
            },
            $TicketIDs[2] => {
                PendingTime => '2015-11-12 12:00:00',
            },
        },
        TicketSearchConfig => {
            TicketPendingTimeOlderDate => '2015-11-15 14:00:00',
        },
        ExpectedResultTicketIDs => [],
    },
    {
        Description =>
            "Test search param 'TicketPendingTimeOlderDate' with tickets which have a pending time and correct state",
        TimeStamp    => '2015-11-20 08:00:00',
        TicketUpdate => {
            $TicketIDs[1] => {
                PendingTime => '2015-11-10 13:00:00',
                State       => 'pending reminder',
            },
            $TicketIDs[2] => {
                PendingTime => '2015-11-12 12:00:00',
                State       => 'pending reminder',
            },
        },
        TicketSearchConfig => {
            TicketPendingTimeOlderDate => '2015-11-15 14:00:00',
        },
        ExpectedResultTicketIDs => [ $TicketIDs[1], $TicketIDs[2], ],
    },
    {
        Description =>
            "Test search param 'TicketPendingTimeOlderDate' and 'TicketPendingTimeNewerDate' together, but newer date is greater then older date",
        TimeStamp          => '2015-11-20 08:00:00',
        TicketSearchConfig => {
            TicketPendingTimeNewerDate => '2015-12-01 14:00:00',
            TicketPendingTimeOlderDate => '2015-11-15 14:00:00',
        },
        ExpectedResultTicketIDs => [],
    },
    {
        Description => "Test search param 'TicketPendingTimeOlderDate' and 'TicketPendingTimeNewerDate' together",
        TimeStamp   => '2015-11-20 08:00:00',
        TicketSearchConfig => {
            TicketPendingTimeNewerDate => '2015-12-01 00:00:00',
            TicketPendingTimeOlderDate => '2015-12-05 00:00:00',
        },
        ExpectedResultTicketIDs => [ $TicketIDs[0], $TicketIDs[3], ],
    },
    {
        Description =>
            "Test search param 'TicketPendingTimeOlderMinutes' with tickets which have a pending time and correct state",
        TimeStamp    => '2016-04-13 12:00:00',
        TicketUpdate => {
            $TicketIDs[0] => {
                PendingTime => '2016-04-13 10:30:00',
                State       => 'pending reminder',
            },
            $TicketIDs[1] => {
                PendingTime => '2016-04-14 14:00:00',
                State       => 'pending auto close+',
            },
            $TicketIDs[2] => {
                PendingTime => '2016-04-14 18:00:00',
                State       => 'pending reminder',
            },
            $TicketIDs[3] => {
                PendingTime => '2016-04-15 10:00:00',
                State       => 'pending auto close+',
            },
        },
        TicketSearchConfig => {
            TicketPendingTimeOlderMinutes => '60',
        },
        ExpectedResultTicketIDs => [ $TicketIDs[0] ],
    },
    {
        Description =>
            "Test search param 'TicketPendingTimeNewerMinutes' with tickets which have a pending time and correct state",
        TimeStamp          => '2016-04-14 19:15:00',
        TicketSearchConfig => {
            TicketPendingTimeNewerMinutes => '60',
        },
        ExpectedResultTicketIDs => [ $TicketIDs[3] ],
    },
    {
        Description =>
            "Test search param 'TicketPendingTimeNewerMinutes' with tickets which have a pending time in future and correct state",
        TimeStamp          => '2016-04-14 17:15:00',
        TicketSearchConfig => {
            TicketPendingTimeNewerMinutes => '-60',
        },
        ExpectedResultTicketIDs => [ $TicketIDs[3] ],
    },
    {
        Description => "Test search param 'TicketPendingTimeNewerMinutes' and 'TicketPendingTimeOlderMinutes' together",
        TimeStamp   => '2016-04-14 19:00:00',
        TicketSearchConfig => {
            TicketPendingTimeNewerMinutes => '2160',
            TicketPendingTimeOlderMinutes => '120',
        },
        ExpectedResultTicketIDs => [ $TicketIDs[0], $TicketIDs[1], ],
    },
);

# define test counter
my $TestCount = 1;

TEST:
for my $Test (@Tests) {

    if ( !$Test->{TicketSearchConfig} || ref $Test->{TicketSearchConfig} ne 'HASH' ) {

        $Self->True(
            0,
            "Test $TestCount: No TicketSearchConfig found for this test.",
        );

        next TEST;
    }

    if ( $Test->{TimeStamp} ) {

        # set the fixed time
        my $SystemTime = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Test->{TimeStamp},
            }
        )->ToEpoch();
        $Helper->FixedTimeSet($SystemTime);
    }

    # print test case description
    if ( $Test->{Description} ) {
        $Self->True(
            1,
            "Test $TestCount: $Test->{Description}",
        );
    }

    if ( IsHashRefWithData( $Test->{TicketUpdate} ) ) {

        # Change the given data from the diffrent tickets.
        for my $TicketID ( sort keys %{ $Test->{TicketUpdate} } ) {

            my $Success = $TicketObject->TicketPendingTimeSet(
                String   => $Test->{TicketUpdate}->{$TicketID}->{PendingTime},
                TicketID => $TicketID,
                UserID   => 1,
            );

            $Self->True(
                $Success,
                "Test $TestCount: TicketPendingTimeSet() - Update ticket pending time for TicketID '$TicketID' - success.",
            );

            if ( $Test->{TicketUpdate}->{$TicketID}->{State} ) {

                $Success = $TicketObject->TicketStateSet(
                    State    => $Test->{TicketUpdate}->{$TicketID}->{State},
                    TicketID => $TicketID,
                    UserID   => 1,
                );

                $Self->True(
                    $Success,
                    "Test $TestCount: TicketStateSet() - Update ticket state for TicketID '$TicketID' - success.",
                );
            }

        }
    }

    my @FoundTicketIDs = $TicketObject->TicketSearch(
        Result   => 'ARRAY',
        UserID   => 1,
        TicketID => [@TicketIDs],
        %{ $Test->{TicketSearchConfig} },
    );

    @FoundTicketIDs = sort { int $a <=> int $b } @FoundTicketIDs;
    @{ $Test->{ExpectedResultTicketIDs} } = sort { int $a <=> int $b } @{ $Test->{ExpectedResultTicketIDs} };

    $Self->IsDeeply(
        \@FoundTicketIDs,
        $Test->{ExpectedResultTicketIDs},
        "Test $TestCount: TicketSearch() - test the search result",
    );
}
continue {

    $Helper->FixedTimeUnset();

    $TestCount++;
}

# cleanup is done by RestoreDatabase.

1;
