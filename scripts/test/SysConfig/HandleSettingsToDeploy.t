# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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

my $SettingName1 = 'ProductName ' . $HelperObject->GetRandomNumber() . 1;
my $SettingName2 = 'ProductName ' . $HelperObject->GetRandomNumber() . 2;
my $SettingName3 = 'ProductName ' . $HelperObject->GetRandomNumber() . 3;
my $SettingName4 = 'ProductName ' . $HelperObject->GetRandomNumber() . 4;
my $SettingName5 = 'ProductName ' . $HelperObject->GetRandomNumber() . 5;

my $Cleanup = sub {

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

    # Add default settings
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
        XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
        XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
        XMLFilename              => 'UnitTest.xml',
        EffectiveValue           => 'Test setting 1',
        UserID                   => 1,
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
        XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
        XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
        XMLFilename              => 'UnitTest.xml',
        EffectiveValue           => 'Test setting 2',
        UserID                   => 1,
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
        XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
        XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
        XMLFilename              => 'UnitTest.xml',
        EffectiveValue           => 'Test setting 3',
        UserID                   => 1,
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
        XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
        XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
        XMLFilename              => 'UnitTest.xml',
        EffectiveValue           => 'Test setting 4',
        UserID                   => 1,
    );

    my $DefaultSettingID5 = $SysConfigDBObject->DefaultSettingAdd(
        Name                     => $SettingName5,
        Description              => 'Defines the name of the application ...',
        Navigation               => 'ASimple::Path::Structure',
        IsInvisible              => 1,
        IsReadonly               => 0,
        IsRequired               => 1,
        IsValid                  => 1,
        HasConfigLevel           => 200,
        UserModificationPossible => 1,
        UserModificationActive   => 1,
        XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
        XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
        XMLFilename              => 'UnitTest.xml',
        EffectiveValue           => 'Test setting 5',
        UserID                   => 1,
    );

    my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
        LockAll => 1,
        Force   => 1,
        UserID  => 1,
    );

    # Modify setting 1 and add 2 versions (keep setting 1 dirty)
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

    my %DefaultSettingVersionGetLast1 = $SysConfigDBObject->DefaultSettingVersionGetLast(
        DefaultID => $DefaultSettingID1,
    );
    $Self->True(
        \%DefaultSettingVersionGetLast1,
        'DefaultSettingVersionGetLast get version for default.',
    );

    my $DefaultSettingVersionID1 = $DefaultSettingVersionGetLast1{DefaultVersionID};

    my $Modified1VersionID1 = $SysConfigDBObject->ModifiedSettingVersionAdd(
        DefaultVersionID    => $DefaultSettingVersionID1,
        Name                => $SettingName1,
        IsValid             => 1,
        EffectiveValue      => 'Modified version 1 Setting 1',
        DeploymentTimeStamp => '2015-12-12 12:00:00',
        UserID              => 1,
    );
    my $Modified1VersionID2 = $SysConfigDBObject->ModifiedSettingVersionAdd(
        DefaultVersionID    => $DefaultSettingVersionID1,
        Name                => $SettingName1,
        IsValid             => 1,
        EffectiveValue      => 'Modified version 2 Setting 1',
        DeploymentTimeStamp => '2015-12-12 12:00:00',
        UserID              => 1,
    );

    # Modify setting 2 and create 1 version (remove dirty flag)
    my $ModifiedID2 = $SysConfigDBObject->ModifiedSettingAdd(
        DefaultID         => $DefaultSettingID2,
        Name              => $SettingName2,
        IsValid           => 1,
        EffectiveValue    => 'Modified setting 2',
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    my %DefaultSettingVersionGetLast2 = $SysConfigDBObject->DefaultSettingVersionGetLast(
        DefaultID => $DefaultSettingID2,
    );
    $Self->True(
        \%DefaultSettingVersionGetLast2,
        'DefaultSettingVersionGetLast get version for default.',
    );

    my $DefaultSettingVersionID2 = $DefaultSettingVersionGetLast1{DefaultVersionID};

    my $Modified2VersionID1 = $SysConfigDBObject->ModifiedSettingVersionAdd(
        DefaultVersionID    => $DefaultSettingVersionID2,
        Name                => $SettingName2,
        IsValid             => 1,
        EffectiveValue      => 'Modified setting 2',
        DeploymentTimeStamp => '2015-12-12 12:00:00',
        UserID              => 1,
    );

    my $ExclusiveLockGUID2 = $SysConfigDBObject->DefaultSettingLock(
        DefaultID => $DefaultSettingID3,
        Force     => 1,
        UserID    => 1,
    );
    my $ModifiedID3 = $SysConfigDBObject->ModifiedSettingAdd(
        DefaultID         => $DefaultSettingID3,
        Name              => $SettingName3,
        IsValid           => 1,
        EffectiveValue    => 'Modified setting 3',
        ExclusiveLockGUID => $ExclusiveLockGUID2,
        UserID            => 1,
    );

    # Modify setting 5 and add 1 versions (keep setting 1 dirty)
    my $ExclusiveLockGUID3 = $SysConfigDBObject->DefaultSettingLock(
        LockAll => 1,
        Force   => 1,
        UserID  => 1,
    );
    my $ModifiedID4 = $SysConfigDBObject->ModifiedSettingAdd(
        DefaultID         => $DefaultSettingID5,
        Name              => $SettingName5,
        IsValid           => 1,
        ResetToDefault    => 1,
        EffectiveValue    => 'Modified setting 5',
        ExclusiveLockGUID => $ExclusiveLockGUID3,
        UserID            => 1,
    );

    my %DefaultSettingVersionGetLast3 = $SysConfigDBObject->DefaultSettingVersionGetLast(
        DefaultID => $DefaultSettingID5,
    );
    $Self->True(
        \%DefaultSettingVersionGetLast3,
        'DefaultSettingVersionGetLast get version for default.',
    );

    my $DefaultSettingVersionID3 = $DefaultSettingVersionGetLast3{DefaultVersionID};

    my $Modified1VersionID3 = $SysConfigDBObject->ModifiedSettingVersionAdd(
        DefaultVersionID    => $DefaultSettingVersionID3,
        Name                => $SettingName5,
        IsValid             => 1,
        EffectiveValue      => 'Modified version 1 Setting 5',
        DeploymentTimeStamp => '2015-12-12 12:00:00',
        UserID              => 1,
    );

    $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            UPDATE sysconfig_modified
            SET is_dirty = 0
            WHERE is_dirty = 1
                AND id = ?
        ',
        Bind => [ \$ModifiedID2 ],
    );

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    $CacheObject->CleanUp(
        Type => 'SysConfigModified',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigModifiedList',
    );
    $CacheObject->CleanUp(
        Type => 'SysConfigModifiedVersion',
    );
};

