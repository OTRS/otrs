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

use CGI;

use Kernel::System::Web::Request;

use Kernel::System::VariableCheck qw(:all);

my $DFBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $ActivityObject  = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');
my $ProcessObject   = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Use a fixed year to compare the time selection results
$Helper->FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2013-12-12 12:00:00',
        },
    )->ToEpoch()
);

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

# there is not really needed to add the dynamic fields for this test, we can define a static
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
        Success => 0,
    },
    {
        Name   => 'Missing Profile',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
        },
        Success => 0,
    },

    # text dynamic field
    {
        Name   => 'Text missing DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Profile            => {},
            CGIParam           => {}
        },
        ExpectedResults => {
            Display   => undef,
            Parameter => {
                Equals => undef,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Text empty DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Profile            => {
                Search_DynamicField_TextField => '',
            },
            CGIParam => {
                Search_DynamicField_TextField => '',
            },

        },
        ExpectedResults => {
            Display   => '',
            Parameter => {
                Equals => '',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Text UTF8 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Profile            => {
                Search_DynamicField_TextField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            CGIParam => {
                Search_DynamicField_TextField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
        },
        ExpectedResults => {
            Display   => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            Parameter => {
                Equals => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Text UTF8 Wildcard DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Profile            => {
                Search_DynamicField_TextField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß*',
            },
            CGIParam => {
                Search_DynamicField_TextField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß*',
            },

        },
        ExpectedResults => {
            Display   => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß*',
            Parameter => {
                Like => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß*',
            },
        },
        Success => 1,
    },

    # text area dynamic field
    {
        Name   => 'TextArea missing DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Profile            => {},
            CGIParam           => {}
        },
        ExpectedResults => {
            Display   => undef,
            Parameter => {
                Equals => undef,
            },
        },
        Success => 1,
    },
    {
        Name   => 'TextArea empty DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Profile            => {
                Search_DynamicField_TextAreaField => '',
            },
            CGIParam => {
                Search_DynamicField_TextAreaField => '',
            },
        },
        ExpectedResults => {
            Display   => '',
            Parameter => {
                Equals => '',
            },
        },
        Success => 1,
    },
    {
        Name   => 'TextArea UTF8 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Profile            => {
                Search_DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            CGIParam => {
                Search_DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
        },
        ExpectedResults => {
            Display   => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            Parameter => {
                Equals => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
        },
        Success => 1,
    },
    {
        Name   => 'TextArea UTF8 Wildcard DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Profile            => {
                Search_DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß*',
            },
            CGIParam => {
                Search_DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß*',
            },
        },
        ExpectedResults => {
            Display   => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß*',
            Parameter => {
                Like => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß*',
            },
        },
        Success => 1,
    },

    # checkbox dynamic field
    {
        Name   => 'Checkbox missing DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Profile            => {},
            CGIParam           => {}
        },
        ExpectedResults => {
            Display   => undef,
            Parameter => {
                Equals => undef,
            },
        },
        ExpectedResultsWebRequest => {
            Display   => '',
            Parameter => {
                Equals => [],
            },
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox empty DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Profile            => {
                Search_DynamicField_CheckboxField => '',
            },
            CGIParam => {
                Search_DynamicField_CheckboxField => '',
            },
        },
        ExpectedResults => {
            Display   => '',
            Parameter => {
                Equals => '',
            },
        },
        ExpectedResultsWebRequest => {
            Display   => '',
            Parameter => {
                Equals => [ '', ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox 1 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Profile            => {
                Search_DynamicField_CheckboxField => 1,
            },
            CGIParam => {
                Search_DynamicField_CheckboxField => 1,
            },
        },
        ExpectedResults => {
            Display   => 'Checked',
            Parameter => {
                Equals => 1,
            },
        },
        ExpectedResultsWebRequest => {
            Display   => 'Checked',
            Parameter => {
                Equals => [ 1, ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox -1 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Profile            => {
                Search_DynamicField_CheckboxField => -1,
            },
            CGIParam => {
                Search_DynamicField_CheckboxField => -1,
            },
        },
        ExpectedResults => {
            Display   => 'Unchecked',
            Parameter => {
                Equals => 0,
            },
        },
        ExpectedResultsWebRequest => {
            Display   => 'Unchecked',
            Parameter => {
                Equals => [ 0, ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox -1, 1 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Profile            => {
                Search_DynamicField_CheckboxField => [ -1, 1 ],
            },
            CGIParam => {
                Search_DynamicField_CheckboxField => [ -1, 1 ],
            },
        },
        ExpectedResults => {
            Display   => 'Unchecked + Checked',
            Parameter => {
                Equals => [ 0, 1, ],
            },
        },
        ExpectedResultsWebRequest => {
            Display   => 'Unchecked + Checked',
            Parameter => {
                Equals => [ 0, 1, ],
            },
        },
        Success => 1,
    },

    # dropdown dynamic field
    {
        Name   => 'Dropdown missing DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Profile            => {},
            CGIParam           => {}
        },
        ExpectedResults => {
            Display   => undef,
            Parameter => {
                Equals => undef,
            },
        },
        ExpectedResultsWebRequest => {
            Display   => '',
            Parameter => {
                Equals => [],
            },
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown empty DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Profile            => {
                Search_DynamicField_DropdownField => '',
            },
            CGIParam => {
                Search_DynamicField_DropdownField => '',
            },
        },
        ExpectedResults => {
            Display   => '',
            Parameter => {
                Equals => '',
            },
        },
        ExpectedResultsWebRequest => {
            Display   => '',
            Parameter => {
                Equals => [ '', ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown 1 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Profile            => {
                Search_DynamicField_DropdownField => 1,
            },
            CGIParam => {
                Search_DynamicField_DropdownField => 1,
            },
        },
        ExpectedResults => {
            Display   => 'A',
            Parameter => {
                Equals => 1,
            },
        },
        ExpectedResultsWebRequest => {
            Display   => 'A',
            Parameter => {
                Equals => [ 1, ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown 1,2 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Profile            => {
                Search_DynamicField_DropdownField => [ 1, 2, ],
            },
            CGIParam => {
                Search_DynamicField_DropdownField => [ 1, 2, ]
            },
        },
        ExpectedResults => {
            Display   => 'A + B',
            Parameter => {
                Equals => [ 1, 2, ],
            },
        },
        ExpectedResultsWebRequest => {
            Display   => 'A + B',
            Parameter => {
                Equals => [ 1, 2, ],
            },
        },
        Success => 1,
    },

    # multiselect dynamic field
    {
        Name   => 'Multiselect missing DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Profile            => {},
            CGIParam           => {}
        },
        ExpectedResults => {
            Display   => undef,
            Parameter => {
                Equals => undef,
            },
        },
        ExpectedResultsWebRequest => {
            Display   => '',
            Parameter => {
                Equals => [],
            },
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect empty DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Profile            => {
                Search_DynamicField_MultiselectField => '',
            },
            CGIParam => {
                Search_DynamicField_MultiselectField => '',
            },
        },
        ExpectedResults => {
            Display   => '',
            Parameter => {
                Equals => '',
            },
        },
        ExpectedResultsWebRequest => {
            Display   => '',
            Parameter => {
                Equals => [ '', ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect 1 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Profile            => {
                Search_DynamicField_MultiselectField => 1,
            },
            CGIParam => {
                Search_DynamicField_MultiselectField => 1,
            },
        },
        ExpectedResults => {
            Display   => 'A',
            Parameter => {
                Equals => 1,
            },
        },
        ExpectedResultsWebRequest => {
            Display   => 'A',
            Parameter => {
                Equals => [ 1, ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect 1,2 DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Profile            => {
                Search_DynamicField_MultiselectField => [ 1, 2, ],
            },
            CGIParam => {
                Search_DynamicField_MultiselectField => [ 1, 2, ]
            },
        },
        ExpectedResults => {
            Display   => 'A + B',
            Parameter => {
                Equals => [ 1, 2, ],
            },
        },
        ExpectedResultsWebRequest => {
            Display   => 'A + B',
            Parameter => {
                Equals => [ 1, 2, ],
            },
        },
        Success => 1,
    },

    # datetime dynamic field
    {
        Name   => 'DateTime TimeSlot missing DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Profile            => {},
            CGIParam           => {},
            Type               => 'TimeSlot'
        },
        ExpectedResults => {
            Display   => undef,
            Parameter => {
                Equals => undef,
            },
        },
        Success => 1,
    },
    {
        Name   => 'DateTime TimeSlot empty DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Profile            => {
                Search_DynamicField_DateTimeFieldTimeSlot            => '1',
                Search_DynamicField_DateTimeFieldTimeSlotStartYear   => '',
                Search_DynamicField_DateTimeFieldTimeSlotStartMonth  => '',
                Search_DynamicField_DateTimeFieldTimeSlotStartDay    => '',
                Search_DynamicField_DateTimeFieldTimeSlotStartHour   => '',
                Search_DynamicField_DateTimeFieldTimeSlotStartMinute => '',
                Search_DynamicField_DateTimeFieldTimeSlotStopYear    => '',
                Search_DynamicField_DateTimeFieldTimeSlotStopMonth   => '',
                Search_DynamicField_DateTimeFieldTimeSlotStopDay     => '',
                Search_DynamicField_DateTimeFieldTimeSlotStopHour    => '',
                Search_DynamicField_DateTimeFieldTimeSlotStopMinute  => '',
            },
            CGIParam => {
                Search_DynamicField_DateTimeFieldTimeSlot            => '1',
                Search_DynamicField_DateTimeFieldTimeSlotStartYear   => '',
                Search_DynamicField_DateTimeFieldTimeSlotStartMonth  => '',
                Search_DynamicField_DateTimeFieldTimeSlotStartDay    => '',
                Search_DynamicField_DateTimeFieldTimeSlotStartHour   => '',
                Search_DynamicField_DateTimeFieldTimeSlotStartMinute => '',
                Search_DynamicField_DateTimeFieldTimeSlotStopYear    => '',
                Search_DynamicField_DateTimeFieldTimeSlotStopMonth   => '',
                Search_DynamicField_DateTimeFieldTimeSlotStopDay     => '',
                Search_DynamicField_DateTimeFieldTimeSlotStopHour    => '',
                Search_DynamicField_DateTimeFieldTimeSlotStopMinute  => '',
            },
            Type => 'TimeSlot',
        },
        ExpectedResults => {
            Display   => undef,
            Parameter => {
                Equals => undef,
            },
        },
        Success => 1,
    },
    {
        Name   => 'DateTime TimeSlot correct date DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Profile            => {
                Search_DynamicField_DateTimeFieldTimeSlot            => '1',
                Search_DynamicField_DateTimeFieldTimeSlotStartYear   => '2013',
                Search_DynamicField_DateTimeFieldTimeSlotStartMonth  => '12',
                Search_DynamicField_DateTimeFieldTimeSlotStartDay    => '12',
                Search_DynamicField_DateTimeFieldTimeSlotStartHour   => '10',
                Search_DynamicField_DateTimeFieldTimeSlotStartMinute => '50',
                Search_DynamicField_DateTimeFieldTimeSlotStopYear    => '2014',
                Search_DynamicField_DateTimeFieldTimeSlotStopMonth   => '12',
                Search_DynamicField_DateTimeFieldTimeSlotStopDay     => '12',
                Search_DynamicField_DateTimeFieldTimeSlotStopHour    => '10',
                Search_DynamicField_DateTimeFieldTimeSlotStopMinute  => '50',
            },
            CGIParam => {
                Search_DynamicField_DateTimeFieldTimeSlot            => '1',
                Search_DynamicField_DateTimeFieldTimeSlotStartYear   => '2013',
                Search_DynamicField_DateTimeFieldTimeSlotStartMonth  => '12',
                Search_DynamicField_DateTimeFieldTimeSlotStartDay    => '12',
                Search_DynamicField_DateTimeFieldTimeSlotStartHour   => '10',
                Search_DynamicField_DateTimeFieldTimeSlotStartMinute => '50',
                Search_DynamicField_DateTimeFieldTimeSlotStopYear    => '2014',
                Search_DynamicField_DateTimeFieldTimeSlotStopMonth   => '12',
                Search_DynamicField_DateTimeFieldTimeSlotStopDay     => '12',
                Search_DynamicField_DateTimeFieldTimeSlotStopHour    => '10',
                Search_DynamicField_DateTimeFieldTimeSlotStopMinute  => '50',
            },
            Type => 'TimeSlot',
        },
        ExpectedResults => {
            Display   => '2013-12-12 10:50:00 - 2014-12-12 10:50:59',
            Parameter => {
                GreaterThanEquals => '2013-12-12 10:50:00',
                SmallerThanEquals => '2014-12-12 10:50:59'
            },
        },
        Success => 1,
    },
    {
        Name   => 'DateTime TimeSlot wrong date DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Profile            => {
                Search_DynamicField_DateTimeFieldTimeSlot            => '1',
                Search_DynamicField_DateTimeFieldTimeSlotStartYear   => '2013',
                Search_DynamicField_DateTimeFieldTimeSlotStartMonth  => '02',
                Search_DynamicField_DateTimeFieldTimeSlotStartDay    => '30',
                Search_DynamicField_DateTimeFieldTimeSlotStartHour   => '10',
                Search_DynamicField_DateTimeFieldTimeSlotStartMinute => '50',
                Search_DynamicField_DateTimeFieldTimeSlotStopYear    => '2014',
                Search_DynamicField_DateTimeFieldTimeSlotStopMonth   => '02',
                Search_DynamicField_DateTimeFieldTimeSlotStopDay     => '30',
                Search_DynamicField_DateTimeFieldTimeSlotStopHour    => '10',
                Search_DynamicField_DateTimeFieldTimeSlotStopMinute  => '50',
            },
            CGIParam => {
                Search_DynamicField_DateTimeFieldTimeSlot            => '1',
                Search_DynamicField_DateTimeFieldTimeSlotStartYear   => '2013',
                Search_DynamicField_DateTimeFieldTimeSlotStartMonth  => '02',
                Search_DynamicField_DateTimeFieldTimeSlotStartDay    => '30',
                Search_DynamicField_DateTimeFieldTimeSlotStartHour   => '10',
                Search_DynamicField_DateTimeFieldTimeSlotStartMinute => '50',
                Search_DynamicField_DateTimeFieldTimeSlotStopYear    => '2014',
                Search_DynamicField_DateTimeFieldTimeSlotStopMonth   => '02',
                Search_DynamicField_DateTimeFieldTimeSlotStopDay     => '30',
                Search_DynamicField_DateTimeFieldTimeSlotStopHour    => '10',
                Search_DynamicField_DateTimeFieldTimeSlotStopMinute  => '50',
            },
            Type => 'TimeSlot',
        },
        ExpectedResults => {
            Display   => '2013-02-30 10:50:00 - 2014-02-30 10:50:59',
            Parameter => {
                GreaterThanEquals => '2013-02-30 10:50:00',
                SmallerThanEquals => '2014-02-30 10:50:59'
            },
        },
        Success => 1,
    },
    {
        Name   => 'DateTime TimePoint missing DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Profile            => {},
            CGIParam           => {},
            Type               => 'TimePoint'
        },
        ExpectedResults => {
            Display   => undef,
            Parameter => {
                Equals => undef,
            },
        },
        Success => 1,
    },
    {
        Name   => 'DateTime TimePoint Before 1 Day DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Profile            => {
                Search_DynamicField_DateTimeFieldTimePoint       => '1',
                Search_DynamicField_DateTimeFieldTimePointStart  => 'Before',
                Search_DynamicField_DateTimeFieldTimePointValue  => '1',
                Search_DynamicField_DateTimeFieldTimePointFormat => 'day',
            },
            CGIParam => {
                Search_DynamicField_DateTimeFieldTimePoint       => '1',
                Search_DynamicField_DateTimeFieldTimePointStart  => 'Before',
                Search_DynamicField_DateTimeFieldTimePointValue  => '1',
                Search_DynamicField_DateTimeFieldTimePointFormat => 'day',
            },
            Type => 'TimePoint',
        },
        ExpectedResults => {
            Display   => '<= 2013-12-11 12:00:00',
            Parameter => {
                SmallerThanEquals => '2013-12-11 12:00:00',
            },
        },
        Success => 1,
    },
    {
        Name   => 'DateTime TimePoint Last 1 Day DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Profile            => {
                Search_DynamicField_DateTimeFieldTimePoint       => '1',
                Search_DynamicField_DateTimeFieldTimePointStart  => 'Last',
                Search_DynamicField_DateTimeFieldTimePointValue  => '1',
                Search_DynamicField_DateTimeFieldTimePointFormat => 'day',
            },
            CGIParam => {
                Search_DynamicField_DateTimeFieldTimePoint       => '1',
                Search_DynamicField_DateTimeFieldTimePointStart  => 'Last',
                Search_DynamicField_DateTimeFieldTimePointValue  => '1',
                Search_DynamicField_DateTimeFieldTimePointFormat => 'day',
            },
            Type => 'TimePoint',
        },
        ExpectedResults => {
            Display   => '2013-12-11 12:00:00 - 2013-12-12 12:00:00',
            Parameter => {
                GreaterThanEquals => '2013-12-11 12:00:00',
                SmallerThanEquals => '2013-12-12 12:00:00',
            },
        },
        Success => 1,
    },
    {
        Name   => 'DateTime TimePoint Next 1 Day DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Profile            => {
                Search_DynamicField_DateTimeFieldTimePoint       => '1',
                Search_DynamicField_DateTimeFieldTimePointStart  => 'Next',
                Search_DynamicField_DateTimeFieldTimePointValue  => '1',
                Search_DynamicField_DateTimeFieldTimePointFormat => 'day',
            },
            CGIParam => {
                Search_DynamicField_DateTimeFieldTimePoint       => '1',
                Search_DynamicField_DateTimeFieldTimePointStart  => 'Next',
                Search_DynamicField_DateTimeFieldTimePointValue  => '1',
                Search_DynamicField_DateTimeFieldTimePointFormat => 'day',
            },
            Type => 'TimePoint',
        },
        ExpectedResults => {
            Display   => '2013-12-12 12:00:00 - 2013-12-13 12:00:00',
            Parameter => {
                GreaterThanEquals => '2013-12-12 12:00:00',
                SmallerThanEquals => '2013-12-13 12:00:00',
            },
        },
        Success => 1,
    },
    {
        Name   => 'DateTime TimePoint After 1 Day DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Profile            => {
                Search_DynamicField_DateTimeFieldTimePoint       => '1',
                Search_DynamicField_DateTimeFieldTimePointStart  => 'After',
                Search_DynamicField_DateTimeFieldTimePointValue  => '1',
                Search_DynamicField_DateTimeFieldTimePointFormat => 'day',
            },
            CGIParam => {
                Search_DynamicField_DateTimeFieldTimePoint       => '1',
                Search_DynamicField_DateTimeFieldTimePointStart  => 'After',
                Search_DynamicField_DateTimeFieldTimePointValue  => '1',
                Search_DynamicField_DateTimeFieldTimePointFormat => 'day',
            },
            Type => 'TimePoint',
        },
        ExpectedResults => {
            Display   => '>= 2013-12-13 12:00:00',
            Parameter => {
                GreaterThanEquals => '2013-12-13 12:00:00',
            },
        },
        Success => 1,
    },

    # date dynamic field
    {
        Name   => 'Date TimeSlot missing DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Profile            => {},
            CGIParam           => {},
            Type               => 'TimeSlot'
        },
        ExpectedResults => {
            Display   => undef,
            Parameter => {
                Equals => undef,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Date TimeSlot empty DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Profile            => {
                Search_DynamicField_DateFieldTimeSlot            => '1',
                Search_DynamicField_DateFieldTimeSlotStartYear   => '',
                Search_DynamicField_DateFieldTimeSlotStartMonth  => '',
                Search_DynamicField_DateFieldTimeSlotStartDay    => '',
                Search_DynamicField_DateFieldTimeSlotStopYear    => '',
                Search_DynamicField_DateFieldTimeSlotStopMonth   => '',
                Search_DynamicField_DateTimeFieldTimeSlotStopDay => '',
            },
            CGIParam => {
                Search_DynamicField_DateFieldTimeSlot           => '1',
                Search_DynamicField_DateFieldTimeSlotStartYear  => '',
                Search_DynamicField_DateFieldTimeSlotStartMonth => '',
                Search_DynamicField_DateFieldTimeSlotStartDay   => '',
                Search_DynamicField_DateFieldTimeSlotStopYear   => '',
                Search_DynamicField_DateFieldTimeSlotStopMonth  => '',
                Search_DynamicField_DateFieldTimeSlotStopDay    => '',
            },
            Type => 'TimeSlot',
        },
        ExpectedResults => {
            Display   => undef,
            Parameter => {
                Equals => undef,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Date TimeSlot correct date DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Profile            => {
                Search_DynamicField_DateFieldTimeSlot           => '1',
                Search_DynamicField_DateFieldTimeSlotStartYear  => '2013',
                Search_DynamicField_DateFieldTimeSlotStartMonth => '12',
                Search_DynamicField_DateFieldTimeSlotStartDay   => '12',
                Search_DynamicField_DateFieldTimeSlotStopYear   => '2014',
                Search_DynamicField_DateFieldTimeSlotStopMonth  => '12',
                Search_DynamicField_DateFieldTimeSlotStopDay    => '12',
            },
            CGIParam => {
                Search_DynamicField_DateFieldTimeSlot           => '1',
                Search_DynamicField_DateFieldTimeSlotStartYear  => '2013',
                Search_DynamicField_DateFieldTimeSlotStartMonth => '12',
                Search_DynamicField_DateFieldTimeSlotStartDay   => '12',
                Search_DynamicField_DateFieldTimeSlotStopYear   => '2014',
                Search_DynamicField_DateFieldTimeSlotStopMonth  => '12',
                Search_DynamicField_DateFieldTimeSlotStopDay    => '12',
            },
            Type => 'TimeSlot',
        },
        ExpectedResults => {
            Display   => '2013-12-12 - 2014-12-12',
            Parameter => {
                GreaterThanEquals => '2013-12-12 00:00:00',
                SmallerThanEquals => '2014-12-12 23:59:59'
            },
        },
        Success => 1,
    },
    {
        Name   => 'Date TimeSlot wrong date DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Profile            => {
                Search_DynamicField_DateFieldTimeSlot           => '1',
                Search_DynamicField_DateFieldTimeSlotStartYear  => '2013',
                Search_DynamicField_DateFieldTimeSlotStartMonth => '02',
                Search_DynamicField_DateFieldTimeSlotStartDay   => '30',
                Search_DynamicField_DateFieldTimeSlotStopYear   => '2014',
                Search_DynamicField_DateFieldTimeSlotStopMonth  => '02',
                Search_DynamicField_DateFieldTimeSlotStopDay    => '30',
            },
            CGIParam => {
                Search_DynamicField_DateFieldTimeSlot           => '1',
                Search_DynamicField_DateFieldTimeSlotStartYear  => '2013',
                Search_DynamicField_DateFieldTimeSlotStartMonth => '02',
                Search_DynamicField_DateFieldTimeSlotStartDay   => '30',
                Search_DynamicField_DateFieldTimeSlotStopYear   => '2014',
                Search_DynamicField_DateFieldTimeSlotStopMonth  => '02',
                Search_DynamicField_DateFieldTimeSlotStopDay    => '30',
            },
            Type => 'TimeSlot',
        },
        ExpectedResults => {
            Display   => '2013-02-30 - 2014-02-30',
            Parameter => {
                GreaterThanEquals => '2013-02-30 00:00:00',
                SmallerThanEquals => '2014-02-30 23:59:59'
            },
        },
        Success => 1,
    },
    {
        Name   => 'Date TimePoint missing DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Profile            => {},
            CGIParam           => {},
            Type               => 'TimePoint'
        },
        ExpectedResults => {
            Display   => undef,
            Parameter => {
                Equals => undef,
            },
        },
        Success => 1,
    },
    {
        Name   => 'Date TimePoint Before 1 Day DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Profile            => {
                Search_DynamicField_DateFieldTimePoint       => '1',
                Search_DynamicField_DateFieldTimePointStart  => 'Before',
                Search_DynamicField_DateFieldTimePointValue  => '1',
                Search_DynamicField_DateFieldTimePointFormat => 'day',
            },
            CGIParam => {
                Search_DynamicField_DateFieldTimePoint       => '1',
                Search_DynamicField_DateFieldTimePointStart  => 'Before',
                Search_DynamicField_DateFieldTimePointValue  => '1',
                Search_DynamicField_DateFieldTimePointFormat => 'day',
            },
            Type => 'TimePoint',
        },
        ExpectedResults => {
            Display   => '< 2013-12-11',
            Parameter => {
                SmallerThan => '2013-12-11 00:00:00',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Date TimePoint Last 1 Day DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Profile            => {
                Search_DynamicField_DateFieldTimePoint       => '1',
                Search_DynamicField_DateFieldTimePointStart  => 'Last',
                Search_DynamicField_DateFieldTimePointValue  => '1',
                Search_DynamicField_DateFieldTimePointFormat => 'day',
            },
            CGIParam => {
                Search_DynamicField_DateFieldTimePoint       => '1',
                Search_DynamicField_DateFieldTimePointStart  => 'Last',
                Search_DynamicField_DateFieldTimePointValue  => '1',
                Search_DynamicField_DateFieldTimePointFormat => 'day',
            },
            Type => 'TimePoint',
        },
        ExpectedResults => {
            Display   => '2013-12-11 - 2013-12-12',
            Parameter => {
                GreaterThanEquals => '2013-12-11 00:00:00',
                SmallerThanEquals => '2013-12-12 23:59:59',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Date TimePoint Next 1 Day DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Profile            => {
                Search_DynamicField_DateFieldTimePoint       => '1',
                Search_DynamicField_DateFieldTimePointStart  => 'Next',
                Search_DynamicField_DateFieldTimePointValue  => '1',
                Search_DynamicField_DateFieldTimePointFormat => 'day',
            },
            CGIParam => {
                Search_DynamicField_DateFieldTimePoint       => '1',
                Search_DynamicField_DateFieldTimePointStart  => 'Next',
                Search_DynamicField_DateFieldTimePointValue  => '1',
                Search_DynamicField_DateFieldTimePointFormat => 'day',
            },
            Type => 'TimePoint',
        },
        ExpectedResults => {
            Display   => '2013-12-12 - 2013-12-13',
            Parameter => {
                GreaterThanEquals => '2013-12-12 00:00:00',
                SmallerThanEquals => '2013-12-13 23:59:59',
            },
        },
        Success => 1,
    },
    {
        Name   => 'Date TimePoint After 1 Day DF',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Profile            => {
                Search_DynamicField_DateFieldTimePoint       => '1',
                Search_DynamicField_DateFieldTimePointStart  => 'After',
                Search_DynamicField_DateFieldTimePointValue  => '1',
                Search_DynamicField_DateFieldTimePointFormat => 'day',
            },
            CGIParam => {
                Search_DynamicField_DateFieldTimePoint       => '1',
                Search_DynamicField_DateFieldTimePointStart  => 'After',
                Search_DynamicField_DateFieldTimePointValue  => '1',
                Search_DynamicField_DateFieldTimePointFormat => 'day',
            },
            Type => 'TimePoint',
        },
        ExpectedResults => {
            Display   => '> 2013-12-13',
            Parameter => {
                GreaterThan => '2013-12-13 23:59:59',
            },
        },
        Success => 1,
    },
    {
        Name   => 'ProcessManagementProcessID DF test 1',
        Config => {
            DynamicFieldConfig => $DynamicFieldProcessID,
            Profile            => {
                Search_DynamicField_ProcessManagementProcessID => $RandomID,
            },
            CGIParam => {
                Search_DynamicField_ProcessManagementProcessID => $RandomID,
            },
        },
        ExpectedResults => {
            Display   => $RandomID,
            Parameter => {
                Equals => [ sort keys %ProcessLookup, $RandomID ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'ProcessManagementProcessID DF test2',
        Config => {
            DynamicFieldConfig => $DynamicFieldProcessID,
            Profile            => {
                Search_DynamicField_ProcessManagementProcessID => 'Process-1' . $RandomID,
            },
            CGIParam => {
                Search_DynamicField_ProcessManagementProcessID => 'Process-1' . $RandomID,
            },
        },
        ExpectedResults => {
            Display   => 'Process-1' . $RandomID,
            Parameter => {
                Equals => [ 'EntityID-1' . $RandomID, 'Process-1' . $RandomID ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'ProcessManagementProcessID DF test3',
        Config => {
            DynamicFieldConfig => $DynamicFieldProcessID,
            Profile            => {
                Search_DynamicField_ProcessManagementProcessID => 'Process-2' . $RandomID,
            },
            CGIParam => {
                Search_DynamicField_ProcessManagementProcessID => 'Process-2' . $RandomID,
            },
        },
        ExpectedResults => {
            Display   => 'Process-2' . $RandomID,
            Parameter => {
                Equals => [ 'EntityID-2' . $RandomID, 'Process-2' . $RandomID ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'ProcessManagementProcessID DF test4',
        Config => {
            DynamicFieldConfig => $DynamicFieldProcessID,
            Profile            => {
                Search_DynamicField_ProcessManagementProcessID => 'Process-3' . $RandomID,
            },
            CGIParam => {
                Search_DynamicField_ProcessManagementProcessID => 'Process-3' . $RandomID,
            },
        },
        ExpectedResults => {
            Display   => 'Process-3' . $RandomID,
            Parameter => {
                Equals => [ 'EntityID-3' . $RandomID, 'Process-3' . $RandomID ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'ProcessManagementProcessID DF test5',
        Config => {
            DynamicFieldConfig => $DynamicFieldProcessID,
            Profile            => {
                Search_DynamicField_ProcessManagementProcessID => "*$RandomID",
            },
            CGIParam => {
                Search_DynamicField_ProcessManagementProcessID => "*$RandomID",
            },
        },
        ExpectedResults => {
            Display   => "*$RandomID",
            Parameter => {
                Like => [ ( sort keys %ProcessLookup ), "*$RandomID" ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'ProcessManagementActivityID DF test1',
        Config => {
            DynamicFieldConfig => $DynamicFieldActivityID,
            Profile            => {
                Search_DynamicField_ProcessManagementActivityID => $RandomID,
            },
            CGIParam => {
                Search_DynamicField_ProcessManagementActivityID => $RandomID,
            },
        },

        ExpectedResults => {
            Display   => $RandomID,
            Parameter => {
                Equals => [ sort keys %ActivityLookup, $RandomID ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'ProcessManagementActivityID DF test2',
        Config => {
            DynamicFieldConfig => $DynamicFieldActivityID,
            Profile            => {
                Search_DynamicField_ProcessManagementActivityID => 'Activity-1' . $RandomID,
            },
            CGIParam => {
                Search_DynamicField_ProcessManagementActivityID => 'Activity-1' . $RandomID,
            },
        },
        ExpectedResults => {
            Display   => 'Activity-1' . $RandomID,
            Parameter => {
                Equals => [ 'EntityID-1' . $RandomID, 'Activity-1' . $RandomID ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'ProcessManagementActivityID DF test3',
        Config => {
            DynamicFieldConfig => $DynamicFieldActivityID,
            Profile            => {
                Search_DynamicField_ProcessManagementActivityID => 'Activity-2' . $RandomID,
            },
            CGIParam => {
                Search_DynamicField_ProcessManagementActivityID => 'Activity-2' . $RandomID,
            },
        },
        ExpectedResults => {
            Display   => 'Activity-2' . $RandomID,
            Parameter => {
                Equals => [ 'EntityID-2' . $RandomID, 'Activity-2' . $RandomID ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'ProcessManagementActivityID DF test4',
        Config => {
            DynamicFieldConfig => $DynamicFieldActivityID,
            Profile            => {
                Search_DynamicField_ProcessManagementActivityID => 'Activity-3' . $RandomID,
            },
            CGIParam => {
                Search_DynamicField_ProcessManagementActivityID => 'Activity-3' . $RandomID,
            },
        },
        ExpectedResults => {
            Display   => 'Activity-3' . $RandomID,
            Parameter => {
                Equals => [ 'EntityID-3' . $RandomID, 'Activity-3' . $RandomID ],
            },
        },
        Success => 1,
    },
    {
        Name   => 'ProcessManagementActivityID DF test5',
        Config => {
            DynamicFieldConfig => $DynamicFieldActivityID,
            Profile            => {
                Search_DynamicField_ProcessManagementActivityID => "*$RandomID",
            },
            CGIParam => {
                Search_DynamicField_ProcessManagementActivityID => "*$RandomID",
            },
        },

        ExpectedResults => {
            Display   => "*$RandomID",
            Parameter => {
                Like => [ ( sort keys %ActivityLookup ), "*$RandomID" ],
            },
        },
        Success => 1,
    },
);

# execute tests
for my $Test (@Tests) {

    if ( !IsHashRefWithData( $Test->{Config} ) )
    {
        my $Result = $DFBackendObject->SearchFieldParameterBuild( %{ $Test->{Config} } );

        $Self->Is(
            $Result,
            undef,
            "$Test->{Name} | SearchFieldParameterBuild() (should be undef)",
        );
    }
    else {
        my %Config   = %{ $Test->{Config} };
        my $TestType = 'Profile';

        TESTOPTION:
        for my $CGIEnabled ( 0 .. 1 ) {

            if ( $CGIEnabled && ref $Test->{Config}->{CGIParam} eq 'HASH' ) {

                # create a new CGI object to simulate a web request
                my $WebRequest = CGI->new( $Test->{Config}->{CGIParam} );

                my $LocalParamObject = Kernel::System::Web::Request->new(
                    WebRequest => $WebRequest,
                );

                # include ParamObject in function call
                %Config = (
                    %Config,
                    ParamObject => $LocalParamObject,
                );

                $TestType = 'Web Request';
            }

            my $Result = $DFBackendObject->SearchFieldParameterBuild(%Config);

            if ( $Test->{Success} ) {

                if ( $CGIEnabled && IsHashRefWithData $Test->{ExpectedResultsWebRequest} )
                {
                    $Self->IsDeeply(
                        $Result,
                        $Test->{ExpectedResultsWebRequest},
                        "$Test->{Name} in $TestType | SearchFieldParameterBuild()",
                    );
                    next TESTOPTION;
                }
                $Self->IsDeeply(
                    $Result,
                    $Test->{ExpectedResults},
                    "$Test->{Name} in $TestType | SearchFieldParameterBuild()",
                );
            }
            else {
                $Self->Is(
                    $Result,
                    undef,
                    "$Test->{Name} | SearchFieldParameterBuild() (should be undef)",
                );
            }
        }
    }
}

# we don't need any cleanup

1;
