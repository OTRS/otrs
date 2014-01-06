# --
# 000-Login.t - frontend tests for login
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: 000-Login.t,v 1.4 2011-02-09 15:45:30 mg Exp $
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
use Time::HiRes qw(sleep);

if ( !$Self->{ConfigObject}->Get('SeleniumTestsActive') ) {
    $Self->True( 1, 'Selenium testing is not active' );
    return 1;
}

require Kernel::System::UnitTest::Selenium;

my $Helper = Kernel::System::UnitTest::Helper->new(
    UnitTestObject => $Self,
    %{$Self},
    RestoreSystemConfiguration => 0,
);

my $TestUserLogin = $Helper->TestUserCreate() || die "Did not get test user";

for my $SeleniumScenario ( @{ $Helper->SeleniumScenariosGet() } ) {
    eval {
        my $sel = Kernel::System::UnitTest::Selenium->new(
            Verbose        => 1,
            UnitTestObject => $Self,
            %{$SeleniumScenario},
        );

        eval {

            my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

            # open login page with logout action to make sure we're logged out
            $sel->open_ok("${ScriptAlias}index.pl?Action=Logout");

            # prevent version information disclosure
            $Self->False( $sel->is_text_present("Powered"), 'No version information disclosure' );

            # check
            $sel->is_editable_ok("User");
            $sel->type_ok( "User", $TestUserLogin );
            $sel->is_editable_ok("Password");
            $sel->type_ok( "Password", $TestUserLogin );
            $sel->is_visible_ok("css=button#LoginButton");

            # login
            if ( !$sel->click_ok("css=button#LoginButton") ) {
                $Self->False( 1, "Could not submit login form" );
                return;
            }
            $sel->wait_for_page_to_load_ok("30000");

            # login succressful?
            if ( !$sel->is_element_present_ok("css=a#LogoutButton") ) {
                $Self->False( 1, "Login was not successful" );
                return;
            }

            # logout again
            if ( !$sel->click_ok("css=a#LogoutButton") ) {
                $sel->False( 1, "Could not submit logout form" );
                return;
            }

            $sel->wait_for_page_to_load_ok("30000");
            $sel->is_editable_ok("User");
            $sel->is_editable_ok("Password");
            $sel->is_visible_ok("//button[\@id='LoginButton']");

            return 1;
        } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );

        return 1;

    } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );
}

1;
