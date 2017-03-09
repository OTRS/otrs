
# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
## nofilter(TidyAll::Plugin::OTRS::Perl::TestSubs)
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

# Delete sysconfig_modified_version
return if !$DBObject->Do(
    SQL => 'DELETE FROM sysconfig_modified_version',
);

# Delete sysconfig_modified
return if !$DBObject->Do(
    SQL => 'DELETE FROM sysconfig_modified',
);

# Delete sysconfig_default_version
return if !$DBObject->Do(
    SQL => 'DELETE FROM sysconfig_default_version',
);

# Delete sysconfig_default
return if !$DBObject->Do(
    SQL => 'DELETE FROM sysconfig_default',
);

#
# Prepare valid config XML and Perl
#
my @ValidSettingXML = (
    <<'EOF',
<Setting Name="Test1" Required="1" Valid="1">
    <Description Translatable="1">Test 1.</Description>
    <Group>Ticket</Group>
    <SubGroup>Core::Ticket</SubGroup>
    <Setting>
        <Item ValueType="String" ValueRegex=".*">Test setting 1</Item>
    </Setting>
</Setting>
EOF
    <<'EOF',
<Setting Name="Test2" Required="1" Valid="1">
    <Description Translatable="1">Test 2.</Description>
    <Group>Ticket</Group>
    <SubGroup>Core::Ticket</SubGroup>
    <Setting>
        <Item ValueType="File">/usr/bin/gpg</Item>
    </Setting>
</Setting>
EOF
);

my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');
my @ValidSettingXMLAndPerl;
for my $ValidSettingXML (@ValidSettingXML) {
    push @ValidSettingXMLAndPerl, {
        XML  => $ValidSettingXML,
        Perl => $SysConfigXMLObject->SettingParse( SettingXML => $ValidSettingXML ),
    };
}

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

# Add default setting s
my $SettingName1      = 'ProductName ' . $HelperObject->GetRandomNumber() . 1;
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
    XMLContentRaw            => $ValidSettingXMLAndPerl[0]->{XML},
    XMLContentParsed         => $ValidSettingXMLAndPerl[0]->{Perl},
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test setting 1',
    UserID                   => 1,
);

my $SettingName2      = 'ProductName ' . $HelperObject->GetRandomNumber() . 2;
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
    XMLContentRaw            => $ValidSettingXMLAndPerl[0]->{XML},
    XMLContentParsed         => $ValidSettingXMLAndPerl[0]->{Perl},
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test setting 2',
    UserID                   => 1,
);

my $SettingName3      = 'ProductName ' . $HelperObject->GetRandomNumber() . 3;
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
    XMLContentRaw            => $ValidSettingXMLAndPerl[0]->{XML},
    XMLContentParsed         => $ValidSettingXMLAndPerl[0]->{Perl},
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test setting 3',
    UserID                   => 1,
);

my $SettingName4      = 'ProductName ' . $HelperObject->GetRandomNumber() . 4;
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
    XMLContentRaw            => $ValidSettingXMLAndPerl[0]->{XML},
    XMLContentParsed         => $ValidSettingXMLAndPerl[0]->{Perl},
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test setting 4',
    UserID                   => 1,
);

my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    LockAll => 1,
    Force   => 1,
    UserID  => 1,
);

# Create a effective user modified setting
my $ModifiedIDUser = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID         => $DefaultSettingID1,
    Name              => $SettingName1,
    IsValid           => 1,
    EffectiveValue    => 'User setting 1',
    TargetUserID      => 1,
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);

$ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    LockAll => 1,
    Force   => 1,
    UserID  => 1,
);
my $ModifiedID1 = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID         => $DefaultSettingID1,
    Name              => $SettingName1,
    IsValid           => 1,
    EffectiveValue    => 'Modified setting 1',
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);

my $ModifiedID2 = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID         => $DefaultSettingID2,
    Name              => $SettingName2,
    IsValid           => 1,
    EffectiveValue    => 'Modified setting 2',
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);

my $TestUserLogin = $HelperObject->TestUserCreate();
my $UserID        = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $TestUserLogin,
);

my $ExclusiveLockGUID2 = $SysConfigDBObject->DefaultSettingLock(
    DefaultID => $DefaultSettingID3,
    Force     => 1,
    UserID    => $UserID,
);
my $ModifiedID3 = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID         => $DefaultSettingID3,
    Name              => $SettingName3,
    IsValid           => 1,
    EffectiveValue    => 'Modified setting 3',
    ExclusiveLockGUID => $ExclusiveLockGUID2,
    UserID            => $UserID,
);

my @Tests = (
    {
        Name   => "Invalid TargetUserID",
        Config => {
            TargetUserID => $TestUserLogin,
        },
    },
    {
        Name   => "Invalid ModifiedIDs",
        Config => {
            ModifiedIDs => $TestUserLogin,
        },
    },
    {
        Name   => "Empty ModifiedIDs",
        Config => {
            ModifiedIDs => [],
        },
    },
    {
        Name   => "Wrong TargetUserID",
        Config => {
            TargetUserID => $UserID,
        },
        ExpectedResults => [ $ModifiedIDUser, $ModifiedID1, $ModifiedID2, $ModifiedID3 ],
        Success         => 1,
    },
    {
        Name   => "Clean settings for user 1",
        Config => {
            TargetUserID => 1,
        },
        ExpectedResults => [ $ModifiedID1, $ModifiedID2, $ModifiedID3 ],
        Success         => 1,
    },
    {
        Name   => "Global for ModifiedID1",
        Config => {
            ModifiedIDs => [$ModifiedID1],
        },
        ExpectedResults => [ $ModifiedID2, $ModifiedID3 ],
        Success         => 1,
    },
    {
        Name            => "Global All",
        Config          => {},
        ExpectedResults => [],
        Success         => 1,
    },
);

TEST:
for my $Test (@Tests) {

    my $Success = $SysConfigDBObject->ModifiedSettingDirtyCleanUp( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->False(
            $Success,
            "$Test->{Name} ModifiedSettingDirtyCleanUp() with False",
        );

        next TEST;
    }

    $Self->True(
        $Success,
        "$Test->{Name} ModifiedSettingDirtyCleanUp() with Success",
    );

    my @List = $SysConfigDBObject->ModifiedSettingListGet(
        IsDirty => 1,
    );

    my @SettingIDs = map { $_->{ModifiedID} } @List;

    $Self->IsDeeply(
        \@SettingIDs,
        $Test->{ExpectedResults},
        "$Test->{Name} Settings List after ModifiedSettingDirtyCleanUp()",
    );

}

1;
