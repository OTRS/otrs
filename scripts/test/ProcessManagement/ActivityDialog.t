# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $HelperObject         = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ActivityDialogObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::ActivityDialog');

# define needed variables
my $RandomID = $HelperObject->GetRandomID();

# ActivityDialogGet() tests
my @Tests = (
    {
        Name            => 'No Interface',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface => ['AgentInterface'],
            },
        },
        Config  => {},
        Success => 0,
    },
    {
        Name            => 'Interface allowed: Agent / Interface used: Agent',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface => ['AgentInterface'],
            },
        },
        Config => {
            Interface              => 'AgentInterface',
            ActivityDialogEntityID => 'AD1' . $RandomID,
        },
        Success => 1,
    },
    {
        Name            => 'Interface allowed: Customer / Interface used: Customer',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface => ['CustomerInterface'],
            },
        },
        Config => {
            Interface              => 'CustomerInterface',
            ActivityDialogEntityID => 'AD1' . $RandomID,
        },
        Success => 1,
    },
    {
        Name            => 'Interface allowed: Agent / Interface used: Customer',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface => ['AgentInterface'],
            },
        },
        Config => {
            Interface              => 'CustomerInterface',
            ActivityDialogEntityID => 'AD1' . $RandomID,
        },
        Success => 0,
    },
    {
        Name            => 'Interface allowed: Customer / Interface used: Agent',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface => ['CustomerInterface'],
            },
        },
        Config => {
            Interface              => 'AgentInterface',
            ActivityDialogEntityID => 'AD1' . $RandomID,
        },
        Success => 0,
    },
    {
        Name            => 'Interface allowed: Agent+Customer / Interface used: Agent',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface => [ 'AgentInterface', 'CustomerInterface' ],
            },
        },
        Config => {
            Interface              => 'AgentInterface',
            ActivityDialogEntityID => 'AD1' . $RandomID,
        },
        Success => 1,
    },
    {
        Name            => 'Interface allowed: Agent+Customer / Interface used: Customer',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface => [ 'AgentInterface', 'CustomerInterface' ],
            },
        },
        Config => {
            Interface              => 'CustomerInterface',
            ActivityDialogEntityID => 'AD1' . $RandomID,
        },
        Success => 1,
    },
    {
        Name            => 'No Parameters',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface        => ['AgentInterface'],
                Name             => 'Activity Dialog 1',
                DescriptionShort => 'AD1 Process Short',
                DescriptionLong  => 'AD1 Process Long description',
                CreateTime       => '07-02-2012 13:37:00',
                CreateBy         => '2',
                ChangeTime       => '08-02-2012 13:37:00',
                ChangeBy         => '3',
                Fields           => {
                    DynamicField_Make => {
                        Display          => 2,
                        DescriptionLong  => 'Make Long',
                        DescriptionShort => 'Make Short',
                    },
                    DynamicField_VWModel => {
                        Display          => 2,
                        DescriptionLong  => 'VWModel Long',
                        DescriptionShort => 'VWModel Short',
                    },
                    DynamicField_PeugeotModel => {
                        Display          => 0,
                        DescriptionLong  => 'PeugeotModel Long',
                        DescriptionShort => 'PeugeotModel Short',
                    },
                    StateID => {
                        Display          => 1,
                        DescriptionLong  => 'StateID Long',
                        DescriptionShort => 'StateID Short',
                    },
                },
                FieldOrder => [
                    'StateID',
                    'DynamicField_Make',
                    'DynamicField_VWModelModel',
                    'DynamicField_PeugeotModel',
                ],
                SubmitAdviceText => 'NOTE: If you submit the form ...',
                SubmitButtonText => 'Make an inquiry',
            },
        },
        Config => {
            Interface => 'AgentInterface',
        },
        Success => 0,
    },
    {
        Name            => 'No ActivityDialogEntityID',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface        => ['AgentInterface'],
                Name             => 'Activity Dialog 1',
                DescriptionShort => 'AD1 Process Short',
                DescriptionLong  => 'AD1 Process Long description',
                CreateTime       => '07-02-2012 13:37:00',
                CreateBy         => '2',
                ChangeTime       => '08-02-2012 13:37:00',
                ChangeBy         => '3',
                Fields           => {
                    DynamicField_Make => {
                        Display          => 2,
                        DescriptionLong  => 'Make Long',
                        DescriptionShort => 'Make Short',
                    },
                    DynamicField_VWModel => {
                        Display          => 2,
                        DescriptionLong  => 'VWModel Long',
                        DescriptionShort => 'VWModel Short',
                    },
                    DynamicField_PeugeotModel => {
                        Display          => 0,
                        DescriptionLong  => 'PeugeotModel Long',
                        DescriptionShort => 'PeugeotModel Short',
                    },
                    StateID => {
                        Display          => 1,
                        DescriptionLong  => 'StateID Long',
                        DescriptionShort => 'StateID Short',
                    },
                },
                FieldOrder => [
                    'StateID',
                    'DynamicField_Make',
                    'DynamicField_VWModelModel',
                    'DynamicField_PeugeotModel',
                ],
                SubmitAdviceText => 'NOTE: If you submit the form ...',
                SubmitButtonText => 'Make an inquiry',
            },
        },
        Config => {
            Interface => 'AgentInterface',
            Other     => 1,
        },
        Success => 0,
    },
    {
        Name            => 'Wrong ActivityDialogEntityID',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface        => ['AgentInterface'],
                Name             => 'Activity Dialog 1',
                DescriptionShort => 'AD1 Process Short',
                DescriptionLong  => 'AD1 Process Long description',
                CreateTime       => '07-02-2012 13:37:00',
                CreateBy         => '2',
                ChangeTime       => '08-02-2012 13:37:00',
                ChangeBy         => '3',
                Fields           => {
                    DynamicField_Make => {
                        Display          => 2,
                        DescriptionLong  => 'Make Long',
                        DescriptionShort => 'Make Short',
                    },
                    DynamicField_VWModel => {
                        Display          => 2,
                        DescriptionLong  => 'VWModel Long',
                        DescriptionShort => 'VWModel Short',
                    },
                    DynamicField_PeugeotModel => {
                        Display          => 0,
                        DescriptionLong  => 'PeugeotModel Long',
                        DescriptionShort => 'PeugeotModel Short',
                    },
                    StateID => {
                        Display          => 1,
                        DescriptionLong  => 'StateID Long',
                        DescriptionShort => 'StateID Short',
                    },
                },
                FieldOrder => [
                    'StateID',
                    'DynamicField_Make',
                    'DynamicField_VWModelModel',
                    'DynamicField_PeugeotModel',
                ],
                SubmitAdviceText => 'NOTE: If you submit the form ...',
                SubmitButtonText => 'Make an inquiry',
            },
        },
        Config => {
            Interface              => 'AgentInterface',
            ActivityDialogEntityID => 'Notexisiting' . $RandomID,
        },
        Success => 0,
    },
    {
        Name            => 'No ActivityDialogs Configuration',
        ActivityDialogs => {},
        Config          => {
            Interface              => 'AgentInterface',
            ActivityDialogEntityID => 'Notexisiting' . $RandomID,
        },
        Success => 0,
    },
    {
        Name            => 'Correct ASCII',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface        => ['AgentInterface'],
                Name             => 'Activity Dialog 1',
                DescriptionShort => 'AD1 Process Short',
                DescriptionLong  => 'AD1 Process Long description',
                CreateTime       => '07-02-2012 13:37:00',
                CreateBy         => '2',
                ChangeTime       => '08-02-2012 13:37:00',
                ChangeBy         => '3',
                Fields           => {
                    DynamicField_Make => {
                        Display          => 2,
                        DescriptionLong  => 'Make Long',
                        DescriptionShort => 'Make Short',
                    },
                    DynamicField_VWModel => {
                        Display          => 2,
                        DescriptionLong  => 'VWModel Long',
                        DescriptionShort => 'VWModel Short',
                    },
                    DynamicField_PeugeotModel => {
                        Display          => 0,
                        DescriptionLong  => 'PeugeotModel Long',
                        DescriptionShort => 'PeugeotModel Short',
                    },
                    StateID => {
                        Display          => 1,
                        DescriptionLong  => 'StateID Long',
                        DescriptionShort => 'StateID Short',
                    },
                },
                FieldOrder => [
                    'StateID',
                    'DynamicField_Make',
                    'DynamicField_VWModelModel',
                    'DynamicField_PeugeotModel',
                ],
                SubmitAdviceText => 'NOTE: If you submit the form ...',
                SubmitButtonText => 'Make an inquiry',
            },
        },
        Config => {
            Interface              => 'AgentInterface',
            ActivityDialogEntityID => 'AD1' . $RandomID,
        },
        Success => 1,
    },
    {
        Name            => 'Correct UTF8',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface => ['AgentInterface'],
                Name =>
                    'äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                DescriptionShort =>
                    'AD1 äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                DescriptionLong =>
                    'AD1 äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                CreateTime => '07-02-2012 13:37:00',
                CreateBy   => '2',
                ChangeTime => '08-02-2012 13:37:00',
                ChangeBy   => '3',
                Fields     => {
                    DynamicField_Make => {
                        Display => 2,
                        DescriptionLong =>
                            'Make äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                        DescriptionShort => 'Make Short',
                    },
                    DynamicField_VWModel => {
                        Display         => 2,
                        DescriptionLong => 'VWModel Long',
                        DescriptionShort =>
                            'VWModel äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                    },
                    DynamicField_PeugeotModel => {
                        Display => 0,
                        DescriptionLong =>
                            'PeugeotModel äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                        DescriptionShort => 'PeugeotModel Short',
                    },
                    StateID => {
                        Display         => 1,
                        DescriptionLong => 'StateID Long',
                        DescriptionShort =>
                            'StateID äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                    },
                },
                FieldOrder => [
                    'StateID',
                    'DynamicField_Make',
                    'DynamicField_VWModelModel',
                    'DynamicField_PeugeotModel',
                ],
                SubmitAdviceText =>
                    'NOTE: äöüßÄÖÜ€исáéíúóúÁÉÍÓÚñÑ-カスタ-用迎使用-Язык',
                SubmitButtonText => 'Make an inquiry',
            },
        },
        Config => {
            Interface              => 'AgentInterface',
            ActivityDialogEntityID => 'AD1' . $RandomID,
        },
        Success => 1,
    },
);

