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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
$Helper->FixedTimeSet();

# Get SysConfig DB object.
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

# Special tests for settings during a deployment.
my $RandomID = $Helper->GetRandomID();

my ( $TestUserLogin, $UserID ) = $Helper->TestUserCreate();

# Create a new default setting.
my $DefaultID0 = $SysConfigDBObject->DefaultSettingAdd(
    Name                     => 'SettingName' . $RandomID,
    Description              => 'UnitTest',
    Navigation               => "UnitTest::Core",
    IsInvisible              => 0,
    IsReadonly               => 0,
    IsRequired               => 0,
    IsValid                  => 1,
    HasConfigLevel           => 0,
    UserModificationPossible => 0,
    UserModificationActive   => 0,
    XMLContentRaw            => <<"EOF",
<Setting Name="SettingName$RandomID" Required="0" Valid="0">
    <Description Translatable="1">Just for testing.</Description>
    <Navigation>UnitTest::Core</Navigation>
    <Value>
        <Item ValueType="String" ValueRegex=".*">An string value.</Item>
    </Value>
</Setting>
EOF
    XMLContentParsed => {
        Name        => 'SettingName' . $RandomID,
        Required    => '1',
        Valid       => '1',
        Description => [
            {
                Content      => 'Just for testing.',
                Translatable => '1',
            },
        ],
        Navigation => [
            {
                Content => 'UnitTest::Core',
            },
        ],
        Setting => [
            {
                Item => [
                    {
                        ValueRegex => '.*',
                        ValueType  => 'String',
                        Content    => 'An string value.',
                    },
                ],
            },
        ],
    },
    XMLFilename    => 'UnitTest.xml',
    EffectiveValue => 'An string value.',
    UserID         => 1,
);

my $VerifyUnlock = sub {

    # Make sure there is no deployment lock.
    my $Success = $SysConfigDBObject->DeploymentUnlock(
        All => 1,
    );
    $Self->True(
        $Success,
        "DeploymentUnlock() call with true",
    );
    my $Locked = $SysConfigDBObject->DeploymentIsLocked();
    $Self->False(
        $Locked,
        "DeploymentIsLocked() with false",
    );
};

# DeploymentLock tests.
my @Tests = (
    {
        Name    => 'No Params',
        Param   => {},
        Success => 0,
        Unlock  => 1,
    },
    {
        Name  => 'Correct',
        Param => {
            UserID => 1,
        },
        Success => 1,
        Unlock  => 1,
    },
    {
        Name  => 'Already Locked',
        Param => {
            UserID => 1,
        },
        Success => 0,
    },
    {
        Name  => 'Correct Invalid GUID (empty)',
        Param => {
            UserID            => 1,
            ExclusiveLockGUID => '',
        },
        Success => 0,
        Unlock  => 1,
    },
    {
        Name  => 'Correct Invalid GUID (0)',
        Param => {
            UserID            => 1,
            ExclusiveLockGUID => 0,
        },
        Success => 0,
        Unlock  => 1,
    },
    {
        Name  => 'Correct Invalid GUID (a)',
        Param => {
            UserID            => 1,
            ExclusiveLockGUID => 'a',
        },
        Success => 0,
        Unlock  => 1,
    },
    {
        Name  => 'Correct Invalid GUID (a) x 31',
        Param => {
            UserID            => 1,
            ExclusiveLockGUID => 'a' x 31,
        },
        Success => 0,
        Unlock  => 1,
    },
    {
        Name  => 'Correct Valid GUID (a) x 32',
        Param => {
            UserID            => 1,
            ExclusiveLockGUID => 'a' x 32,
        },
        Success => 1,
        Unlock  => 1,
    },
    {
        Name  => 'Correct Valid GUID (a) x 33',
        Param => {
            UserID            => 1,
            ExclusiveLockGUID => 'a' x 33,
        },
        Success => 0,
        Unlock  => 1,
    },
    {
        Name  => 'Lock default setting (with force).',
        Param => {
            UserID            => 1,
            ExclusiveLockGUID => 'a' x 32,
            Force             => 1,
        },
        Success     => 1,
        Unlock      => 1,
        SettingLock => 1,
    },
    {
        Name  => 'Lock default setting (by user).',
        Param => {
            UserID            => 1,
            ExclusiveLockGUID => 'a' x 32,
        },
        Success     => 0,
        Unlock      => 1,
        SettingLock => 1,
    },
    {
        Name  => 'Lock default setting (other user).',
        Param => {
            UserID            => 1,
            ExclusiveLockGUID => 'a' x 32,
        },
        LockUser    => $UserID,
        Success     => 1,
        Unlock      => 1,
        SettingLock => 1,
    },
);

