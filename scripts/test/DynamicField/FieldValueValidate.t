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

my $DFBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

my $UserID = 1;

# There is not really needed to add the dynamic fields for this test, we can define a static
#   set of configurations.
my %DynamicFieldConfigs = (
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
            PossibleNone       => 1,
            TranslatableValues => '',
            PossibleValues     => {
                1 => 'A',
                2 => 'B',
            },
        },
        ValidID    => 1,
        CreateTime => '2018-02-08 15:08:00',
        ChangeTime => '2018-06-11 17:22:00',
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
            PossibleNone       => 1,
            TranslatableValues => '',
            PossibleValues     => {
                1 => 'A',
                2 => 'B',
                3 => 'C',
                4 => 'D',
            },
        },
        ValidID    => 1,
        CreateTime => '2018-02-08 15:08:00',
        ChangeTime => '2018-06-11 17:22:00',
    },
);

# Define tests.
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
        },
        Success => 0,
    },
    {
        Name   => 'Missing UserID',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
        },
        Success => 0,
    },
    {
        Name   => 'Missing Value Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => undef,
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Missing Value Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => undef,
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Zero Value Dropdown, wrong value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => 0,
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Zero Value Multiselect, wrong value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => 0,
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Empty String Value Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => '',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Empty String Value Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => '',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Empty Array Value Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => [],
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Empty Array Value Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => [],
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Wrong Value Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => 'Value 1',
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Array Value Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => [ 'Value 1', 'Value 2' ],
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Value Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => '1',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Wrong Single Value Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => 'Value 1',
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Single Value Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => '1',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Array Single Value Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => ['1'],
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Wrong Single Value Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => [ '1', 'Value 2' ],
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Multiple Values Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => [ 'Value 1', 'Value 2' ],
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Multiple Values Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => [ '1', '2', '4' ],
            UserID             => $UserID,
        },
        Success => 1,
    },
);

# Execute tests.
for my $Test (@Tests) {
    my $Success = $DFBackendObject->FieldValueValidate( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->Is(
            $Success,
            1,
            "$Test->{Name} | FieldValueValidate()",
        );
    }
    else {
        $Self->Is(
            $Success,
            undef,
            "$Test->{Name} | FieldValueValidate() (should be undef)",
        );
    }
}

# We don't need any cleanup.

1;
