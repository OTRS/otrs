# --
# Login.t - frontend tests for login
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::Config;

use Kernel::System::UnitTest::Helper;
use Kernel::System::UnitTest::Selenium;

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose        => 1,
    UnitTestObject => $Self,
);

$Selenium->RunTest(
    sub {
        my $Helper = Kernel::System::UnitTest::Helper->new(
            UnitTestObject => $Self,
            %{$Self},
            RestoreSystemConfiguration => 0,
        );

        my $TestUserLogin = $Helper->TestCustomerUserCreate() || die "Did not get test user";

        my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

        # First load the page so we can delete any pre-existing cookies
        $Selenium->get("${ScriptAlias}customer.pl");
        $Selenium->delete_all_cookies();

        # Now load it again to login
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
