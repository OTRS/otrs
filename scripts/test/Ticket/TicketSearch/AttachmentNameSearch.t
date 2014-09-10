# --
# AttachmentNameSearch.t - TicketSearch test for Attachment Name
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# get a random id
my $RandomID = $HelperObject->GetRandomID();

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

$ConfigObject->Set(
    Key   => 'Ticket::StorageModule',
    Value => 'Kernel::System::Ticket::ArticleStorageDB',
);

# ticket id container
my @TicketIDs;

# create 2 tickets
# create ticket 1
my $TicketID1 = $TicketObject->TicketCreate(
    Title        => $RandomID . 'Ticket One Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465' . $RandomID,
    CustomerUser => 'customerOne@example.com',
    Service      => 'TestService' . $RandomID,
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketID1,
    "TicketCreate() successful for Ticket One ID $TicketID1",
);

# get the Ticket entry
my %TicketEntryOne = $TicketObject->TicketGet(
    TicketID      => $TicketID1,
    DynamicFields => 0,
    UserID        => $Self->{UserID},
);

$Self->True(
    IsHashRefWithData( \%TicketEntryOne ),
    "TicketGet() successful for Local TicketGet One ID $TicketID1",
);

# add ticket id
push @TicketIDs, $TicketID1;

# create ticket 2
my $TicketID2 = $TicketObject->TicketCreate(
    Title        => $RandomID . 'Ticket Two Title ' . $RandomID,
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465' . $RandomID,
    CustomerUser => 'customerOne@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketID2,
    "TicketCreate() successful for Ticket Two ID $TicketID2",
);

# get the Ticket entry
my %TicketEntryTwo = $TicketObject->TicketGet(
    TicketID      => $TicketID2,
    DynamicFields => 0,
    UserID        => $Self->{UserID},
);

$Self->True(
    IsHashRefWithData( \%TicketEntryTwo ),
    "TicketGet() successful for Local TicketGet Two ID $TicketID2",
);

# add ticket id
push @TicketIDs, $TicketID2;

my $TicketCounter = 1;

# create article and attachments
TICKET:
for my $TicketID (@TicketIDs) {

    # create 2 articles per ticket
    ARTICLE:
    for my $ArticleCounter ( 1 .. 2 ) {
        my $ArticleID = $TicketObject->ArticleCreate(
            TicketID       => $TicketID,
            ArticleType    => 'note-external',
            SenderType     => 'agent',
            From           => 'Agent Some Agent Some Agent <email@example.com>',
            To             => 'Customer A <customer-a@example.com>',
            Cc             => 'Customer B <customer-b@example.com>',
            ReplyTo        => 'Customer B <customer-b@example.com>',
            Subject        => 'Ticket' . $TicketCounter . 'Article' . $ArticleCounter . $RandomID,
            Body           => 'A text for the body, Title äöüßÄÖÜ€ис',
            ContentType    => 'text/plain; charset=ISO-8859-15',
            HistoryType    => 'OwnerUpdate',
            HistoryComment => 'first article',
            UserID         => 1,
            NoAgentNotify  => 1,
        );

        next ARTICLE if $ArticleCounter == 1;

        # add attachment only to second article
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.txt";

        my $ContentRef = $MainObject->FileRead(
            Location => $Location,
            Mode     => 'binmode',
            Type     => 'Local',
        );

        my $ArticleWriteAttachment = $TicketObject->ArticleWriteAttachment(
            Content     => ${$ContentRef},
            Filename    => 'StdAttachment-Test1' . $RandomID . '.txt',
            ContentType => 'txt',
            ArticleID   => $ArticleID,
            UserID      => 1,
        );
    }
    $TicketCounter++;
}

# add an internal article
my $ArticleID = $TicketObject->ArticleCreate(
    TicketID       => $TicketID2,
    ArticleType    => 'note-internal',
    SenderType     => 'agent',
    From           => 'Agent Some Agent Some Agent <email@example.com>',
    To             => 'Customer A <customer-a@example.com>',
    Cc             => 'Customer B <customer-b@example.com>',
    ReplyTo        => 'Customer B <customer-b@example.com>',
    Subject        => 'Ticket2Article3' . $RandomID,
    Body           => 'A text for the body, Title äöüßÄÖÜ€ис',
    ContentType    => 'text/plain; charset=ISO-8859-15',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'first article',
    UserID         => 1,
    NoAgentNotify  => 1,
);

# add attachment only to second article
my $Location
    = $ConfigObject->Get('Home') . '/scripts/test/sample/StdAttachment/StdAttachment-Test1.txt';

my $ContentRef = $MainObject->FileRead(
    Location => $Location,
    Mode     => 'binmode',
    Type     => 'Local',
);

my $ArticleWriteAttachment = $TicketObject->ArticleWriteAttachment(
    Content     => ${$ContentRef},
    Filename    => 'StdAttachment-Test1' . $RandomID . '.txt',
    ContentType => 'txt',
    ArticleID   => $ArticleID,
    UserID      => 1,
);

