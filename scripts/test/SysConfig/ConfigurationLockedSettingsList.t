# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

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

my $Helper            = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');
my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');

my $RandomID    = $Helper->GetRandomID();
my $SettingName = "Test$RandomID-";
my $UserID      = 1;
my @SettingDirtyNames;

my $UnlockedAll = $SysConfigObject->SettingUnlock(
    UnlockAll => 1,
);

$Self->IsNot(
    $UnlockedAll,
    undef,
    'SettingUnlock()',
);

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

my %DefaultIDs;
my $LastDefaultID;

DEFAULTS:
for my $Index ( 1 .. 3 ) {
    my $DefaultID = $SysConfigDBObject->DefaultSettingAdd(
        Name             => $SettingName . $Index,
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
        $DefaultID,
        undef,
        "DefaultSettingAdd() - $Index",
    );

    # Save it for later use.
    $DefaultIDs{$DefaultID} = $SettingName . $Index;

    $LastDefaultID = $DefaultID;

    # Lock only the first 2 defaults
    last DEFAULTS if $Index > 2;

    # Lock setting (so it can be updated).
    my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
        UserID    => $UserID,
        Force     => 1,
        DefaultID => $DefaultID,
    );

    $Self->True(
        $ExclusiveLockGUID,
        "DefaultSettingLock",
    );

    my %Result = $SysConfigObject->SettingLockCheck(
        DefaultID           => $DefaultID,
        ExclusiveLockGUID   => $UserID,
        ExclusiveLockUserID => $UserID,
    );

    $Self->Is(
        $Result{Locked},
        1,
        "Setting is locked to $UserID",
    );

    $Self->True(
        $Result{User}->{UserLogin},
        "Locked UserLogin is provided - $Result{User}->{UserLogin}"
    );

}

# set user details
my ( $UserLogin, $TestUserID ) = $Helper->TestUserCreate();

$Self->True(
    $TestUserID,
    "Creating test customer user",
);

# Lock setting for a different user.
my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => $TestUserID,
    Force     => 1,
    DefaultID => $LastDefaultID,
);

$Self->True(
    $ExclusiveLockGUID,
    "DefaultSettingLock",
);

my %Result = $SysConfigObject->SettingLockCheck(
    DefaultID           => $LastDefaultID,
    ExclusiveLockGUID   => $TestUserID,
    ExclusiveLockUserID => $TestUserID,
);

$Self->Is(
    $Result{Locked},
    1,
    "Is locked to $UserID",
);

$Self->Is(
    $Result{User}->{UserLogin},
    $UserLogin,
    "Locked UserLogin is correct"
);

#Check all the locked settings
my @LockedSettingsResult = $SysConfigObject->ConfigurationLockedSettingsList(

    # ExclusiveLockUserID       => 2, # Optional, ID of the user for which the default setting is locked
);

my @DefaultNames = sort values %DefaultIDs;

$Self->IsDeeply(
    \@LockedSettingsResult,
    \@DefaultNames,
    "ConfigurationLockedSettingsList() - All locked settings.",
);

#Check just the ones for the test user
@LockedSettingsResult = $SysConfigObject->ConfigurationLockedSettingsList(
    ExclusiveLockUserID => $TestUserID,
);

@DefaultNames = ( $DefaultIDs{$LastDefaultID} );

$Self->IsDeeply(
    \@LockedSettingsResult,
    \@DefaultNames,
    "ConfigurationLockedSettingsList() - All locked settings.",
);

%Result = $SysConfigObject->SettingLockCheck(
    DefaultID           => $LastDefaultID,
    ExclusiveLockGUID   => $TestUserID,
    ExclusiveLockUserID => $TestUserID,
);

$Self->Is(
    $Result{Locked},
    1,
    "Is locked to $UserID",
);

$Self->Is(
    $Result{User}->{UserLogin},
    $UserLogin,
    "Locked UserLogin is correct"
);

1;
