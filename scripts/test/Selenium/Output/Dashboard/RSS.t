# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
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
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # disable all dashboard plugins
        my $Config = $Kernel::OM->Get('Kernel::Config')->Get('DashboardBackend');
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'DashboardBackend',
            Value => \%$Config,
        );

        # get dashboard RSS plugin default sysconfig
        my %RSSConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name    => 'DashboardBackend###0410-RSS',
            Default => 1,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0410-RSS',
            Value => $RSSConfig{EffectiveValue},
        );

        # Avoid SSL errors on old test platforms.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'WebUserAgent::DisableSSLVerification',
            Value => 1,
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # wait for RSS plugin to show up
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Dashboard0410-RSS").length' );

        # test if RSS plugin shows correct link
        my $RSSLink = "https://www.otrs.com/";
        $Self->True(
            $Selenium->execute_script("return \$('#Dashboard0410-RSS').find(\"a.AsBlock[href*='$RSSLink']\").length;")
                > 0,
            "RSS dashboard plugin link ($RSSLink) - found",
        );

        # make sure cache is correct
        for my $Cache (qw( Dashboard DashboardQueueOverview )) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
