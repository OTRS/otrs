# --
# ValueIsDifferent.t - ValueIsDifferent() backend tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use CGI;
use vars (qw($Self));

use Kernel::System::DynamicField::Backend;
use Kernel::System::UnitTest::Helper;

use Kernel::System::VariableCheck qw(:all);

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $DFBackendObject = Kernel::System::DynamicField::Backend->new( %{$Self} );

my $UserID = 1;

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
            DefaultValue => 'Default',
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
            DefaultValue => "Multi\nLine",
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
            DefaultValue => '1',
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
            DefaultValue       => 2,
            Link               => '',
            PossibleNone       => 1,
            TranslatableValues => '',
            PossibleValues     => {
                1 => 'A',
                2 => 'B',
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
            DefaultValue       => 2,
            PossibleNone       => 1,
            TranslatableValues => '',
            PossibleValues     => {
                1 => 'A',
                2 => 'B',
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
            DefaultValue  => '2013-08-21 16:45:00',
            Link          => '',
            YearsPeriod   => '1',
            YearsInFuture => '5',
            YearsInPast   => '5',
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
        FieldType     => 'Date',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue  => '2013-08-21 00:00:00',
            Link          => '',
            YearsPeriod   => '1',
            YearsInFuture => '5',
            YearsInPast   => '5',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
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
        },
        Success => 0,
    },

    # Dynamic Field Text
    {
        Name   => 'Text: Value1 undef, Value2 empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value1             => undef,
            Value2             => '',
        },
        Success => 0,
    },
    {
        Name   => 'Text: Value1 empty, Value2 undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value1             => '',
            Value2             => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Text: Both undefs',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value1             => undef,
            Value2             => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Text: Both empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value1             => '',
            Value2             => '',
        },
        Success => 0,
    },
    {
        Name   => 'Text: Both equals',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value1             => 'abcde',
            Value2             => 'abcde',
        },
        Success => 0,
    },
    {
        Name   => 'Text: Both equals utf8',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value1             => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            Value2             => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 0,
    },
    {
        Name   => 'Text: Different case',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value1             => 'A',
            Value2             => 'a',
        },
        Success => 1,
    },
    {
        Name   => 'Text: Different using utf8',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value1             => 'a',
            Value2             => 'á',
        },
        Success => 1,
    },
    {
        Name   => 'Text: Different using utf8 (both)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value1             => 'ä',
            Value2             => 'á',
        },
        Success => 1,
    },

    # Dynamic Field TextArea
    {
        Name   => 'TextArea: Value1 undef, Value2 empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value1             => undef,
            Value2             => '',
        },
        Success => 0,
    },
    {
        Name   => 'TextArea: Value1 empty, Value2 undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value1             => '',
            Value2             => undef,
        },
        Success => 0,
    },
    {
        Name   => 'TextArea: Both undefs',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value1             => undef,
            Value2             => undef,
        },
        Success => 0,
    },
    {
        Name   => 'TextArea: Both empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value1             => '',
            Value2             => '',
        },
        Success => 0,
    },
    {
        Name   => 'TextArea: Both equals',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value1             => 'abcde',
            Value2             => 'abcde',
        },
        Success => 0,
    },
    {
        Name   => 'TextArea: Both equals utf8',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value1             => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            Value2             => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 0,
    },
    {
        Name   => 'TextArea: Different case',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value1             => 'A',
            Value2             => 'a',
        },
        Success => 1,
    },
    {
        Name   => 'TextArea: Different using utf8',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value1             => 'a',
            Value2             => 'á',
        },
        Success => 1,
    },
    {
        Name   => 'TextArea: Different using utf8 (both)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value1             => 'ä',
            Value2             => 'á',
        },
        Success => 1,
    },
    {
        Name   => 'TextArea: Different mutiline',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value1             => 'This is a multiline\ntext',
            Value2             => 'This is a multiline\nentry',
        },
        Success => 1,
    },
    {
        Name   => 'TextArea: Same mutiline',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value1             => 'This is a multiline\ntext',
            Value2             => 'This is a multiline\ntext',
        },
        Success => 0,
    },

    # Dynamic Field Checkbox
    {
        Name   => 'Checkbox: Value1 undef, Value2 empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value1             => undef,
            Value2             => '',
        },
        Success => 0,
    },
    {
        Name   => 'Checkbox: Value1 empty, Value2 undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value1             => '',
            Value2             => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Checkbox: Value1 undef, Value2 0',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value1             => undef,
            Value2             => 0,
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: Value1 0, Value2 undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value1             => 0,
            Value2             => undef,
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: Both undefs',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value1             => undef,
            Value2             => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Checkbox: Both empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value1             => '',
            Value2             => '',
        },
        Success => 0,
    },
    {
        Name   => 'Checkbox: Both equals 0',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value1             => 0,
            Value2             => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Checkbox: Both equals 1',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value1             => 1,
            Value2             => 1,
        },
        Success => 0,
    },
    {
        Name   => 'Checkbox: Different',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value1             => 0,
            Value2             => 1,
        },
        Success => 1,
    },

    # Dynamic Field Dropdown
    {
        Name   => 'Dropdown: Value1 undef, Value2 empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value1             => undef,
            Value2             => '',
        },
        Success => 0,
    },
    {
        Name   => 'Dropdown: Value1 empty, Value2 undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value1             => '',
            Value2             => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Dropdown: Both undefs',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value1             => undef,
            Value2             => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Dropdown: Both empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value1             => '',
            Value2             => '',
        },
        Success => 0,
    },
    {
        Name   => 'Dropdown: Both equals',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value1             => 'abcde',
            Value2             => 'abcde',
        },
        Success => 0,
    },
    {
        Name   => 'Dropdown: Both equals utf8',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value1             => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            Value2             => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 0,
    },
    {
        Name   => 'Dropdown: Different case',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value1             => 'A',
            Value2             => 'a',
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown: Different using utf8',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value1             => 'a',
            Value2             => 'á',
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown: Different using utf8 (both)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value1             => 'ä',
            Value2             => 'á',
        },
        Success => 1,
    },

    # Dynamic Field Multiselect
    {
        Name   => 'Multiselect: Value1 undef, Value2 empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => undef,
            Value2             => '',
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Value1 empty, Value2 undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => '',
            Value2             => undef,
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Value1 undef, Value2 empty array',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => undef,
            Value2             => [],
        },
        Success => 0,
    },
    {
        Name   => 'Multiselect: Value1 empty array, Value2 undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => [],
            Value2             => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Multiselect: Both undefs',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => undef,
            Value2             => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Multiselect: Both empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => '',
            Value2             => '',
        },
        Success => 0,
    },
    {
        Name   => 'Multiselect: Both empty arrays',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => [],
            Value2             => [],
        },
        Success => 0,
    },
    {
        Name   => 'Multiselect: Both equals',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => 'abcde',
            Value2             => 'abcde',
        },
        Success => 0,
    },
    {
        Name   => 'Multiselect: Both equals utf8',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            Value2             => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 0,
    },
    {
        Name   => 'Multiselect: Different case',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => 'A',
            Value2             => 'a',
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Different using utf8',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => 'a',
            Value2             => 'á',
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Different using utf8 (both)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => 'ä',
            Value2             => 'á',
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Both equal arrays',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => ['abcde'],
            Value2             => ['abcde'],
        },
        Success => 0,
    },
    {
        Name   => 'Multiselect: Both equals utf8 arrays',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => ['äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß'],
            Value2             => ['äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß'],
        },
        Success => 0,
    },
    {
        Name   => 'Multiselect: Different case arrays',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => ['A'],
            Value2             => ['a'],
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Different using utf8 arrays',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => ['a'],
            Value2             => ['á'],
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Different using utf8 (both) arrays',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => ['ä'],
            Value2             => ['á'],
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Different order arrays',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => [ 'A', 'B', ],
            Value2             => [ 'B', 'A', ],
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: Same arrays',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value1             => [ 'A', 'B', ],
            Value2             => [ 'A', 'B', ],
        },
        Success => 0,
    },

    # Dynamic Field DateTime
    {
        Name   => 'DateTime: Value1 undef, Value2 empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value1             => undef,
            Value2             => '',
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Value1 empty, Value2 undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value1             => '',
            Value2             => undef,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Both undefs',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value1             => undef,
            Value2             => undef,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Both empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value1             => '',
            Value2             => '',
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Both equals',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value1             => '2013-08-21 16:45:00',
            Value2             => '2013-08-21 16:45:00',
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Different date/time',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value1             => '2013-08-21 16:45:00',
            Value2             => '2013-08-21 16:45:01',,
        },
        Success => 1,
    },

    # Dynamic Field Date
    {
        Name   => 'Date: Value1 undef, Value2 empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value1             => undef,
            Value2             => '',
        },
        Success => 0,
    },
    {
        Name   => 'Date: Value1 empty, Value2 undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value1             => '',
            Value2             => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Both undefs',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value1             => undef,
            Value2             => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Both empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value1             => '',
            Value2             => '',
        },
        Success => 0,
    },
    {
        Name   => 'Date: Both equals',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value1             => '2013-08-21 00:00:00',
            Value2             => '2013-08-21 00:00:00',
        },
        Success => 0,
    },
    {
        Name   => 'Date: Different date/time',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value1             => '2013-08-21 00:00:00',
            Value2             => '2013-08-22 00:00:00',,
        },
        Success => 1,
    },

);

# execute tests
for my $Test (@Tests) {

    my $Result = $DFBackendObject->ValueIsDifferent( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->True(
            $Result,
            "$Test->{Name} | ValueIsDifferent() with true",
        );
    }
    else {
        $Self->Is(
            $Result,
            undef,
            "$Test->{Name} | ValueIsDifferent() (should be undef)",
        );
    }
}

# we don't need any cleanup
1;
