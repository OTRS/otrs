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

# Make sure that the ticket object gets recreated for each loop.
$Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => 'Raw' );

my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Internal',
);

my ( $TestUserLogin, $UserID ) = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users', ],
);

my @TicketIDs;
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title - ticket index accelerator tests',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => $UserID,
    UserID       => $UserID,
);
push( @TicketIDs, $TicketID );
$Self->True(
    $TicketID,
    "TicketCreate() - unlock - new",
);

my %IndexBefore = $TicketObject->TicketAcceleratorIndex(
    UserID        => $UserID,
    QueueID       => [ 1, 2, 3, 4, 5, $QueueID ],
    ShownQueueIDs => [ 1, 2, 3, 4, 5, $QueueID ],
);
$TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title - ticket index accelerator tests',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => $UserID,
    UserID       => $UserID,
);
push( @TicketIDs, $TicketID );
$Self->True(
    $TicketID,
    "TicketCreate() - unlock - closed successful",
);
$TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title - ticket index accelerator tests',
    Queue        => 'Raw',
    Lock         => 'lock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => $UserID,
    UserID       => $UserID,
);
push( @TicketIDs, $TicketID );
$Self->True(
    $TicketID,
    "TicketCreate() - lock - closed successful",
);
$TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title - ticket index accelerator tests',
    Queue        => 'Raw',
    Lock         => 'lock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => $UserID,
    UserID       => $UserID,
);
push( @TicketIDs, $TicketID );
$Self->True(
    $TicketID,
    "TicketCreate() - lock - open",
);
$TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title - ticket index accelerator tests',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => $UserID,
    UserID       => $UserID,
);
push( @TicketIDs, $TicketID );
$Self->True(
    $TicketID,
    "TicketCreate() - unlock - open",
);

my %IndexNow = $TicketObject->TicketAcceleratorIndex(
    UserID        => $UserID,
    QueueID       => [ 1, 2, 3, 4, 5, $QueueID ],
    ShownQueueIDs => [ 1, 2, 3, 4, 5, $QueueID ],
);
$Self->Is(
    $IndexBefore{AllTickets}  || 0,
    $IndexNow{AllTickets} - 2 || '',
    "TicketAcceleratorIndex() - AllTickets",
);
for my $ItemNow ( @{ $IndexNow{Queues} } ) {
    if ( $ItemNow->{Queue} eq 'Raw' ) {
        for my $ItemBefore ( @{ $IndexBefore{Queues} } ) {
            if ( $ItemBefore->{Queue} eq 'Raw' ) {
                $Self->Is(
                    $ItemBefore->{Count}  || 0,
                    $ItemNow->{Count} - 1 || '',
                    "TicketAcceleratorIndex() - Count",
                );
            }
        }
    }
}
my $TicketLock = $TicketObject->LockSet(
    Lock               => 'lock',
    TicketID           => $TicketIDs[1],
    SendNoNotification => 1,
    UserID             => $UserID,
);
$Self->True(
    $TicketLock,
    "LockSet()",
);
%IndexNow = $TicketObject->TicketAcceleratorIndex(
    UserID        => $UserID,
    QueueID       => [ 1, 2, 3, 4, 5, $QueueID ],
    ShownQueueIDs => [ 1, 2, 3, 4, 5, $QueueID ],
);
$Self->Is(
    $IndexBefore{AllTickets}  || 0,
    $IndexNow{AllTickets} - 2 || '',
    "TicketAcceleratorIndex() - AllTickets",
);
for my $ItemNow ( @{ $IndexNow{Queues} } ) {
    if ( $ItemNow->{Queue} eq 'Raw' ) {
        for my $ItemBefore ( @{ $IndexBefore{Queues} } ) {
            if ( $ItemBefore->{Queue} eq 'Raw' ) {
                $Self->Is(
                    $ItemBefore->{Count}  || 0,
                    $ItemNow->{Count} - 1 || '',
                    "TicketAcceleratorIndex() - Count",
                );
            }
        }
    }
}
$TicketLock = $TicketObject->LockSet(
    Lock               => 'lock',
    TicketID           => $TicketIDs[4],
    SendNoNotification => 1,
    UserID             => $UserID,
);
$Self->True(
    $TicketLock,
    "LockSet()",
);
%IndexNow = $TicketObject->TicketAcceleratorIndex(
    UserID        => $UserID,
    QueueID       => [ 1, 2, 3, 4, 5, $QueueID ],
    ShownQueueIDs => [ 1, 2, 3, 4, 5, $QueueID ],
);
$Self->Is(
    $IndexBefore{AllTickets}  || 0,
    $IndexNow{AllTickets} - 2 || '',
    "TicketAcceleratorIndex() - AllTickets",
);
for my $ItemNow ( @{ $IndexNow{Queues} } ) {
    if ( $ItemNow->{Queue} eq 'Raw' ) {
        for my $ItemBefore ( @{ $IndexBefore{Queues} } ) {
            if ( $ItemBefore->{Queue} eq 'Raw' ) {
                $Self->Is(
                    $ItemBefore->{Count} || 0,
                    $ItemNow->{Count}    || '',
                    "TicketAcceleratorIndex() - Count",
                );
            }
        }
    }
}
$TicketLock = $TicketObject->LockSet(
    Lock               => 'unlock',
    TicketID           => $TicketIDs[4],
    SendNoNotification => 1,
    UserID             => $UserID,
);
$Self->True(
    $TicketLock,
    "LockSet()",
);
%IndexNow = $TicketObject->TicketAcceleratorIndex(
    UserID        => $UserID,
    QueueID       => [ 1, 2, 3, 4, 5, $QueueID ],
    ShownQueueIDs => [ 1, 2, 3, 4, 5, $QueueID ],
);
$Self->Is(
    $IndexBefore{AllTickets}  || 0,
    $IndexNow{AllTickets} - 2 || '',
    "TicketAcceleratorIndex() - AllTickets",
);
for my $ItemNow ( @{ $IndexNow{Queues} } ) {
    if ( $ItemNow->{Queue} eq 'Raw' ) {
        for my $ItemBefore ( @{ $IndexBefore{Queues} } ) {
            if ( $ItemBefore->{Queue} eq 'Raw' ) {
                $Self->Is(
                    $ItemBefore->{Count}  || 0,
                    $ItemNow->{Count} - 1 || '',
                    "TicketAcceleratorIndex() - Count",
                );
            }
        }
    }
}
my $TicketState = $TicketObject->StateSet(
    State              => 'open',
    TicketID           => $TicketIDs[1],
    SendNoNotification => 1,
    UserID             => $UserID,
);
$Self->True(
    $TicketState,
    "StateSet()",
);
$TicketLock = $TicketObject->LockSet(
    Lock               => 'unlock',
    TicketID           => $TicketIDs[1],
    SendNoNotification => 1,
    UserID             => $UserID,
);
$Self->True(
    $TicketLock,
    "LockSet()",
);
%IndexNow = $TicketObject->TicketAcceleratorIndex(
    UserID        => $UserID,
    QueueID       => [ 1, 2, 3, 4, 5, $QueueID ],
    ShownQueueIDs => [ 1, 2, 3, 4, 5, $QueueID ],
);
$Self->Is(
    $IndexBefore{AllTickets}  || 0,
    $IndexNow{AllTickets} - 3 || '',
    "TicketAcceleratorIndex() - AllTickets",
);
for my $ItemNow ( @{ $IndexNow{Queues} } ) {
    if ( $ItemNow->{Queue} eq 'Raw' ) {
        for my $ItemBefore ( @{ $IndexBefore{Queues} } ) {
            if ( $ItemBefore->{Queue} eq 'Raw' ) {
                $Self->Is(
                    $ItemBefore->{Count}  || 0,
                    $ItemNow->{Count} - 2 || '',
                    "TicketAcceleratorIndex() - Count",
                );
            }
        }
    }
}

