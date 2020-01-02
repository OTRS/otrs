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

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

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

my $SettingName = 'ProductName ' . $HelperObject->GetRandomNumber();

# Add default setting
my $DefaultSettingID = $SysConfigDBObject->DefaultSettingAdd(
    Name                     => $SettingName,
    Description              => 'Defines the name of the application ...',
    Navigation               => 'ASimple::Path::Structure',
    IsInvisible              => 0,
    IsReadonly               => 0,
    IsRequired               => 1,
    IsValid                  => 1,
    HasConfigLevel           => 200,
    UserModificationPossible => 0,
    UserModificationActive   => 0,
    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test setting 1',
    UserID                   => 1,
);

my $Result = $DefaultSettingID ? 1 : 0;

$Self->Is(
    $Result,
    1,
    'DefaultSettingAdd() must succeed.',
);

# Get testing random number
my $RandomNumber = $HelperObject->GetRandomNumber();

# disable email checks to create new user
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $TestUserID;
my $UserRand = 'example-user' . $RandomNumber;

# get user object
my $UserObject = $Kernel::OM->Get('Kernel::System::User');

# add test user
$TestUserID = $UserObject->UserAdd(
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand,
    UserEmail     => $UserRand . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
) || die "Could not create test user";

# Get current time.
my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
$DateTimeObject->Add(
    Minutes => 6
);
my $ExpiredTime = $DateTimeObject->ToEpoch();

