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

# Get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

# Get helper object.
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TestUserLogin = $HelperObject->TestUserCreate(
    Groups   => [ 'admin', 'users' ],
    Language => 'en'
);
my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $TestUserLogin,
);

# Get SysConfig DB object
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

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

# Get SysConfig object.
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

# Configuration should not be dirty
my $Result = $SysConfigObject->ConfigurationIsDirtyCheck();
$Self->Is(
    $Result,
    0,
    'ConfigurationIsDirtyCheck() on clean system',
);

# Provoke dirty configuration by adding a new default.
my $DefaultID = $SysConfigDBObject->DefaultSettingAdd(
    Name           => "UnitTest",
    Description    => "Defines the name of the application ...",
    Valid          => 1,
    HasConfigLevel => 200,
    Required       => 1,
    Navigation     => "Core",
    XMLContentRaw  => <<'EOF',
<Setting Name="UnitTest" Required="1" Valid="1" ConfigLevel="200">
    <Description Translatable="1">Test.</Description>
    <Navigation>Core</Navigation>
    <Value>
        <Item ValueType="String" ValueRegex="">OTRS 6</Item>
    </Value>
</Setting>
EOF
    XMLContentParsed => {
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
    },
    XMLFilename    => 'UnitTest.xml',
    EffectiveValue => 'OTRS 6',
    UserID         => 1,
);
$Self->IsNot(
    $DefaultID,
    undef,
    'DefaultSettingAdd()',
);

# Configuration should be dirty
$Result = $SysConfigObject->ConfigurationIsDirtyCheck();
$Self->Is(
    $Result,
    1,
    'ConfigurationIsDirtyCheck() after DefaultSettingAdd()',
);

my $DeployAndCheck = sub {

    my $ExclusiveLockGUID = $SysConfigDBObject->DeploymentLock(
        UserID => 1,
        Force  => 1,
    );

    my $EffectiveValueStrg = 'Test';

    my $DeploymentID = $SysConfigDBObject->DeploymentAdd(
        Comments            => 'UnitTest',
        EffectiveValueStrg  => \$EffectiveValueStrg,
        ExclusiveLockGUID   => $ExclusiveLockGUID,
        DeploymentTimeStamp => '1977-12-12 12:00:00',
        UserID              => 1,
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
    $Result = $SysConfigObject->ConfigurationIsDirtyCheck(
        UserID => 1,
    );
    $Self->Is(
        $Result,
        0,
        "ConfigurationIsDirtyCheck() after deployment for UserID 1",
    );
    $Result = $SysConfigObject->ConfigurationIsDirtyCheck(
        UserID => $TestUserID,
    );
    $Self->Is(
        $Result,
        0,
        "ConfigurationIsDirtyCheck() after deployment for UserID $TestUserID",
    );

};

$DeployAndCheck->();

my $Success = $SysConfigDBObject->DeploymentUnlock(
    All => 1,
);
$Self->True(
    $Success,
    'Unlock all deployment',
);

my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => 1,
    Force     => 1,
    DefaultID => $DefaultID,
);

# Provoke dirty configuration by updating a new default.
$Success = $SysConfigDBObject->DefaultSettingUpdate(
    DefaultID         => $DefaultID,
    ExclusiveLockGUID => $ExclusiveLockGUID,
    Name              => "UnitTest",
    Description       => "Defines the name of the application ...",
    HasConfigLevel    => 200,
    Required          => 1,
    Navigation        => "Core",
    XMLContentRaw     => <<'EOF',
<Setting Name="UnitTest" Required="1" Valid="1" ConfigLevel="200">
    <Description Translatable="1">Test.</Description>
    <Navigation>Core</Navigation>
    <Value>
        <Item ValueType="String" ValueRegex="">OTRS 6 Update</Item>
    </Value>
</Setting>
EOF
    XMLContentParsed => {
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
                        Content    => 'OTRS 6 Update',
                        ValueRegex => '',
                    },
                ],
            },
        ],
    },
    EffectiveValue => 'OTRS 6 Update',
    XMLFilename    => 'UnitTest.xml',
    UserID         => 1,
);
$Self->IsNot(
    $Success,
    undef,
    'DefaultSettingUpdate()',
);

