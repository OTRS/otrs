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

# Test change time and user ID of main ticket on merge action.
#   See bug#13092 for more information.
$Helper->FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2017-09-27 10:00:00',
        },
    )->ToEpoch()
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

# Verify main ticket and merge ticket change time and user ID on creation.
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
my $Language      = 'de';
my $TestUserLogin = $Helper->TestUserCreate(
    Groups   => ['users'],
    Language => $Language,
);
my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $TestUserLogin,
);
$Self->True(
    $UserID,
    "Test user is created - $TestUserLogin ($UserID)"
);

# Merge two tickets.
$MergeSuccess = $TicketObject->TicketMerge(
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

# Check translation of AutomaticMergeText, see more in bug #13967
my @ArticleBoxUpdate = $ArticleObject->ArticleList(
    TicketID => $MergeTicket{TicketID},
);
my $NewMetaArticle = pop @ArticleBoxUpdate;
my %Article        = $ArticleBackendObject->ArticleGet( %{$NewMetaArticle} );

$Kernel::OM->ObjectParamAdd(
    'Kernel::Language' => {
        UserLanguage => $Language,
    },
);
my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

my $Body = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::AutomaticMergeText');
$Body = $LanguageObject->Translate($Body);
$Body =~ s{<OTRS_TICKET>}{$MergeTicket{TicketNumber}}xms;
$Body =~ s{<OTRS_MERGE_TO_TICKET>}{$MainTicket{TicketNumber}}xms;

$Self->Is(
    $Body,
    $Article{Body},
    'Check article body of merged ticket'
);

# Linking objects and linking tickets.
# See bug#12994 (https://bugs.otrs.org/show_bug.cgi?id=12994).
my $RandomID = $Helper->GetRandomID();

undef @TicketIDs;
for my $Item ( 1 .. 6 ) {
    my $TicketID = $TicketObject->TicketCreate(
        Title        => 'Selenium test ',
        Queue        => 'Junk',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    $Self->True(
        $TicketID,
        'TicketCreated',
    );

    push @TicketIDs, $TicketID;
}

my @ItemData = (
    {
        SourceKey => $TicketIDs[0],
        TargetKey => $TicketIDs[2],
    },
    {
        SourceKey => $TicketIDs[1],
        TargetKey => $TicketIDs[2],
    },
    {
        SourceKey => $TicketIDs[0],
        TargetKey => $TicketIDs[5],
    },
    {
        SourceKey => $TicketIDs[1],
        TargetKey => $TicketIDs[5],
    },
    {
        SourceKey => $TicketIDs[0],
        TargetKey => $TicketIDs[3],
    },
    {
        SourceKey => $TicketIDs[1],
        TargetKey => $TicketIDs[4],
    },
);

# Create links between ticket.
for my $Item (@ItemData) {
    my $True = $LinkObject->LinkAdd(
        %{$Item},
        SourceObject => 'Ticket',
        TargetObject => 'Ticket',
        Type         => 'ParentChild',
        State        => 'Valid',
        UserID       => 1,
    );
    $Self->True(
        $True,
        "TicketID $Item->{SourceKey} is linked to $Item->{TargetKey}",
    );
}

# Merging tickets.
my $Success = $TicketObject->TicketMerge(
    MainTicketID  => $TicketIDs[1],
    MergeTicketID => $TicketIDs[0],
    UserID        => 1,
);
$Self->True(
    $Success,
    "TicketID $TicketIDs[0] is successfully merged to TicketID $TicketIDs[1]",
);

# Get list of links merged to ticket.
my $LinkList = $LinkObject->LinkListWithData(
    Object => 'Ticket',
    Key    => $TicketIDs[1],
    State  => 'Valid',
    Type   => 'ParentChild',    # (optional)
    UserID => 1,
);
$Self->True(
    $LinkList->{Ticket}->{ParentChild}->{Target}->{ $TicketIDs[3] },
    "Child TicketID $TicketIDs[3] from parent TicketID $TicketIDs[0] is merged to TicketID $TicketIDs[1]"
);
$Self->True(
    $LinkList->{Ticket}->{ParentChild}->{Target}->{ $TicketIDs[4] },
    "Child TicketID $TicketIDs[4] persevered link with parent TicketID $TicketIDs[1]"
);
$Self->True(
    $LinkList->{Ticket}->{ParentChild}->{Target}->{ $TicketIDs[2] },
    "Mutual child TicketID $TicketIDs[2] is merged to TicketID $TicketIDs[1]"
);

# Cleanup is done by RestoreDatabase.

1;
