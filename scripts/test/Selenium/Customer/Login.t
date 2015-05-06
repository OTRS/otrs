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

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Selenium     = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $TestUserLogin = $Helper->TestCustomerUserCreate() || die "Did not get test user";

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # first load the page so we can delete any pre-existing cookies
        $Selenium->get("${ScriptAlias}customer.pl");
        $Selenium->delete_all_cookies();

        # now load it again to login
        $Selenium->get("${ScriptAlias}customer.pl");

        # prevent version information disclosure
        $Self->False(
            index( $Selenium->get_page_source(), 'Powered' ) > -1,
            'No version information disclosure'
        );

        my $Element = $Selenium->find_element( 'input#User', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys($TestUserLogin);

        $Element = $Selenium->find_element( 'input#Password', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys($TestUserLogin);

        # login
        $Element->submit();

        # login succressful?
        $Element = $Selenium->find_element( 'a#LogoutButton', 'css' );

        # logout again
        $Element->click();

        # login page?
        $Element = $Selenium->find_element( 'input#User', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys($TestUserLogin);
    }
);

1;
