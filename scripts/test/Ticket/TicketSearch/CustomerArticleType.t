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

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

$ConfigObject->Set(
    Key   => 'Ticket::Article::Backend::MIMEBase::ArticleStorage',
    Value => 'Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB',
);

my $UserID = 1;

# get a random id
my $RandomID = $Helper->GetRandomID();

# Make sure that the ticket and article objects get recreated for each loop.
$Kernel::OM->ObjectsDiscard(
    Objects => [
        'Kernel::System::Ticket',
        'Kernel::System::Ticket::Article',
    ],
);

my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel(
    ChannelName => 'Internal',
);

my @TicketIDs;

# create tickets
for my $TitleDataItem ( 'Ticket One Title', 'Ticket Two Title' ) {
    my $TicketID = $TicketObject->TicketCreate(
        Title        => "$TitleDataItem$RandomID",
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
        $TicketID,
        "TicketCreate() successful for Ticket ID $TicketID",
    );

    # get the Ticket entry
    my %TicketEntry = $TicketObject->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 0,
        UserID        => $UserID,
    );

    $Self->True(
        IsHashRefWithData( \%TicketEntry ),
        "TicketGet() successful for Local TicketGet ID $TicketID",
    );

    push @TicketIDs, $TicketID;
}

# Create articles (article not visible for customer only for first article of first ticket).
for my $Item ( 0 .. 1 ) {
    for my $SubjectDataItem (qw( Kumbala Acua )) {
        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketIDs[$Item],
            IsVisibleForCustomer => ( $Item == 0 && $SubjectDataItem eq 'Kumbala' ) ? 1 : 0,
            SenderType           => 'agent',
            From                 => 'Agent Some Agent Some Agent <email@example.com>',
            To                   => 'Customer A <customer-a@example.com>',
            Cc                   => 'Customer B <customer-b@example.com>',
            ReplyTo              => 'Customer B <customer-b@example.com>',
            Subject              => "$SubjectDataItem$RandomID",
            Body                 => 'A text for the body, Title äöüßÄÖÜ€ис',
            ContentType          => 'text/plain; charset=ISO-8859-15',
            HistoryType          => 'OwnerUpdate',
            HistoryComment       => 'first article',
            UserID               => 1,
            NoAgentNotify        => 1,
        );
        $Self->True(
            $ArticleID,
            "Article is created - $ArticleID "
        );

        $ArticleObject->ArticleSearchIndexBuild(
            TicketID  => $TicketIDs[$Item],
            ArticleID => $ArticleID,
            UserID    => 1,
        );
    }
}

# actual tests
my @Tests = (
    {
        Name   => 'Agent Interface (Internal/External)',
        Config => {
            MIMEBase_Subject => 'Kumbala' . $RandomID,
            UserID           => 1,
        },
        ExpectedResults => [ $TicketIDs[0], $TicketIDs[1] ],
    },
    {
        Name   => 'Customer Interface (Internal/External)',
        Config => {
            MIMEBase_Subject => 'Kumbala' . $RandomID,
            CustomerUserID   => 'customerOne@example.com',
        },
        ExpectedResults => [ $TicketIDs[0] ],
        ForBothStorages => 1,
    },
    {
        Name   => 'Customer Interface (External/External)',
        Config => {
            MIMEBase_Subject => 'Acua' . $RandomID,
            UserID           => 1,
        },
        ExpectedResults => [ $TicketIDs[0], $TicketIDs[1] ],
    },
);

for my $Test (@Tests) {

    my @FoundTicketIDs = $TicketObject->TicketSearch(
        Result              => 'ARRAY',
        SortBy              => 'Age',
        OrderBy             => 'Down',
        Limit               => 100,
        UserID              => 1,
        ConditionInline     => 0,
        ContentSearchPrefix => '*',
        ContentSearchSuffix => '*',
        FullTextIndex       => 1,
        %{ $Test->{Config} },
    );

    @FoundTicketIDs = sort { int $a <=> int $b } @FoundTicketIDs;
    @{ $Test->{ExpectedResults} } = sort { int $a <=> int $b } @{ $Test->{ExpectedResults} };

    $Self->IsDeeply(
        \@FoundTicketIDs,
        $Test->{ExpectedResults},
        "$Test->{Name} TicketSearch() -"
    );
}

# cleanup is done by RestoreDatabase.

1;
