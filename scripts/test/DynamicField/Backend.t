# --
# Backend.t - DynamicFieldValue backend tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Backend.t,v 1.7 2011-08-29 21:52:03 cr Exp $
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
use Kernel::System::DynamicField::Backend;
use Kernel::System::UnitTest::Helper;
use Kernel::System::Ticket;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $RandomID = int rand 1_000_000_000;

my $DynamicFieldObject = Kernel::System::DynamicField->new( %{$Self} );
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

# create a dynamic field
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

# get the Dynamic Fields configuration
my $DynamicFieldsConfig = $Self->{ConfigObject}->Get('DynamicFields::Backend');

# sanity check
$Self->Is(
    ref $DynamicFieldsConfig,
    'HASH',
    'Dynamic Field confguration',
);
$Self->IsNotDeeply(
    $DynamicFieldsConfig,
    {},
    'Dynamic Field confguration is not empty',
);

# create backend object and delegates
my $BackendObject = Kernel::System::DynamicField::Backend->new( %{$Self} );

$Self->True(
    $BackendObject,
    'Backend object was created',
);

$Self->Is(
    ref $BackendObject,
    'Kernel::System::DynamicField::Backend',
    'Backend object was created successfuly',
);

# check all registered backend delegates
for my $FieldType ( sort keys %{$DynamicFieldsConfig} ) {
    $Self->True(
        $BackendObject->{ 'DynamicField' . $FieldType . 'Object' },
        "Backend delegate for field type $FieldType was created",
    );

    $Self->Is(
        ref $BackendObject->{ 'DynamicField' . $FieldType . 'Object' },
        $DynamicFieldsConfig->{$FieldType}->{Module},
        "Backend delegate for field type $FieldType was created successfuly",
    );
}

