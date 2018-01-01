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

# Get needed objects.
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');
my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $Module = 'StaticDB';

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

# Make UserID 1 valid.
my %RootUser = $UserObject->GetUserData(
    UserID => 1,
);
my $Success = $UserObject->UserUpdate(
    %RootUser,
    UserID       => 1,
    ValidID      => 1,
    ChangeUserID => 1,
);
$Self->True(
    $Success,
    "Force root user to be valid",
);

my $QueueBefore = 'Unittest-' . $HelperObject->GetRandomID();
my %Queue = $QueueObject->QueueGet( Name => $QueueBefore );

# Create test queue if raw queue does not exist.
my $QueueID;
if ( !%Queue ) {

    $QueueID = $QueueObject->QueueAdd(
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

    %Queue = $QueueObject->QueueGet( Name => $QueueBefore );
    $QueueID = $Queue{QueueID};
}

# Reactivate queue if it is disabled.
else {

    my $Updated = $QueueObject->QueueUpdate(
        %Queue,
        ValidID => 1,
        UserID  => 1,
    );

    $Self->True(
        $Updated,
        "Queue:\'$QueueBefore\' is prepared for testing.",
    );
}

my $QueueAfter;
TRY:
for my $Try ( 1 .. 20 ) {

    $QueueAfter = 'Unittest-' . $HelperObject->GetRandomID();

    my %Queue2 = $QueueObject->QueueGet(
        Name => $QueueAfter,
    );

    last TRY if !%Queue2;
}

# Test scenarios for Tickets.
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

# Loop for each created Queues, updating Queue , and checking ticket index before and after UpdateQueue().
my %IndexBefore = $TicketObject->TicketAcceleratorIndex(
    UserID        => 1,
    QueueID       => $QueueID,
    ShownQueueIDs => [$QueueID],
);

my $Updated = $QueueObject->QueueUpdate(
    %Queue,
    Name   => $QueueAfter,
    UserID => 1,
);
$Self->True(
    $Updated,
    "Queue:\'$QueueBefore\' is updated",
);
my $QueueAfterName = $QueueObject->QueueLookup( QueueID => $QueueID );
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

my ($ItemBefore) = grep { $_->{Queue} eq $QueueBefore } @{ $IndexBefore{Queues} };
my ($ItemAfter)  = grep { $_->{Queue} eq $QueueAfter } @{ $IndexAfter{Queues} };

$Self->Is(
    $ItemBefore->{Count} // 0,
    $ItemAfter->{Count}  // 1,
    "$Module TicketAcceleratorIndex() for Queue: $QueueAfter - Count",
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

# Restore UserID 1 previous validity.
$Success = $UserObject->UserUpdate(
    %RootUser,
    UserID       => 1,
    ChangeUserID => 1,
);
$Self->True(
    $Success,
    "Restored root user validity",
);

1;
