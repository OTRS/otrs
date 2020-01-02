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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable PerformanceLog
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PerformanceLog',
            Value => 1
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminPerformanceLog screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPerformanceLog");

        # check for Admin on different range time screens
        for my $Time (
            qw(5 30 60 120 1440 2880)
            )
        {
            # click on Admin
            $Selenium->find_element("//a[contains(\@href, \'Interface=Agent;Minute=$Time' )]")->VerifiedClick();

            # check screen layout
            $Selenium->find_element( "table",             'css' );
            $Selenium->find_element( "table thead tr th", 'css' );
            $Selenium->find_element( "table tbody tr td", 'css' );
            $Selenium->find_element( "div.Progressbar",   'css' )->is_displayed();

            # click on "Go to overview"
            $Selenium->find_element("//a[contains(\@href, \'Action=AdminPerformanceLog' )]")->VerifiedClick();

        }

    }

);

1;
