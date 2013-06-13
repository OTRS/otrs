# --
# ObjectMatch.t - ObjectMatch backend tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::System::DynamicField::Backend;
use Kernel::System::UnitTest::Helper;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $BackendObject = Kernel::System::DynamicField::Backend->new( %{$Self} );

# theres is not really needed to add the dynamic fields for this test, we can define a static
# set of configurations
my %DynamicFieldConfigs = (
    Text => {
        ID            => 123,
        InternalField => 0,
        Name          => 'TextField',
        Label         => 'TextField',
        FieldOrder    => 123,
        FieldType     => 'Text',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue => '',
            Link         => '',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    TextArea => {
        ID            => 123,
        InternalField => 0,
        Name          => 'TextAreaField',
        Label         => 'TextAreaField',
        FieldOrder    => 123,
        FieldType     => 'TextArea',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue => '',
            Rows         => '',
            Cols         => '',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    Checkbox => {
        ID            => 123,
        InternalField => 0,
        Name          => 'CheckboxField',
        Label         => 'CheckboxField',
        FieldOrder    => 123,
        FieldType     => 'Checkbox',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue => '',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    Dropdown => {
        ID            => 123,
        InternalField => 0,
        Name          => 'DropdownField',
        Label         => 'DropdownField',
        FieldOrder    => 123,
        FieldType     => 'Dropdown',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue       => '',
            Link               => '',
            PossibleNone       => '',
            TranslatableValues => '',
            PossibleValues     => {
                A => 'A',
                B => 'B',
            },
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    Multiselect => {
        ID            => 123,
        InternalField => 0,
        Name          => 'MultiselectField',
        Label         => 'MultiselectField',
        FieldOrder    => 123,
        FieldType     => 'Multiselect',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue       => '',
            PossibleNone       => '',
            TranslatableValues => '',
            PossibleValues     => {
                A => 'A',
                B => 'B',
            },
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    DateTime => {
        ID            => 123,
        InternalField => 0,
        Name          => 'DateTimeField',
        Label         => 'DateTimeField',
        FieldOrder    => 123,
        FieldType     => 'DateTime',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue  => '',
            Link          => '',
            YearsPeriod   => '',
            YearsInFuture => '',
            YearsInPast   => '',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    Date => {
        ID            => 123,
        InternalField => 0,
        Name          => 'DateField',
        Label         => 'DateField',
        FieldOrder    => 123,
        FieldType     => 'DateTime',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue  => '',
            Link          => '',
            YearsPeriod   => '',
            YearsInFuture => '',
            YearsInPast   => '',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
);

my %ObjectAttributesBase = (
    DynamicField_TextField        => 'Some Text',
    DynamicField_TextAreaField    => 'Some Text',
    DynamicField_CheckboxField    => 1,
    DynamicField_DropdownField    => 'Some Text',
    DynamicField_MultiselectField => [ 'Other Text', 'Some Text' ],
    DynamicField_DateTimeField    => '2013-06-11 17:22:00',
    DynamicField_DateField        => '2013-06-11 00:00:00',
);

# define tests
my @Tests = (
    {
        Name    => 'No Params',
        Config  => undef,
        Success => 0,
    },
    {
        Name    => 'Empty Config',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing DynamicFieldConfig',
        Config => {
            DynamicFieldConfig => undef,
            ObjectAttributes   => {},
        },
        Success => 0,
    },
    {
        Name   => 'Missing ObjectAttributes',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            ObjectAttributes   => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Missing Value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value              => undef,
            ObjectAttributes   => {
                %ObjectAttributesBase,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Empty ObjectAttributes',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value              => 'Some Text',
            ObjectAttributes   => {},
        },
        Success => 0,
    },

    # tests for each FieldType (for fail)
    {
        Name   => 'Wrong Value FieldType=Text',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value              => 'Wrong Value',
            ObjectAttributes   => {
                %ObjectAttributesBase,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Value FieldType=TextArea',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value              => 'Wrong Value',
            ObjectAttributes   => {
                %ObjectAttributesBase,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Value FieldType=Checkbox',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value              => 'Wrong Value',
            ObjectAttributes   => {
                %ObjectAttributesBase,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Value FieldType=Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => 'Wrong Value',
            ObjectAttributes   => {
                %ObjectAttributesBase,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Value FieldType=Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => 'Wrong Value',
            ObjectAttributes   => {
                %ObjectAttributesBase,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Value FieldType=DateTime',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => 'Wrong Value',
            ObjectAttributes   => {
                %ObjectAttributesBase,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Value FieldType=Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => 'Wrong Value',
            ObjectAttributes   => {
                %ObjectAttributesBase,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing Field FieldType=Text',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value              => 'Some Text',
            ObjectAttributes   => {
                %ObjectAttributesBase,
                DynamicField_TextField => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing Field FieldType=TextArea',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value              => 'Some Text',
            ObjectAttributes   => {
                %ObjectAttributesBase,
                DynamicField_TextAreaField => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing Field FieldType=Checkbox 1',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value              => 1,
            ObjectAttributes   => {
                %ObjectAttributesBase,
                DynamicField_CheckboxField => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing Field FieldType=Checkbox 0',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value              => 0,
            ObjectAttributes   => {
                %ObjectAttributesBase,
                DynamicField_CheckboxField => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing Field FieldType=Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => 'Some Text',
            ObjectAttributes   => {
                %ObjectAttributesBase,
                DynamicField_DropdownField => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing Field FieldType=MultiSelect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => 'Some Text',
            ObjectAttributes   => {
                %ObjectAttributesBase,
                DynamicField_MultiselectField => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing Field FieldType=DateTime',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '2013-06-11 17:22:00',
            ObjectAttributes   => {
                %ObjectAttributesBase,
                DynamicField_DateTimeField => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing Field FieldType=Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '2013-06-11 00:00:00',
            ObjectAttributes   => {
                %ObjectAttributesBase,
                DynamicField_DateField => undef,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing Item FieldType=Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => 'Other Text',
            ObjectAttributes   => {
                %ObjectAttributesBase,
                DynamicField_MultiselectField => [ undef, 'Some Text' ],
            },
        },
        Success => 0,
    },

    # tests for each FieldType (for success)
    {
        Name   => 'Correct Value FieldType=Text',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value              => 'Some Text',
            ObjectAttributes   => {
                %ObjectAttributesBase,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Value FieldType=TextArea',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value              => 'Some Text',
            ObjectAttributes   => {
                %ObjectAttributesBase,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Value FieldType=Checkbox 1',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value              => 1,
            ObjectAttributes   => {
                %ObjectAttributesBase,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Value FieldType=Checkbox 0',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value              => 0,
            ObjectAttributes   => {
                %ObjectAttributesBase,
                DynamicField_CheckboxField => 0,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Value FieldType=Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => 'Correct Value',
            ObjectAttributes   => {
                %ObjectAttributesBase,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Correct Value FieldType=Multiselect Some Text',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => 'Some Text',
            ObjectAttributes   => {
                %ObjectAttributesBase,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Correct Value FieldType=Multiselect Other Text',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => 'Other Text',
            ObjectAttributes   => {
                %ObjectAttributesBase,
            },
        },
        Success => 1,
    },

    # not supported
    {
        Name   => 'Correct Value FieldType=DateTime (not supported)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '2013-06-11 17:22:00',
            ObjectAttributes   => {
                %ObjectAttributesBase,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Correct Value FieldType=Date (Not Supported)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '2013-06-11 00:00:00',
            ObjectAttributes   => {
                %ObjectAttributesBase,
            },
        },
        Success => 0,
    },
);

# execute tests
for my $Test (@Tests) {

    my $Match = $BackendObject->ObjectMatch( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->True(
            $Match,
            "$Test->{Name} ObjectMatch() executed with True",
        );
    }
    else {
        $Self->False(
            $Match,
            "$Test->{Name} ObjectMatch() executed with False",
        );
    }
}

# we don't need any cleanup
1;
