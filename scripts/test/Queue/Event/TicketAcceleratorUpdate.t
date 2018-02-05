# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$ConfigObject->Set(
    Key   => 'Ticket::ArchiveSystem',
    Value => 1,
);

$ConfigObject->Set(
    Key   => 'Ticket::IndexModule',
    Value => "Kernel::System::Ticket::IndexAccelerator::$Module",
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');
my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');

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

my $QueueBefore = 'Unittest-' . $Helper->GetRandomID();

my $QueueIDExist = $QueueObject->QueueLookup( Queue => $QueueBefore );

if ( !$QueueIDExist ) {

    my $QueueID = $QueueObject->QueueAdd(
        Name            => $QueueBefore,
        GroupID         => 1,
        ValidID         => 1,
        SystemAddressID => 1,
        SalutationID    => 1,
        SignatureID     => 1,
        Comment         => 'Unittest queue',
        UserID          => 1,
    );

    $Self->True(
        $QueueID,
        "Queue:\'$QueueBefore\' is created new for testing.",
    );
}

my %Queue = $QueueObject->QueueGet( Name => $QueueBefore );
my $QueueID = $Queue{QueueID};

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

my $QueueAfterName = 'Unittest-' . $Helper->GetRandomID();

my $Updated = $QueueObject->QueueUpdate(
    %Queue,
    Name   => $QueueAfterName,
    UserID => 1,
);
$Self->True(
    $Updated,
    "Queue:\'$QueueBefore\' is updated",
);
$QueueAfterName = $QueueObject->QueueLookup( QueueID => $QueueID );
$Self->IsNot(
    $QueueAfterName,
    $QueueBefore,
    "Compare Queue name - Before:\'$QueueBefore\' => After: \'$QueueAfterName\'",
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

my ($ItemBefore) = grep { $_->{Queue} eq 'CustomQueue' } @{ $IndexBefore{Queues} };
my ($ItemAfter)  = grep { $_->{Queue} eq 'CustomQueue' } @{ $IndexAfter{Queues} };

$Self->Is(
    $ItemBefore->{Count} // 0,
    $ItemAfter->{Count}  // 1,
    "$Module TicketAcceleratorIndex() for Queue: $QueueAfterName - Count",
);

my $Restored = $QueueObject->QueueUpdate(
    %Queue,
    Name   => $QueueBefore,
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

# cleanup is done by RestoreDatabase.

1;
