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

# get needed objects
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# create local objects
my $RandomID = $Helper->GetRandomID();

$Self->Is(
    ref $BackendObject,
    'Kernel::System::DynamicField::Backend',
    'Backend object was created successfuly',
);

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

my @DFConfig;
my $DFTicketConfig = $DynamicFieldObject->DynamicFieldGet(
    ID => $FieldID1,
);

push @DFConfig, $DFTicketConfig;

# create a dynamic fields

for my $Item ( 1 .. 2 ) {
    my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
        Name       => "DFTArticle$Item$RandomID",
        Label      => 'Description',
        FieldOrder => 9991,
        FieldType  => 'Text',                       # mandatory, selects the DF backend to use for this field
        ObjectType => 'Article',
        Config     => {
            DefaultValue => 'Default',
        },
        ValidID => 1,
        UserID  => 1,
        Reorder => 0,
    );

    my $DFArticleConfig = $DynamicFieldObject->DynamicFieldGet(
        ID => $DynamicFieldID,
    );

    push @DFConfig, $DFArticleConfig;

}

# Make sure that the TicketObject gets recreated for each loop.
$Kernel::OM->ObjectsDiscard( Objects => [ 'Kernel::System::Ticket', 'Kernel::System::Ticket::Article' ] );

my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Email');

$Self->Is(
    $ArticleObject->{ArticleSearchIndexModule},
    'Kernel::System::Ticket::ArticleSearchIndex::DB',
    "ArticleObject loaded the correct backend",
);

my @TestTicketIDs;
my @TicketIDs;
my @Tickets;

for my $Item ( 0 .. 1 ) {
    my $TicketID = $TicketObject->TicketCreate(
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

    push @TestTicketIDs, $TicketID;
    push @TicketIDs,     $TicketID;

    my %TicketData = $TicketObject->TicketGet(
        TicketID => $TicketID,
    );

    push @Tickets, \%TicketData;
}

$BackendObject->ValueSet(
    DynamicFieldConfig => $DFConfig[0],
    ObjectID           => $TicketIDs[0],
    Value              => 'ticket1_field1',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $DFConfig[0],
    ObjectID           => $TicketIDs[1],
    Value              => 'ticket2_field1',
    UserID             => 1,
);

my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketIDs[0],
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer <customer-a@example.com>',
    Subject              => 'some short description',
    Body                 => 'ticket1_article1',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 1,                                          # if you don't want to send agent notifications
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $DFConfig[1],
    ObjectID           => $ArticleID,
    Value              => 'fieldarticle1_ticket1_article1',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $DFConfig[2],
    ObjectID           => $ArticleID,
    Value              => 'fieldarticle2_ticket1_article1',
    UserID             => 1,
);

$ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketIDs[0],
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer <customer-a@example.com>',
    Subject              => 'some short description',
    Body                 => 'ticket1_article2',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 1,                                          # if you don't want to send agent notifications
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $DFConfig[1],
    ObjectID           => $ArticleID,
    Value              => 'fieldarticle1_ticket1_article2',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $DFConfig[2],
    ObjectID           => $ArticleID,
    Value              => 'fieldarticle2_ticket1_article2',
    UserID             => 1,
);

$ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketIDs[1],
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer <customer-a@example.com>',
    Subject              => 'some short description',
    Body                 => 'ticket2_article1',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 1,                                          # if you don't want to send agent notifications
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $DFConfig[1],
    ObjectID           => $ArticleID,
    Value              => 'fieldarticle1_ticket2_article1',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $DFConfig[2],
    ObjectID           => $ArticleID,
    Value              => 'fieldarticle2_ticket2_article1',
    UserID             => 1,
);

$ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketIDs[1],
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer <customer-a@example.com>',
    Subject              => 'some short description',
    Body                 => 'ticket2_article2',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 1,                                          # if you don't want to send agent notifications
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $DFConfig[1],
    ObjectID           => $ArticleID,
    Value              => 'fieldarticle1_ticket2_article2',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $DFConfig[2],
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
    { $TicketIDs[0] => $Tickets[0]->{TicketNumber} },
    "Search for one article field",
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
    { $TicketIDs[0] => ( $Tickets[0]->{TicketNumber} ) },
    "Search for two article fields in one article",
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
    "Search for two article fields in different articles",
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
        $TicketIDs[0] => ( $Tickets[0]->{TicketNumber} ),
        $TicketIDs[1] => ( $Tickets[1]->{TicketNumber} ),
    },
    "Search for two article fields in different tickets, wildcard",
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
        $TicketIDs[0] => ( $Tickets[0]->{TicketNumber} ),
        $TicketIDs[1] => ( $Tickets[1]->{TicketNumber} ),
    },
    "Search for two article fields in different tickets, hardcoded",
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
    [ $TicketIDs[0], $TicketIDs[1], ],
    "Sort by search field, ASC",
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
    [ $TicketIDs[1], $TicketIDs[0], ],
    "Sort by search field, DESC",
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
    [ $TicketIDs[0], $TicketIDs[1], ],
    "Sort by another field, ASC",
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
    [ $TicketIDs[1], $TicketIDs[0], ],
    "Sort by another field, DESC",
);

for my $TicketID (@TestTicketIDs) {

    # the ticket is no longer needed
    $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
}

# cleanup is done by RestoreDatabase.

1;
