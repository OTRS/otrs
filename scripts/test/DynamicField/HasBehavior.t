# --
# HasBehavior.t - HasBehavior backend tests
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
    },
    {
        Name   => 'DynamicField Text',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
        },
        ExpectedResults => {
            'IsACLReducible'               => 0,
            'IsNotificationEventCondition' => 1,
            'IsSortable'                   => 1,
            'IsStatsCondition'             => 1,
            'IsCustomerInterfaceCapable'   => 1,
        },
    },
    {
        Name   => 'DynamicField Text Area',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
        },
        ExpectedResults => {
            'IsACLReducible'               => 0,
            'IsNotificationEventCondition' => 1,
            'IsSortable'                   => 0,
            'IsStatsCondition'             => 1,
            'IsCustomerInterfaceCapable'   => 1,
        },
    },
    {
        Name   => 'DynamicField Checkbox',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
        },
        ExpectedResults => {
            'IsACLReducible'               => 0,
            'IsNotificationEventCondition' => 1,
            'IsSortable'                   => 1,
            'IsStatsCondition'             => 1,
            'IsCustomerInterfaceCapable'   => 1,
        },
    },
    {
        Name   => 'DynamicField Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
        },
        ExpectedResults => {
            'IsACLReducible'               => 1,
            'IsNotificationEventCondition' => 1,
            'IsSortable'                   => 1,
            'IsStatsCondition'             => 1,
            'IsCustomerInterfaceCapable'   => 1,
        },
    },
    {
        Name   => 'DynamicField Miltiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
        },
        ExpectedResults => {
            'IsACLReducible'               => 1,
            'IsNotificationEventCondition' => 1,
            'IsSortable'                   => 0,
            'IsStatsCondition'             => 1,
            'IsCustomerInterfaceCapable'   => 1,
        },
    },
    {
        Name   => 'DynamicField DateTime',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
        },
        ExpectedResults => {
            'IsACLReducible'               => 0,
            'IsNotificationEventCondition' => 0,
            'IsSortable'                   => 1,
            'IsStatsCondition'             => 0,
            'IsCustomerInterfaceCapable'   => 1,
        },
    },
    {
        Name   => 'DynamicField Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
        },
        ExpectedResults => {
            'IsACLReducible'               => 0,
            'IsNotificationEventCondition' => 0,
            'IsSortable'                   => 1,
            'IsStatsCondition'             => 0,
            'IsCustomerInterfaceCapable'   => 1,
        },
    },
);

# execute tests
for my $Test (@Tests) {

    # set known behaviors
    BEHAVIOR:
    for my $Behavior (
        qw(
            IsACLReducible IsNotificationEventCondition IsSortable IsStatsCondition NotExisting
            IsCustomerInterfaceCapable
        )
        )
    {

        # to store the config (also for each behavior)
        my %Config;

        # add the behavior if there is a config where to add it.
        if ( IsHashRefWithData( $Test->{Config} ) ) {
            %Config = (
                %{ $Test->{Config} },
                Behavior => $Behavior,
            );
        }

        # call HasBehavior for each test for each known behavior
        my $Success = $DFBackendObject->HasBehavior( %Config );

        # if the test is a success then check the expected results with true
        if ($Success) {
            $Self->True(
                $Test->{ExpectedResults}->{$Behavior},
                "$Test->{Name} HasBehavior() for $Behavior executed with True",
            );
        }

        # otherwise if there is a DynamicField config check the expected results with false
        else {
            if ( IsHashRefWithData( $Test->{Config}->{DynamicFieldConfig} ) ) {
                $Self->False(
                    $Test->{ExpectedResults}->{$Behavior},
                    "$Test->{Name} HasBehavior() for $Behavior executed with False",
                );
            }

            # if there is no DynamicField config, then it should fail, don't need further checks
            else {
                $Self->True(
                    1,
                    "$Test->{Name} HasBehavior() Should not run on missing configuration",
                );

                # if the tests supposed to fail due to missing essential configuration there is no
                # need to keep testing with other behaviors
                last BEHAVIOR;
            }
        }
    }
}

# we don't need any cleanup
1;