# actual tests
my @Tests = (
    {
        Name   => 'AttachmentName',
        Config => {
            AttachmentName => 'StdAttachment-Test1' . $RandomID . '.txt',
            UserID         => 1,
        },
        ExpectedResults => [ $TicketID1, $TicketID2 ],
        ForBothStorages => 0,
    },
    {
        Name   => 'AttachmentName Ticket1 Article1',
        Config => {
            AttachmentName => 'StdAttachment-Test1' . $RandomID . '.txt',
            Subject        => 'Ticket1Article1' . $RandomID,
            UserID         => 1,
        },
        ExpectedResults => [$TicketID1],
        ForBothStorages => 1,
    },
    {
        Name   => 'AttachmentName Ticket1 Article2',
        Config => {
            AttachmentName => 'StdAttachment-Test1' . $RandomID . '.txt',
            Subject        => 'Ticket1Article2' . $RandomID,
            UserID         => 1,
        },
        ExpectedResults => [$TicketID1],
        ForBothStorages => 1,
    },
    {
        Name   => 'AttachmentName Ticket2 Article1',
        Config => {
            AttachmentName => 'StdAttachment-Test1' . $RandomID . '.txt',
            Subject        => 'Ticket2Article1' . $RandomID,
            UserID         => 1,
        },
        ExpectedResults => [$TicketID2],
        ForBothStorages => 1,
    },
    {
        Name   => 'AttachmentName Ticket2 Article2',
        Config => {
            AttachmentName => 'StdAttachment-Test1' . $RandomID . '.txt',
            Subject        => 'Ticket2Article2' . $RandomID,
            UserID         => 1,
        },
        ExpectedResults => [$TicketID2],
        ForBothStorages => 1,
    },
    {
        Name   => 'AttachmentName Ticket2 Article3',
        Config => {
            AttachmentName => 'StdAttachment-Test1' . $RandomID . '.txt',
            Subject        => 'Ticket2Article3' . $RandomID,
            UserID         => 1,
        },
        ExpectedResults => [$TicketID2],
        ForBothStorages => 1,
    },
    {
        Name   => 'AttachmentName Title Ticket 1',
        Config => {
            AttachmentName => 'StdAttachment-Test1' . $RandomID . '.txt',
            Title          => $RandomID . 'Ticket One Title',
            UserID         => 1,
        },
        ExpectedResults => [$TicketID1],
        ForBothStorages => 1,
    },
    {
        Name   => 'AttachmentName Title (Like) Ticket 1',
        Config => {
            AttachmentName => 'StdAttachment-Test1' . $RandomID . '.txt',
            Title          => $RandomID . '*Title',
            UserID         => 1,
        },
        ExpectedResults => [$TicketID1],
        ForBothStorages => 1,
    },
    {
        Name   => 'AttachmentName (AsCustomer)',
        Config => {
            AttachmentName => 'StdAttachment-Test1' . $RandomID . '.txt',
            CustomerUserID => 'customerOne@example.com',
        },
        ExpectedResults => [ $TicketID1, $TicketID2 ],
        ForBothStorages => 1,
    },
    {
        Name   => 'AttachmentName (AsCustomer) Ticket2 Article2',
        Config => {
            AttachmentName => 'StdAttachment-Test1' . $RandomID . '.txt',
            Subject        => 'Ticket2Article2' . $RandomID,
            CustomerUserID => 'customerOne@example.com',
        },
        ExpectedResults => [$TicketID2],
        ForBothStorages => 1,
    },
    {
        Name   => 'AttachmentName (AsCustomer) Ticket2 Article3',
        Config => {
            AttachmentName => 'StdAttachment-Test1' . $RandomID . '.txt',
            Subject        => 'Ticket2Article3' . $RandomID,
            CustomerUserID => 'customerOne@example.com',
        },
        ExpectedResults => [],
        ForBothStorages => 1,
    },
);

for my $Test (@Tests) {

    # attachment name is not considering for searches using ArticleSotrageFS
    for my $StorageBackend (qw(ArticleStorageDB ArticleStorageFS)) {

        $ConfigObject->Set(
            Key   => 'Ticket::StorageModule',
            Value => "Kernel::System::Ticket::$StorageBackend",
        );

        my @FoundTicketIDs = $TicketObject->TicketSearch(
            Result              => 'ARRAY',
            SortBy              => 'Age',
            OrderBy             => 'Down',
            Limit               => 100,
            ConditionInline     => 0,
            ContentSearchPrefix => '*',
            ContentSearchSuffix => '*',
            FullTextIndex       => 1,
            %{ $Test->{Config} },
        );

        @FoundTicketIDs = sort @FoundTicketIDs;

        if ( $StorageBackend eq 'ArticleStorageDB' || $Test->{ForBothStorages} ) {
            $Self->IsDeeply(
                \@FoundTicketIDs,
                $Test->{ExpectedResults},
                "$Test->{Name} $StorageBackend TicketSearch() -"
            );
        }
        else {
            $Self->IsNotDeeply(
                \@FoundTicketIDs,
                $Test->{ExpectedResults},
                "$Test->{Name} $StorageBackend TicketSearch() -"
            );
        }
    }
}

for my $TicketID (@TicketIDs) {

    # delete the ticket Three
    my $TicketDelete = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );

    # sanity check
    $Self->True(
        $TicketDelete,
        "TicketDelete() successful for Ticket ID $TicketID",
    );
}

1;