# Configuration should be dirty
$Result = $SysConfigObject->ConfigurationIsDirtyCheck();
$Self->Is(
    $Result,
    1,
    'ConfigurationIsDirtyCheck() after DefaultSettingUpdate()',
);
$Result = $SysConfigObject->ConfigurationIsDirtyCheck(
    UserID => 1,
);
$Self->Is(
    $Result,
    1,
    "ConfigurationIsDirtyCheck() after DefaultSettingUpdate() for UserID 1",
);
$Result = $SysConfigObject->ConfigurationIsDirtyCheck(
    UserID => $TestUserID,
);
$Self->Is(
    $Result,
    1,
    "ConfigurationIsDirtyCheck() after DefaultSettingUpdate() for UserID $TestUserID",
);

$DeployAndCheck->();

$Success = $SysConfigDBObject->DeploymentUnlock(
    All => 1,
);
$Self->True(
    $Success,
    'Unlock all deployment',
);

# Lock setting again
$ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => 1,
    Force     => 1,
    DefaultID => $DefaultID,
);

# Provoke dirty configuration by adding a new modified.
my $ModifiedID = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID         => $DefaultID,
    Name              => "UnitTest",
    EffectiveValue    => 'OTRS 6 Modified',
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);
$Self->IsNot(
    $ModifiedID,
    undef,
    'ModifiedSettingAdd()',
);

# Configuration should be dirty
$Result = $SysConfigObject->ConfigurationIsDirtyCheck();
$Self->Is(
    $Result,
    1,
    'ConfigurationIsDirtyCheck() after ModifiedSettingAdd()',
);
$Result = $SysConfigObject->ConfigurationIsDirtyCheck(
    UserID => 1,
);
$Self->Is(
    $Result,
    1,
    "ConfigurationIsDirtyCheck() after ModifiedSettingAdd() for UserID 1",
);
$Result = $SysConfigObject->ConfigurationIsDirtyCheck(
    UserID => $TestUserID,
);
$Self->Is(
    $Result,
    0,
    "ConfigurationIsDirtyCheck() after ModifiedSettingAdd() for UserID $TestUserID",
);

$DeployAndCheck->();

$Success = $SysConfigDBObject->DeploymentUnlock(
    All => 1,
);
$Self->True(
    $Success,
    'Unlock all deployment',
);

# Lock setting
$ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    DefaultID => $DefaultID,
    UserID    => 1,
    Force     => 1,
);

my $IsLock = $SysConfigDBObject->DefaultSettingIsLocked(
    DefaultID => $DefaultID,
);

if ($ExclusiveLockGUID) {
    $Self->True(
        $IsLock,
        'Default setting must be lock.',
    );
}

# Provoke dirty configuration by updating a modified.
$Success = $SysConfigDBObject->ModifiedSettingUpdate(
    ModifiedID             => $ModifiedID,
    DefaultID              => $DefaultID,
    Name                   => "UnitTest",
    UserModificationActive => 0,
    EffectiveValue         => 'OTRS 6 Modified Update',
    ExclusiveLockGUID      => $ExclusiveLockGUID,
    UserID                 => 1,
);
$Self->IsNot(
    $Success,
    undef,
    'ModifiedSettingUpdate()',
);

# Configuration should be dirty
$Result = $SysConfigObject->ConfigurationIsDirtyCheck();
$Self->Is(
    $Result,
    1,
    'ConfigurationIsDirtyCheck() after ModifiedSettingUpdate()',
);
$Result = $SysConfigObject->ConfigurationIsDirtyCheck(
    UserID => 1,
);
$Self->Is(
    $Result,
    1,
    "ConfigurationIsDirtyCheck() after ModifiedSettingUpdate() for UserID 1",
);
$Result = $SysConfigObject->ConfigurationIsDirtyCheck(
    UserID => $TestUserID,
);
$Self->Is(
    $Result,
    0,
    "ConfigurationIsDirtyCheck() after ModifiedSettingUpdate() for UserID $TestUserID",
);
$DeployAndCheck->();

1;
