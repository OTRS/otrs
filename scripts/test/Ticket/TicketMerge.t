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

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

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
        $TicketObject->ArticleCreate(
            TicketID       => $TicketIDs[$IDCount],
            ArticleType    => 'note-internal',
            SenderType     => 'agent',
            From           => 'Some Agent <email@example.com>',
            To             => 'Some Customer A <customer-a@example.com>',
            Subject        => 'some short description',
            Body           => 'the message text',
            Charset        => 'ISO-8859-15',
            MimeType       => 'text/plain',
            HistoryType    => 'AddNote',
            HistoryComment => 'Some free text!',
            UserID         => 1,
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

    my $ArticleCountOrg = $TicketObject->ArticleCount(
        TicketID => $TicketIDs[$IDCount],
    );
    my $ArticleCountMerge = $TicketObject->ArticleCount(
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

    my $ArticleCountOrgMerged = $TicketObject->ArticleCount(
        TicketID => $TicketIDs[$IDCount],
    );
    my $ArticleCountMergeMerged = $TicketObject->ArticleCount(
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

# cleanup is done by RestoreDatabase.

1;