for my $Test (@Tests) {

    # set activity dialog config
    $ConfigObject->Set(
        Key   => 'Process::ActivityDialog',
        Value => $Test->{ActivityDialogs},
    );

    # get activity dialog descrived in test
    my $ActivityDialog = $ActivityDialogObject->ActivityDialogGet( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->IsNot(
            $ActivityDialog,
            undef,
            "ActivityDialogGet() Test:'$Test->{Name}' | should not be undef"
        );
        $Self->Is(
            ref $ActivityDialog,
            'HASH',
            "ActivityDialogGet() Test:'$Test->{Name}' | should be a HASH"
        );
        $Self->IsDeeply(
            $ActivityDialog,
            $Test->{ActivityDialogs}->{ $Test->{Config}->{ActivityDialogEntityID} },
            "ActivityDialogGet() Test:'$Test->{Name}' | comparison"
        );
    }
    else {
        $Self->Is(
            $ActivityDialog,
            undef,
            "ActivityDialogGet() Test:'$Test->{Name}' | should be undef"
        );
    }
}

# ActivityDialogCompletedCheck() tests
@Tests = (
    {
        Name            => 'No Parameters',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface        => ['AgentInterface'],
                Name             => 'Activity Dialog 1',
                DescriptionShort => 'AD1 Process Short',
                DescriptionLong  => 'AD1 Process Long description',
                CreateTime       => '07-02-2012 13:37:00',
                CreateBy         => '2',
                ChangeTime       => '08-02-2012 13:37:00',
                ChangeBy         => '3',
                Fields           => {
                    DynamicField_Make => {
                        Display          => 0,
                        DescriptionLong  => 'Make Long',
                        DescriptionShort => 'Make Short',
                    },
                    DynamicField_VWModel => {
                        Display          => 1,
                        DescriptionLong  => 'VWModel Long',
                        DescriptionShort => 'VWModel Short',
                    },
                    StateID => {
                        Display          => 2,
                        DescriptionLong  => 'StateID Long',
                        DescriptionShort => 'StateID Short',
                    },
                },
                FieldOrder => [
                    'StateID',
                    'DynamicField_Make',
                    'DynamicField_VWModelModel',
                ],
                SubmitAdviceText => 'NOTE: If you submit the form ...',
                SubmitButtonText => 'Make an inquiry',
            },
        },
        Config => {
            Interface => 'AgentInterface',
        },
        Success => 0,
    },
    {
        Name            => 'No ActivityDialogEntityID',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface        => ['AgentInterface'],
                Name             => 'Activity Dialog 1',
                DescriptionShort => 'AD1 Process Short',
                DescriptionLong  => 'AD1 Process Long description',
                CreateTime       => '07-02-2012 13:37:00',
                CreateBy         => '2',
                ChangeTime       => '08-02-2012 13:37:00',
                ChangeBy         => '3',
                Fields           => {
                    DynamicField_Make => {
                        Display          => 0,
                        DescriptionLong  => 'Make Long',
                        DescriptionShort => 'Make Short',
                    },
                    DynamicField_VWModel => {
                        Display          => 1,
                        DescriptionLong  => 'VWModel Long',
                        DescriptionShort => 'VWModel Short',
                    },
                    StateID => {
                        Display          => 2,
                        DescriptionLong  => 'StateID Long',
                        DescriptionShort => 'StateID Short',
                    },
                },
                FieldOrder => [
                    'StateID',
                    'DynamicField_Make',
                    'DynamicField_VWModelModel',
                ],
                SubmitAdviceText => 'NOTE: If you submit the form ...',
                SubmitButtonText => 'Make an inquiry',
            },
        },
        Config => {
            Interface              => 'AgentInterface',
            ActivityDialogEntityID => undef,
            Data                   => {
                DynamicField_Make    => 'VW',
                DynamicField_VWModel => 'Golf',
                StateID              => 1,
            },
        },
        Success => 0,
    },
    {
        Name            => 'No Data',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface        => ['AgentInterface'],
                Name             => 'Activity Dialog 1',
                DescriptionShort => 'AD1 Process Short',
                DescriptionLong  => 'AD1 Process Long description',
                CreateTime       => '07-02-2012 13:37:00',
                CreateBy         => '2',
                ChangeTime       => '08-02-2012 13:37:00',
                ChangeBy         => '3',
                Fields           => {
                    DynamicField_Make => {
                        Display          => 0,
                        DescriptionLong  => 'Make Long',
                        DescriptionShort => 'Make Short',
                    },
                    DynamicField_VWModel => {
                        Display          => 1,
                        DescriptionLong  => 'VWModel Long',
                        DescriptionShort => 'VWModel Short',
                    },
                    StateID => {
                        Display          => 2,
                        DescriptionLong  => 'StateID Long',
                        DescriptionShort => 'StateID Short',
                    },
                },
                FieldOrder => [
                    'StateID',
                    'DynamicField_Make',
                    'DynamicField_VWModelModel',
                ],
                SubmitAdviceText => 'NOTE: If you submit the form ...',
                SubmitButtonText => 'Make an inquiry',
            },
        },
        Config => {
            Interface              => 'AgentInterface',
            ActivityDialogEntityID => 'AD1' . $RandomID,
            Data                   => undef,
        },
        Success => 0,
    },
    {
        Name            => 'Wong Data Format',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface        => ['AgentInterface'],
                Name             => 'Activity Dialog 1',
                DescriptionShort => 'AD1 Process Short',
                DescriptionLong  => 'AD1 Process Long description',
                CreateTime       => '07-02-2012 13:37:00',
                CreateBy         => '2',
                ChangeTime       => '08-02-2012 13:37:00',
                ChangeBy         => '3',
                Fields           => {
                    DynamicField_Make => {
                        Display          => 0,
                        DescriptionLong  => 'Make Long',
                        DescriptionShort => 'Make Short',
                    },
                    DynamicField_VWModel => {
                        Display          => 1,
                        DescriptionLong  => 'VWModel Long',
                        DescriptionShort => 'VWModel Short',
                    },
                    StateID => {
                        Display          => 2,
                        DescriptionLong  => 'StateID Long',
                        DescriptionShort => 'StateID Short',
                    },
                },
                FieldOrder => [
                    'StateID',
                    'DynamicField_Make',
                    'DynamicField_VWModelModel',
                ],
                SubmitAdviceText => 'NOTE: If you submit the form ...',
                SubmitButtonText => 'Make an inquiry',
            },
        },
        Config => {
            Interface              => 'AgentInterface',
            ActivityDialogEntityID => 'AD1' . $RandomID,
            Data                   => 1,
        },
        Success => 0,
    },
    {
        Name            => 'No Fields in ActivityDialog Config',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface        => ['AgentInterface'],
                Name             => 'Activity Dialog 1',
                DescriptionShort => 'AD1 Process Short',
                DescriptionLong  => 'AD1 Process Long description',
                CreateTime       => '07-02-2012 13:37:00',
                CreateBy         => '2',
                ChangeTime       => '08-02-2012 13:37:00',
                ChangeBy         => '3',
                Fields           => 1,
                FieldOrder       => [
                    'StateID',
                    'DynamicField_Make',
                    'DynamicField_VWModelModel',
                ],
                SubmitAdviceText => 'NOTE: If you submit the form ...',
                SubmitButtonText => 'Make an inquiry',
            },
        },
        Config => {
            Interface              => 'AgentInterface',
            ActivityDialogEntityID => 'AD1' . $RandomID,
            Data                   => {
                DynamicField_Make    => 'VW',
                DynamicField_VWModel => 'Golf',
                StateID              => 1,
            },
        },
        Success => 0,
    },
    {
        Name            => 'No Data for Required Field',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface        => ['AgentInterface'],
                Name             => 'Activity Dialog 1',
                DescriptionShort => 'AD1 Process Short',
                DescriptionLong  => 'AD1 Process Long description',
                CreateTime       => '07-02-2012 13:37:00',
                CreateBy         => '2',
                ChangeTime       => '08-02-2012 13:37:00',
                ChangeBy         => '3',
                Fields           => {
                    DynamicField_Make => {
                        Display          => 0,
                        DescriptionLong  => 'Make Long',
                        DescriptionShort => 'Make Short',
                    },
                    DynamicField_VWModel => {
                        Display          => 1,
                        DescriptionLong  => 'VWModel Long',
                        DescriptionShort => 'VWModel Short',
                    },
                    StateID => {
                        Display          => 2,
                        DescriptionLong  => 'StateID Long',
                        DescriptionShort => 'StateID Short',
                    },
                },
                FieldOrder => [
                    'StateID',
                    'DynamicField_Make',
                    'DynamicField_VWModelModel',
                ],
                SubmitAdviceText => 'NOTE: If you submit the form ...',
                SubmitButtonText => 'Make an inquiry',
            },
        },
        Config => {
            Interface              => 'AgentInterface',
            ActivityDialogEntityID => 'AD1' . $RandomID,
            Data                   => {
                DynamicField_Make    => 'VW',
                DynamicField_VWModel => 'Golf',
                StateID              => '',
            },
        },
        Success => 0,
    },
    {
        Name            => 'Correct,  Data for Required Field',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface        => ['AgentInterface'],
                Name             => 'Activity Dialog 1',
                DescriptionShort => 'AD1 Process Short',
                DescriptionLong  => 'AD1 Process Long description',
                CreateTime       => '07-02-2012 13:37:00',
                CreateBy         => '2',
                ChangeTime       => '08-02-2012 13:37:00',
                ChangeBy         => '3',
                Fields           => {
                    DynamicField_Make => {
                        Display          => 0,
                        DescriptionLong  => 'Make Long',
                        DescriptionShort => 'Make Short',
                    },
                    DynamicField_VWModel => {
                        Display          => 1,
                        DescriptionLong  => 'VWModel Long',
                        DescriptionShort => 'VWModel Short',
                    },
                    StateID => {
                        Display          => 2,
                        DescriptionLong  => 'StateID Long',
                        DescriptionShort => 'StateID Short',
                    },
                },
                FieldOrder => [
                    'StateID',
                    'DynamicField_Make',
                    'DynamicField_VWModelModel',
                ],
                SubmitAdviceText => 'NOTE: If you submit the form ...',
                SubmitButtonText => 'Make an inquiry',
            },
        },
        Config => {
            Interface              => 'AgentInterface',
            ActivityDialogEntityID => 'AD1' . $RandomID,
            Data                   => {
                DynamicField_Make    => 'VW',
                DynamicField_VWModel => 'Golf',
                StateID              => 1,
            },
        },
        Success => 1,
    },
    {
        Name            => 'Correct,  No Required Field',
        ActivityDialogs => {
            'AD1' . $RandomID => {
                Interface        => ['AgentInterface'],
                Name             => 'Activity Dialog 1',
                DescriptionShort => 'AD1 Process Short',
                DescriptionLong  => 'AD1 Process Long description',
                CreateTime       => '07-02-2012 13:37:00',
                CreateBy         => '2',
                ChangeTime       => '08-02-2012 13:37:00',
                ChangeBy         => '3',
                Fields           => {
                    DynamicField_Make => {
                        Display          => 0,
                        DescriptionLong  => 'Make Long',
                        DescriptionShort => 'Make Short',
                    },
                    DynamicField_VWModel => {
                        Display          => 1,
                        DescriptionLong  => 'VWModel Long',
                        DescriptionShort => 'VWModel Short',
                    },
                    StateID => {
                        Display          => 1,
                        DescriptionLong  => 'StateID Long',
                        DescriptionShort => 'StateID Short',
                    },
                },
                FieldOrder => [
                    'StateID',
                    'DynamicField_Make',
                    'DynamicField_VWModelModel',
                ],
                SubmitAdviceText => 'NOTE: If you submit the form ...',
                SubmitButtonText => 'Make an inquiry',
            },
        },
        Config => {
            Interface              => 'AgentInterface',
            ActivityDialogEntityID => 'AD1' . $RandomID,
            Data                   => {
                DynamicField_Make    => '',
                DynamicField_VWModel => '',
                StateID              => '',
            },
        },
        Success => 1,
    },
);

for my $Test (@Tests) {

    # set activity dialog config
    $ConfigObject->Set(
        Key   => 'Process::ActivityDialog',
        Value => $Test->{ActivityDialogs},
    );

    # get activity dialog descrived in test
    my $CheckSuccess = $ActivityDialogObject->ActivityDialogCompletedCheck( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->True(
            $CheckSuccess,
            "ActivityDialogCompletedCheck() Test:'$Test->{Name}' | with True",
        );
    }
    else {
        $Self->False(
            $CheckSuccess,
            "ActivityDialogCompletedCheck() Test:'$Test->{Name}' | with False",
        );
    }
}

1;
