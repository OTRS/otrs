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

use Kernel::Config;

use Kernel::System::VariableCheck qw(:all);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

# get needed objects
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

my $Home = $Kernel::OM->Get('Kernel::Config')->{Home};

my $TestFile      = 'ZZZAutoOTRS5.pm';
my $TestPath      = $Home . '/scripts/test/sample/SysConfig/Migration/';
my $TestLocation  = $TestPath . $TestFile;
my $TestFileClass = "scripts::test::sample::SysConfig::Migration::ZZZAutoOTRS5";

$Self->True(
    -e $TestLocation,
    "TestFile '$TestFile' existing",
);

# load from samples
my $Config5 = $MainObject->FileRead(
    Directory => $TestPath,
    Filename  => $TestFile,
    Mode      => 'utf8',
);

$Self->True(
    $Config5,
    "File was readable",
);

return if !-e $TestLocation;

# Import
my %OTRS5Config;
delete $INC{$TestPath};
$Kernel::OM->Get('Kernel::System::Main')->Require($TestFileClass);
$TestFileClass->Load( \%OTRS5Config );

$Self->True(
    \%OTRS5Config,
    "Config was loaded",
);

# Update before migrate
my $PreModifiedSettings = [
    {
        Name           => 'ProductName',
        EffectiveValue => 'UnitTestModified',
    },
    {
        Name           => 'Frontend::NavigationModule###AdminCustomerUser',
        EffectiveValue => {
            'Name'        => 'Customer User',
            'Description' => 'Create and manage customer users (changed).',
            'Group'       => [
                'admin',
                'users',
            ],
            'Block'  => 'Customer',
            'Module' => 'Kernel::Output::HTML::NavBar::ModuleAdmin',
            'Prio'   => '300',
        },
    },
];

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
for my $Settings ( @{$PreModifiedSettings} ) {
    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        %{$Settings},
        Force  => 1,
        UserID => 1,
    );
    my %Result = $SysConfigObject->SettingUpdate(
        %{$Settings},
        IsValid           => 1,
        ExclusiveLockGUID => $ExclusiveLockGUID,
        NoValidation      => 1,
        UserID            => 1,
    );

    $Self->True(
        $Result{Success},
        "Setting $Settings->{Name} was updated successfully.",
    );
    $SysConfigObject->SettingUnlock(
        Name => $Settings->{Name},
    );
    my %Setting = $SysConfigObject->SettingGet(
        Name => $Settings->{Name},
    );

    if ( IsArrayRefWithData( $Settings->{EffectiveValue} ) || IsHashRefWithData( $Settings->{EffectiveValue} ) ) {
        $Self->IsDeeply(
            $Setting{EffectiveValue},
            $Settings->{EffectiveValue},
            'Test Setting ' . $Setting{Name} . ' was modified.',
        );
    }
    else {
        $Self->Is(
            $Setting{EffectiveValue},
            $Settings->{EffectiveValue},
            'Test Setting ' . $Setting{Name} . ' was modified.',
        );
    }
}

# migrate package setting
my $Success = $Kernel::OM->Get('Kernel::System::SysConfig::Migration')->MigrateConfigEffectiveValues(
    FileClass       => $TestFileClass,
    FilePath        => $TestLocation,
    PackageSettings => [
        'SessionAgentOnlineThreshold',
        'Ticket::Frontend::AgentTicketQueue###HighlightAge2',
    ],
    PackageLookupNewConfigName => {
        'ChatEngine::AgentOnlineThreshold' => 'SessionAgentOnlineThreshold',
        'Test###HighlightAge2'             => 'Ticket::Frontend::AgentTicketQueue###HighlightAge2',
    },
    ReturnMigratedSettingsCounts => 1,
);

$Self->True(
    $Success,
    "Config was successfully migrated from otrs5 to 6."
);

# RebuildConfig
my $Rebuild = $SysConfigObject->ConfigurationDeploy(
    Comments => "UnitTest Configuration Rebuild",
    Force    => 1,
    UserID   => 1,
);

$Self->True(
    $Rebuild,
    "Setting Deploy was successfull."
);

my %ValueOld = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet( Name => 'ChatEngine::AgentOnlineThreshold' );
my %ValueNew = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet( Name => 'SessionAgentOnlineThreshold' );

$Self->False(
    $ValueOld{EffectiveValue},
    "TEST ChatEngine::AgentOnlineThreshold: ChatEngine::AgentOnlineThreshold is invalid.",
);

$Self->Is(
    $ValueNew{EffectiveValue},
    10,
    "TEST SessionAgentOnlineThreshold: Value for SessionAgentOnlineThreshold is correct",
);

