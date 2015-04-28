# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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

my $UserID = 1;

# ticket index accelerator tests
for my $Module ( 'RuntimeDB', 'StaticDB' ) {

    # get a random id
    my $RandomID = $HelperObject->GetRandomID();

    # Make sure that the TicketObject gets recreated for each loop.
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    $ConfigObject->Set(
        Key   => 'Ticket::IndexModule',
        Value => "Kernel::System::Ticket::IndexAccelerator::$Module",
    );

    $ConfigObject->Set(
        Key   => 'CheckEmailAddresses',
        Value => 0,
    );

    $ConfigObject->Set(
        Key   => 'Ticket::StorageModule',
        Value => 'Kernel::System::Ticket::ArticleStorageDB',
    );

    # create test ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    $Self->True(
        $TicketObject->isa("Kernel::System::Ticket::IndexAccelerator::$Module"),
        "TicketObject loaded the correct backend",
    );

    # ticket id container
    my @TicketIDs;

    # create 2 tickets
    # create ticket 1
    my $TicketID1 = $TicketObject->TicketCreate(
        Title => 'Ticket One Title' . $RandomID,
        ,
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
        $TicketID1,
        "$Module TicketCreate() successful for Ticket One ID $TicketID1",
    );

    # get the Ticket entry
    my %TicketEntryOne = $TicketObject->TicketGet(
        TicketID      => $TicketID1,
        DynamicFields => 0,
        UserID        => $UserID,
    );

    $Self->True(
        IsHashRefWithData( \%TicketEntryOne ),
        "$Module TicketGet() successful for Local TicketGet One ID $TicketID1",
    );

    # add ticket id
    push @TicketIDs, $TicketID1;

    # create ticket 2
    my $TicketID2 = $TicketObject->TicketCreate(
        Title        => 'Ticket Two Title ' . $RandomID,
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
        "$Module TicketCreate() successful for Ticket Two ID $TicketID2",
    );

    # get the Ticket entry
    my %TicketEntryTwo = $TicketObject->TicketGet(
        TicketID      => $TicketID2,
        DynamicFields => 0,
        UserID        => $UserID,
    );

    $Self->True(
        IsHashRefWithData( \%TicketEntryTwo ),
        "$Module TicketGet() successful for Local TicketGet Two ID $TicketID2",
    );

    # add ticket id
    push @TicketIDs, $TicketID2;

    my $TicketCounter = 1;

    # create article
    my $ArticleID = $TicketObject->ArticleCreate(
        TicketID       => $TicketID1,
        ArticleType    => 'note-internal',
        SenderType     => 'agent',
        From           => 'Agent Some Agent Some Agent <email@example.com>',
        To             => 'Customer A <customer-a@example.com>',
        Cc             => 'Customer B <customer-b@example.com>',
        ReplyTo        => 'Customer B <customer-b@example.com>',
        Subject        => 'Kumbala' . $RandomID,
        Body           => 'A text for the body, Title äöüßÄÖÜ€ис',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'first article',
        UserID         => 1,
        NoAgentNotify  => 1,
    );
    $Self->IsNot(
        $ArticleID,
        undef,
        "$Module ArticleCreate() for $TicketID1 | ArticleID is not undef"
    );

    $ArticleID = $TicketObject->ArticleCreate(
        TicketID       => $TicketID2,
        ArticleType    => 'note-external',
        SenderType     => 'agent',
        From           => 'Agent Some Agent Some Agent <email@example.com>',
        To             => 'Customer A <customer-a@example.com>',
        Cc             => 'Customer B <customer-b@example.com>',
        ReplyTo        => 'Customer B <customer-b@example.com>',
        Subject        => 'Kumbala' . $RandomID,
        Body           => 'A text for the body, Title äöüßÄÖÜ€ис',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'first article',
        UserID         => 1,
        NoAgentNotify  => 1,
    );
    $Self->IsNot(
        $ArticleID,
        undef,
        "$Module ArticleCreate() for $TicketID2 | ArticleID is not undef"
    );

    # create a common article
    for my $TicketID ( $TicketID1, $TicketID2 ) {
        my $ArticleID = $TicketObject->ArticleCreate(
            TicketID       => $TicketID,
            ArticleType    => 'note-external',
            SenderType     => 'agent',
            From           => 'Agent Some Agent Some Agent <email@example.com>',
            To             => 'Customer A <customer-a@example.com>',
            Cc             => 'Customer B <customer-b@example.com>',
            ReplyTo        => 'Customer B <customer-b@example.com>',
            Subject        => 'Acua' . $RandomID,
            Body           => 'A text for the body, Title äöüßÄÖÜ€ис',
            ContentType    => 'text/plain; charset=ISO-8859-15',
            HistoryType    => 'OwnerUpdate',
            HistoryComment => 'first article',
            UserID         => 1,
            NoAgentNotify  => 1,
        );
        $Self->IsNot(
            $ArticleID,
            undef,
            "$Module ArticleCreate() for $TicketID | ArticleID is not undef"
        );
    }

    # actual tests
    my @Tests = (
        {
            Name   => 'Agent Interface (Internal/External)',
            Config => {
                Subject => 'Kumbala' . $RandomID,
                UserID  => 1,
            },
            ExpectedResults => [ $TicketID1, $TicketID2 ],
        },
        {
            Name   => 'Customer Interface (Internal/External)',
            Config => {
                Subject        => 'Kumbala' . $RandomID,
                CustomerUserID => 'customerOne@example.com',
            },
            ExpectedResults => [$TicketID2],
            ForBothStorages => 1,
        },
        {
            Name   => 'Customer Interface (External/External)',
            Config => {
                Subject => 'Acua' . $RandomID,
                UserID  => 1,
            },
            ExpectedResults => [ $TicketID1, $TicketID2 ],
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

        @FoundTicketIDs = sort @FoundTicketIDs;

        $Self->IsDeeply(
            \@FoundTicketIDs,
            $Test->{ExpectedResults},
            "$Module $Test->{Name} TicketSearch() -"
        );
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
            "$Module TicketDelete() successful for Ticket ID $TicketID",
        );
    }
}

1;