# Test configuration
my @Tests = (
    {
        Description => 'Complete testing cycle DefaultID',
        Config      => [
            {
                Action => 'DefaultSettingLock',
                Data   => {
                    UserID    => $TestUserID,
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLocked',
                Data   => {
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLockedByUser',
                Data   => {
                    DefaultID           => $DefaultSettingID,
                    ExclusiveLockUserID => $TestUserID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingUnlock',
                Data   => {
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLocked',
                Data   => {
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 0,
            },
        ],
    },
    {
        Description => 'Complete testing cycle Name',
        Config      => [
            {
                Action => 'DefaultSettingLock',
                Data   => {
                    Name   => $SettingName,
                    UserID => $TestUserID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLocked',
                Data   => {
                    Name => $SettingName,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLockedByUser',
                Data   => {
                    Name                => $SettingName,
                    ExclusiveLockUserID => $TestUserID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingUnlock',
                Data   => {
                    Name => $SettingName,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLocked',
                Data   => {
                    Name => $SettingName,
                },
                ExpectedResult => 0,
            },
        ],
    },

    {
        Description => 'Check IsLocked before locking.',
        Config      => [
            {
                Action => 'DefaultSettingIsLocked',
                Data   => {
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 0,
            },
            {
                Action => 'DefaultSettingLock',
                Data   => {
                    UserID    => 1,
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLockedByUser',
                Data   => {
                    DefaultID           => $DefaultSettingID,
                    ExclusiveLockUserID => 1,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingLock',
                Data   => {
                    UserID    => $TestUserID,
                    Force     => 1,
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLocked',
                Data   => {
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLockedByUser',
                Data   => {
                    DefaultID           => $DefaultSettingID,
                    ExclusiveLockUserID => $TestUserID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLockedByUser',
                Data   => {
                    DefaultID           => 1,
                    ExclusiveLockUserID => $TestUserID,
                },
                ExpectedResult => 0,
            },
            {
                Action => 'DefaultSettingUnlock',
                Data   => {
                    UnlockAll => 1,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLocked',
                Data   => {
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 0,
            },
        ],
    },
    {
        Description => 'Several failing test',
        Config      => [
            {
                Action => 'DefaultSettingIsLockedByUser',
                Data   => {
                    DefaultID           => $DefaultSettingID,
                    ExclusiveLockUserID => 1,
                },
                ExpectedResult => 0,
            },
            {
                Action => 'DefaultSettingLock',
                Data   => {
                    UserID    => $TestUserID,
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLockedByUser',
                Data   => {
                    DefaultID           => $DefaultSettingID,
                    ExclusiveLockUserID => $TestUserID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLockedByUser',
                Data   => {
                    DefaultID           => $DefaultSettingID,
                    ExclusiveLockUserID => $TestUserID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLocked',
                Data   => {
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLocked',
                Data   => {
                    DefaultID => 0,
                },
                ExpectedResult => 0,
            },
            {
                Action => 'DefaultSettingIsLocked',
                Data   => {
                    DefaultID => '',
                },
                ExpectedResult => 0,
            },
            {
                Action => 'DefaultSettingIsLocked',
                Data   => {

                    # DefaultID => 1,
                },
                ExpectedResult => 0,
            },

            {
                Action => 'DefaultSettingLock',
                Data   => {
                    UserID    => 1,
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 0,
            },
            {
                Action => 'DefaultSettingIsLockedByUser',    # missing ExclusiveLockGuid due last failing test
                Data   => {
                    DefaultID           => $DefaultSettingID,
                    ExclusiveLockUserID => 1,
                },
                ExpectedResult => 0,
            },
            {
                Action => 'DefaultSettingLock',
                Data   => {
                    UserID    => $TestUserID,
                    Force     => 1,
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLocked',
                Data   => {
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLockedByUser',
                Data   => {
                    DefaultID           => $DefaultSettingID,
                    ExclusiveLockUserID => $TestUserID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLockedByUser',
                Data   => {
                    DefaultID           => $DefaultSettingID,
                    ExclusiveLockUserID => $TestUserID,
                    ExclusiveLockGUID   => 'ASTRINGWITHWRONGLENGHT',
                },
                ExpectedResult => 0,
            },
            {
                Action => 'DefaultSettingIsLockedByUser',
                Data   => {
                    DefaultID           => $DefaultSettingID,
                    ExclusiveLockUserID => $TestUserID,
                    ExclusiveLockGUID   => 'THISISASTRINGWITHCORRECTLENGHT32',    # But not a valid GUID
                },
                ExpectedResult => 0,
            },
        ],
    },

    {
        Description => 'Not correct and correct ExclusiveLockUserID',
        Config      => [
            {
                Action => 'DefaultSettingLock',
                Data   => {
                    UserID    => $TestUserID,
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLocked',
                Data   => {
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLockedByUser',
                Data   => {
                    DefaultID           => $DefaultSettingID,
                    ExclusiveLockUserID => 1,
                },
                ExpectedResult => 0,
            },
            {
                Action => 'DefaultSettingIsLockedByUser',
                Data   => {
                    DefaultID           => $DefaultSettingID,
                    ExclusiveLockUserID => $TestUserID,
                },
                ExpectedResult => 1,
            },
        ],
    },
    {
        Description => 'Tests for the Expire time',
        Config      => [
            {
                Action => 'DefaultSettingLock',
                Data   => {
                    UserID    => $TestUserID,
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLocked',
                Data   => {
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 1,
            },
            {
                Action => 'DefaultSettingIsLockedByUser',
                Data   => {
                    DefaultID           => $DefaultSettingID,
                    ExclusiveLockUserID => $TestUserID,
                },
                ExpectedResult => 1,
            },
            {
                Action       => 'DefaultSettingIsLocked',
                FixedTimeSet => $ExpiredTime,
                Data         => {
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 0,
            },
            {
                Action       => 'DefaultSettingIsLockedByUser',
                FixedTimeSet => $ExpiredTime,
                Data         => {
                    DefaultID           => $DefaultSettingID,
                    ExclusiveLockUserID => $TestUserID,
                },
                ExpectedResult => 0,
            },
        ],
    },
    {
        Description => 'Tests for Deployment lock - failing setting lock',
        Config      => [
            {
                Action     => 'DefaultSettingLock',
                DeployLock => 1,
                Data       => {
                    UserID    => $TestUserID,
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 0,
            },
            {
                Action => 'DefaultSettingIsLocked',
                Data   => {
                    DefaultID => $DefaultSettingID,
                },
                ExpectedResult => 0,
            },
        ],
    },
);

my $Counter = 0;
my $ExclusiveLockGUID;

TEST:
for my $Test (@Tests) {
    $Counter++;
    for my $TestConfig ( @{ $Test->{Config} } ) {

        # Set time if needed
        if ( $TestConfig->{FixedTimeSet} ) {
            $HelperObject->FixedTimeSet( $TestConfig->{FixedTimeSet} );
        }

        my $ExclusiveLockGUID2;
        if ( $TestConfig->{DeployLock} ) {

            # Lock setting
            $ExclusiveLockGUID2 = $SysConfigDBObject->DeploymentLock(
                UserID => 1,
                Force  => 1,
            );

            my $EffectiveValueStrg = << 'EOF';
# OTRS config file (Unit Tests)
# VERSION:1.1
package Kernel::Config::Files::ZZZAAuto;
use strict;
use warnings;
no warnings 'redefine';
use utf8;

 sub Load {
}
1;
EOF

            # Get system time stamp (string formated).
            my $DateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime'
            );
            my $TimeStamp = $DateTimeObject->ToString();

            my $DeploymentID = $SysConfigDBObject->DeploymentAdd(
                Comments            => 'UnitTest',
                EffectiveValueStrg  => \$EffectiveValueStrg,
                ExclusiveLockGUID   => $ExclusiveLockGUID2,
                DeploymentTimeStamp => $TimeStamp,
                UserID              => 1,
            );
            $Self->IsNot(
                $DeploymentID,
                undef,
                'DeploymentAdd()',
            );
        }

        my $Function = $TestConfig->{Action};

        my $Result = $SysConfigDBObject->$Function(
            ExclusiveLockGUID => $ExclusiveLockGUID,
            %{ $TestConfig->{Data} },
        );

        my $TestResult = $Result ? 1 : 0;

        $Self->Is(
            $TestResult,
            $TestConfig->{ExpectedResult},
            "$Counter .- " . $Test->{Description} . " : $Function .",
        );

        if ( $Function eq 'DefaultSettingLock' ) {
            $ExclusiveLockGUID = $Result;
        }

        # Set time if needed
        if ( $TestConfig->{FixedTimeSet} ) {
            $HelperObject->FixedTimeUnset();
        }

        # Unlock deployment each loop
        if ( $TestConfig->{DeployLock} ) {

            my $UnlockResult = $SysConfigDBObject->DeploymentUnlock(
                ExclusiveLockGUID => $ExclusiveLockGUID2,
                UserID            => 1,
            );
            $Self->IsNot(
                $UnlockResult,
                undef,
                'DeploymentUnlock()',
            );
        }
    }

    # Unlock setting after each testing loop
    $SysConfigDBObject->DefaultSettingUnlock(
        DefaultID => $DefaultSettingID,
    );

}

1;
