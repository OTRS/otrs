# --
# DynamicFieldValue.t - DynamicFieldValue backend tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: DynamicFieldValue.t,v 1.2 2011-08-25 17:30:48 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::System::DynamicField;
use Kernel::System::DynamicFieldValue;
use Kernel::System::UnitTest::Helper;
use Kernel::System::Ticket;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $RandomID = int rand 1_000_000_000;

my $DynamicFieldObject      = Kernel::System::DynamicField->new( %{$Self} );
my $DynamicFieldValueObject = Kernel::System::DynamicFieldValue->new( %{$Self} );
my $TicketObject            = Kernel::System::Ticket->new( %{$Self} );

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

    #TODO find and add more fail cases
    {
        Name               => 'Set Text Value',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => {
            ValueText => 'a text',
        },
        SuccessSet => 1,
    },
    {
        Name               => 'Set Date Value',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => {
            ValueDateTime => '1977-12-12 12:00:00',
        },
        SuccessSet => 1,
    },
    {
        Name               => 'Set Int Value',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => {
            ValueInt => 1,
        },
        SuccessSet => 1,
    },
    {
        Name               => 'Set All Values',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
        },
        ObjectID => $TicketID,
        Value    => {
            ValueText     => 'a text',
            ValueDateTime => '1977-12-12 12:00:00',
            ValueInt      => 1,
        },
        SuccessSet => 1,
    },

    # TODO add ValueGet() specific tests
);

for my $Test (@Tests) {
    my $Success = $DynamicFieldValueObject->ValueSet(
        DynamicFieldConfig => $Test->{DynamicFieldConfig},
        ObjectID           => $Test->{ObjectID},
        %{ $Test->{Value} },
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

        # get the value with ValueGet()
        my $Value = $DynamicFieldValueObject->ValueGet(
            DynamicFieldConfig => $Test->{DynamicFieldConfig},
            ObjectID           => $Test->{ObjectID},
        );

        # sanity check
        $Self->True(
            $Value,
            "ValueGet() after ValueSet() - Test $Test->{Name} - with True",
        );

        # compare data
        for my $ValueKey ( keys %{ $Test->{Value} } ) {
            $Self->Is(
                $Value->{$ValueKey},
                $Test->{Value}->{$ValueKey},
                "ValueGet() after ValueSet() - Test $Test->{Name} - Key $ValueKey",
            );
        }
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
