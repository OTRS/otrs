# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
use strict;
use warnings;
use vars (qw($Self));

use utf8;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Module       = 'StaticDB';

$ConfigObject->Set(
    Key   => 'Ticket::ArchiveSystem',
    Value => 1,
);

$ConfigObject->Set(
    Key   => 'Ticket::IndexModule',
    Value => "Kernel::System::Ticket::IndexAccelerator::$Module",
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
$Self->True(
    $TicketObject->isa("Kernel::System::Ticket::IndexAccelerator::$Module"),
    "TicketObject loaded the correct backend",
);

my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
my $DBObject    = $Kernel::OM->Get('Kernel::System::DB');

# test scenarios for Tickets
my @Tests = (
    {
        Name => 'Ticket 1',
        Data => {
            Title        => 'Some Ticket_Title 1',
            CustomerNo   => '123456',
            CustomerUser => 'customer1@example.com',
        },
    },
);

my $QueueBefore = 'Raw';
my %Queue       = $QueueObject->QueueGet( Name => $QueueBefore );
my $QueueID     = $Queue{QueueID};

my @TicketIDs;
for my $Test (@Tests) {
    my $TicketID = $TicketObject->TicketCreate(
        Title        => $Test->{Data}->{Title},
        QueueID      => $QueueID,
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'new',
        CustomerNo   => $Test->{Data}->{CustomerNo},
        CustomerUser => $Test->{Data}->{CustomerUser},
        OwnerID      => 1,
        UserID       => 1,
    );
    push( @TicketIDs, $TicketID );
    $Self->True(
        $TicketID,
        "$Module $Test->{Name} TicketCreate() - $TicketID ",
    );
}

#loop for each created Queues, updating Queue , and checking ticket index before and after UpdateQueue()
my %IndexBefore = $TicketObject->TicketAcceleratorIndex(
    UserID        => 1,
    QueueID       => $QueueID,
    ShownQueueIDs => [$QueueID],
);

my $Updated = $QueueObject->QueueUpdate(
    %Queue,
    Name   => "Raw2",
    UserID => 1,
);
$Self->True(
    $Updated,
    "Queue:\'$QueueBefore\' is updated",
);
my $QueueAfter = $QueueObject->QueueLookup( QueueID => $QueueID );
$Self->IsNot(
    $QueueAfter,
    $QueueBefore,
    "Compare Queue name - Before:\'$QueueBefore\' => After: \'$QueueAfter\'",
);
my %IndexAfter = $TicketObject->TicketAcceleratorIndex(
    UserID        => 1,
    QueueID       => $QueueID,
    ShownQueueIDs => [$QueueID],
);
$Self->Is(
    $IndexBefore{AllTickets} // 0,
    $IndexAfter{AllTickets}  // 1,
    "$Module TicketAcceleratorIndex() - AllTickets",
);

my ($ItemBefore) = grep { $_->{Queue} eq 'Raw' } @{ $IndexBefore{Queues} };
my ($ItemAfter)  = grep { $_->{Queue} eq 'Raw2' } @{ $IndexAfter{Queues} };

$Self->Is(
    $ItemBefore->{Count} // 0,
    $ItemAfter->{Count}  // 1,
    "$Module TicketAcceleratorIndex() for Queue: $ItemAfter->{Queue} - Count",
);

my $Restored = $QueueObject->QueueUpdate(
    %Queue,
    Name   => "Raw",
    UserID => 1,
);
$Self->True(
    $Restored,
    "Queue:\'$QueueBefore\' is restored",
);

# delete tickets
for my $TicketID (@TicketIDs) {
    $Self->True(
        $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        ),
        "$Module TicketDelete() - $TicketID",
    );
}

1;