# Make sure there is no deployment lock.
$VerifyUnlock->();

TEST:
for my $Test (@Tests) {

    if ( $Test->{Unlock} ) {

        my $Success = $SysConfigDBObject->DeploymentUnlock(
            All => 1,
        );
        $Self->True(
            $Success,
            "$Test->{Name} DeploymentUnlock() call before with true",
        );
    }

    # Lock a setting, deployment lock should not be possible if lock is from the same user.
    my $ExclusiveLockGUID0;
    if ( $Test->{SettingLock} ) {

        # Lock setting
        $ExclusiveLockGUID0 = $SysConfigDBObject->DefaultSettingLock(
            DefaultID => $DefaultID0,
            UserID    => $Test->{LockUser} || 1,
        );

        $Self->IsNot(
            $ExclusiveLockGUID0,
            undef,
            "$Test->{Name} DefaultSettingLock()",
        );
    }

    my $GUID = $SysConfigDBObject->DeploymentLock( %{ $Test->{Param} } );

    if ( !$Test->{Success} ) {
        $Self->Is(
            $GUID,
            undef,
            "$Test->{Name} DepolymentLock()",
        );

        # Unlock the setting if needed
        if ( $Test->{SettingLock} ) {

            # Unlock setting
            my $UnlockSettingResult = $SysConfigDBObject->DefaultSettingUnlock(
                DefaultID => $DefaultID0,
                UnlockAll => 1,
            );

            $Self->True(
                $UnlockSettingResult,
                'DefaultSettingUnlock()',
            );
        }

        next TEST;
    }

    $Self->IsNot(
        $GUID,
        undef,
        "$Test->{Name} DepolymentLock()",
    );
}

# Make sure there is no deployment lock.
$VerifyUnlock->();

# DeploymentIsLocked tests.
@Tests = (
    {
        Name    => 'Deployment Unlocked',
        Lock    => 0,
        Unlock  => 'All',
        Success => 0,
    },
    {
        Name    => 'Deployment Locked',
        Lock    => 1,
        Success => 1,
    },
    {
        Name    => 'Deployment Unlocked after lock',
        Lock    => 1,
        Unlock  => 1,
        Success => 0,
    },
    {
        Name    => 'Deployment Unlocked all after lock',
        Lock    => 1,
        Unlock  => 'All',
        Success => 0,
    },
    {
        Name       => 'Deployment Time Locked',
        Lock       => 1,
        AddSeconds => ( 60 * 5 ) - 1,
        Success    => 1,
    },
    {
        Name       => 'Deployment Time Unlocked',
        Lock       => 1,
        AddSeconds => 60 * 5,
        Success    => 0,
    },

);

my $PrepareLockTests = sub {
    my %Param = @_;

    my $Test = $Param{Test};

    my $ExclusiveLockGUID;
    if ( $Test->{Lock} ) {
        $ExclusiveLockGUID = $SysConfigDBObject->DeploymentLock(
            UserID => 1,
        );
        $Self->IsNot(
            $ExclusiveLockGUID,
            undef,
            "$Test->{Name} - DeploymentLock()",
        );
    }

    if ( $Test->{Unlock} ) {
        if ( $Test->{Unlock} ne 'All' && !$ExclusiveLockGUID ) {
            my $Success = $SysConfigDBObject->DeploymentUnlock(
                All => 1,
            );
            $Self->True(
                0,
                "$Test->{Name} - EXCEPTION - Unlock call without previous ExclusiveLockGUID, skipping test",
            );
            next TEST;
        }
        elsif ($ExclusiveLockGUID) {
            my $Success = $SysConfigDBObject->DeploymentUnlock(
                ExclusiveLockGUID => $ExclusiveLockGUID,
                UserID            => 1,
            );
            $Self->IsNot(
                $Success,
                undef,
                "$Test->{Name} - DeploymentUnlock() user",
            );
        }
        elsif ($ExclusiveLockGUID) {
            my $Success = $SysConfigDBObject->DeploymentUnlock(
                All => 1,
            );
            $Self->IsNot(
                $Success,
                undef,
                "$Test->{Name} - DeploymentUnlock() user",
            );
        }
    }

    if ( $Test->{AddSeconds} ) {
        $Helper->FixedTimeAddSeconds( $Test->{AddSeconds} );
    }

    return $ExclusiveLockGUID;
};

