# --
# DynamicFieldFromCustomerUser.t - DynamicFieldFromCustomerUser tests
# Copyright (C) 2003-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;

#use warnings;
use utf8;
use vars (qw($Self));

use Kernel::Config;
use Kernel::System::CustomerUser;
use Kernel::System::DynamicField;
use Kernel::System::Ticket;
use Kernel::System::UnitTest::Helper;

# create helper object
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 1,
);

# create a RandomID
my $RandomID = $HelperObject->GetRandomID();

$RandomID =~ s/\-//g;

my $ConfigObject = Kernel::Config->new( %{$Self} );
$ConfigObject->Set(
    Key   => 'DynamicFieldFromCustomerUser::Mapping',
    Value => {
        UserLogin     => 'CustomerLogin' . $RandomID,
        UserFirstname => 'CustomerFirstname' . $RandomID,
        UserLastname  => 'CustomerLastname' . $RandomID,
    },
);
$ConfigObject->Set(
    Key   => 'Ticket::EventModulePost###930-DynamicFieldFromCustomerUser',
    Value => {
        Module => 'Kernel::System::Ticket::Event::DynamicFieldFromCustomerUser',
        Event => '(TicketCreate|TicketCustomerUpdate)',
    },
);

# create all other objects
my $TicketObject = Kernel::System::Ticket->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $DynamicFieldObject = Kernel::System::DynamicField->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);
my $CustomerUserObject = Kernel::System::CustomerUser->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

# create the required dynamic fields
my @DynamicFields = (
    {
        Name       => 'CustomerLogin' . $RandomID,
        Label      => 'CustomerLogin',
        FieldOrder => 9991,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
    },
    {
        Name       => 'CustomerFirstname' . $RandomID,
        Label      => 'CustomerFirstname',
        FieldOrder => 9992,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
    },
    {
        Name       => 'CustomerLastname' . $RandomID,
        Label      => 'CustomerLastname',
        FieldOrder => 9993,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
    },
);

my @AddedDynamicFieldIDs;
my @AddedDynamicFieldNames;
for my $DynamicFieldConfig (@DynamicFields) {

    my $ID = $DynamicFieldObject->DynamicFieldAdd(
        %{$DynamicFieldConfig},
        Config => {
            DefaultValue => '',
        },
        InternalField => 0,
        Reorder       => 0,
        ValidID       => 1,
        UserID        => 1,
    );

    # sanity test
    $Self->IsNot(
        $ID,
        undef,
        "DynamicFieldAdd() for '$DynamicFieldConfig->{Label}' Field ID should be defined",
    );

    # remember the DynamicField ID
    push @AddedDynamicFieldIDs, $ID;

    # remember the DynamicField Name
    push @AddedDynamicFieldNames, $DynamicFieldConfig->{Name};
}

# create a customer user
my $TestUserLogin = $HelperObject->TestCustomerUserCreate();

# get customer user data
my %TestUserData = $CustomerUserObject->CustomerUserDataGet(
    User => $TestUserLogin,
);

# set customer Firstname and Lastname
$TestUserData{UserFirstname} = 'UserFirstName' . $RandomID;
$TestUserData{UserLastname}  = 'UserLastName' . $RandomID;

# update the user manually because First and LastNames are important
$CustomerUserObject->CustomerUserUpdate(
    %TestUserData,
    Source  => 'CustomerUser',
    ID      => $TestUserLogin,
    ValidID => 1,
    UserID  => 1,
);

# create a new ticket with the test user information
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

# at this point the information should be already stored in the dynamic fields
# get ticket data (with DynamicFields)
my %Ticket = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
    UserID        => 1,
    Silent        => 0,
);

# test actual resutls with expected ones
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

# clean the system
# remove the ticket
my $Success = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

# sanity test
$Self->True(
    $Success,
    "TicketDelete() for Ticket ID:'$TicketID' with true",
);

# remove dynamic fields
for my $ID (@AddedDynamicFieldIDs) {
    my $Success = $DynamicFieldObject->DynamicFieldDelete(
        ID      => $ID,
        UserID  => 1,
        Reorder => 0,
    );

    # sanity test
    $Self->True(
        $Success,
        "DynamicFieldDelete() for DynamicField ID:'$ID' with true",
    );
}

1;
