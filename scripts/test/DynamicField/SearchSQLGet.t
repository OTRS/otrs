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

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $DBObject        = $Kernel::OM->Get('Kernel::System::DB');
my $DFBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

my $UserID = 1;

my $DBType   = $DBObject->{'DB::Type'};
my $IsOracle = $DBType eq 'oracle';

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

# Set expected results depends on database case sensitivity (bug#12657).
my $SearchTerm = "(\'Foo\')";
my $ValueText  = '(dfv.value_text)';

if ( $DBObject->GetDatabaseFunction('CaseSensitive') ) {
    $ValueText  = 'LOWER' . $ValueText;
    $SearchTerm = 'LOWER' . $SearchTerm;
}

# define tests
my @Tests = (
    {
        Name   => 'No Params',
        Config => undef,
    },
    {
        Name   => 'Empty Config',
        Config => {},
    },
    {
        Name   => 'Missing DynamicFieldConfig',
        Config => {
            DynamicFieldConfig => undef,
        },
    },
    {
        Name   => 'Missing TableAlias',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            TableAlias         => undef,
        },
    },
    {
        Name   => 'Missing Operator',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            TableAlias         => 'dfv',
            Operator           => undef,
        },
    },
    {
        Name   => 'Missing SearchTerm',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            TableAlias         => 'dfv',
            Operator           => 'Equals',
            SearchTerm         => undef,
        },
    },
    {
        Name   => 'Wrong Operator',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            TableAlias         => 'dfv',
            Operator           => 'Equal',
            SearchTerm         => 'Foo',
        },
    },
    {
        Name   => 'Text',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            TableAlias         => 'dfv',
            TestOperators      => {
                Empty             => 1,
                Equals            => 'Foo',
                GreaterThan       => 'Foo',
                GreaterThanEquals => 'Foo',
                Like              => 'Foo*',
                SmallerThan       => 'Foo',
                SmallerThanEquals => 'Foo',
            },
        },
        ExpectedResult => {
            Empty             => " dfv.value_text IS NULL ",
            Equals            => " $ValueText = $SearchTerm ",
            GreaterThan       => " $ValueText > $SearchTerm ",
            GreaterThanEquals => " $ValueText >= $SearchTerm ",
            Like              => {
                ColumnKey => 'dfv.value_text',
            },
            SmallerThan       => " $ValueText < $SearchTerm ",
            SmallerThanEquals => " $ValueText <= $SearchTerm ",
        },
    },
    {
        Name   => 'TextArea',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            TableAlias         => 'dfv',
            TestOperators      => {
                Empty             => 1,
                Equals            => 'Foo',
                GreaterThan       => 'Foo',
                GreaterThanEquals => 'Foo',
                Like              => 'Foo*',
                SmallerThan       => 'Foo',
                SmallerThanEquals => 'Foo',
            },
        },
        ExpectedResult => {
            Empty             => " dfv.value_text IS NULL ",
            Equals            => " $ValueText = $SearchTerm ",
            GreaterThan       => " $ValueText > $SearchTerm ",
            GreaterThanEquals => " $ValueText >= $SearchTerm ",
            Like              => {
                ColumnKey => 'dfv.value_text',
            },
            SmallerThan       => " $ValueText < $SearchTerm ",
            SmallerThanEquals => " $ValueText <= $SearchTerm ",
        },
    },
    {
        Name   => 'TextArea Not Empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            TableAlias         => 'dfv',
            TestOperators      => {
                Empty => 0,
            },
        },
        ExpectedResult => {
            Empty => $IsOracle ? " dfv.value_text IS NOT NULL " : " dfv.value_text <> '' ",
        },
    },
    {
        Name   => 'Checkbox Wrong Data',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            TableAlias         => 'dfv',
            TestOperators      => {
                Equals            => 'Foo',
                GreaterThan       => 'Foo',
                GreaterThanEquals => 'Foo',
                Like              => 'Foo*',
                SmallerThan       => 'Foo',
                SmallerThanEquals => 'Foo',
            },
        },
        ExpectedResult => {
            Equals            => undef,
            GreaterThan       => undef,
            GreaterThanEquals => undef,
            Like              => undef,
            SmallerThan       => undef,
            SmallerThanEquals => undef,
        },
    },
    {
        Name   => 'Checkbox',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            TableAlias         => 'dfv',
            TestOperators      => {
                Empty             => 1,
                Equals            => 123,
                GreaterThan       => 123,
                GreaterThanEquals => 123,
                Like              => 123,
                SmallerThan       => 123,
                SmallerThanEquals => 123,
            },
        },
        ExpectedResult => {
            Empty             => " dfv.value_int IS NULL ",
            Equals            => " dfv.value_int = 123 ",
            GreaterThan       => undef,
            GreaterThanEquals => undef,
            Like              => undef,
            SmallerThan       => undef,
            SmallerThanEquals => undef,
        },
    },
    {
        Name   => 'Checkbox Not Empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            TableAlias         => 'dfv',
            TestOperators      => {
                Empty => 0,
            },
        },
        ExpectedResult => {
            Empty => " dfv.value_int IS NOT NULL ",
        },
    },
    {
        Name   => 'Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            TableAlias         => 'dfv',
            TestOperators      => {
                Empty             => 1,
                Equals            => 'Foo',
                GreaterThan       => 'Foo',
                GreaterThanEquals => 'Foo',
                Like              => 'Foo*',
                SmallerThan       => 'Foo',
                SmallerThanEquals => 'Foo',
            },
        },
        ExpectedResult => {
            Empty             => " dfv.value_text IS NULL OR dfv.value_text = '' ",
            Equals            => " dfv.value_text = 'Foo' ",
            GreaterThan       => " dfv.value_text > 'Foo' ",
            GreaterThanEquals => " dfv.value_text >= 'Foo' ",
            Like              => {
                ColumnKey => 'dfv.value_text',
            },
            SmallerThan       => " dfv.value_text < 'Foo' ",
            SmallerThanEquals => " dfv.value_text <= 'Foo' ",
        },
    },
    {
        Name   => 'Dropdown Not Empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            TableAlias         => 'dfv',
            TestOperators      => {
                Empty => 0,
            },
        },
        ExpectedResult => {
            Empty => $IsOracle ? " dfv.value_text IS NOT NULL " : " dfv.value_text <> '' ",
        },
    },
    {
        Name   => 'Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            TableAlias         => 'dfv',
            TestOperators      => {
                Empty             => 1,
                Equals            => 'Foo',
                GreaterThan       => 'Foo',
                GreaterThanEquals => 'Foo',
                Like              => 'Foo*',
                SmallerThan       => 'Foo',
                SmallerThanEquals => 'Foo',
            },
        },
        ExpectedResult => {
            Empty             => " dfv.value_text IS NULL OR dfv.value_text = '' ",
            Equals            => " dfv.value_text = 'Foo' ",
            GreaterThan       => " dfv.value_text > 'Foo' ",
            GreaterThanEquals => " dfv.value_text >= 'Foo' ",
            Like              => {
                ColumnKey => 'dfv.value_text',
            },
            SmallerThan       => " dfv.value_text < 'Foo' ",
            SmallerThanEquals => " dfv.value_text <= 'Foo' ",
        },
    },
    {
        Name   => 'Multiselect Not Empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            TableAlias         => 'dfv',
            TestOperators      => {
                Empty => 0,
            },
        },
        ExpectedResult => {
            Empty => $IsOracle ? " dfv.value_text IS NOT NULL " : " dfv.value_text <> '' ",
        },
    },
    {
        Name   => 'DateTime',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            TableAlias         => 'dfv',
            TestOperators      => {
                Empty             => 1,
                Equals            => 'Foo',
                GreaterThan       => 'Foo',
                GreaterThanEquals => 'Foo',
                Like              => 'Foo*',
                SmallerThan       => 'Foo',
                SmallerThanEquals => 'Foo',
            },
        },
        ExpectedResult => {
            Empty             => " dfv.value_date IS NULL ",
            Equals            => " dfv.value_date = 'Foo' ",
            GreaterThan       => " dfv.value_date > 'Foo' ",
            GreaterThanEquals => " dfv.value_date >= 'Foo' ",
            Like              => undef,
            SmallerThan       => " dfv.value_date < 'Foo' ",
            SmallerThanEquals => " dfv.value_date <= 'Foo' ",
        },
    },
    {
        Name   => 'DateTime Not Empty',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            TableAlias         => 'dfv',
            TestOperators      => {
                Empty => 0,
            },
        },
        ExpectedResult => {
            Empty => " dfv.value_date IS NOT NULL ",
        },
    },
    {
        Name   => 'Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            TableAlias         => 'dfv',
            TestOperators      => {
                Empty             => 1,
                Equals            => 'Foo',
                GreaterThan       => 'Foo',
                GreaterThanEquals => 'Foo',
                Like              => 'Foo*',
                SmallerThan       => 'Foo',
                SmallerThanEquals => 'Foo',
            },
        },
        ExpectedResult => {
            Empty             => " dfv.value_date IS NULL ",
            Equals            => " dfv.value_date = 'Foo' ",
            GreaterThan       => " dfv.value_date > 'Foo' ",
            GreaterThanEquals => " dfv.value_date >= 'Foo' ",
            Like              => undef,
            SmallerThan       => " dfv.value_date < 'Foo' ",
            SmallerThanEquals => " dfv.value_date <= 'Foo' ",
        },
    },
    {
        Name   => 'Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            TableAlias         => 'dfv',
            TestOperators      => {
                Equals            => '2017-01-01',
                GreaterThan       => '2017-01-01',
                GreaterThanEquals => '2017-01-01',
                Like              => '2017-01-01',
                SmallerThan       => '2017-01-01',
                SmallerThanEquals => '2017-01-01',
            },
        },
        ExpectedResult => {
            Equals            => " dfv.value_date = '2017-01-01 00:00:00' ",
            GreaterThan       => " dfv.value_date > '2017-01-01 00:00:00' ",
            GreaterThanEquals => " dfv.value_date >= '2017-01-01 00:00:00' ",
            Like              => undef,
            SmallerThan       => " dfv.value_date < '2017-01-01 00:00:00' ",
            SmallerThanEquals => " dfv.value_date <= '2017-01-01 00:00:00' ",
        },
    },
    {
        Name   => 'Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            TableAlias         => 'dfv',
            TestOperators      => {
                Empty => 0,
            },
        },
        ExpectedResult => {
            Empty => " dfv.value_date IS NOT NULL ",
        },
    },

);

