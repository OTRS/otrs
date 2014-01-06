# --
# TicketDynamicFieldSearch.t - ticket module testscript
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: TicketDynamicFieldSearch.t,v 1.7 2011-10-26 22:15:41 cg Exp $
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

my $ConfigObject = Kernel::Config->new();
my $UserObject   = Kernel::System::User->new(
    ConfigObject => $ConfigObject,
    %{$Self},
);
my $DynamicFieldObject = Kernel::System::DynamicField->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# create backend object and delegates
my $BackendObject = Kernel::System::DynamicField::Backend->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
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

push @TestDynamicFields, $FieldID1;

my $Field1Config = $DynamicFieldObject->DynamicFieldGet(
    ID => $FieldID1,
);

# create a dynamic field
my $FieldID2 = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "DFT2$RandomID",
    Label      => 'Description',
    FieldOrder => 9992,
    FieldType  => 'Dropdown',        # mandatory, selects the DF backend to use for this field
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue   => 'Default',
        PossibleValues => {
            ticket1_field2 => 'ticket1_field2',
            ticket2_field2 => 'ticket2_field2',
        },
    },
    ValidID => 1,
    UserID  => 1,
    Reorder => 0,
);

my $Field2Config = $DynamicFieldObject->DynamicFieldGet(
    ID => $FieldID2,
);

push @TestDynamicFields, $FieldID2;

# create a dynamic field
my $FieldID3 = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "DFT3$RandomID",
    Label      => 'Description',
    FieldOrder => 9993,
    FieldType  => 'DateTime',        # mandatory, selects the DF backend to use for this field
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 'Default',
    },
    ValidID => 1,
    UserID  => 1,
    Reorder => 0,
);

my $Field3Config = $DynamicFieldObject->DynamicFieldGet(
    ID => $FieldID3,
);

push @TestDynamicFields, $FieldID3;

# create a dynamic field
my $FieldID4 = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "DFT4$RandomID",
    Label      => 'Description',
    FieldOrder => 9993,
    FieldType  => 'Checkbox',        # mandatory, selects the DF backend to use for this field
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 'Default',
    },
    ValidID => 1,
    UserID  => 1,
    Reorder => 0,
);

my $Field4Config = $DynamicFieldObject->DynamicFieldGet(
    ID => $FieldID4,
);

push @TestDynamicFields, $FieldID4;

# create a dynamic field
my $FieldID5 = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "DFT5$RandomID",
    Label      => 'Description',
    FieldOrder => 9995,
    FieldType  => 'Multiselect',     # mandatory, selects the DF backend to use for this field
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => [ 'ticket2_field5', 'ticket4_field5' ],
        PossibleValues => {
            ticket1_field5 => 'ticket1_field51',
            ticket2_field5 => 'ticket2_field52',
            ticket3_field5 => 'ticket2_field53',
            ticket4_field5 => 'ticket2_field54',
            ticket5_field5 => 'ticket2_field55',
        },
    },
    ValidID => 1,
    UserID  => 1,
    Reorder => 0,
);

my $Field5Config = $DynamicFieldObject->DynamicFieldGet(
    ID => $FieldID5,
);

push @TestDynamicFields, $FieldID5;

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
    DynamicFieldConfig => $Field2Config,
    ObjectID           => $TicketID1,
    Value              => 'ticket1_field2',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $Field3Config,
    ObjectID           => $TicketID1,
    Value              => '2001-01-01 01:01:01',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $Field4Config,
    ObjectID           => $TicketID1,
    Value              => '0',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $Field5Config,
    ObjectID           => $TicketID1,
    Value              => ['ticket1_field5'],
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $Field1Config,
    ObjectID           => $TicketID2,
    Value              => 'ticket2_field1',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $Field2Config,
    ObjectID           => $TicketID2,
    Value              => 'ticket2_field2',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $Field3Config,
    ObjectID           => $TicketID2,
    Value              => '2011-11-11 11:11:11',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $Field4Config,
    ObjectID           => $TicketID2,
    Value              => '1',
    UserID             => 1,
);

