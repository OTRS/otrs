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
    $SysConfigObject->SettingUnlock(
        Name => $Settings->{Name},
    );
    my %Setting = $SysConfigObject->SettingGet(
        Name    => $Settings->{Name},
        Default => 0,
    );
    $Self->Is(
        $Setting{EffectiveValue},
        $Settings->{EffectiveValue},
        'Test Setting ' . $Setting{Name} . ' was modified.',
    );
}

# migrate
my $Success = $Kernel::OM->Get('Kernel::System::SysConfig::Migration')->MigrateConfigEffectiveValues(
    FileClass => $TestFileClass,
    FilePath  => $TestLocation,
);

$Self->True(
    $Success,
    "Config was successfully migrated from otrs5 to 6."
);

1;