TEST:
for my $Test (@Tests) {

    my $ExclusiveLockGUID = $PrepareLockTests->( Test => $Test );

    my $Locked = $SysConfigDBObject->DeploymentIsLocked();

    $Self->Is(
        $Locked // 0,
        $Test->{Success},
        "$Test->{Name} - DeploymentIsLocked()"
    );

    # Make sure deployment is unlocked for the next run
    my $Success = $SysConfigDBObject->DeploymentUnlock(
        All => 1,
    );
}

# Deployment unlock tests.
@Tests = (
    {
        Name        => 'No Params',
        Lock        => 1,
        Params      => {},
        Success     => 0,
        StillLocked => 1,
    },
    {
        Name   => 'Missing ExclusiveLockGUID',
        Lock   => 1,
        Params => {
            UserID => 1,
        },
        Success     => 0,
        StillLocked => 1,
    },
    {
        Name   => 'Missing UserID',
        Lock   => 1,
        Params => {
            ExclusiveLockGUID => 1,
        },
        Success     => 0,
        StillLocked => 1,
    },
    {
        Name   => 'Wrong ExclusiveLockGUID',
        Lock   => 1,
        Params => {
            ExclusiveLockGUID => 2,
            UserID            => 1,
        },
        Success     => 1,
        StillLocked => 1,
    },
    {
        Name   => 'Wrong UserID',
        Lock   => 1,
        Params => {
            ExclusiveLockGUID => 1,
            UserID            => 123,
        },
        Success     => 1,
        StillLocked => 1,
    },
    {
        Name   => 'Not Locked',
        Lock   => 0,
        Params => {
            ExclusiveLockGUID => 1,
            UserID            => 1,
        },
        Success     => 1,
        StillLocked => 0,
    },
    {
        Name   => 'Not Locked (All)',
        Lock   => 0,
        Params => {
            All => 1
        },
        Success     => 1,
        StillLocked => 0,
    },
    {
        Name   => 'Locked (User)',
        Lock   => 1,
        Params => {
            ExclusiveLockGUID => 1,
            UserID            => 1,
        },
        Success     => 1,
        StillLocked => 0,
    },
    {
        Name   => 'Locked (All)',
        Lock   => 1,
        Params => {
            All => 1
        },
        Success     => 1,
        StillLocked => 0,
    },
);

TEST:
for my $Test (@Tests) {

    my $ExclusiveLockGUID;
    if ( $Test->{Lock} ) {
        $ExclusiveLockGUID = $SysConfigDBObject->DeploymentLock(
            UserID => 1,
        );
        $Self->IsNot(
            $ExclusiveLockGUID,
            undef,
            "$Test->{Name} - DeploymentLock()",
        );
    }

    if (
        defined $Test->{Params}->{ExclusiveLockGUID}
        && $Test->{Params}->{ExclusiveLockGUID} == 1
        && $ExclusiveLockGUID
        )
    {
        $Test->{Params}->{ExclusiveLockGUID} = $ExclusiveLockGUID;
    }

    my $Success = $SysConfigDBObject->DeploymentUnlock( %{ $Test->{Params} } );
    $Self->Is(
        $Success // 0,
        $Test->{Success},
        "$Test->{Name} - DeploymentUnlock()",
    );

    my $Locked = $SysConfigDBObject->DeploymentIsLocked();
    $Self->Is(
        $Locked // 0,
        $Test->{StillLocked},
        "$Test->{Name} - DeploymentIsLocked()",
    );

    # Make sure deployment is unlocked for the next run
    $Success = $SysConfigDBObject->DeploymentUnlock(
        All => 1,
    );
}

# Make sure there is no deployment lock.
$VerifyUnlock->();

# DeploymentIsLockedByUser tests.
@Tests = (
    {
        Name    => 'Deployment Unlocked',
        Lock    => 0,
        Unlock  => 'All',
        Success => 0,
    },
    {
        Name    => 'Deployment Locked',
        Lock    => 1,
        Success => 1,
    },
    {
        Name    => 'Deployment Unlocked after lock',
        Lock    => 1,
        Unlock  => 1,
        Success => 0,
    },
    {
        Name    => 'Deployment Unlocked all after lock',
        Lock    => 1,
        Unlock  => 'All',
        Success => 0,
    },
    {
        Name       => 'Deployment Time Locked',
        Lock       => 1,
        AddSeconds => ( 60 * 5 ) - 1,
        Success    => 1,
    },
    {
        Name       => 'Deployment Time Unlocked (still lock to the user)',
        Lock       => 1,
        AddSeconds => 60 * 5,
        Success    => 1,
    },
    {
        Name    => 'Deployment wrong UserID',
        Lock    => 1,
        Success => 0,
        UserID  => 123,
    },
    {
        Name              => 'Deployment wrong ExclusiveLockGUID',
        Lock              => 1,
        Success           => 0,
        ExclusiveLockGUID => 123,
    },
    {
        Name    => 'Deployment missing UserID',
        Lock    => 1,
        Success => 0,
        UserID  => undef,
    },
    {
        Name              => 'Deployment missing ExclusiveLockGUID',
        Lock              => 1,
        Success           => 0,
        ExclusiveLockGUID => undef,
    },

);

