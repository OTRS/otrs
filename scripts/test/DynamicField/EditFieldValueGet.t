# --
# EditFieldValueGet.t - EditFieldValueGet() backend tests
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
use Kernel::System::Web::Request;

use Kernel::System::VariableCheck qw(:all);

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $DFBackendObject = Kernel::System::DynamicField::Backend->new( %{$Self} );

my $ParamObject = Kernel::System::Web::Request->new(
    %{$Self},
    WebRequest => 0,
);

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
        Name   => 'Missing ParamObject and Template',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            ParamObject        => undef,
            Template           => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Missing LayoutObject (W/TransformDates)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            ParamObject        => $ParamObject,
            TransformDates     => 1,
            LayoutObject       => undef
        },
        Success => 0,
    },

    # Dynamic Field Text
    {
        Name   => 'Text: Empty template and no ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Text},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Text: Empty template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Text},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Text: UTF8 template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Template           => {
                DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Text: empty template and UTF8 ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Text: Empty template and no ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Text},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Text: Empty template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Text},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Text: UTF8 template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Template           => {
                DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Text: empty template and UTF8 ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Text: Empty template and no ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Text},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TextField => undef,
        },

        Success => 1,
    },
    {
        Name   => 'Text: Empty template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Text},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TextField => undef,
        },
        Success => 1,
    },
    {
        Name   => 'Text: UTF8 template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Template           => {
                DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 1,
    },
    {
        Name   => 'Text: empty template and UTF8 ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 1,
    },

    # Dynamic Field TextArea
    {
        Name   => 'TextArea: Empty template and no ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{TextArea},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'TextArea: Empty template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{TextArea},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'TextArea: UTF8 template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Template           => {
                DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'TextArea: empty template and UTF8 ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'TextArea: Empty template and no ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{TextArea},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'TextArea: Empty template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{TextArea},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'TextArea: UTF8 template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Template           => {
                DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'TextArea: empty template and UTF8 ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'TextArea: Empty template and no ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{TextArea},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TextAreaField => undef,
        },

        Success => 1,
    },
    {
        Name   => 'TextArea: Empty template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{TextArea},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TextAreaField => undef,
        },
        Success => 1,
    },
    {
        Name   => 'TextArea: UTF8 template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Template           => {
                DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TextAreaField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 1,
    },
    {
        Name   => 'TextArea: empty template and UTF8 ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TextAreaField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 1,
    },

    # Dynamic Field Checkbox
    {
        Name   => 'Checkbox: Empty template and no ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Checkbox},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Checkbox: Empty template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Checkbox},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Checkbox: UTF8 template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Checkbox: empty template and UTF8 ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Checkbox: Empty template and no ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Checkbox},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {},
        Success         => 1,
    },
    {
        Name   => 'Checkbox: Empty template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Checkbox},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {},
        Success         => 1,
    },
    {
        Name   => 'Checkbox: UTF8 template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => {
            FieldValue => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            UsedValue  => 1,
            }
    },
    {
        Name   => 'Checkbox: empty template and UTF8 ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => {
            FieldValue => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            UsedValue  => 1
        },

    },
    {
        Name   => 'Checkbox: Empty template and no ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Checkbox},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CheckboxField => undef,
        },

        Success => 1,
    },
    {
        Name   => 'Checkbox: Empty template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Checkbox},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CheckboxField => undef,
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: UTF8 template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CheckboxField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            DynamicField_CheckboxFieldUsed => 1,
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: empty template and UTF8 ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CheckboxField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            DynamicField_CheckboxFieldUsed => 1,
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: UTF8 template and empty ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Checkbox: empty template and UTF8 ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Checkbox: UTF8 template and empty ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            FieldValue => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            UsedValue  => 0,
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: empty template and UTF8 ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            FieldValue => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            UsedValue  => 0,

        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: UTF8 template and empty ParamObject (TemplateStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CheckboxField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            DynamicField_CheckboxFieldUsed => 0,
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: empty template and UTF8 ParamObject (TemplateStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CheckboxField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            DynamicField_CheckboxFieldUsed => 0,
        },
        Success => 1,
    },

    # Dynamic Field Dropdown
    {
        Name   => 'Dropdown: Empty template and no ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Dropdown},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Dropdown: Empty template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Dropdown},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Dropdown: UTF8 template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Template           => {
                DynamicField_DropdownField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Dropdown: empty template and UTF8 ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DropdownField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Dropdown: Empty template and no ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Dropdown},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Dropdown: Empty template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Dropdown},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Dropdown: UTF8 template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Template           => {
                DynamicField_DropdownField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Dropdown: empty template and UTF8 ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DropdownField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Dropdown: Empty template and no ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Dropdown},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DropdownField => undef,
        },

        Success => 1,
    },
    {
        Name   => 'Dropdown: Empty template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Dropdown},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DropdownField => undef,
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown: UTF8 template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Template           => {
                DynamicField_DropdownField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DropdownField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown: empty template and UTF8 ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DropdownField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DropdownField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 1,
    },

    # Dynamic Field Multiselect
    {
        Name   => 'Multiselect: Empty template and no ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Multiselect},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Multiselect: Empty template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Multiselect},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => [],
        Success         => 1,
    },
    {
        Name   => 'Multiselect: UTF8 template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {
                DynamicField_MultiselectField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        Success         => 1,
    },
    {
        Name   => 'Multiselect: empty template and UTF8 ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_MultiselectField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => ['äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß'],
        Success         => 1,
    },
    {
        Name   => 'Multiselect: Empty template and no ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Multiselect},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Multiselect: Empty template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Multiselect},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => [],
        Success         => 1,
    },
    {
        Name   => 'Multiselect: UTF8 template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {
                DynamicField_MultiselectField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Multiselect: empty template and UTF8 ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_MultiselectField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => ['äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß'],
    },
    {
        Name   => 'Multiselect: Empty template and no ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Multiselect},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_MultiselectField => undef,
        },

        Success => 1,
    },
    {
        Name   => 'Multiselect: Empty template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Multiselect},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_MultiselectField => [],
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: UTF8 template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {
                DynamicField_MultiselectField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_MultiselectField =>
                'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: empty template and UTF8 ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_MultiselectField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_MultiselectField =>
                ['äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß'],
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: UTF8 template and empty ParamObject (Normal MultiValue)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {
                DynamicField_MultiselectField =>
                    [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
        Success => 1,
    },
    {
        Name   => 'Multiselect: empty template and UTF8 ParamObject (Normal MultiValue)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_MultiselectField =>
                    [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
        Success => 1,
    },
    {
        Name   => 'Multiselect: UTF8 template and empty ParamObject (ValueStructure MultiValue)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {
                DynamicField_MultiselectField =>
                    [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 1,
        ExpectedResults => [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
    },
    {
        Name   => 'Multiselect: empty template and UTF8 ParamObject (ValueStructure MultiValue)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_MultiselectField =>
                    [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 1,
        ExpectedResults => [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
    },
    {
        Name   => 'Multiselect: UTF8 template and empty ParamObject (TemplateStructure MultiValue)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {
                DynamicField_MultiselectField =>
                    [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_MultiselectField =>
                [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: empty template and UTF8 ParamObject (TemplateStructure MultiValue)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_MultiselectField =>
                    [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_MultiselectField =>
                [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
        },
        Success => 1,
    },

    # Dynamic Field DateTime
    {
        Name   => 'DateTime: Empty template and no ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{DateTime},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Empty template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{DateTime},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Wrong template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => '0000-00-00 00:00:00',
    },
    {
        Name   => 'DateTime: Correct template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeFieldUsed   => 1,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '2013-08-21 16:45:00',
        Success         => 1,
    },
    {
        Name   => 'DateTime: empty template and Wrong ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '0000-00-00 00:00:00',
        Success         => 1,
    },
    {
        Name   => 'DateTime: empty template and Correct ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeFieldUsed   => 1,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '2013-08-21 16:45:00',
        Success         => 1,
    },
    {
        Name   => 'DateTime: Empty template and no ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{DateTime},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Empty template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{DateTime},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Wrong template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 1,
            DynamicField_DateTimeFieldYear   => 0,
            DynamicField_DateTimeFieldMonth  => 0,
            DynamicField_DateTimeFieldDay    => 0,
            DynamicField_DateTimeFieldHour   => 0,
            DynamicField_DateTimeFieldMinute => 0,
        },
    },
    {
        Name   => 'DateTime: Correct template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeFieldUsed   => 1,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 1,
            DynamicField_DateTimeFieldYear   => 2013,
            DynamicField_DateTimeFieldMonth  => 8,
            DynamicField_DateTimeFieldDay    => 21,
            DynamicField_DateTimeFieldHour   => 16,
            DynamicField_DateTimeFieldMinute => 45,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: empty template and Wrong ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 1,
            DynamicField_DateTimeFieldYear   => 0,
            DynamicField_DateTimeFieldMonth  => 0,
            DynamicField_DateTimeFieldDay    => 0,
            DynamicField_DateTimeFieldHour   => 0,
            DynamicField_DateTimeFieldMinute => 0,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: empty template and Correct ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeFieldUsed   => 1,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 1,
            DynamicField_DateTimeFieldYear   => 2013,
            DynamicField_DateTimeFieldMonth  => 8,
            DynamicField_DateTimeFieldDay    => 21,
            DynamicField_DateTimeFieldHour   => 16,
            DynamicField_DateTimeFieldMinute => 45,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: Empty template and no ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{DateTime},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Empty template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{DateTime},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Wrong template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        Success         => 1,
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 1,
            DynamicField_DateTimeFieldYear   => 0,
            DynamicField_DateTimeFieldMonth  => 0,
            DynamicField_DateTimeFieldDay    => 0,
            DynamicField_DateTimeFieldHour   => 0,
            DynamicField_DateTimeFieldMinute => 0,
        },
    },
    {
        Name   => 'DateTime: Correct template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeFieldUsed   => 1,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 1,
            DynamicField_DateTimeFieldYear   => 2013,
            DynamicField_DateTimeFieldMonth  => 8,
            DynamicField_DateTimeFieldDay    => 21,
            DynamicField_DateTimeFieldHour   => 16,
            DynamicField_DateTimeFieldMinute => 45,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: empty template and Wrong ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 1,
            DynamicField_DateTimeFieldYear   => 0,
            DynamicField_DateTimeFieldMonth  => 0,
            DynamicField_DateTimeFieldDay    => 0,
            DynamicField_DateTimeFieldHour   => 0,
            DynamicField_DateTimeFieldMinute => 0,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: empty template and Correct ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeFieldUsed   => 1,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 1,
            DynamicField_DateTimeFieldYear   => 2013,
            DynamicField_DateTimeFieldMonth  => 8,
            DynamicField_DateTimeFieldDay    => 21,
            DynamicField_DateTimeFieldHour   => 16,
            DynamicField_DateTimeFieldMinute => 45,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: Wrong template and empty ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Correct template and empty ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeFieldUsed   => 0,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '',
        Success         => 1,
    },
    {
        Name   => 'DateTime: empty template and Wrong ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: empty template and Correct ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeFieldUsed   => 0,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '',
        Success         => 1,
    },
    {
        Name   => 'DateTime: Wrong template and empty ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Correct template and empty ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeFieldUsed   => 0,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 0,
            DynamicField_DateTimeFieldYear   => 2013,
            DynamicField_DateTimeFieldMonth  => 8,
            DynamicField_DateTimeFieldDay    => 21,
            DynamicField_DateTimeFieldHour   => 16,
            DynamicField_DateTimeFieldMinute => 45,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: empty template and Wrong ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: empty template and Correct ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeFieldUsed   => 0,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 0,
            DynamicField_DateTimeFieldYear   => 2013,
            DynamicField_DateTimeFieldMonth  => 8,
            DynamicField_DateTimeFieldDay    => 21,
            DynamicField_DateTimeFieldHour   => 16,
            DynamicField_DateTimeFieldMinute => 45,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: Wrong template and empty ParamObject (TemplateStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Correct template and empty ParamObject (TemplateStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeFieldUsed   => 0,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 0,
            DynamicField_DateTimeFieldYear   => 2013,
            DynamicField_DateTimeFieldMonth  => 8,
            DynamicField_DateTimeFieldDay    => 21,
            DynamicField_DateTimeFieldHour   => 16,
            DynamicField_DateTimeFieldMinute => 45,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: empty template and Wrong ParamObject (TemplateStructure NotUsed)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 0,
            DynamicField_DateTimeFieldYear   => 0,
            DynamicField_DateTimeFieldMonth  => 0,
            DynamicField_DateTimeFieldDay    => 0,
            DynamicField_DateTimeFieldHour   => 0,
            DynamicField_DateTimeFieldMinute => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: empty template and Correct ParamObject (TemplateStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeFieldUsed   => 0,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 0,
            DynamicField_DateTimeFieldYear   => 2013,
            DynamicField_DateTimeFieldMonth  => 8,
            DynamicField_DateTimeFieldDay    => 21,
            DynamicField_DateTimeFieldHour   => 16,
            DynamicField_DateTimeFieldMinute => 45,
        },
        Success => 1,
    },

    # Dynamic Field Date
    {
        Name   => 'Date: Empty template and no ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Date},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Empty template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Date},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Wrong template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => '0000-00-00 00:00:00',
    },
    {
        Name   => 'Date: Correct template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateFieldUsed  => 1,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '2013-08-21 00:00:00',
        Success         => 1,
    },
    {
        Name   => 'Date: empty template and Wrong ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '0000-00-00 00:00:00',
        Success         => 1,
    },
    {
        Name   => 'Date: empty template and Correct ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateFieldUsed  => 1,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '2013-08-21 00:00:00',
        Success         => 1,
    },
    {
        Name   => 'Date: Empty template and no ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Date},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Empty template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Date},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Wrong template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => {
            DynamicField_DateFieldUsed   => 1,
            DynamicField_DateFieldYear   => 0,
            DynamicField_DateFieldMonth  => 0,
            DynamicField_DateFieldDay    => 0,
            DynamicField_DateFieldHour   => 0,
            DynamicField_DateFieldMinute => 0,
        },
    },
    {
        Name   => 'Date: Correct template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateFieldUsed  => 1,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed   => 1,
            DynamicField_DateFieldYear   => 2013,
            DynamicField_DateFieldMonth  => 8,
            DynamicField_DateFieldDay    => 21,
            DynamicField_DateFieldHour   => 0,
            DynamicField_DateFieldMinute => 0,
        },
        Success => 1,
    },
    {
        Name   => 'Date: empty template and Wrong ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed   => 1,
            DynamicField_DateFieldYear   => 0,
            DynamicField_DateFieldMonth  => 0,
            DynamicField_DateFieldDay    => 0,
            DynamicField_DateFieldHour   => 0,
            DynamicField_DateFieldMinute => 0,
        },
        Success => 1,
    },
    {
        Name   => 'Date: empty template and Correct ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateFieldUsed  => 1,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed   => 1,
            DynamicField_DateFieldYear   => 2013,
            DynamicField_DateFieldMonth  => 8,
            DynamicField_DateFieldDay    => 21,
            DynamicField_DateFieldHour   => 0,
            DynamicField_DateFieldMinute => 0,
        },
        Success => 1,
    },
    {
        Name   => 'Date: Empty template and no ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Date},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Empty template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Date},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Wrong template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        Success         => 1,
        ExpectedResults => {
            DynamicField_DateFieldUsed   => 1,
            DynamicField_DateFieldYear   => 0,
            DynamicField_DateFieldMonth  => 0,
            DynamicField_DateFieldDay    => 0,
            DynamicField_DateFieldHour   => 0,
            DynamicField_DateFieldMinute => 0,
        },
    },
    {
        Name   => 'Date: Correct template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateFieldUsed  => 1,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed   => 1,
            DynamicField_DateFieldYear   => 2013,
            DynamicField_DateFieldMonth  => 8,
            DynamicField_DateFieldDay    => 21,
            DynamicField_DateFieldHour   => 0,
            DynamicField_DateFieldMinute => 0,
        },
        Success => 1,
    },
    {
        Name   => 'Date: empty template and Wrong ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed   => 1,
            DynamicField_DateFieldYear   => 0,
            DynamicField_DateFieldMonth  => 0,
            DynamicField_DateFieldDay    => 0,
            DynamicField_DateFieldHour   => 0,
            DynamicField_DateFieldMinute => 0,
        },
        Success => 1,
    },
    {
        Name   => 'Date: empty template and Correct ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateFieldUsed  => 1,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed   => 1,
            DynamicField_DateFieldYear   => 2013,
            DynamicField_DateFieldMonth  => 8,
            DynamicField_DateFieldDay    => 21,
            DynamicField_DateFieldHour   => 0,
            DynamicField_DateFieldMinute => 0,
        },
        Success => 1,
    },
    {
        Name   => 'Date: Wrong template and empty ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Correct template and empty ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateFieldUsed  => 0,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '',
        Success         => 1,
    },
    {
        Name   => 'Date: empty template and Wrong ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: empty template and Correct ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateFieldUsed  => 0,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '',
        Success         => 1,
    },
    {
        Name   => 'Date: Wrong template and empty ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Correct template and empty ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateFieldUsed  => 0,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed   => 0,
            DynamicField_DateFieldYear   => 2013,
            DynamicField_DateFieldMonth  => 8,
            DynamicField_DateFieldDay    => 21,
            DynamicField_DateFieldHour   => 0,
            DynamicField_DateFieldMinute => 0,
        },
        Success => 1,
    },
    {
        Name   => 'Date: empty template and Wrong ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: empty template and Correct ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateFieldUsed  => 0,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed   => 0,
            DynamicField_DateFieldYear   => 2013,
            DynamicField_DateFieldMonth  => 8,
            DynamicField_DateFieldDay    => 21,
            DynamicField_DateFieldHour   => 0,
            DynamicField_DateFieldMinute => 0,
        },
        Success => 1,
    },
    {
        Name   => 'Date: Wrong template and empty ParamObject (TemplateStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Correct template and empty ParamObject (TemplateStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateFieldUsed  => 0,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed   => 0,
            DynamicField_DateFieldYear   => 2013,
            DynamicField_DateFieldMonth  => 8,
            DynamicField_DateFieldDay    => 21,
            DynamicField_DateFieldHour   => 0,
            DynamicField_DateFieldMinute => 0,
        },
        Success => 1,
    },
    {
        Name   => 'Date: empty template and Wrong ParamObject (TemplateStructure NotUsed)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed   => 0,
            DynamicField_DateFieldYear   => 0,
            DynamicField_DateFieldMonth  => 0,
            DynamicField_DateFieldDay    => 0,
            DynamicField_DateFieldHour   => 0,
            DynamicField_DateFieldMinute => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: empty template and Correct ParamObject (TemplateStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateFieldUsed  => 0,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed   => 0,
            DynamicField_DateFieldYear   => 2013,
            DynamicField_DateFieldMonth  => 8,
            DynamicField_DateFieldDay    => 21,
            DynamicField_DateFieldHour   => 0,
            DynamicField_DateFieldMinute => 0,
        },
        Success => 1,
    },
);

# execute tests
for my $Test (@Tests) {

    my $Value;

    if ( IsHashRefWithData( $Test->{Config} ) ) {
        my %Config = %{ $Test->{Config} };

        if ( IsHashRefWithData( $Test->{Config}->{CGIParam} ) ) {

            # creatate a new CGI object to simulate a web request
            my $WebRequest = new CGI( $Test->{Config}->{CGIParam} );

            my $LocalParamObject = Kernel::System::Web::Request->new(
                %{$Self},
                WebRequest => $WebRequest,
            );

            %Config = (
                %Config,
                ParamObject => $LocalParamObject,
            );
        }
        $Value = $DFBackendObject->EditFieldValueGet(%Config);
    }
    else {
        $Value = $DFBackendObject->EditFieldValueGet( %{ $Test->{Config} } );
    }
    if ( $Test->{Success} ) {
        $Self->IsDeeply(
            $Value,
            $Test->{ExpectedResults},
            "$Test->{Name} | EditFieldValueLGet()",
        );
    }
    else {
        $Self->Is(
            $Value,
            undef,
            "$Test->{Name} | EditFieldValueLGet() (should be undef)",
        );
    }
}

# we don't need any cleanup
1;
