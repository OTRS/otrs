# --
# ArticleDynamicFieldSearch.t - ticket module testscript
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

use Kernel::Config;
use Kernel::System::Ticket;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;

# create local objects
my $RandomID = int rand 1_000_000_000;

my $ConfigObject = $Kernel::OM->Get('ConfigObject');
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
$Self->Is(
    ref $BackendObject,
    'Kernel::System::DynamicField::Backend',
    'Backend object was created successfuly',
);

my @TestDynamicFields;

# create a dynamic field
my $FieldID1 = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "DFT1$RandomID",
    Label      => 'Description',
    FieldOrder => 9991,
    FieldType  => 'Text',            # mandatory, selects the DF backend to use for this field
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 'Default',
    },
    ValidID => 1,
    UserID  => 1,
    Reorder => 0,
);

my $Field1Config = $DynamicFieldObject->DynamicFieldGet(
    ID => $FieldID1,
);

push @TestDynamicFields, $FieldID1;

# create a dynamic field
my $FieldIDArticle1 = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "DFTArticle1$RandomID",
    Label      => 'Description',
    FieldOrder => 9991,
    FieldType  => 'Text',                  # mandatory, selects the DF backend to use for this field
    ObjectType => 'Article',
    Config     => {
        DefaultValue => 'Default',
    },
    ValidID => 1,
    UserID  => 1,
    Reorder => 0,
);

my $FieldArticle1Config = $DynamicFieldObject->DynamicFieldGet(
    ID => $FieldIDArticle1,
);

push @TestDynamicFields, $FieldIDArticle1;

# create a dynamic field
my $FieldIDArticle2 = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "DFTArticle2$RandomID",
    Label      => 'Description',
    FieldOrder => 9991,
    FieldType  => 'Text',                  # mandatory, selects the DF backend to use for this field
    ObjectType => 'Article',
    Config     => {
        DefaultValue => 'Default',
    },
    ValidID => 1,
    UserID  => 1,
    Reorder => 0,
);

my $FieldArticle2Config = $DynamicFieldObject->DynamicFieldGet(
    ID => $FieldIDArticle2,
);

push @TestDynamicFields, $FieldIDArticle2;