TEST:
for my $Test (@Tests) {

    my $ExclusiveLockGUID = $PrepareLockTests->( Test => $Test );

    my %Param = (
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    for my $ParamName (qw(ExclusiveLockGUID UserID)) {
        $Param{$ParamName} = exists $Test->{$ParamName} ? $Test->{$ParamName} : $Param{$ParamName};
    }

    my $Locked = $SysConfigDBObject->DeploymentIsLockedByUser(%Param);

    if ( $Test->{Success} ) {
        $Self->Is(
            $Locked,
            1,
            "$Test->{Name} - DeploymentIsLockedByUser()"
        );
    }
    else {
        $Self->Is(
            $Locked // 0,
            0,
            "$Test->{Name} - DeploymentIsLockedByUser()"
        );
    }

    # Make sure deployment is unlocked for the next run.
    my $Success = $SysConfigDBObject->DeploymentUnlock(
        All => 1,
    );
}

my $EffectiveValueStrg = '$Self->{Key} => 1,';

# DeploymentAdd() tests.
@Tests = (
    {
        Name  => 'No Params',
        Param => {
            ExclusiveLockGUID => undef,
            UserID            => undef,
        },
        Lock    => 1,
        Success => 0,
    },
    {
        Name  => 'No ExclusiveLockGUID',
        Param => {
            EffectiveValueStrg => \$EffectiveValueStrg,
            ExclusiveLockGUID  => undef,
        },
        Lock    => 1,
        Success => 0,
    },
    {
        Name  => 'No UserID',
        Param => {
            EffectiveValueStrg => \$EffectiveValueStrg,
            UserID             => undef,
        },
        Lock    => 1,
        Success => 0,
    },
    {
        Name  => 'Wrong UserID',
        Param => {
            EffectiveValueStrg => \$EffectiveValueStrg,
            UserID             => 123,
        },
        Lock    => 1,
        Success => 0,
    },
    {
        Name  => 'Wrong ExclusiveLockGUID',
        Param => {
            EffectiveValueStrg => $EffectiveValueStrg,
            ExclusiveLockGUID  => 123,
        },
        Lock    => 1,
        Success => 0,
    },
    {
        Name  => 'Wrong EffectiveValue format array',
        Param => {
            EffectiveValueStrg => ['$Self->{Key} => 1,'],
        },
        Lock    => 1,
        Success => 0,
    },
    {
        Name  => 'Wrong EffectiveValue format hash',
        Param => {
            EffectiveValueStrg => { Test => '$Self->{Key} => 1,' },
        },
        Lock    => 1,
        Success => 0,
    },
    {
        Name  => 'Correct',
        Param => {
            EffectiveValueStrg => \$EffectiveValueStrg,
        },
        Lock    => 1,
        Success => 1,
    },
    {
        Name  => 'Correct Not Locked',
        Param => {
            EffectiveValueStrg => \$EffectiveValueStrg,
            ExclusiveLockGUID  => 'a' x 32,
        },
        Lock    => 0,
        Success => 0,
    },
    {
        Name  => 'Correct with comments',
        Param => {
            Comments           => 'Unit Test',
            EffectiveValueStrg => \$EffectiveValueStrg,
        },
        Lock    => 1,
        Success => 1,
    },

);

TEST:
for my $Test (@Tests) {

    my $ExclusiveLockGUID = $PrepareLockTests->( Test => $Test );

    my %Param = (
        ExclusiveLockGUID   => $ExclusiveLockGUID,
        UserID              => 1,
        DeploymentTimeStamp => '1977-12-12 12:00:00',
    );

    for my $ParamName (qw(ExclusiveLockGUID UserID)) {
        my $Var = exists $Test->{Param}->{$ParamName};
        $Param{$ParamName} = exists $Test->{Param}->{$ParamName} ? $Test->{Param}->{$ParamName} : $Param{$ParamName};
    }

    my $DeploymentID = $SysConfigDBObject->DeploymentAdd(
        %{ $Test->{Param} },
        %Param,
    );

    if ( !$Test->{Success} ) {
        $Self->Is(
            $DeploymentID,
            undef,
            "$Test->{Name} DeploymentAdd()",
        );
        next TEST;
    }

    $Self->IsNot(
        $DeploymentID,
        undef,
        "$Test->{Name} DeploymentAdd()",
    );
}
continue {

    # Make sure deployment is unlocked for the next run.
    my $Success = $SysConfigDBObject->DeploymentUnlock(
        All => 1,
    );
}

# Create a new default setting.
my $DefaultID = $SysConfigDBObject->DefaultSettingAdd(
    Name                     => $RandomID,
    Description              => 'UnitTest',
    Navigation               => "UnitTest::Core",
    IsInvisible              => 0,
    IsReadonly               => 0,
    IsRequired               => 0,
    IsValid                  => 1,
    HasConfigLevel           => 0,
    UserModificationPossible => 0,
    UserModificationActive   => 0,
    XMLContentRaw            => <<"EOF",
<Setting Name="$RandomID" Required="0" Valid="0">
    <Description Translatable="1">Test.</Description>
    <Navigation>UnitTest::Core</Navigation>
    <Value>
        <Item ValueType="String" ValueRegex=".*">123</Item>
    </Value>
</Setting>
EOF
    XMLContentParsed => {
        Name        => 'Test',
        Required    => '1',
        Valid       => '1',
        Description => [
            {
                Content      => 'Test.',
                Translatable => '1',
            },
        ],
        Navigation => [
            {
                Content => 'Core::Ticket',
            },
        ],
        Setting => [
            {
                Item => [
                    {
                        ValueRegex => '.*',
                        ValueType  => 'String',
                        Content    => '123',
                    },
                ],
            },
        ],
    },
    XMLFilename    => 'UnitTest.xml',
    EffectiveValue => '123',
    UserID         => 1,
);

# Check default setting IsDirty flag.
my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
    DefaultID => $DefaultID,
);