$BackendObject->ValueSet(
    DynamicFieldConfig => $Field5Config,
    ObjectID           => $TicketID2,
    Value              => [
        'ticket1_field5',
        'ticket2_field5',
        'ticket4_field5',
    ],
    UserID => 1,
);

my %TicketIDsSearch = $TicketObject->TicketSearch(
    Result                       => 'HASH',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT1$RandomID" => {
        Equals => 'ticket1_field1',
    },
    UserID     => 1,
    Permission => 'rw',
);

$Self->IsDeeply(
    \%TicketIDsSearch,
    { $TicketID1 => $Ticket1{TicketNumber} },
    'Search for one field',
);

%TicketIDsSearch = $TicketObject->TicketSearch(
    Result                       => 'HASH',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT1$RandomID" => {
        Like => 'ticket1_field1',
    },
    UserID     => 1,
    Permission => 'rw',
);

$Self->IsDeeply(
    \%TicketIDsSearch,
    { $TicketID1 => $Ticket1{TicketNumber} },
    'Search for one field',
);

%TicketIDsSearch = $TicketObject->TicketSearch(
    Result                       => 'HASH',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT1$RandomID" => {
        Equals => 'ticket1_field1',
    },
    "DynamicField_DFT2$RandomID" => {
        Equals => 'ticket1_field2',
    },
    UserID     => 1,
    Permission => 'rw',
);

$Self->IsDeeply(
    \%TicketIDsSearch,
    { $TicketID1 => $Ticket1{TicketNumber} },
    'Search for two fields',
);

%TicketIDsSearch = $TicketObject->TicketSearch(
    Result                       => 'HASH',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT1$RandomID" => {
        Equals => 'ticket1_field1_nonexisting',
    },
    "DynamicField_DFT2$RandomID" => {
        Equals => 'ticket1_field2',
    },
    UserID     => 1,
    Permission => 'rw',
);

$Self->IsDeeply(
    \%TicketIDsSearch,
    {},
    'Search for two fields, wrong first value',
);

%TicketIDsSearch = $TicketObject->TicketSearch(
    Result                       => 'HASH',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT1$RandomID" => {
        Equals => 'ticket1_field1',
    },
    "DynamicField_DFT2$RandomID" => {
        Equals => 'ticket1_field2_nonexisting',
    },
    UserID     => 1,
    Permission => 'rw',
);

$Self->IsDeeply(
    \%TicketIDsSearch,
    {},
    'Search for two fields, wrong second value',
);

%TicketIDsSearch = $TicketObject->TicketSearch(
    Result                       => 'HASH',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT1$RandomID" => {
        Like => 'ticket%_field1',
    },
    "DynamicField_DFT2$RandomID" => {
        Like => 'ticket%_field2',
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
    'Search for two fields, match two tickets',
);

%TicketIDsSearch = $TicketObject->TicketSearch(
    Result                       => 'HASH',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT1$RandomID" => {
        Equals => 'ticket1_field1',
    },
    "DynamicField_DFT2$RandomID" => {
        Equals => 'ticket1_field2',
    },
    "DynamicField_DFT3$RandomID" => {
        Equals => '2001-01-01 01:01:01',
    },
    "DynamicField_DFT4$RandomID" => {
        Equals => 0,
    },
    "DynamicField_DFT5$RandomID" => {
        Equals => 'ticket1_field5',
    },
    UserID     => 1,
    Permission => 'rw',
);

$Self->IsDeeply(
    \%TicketIDsSearch,
    { $TicketID1 => $Ticket1{TicketNumber} },
    'Search for five fields',
);

