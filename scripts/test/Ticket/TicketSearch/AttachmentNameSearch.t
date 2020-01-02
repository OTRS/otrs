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

use Kernel::System::VariableCheck qw(:all);

my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $MainObject           = $Kernel::OM->Get('Kernel::System::Main');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $UserID = 1;

my $RandomID = $Helper->GetRandomID();

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my @TicketIDs;

# Create two test tickets.
for my $Item ( 1 .. 2 ) {
    my $TicketID = $TicketObject->TicketCreate(
        Title => ( $Item == 1 ) ? ( $RandomID . 'Ticket One Title' ) : ( $RandomID . 'Ticket Two Title ' . $RandomID ),
        Queue => 'Raw',
        Lock  => 'unlock',
        Priority     => '3 normal',
        State        => 'new',
        CustomerID   => '123465' . $RandomID,
        CustomerUser => 'customerOne@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    $Self->True(
        $TicketID,
        "TicketCreate() successful for Ticket ID $TicketID"
    );

    # Get the ticket entry.
    my %TicketEntry = $TicketObject->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 0,
        UserID        => $UserID,
    );

    $Self->True(
        IsHashRefWithData( \%TicketEntry ),
        "TicketGet() successful for Local TicketGet ID $TicketID"
    );

    push @TicketIDs, $TicketID;
}

my $TicketCounter = 1;

# Create test articles and attachments.
TICKET:
for my $TicketID (@TicketIDs) {

    # Create two articles per ticket.
    ARTICLE:
    for my $ArticleCounter ( 1 .. 2 ) {
        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'agent',
            IsVisibleForCustomer => 1,
            From                 => 'Agent Some Agent Some Agent <email@example.com>',
            To                   => 'Customer A <customer-a@example.com>',
            Cc                   => 'Customer B <customer-b@example.com>',
            ReplyTo              => 'Customer B <customer-b@example.com>',
            Subject              => 'Ticket' . $TicketCounter . ' Article' . $ArticleCounter . ' ' . $RandomID,
            Body                 => 'A text for the body, Title äöüßÄÖÜ€ис',
            ContentType          => 'text/plain; charset=ISO-8859-15',
            HistoryType          => 'OwnerUpdate',
            HistoryComment       => 'first article',
            UserID               => 1,
            NoAgentNotify        => 1,
        );

        $Self->True(
            $ArticleID,
            'Article created'
        );

        next ARTICLE if $ArticleCounter == 1;

        # Add attachment only to the second article.
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.txt";

        my $ContentRef = $MainObject->FileRead(
            Location => $Location,
            Mode     => 'binmode',
            Type     => 'Local',
        );

        my $ArticleWriteAttachment = $ArticleBackendObject->ArticleWriteAttachment(
            Content     => ${$ContentRef},
            Filename    => $RandomID . '.txt',
            ContentType => 'txt',
            ArticleID   => $ArticleID,
            UserID      => 1,
        );

        $Self->True(
            $ArticleWriteAttachment,
            'Attachment created'
        );

        $ArticleObject->ArticleSearchIndexBuild(
            TicketID  => $TicketID,
            ArticleID => $ArticleID,
            UserID    => 1,
        );
    }
    $TicketCounter++;
}

# Add an internal article to second ticket.
my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketIDs[1],
    SenderType           => 'agent',
    IsVisibleForCustomer => 0,
    From                 => 'Agent Some Agent Some Agent <email@example.com>',
    To                   => 'Customer A <customer-a@example.com>',
    Cc                   => 'Customer B <customer-b@example.com>',
    ReplyTo              => 'Customer B <customer-b@example.com>',
    Subject              => 'Ticket2 Article3 ' . $RandomID,
    Body                 => 'A text for the body, Title äöüßÄÖÜ€ис',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'first article',
    UserID               => 1,
    NoAgentNotify        => 1,
);

$Self->True(
    $ArticleID,
    'Article created'
);

# Add attachment only to the internal article.
my $Location = $ConfigObject->Get('Home') . '/scripts/test/sample/StdAttachment/StdAttachment-Test1.txt';

my $ContentRef = $MainObject->FileRead(
    Location => $Location,
    Mode     => 'binmode',
    Type     => 'Local',
);

my $ArticleWriteAttachment = $ArticleBackendObject->ArticleWriteAttachment(
    Content     => ${$ContentRef},
    Filename    => $RandomID . '.txt',
    ContentType => 'txt',
    ArticleID   => $ArticleID,
    UserID      => 1,
);

$Self->True(
    $ArticleWriteAttachment,
    'Attachment created'
);

$ArticleObject->ArticleSearchIndexBuild(
    TicketID  => $TicketIDs[1],
    ArticleID => $ArticleID,
    UserID    => 1,
);

