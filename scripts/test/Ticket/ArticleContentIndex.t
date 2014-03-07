# --
# ArticleContentIndex.t - ticket module testscript
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use utf8;
use vars qw($Self);

use Kernel::System::User;
use Kernel::System::Ticket;

# create local objects
my $UserObject = Kernel::System::User->new(
    %{$Self},
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
);

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some test ticket for ArticleContentIndex',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    'TicketCreate()',
);

my @ArticleIDs;

for my $Number ( 1 .. 15 ) {
    my $ArticleID = $TicketObject->ArticleCreate(
        TicketID       => $TicketID,
        ArticleType    => 'note-internal',
        SenderType     => 'agent',
        From           => 'Some Agent <email@example.com>',
        To             => 'Some Customer <customer-a@example.com>',
        Subject        => "Test article $Number",
        Body           => 'the message text',
        ContentType    => 'text/plain; charset=ISO-8859-1',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify  => 1,
    );
    $Self->True( $ArticleID, "ArticleCreate $Number" );
    push @ArticleIDs, $ArticleID;
}

my @ArticleBox = $TicketObject->ArticleContentIndex(
    TicketID          => $TicketID,
    DynamicFieldields => 0,
    UserID            => 1,
);

$Self->Is(
    scalar(@ArticleBox),
    15,
    "ArticleContentIndex by default fetches all articles",
);

@ArticleBox = $TicketObject->ArticleContentIndex(
    TicketID          => $TicketID,
    DynamicFieldields => 0,
    UserID            => 1,
    Limit             => 10,
);

$Self->Is(
    scalar(@ArticleBox),
    10,
    "ArticleContentIndex with Limit => 10 fetches only 10 articles",
);

$Self->Is(
    $ArticleBox[0]{Subject},
    "Test article 1",
    "First article on first page",
);

@ArticleBox = $TicketObject->ArticleContentIndex(
    TicketID          => $TicketID,
    DynamicFieldields => 0,
    UserID            => 1,
    Page              => 2,
    Limit             => 10,
);

$Self->Is(
    scalar(@ArticleBox),
    5,
    "ArticleContentIndex with Limit => 10, Page => 1 fetches the rest",
);

$Self->Is(
    $ArticleBox[0]{Subject},
    "Test article 11",
    "First article on second page",
);

$Self->Is(
    $TicketObject->ArticleCount( TicketID => $TicketID ),
    15,
    'ArticleCount',
);

# Cleanup
$TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

1;
