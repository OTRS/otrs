# --
# ReadableValueRender.t - ReadableValueRender backend tests
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

my $DFBackendObject = Kernel::System::DynamicField::Backend->new( %{$Self} );

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
            DefaultValue       => '',
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
        FieldType     => 'Date',
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
    {
        Name   => 'Missing Value Text',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value TextArea',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value Checkbox',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value DateTime',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'UTF8 Value Text',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value              => 'ÁäñƱƩ⨅ß',
        },
        ExpectedResults => {
            Value => 'ÁäñƱƩ⨅ß',
            Title => 'ÁäñƱƩ⨅ß',
        },
        Success => 1,
    },
    {
        Name   => 'UTF8 Value TextArea',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value              => 'Line1\nÁäñƱƩ⨅ß\nLine3',
        },
        ExpectedResults => {
            Value => 'Line1\nÁäñƱƩ⨅ß\nLine3',
            Title => 'Line1\nÁäñƱƩ⨅ß\nLine3',
        },
        Success => 1,
    },
    {
        Name   => 'Value 1 Checkbox',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value              => 1,
        },
        ExpectedResults => {
            Value => '1',
            Title => '1',
        },
        Success => 1,
    },
    {
        Name   => 'Long Value Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => 'Looooooooooooooooooooooooooooong',
        },
        ExpectedResults => {
            Value => 'Looooooooooooooooooooooooooooong',
            Title => 'Looooooooooooooooooooooooooooong',
        },
        Success => 1,
    },
    {
        Name   => 'Single Value Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => 'Value1',
        },
        ExpectedResults => {
            Value => 'Value1',
            Title => 'Value1',
        },
        Success => 1,
    },
    {
        Name   => 'Multiple Values Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value => [ 'Value1', 'Value2' ],
        },
        ExpectedResults => {
            Value => 'Value1, Value2',
            Title => 'Value1, Value2',
        },
        Success => 1,
    },
    {
        Name   => 'Correct Date Value Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '1977-12-12 00:00:00',
        },
        ExpectedResults => {
            Value => '1977-12-12',
            Title => '1977-12-12',
        },
        Success => 1,
    },
    {
        Name   => 'Incorrect Date Value Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '2013-02-31 00:00:00',
        },
        ExpectedResults => {
            Value => '2013-02-31',
            Title => '2013-02-31',
        },
        Success => 1,
    },
    {
        Name   => 'Correct DateTime Value DateTime',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '1977-12-12 12::59:32',
        },
        ExpectedResults => {
            Value => '1977-12-12 12::59:32',
            Title => '1977-12-12 12::59:32',
        },
        Success => 1,
    },
    {
        Name   => 'Incorrect Date Value Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '2013-02-31 56:00:28',
        },
        ExpectedResults => {
            Value => '2013-02-31 56:00:28',
            Title => '2013-02-31 56:00:28',
        },
        Success => 1,
    },
    {
        Name   => 'UTF8 Value Text (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value              => 'ÁäñƱƩ⨅ß',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => 'Áä...',
            Title => 'ÁäñƱ...',
        },
        Success => 1,
    },
    {
        Name   => 'UTF8 Value TextArea (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value              => 'Line1\nÁäñƱƩ⨅ß\nLine3',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => 'Li...',
            Title => 'Line...',
        },
        Success => 1,
    },
    {
        Name   => 'Value Other Checkbox (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value              => 'Other',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => 'Other',
            Title => 'Other',
        },
        Success => 1,
    },
    {
        Name   => 'Long Value Dropdown (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => 'Looooooooooooooooooooooooooooong',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => 'Lo...',
            Title => 'Looo...',
        },
        Success => 1,
    },
    {
        Name   => 'Single Value Multiselect (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => 'Value1',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => 'Va...',
            Title => 'Valu...',
        },
        Success => 1,
    },
    {
        Name   => 'Multiple Values Multiselect (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => [ 'Value1', 'Value2' ],
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => 'Va...',
            Title => 'Valu...',
        },
        Success => 1,
    },
    {
        Name   => 'Correct Date Value Date (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '1977-12-12 00:00:00',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => '1977-12-12',
            Title => '1977-12-12',
        },
        Success => 1,
    },
    {
        Name   => 'Incorrect Date Value Date (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '2013-02-31 00:00:00',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => '2013-02-31',
            Title => '2013-02-31',
        },
        Success => 1,
    },
    {
        Name   => 'Correct DateTime Value DateTime (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '1977-12-12 12::59:32',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => '1977-12-12 12::59:32',
            Title => '1977-12-12 12::59:32',
        },
        Success => 1,
    },
    {
        Name   => 'Incorrect Date Value Date (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '2013-02-31 56:00:28',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => '2013-02-31 56:00:28',
            Title => '2013-02-31 56:00:28',
        },
        Success => 1,
    },
);

# execute tests
for my $Test (@Tests) {

    my $ValueStrg = $DFBackendObject->ReadableValueRender( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->IsDeeply(
            $ValueStrg,
            $Test->{ExpectedResults},
            "$Test->{Name} | ReadableValueRender()",
        );
    }
    else {
        $Self->Is(
            $ValueStrg,
            undef,
            "$Test->{Name} | ReadableValueRender() should be undef",
        );
    }
}

# we don't need any cleanup
1;