# migrate
$Success = $Kernel::OM->Get('Kernel::System::SysConfig::Migration')->MigrateConfigEffectiveValues(
    FileClass                    => $TestFileClass,
    FilePath                     => $TestLocation,
    ReturnMigratedSettingsCounts => 1,
);

$Self->True(
    $Success,
    "Config was successfully migrated from otrs5 to 6."
);
if ( ref $Success eq 'HASH' ) {

    my $AllSettingsCount      = $Success->{AllSettingsCount};
    my $DisabledSettingsCount = $Success->{DisabledSettingsCount};
    my @MissingSettings       = @{ $Success->{MissingSettings} };
    my @UnsuccessfullSettings = @{ $Success->{UnsuccessfullSettings} };

    my @Tests = (
        {
            Name        => 'AllSettingsCount',
            IsValue     => $AllSettingsCount,
            ShouldValue => 52,
        },
        {
            Name        => 'DisabledSettingsCount',
            IsValue     => $DisabledSettingsCount,
            ShouldValue => 3,
        },
        {
            Name        => 'MissingSettings',
            IsValue     => scalar @MissingSettings,
            ShouldValue => 3,
        },
        {
            Name        => 'UnsuccessfullSettings',
            IsValue     => scalar @UnsuccessfullSettings,
            ShouldValue => 0,
        }
    );

    for my $TestData (@Tests) {
        $Self->Is(
            $TestData->{IsValue},
            $TestData->{ShouldValue},
            "$TestData->{Name} has correct count of settings.",
        );
    }
}
else {
    $Self->Is(
        ref $Success,
        'HASH',
        "Return Value of Migrate with 'ReturnTestCounts' is not a  HASH!",
    );
}

# RebuildConfig
$Rebuild = $SysConfigObject->ConfigurationDeploy(
    Comments => "UnitTest Configuration Rebuild",
    Force    => 1,
    UserID   => 1,
);

$Self->True(
    $Rebuild,
    "Setting Deploy was successfull."
);

