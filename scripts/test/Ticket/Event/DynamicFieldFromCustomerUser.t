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

use Kernel::System::VariableCheck qw(IsHashRefWithData);

use vars (qw($Self));

# Get needed objects.
my $ConfigObject          = $Kernel::OM->Get('Kernel::Config');
my $TicketObject          = $Kernel::OM->Get('Kernel::System::Ticket');
my $DynamicFieldObject    = $Kernel::OM->Get('Kernel::System::DynamicField');
my $CustomerUserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');
my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');

# Get helper object.
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

# Don't check email address validity.
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);
$ConfigObject->Set(
    Key   => 'DynamicFieldFromCustomerUser::Mapping',
    Value => {
        UserLogin           => 'CustomerLogin' . $RandomID,
        UserFirstname       => 'CustomerFirstname' . $RandomID,
        UserLastname        => 'CustomerLastname' . $RandomID,
        CustomerCompanyName => 'CustomerCompanyName' . $RandomID,
        CustomerID          => 'CustomerID' . $RandomID,
    },
);
$ConfigObject->Set(
    Key   => 'Ticket::EventModulePost###950-DynamicFieldFromCustomerUser',
    Value => {
        Module => 'Kernel::System::Ticket::Event::DynamicFieldFromCustomerUser',
        Event  => '(TicketCreate|TicketCustomerUpdate)',
    },
);

# Create the required dynamic fields.
my @DynamicFields = (
    {
        Name       => 'CustomerLogin' . $RandomID,
        Label      => 'CustomerLogin',
        FieldOrder => 9991,
    },
    {
        Name       => 'CustomerFirstname' . $RandomID,
        Label      => 'CustomerFirstname',
        FieldOrder => 9992,
    },
    {
        Name       => 'CustomerLastname' . $RandomID,
        Label      => 'CustomerLastname',
        FieldOrder => 9993,
    },
    {
        Name       => 'CustomerCompanyName' . $RandomID,
        Label      => 'CustomerCompanyName',
        FieldOrder => 9994,
    },
    {
        Name       => 'CustomerID' . $RandomID,
        Label      => 'CustomerID',
        FieldOrder => 9995,
    },
);

my @AddedDynamicFieldNames;
my @AddedDynamicFieldIDs;
for my $DynamicFieldConfig (@DynamicFields) {

    my $ID = $DynamicFieldObject->DynamicFieldAdd(
        %{$DynamicFieldConfig},
        Config => {
            DefaultValue => '',
        },
        FieldType     => 'Text',
        ObjectType    => 'Ticket',
        InternalField => 0,
        Reorder       => 0,
        ValidID       => 1,
        UserID        => 1,
    );

    # Sanity test.
    $Self->IsNot(
        $ID,
        undef,
        "DynamicFieldAdd() for '$DynamicFieldConfig->{Label}' Field ID should be defined",
    );

    # Remember the DynamicFieldName.
    push @AddedDynamicFieldNames, $DynamicFieldConfig->{Name};
    push @AddedDynamicFieldIDs,   $ID;
}

# Create a customer company.
my $TestCustomerID = $CustomerCompanyObject->CustomerCompanyAdd(
    CustomerID             => 'CustomerID' . $RandomID,
    CustomerCompanyName    => 'CustomerCompanyName' . $RandomID,
    CustomerCompanyStreet  => 'Some Street',
    CustomerCompanyZIP     => '12345',
    CustomerCompanyCity    => 'Some city',
    CustomerCompanyCountry => 'USA',
    CustomerCompanyURL     => 'http://example.com',
    CustomerCompanyComment => 'some comment',
    ValidID                => 1,
    UserID                 => 1,
);

# Get customer company data.
my %TestCustomerCompany = $CustomerCompanyObject->CustomerCompanyGet(
    CustomerID => $TestCustomerID,
);

# Create a customer user.
my $TestUserLogin = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => 'UserFirstName' . $RandomID,
    UserLastname   => 'UserLastName' . $RandomID,
    UserCustomerID => $TestCustomerID,
    UserLogin      => 'UserLogin' . $RandomID,
    UserEmail      => 'email' . $RandomID . '@example.com',
    ValidID        => 1,
    UserID         => 1,
);

# Get customer user data.
my %TestUserData = $CustomerUserObject->CustomerUserDataGet(
    User => $TestUserLogin,
);

# Run HistoricalValueGet on all dynamic fields to create a cache.
my $DynamicFieldValueObject = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');
for my $DynamicFieldID (@AddedDynamicFieldIDs) {
    my $HistoricalValues = $DynamicFieldValueObject->HistoricalValueGet(
        FieldID => $DynamicFieldID,
    );
    $Self->True(
        !IsHashRefWithData($HistoricalValues),
        "HistoricalValues for DynamicFieldID $DynamicFieldID are correct before ValueSet."
    );
}

# Create a new ticket with the test user information.
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => $TestUserData{CustomerID},
    CustomerUser => $TestUserLogin,
    OwnerID      => 1,
    UserID       => 1,
);

# At this point the information should be already stored in the dynamic fields
# get ticket data (with DynamicFields).
my %Ticket = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
    UserID        => 1,
    Silent        => 0,
);

# Test actual results with expected ones.
for my $DynamicFieldName (@AddedDynamicFieldNames) {
    $Self->IsNot(
        $Ticket{ 'DynamicField_' . $DynamicFieldName },
        undef,
        "DynamicField $DynamicFieldName for Ticket ID:'$TicketID' should not be undef",
    );
}

$Self->Is(
    $Ticket{ 'DynamicField_CustomerLogin' . $RandomID },
    $TestUserLogin,
    "DynamicField 'CustomerLogin$RandomID' for Ticket ID:'$TicketID' match TestUser Login",
);
$Self->Is(
    $Ticket{ 'DynamicField_CustomerFirstname' . $RandomID },
    $TestUserData{UserFirstname},
    "DynamicField 'CustomerFirstname$RandomID' for Ticket ID:'$TicketID' match TestUser Firstname",
);
$Self->Is(
    $Ticket{ 'DynamicField_CustomerLastname' . $RandomID },
    $TestUserData{UserLastname},
    "DynamicField 'CustomerLastname$RandomID' for Ticket ID:'$TicketID' match TestUser Lastname",
);
$Self->Is(
    $Ticket{ 'DynamicField_CustomerID' . $RandomID },
    $TestCustomerCompany{CustomerID},
    "DynamicField 'CustomerID$RandomID' for Ticket ID:'$TicketID' match TestCompany ID",
);
$Self->Is(
    $Ticket{ 'DynamicField_CustomerCompanyName' . $RandomID },
    $TestCustomerCompany{CustomerCompanyName},
    "DynamicField 'CustomerCompanyName$RandomID' for Ticket ID:'$TicketID' match TestCompany Name",
);

# Run HistoricalValueGet on all dynamic fields again, to check updated values are correct and cache is cleaned on ValueSet.
# See bug#14895 (https://bugs.otrs.org/show_bug.cgi?id=14895) for more details.
for my $DynamicFieldID (@AddedDynamicFieldIDs) {
    my $HistoricalValues = $DynamicFieldValueObject->HistoricalValueGet(
        FieldID => $DynamicFieldID,
    );
    $Self->False(
        !IsHashRefWithData($HistoricalValues),
        "HistoricalValues for DynamicFieldID $DynamicFieldID are correct after ValueSet."
    );
}

# Cleanup is done by RestoreDatabase.

1;
