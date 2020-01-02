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
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

$Self->Is(
    ref $BackendObject,
    'Kernel::System::DynamicField::Backend',
    'Backend object was created successfully',
);

# create dynamic field properties
my @DynamicFieldProperties = (
    {
        Name       => "DFT1$RandomID",
        FieldOrder => 9991,
        FieldType  => 'Text',
        Config     => {
            DefaultValue => 'Default',
        },
    },
    {
        Name       => "DFT2$RandomID",
        FieldOrder => 9992,
        FieldType  => 'Dropdown',
        Config     => {
            DefaultValue   => 'Default',
            PossibleValues => {
                ticket1_field2 => 'ticket1_field2',
                ticket2_field2 => 'ticket2_field2',
            },
        },
    },
    {
        Name       => "DFT3$RandomID",
        FieldOrder => 9993,
        FieldType  => 'DateTime',
        Config     => {
            DefaultValue => 'Default',
        },
    },
    {
        Name       => "DFT4$RandomID",
        FieldOrder => 9993,
        FieldType  => 'Checkbox',
        Config     => {
            DefaultValue => 'Default',
        },
    },
    {
        Name       => "DFT5$RandomID",
        FieldOrder => 9995,
        FieldType  => 'Multiselect',
        Config     => {
            DefaultValue   => [ 'ticket2_field5', 'ticket4_field5' ],
            PossibleValues => {
                ticket1_field5 => 'ticket1_field51',
                ticket2_field5 => 'ticket2_field52',
                ticket3_field5 => 'ticket2_field53',
                ticket4_field5 => 'ticket2_field54',
                ticket5_field5 => 'ticket2_field55',
            },
        },
    }
);

my @FieldConfig;

# create dynamic fields
for my $DynamicFieldProperties (@DynamicFieldProperties) {
    my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
        %{$DynamicFieldProperties},
        Label      => 'Description',
        ObjectType => 'Ticket',
        ValidID    => 1,
        UserID     => 1,
        Reorder    => 0,
    );

    $Self->True(
        $FieldID,
        'DynamicField is created - $FieldID',
    );

    push @FieldConfig, $DynamicFieldObject->DynamicFieldGet(
        ID => $FieldID,
    );
}

my @TicketData;
for ( 1 .. 2 ) {
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

    $Self->True(
        $TicketID,
        'Ticket is created - $TicketID',
    );

    my %Ticket = $TicketObject->TicketGet(
        TicketID => $TicketID,
    );

    push @TicketData, {
        TicketID     => $TicketID,
        TicketNumber => $Ticket{TicketNumber},
    };
}

# Run initial tests for Empty before assigning values
for my $DynamicField ( @FieldConfig[ 0, 2 ] ) {
    my %TicketIDsSearch = $TicketObject->TicketSearch(
        Result                               => 'HASH',
        Limit                                => 100,
        TicketID                             => $TicketData[0]{TicketID},
        "DynamicField_$DynamicField->{Name}" => {
            Empty => 0,
        },
        UserID     => 1,
        Permission => 'r0',
    );

    $Self->IsDeeply(
        \%TicketIDsSearch,
        {},
        "Search with Empty => 0, dynamic field absent, type $DynamicField->{FieldType}",
    );

    %TicketIDsSearch = $TicketObject->TicketSearch(
        Result                               => 'HASH',
        Limit                                => 100,
        TicketID                             => $TicketData[0]{TicketID},
        "DynamicField_$DynamicField->{Name}" => {
            Empty => 1,
        },
        UserID     => 1,
        Permission => 'r0',
    );

    $Self->IsDeeply(
        \%TicketIDsSearch,
        { $TicketData[0]{TicketID} => $TicketData[0]{TicketNumber} },
        "Search with Empty => 1, dynamic field absent, type $DynamicField->{FieldType}",
    );
}

my @Values = (
    {
        DynamicFieldConfig => $FieldConfig[0],
        ObjectID           => $TicketData[0]{TicketID},
        Value              => 'ticket1_field1',
    },
    {
        DynamicFieldConfig => $FieldConfig[1],
        ObjectID           => $TicketData[0]{TicketID},
        Value              => 'ticket1_field2',
    },
    {
        DynamicFieldConfig => $FieldConfig[2],
        ObjectID           => $TicketData[0]{TicketID},
        Value              => '2001-01-01 01:01:01',
    },
    {
        DynamicFieldConfig => $FieldConfig[3],
        ObjectID           => $TicketData[0]{TicketID},
        Value              => '0',
    },
    {
        DynamicFieldConfig => $FieldConfig[4],
        ObjectID           => $TicketData[0]{TicketID},
        Value              => ['ticket1_field5'],
        UserID             => 1,

    },
    {
        DynamicFieldConfig => $FieldConfig[0],
        ObjectID           => $TicketData[1]{TicketID},
        Value              => 'ticket2_field1',

    },
    {
        DynamicFieldConfig => $FieldConfig[1],
        ObjectID           => $TicketData[1]{TicketID},
        Value              => 'ticket2_field2',
    },
    {
        DynamicFieldConfig => $FieldConfig[2],
        ObjectID           => $TicketData[1]{TicketID},
        Value              => '2011-11-11 11:11:11',
    },
    {
        DynamicFieldConfig => $FieldConfig[3],
        ObjectID           => $TicketData[1]{TicketID},
        Value              => '1',
    },
    {
        DynamicFieldConfig => $FieldConfig[4],
        ObjectID           => $TicketData[1]{TicketID},
        Value              => [
            'ticket1_field5',
            'ticket2_field5',
            'ticket4_field5',
        ],
    },
);

