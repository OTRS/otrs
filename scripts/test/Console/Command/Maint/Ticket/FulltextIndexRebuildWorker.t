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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        UseTmpArticleDir => 1,
    },
);

use Kernel::System::VariableCheck qw(:all);

my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Ticket::FulltextIndexRebuildWorker');

my $RandomID = $Helper->GetRandomID();

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);
$Helper->ConfigSettingChange(
    Valid => 0,
    Key   => 'Ticket::EventModulePost###1000-IndexManagement',
    Value => {},
);

my %ArticleTemplate = (
    From    => 'Agent Some Agent Some Agent <email@example.com>',
    To      => 'Customer A <customer-a@example.com>',
    Cc      => 'Customer B <customer-b@example.com>',
    Bcc     => 'Customer C <customer-c@example.com>',
    Subject => 'Ticket Article ',
    Body    => 'Text Body Title äöüßÄÖÜ€ис',
);

my @Tickets;

for my $Counter ( 0 .. 9 ) {

    my $TicketID = $TicketObject->TicketCreate(
        Title        => 'Ticket Title ',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'new',
        CustomerID   => '123465',
        CustomerUser => 'customerOne@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );
    $Self->True(
        $TicketID,
        "TicketCreate() successful for Ticket ID $TicketID."
    );

    my %TicketEntry = $TicketObject->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 0,
        UserID        => 1,
    );

    $Self->True(
        IsHashRefWithData( \%TicketEntry ),
        "TicketGet() successful for Ticket ID $TicketID."
    );

    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        %ArticleTemplate,
        TicketID             => $TicketID,
        SenderType           => 'agent',
        IsVisibleForCustomer => 1,
        ReplyTo              => 'Customer B <customer-b@example.com>',
        Subject              => 'Ticket Article ' . $RandomID . $Counter,
        ContentType          => 'text/plain; charset=ISO-8859-15',
        HistoryType          => 'OwnerUpdate',
        HistoryComment       => 'first article',
        UserID               => 1,
        NoAgentNotify        => 1,
    );

    $Self->True(
        $ArticleID,
        "ArticleCreate() successful for Article ID $ArticleID."
    );

    push @Tickets, {
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    };
}

# Set all articles to be re-indexed
$Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleSearchIndexRebuildFlagSet(
    All   => 1,
    Value => 1,
);

# Empty the search index. This is needed as article only have a flag to be re-indexed
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
return if !$DBObject->Do(
    SQL => 'DELETE FROM article_search_index',
);

# Remove DB object to make sure it does not interfere with the console command.
$Kernel::OM->ObjectsDiscard(
    Objects => [
        'Kernel::System::DB',
    ],
    ForcePackageReload => 0,
);

my $ExitCode = $CommandObject->Execute();

# Check the exit code.
$Self->Is(
    $ExitCode,
    0,
    'Maint::Ticket::FulltextIndexRebuildWorker exit code'
);

# Create DBObject again as we remove it before
$DBObject = $Kernel::OM->Get('Kernel::System::DB');

for my $Counter ( 0 .. 9 ) {

    for my $ArticleKey (qw( MIMEBase_From MIMEBase_To MIMEBase_Cc MIMEBase_Bcc MIMEBase_Subject MIMEBase_Body)) {

        # Check that the article search index table has been populated
        return if !$DBObject->Prepare(
            SQL => '
                SELECT article_value FROM article_search_index
                WHERE
                    ticket_id = ?
                    AND article_id = ?
                    AND article_key = ?
              ORDER BY ticket_id DESC',
            Bind => [
                \$Tickets[$Counter]->{TicketID},
                \$Tickets[$Counter]->{ArticleID},
                \$ArticleKey,
            ],
        );

        my $Value;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Value = $Row[0];
        }

        my $TemplateKey = $ArticleKey;
        $TemplateKey =~ s{MIMEBase_}{};

        my $ExpectedValue = lc $ArticleTemplate{$TemplateKey};
        if ( $TemplateKey eq 'Subject' ) {
            $ExpectedValue = lc 'Ticket Article ' . $RandomID . $Counter;
        }

        $Self->Is(
            $Value,
            $ExpectedValue,
            "ArticleSeachIndex for Article $Tickets[$Counter]->{ArticleID} $ArticleKey value"
        );
    }

    for my $StorageBackend (qw(ArticleStorageDB ArticleStorageFS)) {

        # For the search it is enough to change the config, the TicketObject does not
        #   have to be recreated to use the different base class.
        $ConfigObject->Set(
            Key   => 'Ticket::Article::Backend::MIMEBase::ArticleStorage',
            Value => "Kernel::System::Ticket::Article::Backend::MIMEBase::$StorageBackend",
        );

        my @FoundTicketIDs = $TicketObject->TicketSearch(
            Result              => 'ARRAY',
            Limit               => 1,
            ConditionInline     => 0,
            ContentSearchPrefix => '*',
            ContentSearchSuffix => '*',
            FullTextIndex       => 1,
            Fulltext            => $RandomID . $Counter,
            UserID              => 1,
        );

        $Self->Is(
            scalar @FoundTicketIDs,
            1,
            "TicketSearch() $StorageBackend - Result count.",
        );

        $Self->Is(
            $FoundTicketIDs[0],
            $Tickets[$Counter]->{TicketID},
            "TicketSearch() $StorageBackend - Found TicketID equal to created TicketID.",
        );
    }
}

for my $Ticket (@Tickets) {

    my $TicketID = $Ticket->{TicketID};
    my $Success  = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );

    $Self->True(
        $Success,
        "Ticket with id '$TicketID' deleted."
    );
}

# Cleanup cache is done by RestoreDatabase

1;