$Self->Is(
    $DefaultSetting{IsDirty},
    1,
    "Initial Default IsDirty",
);

# Lock setting again.
my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => 1,
    Force     => 1,
    DefaultID => $DefaultID,
);

# Create a modified setting.
my $ModifiedID = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID                => $DefaultID,
    Name                     => $RandomID,
    IsValid                  => 1,
    UserModificationPossible => 0,
    EffectiveValue           => '456',
    ExclusiveLockGUID        => $ExclusiveLockGUID,
    UserID                   => 1,
);

# Check modified setting IsDisry flag.
my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
    ModifiedID => $ModifiedID,
);
$Self->Is(
    $ModifiedSetting{IsDirty},
    1,
    "Initial Modified IsDirty",
);

# Add a new deployment
$ExclusiveLockGUID = $SysConfigDBObject->DeploymentLock(
    UserID => 1,
);

my $EffectiveValueStrgFile = <<"EOF";
# OTRS config file (automatically generated)
# VERSION:1.1
package Kernel::Config::Files::ZZZAAuto;
use strict;
use warnings;
no warnings 'redefine';
use utf8;

 sub Load {
    \$Self->{$RandomID} = '456'
}
1;
EOF

my $DeploymentID = $SysConfigDBObject->DeploymentAdd(
    Comments            => 'UnitTest',
    EffectiveValueStrg  => \$EffectiveValueStrgFile,
    ExclusiveLockGUID   => $ExclusiveLockGUID,
    DeploymentTimeStamp => '1977-12-12 12:00:00',
    UserID              => 1,
);

my $DefaultCleanup  = $SysConfigDBObject->DefaultSettingDirtyCleanUp();
my $ModifiedCleanup = $SysConfigDBObject->ModifiedSettingDirtyCleanUp();

# Check default setting IsDirty flag.
%DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
    DefaultID => $DefaultID,
);
$Self->Is(
    $DefaultSetting{IsDirty},
    0,
    "After deployment Default IsDirty",
);

# Check default setting IsDirty flag.
%ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
    ModifiedID => $ModifiedID,
);
$Self->Is(
    $ModifiedSetting{IsDirty},
    0,
    "After deployment Modified IsDirty",
);

# Make sure the deployment is unlocked.
my $Success = $SysConfigDBObject->DeploymentUnlock(
    All => 1
);

my $EffectiveValueStrgUnitTest = 'UnitTest';
my $EffectiveValueStrgUTF8     = 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß';

