# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Delete sysconfig_modified_version.
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM sysconfig_modified_version',
);

# Delete sysconfig_modified.
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM sysconfig_modified',
);

# Delete sysconfig_default_version.
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM sysconfig_default_version',
);

# Delete sysconfig_default.
return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM sysconfig_default',
);

my $RandomID = $HelperObject->GetRandomID();

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

# Create new default settings.
my $DefaultID1 = $SysConfigDBObject->DefaultSettingAdd(
    Name             => "Test1$RandomID",
    Description      => "Test.",
    Navigation       => "Test",
    XMLContentRaw    => '<>',
    XMLContentParsed => {
        Test => 'Test',
    },
    XMLFilename    => 'UnitTest.xml',
    EffectiveValue => 'Test',
    UserID         => 1,
);
$Self->IsNot(
    $DefaultID1,
    undef,
    "DefaultSettingAdd() for Test1$RandomID",
);
my $DefaultID2 = $SysConfigDBObject->DefaultSettingAdd(
    Name             => "Test2$RandomID",
    Description      => "Test.",
    Navigation       => "Test",
    XMLContentRaw    => '<>',
    XMLContentParsed => {
        Test => 'Test',
    },
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test',
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    UserID                   => 1,
);
$Self->IsNot(
    $DefaultID2,
    undef,
    "DefaultSettingAdd() for Test2$RandomID",
);

# Create new modified settings.
my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    DefaultID => $DefaultID1,
    Force     => 1,
    UserID    => 1,
);
my $ModifiedID1 = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID         => $DefaultID1,
    Name              => "Test1$RandomID",
    EffectiveValue    => 'TestUpdate',
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);
my $Success = $SysConfigDBObject->DefaultSettingUnlock(
    DefaultID => $DefaultID1,
);
$Self->IsNot(
    $ModifiedID1,
    undef,
    "ModifiedSettingAdd() for Test1$RandomID",
);
$ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    DefaultID => $DefaultID2,
    Force     => 1,
    UserID    => 1,
);
my $ModifiedID2 = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID         => $DefaultID2,
    Name              => "Test2$RandomID",
    EffectiveValue    => 'TestUpdate',
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);
$Success = $SysConfigDBObject->DefaultSettingUnlock(
    DefaultID => $DefaultID2,
);
$Self->IsNot(
    $ModifiedID2,
    undef,
    "ModifiedSettingAdd() for Test2$RandomID",
);

# Get All Settings.
my %DefaultSetting1 = $SysConfigDBObject->DefaultSettingGet(
    DefaultID => $DefaultID1,
);
my %DefaultSetting2 = $SysConfigDBObject->DefaultSettingGet(
    DefaultID => $DefaultID2,
);
my %ModifiedSetting1 = $SysConfigDBObject->ModifiedSettingGet(
    ModifiedID => $ModifiedID1,
);
my %ModifiedSetting2 = $SysConfigDBObject->ModifiedSettingGet(
    ModifiedID => $ModifiedID2,
);

my @Tests = (
    {
        Name          => 'Full',
        Config        => {},
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => \%DefaultSetting1,
                "Test2$RandomID" => \%DefaultSetting2,
            },
            Modified => {
                "Test1$RandomID" => \%ModifiedSetting1,
                "Test2$RandomID" => \%ModifiedSetting2,
            },
        },
    },
    {
        Name   => 'Skip Default',
        Config => {
            SkipDefaultSettings => 1,
        },
        ExpectedValue => {
            Modified => {
                "Test1$RandomID" => \%ModifiedSetting1,
                "Test2$RandomID" => \%ModifiedSetting2,
            },
        },
    },
    {
        Name   => 'Skip Modified',
        Config => {
            SkipModifiedSettings => 1,
        },
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => \%DefaultSetting1,
                "Test2$RandomID" => \%DefaultSetting2,
            },
        },
    },
    {
        Name          => 'Skip User',
        Config        => {},
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => \%DefaultSetting1,
                "Test2$RandomID" => \%DefaultSetting2,
            },
            Modified => {
                "Test1$RandomID" => \%ModifiedSetting1,
                "Test2$RandomID" => \%ModifiedSetting2,
            },
        },
    },
    {
        Name   => 'Skip All',
        Config => {
            SkipDefaultSettings  => 1,
            SkipModifiedSettings => 1,
        },
        ExpectedValue => {},
    },
    {
        Name   => 'Only Default',
        Config => {
            SkipModifiedSettings => 1,
        },
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => \%DefaultSetting1,
                "Test2$RandomID" => \%DefaultSetting2,
            },
        },
    },
    {
        Name   => 'Only Modified',
        Config => {
            SkipDefaultSettings => 1,
        },
        ExpectedValue => {
            Modified => {
                "Test1$RandomID" => \%ModifiedSetting1,
                "Test2$RandomID" => \%ModifiedSetting2,
            },
        },
    },

    {
        Name   => 'Full (Only Values)',
        Config => {
            OnlyValues => 1,
        },
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => $DefaultSetting1{EffectiveValue},
                "Test2$RandomID" => $DefaultSetting2{EffectiveValue},
            },
            Modified => {
                "Test1$RandomID" => $ModifiedSetting1{EffectiveValue},
                "Test2$RandomID" => $ModifiedSetting2{EffectiveValue},
            },
        },
    },
    {
        Name   => 'Skip Default (Only Values)',
        Config => {
            OnlyValues          => 1,
            SkipDefaultSettings => 1,
        },
        ExpectedValue => {
            Modified => {
                "Test1$RandomID" => $ModifiedSetting1{EffectiveValue},
                "Test2$RandomID" => $ModifiedSetting2{EffectiveValue},
            },
        },
    },
    {
        Name   => 'Skip Modified (Only Values)',
        Config => {
            OnlyValues           => 1,
            SkipModifiedSettings => 1,
        },
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => $DefaultSetting1{EffectiveValue},
                "Test2$RandomID" => $DefaultSetting2{EffectiveValue},
            },
        },
    },
    {
        Name   => 'Skip User (Only Values)',
        Config => {
            OnlyValues => 1,
        },
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => $DefaultSetting1{EffectiveValue},
                "Test2$RandomID" => $DefaultSetting2{EffectiveValue},
            },
            Modified => {
                "Test1$RandomID" => $ModifiedSetting1{EffectiveValue},
                "Test2$RandomID" => $ModifiedSetting2{EffectiveValue},
            },
        },
    },
    {
        Name   => 'Skip All (Only Values)',
        Config => {
            OnlyValues           => 1,
            SkipDefaultSettings  => 1,
            SkipModifiedSettings => 1,
        },
        ExpectedValue => {},
    },
);

my $YAMLObject      = $Kernel::OM->Get('Kernel::System::YAML');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

for my $Test (@Tests) {

    my $ConfigurationDumpYAML = $SysConfigObject->ConfigurationDump( %{ $Test->{Config} } );

    my $ConfigurationDumpPerl = $YAMLObject->Load(
        Data => $ConfigurationDumpYAML,
    );

    $Self->IsDeeply(
        $ConfigurationDumpPerl,
        $Test->{ExpectedValue},
        "$Test->{Name} ConfigurationDump() - Result",
    );
}

1;
