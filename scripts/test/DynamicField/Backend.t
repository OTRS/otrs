# --
# Backend.t - DynamicFieldValue backend tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Backend.t,v 1.15 2011-09-23 22:59:47 cg Exp $
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
            ObjectType => 'Ticket',
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
            Name       => "dynamicfieldtest$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'Text',
        },
        ObjectID  => $TicketID,
        Success   => 0,
        ShouldGet => 0,
    },
    {
        Name               => 'Non Existing Backend',
        DynamicFieldConfig => {
            ID         => $FieldID,
            Name       => "dynamicfieldtest$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'NonExistingBackend',
        },
        ObjectID  => $TicketID,
        Value     => 'a text',
        UserID    => 1,
        Success   => 0,
        ShouldGet => 0,
    },
    {
        Name               => 'Set Text Value',
        DynamicFieldConfig => {
            ID         => $FieldID,
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            ID         => $FieldID,
            Name       => "dynamicfieldtest$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'Dropdown',
            Config     => {
                PossibleValues => {},
                }
        },
        ObjectID  => $TicketID,
        Value     => 'a text',
        UserID    => 1,
        Success   => 0,
        ShouldGet => 0,
    },

    {
        Name               => 'Multiselect - No PossibleValues',
        DynamicFieldConfig => {
            ID         => $FieldID,
            Name       => "dynamicfieldtest$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'Multiselect',
        },
        ObjectID  => $TicketID,
        Value     => 'a text',
        UserID    => 1,
        Success   => 0,
        ShouldGet => 1,
    },
    {
        Name               => 'Multiselect - Invalid PossibleValues',
        DynamicFieldConfig => {
            ID         => $FieldID,
            Name       => "dynamicfieldtest$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'Multiselect',
            Config     => {
                PossibleValues => {},
                }
        },
        ObjectID  => $TicketID,
        Value     => 'a text',
        UserID    => 1,
        Success   => 0,
        ShouldGet => 1,
    },

    # options validation are now just on the frontend then this test should be successful
    {
        Name               => 'Dropdown - Invalid Option',
        DynamicFieldConfig => {
            ID         => $FieldID,
            Name       => "dynamicfieldtest$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'Dropdown',
            Config     => {
                PossibleValues => {
                    Key1 => 'Value1',
                    Key2 => 'Value2',
                    Key3 => 'Value3',
                },
            },
        },
        ObjectID  => $TicketID,
        Value     => 'Key4',
        UserID    => 1,
        Success   => 1,
        ShouldGet => 1,
    },
    {
        Name               => 'Dropdown - Invalid Option',
        DynamicFieldConfig => {
            ID         => $FieldID,
            Name       => "dynamicfieldtest$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'Dropdown',
            Config     => {
                PossibleValues => {
                    Key1 => 'Value1',
                    Key2 => 'Value2',
                    Key3 => 'Value3',
                },
            },
        },
        ObjectID  => $TicketID,
        Value     => 'Key3',
        UserID    => 1,
        Success   => 1,
        ShouldGet => 1,
    },

    # options validation are now just on the frontend then this test should be successful
    {
        Name               => 'Multiselect - Invalid Option',
        DynamicFieldConfig => {
            ID         => $FieldID,
            Name       => "dynamicfieldtest$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'Multiselect',
            Config     => {
                PossibleValues => {
                    Key1 => 'Value1',
                    Key2 => 'Value2',
                    Key3 => 'Value3',
                },
            },
        },
        ObjectID  => $TicketID,
        Value     => 'Key4',
        UserID    => 1,
        Success   => 1,
        ShouldGet => 1,
    },
    {
        Name               => 'Multiselect - Invalid Option',
        DynamicFieldConfig => {
            ID         => $FieldID,
            Name       => "dynamicfieldtest$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'Multiselect',
            Config     => {
                PossibleValues => {
                    Key1 => 'Value1',
                    Key2 => 'Value2',
                    Key3 => 'Value3',
                },
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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
            Name       => "dynamicfieldtest$RandomID",
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

        # fix Value if it's an array ref
        if ( defined $Value && ref $Value eq 'ARRAY' ) {
            $Value = join ',', @{$Value};
        }

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

        # fix Value if it's an array ref
        if ( defined $Value && ref $Value eq 'ARRAY' ) {
            $Value = join ',', @{$Value};
        }

        # workaround for oracle
        # oracle databases can't determine the difference between NULL and ''
        if ( !defined $Value || $Value eq '' ) {

            # test falseness
            $Self->False(
                $Value,
                "ValueGet() after successful ValueSet() - (Test $Test->{Name}) - "
                    . "Value (Special case for '')"
            );
        }
        else {

            # compare data
            $Self->Is(
                $Value,
                $Test->{Value},
                "ValueGet() after successful ValueSet() - (Test $Test->{Name}) - Value",
            );
        }
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

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Main;
use Kernel::System::Web::Request;
use Kernel::Output::HTML::Layout;

my $ConfigObject = Kernel::Config->new();
my $EncodeObject = Kernel::System::Encode->new(
    ConfigObject => $ConfigObject,
);
my $LogObject = Kernel::System::Log->new(
    ConfigObject => $ConfigObject,
    EncodeObject => $EncodeObject,
);
my $MainObject = Kernel::System::Main->new(
    ConfigObject => $ConfigObject,
    EncodeObject => $EncodeObject,
    LogObject    => $LogObject,
);
my $TimeObject = Kernel::System::Time->new(
    ConfigObject => $ConfigObject,
    LogObject    => $LogObject,
);
my $RequestObject = Kernel::System::Web::Request->new(
    ConfigObject => $ConfigObject,
    LogObject    => $LogObject,
    EncodeObject => $EncodeObject,
    MainObject   => $MainObject,
);
my $ParamObject = Kernel::System::Web::Request->new(
    ConfigObject => $ConfigObject,
    LogObject    => $LogObject,
    EncodeObject => $EncodeObject,
    MainObject   => $MainObject,

    #        WebRequest => 0,
);
my $LayoutObject = Kernel::Output::HTML::Layout->new(
    ConfigObject  => $ConfigObject,
    LogObject     => $LogObject,
    MainObject    => $MainObject,
    TimeObject    => $TimeObject,
    RequestObject => $RequestObject,
    EncodeObject  => $EncodeObject,
    ParamObject   => $ParamObject,
    Lang          => 'en',
);

# specific tests for ValueGet()
@Tests = (
    {
        Name               => 'Text',
        DynamicFieldConfig => {
            ID         => -1,
            ObjectType => 'Ticket',
            FieldType  => 'Text',
            Config     => {},
            Name       => 'FieldOne',
            Label      => 'Label for field'
        },
        LayoutObject => $LayoutObject,
        ObjectID     => $TicketID,
        UserID       => 1,
    },
    {
        Name               => 'TextArea',
        DynamicFieldConfig => {
            ID         => -1,
            ObjectType => 'Ticket',
            FieldType  => 'TextArea',
            Config     => {},
            Name       => 'FieldOne',
            Label      => 'Label for field'
        },
        LayoutObject => $LayoutObject,
        ObjectID     => $TicketID,
        UserID       => 1,
    },
    {
        Name               => 'Checkbox',
        DynamicFieldConfig => {
            ID         => -1,
            ObjectType => 'Ticket',
            FieldType  => 'Checkbox',
            Config     => {},
            Name       => 'FieldOne',
            Label      => 'Label for field'
        },
        LayoutObject => $LayoutObject,
        ObjectID     => $TicketID,
        UserID       => 1,
    },
    {
        Name               => 'Dropdown',
        DynamicFieldConfig => {
            ID         => -1,
            ObjectType => 'Ticket',
            FieldType  => 'Dropdown',
            Config     => {
                PossibleValues => {
                    a => 'aaa',
                    b => 'bbb',
                    c => 'ccc',
                },
                DefaultValue => 'a',
            },
            Name  => 'FieldOne',
            Label => 'Label for field'
        },
        LayoutObject => $LayoutObject,
        ObjectID     => $TicketID,
        UserID       => 1,
    },
    {
        Name               => 'DateTime',
        DynamicFieldConfig => {
            ID         => -1,
            ObjectType => 'Ticket',
            FieldType  => 'DateTime',
            Config     => {
                PossibleValues => {
                    a => 'aaa',
                    b => 'bbb',
                    c => 'ccc',
                },
                DefaultValue => '0',
            },
            Name  => 'FieldOne',
            Label => 'Label for field'
        },
        LayoutObject => $LayoutObject,
        ObjectID     => $TicketID,
        UserID       => 1,
    },
    {
        Name               => 'Datefield',
        DynamicFieldConfig => {
            ID         => -1,
            ObjectType => 'Ticket',
            FieldType  => 'Date',
            Config     => {
                PossibleValues => {
                    a => 'aaa',
                    b => 'bbb',
                    c => 'ccc',
                },
                DefaultValue => '0',
            },
            Name  => 'FieldTwo',
            Label => 'Label for field'
        },
        LayoutObject => $LayoutObject,
        ObjectID     => $TicketID,
        UserID       => 1,
    },
    {
        Name               => 'Multiselect',
        DynamicFieldConfig => {
            ID         => -1,
            ObjectType => 'Ticket',
            FieldType  => 'Multiselect',
            Config     => {
                PossibleValues => {
                    a => 'aaa',
                    b => 'bbb',
                    c => 'ccc',
                },
                DefaultValue => 'a',
            },
            Name  => 'FieldOne',
            Label => 'Label for field'
        },
        LayoutObject => $LayoutObject,
        ObjectID     => $TicketID,
        UserID       => 1,
    },

    #    {
    #        Name               => 'Wrong ObjectType',
    #        DynamicFieldConfig => {
    #            ID         => $FieldID,
    #            ObjectType => 'InvalidObject',
    #            FieldType  => 'Text',
    #        },
    #        ObjectID => $TicketID,
    #        UserID   => 1,
    #    },
    #    {
    #        Name               => 'Wrong ObjectID',
    #        DynamicFieldConfig => {
    #            ID         => $FieldID,
    #            ObjectType => 'Ticket',
    #            FieldType  => 'Text',
    #        },
    #        ObjectID => -1,
    #        UserID   => 1,
    #    },
);

for my $Test (@Tests) {

    my $FieldHTML = $BackendObject->EditFieldRender(
        DynamicFieldConfig   => $Test->{DynamicFieldConfig},   # complete config of the DynamicField
        PossibleValuesFilter => {
            z => 'zz',
            x => 'xx',
            y => 'yy',
        },

#        PossibleValuesFilter => ['value1', 'value2'],     # Optional. Some backends may support this.
#                                                          #     This may be needed to realize ACL support for ticket masks,
#                                                          #     where the possible values can be limited with and ACL.
#        Value              => 'b',                # Optional
        Mandatory    => 1,                        # 0 or 1,
        Class        => 'AnyCSSClass OrOneMore',  # Optional
        ServerError  => 1,                        # 0 or 1,
        ErrorMessage => 'mensaje de error',       # Optional or a default will be used in error case
        LayoutObject => $LayoutObject,
        ParamObject  => $ParamObject,
    );

    print STDERR $Self->{MainObject}->Dump($FieldHTML);

    $Self->True(
        $FieldHTML,
        "EditFieldRender() - Test ($Test->{Name}) - with True",
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
