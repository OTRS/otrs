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

my $SettingName1 = 'ProductName ' . $HelperObject->GetRandomNumber() . 1;
my $SettingName2 = 'ProductName ' . $HelperObject->GetRandomNumber() . 2;
my $SettingName3 = 'ProductName ' . $HelperObject->GetRandomNumber() . 3;
my $SettingName4 = 'ProductName ' . $HelperObject->GetRandomNumber() . 4;

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
    my @ValidSettingXML = (
        <<'EOF',
<Setting Name="Test1" Required="1" Valid="1">
    <Description Translatable="1">Test 1.</Description>
    <Navigation>Core::Ticket</Navigation>
    <Value>
        <Item ValueType="String" ValueRegex=".*">Test setting 1</Item>
    </Value>
</Setting>
EOF
        <<'EOF',
<Setting Name="Test2" Required="1" Valid="1">
    <Description Translatable="1">Test 2.</Description>
    <Navigation>Core::Ticket</Navigation>
    <Value>
        <Item ValueType="File">/usr/bin/gpg</Item>
    </Value>
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
        XMLContentRaw            => $ValidSettingXMLAndPerl[0]->{XML},
        XMLContentParsed         => $ValidSettingXMLAndPerl[0]->{Perl},
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
        XMLContentRaw            => $ValidSettingXMLAndPerl[0]->{XML},
        XMLContentParsed         => $ValidSettingXMLAndPerl[0]->{Perl},
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
        XMLContentRaw            => $ValidSettingXMLAndPerl[0]->{XML},
        XMLContentParsed         => $ValidSettingXMLAndPerl[0]->{Perl},
        XMLFilename              => 'UnitTest.xml',
        EffectiveValue           => 'Test setting 4',
        UserID                   => 1,
    );
    $Self->True(
        $DefaultSettingID4,
        "Default setting added - $SettingName4",
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
        },
    },
);

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/';

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
my $MainObject      = $Kernel::OM->Get('Kernel::System::Main');

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

    my $Success = $SysConfigObject->ConfigurationDeploy(
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

    my $Success = $SysConfigObject->ConfigurationDeploy(
        AllSettings  => 1,
        Force        => 1,
        Comments     => "Some comments",
        NoValidation => $Test->{NoValidation},
        UserID       => 1,
    );

    $Self->Is(
        $Success // 0,
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

1;