# DeploymentGet() tests.
@Tests = (
    {
        Name    => 'Missing DeploymentID',
        Success => 0,
    },
    {
        Name => 'Correct',
        Add  => {
            Comments           => 'UnitTest',
            EffectiveValueStrg => \$EffectiveValueStrgUnitTest,
            UserID             => 1,
        },
        Success => 1,
    },
    {
        Name => 'Correct utf8',
        Add  => {
            Comments           => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            EffectiveValueStrg => \$EffectiveValueStrgUTF8,
            UserID             => 1,
        },
        Success => 1,
    },

);

# Get cache object.
my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

my @AddedDeployments;

TEST:
for my $Test (@Tests) {

    my $DeploymentID;

    if ( $Test->{Add} ) {

        # Lock and add a deployment.
        my $ExclusiveLockGUID = $SysConfigDBObject->DeploymentLock(
            UserID => 1,
        );
        $DeploymentID = $SysConfigDBObject->DeploymentAdd(
            %{ $Test->{Add} },
            ExclusiveLockGUID   => $ExclusiveLockGUID,
            DeploymentTimeStamp => '1977-12-12 12:00:00',
        );
        $Self->IsNot(
            $DeploymentID,
            undef,
            "$Test->{Name} DeploymentAdd() for DeploymentGet() - DeploymentID",
        );

        push @AddedDeployments, $DeploymentID;
    }

    # Check cache before.
    my $CacheType = "SysConfigDeployment";
    my $CacheKey  = "DeploymentGet::DeploymentID::$DeploymentID";
    my $Cache     = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );
    $Self->Is(
        $Cache,
        undef,
        "$Test->{Name} - cache before DeploymentGet()",
    );

    my %Deployment = $SysConfigDBObject->DeploymentGet(
        DeploymentID => $DeploymentID,
    );

    if ( !$Test->{Success} ) {
        $Self->IsDeeply(
            \%Deployment,
            {},
            "$Test->{Name} DeploymentGet() (Not Success)"
        );
        next TEST;
    }

    # Check meta-data.
    for my $Attribute (qw(CreateTime CreateBy)) {
        $Self->IsNot(
            $Deployment{$Attribute} // '',
            '',
            "$Test->{Name} DeploymentGet() - $Attribute has contents",
        );
    }

    # Check other attributes.
    for my $Attribute (qw(Comments EffectiveValueStrg)) {
        $Self->Is(
            $Deployment{Comments} // '',
            $Test->{Add}->{Comments},
            "$Test->{Name} DeploymentGet() - Comments",
        );
    }

    $Self->Is(
        $Deployment{EffectiveValueStrg} // '',
        ${ $Test->{Add}->{EffectiveValueStrg} },
        "$Test->{Name} DeploymentGet() - EffectiveValueStrg",
    );

    # Check cache after.
    $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );
    $Self->IsDeeply(
        $Cache,
        \%Deployment,
        "$Test->{Name} - cache after DeploymentGet()",
    );

    # Unlock deployment.
    my $Success = $SysConfigDBObject->DeploymentUnlock(
        All => 1
    );
}

# Get deployments.
my @List = $SysConfigDBObject->DeploymentListGet();

my $DeleteCounter = 1;
for my $DeploymentID (@AddedDeployments) {
    my $Success = $SysConfigDBObject->DeploymentDelete(
        DeploymentID => $DeploymentID,
    );
    $Self->True(
        $Success,
        "DeploymentDelete() - for DeploymentID $DeploymentID with true",
    );

    my @NewList = $SysConfigDBObject->DeploymentListGet();
    $Self->Is(
        scalar @NewList,
        ( scalar @List ) - $DeleteCounter,
        "Number of deployments is decreased by 1"
    );
    $DeleteCounter++;
}

# DeploymentListGet() tests.
# Use last deployments as base.
my @DeploymentsAdd = (
    {
        Comments           => 'UnitTest',
        EffectiveValueStrg => \$EffectiveValueStrgUnitTest,
        UserID             => 1,
    },
    {
        Comments           => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        EffectiveValueStrg => \$EffectiveValueStrgUTF8,
        UserID             => 1,
    },
);

my %DeploymentsGet;