# array to save the accounted times of each ticket
my @AccountedTimes = ();
my $Position       = 0;

for my $TicketID (@TicketIDs) {

    for my $Index ( 1 .. 3 ) {

        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'agent',
            IsVisibleForCustomer => 0,
            From                 => 'Some Agent <email@example.com>',
            To                   => 'Some Customer A <customer-a@example.com>',
            Subject              => 'some short description',
            Body                 => 'the message text',
            Charset              => 'ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'OwnerUpdate',
            HistoryComment       => 'Some free text!',
            UserID               => $UserID,
        );

        # add accounted time
        $Self->True(
            $TicketObject->TicketAccountTime(
                TicketID  => $TicketID,
                ArticleID => $ArticleID,
                TimeUnit  => $Index,
                UserID    => $UserID,
            ),
            "Add accounted time",
        );

        $AccountedTimes[$Position] += $Index;
    }

    # verify accounted time
    $Self->Is(
        $TicketObject->TicketAccountedTimeGet( TicketID => $TicketID ),
        $AccountedTimes[$Position],
        "Ticket accounted time",
    );
    $Position++;
}

my $ArraySize = @TicketIDs;

# merge the first and the last ticket on the array
$Self->True(
    $TicketObject->TicketMerge(
        MainTicketID  => $TicketIDs[0],
        MergeTicketID => $TicketIDs[ $ArraySize - 1 ],
        UserID        => $UserID,
    ),
    'Merge tickets',
);

# verify the accounted time of the main ticket, it should be the sum of both (main and merge tickets)
$Self->Is(
    $TicketObject->TicketAccountedTimeGet( TicketID => $TicketIDs[0] ),
    $AccountedTimes[0] + $AccountedTimes[ $ArraySize - 1 ],
    "Merged ticket accounted time",
);

my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
my $QueueRand   = 'Some::Queue' . $Helper->GetRandomID();
my $NewQueueID  = $QueueObject->QueueAdd(
    Name            => $QueueRand,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    UserID          => $UserID,
    Comment         => 'Some Comment',
);

$Self->True(
    $QueueID,
    "QueueAdd() - $QueueRand, $QueueID",
);

for my $Index ( 1 .. 3 ) {
    $TicketID = $TicketObject->TicketCreate(
        Title        => 'Some Ticket_Title - ticket index accelerator tests',
        QueueID      => $NewQueueID,
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => $UserID,
        UserID       => $UserID,
    );
    $Self->True(
        $TicketID,
        "TicketCreate() - unlock - open - new Queue",
    );

    sleep($Index);
}
%IndexNow = $TicketObject->TicketAcceleratorIndex(
    UserID        => $UserID,
    QueueID       => [ 1, 2, 3, 4, 5, $NewQueueID ],
    ShownQueueIDs => [ 1, 2, 3, 4, 5, $NewQueueID ],
);

$Self->True(
    $IndexNow{MaxAge},
    "TicketAcceleratorIndex() - there is MaxAge",
);

# cleanup is done by RestoreDatabase.

1;
