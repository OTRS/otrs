# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
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

# Get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

my $RandomNumber = $HelperObject->GetRandomNumber();

$HelperObject->FixedTimeSet();

my $SettingName1 = 'ProductName ' . $RandomNumber . 1;
my $SettingName2 = 'ProductName ' . $RandomNumber . 2;
my $SettingName3 = 'ProductName ' . $RandomNumber . 3;
my $SettingName4 = 'ProductName ' . $RandomNumber . 4;

#
# Prepare valid config XML and Perl
#
my $ValidSettingXML = <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<otrs_config version="2.0" init="Framework">
    <Setting Name="Test1" Required="1" Valid="1">
        <Description Translatable="1">Test 1.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">Test setting 1</Item>
        </Value>
    </Setting>
    <Setting Name="Test2" Required="1" Valid="1">
        <Description Translatable="1">Test 2.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="File">/usr/bin/gpg</Item>
        </Value>
    </Setting>
</otrs_config>
EOF

    my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');

my @DefaultSettingAddParams = $SysConfigXMLObject->SettingListParse(
    XMLInput => $ValidSettingXML,
);

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

# Add default setting s
my $DefaultSettingID1 = $SysConfigDBObject->DefaultSettingAdd(
    Name                     => $SettingName1,
    Description              => 'Defines the name of the application ...',
    Navigation               => 'ASimple::Path::Structure',
    IsInvisible              => 1,
    IsReadonly               => 0,
    IsRequired               => 1,
    IsValid                  => 1,
    HasConfigLevel           => 200,
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    UserPreferencesGroup     => 'Advanced',
    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test setting 1',
    UserID                   => 1,
);
$Self->IsNot(
    $DefaultSettingID1,
    undef,
    "DefaultSettingAdd() for $SettingName1",
);

my $DefaultSettingID2 = $SysConfigDBObject->DefaultSettingAdd(
    Name                     => $SettingName2,
    Description              => 'Defines the name of the application ...',
    Navigation               => 'ASimple::Path::Structure',
    IsInvisible              => 1,
    IsReadonly               => 0,
    IsRequired               => 1,
    IsValid                  => 1,
    HasConfigLevel           => 200,
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    UserPreferencesGroup     => 'Advanced',
    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test setting 2',
    UserID                   => 1,
);
$Self->IsNot(
    $DefaultSettingID2,
    undef,
    "DefaultSettingAdd() for $SettingName2",
);

my $DefaultSettingID3 = $SysConfigDBObject->DefaultSettingAdd(
    Name                     => $SettingName3,
    Description              => 'Defines the name of the application ...',
    Navigation               => 'ASimple::Path::Structure',
    IsInvisible              => 1,
    IsReadonly               => 0,
    IsRequired               => 1,
    IsValid                  => 1,
    HasConfigLevel           => 200,
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    UserPreferencesGroup     => 'Advanced',
    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test setting 3',
    UserID                   => 1,
);
$Self->IsNot(
    $DefaultSettingID3,
    undef,
    "DefaultSettingAdd() for $SettingName3",
);

my $DefaultSettingID4 = $SysConfigDBObject->DefaultSettingAdd(
    Name                     => $SettingName4,
    Description              => 'Defines the name of the application ...',
    Navigation               => 'ASimple::Path::Structure',
    IsInvisible              => 1,
    IsReadonly               => 0,
    IsRequired               => 1,
    IsValid                  => 1,
    HasConfigLevel           => 200,
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    UserPreferencesGroup     => 'Advanced',
    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test setting 4',
    UserID                   => 1,
);
$Self->IsNot(
    $DefaultSettingID4,
    undef,
    "DefaultSettingAdd() for $SettingName4",
);

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    LockAll => 1,
    Force   => 1,
    UserID  => 1,
);

my %Result = $SysConfigObject->SettingUpdate(
    Name              => $SettingName1,
    IsValid           => 1,
    EffectiveValue    => 'Modified 1 Setting 1',
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);
$Self->True(
    $Result{Success},
    "SettingUpdate() for $SettingName1 with true",
);

%Result = $SysConfigObject->SettingUpdate(
    Name              => $SettingName3,
    IsValid           => 1,
    EffectiveValue    => 'Modified 1 Setting 3',
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);
$Self->True(
    $Result{Success},
    "SettingUpdate() for $SettingName3 with true",
);

my $Success = $SysConfigDBObject->DefaultSettingUnlock(
    UnlockAll => 1,
);

$Success = $SysConfigObject->ConfigurationDeploy(
    Comments     => "UnitTest",
    UserID       => 1,
    Force        => 1,
    NoValidation => 1,
);
$Self->True(
    $Success,
    "ConfigurationDeploy() 1 with true",
);

my %Deployment = $SysConfigObject->ConfigurationDeployGetLast();

my @List = $SysConfigObject->ConfigurationDeploySettingsListGet(
    DeploymentID => $Deployment{DeploymentID},
);

# There are some settings deployed in Selenium tests, skip them.
@List = grep { $_->{Name} !~ m{^Example.*} } @List;

my %SettingsResult = map { $_->{Name} => $_->{EffectiveValue} } @List;

$Self->IsDeeply(
    \%SettingsResult,
    {
        $SettingName1 => 'Modified 1 Setting 1',
        $SettingName3 => 'Modified 1 Setting 3',
    },
    "ConfigurationDeployGetLast() Deployment 1",
);

$ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    LockAll => 1,
    Force   => 1,
    UserID  => 1,
);

%Result = $SysConfigObject->SettingUpdate(
    Name              => $SettingName1,
    IsValid           => 1,
    EffectiveValue    => 'Modified 2 Setting 1',
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);
$Self->True(
    $Result{Success},
    "SettingUpdate() for $SettingName1 with true",
);

%Result = $SysConfigObject->SettingUpdate(
    Name              => $SettingName2,
    IsValid           => 1,
    EffectiveValue    => 'Modified 1 Setting 2',
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);
$Self->True(
    $Result{Success},
    "SettingUpdate() for $SettingName2 with true",
);

%Result = $SysConfigObject->SettingUpdate(
    Name              => $SettingName4,
    IsValid           => 1,
    EffectiveValue    => 'Modified 1 Setting 4',
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);
$Self->True(
    $Result{Success},
    "SettingUpdate() for $SettingName4 with true",
);

$Success = $SysConfigDBObject->DefaultSettingUnlock(
    UnlockAll => 1,
);

# Make sure that there is enough time between two ConfigurationDeploy() calls.
# DeploymentModifiedVersionList() method works with timestamps, so it can return
# data which was deployed in previous deployment. See https://bugs.otrs.org/show_bug.cgi?id=13071.
$HelperObject->FixedTimeAddSeconds(2);

$Success = $SysConfigObject->ConfigurationDeploy(
    Comments     => "UnitTest",
    UserID       => 1,
    Force        => 1,
    NoValidation => 1,
);
$Self->True(
    $Success,
    "ConfigurationDeploy() 2 with true",
);

%Deployment = $SysConfigObject->ConfigurationDeployGetLast();

@List = $SysConfigObject->ConfigurationDeploySettingsListGet(
    DeploymentID => $Deployment{DeploymentID},
);

%SettingsResult = map { $_->{Name} => $_->{EffectiveValue} } @List;

$Self->IsDeeply(
    \%SettingsResult,
    {
        $SettingName1 => 'Modified 2 Setting 1',
        $SettingName2 => 'Modified 1 Setting 2',
        $SettingName4 => 'Modified 1 Setting 4',
    },
    "ConfigurationDeployGetLast() Deployment 2",
);

1;
