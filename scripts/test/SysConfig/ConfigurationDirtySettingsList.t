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

my $HelperObject      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $RandomID    = $HelperObject->GetRandomID();
my $SettingName = "Test$RandomID";
my $UserID      = 1;
my @SettingDirtyNames;

# Make sure all settings are not dirty.
my $ModifiedCleanup = $SysConfigDBObject->ModifiedSettingDirtyCleanUp();
$Self->True(
    $ModifiedCleanup,
    "ModifiedSettingDirtyCleanUp() - with true",
);

my $DefaultCleanup = $SysConfigDBObject->DefaultSettingDirtyCleanUp();
$Self->True(
    $DefaultCleanup,
    "DefaultSettingDirtyCleanUp() - with true",
);

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

my $DeployAndCheck = sub {

    my $ExclusiveLockGUID = $SysConfigDBObject->DeploymentLock(
        UserID => $UserID,
        Force  => 1,
    );

    my $EffectiveValueStrg = 'Test';

    my $DeploymentID = $SysConfigDBObject->DeploymentAdd(
        Comments            => 'UnitTest',
        EffectiveValueStrg  => \$EffectiveValueStrg,
        ExclusiveLockGUID   => $ExclusiveLockGUID,
        UserID              => $UserID,
        DeploymentTimeStamp => '1977-12-12 12:00:00',
    );
    $Self->IsNot(
        $DeploymentID,
        undef,
        'DeploymentAdd()',
    );

    my $DefaultCleanup  = $SysConfigDBObject->DefaultSettingDirtyCleanUp();
    my $ModifiedCleanup = $SysConfigDBObject->ModifiedSettingDirtyCleanUp();

    # Configuration should not be dirty
    my $Result = $SysConfigObject->ConfigurationIsDirtyCheck();
    $Self->Is(
        $Result,
        0,
        'ConfigurationIsDirtyCheck() after deployment',
    );

    my $Success = $SysConfigDBObject->DeploymentUnlock(
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => $UserID,
    );
    $Self->Is(
        $Success,
        1,
        "DeploymentUnlock(). for DeploymentGetLast()",
    );
};

my $XMLContentRaw = <<'EOF',
<Setting Name="UnitTest" Required="1" Valid="1" ConfigLevel="200">
<Description Translatable="1">Test.</Description>
<Navigation>Core</Navigation>
<Value>
    <Item ValueType="String" ValueRegex="">OTRS 6</Item>
</Value>
</Setting>
EOF

    my $XMLContentParsed = {
    Name        => 'UnitTest',
    Required    => '1',
    Valid       => '1',
    ConfigLevel => '200',
    Description => [
        {
            Translatable => '1',
            Content      => 'Test.',
        },
    ],
    Navigation => [
        {
            Content => 'Core',
        },
    ],
    Value => [
        {
            Item => [
                {
                    ValueType  => 'String',
                    Content    => 'OTRS 6',
                    ValueRegex => '',
                },
            ],
        },
    ],
    };

my $DefaultID1 = $SysConfigDBObject->DefaultSettingAdd(
    Name             => $SettingName . '1',
    Description      => "Defines the name of the application ...",
    Valid            => 1,
    HasConfigLevel   => 200,
    Required         => 1,
    Navigation       => "Core",
    XMLContentRaw    => $XMLContentRaw,
    XMLContentParsed => $XMLContentParsed,
    XMLFilename      => 'UnitTest.xml',
    EffectiveValue   => 'OTRS 6',
    UserID           => $UserID,
);
$Self->IsNot(
    $DefaultID1,
    undef,
    'DefaultSettingAdd()',
);

$DeployAndCheck->();

# Provoke dirty configuration by adding a new default.
my $DefaultID2 = $SysConfigDBObject->DefaultSettingAdd(
    Name             => $SettingName . '2',
    Description      => "Defines the name of the application ...",
    Valid            => 1,
    HasConfigLevel   => 200,
    Required         => 1,
    Navigation       => "Core",
    XMLContentRaw    => $XMLContentRaw,
    XMLContentParsed => $XMLContentParsed,
    XMLFilename      => 'UnitTest.xml',
    EffectiveValue   => 'OTRS 6',
    UserID           => $UserID,
);
$Self->IsNot(
    $DefaultID2,
    undef,
    'DefaultSettingAdd()',
);

# Save the Name to use it in the next test
push @SettingDirtyNames, $SettingName . '2';

# Lock setting (so it can be updated).
my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => $UserID,
    Force     => 1,
    DefaultID => $DefaultID1,
);

$Self->True(
    $ExclusiveLockGUID,
    "DefaultSettingLock",
);

my %Result = $SysConfigObject->SettingUpdate(
    DefaultID         => $DefaultID1,
    Name              => $SettingName . '1',
    EffectiveValue    => 'Test Update',
    UserID            => $UserID,
    ExclusiveLockGUID => $ExclusiveLockGUID,
);

$Self->True(
    %Result,
    "SettingUpdate()",
);

# Save the Name to use it in the next test
push @SettingDirtyNames, $SettingName . '1';

# Check for dirty settings
my @SettingDirtyList = $SysConfigObject->ConfigurationDirtySettingsList();

$Self->Is(
    scalar @SettingDirtyNames,
    scalar @SettingDirtyList,
    "ConfigurationDirtySettingsList() - Should be the same as settings added during testing.",
);

for my $IsDirty (@SettingDirtyNames) {
    my $InList = 0;
    if ( grep {/^$IsDirty/} @SettingDirtyList ) {
        $InList = 1;
    }
    $Self->Is(
        $InList,
        1,
        "ConfigurationDirtySettingsList() - $IsDirty: $InList",
    );
}

$DeployAndCheck->();

# Check for dirty settings
@SettingDirtyList = $SysConfigObject->ConfigurationDirtySettingsList();

$Self->Is(
    scalar @SettingDirtyList,
    0,
    "ConfigurationDirtySettingsList() - Should be empty.",
);

1;
