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

# get ticket object
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

    if ($TicketID) {
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

# Test change time and user ID of main ticket on merge action.
#   See bug#13092 for more information.
$Helper->FixedTimeSet(
    $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime( String => '2017-09-27 10:00:00' ),
);

# Create two more tickets.
undef @TicketIDs;
for my $IDCount ( 1 .. 2 ) {
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
    $Self->True(
        $TicketID,
        "TicketID $TicketID is created"
    );
    push @TicketIDs, $TicketID;
}

# Verify MainTicket and MergeTicket ChangeTime and ChangeBy on creation.
my %MainTicket = $TicketObject->TicketGet(
    TicketID => $TicketIDs[0],
    UserID   => 1,
);
$Self->Is(
    $MainTicket{Changed},
    '2017-09-27 10:00:00',
    'On creation MainTicket ChangeTime correct'
);
$Self->Is(
    $MainTicket{ChangeBy},
    1,
    'On creation MainTicket ChangeBy correct'
);

my %MergeTicket = $TicketObject->TicketGet(
    TicketID => $TicketIDs[1],
    UserID   => 1,
);
$Self->Is(
    $MergeTicket{Changed},
    '2017-09-27 10:00:00',
    'On creation MergeTicket ChangeTime correct'
);
$Self->Is(
    $MergeTicket{ChangeBy},
    1,
    'On creation MergeTicket ChangeBy correct'
);

# Add 5 minutes to fixed time.
$Helper->FixedTimeAddSeconds(300);

# Create user who will perform merge action.
my $TestUserLogin = $Helper->TestUserCreate(
    Groups => ['users'],
);
my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $TestUserLogin,
);
$Self->True(
    $UserID,
    "Test user is created - $TestUserLogin ($UserID)"
);

# Merge two tickets.
my $MergeSuccess = $TicketObject->TicketMerge(
    MainTicketID  => $TicketIDs[0],
    MergeTicketID => $TicketIDs[1],
    UserID        => $UserID,
);
$Self->True(
    $MergeSuccess,
    "Successful merge from TicketID $TicketIDs[1] into TicketID $TicketIDs[0]"
);

# Verify main ticket and merge ticket change time and user ID after merge action.
%MainTicket = $TicketObject->TicketGet(
    TicketID => $TicketIDs[0],
    UserID   => 1,
);
$Self->Is(
    $MainTicket{Changed},
    '2017-09-27 10:05:00',
    'After merge MainTicket ChangeTime correct'
);
$Self->Is(
    $MainTicket{ChangeBy},
    $UserID,
    'After merge MainTicket ChangeBy correct'
);

%MergeTicket = $TicketObject->TicketGet(
    TicketID => $TicketIDs[1],
    UserID   => 1,
);
$Self->Is(
    $MergeTicket{Changed},
    '2017-09-27 10:05:00',
    'After merge MergeTicket ChangeTime correct'
);
$Self->Is(
    $MergeTicket{ChangeBy},
    $UserID,
    'After merge MergeTicket ChangeBy correct'
);

# Cleanup is done by RestoreDatabase.

1;