# Actual tests.
my @Tests = (
    {
        Name   => 'AttachmentName',
        Config => {
            MIMEBase_AttachmentName => $RandomID . '.txt',
            UserID                  => 1,
        },
        ExpectedResultsArticleStorageDB => [ $TicketIDs[0], $TicketIDs[1] ],
        ExpectedResultsArticleStorageFS => [ $TicketIDs[0], $TicketIDs[1] ],
    },
    {
        Name   => 'AttachmentName nonexisting',
        Config => {
            MIMEBase_AttachmentName => 'nonexisting-attachment-name-search.txt',
            UserID                  => 1,
        },
        ExpectedResultsArticleStorageDB => [],
        ExpectedResultsArticleStorageFS => [],    # does not consider attachment name
    },
    {
        Name   => 'AttachmentName Ticket1 Article1',
        Config => {
            MIMEBase_AttachmentName => $RandomID . '.txt',
            MIMEBase_Subject        => 'Ticket1 Article1 ' . $RandomID,
            UserID                  => 1,
        },
        ExpectedResultsArticleStorageDB => [],
        ExpectedResultsArticleStorageFS => [],
    },
    {
        Name   => 'AttachmentName Ticket1 Article2',
        Config => {
            MIMEBase_AttachmentName => $RandomID . '.txt',
            MIMEBase_Subject        => 'Ticket1 Article2 ' . $RandomID,
            UserID                  => 1,
        },
        ExpectedResultsArticleStorageDB => [ $TicketIDs[0] ],
        ExpectedResultsArticleStorageFS => [ $TicketIDs[0] ],
    },
    {
        Name   => 'AttachmentName Ticket2 Article1',
        Config => {
            MIMEBase_AttachmentName => $RandomID . '.txt',
            MIMEBase_Subject        => 'Ticket2 Article1 ' . $RandomID,
            UserID                  => 1,
        },
        ExpectedResultsArticleStorageDB => [],
        ExpectedResultsArticleStorageFS => [],
    },
    {
        Name   => 'AttachmentName Ticket2 Article2',
        Config => {
            MIMEBase_AttachmentName => $RandomID . '.txt',
            MIMEBase_Subject        => 'Ticket2 Article2 ' . $RandomID,
            UserID                  => 1,
        },
        ExpectedResultsArticleStorageDB => [ $TicketIDs[1] ],
        ExpectedResultsArticleStorageFS => [ $TicketIDs[1] ],
    },
    {
        Name   => 'AttachmentName Ticket2 Article3',
        Config => {
            MIMEBase_AttachmentName => $RandomID . '.txt',
            MIMEBase_Subject        => 'Ticket2 Article3 ' . $RandomID,
            UserID                  => 1,
        },
        ExpectedResultsArticleStorageDB => [ $TicketIDs[1] ],
        ExpectedResultsArticleStorageFS => [ $TicketIDs[1] ],
    },
    {
        Name   => 'AttachmentName Title Ticket 1',
        Config => {
            MIMEBase_AttachmentName => $RandomID . '.txt',
            Title                   => $RandomID . 'Ticket One Title',
            UserID                  => 1,
        },
        ExpectedResultsArticleStorageDB => [ $TicketIDs[0] ],
        ExpectedResultsArticleStorageFS => [ $TicketIDs[0] ],
    },
    {
        Name   => 'AttachmentName Title (Like) Ticket 1',
        Config => {
            MIMEBase_AttachmentName => $RandomID . '.txt',
            Title                   => $RandomID . '*Title',
            UserID                  => 1,
        },
        ExpectedResultsArticleStorageDB => [ $TicketIDs[0] ],
        ExpectedResultsArticleStorageFS => [ $TicketIDs[0] ],
    },
    {
        Name   => 'AttachmentName (AsCustomer)',
        Config => {
            MIMEBase_AttachmentName => $RandomID . '.txt',
            CustomerUserID          => 'customerOne@example.com',
        },
        ExpectedResultsArticleStorageDB => [ $TicketIDs[0], $TicketIDs[1] ],
        ExpectedResultsArticleStorageFS => [ $TicketIDs[0], $TicketIDs[1] ],
    },
    {
        Name   => 'AttachmentName (AsCustomer) Ticket2 Article2',
        Config => {
            MIMEBase_AttachmentName => $RandomID . '.txt',
            MIMEBase_Subject        => 'Ticket2 Article2 ' . $RandomID,
            CustomerUserID          => 'customerOne@example.com',
        },
        ExpectedResultsArticleStorageDB => [ $TicketIDs[1] ],
        ExpectedResultsArticleStorageFS => [ $TicketIDs[1] ],
    },
    {
        Name   => 'AttachmentName (AsCustomer) Ticket2 Article3',
        Config => {
            MIMEBase_AttachmentName => $RandomID . '.txt',
            MIMEBase_Subject        => 'Ticket2 Article3 ' . $RandomID,
            CustomerUserID          => 'customerOne@example.com',
        },
        ExpectedResultsArticleStorageDB => [],
        ExpectedResultsArticleStorageFS => [],
    },
);

for my $Test (@Tests) {

    # Attachment name search must work for both ArticleStorageDB and ArticleStorageFS.
    for my $StorageBackend (qw(ArticleStorageDB ArticleStorageFS)) {

        # For the search it is enough to change the config, the TicketObject does not
        #   have to be recreated to use the different base class.
        $ConfigObject->Set(
            Key   => 'Ticket::Article::Backend::MIMEBase:::ArticleStorage',
            Value => "Kernel::System::Ticket::Article::Backend::MIMEBase::$StorageBackend",
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
            TicketID            => \@TicketIDs,
            %{ $Test->{Config} },
            Limit => 2,
        );

        @FoundTicketIDs = sort { int $a <=> int $b } @FoundTicketIDs;
        @{ $Test->{"ExpectedResults$StorageBackend"} }
            = sort { $a <=> $b } @{ $Test->{"ExpectedResults$StorageBackend"} };

        $Self->IsDeeply(
            \@FoundTicketIDs,
            $Test->{"ExpectedResults$StorageBackend"},
            "$Test->{Name} $StorageBackend TicketSearch()"
        );
    }
}

# Cleanup is done by RestoreDatabase.

1;
