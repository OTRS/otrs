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
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $DBObject        = $Kernel::OM->Get('Kernel::System::DB');
my $MainObject      = $Kernel::OM->Get('Kernel::System::Main');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

# NOTE: This test removes all settings from SysConfig tables and creates
# own deployments, therefore we must handle DB Restore on our own
# (we need to do a deployment after DB is restored).
my $StartedTransaction = $HelperObject->BeginWork();
$Self->True(
    $StartedTransaction,
    'Started database transaction.',
);

my $Home = $ConfigObject->Get('Home') . '/';

my $SettingName1 = 'ProductName ' . $HelperObject->GetRandomNumber() . 1;
my $SettingName2 = 'ProductName ' . $HelperObject->GetRandomNumber() . 2;
my $SettingName3 = 'ProductName ' . $HelperObject->GetRandomNumber() . 3;
my $SettingName4 = 'ProductName ' . $HelperObject->GetRandomNumber() . 4;
my $SettingName5 = 'File' . $HelperObject->GetRandomNumber() . 5;

my $FileLocation = $MainObject->FileWrite(
    Location => "$Home/Kernel/Config/Files/TempFile.txt",
    Content  => \'Some content',
);
$Self->True(
    $FileLocation,
    'Temp file created.'
);
my $FileLocation2 = "$Home/Kernel/Config/Files/TempFile2.txt";

my $TestUserLogin = $HelperObject->TestUserCreate();
my $UserID        = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $TestUserLogin,
);

my $CleanUp = sub {
    my %Param = @_;

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

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'SysConfigDefault',
    );

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'SysConfigModified',
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

    # Add default settings.
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
    $Self->True(
        $DefaultSettingID1,
        "Default setting added - $SettingName1",
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
    $Self->True(
        $DefaultSettingID2,
        "Default setting added - $SettingName2",
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
    $Self->True(
        $DefaultSettingID3,
        "Default setting added - $SettingName3",
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
    $Self->True(
        $DefaultSettingID4,
        "Default setting added - $SettingName4",
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
        XMLContentRaw            => $DefaultSettingAddParams[1]->{XMLContentRaw},
        XMLContentParsed         => $DefaultSettingAddParams[1]->{XMLContentParsed},
        XMLFilename              => 'UnitTest.xml',
        EffectiveValue           => $FileLocation,
        UserID                   => 1,
    );
    $Self->True(
        $DefaultSettingID5,
        "Default setting added - $SettingName5",
    );

    my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
        LockAll => 1,
        Force   => 1,
        UserID  => $UserID,
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

    my $DefaultSettingVersionID2 = $DefaultSettingVersionGetLast2{DefaultVersionID};

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
        Type => 'SysConfigModifiedVersion',
    );

    my $Success = $SysConfigDBObject->DefaultSettingUnlock(
        UnlockAll => 1,
    );

    if ( $Param{AddInvalid} ) {

        $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
            DefaultID => $DefaultSettingID3,
            Force     => 1,
            UserID    => 1,
        );

        $ModifiedID3 = $SysConfigDBObject->ModifiedSettingUpdate(
            DefaultID         => $DefaultSettingID3,
            ModifiedID        => $ModifiedID3,
            Name              => $SettingName3,
            IsValid           => 1,
            EffectiveValue    => ['Modified setting 3'],
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );
    }
};

my @Tests = (
    {
        Name   => 'NotDirty',
        Config => {
            NotDirty => 1,
            UserID   => 1,
            FileName => 'AAAUnitTest.pm',
        },
        ExpectedValues => {
            $SettingName1 => 'Modified version 2 Setting 1',
            $SettingName2 => 'Modified setting 2',
            $SettingName3 => 'Test setting 3',
            $SettingName4 => 'Test setting 4',
            $SettingName5 => $FileLocation,
        },
    },
    {
        Name   => 'All',
        Config => {
            AllSettings => 1,
            UserID      => 1,
            FileName    => 'AAAUnitTest.pm',
        },
        ExpectedValues => {
            $SettingName1 => 'Modified setting 1',
            $SettingName2 => 'Modified setting 2',
            $SettingName3 => 'Modified setting 3',
            $SettingName4 => 'Test setting 4',
            $SettingName5 => $FileLocation,
        },
    },
    {
        Name   => 'DirtySettings Setting3 (wrong user)',
        Config => {
            DirtySettings => [$SettingName3],
            UserID        => 1,
            FileName      => 'AAAUnitTest.pm',
        },
        ExpectedValues => {
            $SettingName1 => 'Modified version 2 Setting 1',
            $SettingName2 => 'Modified setting 2',
            $SettingName3 => 'Test setting 3',
            $SettingName4 => 'Test setting 4',
            $SettingName5 => $FileLocation,
        },
    },
    {
        Name   => 'DirtySettings Setting3',
        Config => {
            DirtySettings => [$SettingName3],
            UserID        => $UserID,
            FileName      => 'AAAUnitTest.pm',
        },
        ExpectedValues => {
            $SettingName1 => 'Modified version 2 Setting 1',
            $SettingName2 => 'Modified setting 2',
            $SettingName3 => 'Modified setting 3',
            $SettingName4 => 'Test setting 4',
            $SettingName5 => $FileLocation,
        },
    },
    {
        Name   => 'DirtySettings Setting1',
        Config => {
            DirtySettings => [$SettingName1],
            UserID        => 1,
            FileName      => 'AAAUnitTest.pm',
        },
        ExpectedValues => {
            $SettingName1 => 'Modified setting 1',
            $SettingName2 => 'Modified setting 2',
            $SettingName3 => 'Test setting 3',
            $SettingName4 => 'Test setting 4',
            $SettingName5 => $FileLocation,
        },
    },
    {
        Name   => 'Normal user deployment',
        Config => {
            UserID   => 1,
            FileName => 'AAAUnitTest.pm',
        },
        ExpectedValues => {
            $SettingName1 => 'Modified setting 1',
            $SettingName2 => 'Modified setting 2',
            $SettingName3 => 'Test setting 3',
            $SettingName4 => 'Test setting 4',
            $SettingName5 => $FileLocation,
        },
    },
);

