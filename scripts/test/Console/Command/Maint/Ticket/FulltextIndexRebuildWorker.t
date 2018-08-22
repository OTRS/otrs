# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Ticket Title ' . $RandomID,
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465' . $RandomID,
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
    "TicketGet() successful for Local TicketGet ID $TicketID."
);

my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 1,
    From                 => 'Agent Some Agent Some Agent <email@example.com>',
    To                   => 'Customer A <customer-a@example.com>',
    Cc                   => 'Customer B <customer-b@example.com>',
    Bcc                  => 'Customer C <customer-c@example.com>',
    ReplyTo              => 'Customer B <customer-b@example.com>',
    Subject              => 'Ticket Article ' . $RandomID,
    Body                 => 'A text for the body, Title äöüßÄÖÜ€ис',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'first article',
    UserID               => 1,
    NoAgentNotify        => 1,
);

$Self->True(
    $ArticleID,
    'Article created.'
);

my $ExitCode = $CommandObject->Execute();

# Check the exit code.
$Self->Is(
    $ExitCode,
    0,
    'Maint::Ticket::FulltextIndexRebuildWorker exit code'
);

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
        Fulltext            => $RandomID,
        UserID              => 1,
    );

    $Self->Is(
        scalar @FoundTicketIDs,
        1,
        "TicketSearch() $StorageBackend - Result count.",
    );

    $Self->Is(
        $FoundTicketIDs[0],
        $TicketID,
        "TicketSearch() $StorageBackend - Found TicketID equal to created TicketID.",
    );
}

my $Success = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $Success,
    "Ticket with id '$TicketID' deleted."
);

# Cleanup cache is done by RestoreDatabase

1;
