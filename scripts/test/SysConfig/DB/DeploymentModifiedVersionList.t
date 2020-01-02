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

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
$HelperObject->FixedTimeSet();

my $Home     = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my $Location = "$Home/Kernel/Config/Files/ZZZAAuto.pm";

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

my $ContentSCALARRef = $MainObject->FileRead(
    Location        => $Location,
    Mode            => 'utf8',
    Result          => 'SCALAR',
    DisableWarnings => 1,
);

my $RandomID = $HelperObject->GetRandomID();

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

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
};

$CleanUp->();

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

# Create a new default settings (all with value 0).
for my $Count ( 1 .. 10 ) {
    my $SettingName = "UnitTest-$Count-$RandomID";
    my $DefaultID   = $SysConfigDBObject->DefaultSettingAdd(
        Name                     => $SettingName,
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
<Setting Name="$SettingName" Required="0" Valid="0">
    <Description Translatable="1">Just for testing.</Description>
    <Navigation>UnitTest::Core</Navigation>
    <Value>
        <Item>0</Item>
    </Value>
</Setting>
EOF
        XMLContentParsed => {
            Name        => $SettingName,
            Required    => '0',
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
            Value => [
                {
                    Item => [
                        {
                            Content => '0',
                        },
                    ],
                },
            ],
        },
        XMLFilename    => 'UnitTest.xml',
        EffectiveValue => '0',
        UserID         => 1,
    );
    $Self->IsNot(
        $DefaultID,
        undef,
        "DefaultSettingAdd() - $SettingName DefaultID",
    );
}

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

my @DeploymentIDs;

my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
    Comments     => "UnitTest",
    UserID       => 1,
    Force        => 1,
    AllSettings  => 1,
    NoValidation => 1,
);
$Self->True(
    $DeploymentResult{Success},
    "ConfigurationDeploy() Initial Deployment",
);
my %LastDeployment = $SysConfigDBObject->DeploymentGetLast();
push @DeploymentIDs, $LastDeployment{DeploymentID};
$HelperObject->FixedTimeAddSeconds(5);

my $UpdateSettings = sub {
    my %Param = @_;

    for my $Count ( @{ $Param{Settings} } ) {
        my $SettingName = "UnitTest-$Count-$RandomID";

        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            Name   => $SettingName,
            Force  => 1,
            UserID => 1,
        );

        my %Result = $SysConfigObject->SettingUpdate(
            Name              => $SettingName,
            EffectiveValue    => $Param{EffectiveValue},
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );
        $Self->True(
            $Result{Success},
            "SettingUpdate() - $SettingName with true",
        );

        my $Success = $SysConfigObject->SettingUnlock(
            Name => $SettingName,
        );

        my %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );
        $Self->Is(
            $Setting{EffectiveValue},
            $Param{EffectiveValue},
            "SettingGet() - $SettingName EffectiveValue",
        );
    }
    $HelperObject->FixedTimeAddSeconds(5);
};

my @Updates = (
    {
        Settings       => [ 2, 4 ],
        EffectiveValue => 1,
    },
    {
        Settings       => [ 1, 3, 5 ],
        EffectiveValue => 2,
    },
    {
        Settings       => [ 3, 4, 5, 6 ],
        EffectiveValue => 3,
    },
    {
        Settings       => [7],
        EffectiveValue => 4,
    },
    {
        Settings       => [ 3, 8 ],
        EffectiveValue => 5,
    },

);

for my $Update (@Updates) {

    $UpdateSettings->( %{$Update} );

    my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
        Comments     => "UnitTest",
        UserID       => 1,
        Force        => 1,
        AllSettings  => 1,
        NoValidation => 1,
    );
    $Self->True(
        $DeploymentResult{Success},
        "ConfigurationDeploy() Deployment $Update->{EffectiveValue}",
    );
    my %LastDeployment = $SysConfigDBObject->DeploymentGetLast();
    push @DeploymentIDs, $LastDeployment{DeploymentID};
}

# Deployments Table
# Setting | D0 | D1 | D2 | D3 | D4 | D5 |
#       1 |  0 |  - |  2 |  - |  - |  - |
#       2 |  0 |  1 |  - |  - |  - |  - |
#       3 |  0 |  - |  2 |  3 |  - |  5 |
#       4 |  0 |  1 |  - |  3 |  - |  - |
#       5 |  0 |  - |  2 |  3 |  - |  - |
#       6 |  0 |  - |  - |  3 |  - |  - |
#       7 |  0 |  - |  - |  - |  4 |  - |
#       8 |  0 |  - |  - |  - |  - |  5 |
#       9 |  0 |  - |  - |  - |  - |  - |
#      10 |  0 |  - |  - |  - |  - |  - |

