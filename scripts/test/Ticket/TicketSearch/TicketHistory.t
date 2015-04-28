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

my @TicketIDs;

# get ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# create a new ticket (1)
my $TicketID1 = $TicketObject->TicketCreate(
    Title      => 'My ticket created by Agent A',
    QueueID    => '1',
    Lock       => 'unlock',
    PriorityID => 1,
    StateID    => 1,
    OwnerID    => 1,
    UserID     => 1,
);

$Self->True(
    $TicketID1,
    "TicketCreate() for test - $TicketID1",
);
push @TicketIDs, $TicketID1;

# create a new ticket (2)
my $TicketID2 = $TicketObject->TicketCreate(
    Title      => 'My ticket created by Agent A',
    QueueID    => '1',
    Lock       => 'unlock',
    PriorityID => 1,
    StateID    => 1,
    OwnerID    => 1,
    UserID     => 1,
);

$Self->True(
    $TicketID2,
    "TicketCreate() for test - $TicketID1",
);
push @TicketIDs, $TicketID1;

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
$HelperObject->FixedTimeSet();

$HelperObject->FixedTimeAddSeconds(60);

# update ticket 1
my $Success = $TicketObject->TicketLockSet(
    Lock     => 'lock',
    TicketID => $TicketID1,
    UserID   => 1,
);
$Self->True(
    $Success,
    "TicketLockSet() for test - $TicketID1",
);

# close ticket 2
$Success = $TicketObject->TicketStateSet(
    State    => 'closed successful',
    TicketID => $TicketID2,
    UserID   => 1,
);
$Self->True(
    $Success,
    "TicketStateSet() for test - $TicketID2",
);

$HelperObject->FixedTimeAddSeconds(60);

my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

# the following tests should provoke a join in ticket_history table and the resulting SQL should be valid
my @Tests = (
    {
        Name   => "CreatedTypeIDs",
        Config => {
            CreatedTypeIDs => [ '1', ],
        },
        ExpectedTicketIDs => [ $TicketID1, $TicketID2 ],
    },
    {
        Name   => "CreatedStateIDs",
        Config => {
            CreatedStateIDs => [ '1', ],
        },
        ExpectedTicketIDs => [ $TicketID1, ],
    },
    {
        Name   => "CreatedUserIDs",
        Config => {
            CreatedUserIDs => [ '1', ],
        },
        ExpectedTicketIDs => [ $TicketID1, $TicketID2 ],
    },
    {
        Name   => "CreatedQueueIDs",
        Config => {
            CreatedQueueIDs => [ '1', ],
        },
        ExpectedTicketIDs => [ $TicketID1, $TicketID2 ],
    },
    {
        Name   => "CreatedPriorityIDs",
        Config => {
            CreatedPriorityIDs => [ '1', ],
        },
        ExpectedTicketIDs => [ $TicketID1, $TicketID2 ],
    },
    {
        Name   => "TicketChangeTimeOlderDate",
        Config => {
            TicketChangeTimeOlderDate => $TimeObject->CurrentTimestamp(),
        },
        ExpectedTicketIDs => [ $TicketID1, $TicketID2 ],
    },
    {
        Name   => "TicketCloseTimeOlderDate",
        Config => {
            TicketCloseTimeOlderDate => $TimeObject->CurrentTimestamp(),
        },
        ExpectedTicketIDs => [$TicketID2],
    },
    {
        Name   => "TicketCloseTimeNewerDate",
        Config => {
            TicketCloseTimeNewerDate => $TimeObject->SystemTime2TimeStamp(
                SystemTime => $TimeObject->SystemTime() - 61,
            ),
        },
        ExpectedTicketIDs => [$TicketID2],
    },
);

for my $Test (@Tests) {

    my @ReturnedTicketIDs = $TicketObject->TicketSearch(
        Result  => 'ARRAY',
        UserID  => 1,
        OrderBy => ['Up'],
        SortBy  => ['TicketNumber'],
        %{ $Test->{Config} },
    );

    my %ReturndedLookup = map { $_ => 1 } @ReturnedTicketIDs;

    for my $TicketID ( @{ $Test->{ExpectedTicketIDs} } ) {

        $Self->True(
            $ReturndedLookup{$TicketID},
            "$Test->{Name} TicketSearch() - Results contains ticket $TicketID",
        );
    }
}

for my $TicketID (@TicketIDs) {

    my $Success = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $Success,
        "Removed ticket $TicketID",
    );
}

1;
