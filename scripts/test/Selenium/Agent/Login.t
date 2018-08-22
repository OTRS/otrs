# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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

        my $TestUserLogin = $Helper->TestUserCreate() || die "Did not get test user";

        my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

        # First load the page so we can delete any pre-existing cookies
        $Selenium->get("${ScriptAlias}index.pl");
        $Selenium->delete_all_cookies();

        # Now load it again to login
        $Selenium->get("${ScriptAlias}index.pl");

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
        $Selenium->find_element( "#LoginButton", 'css' )->click();

        # Wait until form has loaded, if neccessary
        ACTIVESLEEP:
        for my $Second ( 1 .. 20 ) {
            if ( $Selenium->execute_script('return typeof($) === "function" && $("a#LogoutButton").length') ) {
                last ACTIVESLEEP;
            }
            sleep 1;
        }

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
