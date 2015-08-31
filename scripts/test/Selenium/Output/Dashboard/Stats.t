# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # disable all dashboard plugins
        my $Config = $Kernel::OM->Get('Kernel::Config')->Get('DashboardBackend');
        $SysConfigObject->ConfigItemUpdate(
            Valid => 0,
            Key   => 'DashboardBackend',
            Value => \%$Config,
        );

        # Add at least one dashboard setting dashboard sysconfig so dashboard can be loaded
        $SysConfigObject->ConfigItemReset(
            Name => 'DashboardBackend###0400-UserOnline',
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', 'stats' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get user object
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # get test user ID
        my $TestUserID = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');

        my $StatisticContent = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Kernel::OM->Get('Kernel::Config')->Get('Home')
                . '/scripts/test/Selenium/Output/Dashboard/Stats.xml',
        );

        # import the exported stat
        my $TestStatID = $StatsObject->Import(
            Content => $$StatisticContent,
            UserID  => $TestUserID,
        );
        $Self->True(
            $TestStatID,
            "Successfully imported StatID $TestStatID",
        );

        # update test stats name and show as dashboard widget
        my $TestStatsName = "SeleniumStats" . $Helper->GetRandomID();
        my $Update        = $StatsObject->StatsUpdate(
            StatID => $TestStatID,
            Hash   => {
                Title                 => $TestStatsName,
                ShowAsDashboardWidget => '1',
            },
            UserID => $TestUserID,
        );
        $Self->True(
            $Update,
            "Stats updated ID - $TestStatID",
        );

        # refresh dashboard screen
        $Selenium->refresh();

        # enable stats widget on dashboard
        my $StatsInSettings = "Settings10" . $TestStatID . "-Stats";
        $Selenium->find_element( ".SettingsWidget .Header a", "css" )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('.SettingsWidget.Expanded').length;" );

        $Selenium->find_element( "#$StatsInSettings",      'css' )->click();
        $Selenium->find_element( ".SettingsWidget button", 'css' )->click();

        my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Stats::Dashboard::Generate');
        my $ExitCode      = $CommandObject->Execute();
        $Selenium->refresh();

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".nvd3-svg").length;' );

        $Self->Is(
            $Selenium->execute_script('return $(".nv-legend-text:contains(Misc)").length'),
            1,
            "Legend entry for Misc queue found.",
        );

        # delete test stat
        $Self->True(
            $StatsObject->StatsDelete(
                StatID => $TestStatID,
                UserID => $TestUserID,
            ),
            "Delete StatID - $TestStatID",
        );

        # make sure cache is correct
        for my $Cache (qw( Stats Dashboard DashboardQueueOverview )) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
