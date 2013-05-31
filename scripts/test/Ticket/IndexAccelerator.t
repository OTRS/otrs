# --
# IndexAccelerator.t - ticket module testscript
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use utf8;
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::Ticket;
use Kernel::System::Queue;

# create local objects
my $ConfigObject = Kernel::Config->new();
my $UserObject   = Kernel::System::User->new(
    ConfigObject => $ConfigObject,
    %{$Self},
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $QueueObject = Kernel::System::Queue->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# ticket index accelerator tests
for my $Module ( 'RuntimeDB', 'StaticDB' ) {
    my $QueueID = $QueueObject->QueueLookup( Queue => 'Raw' );
    $ConfigObject->Set(
        Key   => 'Ticket::IndexModule',
        Value => "Kernel::System::Ticket::IndexAccelerator::$Module",
    );
    my $TicketObject = Kernel::System::Ticket->new(
        %{$Self},
        ConfigObject => $ConfigObject,
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
        OwnerID      => 1,
        UserID       => 1,
    );
    push( @TicketIDs, $TicketID );
    $Self->True(
        $TicketID,
        "$Module TicketCreate() - unlock - new",
    );

    my %IndexBefore = $TicketObject->TicketAcceleratorIndex(
        UserID        => 1,
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
        OwnerID      => 1,
        UserID       => 1,
    );
    push( @TicketIDs, $TicketID );
    $Self->True(
        $TicketID,
        "$Module TicketCreate() - unlock - closed successful",
    );
    $TicketID = $TicketObject->TicketCreate(
        Title        => 'Some Ticket_Title - ticket index accelerator tests',
        Queue        => 'Raw',
        Lock         => 'lock',
        Priority     => '3 normal',
        State        => 'closed successful',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    push( @TicketIDs, $TicketID );
    $Self->True(
        $TicketID,
        "$Module TicketCreate() - lock - closed successful",
    );
    $TicketID = $TicketObject->TicketCreate(
        Title        => 'Some Ticket_Title - ticket index accelerator tests',
        Queue        => 'Raw',
        Lock         => 'lock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    push( @TicketIDs, $TicketID );
    $Self->True(
        $TicketID,
        "$Module TicketCreate() - lock - open",
    );
    $TicketID = $TicketObject->TicketCreate(
        Title        => 'Some Ticket_Title - ticket index accelerator tests',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    push( @TicketIDs, $TicketID );
    $Self->True(
        $TicketID,
        "$Module TicketCreate() - unlock - open",
    );

    my %IndexNow = $TicketObject->TicketAcceleratorIndex(
        UserID        => 1,
        QueueID       => [ 1, 2, 3, 4, 5, $QueueID ],
        ShownQueueIDs => [ 1, 2, 3, 4, 5, $QueueID ],
    );
    $Self->Is(
        $IndexBefore{AllTickets}  || 0,
        $IndexNow{AllTickets} - 2 || '',
        "$Module TicketAcceleratorIndex() - AllTickets",
    );
    for my $ItemNow ( @{ $IndexNow{Queues} } ) {
        if ( $ItemNow->{Queue} eq 'Raw' ) {
            for my $ItemBefore ( @{ $IndexBefore{Queues} } ) {
                if ( $ItemBefore->{Queue} eq 'Raw' ) {
                    $Self->Is(
                        $ItemBefore->{Count}  || 0,
                        $ItemNow->{Count} - 1 || '',
                        "$Module TicketAcceleratorIndex() - Count",
                    );
                }
            }
        }
    }
    my $TicketLock = $TicketObject->LockSet(
        Lock               => 'lock',
        TicketID           => $TicketIDs[1],
        SendNoNotification => 1,
        UserID             => 1,
    );
    $Self->True(
        $TicketLock,
        "$Module LockSet()",
    );
    %IndexNow = $TicketObject->TicketAcceleratorIndex(
        UserID        => 1,
        QueueID       => [ 1, 2, 3, 4, 5, $QueueID ],
        ShownQueueIDs => [ 1, 2, 3, 4, 5, $QueueID ],
    );
    $Self->Is(
        $IndexBefore{AllTickets}  || 0,
        $IndexNow{AllTickets} - 2 || '',
        "$Module TicketAcceleratorIndex() - AllTickets",
    );
    for my $ItemNow ( @{ $IndexNow{Queues} } ) {
        if ( $ItemNow->{Queue} eq 'Raw' ) {
            for my $ItemBefore ( @{ $IndexBefore{Queues} } ) {
                if ( $ItemBefore->{Queue} eq 'Raw' ) {
                    $Self->Is(
                        $ItemBefore->{Count}  || 0,
                        $ItemNow->{Count} - 1 || '',
                        "$Module TicketAcceleratorIndex() - Count",
                    );
                }
            }
        }
    }
    $TicketLock = $TicketObject->LockSet(
        Lock               => 'lock',
        TicketID           => $TicketIDs[4],
        SendNoNotification => 1,
        UserID             => 1,
    );
    $Self->True(
        $TicketLock,
        "$Module LockSet()",
    );
    %IndexNow = $TicketObject->TicketAcceleratorIndex(
        UserID        => 1,
        QueueID       => [ 1, 2, 3, 4, 5, $QueueID ],
        ShownQueueIDs => [ 1, 2, 3, 4, 5, $QueueID ],
    );
    $Self->Is(
        $IndexBefore{AllTickets}  || 0,
        $IndexNow{AllTickets} - 2 || '',
        "$Module TicketAcceleratorIndex() - AllTickets",
    );
    for my $ItemNow ( @{ $IndexNow{Queues} } ) {
        if ( $ItemNow->{Queue} eq 'Raw' ) {
            for my $ItemBefore ( @{ $IndexBefore{Queues} } ) {
                if ( $ItemBefore->{Queue} eq 'Raw' ) {
                    $Self->Is(
                        $ItemBefore->{Count} || 0,
                        $ItemNow->{Count}    || '',
                        "$Module TicketAcceleratorIndex() - Count",
                    );
                }
            }
        }
    }
    $TicketLock = $TicketObject->LockSet(
        Lock               => 'unlock',
        TicketID           => $TicketIDs[4],
        SendNoNotification => 1,
        UserID             => 1,
    );
    $Self->True(
        $TicketLock,
        "$Module LockSet()",
    );
    %IndexNow = $TicketObject->TicketAcceleratorIndex(
        UserID        => 1,
        QueueID       => [ 1, 2, 3, 4, 5, $QueueID ],
        ShownQueueIDs => [ 1, 2, 3, 4, 5, $QueueID ],
    );
    $Self->Is(
        $IndexBefore{AllTickets}  || 0,
        $IndexNow{AllTickets} - 2 || '',
        "$Module TicketAcceleratorIndex() - AllTickets",
    );
    for my $ItemNow ( @{ $IndexNow{Queues} } ) {
        if ( $ItemNow->{Queue} eq 'Raw' ) {
            for my $ItemBefore ( @{ $IndexBefore{Queues} } ) {
                if ( $ItemBefore->{Queue} eq 'Raw' ) {
                    $Self->Is(
                        $ItemBefore->{Count}  || 0,
                        $ItemNow->{Count} - 1 || '',
                        "$Module TicketAcceleratorIndex() - Count",
                    );
                }
            }
        }
    }
    my $TicketState = $TicketObject->StateSet(
        State              => 'open',
        TicketID           => $TicketIDs[1],
        SendNoNotification => 1,
        UserID             => 1,
    );
    $Self->True(
        $TicketState,
        "$Module StateSet()",
    );
    $TicketLock = $TicketObject->LockSet(
        Lock               => 'unlock',
        TicketID           => $TicketIDs[1],
        SendNoNotification => 1,
        UserID             => 1,
    );
    $Self->True(
        $TicketLock,
        "$Module LockSet()",
    );
    %IndexNow = $TicketObject->TicketAcceleratorIndex(
        UserID        => 1,
        QueueID       => [ 1, 2, 3, 4, 5, $QueueID ],
        ShownQueueIDs => [ 1, 2, 3, 4, 5, $QueueID ],
    );
    $Self->Is(
        $IndexBefore{AllTickets}  || 0,
        $IndexNow{AllTickets} - 3 || '',
        "$Module TicketAcceleratorIndex() - AllTickets",
    );
    for my $ItemNow ( @{ $IndexNow{Queues} } ) {
        if ( $ItemNow->{Queue} eq 'Raw' ) {
            for my $ItemBefore ( @{ $IndexBefore{Queues} } ) {
                if ( $ItemBefore->{Queue} eq 'Raw' ) {
                    $Self->Is(
                        $ItemBefore->{Count}  || 0,
                        $ItemNow->{Count} - 2 || '',
                        "$Module TicketAcceleratorIndex() - Count",
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

            # generate a random number for the time units
            my $RandomNumber = int( rand(100) ) + 1;

            my $ArticleID = $TicketObject->ArticleCreate(
                TicketID       => $TicketID,
                ArticleType    => 'note-internal',
                SenderType     => 'agent',
                From           => 'Some Agent <email@example.com>',
                To             => 'Some Customer A <customer-a@example.com>',
                Subject        => 'some short description',
                Body           => 'the message text',
                Charset        => 'ISO-8859-15',
                MimeType       => 'text/plain',
                HistoryType    => 'OwnerUpdate',
                HistoryComment => 'Some free text!',
                UserID         => 1,
            );

            # add accounted time
            $Self->True(
                $TicketObject->TicketAccountTime(
                    TicketID  => $TicketID,
                    ArticleID => $ArticleID,
                    TimeUnit  => $RandomNumber,
                    UserID    => 1,
                ),
                "Add accounted time",
            );

            $AccountedTimes[$Position] += $RandomNumber;
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
            UserID        => 1,
        ),
        'Merge tickets',
    );

# verify the accounted time of the main ticket, it should be the sum of both (main and merge tickets)
    $Self->Is(
        $TicketObject->TicketAccountedTimeGet( TicketID => $TicketIDs[0] ),
        $AccountedTimes[0] + $AccountedTimes[ $ArraySize - 1 ],
        "Merged ticket accounted time",
    );

    # delete tickets
    for my $TicketID (@TicketIDs) {
        $Self->True(
            $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            ),
            "$Module TicketDelete()",
        );
    }
}

1;