my @Tests = (
    {
        Name           => 'Empty',
        Config         => {},
        ExpectedValues => {
            $SettingName1 => {
                IsDirty          => 1,
                EffectiveValue   => 'Modified setting 1',
                LastVersionValue => 'Modified version 2 Setting 1',
            },
            $SettingName2 => {
                IsDirty          => 0,
                EffectiveValue   => 'Modified setting 2',
                LastVersionValue => 'Modified setting 2',
            },
            $SettingName3 => {
                IsDirty          => 1,
                EffectiveValue   => 'Modified setting 3',
                LastVersionValue => 'Test setting 3',
            },
            $SettingName5 => {
                IsDirty          => 1,
                EffectiveValue   => 'Modified setting 5',
                LastVersionValue => 'Modified version 1 Setting 5',
            },
        },
    },
    {
        Name   => 'Missing UserID',
        Config => {
            DeploymentTimeStamp => '1977-12-12 12:00:00',
        },
        ExpectedValues => {
            $SettingName1 => {
                IsDirty          => 1,
                EffectiveValue   => 'Modified setting 1',
                LastVersionValue => 'Modified version 2 Setting 1',
            },
            $SettingName2 => {
                IsDirty          => 0,
                EffectiveValue   => 'Modified setting 2',
                LastVersionValue => 'Modified setting 2',
            },
            $SettingName3 => {
                IsDirty          => 1,
                EffectiveValue   => 'Modified setting 3',
                LastVersionValue => 'Test setting 3',
            },
            $SettingName5 => {
                IsDirty          => 1,
                EffectiveValue   => 'Modified setting 5',
                LastVersionValue => 'Modified version 1 Setting 5',
            },
        },
    },
    {
        Name   => 'Missing DeploymentTimeStamp',
        Config => {
            UserID => 1,
        },
        ExpectedValues => {
            $SettingName1 => {
                IsDirty          => 1,
                EffectiveValue   => 'Modified setting 1',
                LastVersionValue => 'Modified version 2 Setting 1',
            },
            $SettingName2 => {
                IsDirty          => 0,
                EffectiveValue   => 'Modified setting 2',
                LastVersionValue => 'Modified setting 2',
            },
            $SettingName3 => {
                IsDirty          => 1,
                EffectiveValue   => 'Modified setting 3',
                LastVersionValue => 'Test setting 3',
            },
            $SettingName5 => {
                IsDirty          => 1,
                EffectiveValue   => 'Modified setting 5',
                LastVersionValue => 'Modified version 1 Setting 5',
            },
        },
    },

    {
        Name   => 'NotDirty',
        Config => {
            NotDirty            => 1,
            DeploymentTimeStamp => '1977-12-12 12:00:00',
            UserID              => 1,
        },
        ExpectedValues => {
            $SettingName1 => {
                IsDirty          => 1,
                EffectiveValue   => 'Modified setting 1',
                LastVersionValue => 'Modified version 2 Setting 1',
            },
            $SettingName2 => {
                IsDirty          => 0,
                EffectiveValue   => 'Modified setting 2',
                LastVersionValue => 'Modified setting 2',
            },
            $SettingName3 => {
                IsDirty          => 1,
                EffectiveValue   => 'Modified setting 3',
                LastVersionValue => 'Test setting 3',
            },
            $SettingName5 => {
                IsDirty          => 1,
                EffectiveValue   => 'Modified setting 5',
                LastVersionValue => 'Modified version 1 Setting 5',
            },
        },
    },
    {
        Name   => 'Delete reseted setting',
        Config => {
            AllSettings         => 1,
            DeploymentTimeStamp => '1977-12-12 12:00:00',
            UserID              => 1,
        },
        ExpectedValues => {
            $SettingName1 => {
                IsDirty          => 0,
                EffectiveValue   => 'Modified setting 1',
                LastVersionValue => 'Modified setting 1',
            },
            $SettingName2 => {
                IsDirty          => 0,
                EffectiveValue   => 'Modified setting 2',
                LastVersionValue => 'Modified setting 2',
            },
            $SettingName3 => {
                IsDirty          => 0,
                EffectiveValue   => 'Modified setting 3',
                LastVersionValue => 'Modified setting 3',
            },
        },
    },
    {
        Name   => 'All',
        Config => {
            AllSettings         => 1,
            DeploymentTimeStamp => '1977-12-12 12:00:00',
            UserID              => 1,
        },
        ExpectedValues => {
            $SettingName1 => {
                IsDirty          => 0,
                EffectiveValue   => 'Modified setting 1',
                LastVersionValue => 'Modified setting 1',
            },
            $SettingName2 => {
                IsDirty          => 0,
                EffectiveValue   => 'Modified setting 2',
                LastVersionValue => 'Modified setting 2',
            },
            $SettingName3 => {
                IsDirty          => 0,
                EffectiveValue   => 'Modified setting 3',
                LastVersionValue => 'Modified setting 3',
            },
        },
    },
    {
        Name   => 'DirtySettings Setting3',
        Config => {
            DirtySettings       => [$SettingName3],
            DeploymentTimeStamp => '1977-12-12 12:00:00',
            UserID              => 1,
        },
        ExpectedValues => {
            $SettingName1 => {
                IsDirty          => 1,
                EffectiveValue   => 'Modified setting 1',
                LastVersionValue => 'Modified version 2 Setting 1',
            },
            $SettingName2 => {
                IsDirty          => 0,
                EffectiveValue   => 'Modified setting 2',
                LastVersionValue => 'Modified setting 2',
            },
            $SettingName3 => {
                IsDirty          => 0,
                EffectiveValue   => 'Modified setting 3',
                LastVersionValue => 'Modified setting 3',
            },
            $SettingName5 => {
                IsDirty          => 1,
                EffectiveValue   => 'Modified setting 5',
                LastVersionValue => 'Modified version 1 Setting 5',
            },
        },
    },
    {
        Name   => 'DirtySettings Setting1',
        Config => {
            DirtySettings       => [$SettingName1],
            DeploymentTimeStamp => '1977-12-12 12:00:00',
            UserID              => 1,
        },
        ExpectedValues => {
            $SettingName1 => {
                IsDirty          => 0,
                EffectiveValue   => 'Modified setting 1',
                LastVersionValue => 'Modified setting 1',
            },
            $SettingName2 => {
                IsDirty          => 0,
                EffectiveValue   => 'Modified setting 2',
                LastVersionValue => 'Modified setting 2',
            },
            $SettingName3 => {
                IsDirty          => 1,
                EffectiveValue   => 'Modified setting 3',
                LastVersionValue => 'Test setting 3',
            },
            $SettingName5 => {
                IsDirty          => 1,
                EffectiveValue   => 'Modified setting 5',
                LastVersionValue => 'Modified version 1 Setting 5',
            },
        },
    },
    {
        Name   => 'Basic',
        Config => {
            DeploymentTimeStamp => '1977-12-12 12:00:00',
            UserID              => 1,
        },
        ExpectedValues => {
            $SettingName1 => {
                IsDirty          => 0,
                EffectiveValue   => 'Modified setting 1',
                LastVersionValue => 'Modified setting 1',
            },
            $SettingName2 => {
                IsDirty          => 0,
                EffectiveValue   => 'Modified setting 2',
                LastVersionValue => 'Modified setting 2',
            },
            $SettingName3 => {
                IsDirty          => 0,
                EffectiveValue   => 'Modified setting 3',
                LastVersionValue => 'Modified setting 3',
            },
        },
    },
);

my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

for my $Test (@Tests) {
    $Cleanup->();

    my $Success = $SysConfigObject->_HandleSettingsToDeploy( %{ $Test->{Config} } );

    my @SettingList = $SysConfigDBObject->ModifiedSettingListGet(
        IsGlobal => 1,
    );
    my %Result;

    for my $Setting (@SettingList) {
        $Result{ $Setting->{Name} } = {
            IsDirty        => $Setting->{IsDirty},
            EffectiveValue => $Setting->{EffectiveValue},
        };

        my %ModifiedSettingVersion = $SysConfigDBObject->ModifiedSettingVersionGetLast(
            Name => $Setting->{Name},
        );
        if (%ModifiedSettingVersion) {
            $Result{ $Setting->{Name} }->{LastVersionValue} = $ModifiedSettingVersion{EffectiveValue};
        }
        else {
            my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
                Name => $Setting->{Name},
            );
            $Result{ $Setting->{Name} }->{LastVersionValue} = $DefaultSetting{EffectiveValue};
        }

    }

    $Self->IsDeeply(
        \%Result,
        $Test->{ExpectedValues},
        "$Test->{Name} - _HandleSettingsToDeploy()",
    );
}

1;