my @Tests = (
    {
        Name      => 'No DynamicFieldConfig',
        ObjectID  => $TicketID,
        UserID    => 1,
        Success   => 0,
        ShouldGet => 0,
    },
    {
        Name               => 'No ObjectID',
        DynamicFieldConfig => {
            ID         => -1,
            ObjectType => 'Ticket',
        },
        UserID    => 1,
        Success   => 0,
        ShouldGet => 0,
    },
    {
        Name               => 'Invalid DynamicFieldConfig',
        DynamicFieldConfig => {},
        ObjectID           => $TicketID,
        UserID             => 1,
        Success            => 0,
        ShouldGet          => 0,
    },
    {
        Name               => 'No ID',
        DynamicFieldConfig => {
            ObjectType => 'Ticket',
        },
        ObjectID  => $TicketID,
        UserID    => 1,
        Success   => 0,
        ShouldGet => 0,
    },
    {
        Name               => 'No ObjectType',
        DynamicFieldConfig => {
            ID => $FieldID,
        },
        ObjectID  => $TicketID,
        UserID    => 1,
        Success   => 0,
        ShouldGet => 0,
    },
    {
        Name               => 'No UserID',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'Text',
        },
        ObjectID  => $TicketID,
        Success   => 0,
        ShouldGet => 0,
    },
    {
        Name               => 'Set Text Value',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'Text',
        },
        ObjectID  => $TicketID,
        Value     => 'a text',
        UserID    => 1,
        Success   => 1,
        ShouldGet => 1,
    },
    {
        Name               => 'Set Text Value - empty',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'Text',
        },
        ObjectID  => $TicketID,
        Value     => '',
        UserID    => 1,
        Success   => 1,
        ShouldGet => 1,
    },
    {
        Name               => 'Set Text Value - unicode',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'Text',
        },
        ObjectID  => $TicketID,
        Value     => 'äöüßÄÖÜ€ис',
        UserID    => 1,
        Success   => 1,
        ShouldGet => 1,
    },
    {
        Name               => 'Set TextArea Value',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'TextArea',
        },
        ObjectID  => $TicketID,
        Value     => 'a text',
        UserID    => 1,
        Success   => 1,
        ShouldGet => 1,
    },
    {
        Name               => 'Set TextArea Value - empty',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'TextArea',
        },
        ObjectID  => $TicketID,
        Value     => '',
        UserID    => 1,
        Success   => 1,
        ShouldGet => 1,
    },
    {
        Name               => 'Set TextArea Value - unicode',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'TextArea',
        },
        ObjectID  => $TicketID,
        Value     => 'äöüßÄÖÜ€ис',
        UserID    => 1,
        Success   => 1,
        ShouldGet => 1,
    },
    {
        Name               => 'Set DateTime Value',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'DateTime',
        },
        ObjectID  => $TicketID,
        Value     => '2011-01-01 01:01:01',
        UserID    => 1,
        Success   => 1,
        ShouldGet => 1,
    },
    {
        Name               => 'Dropdown - No PossibleValues',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'Dropdown',
        },
        ObjectID  => $TicketID,
        Value     => 'a text',
        UserID    => 1,
        Success   => 0,
        ShouldGet => 0,
    },
    {
        Name               => 'Dropdown - Invalid PossibleValues',
        DynamicFieldConfig => {
            ID             => $FieldID,
            ObjectType     => 'Ticket',
            FieldType      => 'Dropdown',
            PossibleValues => {},
        },
        ObjectID  => $TicketID,
        Value     => 'a text',
        UserID    => 1,
        Success   => 0,
        ShouldGet => 0,
    },
    {
        Name               => 'Dropdown - Invalid Option',
        DynamicFieldConfig => {
            ID             => $FieldID,
            ObjectType     => 'Ticket',
            FieldType      => 'Dropdown',
            PossibleValues => {
                Key1 => 'Value1',
                Key2 => 'Value2',
                Key3 => 'Value3',
            },
        },
        ObjectID  => $TicketID,
        Value     => 'Key4',
        UserID    => 1,
        Success   => 0,
        ShouldGet => 0,
    },
    {
        Name               => 'Dropdown - Invalid Option',
        DynamicFieldConfig => {
            ID             => $FieldID,
            ObjectType     => 'Ticket',
            FieldType      => 'Dropdown',
            PossibleValues => {
                Key1 => 'Value1',
                Key2 => 'Value2',
                Key3 => 'Value3',
            },
        },
        ObjectID  => $TicketID,
        Value     => 'Key3',
        UserID    => 1,
        Success   => 1,
        ShouldGet => 1,
    },
    {
        Name               => 'Checkbox - Invalid Option (Negative)',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'Checkbox',
        },
        ObjectID  => $TicketID,
        Value     => -1,
        UserID    => 1,
        Success   => 0,
        ShouldGet => 0,
    },
    {
        Name               => 'Checkbox - Invalid Option (Letter)',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'Checkbox',
        },
        ObjectID  => $TicketID,
        Value     => 'a',
        UserID    => 1,
        Success   => 0,
        ShouldGet => 0,
    },
    {
        Name               => 'Checkbox - Invalid Option (Non Binary)',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'Checkbox',
        },
        ObjectID  => $TicketID,
        Value     => 5,
        UserID    => 1,
        Success   => 0,
        ShouldGet => 0,
    },
    {
        Name               => 'Set Checkbox Value (1) ',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'Checkbox',
        },
        ObjectID  => $TicketID,
        Value     => 1,
        UserID    => 1,
        Success   => 1,
        ShouldGet => 1,
    },
    {
        Name               => 'Set Checkbox Value (0) ',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'Checkbox',
        },
        ObjectID  => $TicketID,
        Value     => 0,
        UserID    => 1,
        Success   => 1,
        ShouldGet => 1,
    },
    {
        Name               => 'Set Checkbox Value (Null) ',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'Checkbox',
        },
        ObjectID  => $TicketID,
        Value     => undef,
        UserID    => 1,
        Success   => 1,
        ShouldGet => 1,
    },
    {
        Name               => 'Set DateTime Value - invalid date',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'DateTime',
        },
        ObjectID  => $TicketID,
        Value     => '2011-02-31 01:01:01',
        UserID    => 1,
        Success   => 0,
        ShouldGet => 1,
    },
    {
        Name               => 'Set DateTime Value - wrong data',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'DateTime',
        },
        ObjectID  => $TicketID,
        Value     => 'Aug 1st',
        UserID    => 1,
        Success   => 0,
        ShouldGet => 1,
    },
    {
        Name               => 'Set DateTime Value - no data',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'DateTime',
        },
        ObjectID  => $TicketID,
        Value     => undef,
        UserID    => 1,
        Success   => 1,
        ShouldGet => 1,
    },
    {
        Name               => 'Set Date Value - invalid date',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'Date',
        },
        ObjectID  => $TicketID,
        Value     => '2011-02-31 01:01:01',
        UserID    => 1,
        Success   => 0,
        ShouldGet => 1,
    },
    {
        Name               => 'Set Date Value - invalid time',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'Date',
        },
        ObjectID  => $TicketID,
        Value     => '2011-31-02 01:01:01',
        UserID    => 1,
        Success   => 0,
        ShouldGet => 1,
    },
    {
        Name               => 'Set Date Value - wrong data',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'DateTime',
        },
        ObjectID  => $TicketID,
        Value     => 'Aug 1st',
        UserID    => 1,
        Success   => 0,
        ShouldGet => 1,
    },
    {
        Name               => 'Set Date Value - no data',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'DateTime',
        },
        ObjectID  => $TicketID,
        Value     => undef,
        UserID    => 1,
        Success   => 1,
        ShouldGet => 1,
    },
);