# TODO - many SettingGet to check correct value
my @Tests = (
    {
        TestType => 'Renaming',
        Name     => 'Renamed Setting 1',
        OldName  => 'Frontend::NotifyModule###800-Daemon-Check',
        NewName  => 'Frontend::NotifyModule###8000-Daemon-Check',
    },
    {
        TestType => 'Renaming',
        Name     => 'Renamed Setting 2',
        OldName  => 'CustomerCompany::EventModulePost###110-UpdateTickets',
        NewName  => 'CustomerCompany::EventModulePost###2300-UpdateTickets',
    },

    {
        TestType       => 'EffectiveValue',
        Name           => 'Effective Value',
        Key            => 'Ticket::Frontend::AgentTicketQueue###HighlightAge1',
        EffectiveValue => '1234',
    },
    {
        TestType       => 'EffectiveValue',
        Name           => 'Effective Value',
        Key            => 'Ticket::Frontend::AgentTicketQueue###HighlightAge2',
        EffectiveValue => '5678',
    },

    {
        TestType => 'Disabled',
        Name     => 'Disabled Setting',
        Key      => 'PreferencesGroups###Comment',
    },
    {
        TestType => 'Disabled',
        Name     => 'Disabled renamed setting',
        Key      => 'Ticket::EventModulePost###9700-GenericAgent',
    },
    {
        TestType => 'Disabled',
        Name     => 'Disabled setting with two sub levels',
        Key      => 'Ticket::Frontend::AgentTicketSearch###Defaults###Fulltext',
    },
    {
        TestType => 'Disabled',
        Name     => 'Disabled nav bar item setting',
        Key      => 'Frontend::Navigation###AgentTicketEscalationView###002-Ticket',
    },
    {
        TestType       => 'EffectiveValue',
        Name           => 'Effective Value',
        Key            => 'Frontend::NavigationModule###AdminDynamicField',
        EffectiveValue => {
            'Block'       => 'Ticket',
            'Description' => 'Create and manage dynamic fields (other description).',
            'Group'       => [
                'admin',
                'users',
            ],
            'GroupRo'   => [],
            'IconBig'   => 'fa-align-left',
            'IconSmall' => '',
            'Module'    => 'Kernel::Output::HTML::NavBar::ModuleAdmin',
            'Name'      => 'Dynamic Fields',
            'Prio'      => '1000',
        },
    },
    {
        TestType       => 'EffectiveValue',
        Name           => 'Effective Value',
        Key            => 'Frontend::Navigation###AdminDynamicField###002-Ticket',
        EffectiveValue => [
            {
                'AccessKey' => '',
                'Group'     => [
                    'admin',
                    'users',
                ],
                'GroupRo'     => [],
                'AccessKey'   => '',
                'Block'       => 'ItemArea',
                'Description' => 'Changed the dynamic field.',
                'Link'        => 'Action=AdminDynamicField;Nav=Agent',
                'LinkOption'  => '',
                'Name'        => 'Dynamic Field Administration',
                'NavBar'      => 'Ticket',
                'Prio'        => '9000',
                'Type'        => ''
            },
        ],
    },
    {
        TestType       => 'EffectiveValue',
        Name           => 'Effective Value',
        Key            => 'Frontend::Navigation###AdminCustomerUser###001-Framework',
        EffectiveValue => [
            {
                'AccessKey' => '',
                'Group'     => [
                    'admin',
                    'users',
                ],
                'GroupRo'     => [],
                'Block'       => 'ItemArea',
                'Description' => 'Changed the description.',
                'Link'        => 'Action=AdminCustomerUser;Nav=Agent',
                'LinkOption'  => '',
                'Name'        => 'Customer User Administration',
                'NavBar'      => 'Customers',
                'Prio'        => '9000',
                'Type'        => ''
            },
        ],
    },
    {
        TestType       => 'EffectiveValue',
        Name           => 'Effective Value',
        Key            => 'PostMaster::PreFilterModule###1-Match',
        EffectiveValue => {
            Match => {
                From => 'noreply@',
            },
            Module => 'Kernel::System::PostMaster::Filter::Match',
            Set    => {
                'X-OTRS-IsVisibleForCustomer'          => '0',
                'X-OTRS-FollowUp-IsVisibleForCustomer' => '1',
                'X-OTRS-Ignore'                        => 'yes',
            },
        },
    },
    {
        TestType       => 'EffectiveValue',
        Name           => 'Effective Value',
        Key            => 'PostMaster::PreCreateFilterModule###000-FollowUpArticleVisibilityCheck',
        EffectiveValue => {
            'Module'                      => 'Kernel::System::PostMaster::Filter::FollowUpArticleVisibilityCheck',
            'IsVisibleForCustomer'        => '0',
            'SenderType'                  => 'customer',
            'X-OTRS-IsVisibleForCustomer' => '0',
            'X-OTRS-FollowUp-IsVisibleForCustomer' => '1',
        },
    },
    {
        TestType       => 'EffectiveValue',
        Name           => 'Effective Value',
        Key            => 'PostMaster::CheckFollowUpModule###0100-Subject',
        EffectiveValue => {
            'Module' => 'Kernel::System::PostMaster::FollowUpCheck::Subject',
            ,
            'IsVisibleForCustomer'                 => '1',
            'SenderType'                           => 'customer',
            'X-OTRS-IsVisibleForCustomer'          => '0',
            'X-OTRS-FollowUp-IsVisibleForCustomer' => '1',
        },
    },

    # Check if UTF-8 strings are migrated correctly.
    {
        TestType       => 'EffectiveValue',
        Name           => 'Effective Value',
        Key            => 'TimeZone::Calendar9Name',
        EffectiveValue => 'カレンダー9',
    },

    # There are other renamed settings, this are included AllSetings,
    #   and should not add any results in the MissingSettings above.
    {
        TestType      => 'PreChanged',
        Name          => 'Was changed before 1',
        Key           => 'ProductName',
        ChangedValue  => 'UnitTestModified',
        MigratedValue => 'OTRS 5s',
    },
);

TESTS:
for my $TestData (@Tests) {
    next TESTS if !$TestData->{TestType};

    if ( $TestData->{TestType} eq 'Renaming' ) {
        my %ValueOld = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet( Name => $TestData->{OldName} );
        my %ValueNew = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet( Name => $TestData->{NewName} );

        $Self->False(
            $ValueOld{EffectiveValue},
            "TEST $TestData->{Name}: $TestData->{OldName} is invalid.",
        );

        $Self->True(
            $ValueNew{EffectiveValue},
            "TEST $TestData->{Name}: Value for $TestData->{NewName} found.",
        );
    }
    elsif ( $TestData->{TestType} eq 'PreChanged' ) {
        my %Setting = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet( Name => $TestData->{Key} );

        $Self->Is(
            $Setting{EffectiveValue},
            $TestData->{ChangedValue},
            "TEST $TestData->{Name}: Value was changed before migration an not touched."
        );
    }
    elsif ( $TestData->{TestType} eq 'Disabled' ) {
        my %Setting = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet( Name => $TestData->{Key} );

        $Self->Is(
            $Setting{IsValid},
            0,
            "TEST $TestData->{Name}: Setting is disabled."
        );
    }
    elsif ( $TestData->{TestType} eq 'EffectiveValue' ) {
        my %Setting = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet( Name => $TestData->{Key} );

        $Self->IsDeeply(
            $Setting{EffectiveValue},
            $TestData->{EffectiveValue},
            "TEST $TestData->{Name}: Check effective value."
        );
    }
}

1;
