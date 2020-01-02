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

my $DFBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

my $ActivityObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');
my $ProcessObject  = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $UserID   = 1;
my $RandomID = $Helper->GetRandomID();

my %ProcessLookup = (
    'EntityID-1' . $RandomID => 'Process-1' . $RandomID,
    'EntityID-2' . $RandomID => 'Process-2' . $RandomID,
    'EntityID-3' . $RandomID => 'Process-3' . $RandomID,
);
my $ActivityEntityID       = 'A1-' . $RandomID;
my $ActivityDialogEntityID = 'AD1-' . $RandomID;

for my $Process ( sort keys %ProcessLookup ) {
    my $ProcessID = $ProcessObject->ProcessAdd(
        EntityID      => $Process,
        Name          => $ProcessLookup{$Process},
        StateEntityID => 'S1',
        Layout        => {},
        Config        => {
            Description => 'a Description',
            Path        => {
                $ActivityEntityID => {},
            }
        },
        UserID => $UserID,
    );

    $Self->True(
        $ProcessID,
        "Process is created - $ProcessID.",
    );

}

my %ActivityLookup = (
    'EntityID-1' . $RandomID => 'Activity-1' . $RandomID,
    'EntityID-2' . $RandomID => 'Activity-2' . $RandomID,
    'EntityID-3' . $RandomID => 'Activity-3' . $RandomID,
);

for my $Activity ( sort keys %ActivityLookup ) {
    my $ActivityID = $ActivityObject->ActivityAdd(
        EntityID => $Activity,
        Name     => $ActivityLookup{$Activity},
        Config   => {
            ActivityDialog => {
                1 => $ActivityDialogEntityID,
            },
        },
        UserID => $UserID,
    );

    $Self->True(
        $ActivityID,
        "Activity is created - $ActivityID.",
    );
}

my $DynamicFieldProcessID = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
    Name => 'ProcessManagementProcessID',
);

