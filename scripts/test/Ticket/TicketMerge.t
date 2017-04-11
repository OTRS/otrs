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

my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my @TicketIDs;
my $Limit = 15;

# create some tickets to merge them all
my $TicketCount = 0;
for my $IDCount ( 0 .. $Limit ) {

    # create the ticket
    my $TicketID = $TicketObject->TicketCreate(
        Title        => 'Ticket_' . $IDCount,
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        CustomerNo   => '123456',
        CustomerUser => 'customer@example.com',
        State        => 'new',
        OwnerID      => 1,
        UserID       => 1,
    );
    push @TicketIDs, $TicketID;

    if ( $TicketIDs[$IDCount] ) {
        $TicketCount++;

        # create the article
        $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketIDs[$IDCount],
            SenderType           => 'agent',
            IsVisibleForCustomer => 0,
            From                 => 'Some Agent <email@example.com>',
            To                   => 'Some Customer A <customer-a@example.com>',
            Subject              => 'some short description',
            Body                 => 'the message text',
            Charset              => 'ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'AddNote',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );
    }
}

$Self->Is(
    $TicketCount,
    $Limit + 1,
    'Created ' . $TicketCount . ' Tickets',
);

# merge the tickets
for my $IDCount ( 0 .. $Limit - 1 ) {

    my $ArticleCountOrg = scalar $ArticleObject->ArticleList(
        TicketID => $TicketIDs[$IDCount],
    );
    my $ArticleCountMerge = scalar $ArticleObject->ArticleList(
        TicketID => $TicketIDs[ $IDCount + 1 ],
    );

    # merge
    my $MergeCheck = $TicketObject->TicketMerge(
        MainTicketID  => $TicketIDs[ $IDCount + 1 ],
        MergeTicketID => $TicketIDs[$IDCount],
        UserID        => 1,
    );

    $Self->True(
        $MergeCheck,
        $IDCount . ': Merged Ticket ID ' . $TicketIDs[$IDCount] . ' to ID ' . $TicketIDs[ $IDCount + 1 ],
    );

    my $ArticleCountOrgMerged = scalar $ArticleObject->ArticleList(
        TicketID => $TicketIDs[$IDCount],
    );
    my $ArticleCountMergeMerged = scalar $ArticleObject->ArticleList(
        TicketID => $TicketIDs[ $IDCount + 1 ],
    );

    $Self->Is(
        $ArticleCountMergeMerged,
        $ArticleCountOrg + $ArticleCountMerge,
        $IDCount . ': ArticleCount in MergedTicket is enough.',
    );
    $Self->Is(
        $ArticleCountOrgMerged,
        1,
        $IDCount . ': ArticleCount in OrgTicket is cleaned.',
    );

}

# Check merge depth
my $Count = 0;
for my $TicketID (@TicketIDs) {

    # Get TN from Ticket were MailAnsweres will be added
    # deep merge
    my $TN = $TicketObject->TicketNumberLookup(
        TicketID => $TicketID,
        UserID   => 1,
    );
    my $MergedTicketID = $TicketObject->TicketCheckNumber(
        Tn => $TN,
    );

    # $Limit+1  - because 0..Limit
    # $Limit-10 - because LoopLimit 10
    my $IDLimit = $Limit + 1 - 10;

    if ( $Count < $IDLimit ) {
        $Self->False(
            $MergedTicketID,
            'Limited depth merge target Ticket for ID ' . $TicketID . ' is UNDEF',
        );
    }
    else {
        $Self->Is(
            $MergedTicketID,
            $TicketIDs[$Limit],
            'Unlimited depth merge target Ticket for ID ' . $TicketID . ' is OK',
        );
    }
    $Count++;
}

# create some more tickets for merging linked objects
my @MergeLinkObjectTicketIDs;

for my $TicketCount ( 0 .. 5 ) {

    # create the ticket
    my $TicketID = $TicketObject->TicketCreate(
        Title        => 'Ticket_LinkedObject_Merge_Test' . $TicketCount,
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        CustomerNo   => '123456',
        CustomerUser => 'customer@example.com',
        State        => 'new',
        OwnerID      => 1,
        UserID       => 1,
    );

    push @MergeLinkObjectTicketIDs, $TicketID;
}

my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');

my $LinkType = 'Normal';

# link $MergeLinkObjectTicketIDs[0] with $MergeLinkObjectTicketIDs[1]
my $LinkAddSuccess = $LinkObject->LinkAdd(
    SourceObject => 'Ticket',
    SourceKey    => $MergeLinkObjectTicketIDs[0],
    TargetObject => 'Ticket',
    TargetKey    => $MergeLinkObjectTicketIDs[1],
    Type         => $LinkType,
    State        => 'Valid',
    UserID       => 1,
);

