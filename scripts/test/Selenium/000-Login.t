# --
# 000-Login.t - frontend tests for login
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::Config;
use Kernel::System::User;

use Kernel::System::UnitTest::Helper;

if ( !$Self->{ConfigObject}->Get('SeleniumTestsActive') ) {
    $Self->True( 1, 'Selenium testing is not active' );
    return 1;
}

require Kernel::System::UnitTest::Selenium;    ## no critic

my $Helper = Kernel::System::UnitTest::Helper->new(
    UnitTestObject => $Self,
    %{$Self},
    RestoreSystemConfiguration => 0,
);

my $TestUserLogin = $Helper->TestUserCreate() || die "Did not get test user";

for my $SeleniumScenario ( @{ $Helper->SeleniumScenariosGet() } ) {
    eval {
        my $Selenium = Kernel::System::UnitTest::Selenium->new(
            Verbose        => 1,
            UnitTestObject => $Self,
            %{$SeleniumScenario},
        );

        eval {

            my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

            # open login page with logout action to make sure we're logged out
            $Selenium->open_ok("${ScriptAlias}index.pl?Action=Logout");

            # prevent version information disclosure
            $Self->False(
                $Selenium->is_text_present("Powered"),
                'No version information disclosure'
            );

            # check
            $Selenium->is_editable_ok("User");
            $Selenium->type_ok( "User", $TestUserLogin );
            $Selenium->is_editable_ok("Password");
            $Selenium->type_ok( "Password", $TestUserLogin );
            $Selenium->is_visible_ok("css=button#LoginButton");

            # login
            if ( !$Selenium->click_ok("css=button#LoginButton") ) {
                $Self->False( 1, "Could not submit login form" );
                return;
            }
            $Selenium->wait_for_page_to_load_ok("30000");

            # login succressful?
            if ( !$Selenium->is_element_present_ok("css=a#LogoutButton") ) {
                $Self->False( 1, "Login was not successful" );
                return;
            }

            # logout again
            if ( !$Selenium->click_ok("css=a#LogoutButton") ) {
                $Selenium->False( 1, "Could not submit logout form" );
                return;
            }

            $Selenium->wait_for_page_to_load_ok("30000");
            $Selenium->is_editable_ok("User");
            $Selenium->is_editable_ok("Password");
            $Selenium->is_visible_ok("//button[\@id='LoginButton']");

            return 1;
        } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );

        return 1;

    } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );
}

1;