%TicketIDsSearch = $TicketObject->TicketSearch(
    Result                       => 'HASH',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT1$RandomID" => {
        Equals => 'ticket1_field1',
    },
    "DynamicField_DFT2$RandomID" => {
        Equals => 'ticket1_field2',
    },
    "DynamicField_DFT3$RandomID" => {
        GreaterThanEquals => '2001-01-01 01:01:01',
        SmallerThanEquals => '2001-01-01 01:01:01',
    },
    "DynamicField_DFT4$RandomID" => {
        Equals => 0,
    },
    "DynamicField_DFT5$RandomID" => {
        Equals => 'ticket1_field5',
    },
    UserID     => 1,
    Permission => 'rw',
);

$Self->IsDeeply(
    \%TicketIDsSearch,
    { $TicketID1 => $Ticket1{TicketNumber} },
    'Search for five fields, two operators with equals',
);

%TicketIDsSearch = $TicketObject->TicketSearch(
    Result                       => 'HASH',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT1$RandomID" => {
        Equals => 'ticket1_field1',
    },
    "DynamicField_DFT2$RandomID" => {
        Equals => 'ticket1_field2',
    },
    "DynamicField_DFT3$RandomID" => {
        GreaterThan => '2001-01-01 01:01:00',
        SmallerThan => '2001-01-01 01:01:02',
    },
    "DynamicField_DFT4$RandomID" => {
        Equals => 0,
    },
    "DynamicField_DFT5$RandomID" => {
        Equals => 'ticket1_field5',
    },
    UserID     => 1,
    Permission => 'rw',
);

$Self->IsDeeply(
    \%TicketIDsSearch,
    { $TicketID1 => $Ticket1{TicketNumber} },
    'Search for five fields, two operators without equals',
);

%TicketIDsSearch = $TicketObject->TicketSearch(
    Result                       => 'HASH',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT1$RandomID" => {
        Equals => 'ticket1_field1',
    },
    "DynamicField_DFT2$RandomID" => {
        Equals => 'ticket1_field2',
    },
    "DynamicField_DFT3$RandomID" => {
        GreaterThan => '2001-01-01 01:01:01',
        SmallerThan => '2001-01-01 01:01:01',
    },
    "DynamicField_DFT4$RandomID" => {
        Equals => 0,
    },
    "DynamicField_DFT5$RandomID" => {
        Equals => 'ticket1_field5',
    },
    UserID     => 1,
    Permission => 'rw',
);

$Self->IsDeeply(
    \%TicketIDsSearch,
    {},
    'Search for five fields, two operators without equals (no match)',
);

%TicketIDsSearch = $TicketObject->TicketSearch(
    Result                       => 'HASH',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT1$RandomID" => {
        Equals => 'ticket1_field1',
    },
    "DynamicField_DFT2$RandomID" => {
        Equals => 'ticket1_field2',
    },
    "DynamicField_DFT3$RandomID" =>
        {
        Equals => '2002-02-02 01:01:01',
        },
    "DynamicField_DFT4$RandomID" => {
        Equals => 0,
    },
    "DynamicField_DFT5$RandomID" => {
        Equals => 'ticket1_field5',
    },
    UserID     => 1,
    Permission => 'rw',
);

$Self->IsDeeply(
    \%TicketIDsSearch,
    {},
    'Search for five fields, wrong third value',
);

%TicketIDsSearch = $TicketObject->TicketSearch(
    Result                       => 'HASH',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT1$RandomID" => {
        Equals => 'ticket1_field1',
    },
    "DynamicField_DFT2$RandomID" => {
        Equals => 'ticket1_field2',
    },
    "DynamicField_DFT3$RandomID" =>
        {
        Equals => '2001-01-01 01:01:01',
        },
    "DynamicField_DFT4$RandomID" => {
        Equals => 1,
    },
    "DynamicField_DFT5$RandomID" => {
        Equals => 'ticket1_field5',
    },
    UserID     => 1,
    Permission => 'rw',
);

$Self->IsDeeply(
    \%TicketIDsSearch,
    {},
    'Search for five fields, wrong fourth value',
);

