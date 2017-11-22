# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
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

        # get needed objects
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # disable all dashboard plugins
        my $Config = $ConfigObject->Get('DashboardBackend');
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'DashboardBackend',
            Value => \%$Config,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Stats::ExchangeAxis',
            Value => 1,
        );

        # add at least one dashboard setting dashboard sysconfig so dashboard can be loaded
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0400-UserOnline',
            Value => {
                'Block'         => 'ContentSmall',
                'CacheTTLLocal' => '5',
                'Default'       => '0',
                'Description'   => '',
                'Filter'        => 'Agent',
                'Group'         => '',
                'IdleMinutes'   => '60',
                'Limit'         => '10',
                'Module'        => 'Kernel::Output::HTML::Dashboard::UserOnline',
                'ShowEmail'     => '0',
                'SortBy'        => 'UserFullname',
                'Title'         => 'Online'
            },
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', 'stats' ],
        ) || die "Did not get test user";

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # get stats object
        my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');

        my $StatisticContent = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $ConfigObject->Get('Home')
                . '/scripts/test/Selenium/Output/Dashboard/Stats.xml',
        );

        # import test stats
        my $TestStatID = $StatsObject->Import(
            Content => $StatisticContent,
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
            "Stats is updated - ID $TestStatID",
        );

        my $StatsWidgetID = "10$TestStatID-Stats";

        # Store invalid old-style time zone offset in user preferences for imported statistic.
        my $Success = $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
            Key   => "UserDashboardStatsStatsConfiguration$StatsWidgetID",
            Value => $Kernel::OM->Get('Kernel::System::JSON')->Encode(
                Data => {
                    TimeZone => '+2',    # old-style offset
                },
            ),
            UserID => $TestUserID,
        );

        # Login and go to dashboard.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # enable stats widget on dashboard
        my $StatsInSettings = "Settings10" . $TestStatID . "-Stats";
        $Selenium->find_element( ".SettingsWidget .Header a", "css" )->VerifiedClick();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.SettingsWidget.Expanded').length;"
        );

        $Selenium->find_element( "#$StatsInSettings",      'css' )->VerifiedClick();
        $Selenium->find_element( ".SettingsWidget button", 'css' )->VerifiedClick();

        my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Stats::Dashboard::Generate');
        my $ExitCode      = $CommandObject->Execute();
        $Selenium->VerifiedRefresh();

        $Self->Is(
            $Selenium->execute_script('return $(".nv-legend-text:contains(Misc)").length'),
            1,
            "Legend entry for Misc queue found.",
        );

        # Expand stat widget settings.
        $Selenium->execute_script("\$('#Dashboard$StatsWidgetID-toggle').trigger('click');");

        # Verify time zone is set to system default.
        my $SelectedTimeZone = $Selenium->execute_script("return \$('#TimeZone').val();");
        $Self->Is(
            $SelectedTimeZone,
            $ConfigObject->Get('OTRSTimeZone'),
            'Default time zone'
        );

        # Exchange axis and check if it works.
        $Selenium->execute_script("\$('#ExchangeAxis').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script( "\$('#Dashboard$StatsWidgetID" . "_submit').trigger('click');" );

        sleep 1;

        $ExitCode = $CommandObject->Execute();
        $Selenium->VerifiedRefresh();

        $Self->Is(
            $Selenium->execute_script('return $(".nv-legend-text:contains(open)").length'),
            1,
            "Legend entry for open state found.",
        );

        # Change the language from the user to test the translations.
        $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
            UserID => $TestUserID,
            Key    => 'UserLanguage',
            Value  => 'de',
        );

        $ExitCode = $CommandObject->Execute();
        $Selenium->VerifiedRefresh();

        $Self->Is(
            $Selenium->execute_script('return $(".nv-legend-text:contains(offen)").length'),
            1,
            "Legend entry for open state found.",
        );

        # delete test stat
        $Self->True(
            $StatsObject->StatsDelete(
                StatID => $TestStatID,
                UserID => $TestUserID,
            ),
            "Stats is deleted - ID $TestStatID",
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
