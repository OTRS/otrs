# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
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

my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

my @ArticleIDs;

my %ArticleTypes = $ArticleObject->ArticleTypeList(
    Result => 'HASH',
);
my @ArticleTypeIDs     = ( sort keys %ArticleTypes )[ 0 .. 4 ];
my %ArticleSenderTypes = $ArticleObject->ArticleSenderTypeList(
    Result => 'HASH',
);
my @SenderTypeIDs = ( sort keys %ArticleSenderTypes )[ 0 .. 1 ];

for my $Number ( 1 .. 15 ) {
    my $ArticleID = $ArticleObject->ArticleCreate(
        TicketID       => $TicketID,
        ArticleTypeID  => $ArticleTypeIDs[ $Number % 5 ],
        SenderTypeID   => $SenderTypeIDs[ $Number % 2 ],
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

my @ArticleBox = $ArticleObject->ArticleContentIndex(
    TicketID          => $TicketID,
    DynamicFieldields => 0,
    UserID            => 1,
);

$Self->Is(
    scalar(@ArticleBox),
    15,
    "ArticleContentIndex by default fetches all articles",
);

@ArticleBox = $ArticleObject->ArticleContentIndex(
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

@ArticleBox = $ArticleObject->ArticleContentIndex(
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
    $ArticleObject->ArticleCount( TicketID => $TicketID ),
    15,
    'ArticleCount',
);

$Self->Is(
    $ArticleObject->ArticlePage(
        TicketID    => $TicketID,
        ArticleID   => $ArticleBox[0]{ArticleID},
        RowsPerPage => 10,
    ),
    2,
    'ArticlePage works',
);

# Test filter
#
@ArticleBox = $ArticleObject->ArticleContentIndex(
    TicketID          => $TicketID,
    DynamicFieldields => 0,
    UserID            => 1,
    ArticleTypeID     => [ @ArticleTypeIDs[ 0, 1 ] ],
);

$Self->Is(
    scalar(@ArticleBox),
    6,
    'Filtering by ArticleTypeID',
);

$Self->Is(
    $ArticleObject->ArticleCount(
        TicketID      => $TicketID,
        ArticleTypeID => [ @ArticleTypeIDs[ 0, 1 ] ],
    ),
    6,
    'ArticleCount is consistent with ArticleContentIndex (ArticleTypeID)',
);

@ArticleBox = $ArticleObject->ArticleContentIndex(
    TicketID            => $TicketID,
    DynamicFieldields   => 0,
    UserID              => 1,
    ArticleSenderTypeID => [ $SenderTypeIDs[0] ],
);

$Self->Is(
    scalar(@ArticleBox),
    7,
    'Filtering by ArticleSenderTypeID',
);

$Self->Is(
    $ArticleObject->ArticleCount(
        TicketID            => $TicketID,
        ArticleSenderTypeID => [ $SenderTypeIDs[0] ],
    ),
    7,
    'ArticleCount is consistent with ArticleContentIndex (ArticleSenderTypeID)',
);

@ArticleBox = $ArticleObject->ArticleContentIndex(
    TicketID            => $TicketID,
    DynamicFieldields   => 0,
    UserID              => 1,
    ArticleSenderTypeID => [ $SenderTypeIDs[0] ],
    Limit               => 4,
    Page                => 2,
);

$Self->Is(
    scalar(@ArticleBox),
    3,
    'Filtering by ArticleSenderTypeID plus pagination',
);

$Self->Is(
    $ArticleObject->ArticlePage(
        TicketID      => $TicketID,
        ArticleID     => $ArticleIDs[13],
        ArticleTypeID => [ $ArticleTypeIDs[ 13 % 5 ] ],
        RowsPerPage   => 2,
    ),
    2,
    'ArticlePage with filtering by ArticleTypeID',
);

# cleanup is done by RestoreDatabase.

1;
