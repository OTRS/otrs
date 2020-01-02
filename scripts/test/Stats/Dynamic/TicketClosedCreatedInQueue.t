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

use List::Util qw();

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
    'Kernel::Language' => {
        UserLanguage => 'en',
    },
);
my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
my $StatsObject  = $Kernel::OM->Get('Kernel::System::Stats');

my $RandomID = $Helper->GetRandomID();

# Create test queue.
my $QueueName = "Statistic-Queue-" . $RandomID;
my $QueueID   = $QueueObject->QueueAdd(
    Name            => $QueueName,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);
$Self->True(
    $QueueID,
    "QueueAdd() successful for test - QueueID $QueueID",
);

# Create test tickets.
my @Tickets = (
    {
        TimeStamp  => '2014-10-10 08:00:00',
        TicketData => {
            Title                 => 'Statistic Ticket Title',
            Queue                 => $QueueName,
            Lock                  => 'unlock',
            Priority              => '3 normal',
            State                 => 'open',
            CustomerID            => 'example + test',
            CustomerUser          => 'customer1@example.com',
            OwnerID               => 1,
            UserID                => 1,
            AddSecondsBeforeClose => 360,
        },
    },
    {
        TimeStamp  => '2014-10-12 09:00:00',
        TicketData => {
            Title                 => 'Statistic Ticket Title',
            Queue                 => $QueueName,
            Lock                  => 'unlock',
            Priority              => '3 normal',
            State                 => 'open',
            CustomerID            => 'example + test',
            CustomerUser          => 'customer1@example.com',
            OwnerID               => 1,
            UserID                => 1,
            AddSecondsBeforeClose => 960,
        },
    },
    {
        TimeStamp  => '2014-10-12 12:00:00',
        TicketData => {
            Title        => 'Statistic Ticket Title',
            Queue        => $QueueName,
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerID   => 'example + test',
            CustomerUser => 'customer1@example.com',
            OwnerID      => 1,
            UserID       => 1,
        },
    },
    {
        TimeStamp  => '2014-10-14 08:00:00',
        TicketData => {
            Title        => 'Statistic Ticket Title',
            Queue        => $QueueName,
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerID   => 'example + test',
            CustomerUser => 'customer1@example.com',
            OwnerID      => 1,
            UserID       => 1,
        },
    },
    {
        TimeStamp  => '2014-10-11 08:00:00',
        TicketData => {
            Title        => 'Statistic Ticket Title',
            Queue        => $QueueName,
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerID   => 'example + test',
            CustomerUser => 'customer1@example.com',
            OwnerID      => 1,
            UserID       => 1,
        },
    },
);

my %ClosedTickets = ();

TICKET:
for my $Ticket (@Tickets) {
    my $SystemTime = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Ticket->{TimeStamp},
        },
    );

    # set the fixed time
    $Helper->FixedTimeSet($SystemTime);

    # create the ticket
    my $TicketID = $TicketObject->TicketCreate(
        %{ $Ticket->{TicketData} },
    );
    $Self->True(
        $TicketID,
        "TicketCreate() successful for test - TicketID $TicketID",
    );

    if ( $Ticket->{TicketData}->{AddSecondsBeforeClose} ) {

        $Helper->FixedTimeAddSeconds( $Ticket->{TicketData}->{AddSecondsBeforeClose} );

        # Now close the ticket, because the statistic select only closed tickets.
        $TicketObject->TicketStateSet(
            TicketID => $TicketID,
            State    => 'closed successful',
            UserID   => 1,
        );

        # Get the ticket number,
        my %TicketData = $TicketObject->TicketGet(
            TicketID => $TicketID,
        );

        $ClosedTickets{ $TicketData{TicketNumber} } = 1;
    }

    $Helper->FixedTimeUnset();
}

# Create statistic
my $TicketClosedCreatedInQueueStatID = $StatsObject->StatsAdd(
    UserID => 1,
);
$Self->True(
    $TicketClosedCreatedInQueueStatID,
    "StatsAdd() TicketClosedCreatedInQueue - successful",
);

# Set statistic config.
my $UpdateSuccess = $StatsObject->StatsUpdate(
    StatID => $TicketClosedCreatedInQueueStatID,
    Hash   => {
        Title        => 'Title for result tests',
        Description  => 'some Description',
        Object       => 'TicketList',
        Format       => 'CSV',
        ObjectModule => 'Kernel::System::Stats::Dynamic::TicketList',
        StatType     => 'dynamic',
        Cache        => 0,
        Valid        => 1,
        UseAsXvalue  => [
            {
                Element        => 'TicketAttributes',
                Block          => 'MultiSelectField',
                Name           => 'Attributes to be printed',
                Sort           => 'IndividualKey',
                Selected       => 1,
                Translation    => 1,
                Fixed          => 1,
                SelectedValues => [
                    'TicketNumber',
                    'Created',
                    'Closed',
                    'Queue'
                ],
            },
        ],
        UseAsValueSeries => [
            {
                Block          => 'SelectField',
                Name           => 'Order by',
                Element        => 'OrderBy',
                SelectedValues => [
                    'Created',
                ],
                Selected    => 1,
                Fixed       => 1,
                Translation => 1,
                Sort        => 'IndividualKey',
            },
            {
                Translation => 1,
                Values      => {
                    Down => 'descending',
                    Up   => 'ascending',
                },
                Name    => 'Sort sequence',
                Block   => 'SelectField',
                Element => 'SortSequence',
            },
        ],
        UseAsRestriction => [
            {
                Element     => 'CloseTime',
                Selected    => 1,
                Block       => 'Time',
                Name        => 'Close Time',
                Translation => 1,
                TimeStop    => '2014-10-31 23:59:59',
                Values      => {
                    TimeStop  => 'TicketCloseTimeOlderDate',
                    TimeStart => 'TicketCloseTimeNewerDate',
                },
                TimeRelativeUpcomingCount => 0,
                TimePeriodFormat          => 'DateInputFormat',
                TimeStart                 => '2014-10-01 00:00:00',
                Fixed                     => 1
            },
            {
                TreeView       => 1,
                SelectedValues => [ $QueueID, ],
                Name           => 'Created in Queue',
                Element        => 'CreatedQueueIDs',
                Translation    => 0,
                Block          => 'MultiSelectField',
                Selected       => 1,
                Fixed          => 1
            },
        ],
    },
    UserID => 1,
);

# sanity check
$Self->True(
    $UpdateSuccess,
    "StatsUpdate() TicketClosedCreatedInQueueStatID - successful",
);

# Get all the stat data.
my $Stat = $StatsObject->StatsGet(
    StatID => $TicketClosedCreatedInQueueStatID,
);

# Run the stat.
my ( undef, undef, @Records ) = @{
    $StatsObject->StatsRun(
        StatID   => $TicketClosedCreatedInQueueStatID,
        GetParam => $Stat,
        UserID   => 1,
    )
};

# Check that all closed tickets are in the report.
my $ValidReport = 1;
TICKET_NUMBER:
for my $TicketNumber ( sort keys %ClosedTickets ) {
    my $Found = List::Util::first { $_->[0] eq $TicketNumber } @Records;
    if ( !$Found ) {
        $ValidReport = 0;
        last TICKET_NUMBER;
    }
}

$Self->True(
    $ValidReport,
    'StatsRun() TicketClosedCreatedInQueueStatID - All closed tickets present in the stat result',
);

1;