my $DynamicFieldActivityID = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
    Name => 'ProcessManagementActivityID',
);

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

    # text dynamic field
    {
        Name   => 'Text UTF8 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value              => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        ExpectedResults => {
            Equals => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
    },
    {
        Name   => 'Text UTF8 Wildcard DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value              => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß*',

        },
        ExpectedResults => {
            Like => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß*',
        },
    },

    # textarea dynamic field
    {
        Name   => 'TextArea UTF8 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value              => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        ExpectedResults => {
            Equals => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
    },
    {
        Name   => 'TextArea UTF8 Wildcard DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value              => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß*',
        },
        ExpectedResults => {
            Like => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß*',
        },
    },

    # checkbox dynamic field
    {
        Name   => 'Checkbox 1 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value              => 1,
        },
        ExpectedResults => {
            Equals => 1,
        },
    },
    {
        Name   => 'Checkbox -1 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value              => -1,
        },
        ExpectedResults => {
            Equals => 0,
        },
    },
    {
        Name   => 'Checkbox -1, 1 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value              => [ -1, 1 ],
        },
        ExpectedResults => {
            Equals => [ 0, 1, ],
        },
    },

    # dropdown dynamic field
    {
        Name   => 'Dropdown 1 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => 1,
        },
        ExpectedResults => {
            Equals => 1,
        },
    },
    {
        Name   => 'Dropdown 1,2 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => [ 1, 2, ],
        },
        ExpectedResults => {
            Equals => [ 1, 2, ],
        },
    },

    # multiselect dynamic field
    {
        Name   => 'Multiselect 1 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => 1,
        },
        ExpectedResults => {
            Equals => 1,
        },
    },
    {
        Name   => 'Multiselect 1,2 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => [ 1, 2, ],
        },
        ExpectedResults => {
            Equals => [ 1, 2, ],
        },
    },

    # date dynamic field
    {
        Name   => 'Date TimePoint missing Operator',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '2016-05-01 00:00:00',
            Operator           => '',
        },
        ExpectedResults => {},
    },
    {
        Name   => 'Date TimePoint (SmallerThanEquals) DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '2015-05-01 23:59:59',
            Operator           => 'SmallerThanEquals',
        },
        ExpectedResults => {
            SmallerThanEquals => '2015-05-01 23:59:59',
        },
    },
    {
        Name   => 'Date TimePoint (GreaterThanEquals) DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '2015-05-01 00:00:00',
            Operator           => 'GreaterThanEquals',
        },
        ExpectedResults => {
            GreaterThanEquals => '2015-05-01 00:00:00',
        },
    },
    {
        Name   => 'Date TimePoint (SmallerThanEquals) with a not allowed hour DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '2015-05-01 01:00:00',
            Operator           => 'SmallerThanEquals',
        },
        ExpectedResults => {
            SmallerThanEquals => '2015-05-01 23:59:59',
        },
    },
    {
        Name   => 'Date TimePoint (GreaterThanEquals) with a not allowed hour DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '2015-05-01 10:00:00',
            Operator           => 'GreaterThanEquals',
        },
        ExpectedResults => {
            GreaterThanEquals => '2015-05-01 00:00:00',
        },
    },

    # date time dynamic field
    {
        Name   => 'Date TimePoint missing Operator',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '2016-05-01 00:00:00',
            Operator           => '',
        },
        ExpectedResults => {},
    },
    {
        Name   => 'Date TimePoint (SmallerThanEquals) DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '2015-05-01 20:30:00',
            Operator           => 'SmallerThanEquals',
        },
        ExpectedResults => {
            SmallerThanEquals => '2015-05-01 20:30:00',
        },
    },
    {
        Name   => 'Date TimePoint (GreaterThanEquals) DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '2015-05-01 02:15:00',
            Operator           => 'GreaterThanEquals',
        },
        ExpectedResults => {
            GreaterThanEquals => '2015-05-01 02:15:00',
        },
    },
    {
        Name   => 'ProcessManagementProcessID DF tets 1',
        Config => {
            DynamicFieldConfig => $DynamicFieldProcessID,
            Value              => $RandomID,
        },
        ExpectedResults => {
            Equals => [ sort keys %ProcessLookup, $RandomID ],
        },
    },
    {
        Name   => 'ProcessManagementProcessID DF tets 2',
        Config => {
            DynamicFieldConfig => $DynamicFieldProcessID,
            Value              => 'Process-1' . $RandomID,
        },
        ExpectedResults => {
            Equals => [ 'EntityID-1' . $RandomID, 'Process-1' . $RandomID ],
        },
    },
    {
        Name   => 'ProcessManagementProcessID DF tets 3',
        Config => {
            DynamicFieldConfig => $DynamicFieldProcessID,
            Value              => 'Process-2' . $RandomID,
        },
        ExpectedResults => {
            Equals => [ 'EntityID-2' . $RandomID, 'Process-2' . $RandomID ],
        },
    },
    {
        Name   => 'ProcessManagementProcessID DF tets 4',
        Config => {
            DynamicFieldConfig => $DynamicFieldProcessID,
            Value              => 'Process-3' . $RandomID,
        },
        ExpectedResults => {
            Equals => [ 'EntityID-3' . $RandomID, 'Process-3' . $RandomID ],
        },
    },
    {
        Name   => 'ProcessManagementProcessID DF tets 5',
        Config => {
            DynamicFieldConfig => $DynamicFieldProcessID,
            Value              => "*$RandomID",
        },
        ExpectedResults => {
            Like => [ ( sort keys %ProcessLookup ), "*$RandomID" ],
        },
    },
    {
        Name   => 'ProcessManagementActivityID DF tets 1',
        Config => {
            DynamicFieldConfig => $DynamicFieldActivityID,
            Value              => $RandomID,
        },
        ExpectedResults => {
            Equals => [ sort keys %ActivityLookup, $RandomID ],
        },
    },
    {
        Name   => 'ProcessManagementActivityID DF tets 2',
        Config => {
            DynamicFieldConfig => $DynamicFieldActivityID,
            Value              => 'Activity-1' . $RandomID,
        },
        ExpectedResults => {
            Equals => [ 'EntityID-1' . $RandomID, 'Activity-1' . $RandomID ],
        },
    },
    {
        Name   => 'ProcessManagementActivityID DF tets 3',
        Config => {
            DynamicFieldConfig => $DynamicFieldActivityID,
            Value              => 'Activity-2' . $RandomID,
        },
        ExpectedResults => {
            Equals => [ 'EntityID-2' . $RandomID, 'Activity-2' . $RandomID ],
        },
    },
    {
        Name   => 'ProcessManagementActivityID DF tets 4',
        Config => {
            DynamicFieldConfig => $DynamicFieldActivityID,
            Value              => 'Activity-3' . $RandomID,
        },
        ExpectedResults => {
            Equals => [ 'EntityID-3' . $RandomID, 'Activity-3' . $RandomID ],
        },
    },
    {
        Name   => 'ProcessManagementActivityID DF tets 5',
        Config => {
            DynamicFieldConfig => $DynamicFieldActivityID,
            Value              => "*$RandomID",
        },
        ExpectedResults => {
            Like => [ ( sort keys %ActivityLookup ), "*$RandomID" ],
        },
    },
);

# execute tests
for my $Test (@Tests) {

    my $Result = $DFBackendObject->StatsSearchFieldParameterBuild( %{ $Test->{Config} } );

    $Self->IsDeeply(
        $Result,
        $Test->{ExpectedResults},
        "$Test->{Name} | StatsSearchFieldParameterBuild()",
    );
}

# we don't need any cleanup

1;