# execute tests
for my $Test (@Tests) {

    if (
        !IsHashRefWithData( $Test->{Config} )
        || !IsHashRefWithData( $Test->{Config}->{TestOperators} )
        )
    {
        my $Result = $DFBackendObject->SearchSQLGet( %{ $Test->{Config} } );

        $Self->Is(
            $Result,
            undef,
            "$Test->{Name} | SearchSQLGet() (should be undef)",
        );
    }
    else {
        for my $Operator ( sort keys %{ $Test->{Config}->{TestOperators} } ) {

            # define the complete config
            my %Config = (
                %{ $Test->{Config} },
                Operator   => $Operator,
                SearchTerm => $Test->{Config}->{TestOperators}->{$Operator},
            );

            # execute the operation
            my $Result = $DFBackendObject->SearchSQLGet(%Config);

            if ( $Operator ne 'Like' || !defined $Test->{ExpectedResult}->{'Like'} ) {
                $Self->Is(
                    $Result,
                    $Test->{ExpectedResult}->{$Operator},
                    "$Test->{Name} | $Operator SearchSQLGet()",
                );
            }
            else {

                # like Operator is very complex and depends on the DB
                my $SQL = $DBObject->QueryCondition(
                    Key   => $Test->{ExpectedResult}->{$Operator}->{ColumnKey},
                    Value => $Config{SearchTerm},
                );
                $Self->Is(
                    $Result,
                    $SQL,
                    "$Test->{Name} | $Operator SearchSQLGet()",
                );
            }
        }
    }
}

# we don't need any cleanup

1;
