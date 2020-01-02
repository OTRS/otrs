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

use Kernel::System::VariableCheck qw( IsArrayRefWithData IsHashRefWithData );

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {

        RestoreDatabase => 1,
    },
);

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# disable check email address
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $SettingsXML = << 'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<otrs_config version="2.0" init="Framework">
    <Setting Name="Test0" Required="1" Valid="1">
        <Description Translatable="1">Test.</Description>
        <Navigation>Core::Test</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">Test</Item>
        </Value>
    </Setting>
    <Setting Name="Test1" Required="1" Valid="1">
        <Description Translatable="1">Test.</Description>
        <Navigation>Core::Test</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">Test</Item>
        </Value>
    </Setting>
</otrs_config>
EOF

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');

my @DefaultSettingAddParams = $SysConfigXMLObject->SettingListParse(
    XMLInput    => $SettingsXML,
    XMLFilename => 'UnitTest.xml',
);

for my $Setting (@DefaultSettingAddParams) {

    my $Value = $Kernel::OM->Get('Kernel::System::Storable')->Clone(
        Data => $Setting->{XMLContentParsed}->{Value},
    );

    $Setting->{EffectiveValue} = $SysConfigObject->SettingEffectiveValueGet(
        Value => $Value,
    );
}

my $RandomID   = $HelperObject->GetRandomID();
my $UserObject = $Kernel::OM->Get('Kernel::System::User');

my $TestUserID1;
my $UserRand1 = 'example-user1' . $RandomID;
$TestUserID1 = $UserObject->UserAdd(
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand1,
    UserEmail     => $UserRand1 . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
) || die "Could not create test user";

my $TestUserID2;
my $UserRand2 = 'example-user2' . $RandomID;
$TestUserID2 = $UserObject->UserAdd(
    UserFirstname => 'Firstname Test2',
    UserLastname  => 'Lastname Test2',
    UserLogin     => $UserRand2,
    UserEmail     => $UserRand2 . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
) || die "Could not create test user";

my $SettingName = 'ProductName ' . $RandomID;

my %DefaultSettingAddTemplate = (
    Name           => $SettingName,
    Description    => "Test.",
    Navigation     => "Core::Test",
    IsInvisible    => 0,
    IsReadonly     => 0,
    IsRequired     => 1,
    IsValid        => 1,
    HasConfigLevel => 0,
    XMLFilename    => 'UnitTest.xml',
);

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $DefaultSettingID = $SysConfigDBObject->DefaultSettingAdd(
    %DefaultSettingAddTemplate,
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    UserID                   => 1,
    %{ $DefaultSettingAddParams[0] },
);
$Self->IsNot(
    $DefaultSettingID,
    0,
    "DefaultSettingAdd() - Test0",
);

my %ModifiedSettingAddTemplate = (
    %DefaultSettingAddTemplate,
    DefaultID => $DefaultSettingID,
);

my @Tests = (
    {
        Name   => 'Correct reset',
        Params => {
            Name   => $SettingName,
            UserID => 1,
        },
        ExpectedResult => {
            Name                   => $SettingName,
            EffectiveValue         => 'Test',
            TargetUserID           => undef,
            DefaultID              => $DefaultSettingID,
            IsValid                => 1,
            IsDirty                => 0,
            ResetToDefault         => 1,
            UserModificationActive => 1
        },
        Success => 1,
    },
    {
        Name   => 'Setting wrong name',
        Params => {
            Name   => 'AWrongName',
            UserID => 1,
        },
        Success => 0,
    },
    {
        Name   => 'Not UserID',
        Params => {
            Name => 'AWrongName',

            # UserID => 1,
        },
        Success => 0,
    },
);

TEST:
for my $Test (@Tests) {

    # Add some modified settings
    my @SettingIDs;

    # Add global entry
    my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
        DefaultID => $DefaultSettingID,
        UserID    => 1,
        Force     => 1,
    );
    my $IsLock = $SysConfigDBObject->DefaultSettingIsLocked(
        DefaultID => $DefaultSettingID,
    );
    $Self->True(
        $IsLock,
        'Default setting must be lock.',
    );

    my $ModifiedSettingID = $SysConfigDBObject->ModifiedSettingAdd(
        %ModifiedSettingAddTemplate,
        %{ $DefaultSettingAddParams[1] },
        EffectiveValue    => 'A Different Product Name',
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    my $Result = $ModifiedSettingID ? 1 : 0;
    $Self->True(
        $Result,
        'ModifiedSettingAdd() - Testing global.',
    );

    # Not Result means next tests will fail any way
    # due not ModifiedSettingID available.
    next TEST if !$Result;

    # Store it for later.
    push @SettingIDs, $ModifiedSettingID;

    # Lock setting
    $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
        DefaultID => $DefaultSettingID,
        UserID    => $Test->{Params}->{UserID} || 1,
        Force     => 1,
    );
    $IsLock = $SysConfigDBObject->DefaultSettingIsLocked(
        DefaultID => $DefaultSettingID,
    );
    $Self->True(
        $IsLock,
        'Default setting must be lock for resetting it.',
    );

    my $Success = $SysConfigObject->SettingReset(
        %{ $Test->{Params} },
        ExclusiveLockGUID => $ExclusiveLockGUID,
    );

    if ( !$Test->{Success} ) {
        $Self->Is(
            $Success,
            undef,
            "$Test->{Name} SettingReset() - Failure",
        );

    }
    else {
        $Self->Is(
            $Success,
            $Test->{Success},
            "$Test->{Name} SettingReset() -",
        );
    }

    for my $ModifiedID (@SettingIDs) {

        # Delete modified settings
        my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
            ModifiedID => $ModifiedID,
        );

        $Self->True(
            IsHashRefWithData( \%ModifiedSetting ),
            "ModifiedSettingGet() must return the user setting: $ModifiedID.",
        );

        # Check expected result
        if ( $Test->{Success} ) {

            for my $Field ( sort keys %{ $Test->{ExpectedResult} } ) {
                $Self->Is(
                    $ModifiedSetting{$Field},
                    $Test->{ExpectedResult}->{$Field},
                    "$Test->{Name} ExpectedResult - $Field -",
                );

            }
        }

        my $Result = $SysConfigDBObject->ModifiedSettingDelete( ModifiedID => $ModifiedID );
        $Self->True(
            $Result,
            'ModifiedSettingDelete() must succeed.',
        );

        # Delete modified settings
        %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
            ModifiedID => $ModifiedID,
        );
        $Self->False(
            IsHashRefWithData( \%ModifiedSetting ) ? 1 : 0,
            "ModifiedSettingGet() user setting: $ModifiedID should be deleted.",
        );
    }

}

# cleanup system.
my $Home = $ConfigObject->Get('Home');
for my $UserID ( $TestUserID1, $TestUserID2 ) {
    my $File = "$Home/Kernel/Config/Files/User/$UserID.pm";
    if ( -e $File ) {
        unlink $File;
    }
}

1;