TEST:
for my $Test (@Tests) {
    $CleanUp->();

    # Calculate the correct file to be loader later:
    my $FilePath;
    my $FileClass;
    if ( $Test->{Config}->{FileName} ) {
        $FileClass = 'Kernel::Config::Files::AAAUnitTest';
        $FilePath  = 'Kernel/Config/Files/AAAUnitTest.pm';
    }
    else {
        $Self->False(
            1,
            "WRONG test $Test->{Name}",
        );
        next TEST;
    }

    $SysConfigObject->ConfigurationDeploy(
        %{ $Test->{Config} },
        Force    => 1,
        Comments => "Some comments",
    );

    # Load the configuration file (but remove it from INC first to get always a fresh copy)
    my %Config;
    delete $INC{$FilePath};
    $MainObject->Require($FileClass);
    $FileClass->Load( \%Config );

    # Delete the created file as it is not needed anymore
    if ( -e $Home . $FilePath ) {
        if ( !unlink $Home . $FilePath ) {
            $Self->False(
                1,
                "$Test->{Name} - could not delete $Home$FilePath",
            );
        }
    }

    $Self->IsNot(
        $Config{CurrentDeploymentID},
        undef,
        "$Test->{Name} - CurrentDeploymentID",
    );
    delete $Config{CurrentDeploymentID};

    $Self->IsDeeply(
        \%Config,
        $Test->{ExpectedValues},
        "$Test->{Name} - ConfigurationDeploy()",
    );
}

$CleanUp->();

# Set effective value to the existing file.
my $SettingUpdated = $SysConfigObject->SettingsSet(
    UserID   => 1,
    Comments => 'Unit test deployment',
    Settings => [
        {
            Name           => $SettingName5,
            EffectiveValue => $FileLocation,
        },
    ],
);

$Self->True(
    $SettingUpdated,
    'Settings deployed properly.'
);

# Move file to another localtion. At this point $SettingName5 is invalid, make sure deployment fails.
`mv $FileLocation $FileLocation2`;

my %Result = $SysConfigObject->ConfigurationDeploy(
    Comments    => "Unit test deployment",
    UserID      => 1,
    AllSettings => 1,
    Force       => 1,
);

$Self->IsDeeply(
    \%Result,
    {
        'Error'   => "Invalid setting: $SettingName5",
        'Success' => 0,
    },
    'Make sure that deployment fails for invalid settings.',
);

# Simulate that setting is overridden in the perl file to the proper value.
$HelperObject->ConfigSettingChange(
    Valid => 1,
    Key   => $SettingName5,
    Value => $FileLocation2,
);

%Result = $SysConfigObject->ConfigurationDeploy(
    Comments    => "Unit test deployment",
    UserID      => 1,
    AllSettings => 1,
    Force       => 1,
);

$Self->IsDeeply(
    \%Result,
    {
        'Success' => 1,
    },
    'Make sure that deployment passed for invalid settings overridden in perl file.',
);

@Tests = (
    {
        Name         => 'AddInvalid Without Validation',
        AddInvalid   => 1,
        NoValidation => 1,
        Success      => 1,
    },
    {
        Name         => 'AddInvalid With Validation',
        AddInvalid   => 1,
        NoValidation => 0,
        Success      => 0,
    },
);

TEST:
for my $Test (@Tests) {
    $CleanUp->( AddInvalid => $Test->{AddInvalid} );

    # Calculate the correct file to be loader later:
    my $FileClass = 'Kernel::Config::Files::AAAUnitTest';
    my $FilePath  = 'Kernel/Config/Files/AAAUnitTest.pm';

    if ( -e $Home . $FilePath ) {
        if ( !unlink $Home . $FilePath ) {
            $Self->False(
                1,
                "$Test->{Name} - could not delete $Home$FilePath",
            );
        }
    }

    my %DeployResult = $SysConfigObject->ConfigurationDeploy(
        AllSettings  => 1,
        Force        => 1,
        Comments     => "Some comments",
        NoValidation => $Test->{NoValidation},
        UserID       => 1,
    );

    $Self->Is(
        $DeployResult{Success} // 0,
        $Test->{Success},
        "$Test->{Name} ConfigurationDeploy()",
    );

    # Delete the created file as it is not needed anymore
    if ( -e $Home . $FilePath ) {
        if ( !unlink $Home . $FilePath ) {
            $Self->False(
                1,
                "$Test->{Name} - could not delete $Home$FilePath",
            );
        }
    }
}

my $TempFileDeleted = $MainObject->FileDelete(
    Location => $FileLocation2,
);
$Self->True(
    $TempFileDeleted,
    'Temp file deleted.',
);

my $RollbackSuccess = $HelperObject->Rollback();
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
$Self->True(
    $RollbackSuccess,
    'Rolled back all database changes and cleaned up the cache.',
);

%Result = $SysConfigObject->ConfigurationDeploy(
    Comments    => "Revert changes.",
    UserID      => 1,
    Force       => 1,
    AllSettings => 1,
);

$Self->True(
    $Result{Success},
    'Configuration restored.',
);

1;