%TicketIDsSearch = $TicketObject->TicketSearch(
    Result                       => 'HASH',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT1$RandomID" => {
        Equals => 'ticket1_field1',
    },
    "DynamicField_DFT2$RandomID" => {
        Equals => 'ticket1_field2',
    },
    "DynamicField_DFT3$RandomID" =>
        {
        Equals => '2001-01-01 01:01:01',
        },
    "DynamicField_DFT4$RandomID" => {
        Equals => 1,
    },
    "DynamicField_DFT5$RandomID" => {
        Equals => 'ticket1000_field5',
    },
    UserID     => 1,
    Permission => 'rw',
);

$Self->IsDeeply(
    \%TicketIDsSearch,
    {},
    'Search for five fields, wrong fifth value',
);

my @TicketResultSearch = $TicketObject->TicketSearch(
    Result                       => 'ARRAY',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT1$RandomID" => {
        Like => 'ticket%_field1',
    },
    "DynamicField_DFT2$RandomID" => {
        Like => 'ticket%_field2',
    },
    UserID     => 1,
    Permission => 'rw',
    SortBy     => "DynamicField_DFT1$RandomID",
    OrderBy    => 'Up',
);

$Self->IsDeeply(
    \@TicketResultSearch,
    [ $TicketID1, $TicketID2, ],
    'Search for two fields, match two tickets, sort for search field, ASC',
);

@TicketResultSearch = $TicketObject->TicketSearch(
    Result                       => 'ARRAY',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT1$RandomID" => {
        Like => 'ticket%_field1',
    },
    "DynamicField_DFT2$RandomID" => {
        Like => 'ticket%_field2',
    },
    UserID     => 1,
    Permission => 'rw',
    SortBy     => "DynamicField_DFT1$RandomID",
    OrderBy    => 'Down',
);

$Self->IsDeeply(
    \@TicketResultSearch,
    [ $TicketID2, $TicketID1, ],
    'Search for two fields, match two tickets, sort for search field, DESC',
);

@TicketResultSearch = $TicketObject->TicketSearch(
    Result                       => 'ARRAY',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT2$RandomID" => {
        Like => 'ticket%_field2',
    },
    UserID     => 1,
    Permission => 'rw',
    SortBy     => "DynamicField_DFT1$RandomID",
    OrderBy    => 'Up',
);

$Self->IsDeeply(
    \@TicketResultSearch,
    [ $TicketID1, $TicketID2, ],
    'Search for field, match two tickets, sort for another field, ASC',
);

@TicketResultSearch = $TicketObject->TicketSearch(
    Result                       => 'ARRAY',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT2$RandomID" => {
        Like => 'ticket%_field2',
    },
    UserID     => 1,
    Permission => 'rw',
    SortBy     => "DynamicField_DFT1$RandomID",
    OrderBy    => 'Down',
);

$Self->IsDeeply(
    \@TicketResultSearch,
    [ $TicketID2, $TicketID1, ],
    'Search for field, match two tickets, sort for another field, DESC',
);

@TicketResultSearch = $TicketObject->TicketSearch(
    Result                       => 'ARRAY',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT2$RandomID" => {
        Like => 'ticket%_field2',
    },
    UserID     => 1,
    Permission => 'rw',
    SortBy     => "DynamicField_DFT3$RandomID",
    OrderBy    => 'Up',
);

$Self->IsDeeply(
    \@TicketResultSearch,
    [ $TicketID1, $TicketID2, ],
    'Search for field, match two tickets, sort for date field, ASC',
);

@TicketResultSearch = $TicketObject->TicketSearch(
    Result                       => 'ARRAY',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT2$RandomID" => {
        Like => 'ticket%_field2',
    },
    UserID     => 1,
    Permission => 'rw',
    SortBy     => "DynamicField_DFT3$RandomID",
    OrderBy    => 'Down',
);

$Self->IsDeeply(
    \@TicketResultSearch,
    [ $TicketID2, $TicketID1, ],
    'Search for field, match two tickets, sort for date field, DESC',
);

@TicketResultSearch = $TicketObject->TicketSearch(
    Result                       => 'ARRAY',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT2$RandomID" => {
        Like => 'ticket%_field2',
    },
    UserID     => 1,
    Permission => 'rw',
    SortBy     => "DynamicField_DFT4$RandomID",
    OrderBy    => 'Up',
);

