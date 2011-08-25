# --
# DynamicField/Backend.t - DynamicField backend tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Backend.t,v 1.2 2011-08-25 09:25:35 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::System::DynamicField::Backend;
use Kernel::System::DynamicField;
use Kernel::System::UnitTest::Helper;
use Kernel::System::Ticket;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $RandomID = int rand 1_000_000_000;

my $DynamicFieldObject = Kernel::System::DynamicField->new( %{$Self} );
my $BackendObject      = Kernel::System::DynamicField::Backend->new( %{$Self} );
my $TicketObject       = Kernel::System::Ticket->new( %{$Self} );

# create a ticket
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
$Self->True(
    $TicketID,
    "TicketCreate() successful for Ticket ID $TicketID",
);

# create a dynamicfield
my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "dynamicfieldtest$RandomID",
    Label      => 'a description',
    FieldOrder => 9991,
    FieldType  => 'Text',     # mandatory, selects the DF backend to use for this field
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 'a value',
    },
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $FieldID,
    "DynamicFieldAdd() successful for Field ID $FieldID",
);

my @Tests = (
    {
        Name       => 'No DynamicField Config',
        SuccessSet => 0,
    },
    {
        Name               => 'Empty DynamicField Config',
        DynamicFieldConfig => {},
        ObjectID           => $TicketID,
        SuccessSet         => 0,
    },
    {
        Name               => 'No ObjectID',
        DynamicFieldConfig => {
            ID => -1,
        },
        SuccessSet => 0,
    },
    {
        Name               => 'No Object Type',
        DynamicFieldConfig => {
            ID => -1,
        },
        ObjectID   => $TicketID,
        SuccessSet => 0,
    },
    {
        Name               => 'Set Text Value',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID   => $TicketID,
        ValueText  => 'a text',
        SuccessSet => 1,
    },

);

for my $Test (@Tests) {
    my $Success = $BackendObject->ValueSet(
        DynamicFieldConfig => $Test->{DynamicFieldConfig},
        ObjectID           => $Test->{ObjectID},
        ValueText          => $Test->{ValueText},
        ValueDate          => $Test->{ValueDate},
        ValueInt           => $Test->{ValueInt},
    );

    if ( !$Test->{SuccessSet} ) {
        $Self->False(
            $Success,
            "ValueSet() - Test $Test->{Name} - with False",
        );
    }
    else {
        $Self->True(
            $Success,
            "ValueSet() - Test $Test->{Name} - with True",
        );
    }
}

my $FieldDelete = $DynamicFieldObject->DynamicFieldDelete(
    ID     => $FieldID,
    UserID => 1,
);

# sanity check
$Self->True(
    $FieldDelete,
    "DynamicFieldDelete() successful for Field ID $FieldID",
);

my $TicketDelete = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);

# sanity check
$Self->True(
    $TicketDelete,
    "TicketDelete() successful for Ticket ID $TicketID",
);

1;