for my $Value (@Values) {
    $BackendObject->ValueSet(
        DynamicFieldConfig => $Value->{DynamicFieldConfig},
        ObjectID           => $Value->{ObjectID},
        Value              => $Value->{Value},
        UserID             => 1,
    );
}

# More tests for Empty
for my $DynamicField ( @FieldConfig[ 0, 2 ] ) {
    my %TicketIDsSearch = $TicketObject->TicketSearch(
        Result                               => 'HASH',
        Limit                                => 100,
        TicketID                             => $TicketData[0]{TicketID},
        "DynamicField_$DynamicField->{Name}" => {
            Empty => 1,
        },
        UserID     => 1,
        Permission => 'r0',
    );

    $Self->IsDeeply(
        \%TicketIDsSearch,
        {},
        "Search with Empty => 1, dynamic field present, type $DynamicField->{FieldType}",
    );

    %TicketIDsSearch = $TicketObject->TicketSearch(
        Result                               => 'HASH',
        Limit                                => 100,
        TicketID                             => $TicketData[0]{TicketID},
        "DynamicField_$DynamicField->{Name}" => {
            Empty => 0,
        },
        UserID     => 1,
        Permission => 'r0',
    );

    $Self->IsDeeply(
        \%TicketIDsSearch,
        { $TicketData[0]{TicketID} => $TicketData[0]{TicketNumber} },
        "Search with Empty => 0, dynamic field present, type $DynamicField->{FieldType}",
    );
}

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
    { $TicketData[0]{TicketID} => $TicketData[0]{TicketNumber} },
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
    { $TicketData[0]{TicketID} => $TicketData[0]{TicketNumber} },
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
    { $TicketData[0]{TicketID} => $TicketData[0]{TicketNumber} },
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
        $TicketData[0]{TicketID} => $TicketData[0]{TicketNumber},
        $TicketData[1]{TicketID} => $TicketData[1]{TicketNumber},
        ,
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
    { $TicketData[0]{TicketID} => $TicketData[0]{TicketNumber} },
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
    { $TicketData[0]{TicketID} => $TicketData[0]{TicketNumber} },
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
    { $TicketData[0]{TicketID} => $TicketData[0]{TicketNumber} },
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
    [ $TicketData[0]{TicketID}, $TicketData[1]{TicketID}, ],
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
    [ $TicketData[1]{TicketID}, $TicketData[0]{TicketID}, ],
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
    [ $TicketData[0]{TicketID}, $TicketData[1]{TicketID}, ],
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
    [ $TicketData[1]{TicketID}, $TicketData[0]{TicketID}, ],
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
    [ $TicketData[0]{TicketID}, $TicketData[1]{TicketID}, ],
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
    [ $TicketData[1]{TicketID}, $TicketData[0]{TicketID}, ],
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
    [ $TicketData[0]{TicketID}, $TicketData[1]{TicketID}, ],
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
    [ $TicketData[1]{TicketID}, $TicketData[0]{TicketID}, ],
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
    [ $TicketData[0]{TicketID}, $TicketData[1]{TicketID}, ],
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
    [ $TicketData[1]{TicketID}, $TicketData[0]{TicketID}, ],
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
    [ $TicketData[0]{TicketID}, $TicketData[1]{TicketID}, ],
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
    [ $TicketData[1]{TicketID}, $TicketData[0]{TicketID}, ],
    'Search for one value, match two tickets',
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
    [ $TicketData[1]{TicketID}, ],
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
    [ $TicketData[1]{TicketID}, ],
    'Search for two values in a same field, match one ticket using an array ',
);

# Check that searching for non-existing dynamic fields is an error
my $Result = $TicketObject->TicketSearch(
    Result                                    => 'COUNT',
    UserID                                    => 1,
    "DynamicField_DFT5_NOSUCHTHING_$RandomID" => {
        Like => [ 'ticket2_field5', 'ticket4_field5' ],
    },
    Permission => 'rw',
);

$Self->IsDeeply(
    $Result,
    undef,
    'Searching for a non-existing dynamic field is an error',
);

# Check that values that only look like a DF search query but are none, are accepted
@TicketResultSearch = $TicketObject->TicketSearch(
    Result                       => 'ARRAY',
    Limit                        => 100,
    Title                        => "Ticket$RandomID",
    "DynamicField_DFT5$RandomID" => {
        Like => 'ticket1_field5',
    },
    "DynamicField_DFT5_NOSUCHTHING_$RandomID" => 'some_statistic_param',
    UserID                                    => 1,
    Permission                                => 'rw',
    SortBy                                    => "DynamicField_DFT1$RandomID",
    OrderBy                                   => 'Down',
);

$Self->IsDeeply(
    \@TicketResultSearch,
    [ $TicketData[1]{TicketID}, $TicketData[0]{TicketID}, ],
    'Searching allows custom unknown fields to be present',
);

# cleanup is done by RestoreDatabase.

1;