for my $DeploymentSource (@DeploymentsAdd) {

    $Helper->FixedTimeAddSeconds(5);

    # Lock and add a deployment.
    my $ExclusiveLockGUID = $SysConfigDBObject->DeploymentLock(
        UserID => 1,
    );
    $DeploymentID = $SysConfigDBObject->DeploymentAdd(
        %{$DeploymentSource},
        ExclusiveLockGUID   => $ExclusiveLockGUID,
        DeploymentTimeStamp => '1977-12-12 12:00:00',
    );

    # Unlock deployment.
    my $Success = $SysConfigDBObject->DeploymentUnlock(
        All => 1
    );

    # Get the deployment and remember.
    my %Deployment = $SysConfigDBObject->DeploymentGet(
        DeploymentID => $DeploymentID,
    );
    $DeploymentsGet{$DeploymentID} = \%Deployment;
}

@List = $SysConfigDBObject->DeploymentListGet();
$Self->IsNot(
    scalar @List,
    0,
    "DeploymentListGet() - Number of elements",
);

my %DeploymentList = map { $_->{DeploymentID} => $_ } @List;

for my $DeploymentID ( sort keys %DeploymentsGet ) {
    $Self->IsDeeply(
        $DeploymentList{$DeploymentID},
        $DeploymentsGet{$DeploymentID},
        "DeploymentListGet() - Element ID $DeploymentID",
    );
}

# DeploymentDelete() tests.
@Tests = (
    {
        Name    => 'No params',
        Param   => {},
        Success => 0,
    },
    {
        Name  => 'Wrong DeploymentID (already deleted)',
        Param => {
            DeploymentID => $AddedDeployments[0],
        },
        Success => 1,
    },
);

TEST:
for my $Test (@Tests) {

    my $Success = $SysConfigDBObject->DeploymentDelete( %{ $Test->{Param} } );

    $Self->Is(
        $Success // 0,
        $Test->{Success},
        "$Test->{Name} DeploymentDelete() - ",
    );
}

my %PreviousDeployment;

# DeploymentGetLast() tests.
for my $Count ( 1 .. 5 ) {

    my $ExclusiveLockGUID = $SysConfigDBObject->DeploymentLock(
        UserID => 1,
        Force  => 1,
    );
    $Self->IsNot(
        $ExclusiveLockGUID,
        undef,
        "#$Count DeploymentLock()... for DeploymentGetLast()",
    );

    my $DeploymentID = $SysConfigDBObject->DeploymentAdd(
        Comments            => 'Some Comments',
        EffectiveValueStrg  => \$EffectiveValueStrg,
        ExclusiveLockGUID   => $ExclusiveLockGUID,
        DeploymentTimeStamp => '1977-12-12 12:00:00',
        UserID              => 1,
    );
    $Self->IsNot(
        $DeploymentID,
        undef,
        "#$Count DeploymentAdd().... for DeploymentGetLast()",
    );

    my $Success = $SysConfigDBObject->DeploymentUnlock(
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );
    $Self->Is(
        $Success,
        1,
        "#$Count DeploymentUnlock(). for DeploymentGetLast()",
    );

    @List = $SysConfigDBObject->DeploymentListGet();
    $Self->IsNotDeeply(
        \@List,
        [],
        "#$Count DeploymentListGet() for DeploymentGetLast() is not empty",
    );

    my %CurrentDeployment = %{ $List[0] };
    my %LastDeployment    = $SysConfigDBObject->DeploymentGetLast();

    $Self->IsDeeply(
        \%LastDeployment,
        \%CurrentDeployment,
        "#$Count LastDeployment..... for DeploymentGetLast() is the same las last element of the list",
    );
    $Self->Is(
        $LastDeployment{DeploymentID},
        $DeploymentID,
        "#$Count LastDeployment..... for DeploymentGetLast() the DeploymentID is the same as the last added",
    );

    $Self->IsNotDeeply(
        \%LastDeployment,
        \%PreviousDeployment,
        "#$Count LastDeployment..... for DeploymentGetLast() is different from the previous one",
    );

    %PreviousDeployment = %LastDeployment;
}

# ConfigurationDeployCleanup() tests.
my @RemainingDeployents;
my $DeploymentsToAdd = 35;
for my $Count ( 1 .. 35 ) {

    my $ExclusiveLockGUID = $SysConfigDBObject->DeploymentLock(
        UserID => 1,
        Force  => 1,
    );
    $Self->IsNot(
        $ExclusiveLockGUID,
        undef,
        "#$Count DeploymentLock()... for ConfigurationDeployCleanup()",
    );

    my $DeploymentID = $SysConfigDBObject->DeploymentAdd(
        Comments            => 'Some Comments' . $Count,
        EffectiveValueStrg  => \$EffectiveValueStrg,
        ExclusiveLockGUID   => $ExclusiveLockGUID,
        DeploymentTimeStamp => '1977-12-12 12:00:00',
        UserID              => 1,
    );
    $Self->IsNot(
        $DeploymentID,
        undef,
        "#$Count DeploymentAdd().... for ConfigurationDeployCleanup()",
    );

    my $Success = $SysConfigDBObject->DeploymentUnlock(
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );
    $Self->Is(
        $Success,
        1,
        "#$Count DeploymentUnlock(). for ConfigurationDeployCleanup()",
    );

    if ( $DeploymentsToAdd - $Count < 20 ) {
        push @RemainingDeployents, $DeploymentID;
    }
}