$Self->IsDeeply(
    \@TicketResultSearch,
    [ $TicketID1, $TicketID2, ],
    'Search for field, match two tickets, sort for checkbox field, ASC',
);

@TicketResultSearch = $TicketObject->TicketSearch(
    Result                       => 'ARRAY',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT2$RandomID" => {
        Like => 'ticket%_field2',
    },
    UserID     => 1,
    Permission => 'rw',
    SortBy     => "DynamicField_DFT4$RandomID",
    OrderBy    => 'Down',
);

$Self->IsDeeply(
    \@TicketResultSearch,
    [ $TicketID2, $TicketID1, ],
    'Search for field, match two tickets, sort for checkbox field, DESC',
);

@TicketResultSearch = $TicketObject->TicketSearch(
    Result     => 'ARRAY',
    Limit      => 100,
    Title      => "Ticket$RandomID",
    UserID     => 1,
    Permission => 'rw',
    SortBy     => "DynamicField_DFT4$RandomID",
    OrderBy    => 'Up',
);

$Self->IsDeeply(
    \@TicketResultSearch,
    [ $TicketID1, $TicketID2, ],
    'Search for no field, sort for checkbox field, ASC',
);

@TicketResultSearch = $TicketObject->TicketSearch(
    Result     => 'ARRAY',
    Limit      => 100,
    Title      => "Ticket$RandomID",
    UserID     => 1,
    Permission => 'rw',
    SortBy     => "DynamicField_DFT4$RandomID",
    OrderBy    => 'Down',
);

$Self->IsDeeply(
    \@TicketResultSearch,
    [ $TicketID2, $TicketID1, ],
    'Search for no field, sort for checkbox field, DESC',
);

@TicketResultSearch = $TicketObject->TicketSearch(
    Result                       => 'ARRAY',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT5$RandomID" => {
        Like => 'ticket%_field5',
    },
    UserID     => 1,
    Permission => 'rw',
    SortBy     => "DynamicField_DFT1$RandomID",
    OrderBy    => 'Up',
);

$Self->IsDeeply(
    \@TicketResultSearch,
    [ $TicketID1, $TicketID2, ],
    'Search for field, match two tickets, sort for text field, ASC',
);

@TicketResultSearch = $TicketObject->TicketSearch(
    Result                       => 'ARRAY',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT5$RandomID" => {
        Like => 'ticket1_field5',
    },
    UserID     => 1,
    Permission => 'rw',
    SortBy     => "DynamicField_DFT1$RandomID",
    OrderBy    => 'Down',
);

$Self->IsDeeply(
    \@TicketResultSearch,
    [ $TicketID2, $TicketID1, ],
    'Search for one value, match two ticket',
);

@TicketResultSearch = $TicketObject->TicketSearch(
    Result                       => 'ARRAY',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT5$RandomID" => {
        Like => 'ticket2_field5',
        Like => 'ticket4_field5',
    },
    UserID     => 1,
    Permission => 'rw',
    SortBy     => "DynamicField_DFT1$RandomID",
    OrderBy    => 'Down',
);

$Self->IsDeeply(
    \@TicketResultSearch,
    [ $TicketID2, ],
    'Search for two values in a same field, match one ticket using two operators',
);

@TicketResultSearch = $TicketObject->TicketSearch(
    Result                       => 'ARRAY',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT5$RandomID" => {
        Like => [ 'ticket2_field5', 'ticket4_field5' ],
    },
    UserID     => 1,
    Permission => 'rw',
    SortBy     => "DynamicField_DFT1$RandomID",
    OrderBy    => 'Down',
);

$Self->IsDeeply(
    \@TicketResultSearch,
    [ $TicketID2, ],
    'Search for two values in a same field, match one ticket using an array ',
);

for my $TicketID (@TestTicketIDs) {

    # the ticket is no longer needed
    $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
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
