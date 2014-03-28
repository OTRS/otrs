# --
# ValueValidate.t - ValueValidate backend tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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
use Kernel::System::Time;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);
my $TimeObject = Kernel::System::Time->new(
    %$Self,
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
            DefaultValue => '',
            Link         => '',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    TextRegexA => {
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
            RegExList    => [
                {
                    Value        => '^[0-9]+$',
                    ErrorMessage => 'number',
                },
                {
                    Value        => '^[0-9]{5}$',
                    ErrorMessage => 'number5',
                },
            ],
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
    DateTimeOnlyPast => {
        ID            => 123,
        InternalField => 0,
        Name          => 'DateTimeField',
        Label         => 'DateTimeField',
        FieldOrder    => 123,
        FieldType     => 'DateTime',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue    => '',
            Link            => '',
            YearsPeriod     => '',
            YearsInFuture   => '',
            YearsInPast     => '',
            DateRestriction => 'DisableFutureDates',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    DateTimeOnlyFuture => {
        ID            => 123,
        InternalField => 0,
        Name          => 'DateTimeField',
        Label         => 'DateTimeField',
        FieldOrder    => 123,
        FieldType     => 'DateTime',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue    => '',
            Link            => '',
            YearsPeriod     => '',
            YearsInFuture   => '',
            YearsInPast     => '',
            DateRestriction => 'DisablePastDates',
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
    DateOnlyPast => {
        ID            => 123,
        InternalField => 0,
        Name          => 'DateField',
        Label         => 'DateField',
        FieldOrder    => 123,
        FieldType     => 'Date',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue    => '',
            Link            => '',
            YearsPeriod     => '',
            YearsInFuture   => '',
            YearsInPast     => '',
            DateRestriction => 'DisableFutureDates',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    DateOnlyFuture => {
        ID            => 123,
        InternalField => 0,
        Name          => 'DateField',
        Label         => 'DateField',
        FieldOrder    => 123,
        FieldType     => 'Date',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue    => '',
            Link            => '',
            YearsPeriod     => '',
            YearsInFuture   => '',
            YearsInPast     => '',
            DateRestriction => 'DisablePastDates',
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
        Name   => 'Missing UserID',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
        },
        Success => 0,
    },
    {
        Name   => 'Missing Value Text',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value              => undef,
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value TextArea',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value              => undef,
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value Checkbox',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value              => undef,
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => undef,
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => undef,
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => undef,
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value DateTime',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => undef,
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'UTF8 Value Text',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value              => 'ÁäñƱƩ⨅ß',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'UTF8 Value TextArea',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value              => 'Line1\nÁäñƱƩ⨅ß\nLine3',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Value 1 Checkbox',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value              => 1,
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Value Text Checkbox',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value              => 'Text',
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Long Value Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => 'Looooooooooooooooooooooooooooong',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Single Value Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => 'Value1',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Multiple Values Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => [ 'Value1', 'Value2' ],
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Correct Date Value Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '1977-12-12 00:00:00',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Incorrect Date Value Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '2013-02-31 00:00:00',
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Text Value Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => 'Text',
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Number Value Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => 1,
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Correct DateTime Value DateTime',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '1977-12-12 12:59:32',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Incorrect Date Value DateTime',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '2013-02-31 56:00:28',
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Correct Value Date Zero Hour',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '1970-01-01 00:00:00',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Correct Value Date + Second',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '1970-01-01 00:00:01',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Correct Value Date + Hour',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '1970-01-01 01:00:00',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Correct Value Date - Second',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '1969-12-31 23:59:59',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Correct Value Date - Hour',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '1969-12-31 23:00:00',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Text Value DateTime',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => 'Text',
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Number Value DateTime',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => 1,
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Correct Value Date (input value)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '2013-01-01 00:00:00',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Correct Value Date (search value)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '2013-01-01 23:59:59',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Incorrect Value Date (search value)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '2013-01-01 12:00:00',
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name =>
            'Incorrect future date for datetime field which only allow old dates (search value)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTimeOnlyPast},
            Value              => $TimeObject->SystemTime2TimeStamp(
                SystemTime => $TimeObject->SystemTime() + 8000,
            ),
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Correct old date for datetime field which only allow old dates (search value)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTimeOnlyPast},
            Value              => $TimeObject->SystemTime2TimeStamp(
                SystemTime => $TimeObject->SystemTime() - 8000,
            ),
            UserID => $UserID,
        },
        Success => 1,
    },
    {
        Name =>
            'Correct future date for datetime field which only allow future dates (search value)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTimeOnlyFuture},
            Value              => $TimeObject->SystemTime2TimeStamp(
                SystemTime => $TimeObject->SystemTime() + 8000,
            ),
            UserID => $UserID,
        },
        Success => 1,
    },
    {
        Name =>
            'Incorrect old date for datetime field which only allow future dates (search value)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTimeOnlyFuture},
            Value              => $TimeObject->SystemTime2TimeStamp(
                SystemTime => $TimeObject->SystemTime() - 8000,
            ),
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Incorrect future date for date field which only allow old dates (search value)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateOnlyPast},
            Value              => (
                split(
                    /\s/,
                    $TimeObject->SystemTime2TimeStamp(
                        SystemTime => $TimeObject->SystemTime() + 259200,
                        )
                    )
                )[0]
                . " 00:00:00",
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Correct old date for date field which only allow old dates (search value)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateOnlyPast},
            Value              => (
                split(
                    /\s/,
                    $TimeObject->SystemTime2TimeStamp(
                        SystemTime => $TimeObject->SystemTime() - 259200,
                        )
                    )
                )[0]
                . " 00:00:00",
            UserID => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Correct future date for date field which only allow future dates (search value)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateOnlyFuture},
            Value              => (
                split(
                    /\s/,
                    $TimeObject->SystemTime2TimeStamp(
                        SystemTime => $TimeObject->SystemTime() + 259200,
                        )
                    )
                )[0]
                . " 00:00:00",
            UserID => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Incorrect old date for date field which only allow future dates (search value)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateOnlyFuture},
            Value              => (
                split(
                    /\s/,
                    $TimeObject->SystemTime2TimeStamp(
                        SystemTime => $TimeObject->SystemTime() - 259200,
                        )
                    )
                )[0]
                . " 00:00:00",
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Text with regular expression (numbers only) filled with numbers and text',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextRegexA},
            Value              => 'a1234',
            UserID             => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Text with regular expression (numbers only) filled with 4 numbers',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextRegexA},
            Value              => '12345',
            UserID             => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'Text with regular expression (numbers only) filled with 6 numbers',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextRegexA},
            Value              => '123456',
            UserID             => $UserID,
        },
        Success => 0,
    },
);

# UTC tests
local $ENV{TZ} = 'UTC';

# execute tests
for my $Test (@Tests) {
    my $Success = $DFBackendObject->ValueValidate( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->Is(
            $Success,
            1,
            "$Test->{Name} | ValueValidate()",
        );
    }
    else {
        $Self->Is(
            $Success,
            undef,
            "$Test->{Name} | ValueValidate() (should be undef)",
        );
    }
}

# we don't need any cleanup
1;
