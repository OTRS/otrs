# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::Config;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

# get needed objects
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

my $Home = $Kernel::OM->Get('Kernel::Config')->{Home};

my $TestFile      = 'ZZZAutoOTRS5.pm';
my $TestPath      = $Home . '/scripts/test/sample/SysConfig/Migration/';
my $TestLocation  = $TestPath . $TestFile;
my $TestFileClass = "scripts::test::sample::SysConfig::Migration::ZZZAutoOTRS5";

$Self->True(
    -e $TestLocation,
    "TestFile '$TestFile' existing",
);

# load from samples
my $Config5 = $MainObject->FileRead(
    Directory => $TestPath,
    Filename  => $TestFile,
    Mode      => 'utf8',
);

$Self->True(
    $Config5,
    "File was readable",
);

return if !-e $TestLocation;

# Import
my %OTRS5Config;
delete $INC{$TestPath};
$Kernel::OM->Get('Kernel::System::Main')->Require($TestFileClass);
$TestFileClass->Load( \%OTRS5Config );

$Self->True(
    \%OTRS5Config,
    "Config was loaded",
);

# Update before migrate
my $PreModifiedSettings = [
    {
        Name           => 'ProductName',
        EffectiveValue => 'UnitTestModified',
    },
];

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
for my $Settings ( @{$PreModifiedSettings} ) {
    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        %{$Settings},
        Force  => 1,
        UserID => 1,
    );
    my %Result = $SysConfigObject->SettingUpdate(
        %{$Settings},
        IsValid           => 1,
        ExclusiveLockGUID => $ExclusiveLockGUID,
        NoValidation      => 1,
        UserID            => 1,
    );

    $Self->True(
        $Result{Success},
        "Setting $Settings->{Name} was updated successfully.",
    );
    $SysConfigObject->SettingUnlock(
        Name => $Settings->{Name},
    );
    my %Setting = $SysConfigObject->SettingGet(
        Name => $Settings->{Name},
    );
    $Self->Is(
        $Setting{EffectiveValue},
        $Settings->{EffectiveValue},
        'Test Setting ' . $Setting{Name} . ' was modified.',
    );
}

# migrate package setting
my $Success = $Kernel::OM->Get('Kernel::System::SysConfig::Migration')->MigrateConfigEffectiveValues(
    FileClass => $TestFileClass,
    FilePath  => $TestLocation,
    PackageSettings => [
        'SessionAgentOnlineThreshold',
    ],
    PackageLookupNewConfigName => {
        'SessionAgentOnlineThreshold' => 'ChatEngine::AgentOnlineThreshold'
    },
    ReturnMigratedSettingsCounts => 1,
);

$Self->True(
    $Success,
    "Config was successfully migrated from otrs5 to 6."
);

# RebuildConfig
my $Rebuild = $SysConfigObject->ConfigurationDeploy(
    Comments => "UnitTest Configuration Rebuild",
    Force    => 1,
    UserID   => 1,
);

$Self->True(
    $Rebuild,
    "Setting Deploy was successfull."
);

my %ValueOld = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet( Name => 'ChatEngine::AgentOnlineThreshold' );
my %ValueNew = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet( Name => 'SessionAgentOnlineThreshold' );

$Self->False(
    $ValueOld{EffectiveValue},
    "TEST ChatEngine::AgentOnlineThreshold: ChatEngine::AgentOnlineThreshold is invalid.",
);

$Self->Is(
    $ValueNew{EffectiveValue},
    10,
    "TEST SessionAgentOnlineThreshold: Value for SessionAgentOnlineThreshold is correct",
);

# migrate
$Success = $Kernel::OM->Get('Kernel::System::SysConfig::Migration')->MigrateConfigEffectiveValues(
    FileClass                    => $TestFileClass,
    FilePath                     => $TestLocation,
    ReturnMigratedSettingsCounts => 1,
);

$Self->True(
    $Success,
    "Config was successfully migrated from otrs5 to 6."
);
if ( ref $Success eq 'HASH' ) {

    my $AllSettingsCount      = $Success->{AllSettingsCount};
    my @MissingSettings       = @{ $Success->{MissingSettings} };
    my @UnsuccessfullSettings = @{ $Success->{UnsuccessfullSettings} };

    my @Tests = (
        {
            Name        => 'AllSettingsCount',
            IsValue     => $AllSettingsCount,
            ShouldValue => 47,
        },
        {
            Name        => 'MissingSettings',
            IsValue     => scalar @MissingSettings,
            ShouldValue => 1,
        },
        {
            Name        => 'UnsuccessfullSettings',
            IsValue     => scalar @UnsuccessfullSettings,
            ShouldValue => 0,
        }
    );

    for my $TestData (@Tests) {
        $Self->Is(
            $TestData->{IsValue},
            $TestData->{ShouldValue},
            "$TestData->{Name} has correct count of settings.",
        );
    }
}
else {
    $Self->Is(
        ref $Success,
        'HASH',
        "Return Value of Migrate with 'ReturnTestCounts' is not a  HASH!",
    );
}

# RebuildConfig
$Rebuild = $SysConfigObject->ConfigurationDeploy(
    Comments => "UnitTest Configuration Rebuild",
    Force    => 1,
    UserID   => 1,
);

$Self->True(
    $Rebuild,
    "Setting Deploy was successfull."
);

# TODO - many SettingGet to check correct value
my @Tests = (
    {
        TestType => 'Renaming',
        Name     => 'Renamed Setting 1',
        OldName  => 'Ticket::EventModulePost###098-ArticleSearchIndex',
        NewName  => 'Ticket::EventModulePost###2000-ArticleSearchIndex',
    },
    {
        TestType => 'Renaming',
        Name     => 'Renamed Setting 2',
        OldName  => 'Frontend::NotifyModule###800-Daemon-Check',
        NewName  => 'Frontend::NotifyModule###8000-Daemon-Check',
    },
    {
        TestType => 'Renaming',
        Name     => 'Renamed Setting 3',
        OldName  => 'CustomerCompany::EventModulePost###110-UpdateTickets',
        NewName  => 'CustomerCompany::EventModulePost###2300-UpdateTickets',
    },

    # There are other renamed settings, this are included AllSetings,
    #   and should not add any results in the MissingSettings above.
    {
        TestType      => 'PreChanged',
        Name          => 'Was changed before 1',
        Key           => 'ProductName',
        ChangedValue  => 'UnitTestModified',
        MigratedValue => 'OTRS 5s',
    },
);

TESTS:
for my $TestData (@Tests) {
    next TESTS if !$TestData->{TestType};

    if ( $TestData->{TestType} eq 'Renaming' ) {
        my %ValueOld = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet( Name => $TestData->{OldName} );
        my %ValueNew = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet( Name => $TestData->{NewName} );

        $Self->False(
            $ValueOld{EffectiveValue},
            "TEST $TestData->{Name}: $TestData->{OldName} is invalid.",
        );

        $Self->True(
            $ValueNew{EffectiveValue},
            "TEST $TestData->{Name}: Value for $TestData->{NewName} found.",
        );
    }
    elsif ( $TestData->{TestType} eq 'PreChanged' ) {
        my %Setting = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet( Name => $TestData->{Key} );

        $Self->Is(
            $Setting{EffectiveValue},
            $TestData->{ChangedValue},
            "TEST $TestData->{Name}: Value was changed before migration an not touched."
        );
    }
}

1;
