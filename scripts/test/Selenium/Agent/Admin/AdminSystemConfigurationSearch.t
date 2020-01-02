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
        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # navigate to AdminSystemConfiguration screen
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfiguration"
        );

        # Search for CloudService::Admin::Module###100-SupportDataCollector(setting with : and # to test encoding).
        $Selenium->find_element( '#SysConfigSearch', 'css' )
            ->send_keys('CloudService::Admin::Module###100-SupportDataCollector');
        $Selenium->WaitFor(
            JavaScript => 'return $("ul.ui-autocomplete a:visible").length',
        );

        # Select autocomplete value.
        $Selenium->find_element( 'a.ui-menu-item-wrapper', 'css' )->VerifiedClick();

        # Check if bread crumb link is working.
        $Selenium->find_element( 'ul.BreadCrumb li:nth-child(3) a', 'css' )->VerifiedClick();

        # Check settings count.
        my $SettingCount = $Selenium->execute_script(
            'return $(".SettingsList li").length'
        );
        $Self->Is(
            $SettingCount,
            1,
            'Make sure there is just 1 setting listed',
        );

        my $SettingName = $Selenium->execute_script(
            'return $(".SettingEdit").data("name");'
        );
        $Self->Is(
            $SettingName,
            'CloudService::Admin::Module###100-SupportDataCollector',
            'Check if correct setting is listed.'
        );
    }
);

1;