my @Tests = (
    {
        DeploymentIndex => 1,
        Modes           => {
            SmallerThan       => {},
            SmallerThanEquals => {
                2 => 1,
                4 => 1,
            },
            Equals => {
                2 => 1,
                4 => 1,
            },
            GreaterThan => {
                1 => 2,
                3 => 5,
                4 => 3,
                5 => 3,
                6 => 3,
                7 => 4,
                8 => 5,
            },
            GreaterThanEquals => {
                1 => 2,
                2 => 1,
                3 => 5,
                4 => 3,
                5 => 3,
                6 => 3,
                7 => 4,
                8 => 5,
            },
        },
    },
    {
        DeploymentIndex => 2,
        Modes           => {
            SmallerThan => {
                2 => 1,
                4 => 1,
            },
            SmallerThanEquals => {
                1 => 2,
                2 => 1,
                3 => 2,
                4 => 1,
                5 => 2,
            },
            Equals => {
                1 => 2,
                3 => 2,
                5 => 2,
            },
            GreaterThan => {
                3 => 5,
                4 => 3,
                5 => 3,
                6 => 3,
                7 => 4,
                8 => 5,
            },
            GreaterThanEquals => {
                1 => 2,
                3 => 5,
                4 => 3,
                5 => 3,
                6 => 3,
                7 => 4,
                8 => 5,
            },
        },
    },
    {
        DeploymentIndex => 3,
        Modes           => {
            SmallerThan => {
                1 => 2,
                2 => 1,
                3 => 2,
                4 => 1,
                5 => 2,
            },
            SmallerThanEquals => {
                1 => 2,
                2 => 1,
                3 => 3,
                4 => 3,
                5 => 3,
                6 => 3,
            },
            Equals => {
                3 => 3,
                4 => 3,
                5 => 3,
                6 => 3,
            },
            GreaterThan => {
                3 => 5,
                7 => 4,
                8 => 5,
            },
            GreaterThanEquals => {
                3 => 5,
                4 => 3,
                5 => 3,
                6 => 3,
                7 => 4,
                8 => 5,
            },
        },
    },
    {
        DeploymentIndex => 4,
        Modes           => {
            SmallerThan => {
                1 => 2,
                2 => 1,
                3 => 3,
                4 => 3,
                5 => 3,
                6 => 3,
            },
            SmallerThanEquals => {
                1 => 2,
                2 => 1,
                3 => 3,
                4 => 3,
                5 => 3,
                6 => 3,
                7 => 4,
            },
            Equals => {
                7 => 4,
            },
            GreaterThan => {
                3 => 5,
                8 => 5,
            },
            GreaterThanEquals => {
                3 => 5,
                7 => 4,
                8 => 5,
            },
        },
    },
    {
        DeploymentIndex => 5,
        Modes           => {
            SmallerThan => {
                1 => 2,
                2 => 1,
                3 => 3,
                4 => 3,
                5 => 3,
                6 => 3,
                7 => 4,
            },
            SmallerThanEquals => {
                1 => 2,
                2 => 1,
                3 => 5,
                4 => 3,
                5 => 3,
                6 => 3,
                7 => 4,
                8 => 5,
            },
            Equals => {
                3 => 5,
                8 => 5,
            },
            GreaterThan       => {},
            GreaterThanEquals => {
                3 => 5,
                8 => 5,
            },
        },
    },
);

for my $Test (@Tests) {

    for my $Mode ( sort keys %{ $Test->{Modes} } ) {

        my %ModifiedVersionList = $SysConfigDBObject->DeploymentModifiedVersionList(
            DeploymentID => $DeploymentIDs[ $Test->{DeploymentIndex} ],
            Mode         => $Mode,
        );

        my %Results;

        MODIFIEDVERSIONID:
        for my $ModifiedVersionID ( sort keys %ModifiedVersionList ) {

            my %ModifiedSettingVersion = $SysConfigDBObject->ModifiedSettingVersionGet(
                ModifiedVersionID => $ModifiedVersionID,
            );

            next MODIFIEDVERSIONID if !$ModifiedSettingVersion{Name};
            next MODIFIEDVERSIONID if $ModifiedSettingVersion{Name} !~ m{UnitTest-(\d+)-$RandomID};
            $Results{$1} = $ModifiedSettingVersion{EffectiveValue};
        }

        $Self->IsDeeply(
            \%Results,
            $Test->{Modes}->{$Mode},
            "ModifiedSettingVersionGet Deployment $Test->{DeploymentIndex} Mode $Mode",
        );
    }
}

my $FileLocation = $MainObject->FileWrite(
    Location   => $Location,
    Content    => $ContentSCALARRef,
    Mode       => 'utf8',
    Permission => '644',
);
$Self->IsNot(
    $FileLocation,
    undef,
    "Restored original ZZZAAuto file",
);

1;