# Check Deployment Delete functionality
my @DeploymentListBefore = $SysConfigDBObject->DeploymentListGet();
$Self->True(
    scalar @DeploymentListBefore > 20,
    "DeploymentListGet() before ConfigurationDeployCleanup()",
);

my $CleanupResult = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationDeployCleanup();
$Self->Is(
    $CleanupResult,
    1,
    "ConfigurationDeployCleanup()",
);

my @DeploymentListAfter = $SysConfigDBObject->DeploymentListGet();
$Self->Is(
    scalar @DeploymentListAfter,
    20,
    "DeploymentListGet() after ConfigurationDeployCleanup() Scalar",
);

@RemainingDeployents = reverse @RemainingDeployents;
my @DeploymentIDsAfter = map { $_->{DeploymentID} } @DeploymentListAfter;

$Self->IsDeeply(
    \@RemainingDeployents,
    \@DeploymentIDsAfter,
    "DeploymentListGet() after ConfigurationDeployCleanup() Content",
);

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

my %UserDeployments;

# Tests for user specific deployments
my $TestUserLogin1 = $Helper->TestUserCreate();
my $UserID1        = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $TestUserLogin1,
);
my $TestUserLogin2 = $Helper->TestUserCreate();
my $UserID2        = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $TestUserLogin2,
);
my $TestUserLogin3 = $Helper->TestUserCreate();
my $UserID3        = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $TestUserLogin3,
);
my $TestUserLogin4 = $Helper->TestUserCreate();
my $UserID4        = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $TestUserLogin4,
);
my $TestUserLogin5 = $Helper->TestUserCreate();
my $UserID5        = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $TestUserLogin5,
);

for my $Round ( 1 .. 2 ) {
    for my $UserID ( $UserID1, $UserID2, $UserID3, $UserID4, $UserID5 ) {

        my $EffectiveValueStrg = << 'EOF';
sub Load {
    my ($File, $Self) = @_;
    $Self->{Key} = 1;
}
1;
EOF

        $DeploymentID = $SysConfigDBObject->DeploymentAdd(
            Comments            => 'Some Comments',
            EffectiveValueStrg  => \$EffectiveValueStrg,
            TargetUserID        => $UserID,
            DeploymentTimeStamp => '1977-12-12 12:00:00',
            UserID              => $UserID,
        );
        $Self->IsNot(
            $DeploymentID,
            undef,
            "User $UserID Round $Round DeploymentAdd() - DeploymentID for user is not undef",
        );
        my %Deployment = $SysConfigDBObject->DeploymentGet(
            DeploymentID => $DeploymentID,
        );
        $Self->True(
            $Deployment{EffectiveValueStrg} =~ m{$DeploymentID},
            "User $UserID Round $Round DeploymentGet() - EffectiveValueStrg includes $DeploymentID",
        );

        $UserDeployments{$UserID} = $DeploymentID;

        $DBObject->Prepare(
            SQL => '
                SELECT id
                FROM sysconfig_deployment
                WHERE user_id = ?',
            Bind => [ \$UserID ],
        );

        my @DeploymentIDs;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            push @DeploymentIDs, $Row[0];
        }
        $Self->Is(
            scalar @DeploymentIDs,
            1,
            "User $UserID Round $Round Deployments from user must be 1",
        );
        $Self->Is(
            $DeploymentIDs[0],
            $DeploymentID,
            "User $UserID Round $Round DeploymentID from user must $DeploymentID",
        );

    }
}

my %List                  = $SysConfigDBObject->DeploymentUserList();
my %UserDeploymentsLookup = reverse %UserDeployments;

DEPLOYMENTID:
for my $DeploymentID ( sort keys %List ) {
    next DEPLOYMENTID if !$UserDeploymentsLookup{$DeploymentID};

    $Self->Is(
        $List{$DeploymentID},
        $UserDeploymentsLookup{$DeploymentID},
        "DeploymentUserList() user for deployment $DeploymentID",
    );
}

1;
