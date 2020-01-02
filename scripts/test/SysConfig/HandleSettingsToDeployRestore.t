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

my $RandomID1 = $HelperObject->GetRandomID();
my $RandomID2 = $HelperObject->GetRandomID();

#
# Prepare valid config XML and Perl
#
my $ValidSettingXML = <<'EOF';
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

# Give the unit test an extra scope for the redefined functions.
{

    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::System::SysConfig::DB'],
    );

    use Kernel::System::SysConfig::DB;

    # Provoke a failure for 2nd setting, this provokes that 1st setting is restored.
    no warnings qw( once redefine );    ## no critic
    local *Kernel::System::SysConfig::DB::ModifiedSettingVersionAdd = sub {
        my ( $Self, %Param ) = @_;
        return 0 if $Param{Name} eq $RandomID2;
        return 1;
    };

    # Make sure the system does not complaint for missing added versions.
    local *Kernel::System::SysConfig::DB::ModifiedSettingVersionDelete = sub { return 1 };
    use warnings;

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    # Add default settings.
    my $DefaultSettingID1 = $SysConfigDBObject->DefaultSettingAdd(
        Name                     => $RandomID1,
        Description              => 'Test',
        Navigation               => 'ASimple::Path::Structure',
        IsInvisible              => 0,
        IsReadonly               => 0,
        IsRequired               => 0,
        IsValid                  => 1,
        HasConfigLevel           => 200,
        UserModificationPossible => 0,
        UserModificationActive   => 0,
        XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
        XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
        XMLFilename              => 'UnitTest.xml',
        EffectiveValue           => 'Default',
        UserID                   => 1,
    );
    my $DefaultSettingID2 = $SysConfigDBObject->DefaultSettingAdd(
        Name                     => $RandomID2,
        Description              => 'Test',
        Navigation               => 'ASimple::Path::Structure',
        IsInvisible              => 0,
        IsReadonly               => 0,
        IsRequired               => 0,
        IsValid                  => 1,
        HasConfigLevel           => 200,
        UserModificationPossible => 0,
        UserModificationActive   => 0,
        XMLContentRaw            => $DefaultSettingAddParams[1]->{XMLContentRaw},
        XMLContentParsed         => $DefaultSettingAddParams[1]->{XMLContentParsed},
        XMLFilename              => 'UnitTest.xml',
        EffectiveValue           => 'Default',
        UserID                   => 1,
    );

    # Modify both settings with ResetToDefaut flag to simulate that a restore mechanism is needed
    #   in case of a failure.
    my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
        LockAll => 1,
        Force   => 1,
        UserID  => 1,
    );
    my $ModifiedID1 = $SysConfigDBObject->ModifiedSettingAdd(
        DefaultID         => $DefaultSettingID1,
        Name              => $RandomID1,
        IsValid           => 1,
        ResetToDefault    => 1,
        EffectiveValue    => 'Modified',
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );
    my $ModifiedID2 = $SysConfigDBObject->ModifiedSettingAdd(
        DefaultID         => $DefaultSettingID2,
        Name              => $RandomID2,
        IsValid           => 1,
        ResetToDefault    => 1,
        EffectiveValue    => 'Modified',
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # Get current setting values.
    my %ModifiedSetting1 = $SysConfigObject->SettingGet(
        Name   => $RandomID1,
        UserID => 1,
    );
    my %ModifiedSetting2 = $SysConfigObject->SettingGet(
        Name   => $RandomID2,
        UserID => 1,
    );

    my $DeploymentExclusiveLockGUID = $SysConfigDBObject->DeploymentLock(
        UserID => 1,
        Force  => 1,
    );

    # Call deployment settings handle helper to provoke the restore due to the overwritten
    #   method above.
    my $Success = $SysConfigObject->_HandleSettingsToDeploy(
        DirtySettings               => [ $RandomID1, $RandomID2 ],
        UserID                      => 1,
        DeploymentExclusiveLockGUID => $DeploymentExclusiveLockGUID,
        DeploymentTimeStamp         => '2016-12-12 12:00:00',
    );

    # Get setting values again to compare.
    my %RestoredSetting1 = $SysConfigObject->SettingGet(
        Name   => $RandomID1,
        UserID => 1,
    );
    my %RestoredSetting2 = $SysConfigObject->SettingGet(
        Name   => $RandomID2,
        UserID => 1,
    );

    # Setting one should have the same value but not same ModifiedID.
    $Self->Is(
        $ModifiedSetting1{EffectiveValue},
        $RestoredSetting1{EffectiveValue},
        "Setting $RandomID1 keeps the EffectiveValue",
    );
    $Self->IsNot(
        $ModifiedSetting1{ModifiedID},
        $RestoredSetting1{ModifiedID},
        "Setting $RandomID1 should not keep the same ModifiedID",
    );

    # Setting two should have the same value and ModifiedID since it was not deleted in the handling.
    $Self->Is(
        $ModifiedSetting2{EffectiveValue},
        $RestoredSetting2{EffectiveValue},
        "Setting $RandomID2 keeps the EffectiveValue",
    );
    $Self->Is(
        $ModifiedSetting2{ModifiedID},
        $RestoredSetting2{ModifiedID},
        "Setting $RandomID2 keeps the ModifiedID",
    );
}

1;