for my $Test (@Tests) {
    my $Success = $BackendObject->ValueSet(
        DynamicFieldConfig => $Test->{DynamicFieldConfig},
        ObjectID           => $Test->{ObjectID},
        Value              => $Test->{Value},
        UserID             => $Test->{UserID},
    );

    if ( !$Test->{Success} ) {
        $Self->False(
            $Success,
            "ValueSet() - Test ($Test->{Name}) - with False",
        );

        # Try to get the value with ValueGet()
        my $Value = $BackendObject->ValueGet(
            DynamicFieldConfig => $Test->{DynamicFieldConfig},
            ObjectID           => $Test->{ObjectID},
        );

        # compare data
        if ( $Test->{ShouldGet} ) {
            $Self->IsNot(
                $Value,
                $Test->{Value},
                "ValueGet() after unsuccessful ValueSet() - (Test $Test->{Name}) - Value",
            );
        }
        else {
            $Self->Is(
                $Value,
                undef,
                "ValueGet() after unsuccessful ValueSet() - (Test $Test->{Name}) - Value undef",
            );
        }

    }
    else {
        $Self->True(
            $Success,
            "ValueSet() - Test ($Test->{Name}) - with True",
        );

        # get the value with ValueGet()
        my $Value = $BackendObject->ValueGet(
            DynamicFieldConfig => $Test->{DynamicFieldConfig},
            ObjectID           => $Test->{ObjectID},
        );

        # compare data
        $Self->Is(
            $Value,
            $Test->{Value},
            "ValueGet() after successful ValueSet() - (Test $Test->{Name}) - Value",
        );
    }
}

# specific tests for ValueGet()
@Tests = (
    {
        Name               => 'Wrong FieldID',
        DynamicFieldConfig => {
            ID         => -1,
            ObjectType => 'Ticket',
            FieldType  => 'Text',
        },
        ObjectID => $TicketID,
        UserID   => 1,
    },
    {
        Name               => 'Wrong ObjectType',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'InvalidObject',
            FieldType  => 'Text',
        },
        ObjectID => $TicketID,
        UserID   => 1,
    },
    {
        Name               => 'Wrong ObjectID',
        DynamicFieldConfig => {
            ID         => $FieldID,
            ObjectType => 'Ticket',
            FieldType  => 'Text',
        },
        ObjectID => -1,
        UserID   => 1,
    },
);

for my $Test (@Tests) {

    # try to get the value with ValueGet()
    my $Value = $BackendObject->ValueGet(
        DynamicFieldConfig => $Test->{DynamicFieldConfig},
        ObjectID           => $Test->{ObjectID},
    );

    $Self->False(
        $Value->{ID},
        "ValueGet() - Test ($Test->{Name}) - with False",
    );

}

# delete the dynamic field
my $FieldDelete = $DynamicFieldObject->DynamicFieldDelete(
    ID     => $FieldID,
    UserID => 1,
);

# sanity check
$Self->True(
    $FieldDelete,
    "DynamicFieldDelete() successful for Field ID $FieldID",
);

# delete the ticket
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