$Self->True(
    $LinkAddSuccess,
    "Link added between TicketID $MergeLinkObjectTicketIDs[0] and TicketID $MergeLinkObjectTicketIDs[1] with LinkType $LinkType.",
);

# link $MergeLinkObjectTicketIDs[0] with $MergeLinkObjectTicketIDs[2]
$LinkAddSuccess = $LinkObject->LinkAdd(
    SourceObject => 'Ticket',
    SourceKey    => $MergeLinkObjectTicketIDs[2],
    TargetObject => 'Ticket',
    TargetKey    => $MergeLinkObjectTicketIDs[0],
    Type         => $LinkType,
    State        => 'Valid',
    UserID       => 1,
);

$Self->True(
    $LinkAddSuccess,
    "Link added between TicketID $MergeLinkObjectTicketIDs[2] and TicketID $MergeLinkObjectTicketIDs[0] with LinkType $LinkType.",
);

$LinkType = 'ParentChild';

# link $MergeLinkObjectTicketIDs[0] with $MergeLinkObjectTicketIDs[3]
$LinkAddSuccess = $LinkObject->LinkAdd(
    SourceObject => 'Ticket',
    SourceKey    => $MergeLinkObjectTicketIDs[0],
    TargetObject => 'Ticket',
    TargetKey    => $MergeLinkObjectTicketIDs[3],
    Type         => $LinkType,
    State        => 'Valid',
    UserID       => 1,
);

$Self->True(
    $LinkAddSuccess,
    "Link added between TicketID $MergeLinkObjectTicketIDs[0] and TicketID $MergeLinkObjectTicketIDs[3] with LinkType $LinkType.",
);

# link $MergeLinkObjectTicketIDs[4] with $MergeLinkObjectTicketIDs[0]
$LinkAddSuccess = $LinkObject->LinkAdd(
    SourceObject => 'Ticket',
    SourceKey    => $MergeLinkObjectTicketIDs[4],
    TargetObject => 'Ticket',
    TargetKey    => $MergeLinkObjectTicketIDs[0],
    Type         => $LinkType,
    State        => 'Valid',
    UserID       => 1,
);

$Self->True(
    $LinkAddSuccess,
    "Link added between TicketID $MergeLinkObjectTicketIDs[4] and TicketID $MergeLinkObjectTicketIDs[0] with LinkType $LinkType.",
);

# merge $MergeLinkObjectTicketIDs[0] into $MergeLinkObjectTicketIDs[5]
my $MergeSuccess = $TicketObject->TicketMerge(
    MainTicketID  => $MergeLinkObjectTicketIDs[5],
    MergeTicketID => $MergeLinkObjectTicketIDs[0],
    UserID        => 1,
);

$Self->True(
    $MergeSuccess,
    "Successfull merge from TicketID $MergeLinkObjectTicketIDs[0] into TicketID $MergeLinkObjectTicketIDs[5].",
);

# get list of linked tickets from original ticket after the merge
my %LinkKeyList = $LinkObject->LinkKeyList(
    Object1 => 'Ticket',
    Key1    => $MergeLinkObjectTicketIDs[0],
    Object2 => 'Ticket',
    State   => 'Valid',
    UserID  => 1,
);

# check that old ticket contains only one link after the merge (to the new ticket)
$Self->Is(
    scalar keys %LinkKeyList,
    1,
    "TicketID $MergeLinkObjectTicketIDs[0] must only contain exactly one link. Number of links:",
);

# check that old ticket is really linked to the new ticket
$Self->True(
    $LinkKeyList{ $MergeLinkObjectTicketIDs[5] },
    "TicketID $MergeLinkObjectTicketIDs[0] is now linked with the new TicketID $MergeLinkObjectTicketIDs[5].",
);

# get list of linked tickets from new ticket after the merge
%LinkKeyList = $LinkObject->LinkKeyList(
    Object1 => 'Ticket',
    Key1    => $MergeLinkObjectTicketIDs[5],
    Object2 => 'Ticket',
    State   => 'Valid',
    UserID  => 1,
);

# check that new ticket contains 5 links after the merge
$Self->Is(
    scalar keys %LinkKeyList,
    5,
    "TicketID $MergeLinkObjectTicketIDs[5] must contain exactly five links. Number of links:",
);

# get the last TicketID (the ID of the new ticket) and remove it from the array
my $NewTicketID = pop @MergeLinkObjectTicketIDs;

for my $TicketID (@MergeLinkObjectTicketIDs) {

    # check that ticket is linked to the new ticket
    $Self->True(
        $LinkKeyList{$TicketID},
        "TicketID $TicketID is now linked with the new TicketID $NewTicketID.",
    );
}

# cleanup is done by RestoreDatabase.

1;
