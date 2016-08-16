# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
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
            Value => $Config,
        );

        # get dashboard News plugin default sysconfig
        my %NewsConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemGet(
            Name    => 'DashboardBackend###0405-News',
            Default => 1,
        );

        # set dashboard News plugin to valid
        %NewsConfig = map { $_->{Key} => $_->{Content} }
            grep { defined $_->{Key} } @{ $NewsConfig{Setting}->[1]->{Hash}->[1]->{Item} };

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0405-News',
            Value => \%NewsConfig,
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

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate dashboard screen and wait until page has loaded
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        # test if News plugin shows correct link
        my $NewsLink = "https://www.otrs.com/";
        $Self->True(
            $Selenium->execute_script(
                "return \$('#Dashboard0405-News').find(\"a.AsBlock[href*='$NewsLink']\").length;"
                ) > 0,
            "News dashboard plugin link ($NewsLink) - found",
        );
    }
);

1;