# tests for article search index modules
for my $Module (qw(StaticDB RuntimeDB)) {

    # Make sure that the TicketObject gets recreated for each loop.
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );

    $ConfigObject->Set(
        Key   => 'Ticket::SearchIndexModule',
        Value => 'Kernel::System::Ticket::ArticleSearchIndex::' . $Module,
    );

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    $Self->True(
        $TicketObject->isa('Kernel::System::Ticket::ArticleSearchIndex::' . $Module),
        "TicketObject loaded the correct backend",
    );

    my @TestTicketIDs;

    my $TicketID1 = $TicketObject->TicketCreate(
        Title        => "Ticket$RandomID",
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'closed successful',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );

    push @TestTicketIDs, $TicketID1;

    my %Ticket1 = $TicketObject->TicketGet(
        TicketID => $TicketID1,
    );

    my $TicketID2 = $TicketObject->TicketCreate(
        Title        => "Ticket$RandomID",
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'closed successful',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => 1,
        UserID       => 1,
    );

    push @TestTicketIDs, $TicketID2;

    my %Ticket2 = $TicketObject->TicketGet(
        TicketID => $TicketID2,
    );

    $BackendObject->ValueSet(
        DynamicFieldConfig => $Field1Config,
        ObjectID           => $TicketID1,
        Value              => 'ticket1_field1',
        UserID             => 1,
    );

    $BackendObject->ValueSet(
        DynamicFieldConfig => $Field1Config,
        ObjectID           => $TicketID2,
        Value              => 'ticket2_field1',
        UserID             => 1,
    );

    my $ArticleID = $TicketObject->ArticleCreate(
        TicketID       => $TicketID1,
        ArticleType    => 'note-internal',
        SenderType     => 'agent',
        From           => 'Some Agent <email@example.com>',
        To             => 'Some Customer <customer-a@example.com>',
        Subject        => 'some short description',
        Body           => 'ticket1_article1',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify => 1,    # if you don't want to send agent notifications
    );

    $BackendObject->ValueSet(
        DynamicFieldConfig => $FieldArticle1Config,
        ObjectID           => $ArticleID,
        Value              => 'fieldarticle1_ticket1_article1',
        UserID             => 1,
    );

    $BackendObject->ValueSet(
        DynamicFieldConfig => $FieldArticle2Config,
        ObjectID           => $ArticleID,
        Value              => 'fieldarticle2_ticket1_article1',
        UserID             => 1,
    );

    $ArticleID = $TicketObject->ArticleCreate(
        TicketID       => $TicketID1,
        ArticleType    => 'note-internal',
        SenderType     => 'agent',
        From           => 'Some Agent <email@example.com>',
        To             => 'Some Customer <customer-a@example.com>',
        Subject        => 'some short description',
        Body           => 'ticket1_article2',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify => 1,    # if you don't want to send agent notifications
    );

    $BackendObject->ValueSet(
        DynamicFieldConfig => $FieldArticle1Config,
        ObjectID           => $ArticleID,
        Value              => 'fieldarticle1_ticket1_article2',
        UserID             => 1,
    );

    $BackendObject->ValueSet(
        DynamicFieldConfig => $FieldArticle2Config,
        ObjectID           => $ArticleID,
        Value              => 'fieldarticle2_ticket1_article2',
        UserID             => 1,
    );

    $ArticleID = $TicketObject->ArticleCreate(
        TicketID       => $TicketID2,
        ArticleType    => 'note-internal',
        SenderType     => 'agent',
        From           => 'Some Agent <email@example.com>',
        To             => 'Some Customer <customer-a@example.com>',
        Subject        => 'some short description',
        Body           => 'ticket2_article1',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify => 1,    # if you don't want to send agent notifications
    );

    $BackendObject->ValueSet(
        DynamicFieldConfig => $FieldArticle1Config,
        ObjectID           => $ArticleID,
        Value              => 'fieldarticle1_ticket2_article1',
        UserID             => 1,
    );

    $BackendObject->ValueSet(
        DynamicFieldConfig => $FieldArticle2Config,
        ObjectID           => $ArticleID,
        Value              => 'fieldarticle2_ticket2_article1',
        UserID             => 1,
    );

    $ArticleID = $TicketObject->ArticleCreate(
        TicketID       => $TicketID2,
        ArticleType    => 'note-internal',
        SenderType     => 'agent',
        From           => 'Some Agent <email@example.com>',
        To             => 'Some Customer <customer-a@example.com>',
        Subject        => 'some short description',
        Body           => 'ticket2_article2',
        ContentType    => 'text/plain; charset=ISO-8859-15',
        HistoryType    => 'OwnerUpdate',
        HistoryComment => 'Some free text!',
        UserID         => 1,
        NoAgentNotify => 1,    # if you don't want to send agent notifications
    );

    $BackendObject->ValueSet(
        DynamicFieldConfig => $FieldArticle1Config,
        ObjectID           => $ArticleID,
        Value              => 'fieldarticle1_ticket2_article2',
        UserID             => 1,
    );

    $BackendObject->ValueSet(
        DynamicFieldConfig => $FieldArticle2Config,
        ObjectID           => $ArticleID,
        Value              => 'fieldarticle2_ticket2_article2',
        UserID             => 1,
    );

    my %TicketIDsSearch = $TicketObject->TicketSearch(
        Result                              => 'HASH',
        Limit                               => 100,
        Title                               => "Ticket$RandomID",
        "DynamicField_DFTArticle1$RandomID" => {
            Equals => 'fieldarticle1_ticket1_article1',
        },
        UserID     => 1,
        Permission => 'rw',
    );

    $Self->IsDeeply(
        \%TicketIDsSearch,
        { $TicketID1 => $Ticket1{TicketNumber} },
        "$Module - Search for one article field",
    );

    %TicketIDsSearch = $TicketObject->TicketSearch(
        Result                              => 'HASH',
        Limit                               => 100,
        Title                               => "Ticket$RandomID",
        "DynamicField_DFTArticle1$RandomID" => {
            Equals => 'fieldarticle1_ticket1_article1',
        },
        "DynamicField_DFTArticle2$RandomID" => {
            Equals => 'fieldarticle2_ticket1_article1',
        },
        UserID     => 1,
        Permission => 'rw',
    );

    $Self->IsDeeply(
        \%TicketIDsSearch,
        { $TicketID1 => $Ticket1{TicketNumber} },
        "$Module - Search for two article fields in one article",
    );

    %TicketIDsSearch = $TicketObject->TicketSearch(
        Result                              => 'HASH',
        Limit                               => 100,
        Title                               => "Ticket$RandomID",
        "DynamicField_DFTArticle1$RandomID" => {
            Equals => 'fieldarticle1_ticket1_article1',
        },
        "DynamicField_DFTArticle2$RandomID" => {
            Equals => 'fieldarticle2_ticket1_article2',
        },
        UserID     => 1,
        Permission => 'rw',
    );

    $Self->IsDeeply(
        \%TicketIDsSearch,
        {},
        "$Module - Search for two article fields in different articles",
    );

    %TicketIDsSearch = $TicketObject->TicketSearch(
        Result                              => 'HASH',
        Limit                               => 100,
        Title                               => "Ticket$RandomID",
        "DynamicField_DFTArticle1$RandomID" => {
            Like => 'fieldarticle1_ticket*_article1',
        },
        "DynamicField_DFTArticle2$RandomID" => {
            Like => 'fieldarticle2_ticket*_article1',
        },
        UserID     => 1,
        Permission => 'rw',
    );

    $Self->IsDeeply(
        \%TicketIDsSearch,
        {
            $TicketID1 => $Ticket1{TicketNumber},
            $TicketID2 => $Ticket2{TicketNumber},
        },
        "$Module - Search for two article fields in different tickets, wildcard",
    );

    %TicketIDsSearch = $TicketObject->TicketSearch(
        Result                              => 'HASH',
        Limit                               => 100,
        Title                               => "Ticket$RandomID",
        "DynamicField_DFTArticle1$RandomID" => {
            Equals => [ 'fieldarticle1_ticket1_article1', 'fieldarticle1_ticket2_article1' ]
        },
        "DynamicField_DFTArticle2$RandomID" => {
            Equals => [ 'fieldarticle2_ticket1_article1', 'fieldarticle2_ticket2_article1' ]
        },
        UserID     => 1,
        Permission => 'rw',
    );

    $Self->IsDeeply(
        \%TicketIDsSearch,
        {
            $TicketID1 => $Ticket1{TicketNumber},
            $TicketID2 => $Ticket2{TicketNumber},
        },
        "$Module - Search for two article fields in different tickets, hardcoded",
    );

    my @TicketIDsSearch = $TicketObject->TicketSearch(
        Result                              => 'ARRAY',
        Limit                               => 100,
        Title                               => "Ticket$RandomID",
        "DynamicField_DFTArticle1$RandomID" => {
            Equals => [ 'fieldarticle1_ticket1_article1', 'fieldarticle1_ticket2_article1' ]
        },
        "DynamicField_DFTArticle2$RandomID" => {
            Equals => [ 'fieldarticle2_ticket1_article1', 'fieldarticle2_ticket2_article1' ]
        },
        SortBy     => "DynamicField_DFTArticle2$RandomID",
        OrderBy    => 'Up',
        UserID     => 1,
        Permission => 'rw',
    );

    $Self->IsDeeply(
        \@TicketIDsSearch,
        [ $TicketID1, $TicketID2, ],
        "$Module - Sort by search field, ASC",
    );

    @TicketIDsSearch = $TicketObject->TicketSearch(
        Result                              => 'ARRAY',
        Limit                               => 100,
        Title                               => "Ticket$RandomID",
        "DynamicField_DFTArticle1$RandomID" => {
            Equals => [ 'fieldarticle1_ticket1_article1', 'fieldarticle1_ticket2_article1' ]
        },
        "DynamicField_DFTArticle2$RandomID" => {
            Equals => [ 'fieldarticle2_ticket1_article1', 'fieldarticle2_ticket2_article1' ]
        },
        SortBy     => "DynamicField_DFTArticle2$RandomID",
        OrderBy    => 'Down',
        UserID     => 1,
        Permission => 'rw',
    );

    $Self->IsDeeply(
        \@TicketIDsSearch,
        [ $TicketID2, $TicketID1, ],
        "$Module - Sort by search field, DESC",
    );

    @TicketIDsSearch = $TicketObject->TicketSearch(
        Result                              => 'ARRAY',
        Limit                               => 100,
        Title                               => "Ticket$RandomID",
        "DynamicField_DFTArticle1$RandomID" => {
            Equals => [ 'fieldarticle1_ticket1_article1', 'fieldarticle1_ticket2_article1' ]
        },
        SortBy     => "DynamicField_DFTArticle2$RandomID",
        OrderBy    => 'Up',
        UserID     => 1,
        Permission => 'rw',
    );

    $Self->IsDeeply(
        \@TicketIDsSearch,
        [ $TicketID1, $TicketID2, ],
        "$Module - Sort by another field, ASC",
    );

    @TicketIDsSearch = $TicketObject->TicketSearch(
        Result                              => 'ARRAY',
        Limit                               => 100,
        Title                               => "Ticket$RandomID",
        "DynamicField_DFTArticle1$RandomID" => {
            Equals => [ 'fieldarticle1_ticket1_article1', 'fieldarticle1_ticket2_article1' ]
        },
        SortBy     => "DynamicField_DFTArticle2$RandomID",
        OrderBy    => 'Down',
        UserID     => 1,
        Permission => 'rw',
    );

    $Self->IsDeeply(
        \@TicketIDsSearch,
        [ $TicketID2, $TicketID1, ],
        "$Module - Sort by another field, DESC",
    );

    for my $TicketID (@TestTicketIDs) {

        # the ticket is no longer needed
        $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
    }
}

for my $FieldID (@TestDynamicFields) {

    # delete the dynamic field
    $DynamicFieldObject->DynamicFieldDelete(
        ID      => $FieldID,
        UserID  => 1,
        Reorder => 0,
    );
}

1;
