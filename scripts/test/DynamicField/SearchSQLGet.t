# --
# SearchSQLGet.t - SearchSQLGet() backend tests
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
                Equals            => 'Foo',
                GreaterThan       => 'Foo',
                GreaterThanEquals => 'Foo',
                Like              => 'Foo*',
                SmallerThan       => 'Foo',
                SmallerThanEquals => 'Foo',
            },
        },
        ExpectedResult => {
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
        Name   => 'TextArea',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
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
                Equals            => 123,
                GreaterThan       => 123,
                GreaterThanEquals => 123,
                Like              => 123,
                SmallerThan       => 123,
                SmallerThanEquals => 123,
            },
        },
        ExpectedResult => {
            Equals            => " dfv.value_int = 123 ",
            GreaterThan       => undef,
            GreaterThanEquals => undef,
            Like              => undef,
            SmallerThan       => undef,
            SmallerThanEquals => undef,
        },
    },
    {
        Name   => 'Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
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
        Name   => 'Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
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
        Name   => 'DateTime',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
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
                Equals            => 'Foo',
                GreaterThan       => 'Foo',
                GreaterThanEquals => 'Foo',
                Like              => 'Foo*',
                SmallerThan       => 'Foo',
                SmallerThanEquals => 'Foo',
            },
        },
        ExpectedResult => {
            Equals            => " dfv.value_date = 'Foo' ",
            GreaterThan       => " dfv.value_date > 'Foo' ",
            GreaterThanEquals => " dfv.value_date >= 'Foo' ",
            Like              => undef,
            SmallerThan       => " dfv.value_date < 'Foo' ",
            SmallerThanEquals => " dfv.value_date <= 'Foo' ",
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

                # like Operator is very complex and deppends on the DB
                my $SQL = $Self->{DBObject}->QueryCondition(
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
