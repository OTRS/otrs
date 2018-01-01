# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
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
    Key   => 'Ticket::StorageModule',
    Value => 'Kernel::System::Ticket::ArticleStorageDB',
);

my $UserID = 1;

# ticket index accelerator tests
for my $Module ( 'RuntimeDB', 'StaticDB' ) {

    # get a random id
    my $RandomID = $Helper->GetRandomID();

    # Make sure that the TicketObject gets recreated for each loop.
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );

    $ConfigObject->Set(
        Key   => 'Ticket::IndexModule',
        Value => "Kernel::System::Ticket::IndexAccelerator::$Module",
    );

    # create test ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    $Self->True(
        $TicketObject->isa("Kernel::System::Ticket::IndexAccelerator::$Module"),
        "TicketObject loaded the correct backend",
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
            "$Module TicketCreate() successful for Ticket ID $TicketID",
        );

        # get the Ticket entry
        my %TicketEntry = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 0,
            UserID        => $UserID,
        );

        $Self->True(
            IsHashRefWithData( \%TicketEntry ),
            "$Module TicketGet() successful for Local TicketGet ID $TicketID",
        );

        push @TicketIDs, $TicketID;
    }

    # create articles (ArticleType is 'note-internal' only for first article of first ticket)
    for my $Item ( 0 .. 1 ) {
        for my $SubjectDataItem (qw( Kumbala Acua )) {
            my $ArticleID = $TicketObject->ArticleCreate(
                TicketID       => $TicketIDs[$Item],
                ArticleType    => ( $Item == 0 && $SubjectDataItem eq 'Kumbala' ) ? 'note-internal' : 'note-external',
                SenderType     => 'agent',
                From           => 'Agent Some Agent Some Agent <email@example.com>',
                To             => 'Customer A <customer-a@example.com>',
                Cc             => 'Customer B <customer-b@example.com>',
                ReplyTo        => 'Customer B <customer-b@example.com>',
                Subject        => "$SubjectDataItem$RandomID",
                Body           => 'A text for the body, Title äöüßÄÖÜ€ис',
                ContentType    => 'text/plain; charset=ISO-8859-15',
                HistoryType    => 'OwnerUpdate',
                HistoryComment => 'first article',
                UserID         => 1,
                NoAgentNotify  => 1,
            );
            $Self->True(
                $ArticleID,
                "Article is created - $ArticleID "
            );
        }
    }

    # actual tests
    my @Tests = (
        {
            Name   => 'Agent Interface (Internal/External)',
            Config => {
                Subject => 'Kumbala' . $RandomID,
                UserID  => 1,
            },
            ExpectedResults => [ $TicketIDs[0], $TicketIDs[1] ],
        },
        {
            Name   => 'Customer Interface (Internal/External)',
            Config => {
                Subject        => 'Kumbala' . $RandomID,
                CustomerUserID => 'customerOne@example.com',
            },
            ExpectedResults => [ $TicketIDs[1] ],
            ForBothStorages => 1,
        },
        {
            Name   => 'Customer Interface (External/External)',
            Config => {
                Subject => 'Acua' . $RandomID,
                UserID  => 1,
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

        @FoundTicketIDs = sort { $a <=> $b } @FoundTicketIDs;
        @{ $Test->{ExpectedResults} } = sort { $a <=> $b } @{ $Test->{ExpectedResults} };

        $Self->IsDeeply(
            \@FoundTicketIDs,
            $Test->{ExpectedResults},
            "$Module $Test->{Name} TicketSearch() -"
        );
    }
}

# cleanup is done by RestoreDatabase.

1;
