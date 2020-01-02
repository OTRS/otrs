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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Navigate to AdminSystemConfiguration screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfiguration"
        );

        if ( $Kernel::OM->Get('Kernel::Config')->Get('ConfigImportAllowed') ) {

            # Click on Import/Export button.
            $Selenium->find_element( '.fa-exchange', 'css' )->click();

            # Make sure that import button is on the page.
            $Selenium->find_element( '#ImportButton', 'css' );

            # Make sure that export button is on the page.
            $Selenium->find_element( '#ExportButton', 'css' );

            # Disable import.
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => 'ConfigImportAllowed',
                Value => 0,
            );

            # Refresh the screen.
            $Selenium->VerifiedRefresh();

            # Make sure that export button is on the page.
            $Selenium->find_element( '#ExportButton', 'css' );

        }

        # Make sure that import button is not on the page.
        $Self->False(
            $Selenium->execute_script('return $("#ImportButton").length;') // 0,
            'Import button not found'
        );
    }
);

1;
