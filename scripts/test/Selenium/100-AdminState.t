# --
# 100-AdminState.t - frontend tests for AdminState
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::System::UnitTest::Helper;
use Time::HiRes qw(sleep);

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

my $TestUserLogin = $Helper->TestUserCreate(
    Groups => ['admin'],
) || die "Did not get test user";

for my $SeleniumScenario ( @{ $Helper->SeleniumScenariosGet() } ) {
    eval {
        my $Selenium = Kernel::System::UnitTest::Selenium->new(
            Verbose        => 1,
            UnitTestObject => $Self,
            %{$SeleniumScenario},
        );

        eval {

            $Selenium->Login(
                Type     => 'Agent',
                User     => $TestUserLogin,
                Password => $TestUserLogin,
            );

            my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

            $Selenium->open_ok("${ScriptAlias}index.pl?Action=AdminState");
            $Selenium->wait_for_page_to_load_ok("30000");

            $Selenium->is_text_present_ok('closed successful');
            $Selenium->is_element_present_ok("css=table");
            $Selenium->is_element_present_ok("css=table thead tr th");
            $Selenium->is_element_present_ok("css=table tbody tr td");

            # click 'add new state' link
            $Selenium->click_ok("css=a.Plus");
            $Selenium->wait_for_page_to_load_ok("30000");

            # check add page
            $Selenium->is_editable_ok("Name");
            $Selenium->is_element_present_ok("css=#TypeID");
            $Selenium->is_element_present_ok("css=#ValidID");

            # check client side validation
            $Selenium->type_ok( "Name", "" );
            $Selenium->click_ok("css=button#Submit");
            $Self->Is(
                $Selenium->get_eval(
                    "this.browserbot.getCurrentWindow().\$('#Name').hasClass('Error')"
                ),
                'true',
                'Client side validation correctly detected missing input value',
            );

            # create a real test state
            my $RandomID = $Helper->GetRandomID();

            $Selenium->type_ok( "Name", $RandomID );
            $Selenium->select_ok( "TypeID",  "value=1" );    # new
            $Selenium->select_ok( "ValidID", "value=1" );    # valid
            $Selenium->type_ok( "Comment", 'Selenium test state' );
            $Selenium->click_ok("css=button#Submit");
            $Selenium->wait_for_page_to_load_ok("30000");

            # check overview page
            $Selenium->is_text_present_ok($RandomID);
            $Selenium->is_text_present_ok('closed successful');
            $Selenium->is_element_present_ok("css=table");
            $Selenium->is_element_present_ok("css=table thead tr th");
            $Selenium->is_element_present_ok("css=table tbody tr td");

            # go to new state again
            $Selenium->click_ok("link=$RandomID");
            $Selenium->wait_for_page_to_load_ok("30000");

            # check new state values
            $Selenium->value_is( 'Name',    $RandomID );
            $Selenium->value_is( 'TypeID',  1 );
            $Selenium->value_is( 'ValidID', 1 );
            $Selenium->value_is( 'Comment', 'Selenium test state' );

            # set test state to invalid
            $Selenium->select_ok( "TypeID",  "value=2" );
            $Selenium->select_ok( "ValidID", "value=2" );
            $Selenium->type_ok( "Comment", '' );
            $Selenium->click_ok("css=button#Submit");
            $Selenium->wait_for_page_to_load_ok("30000");

            # check overview page
            $Selenium->is_text_present_ok($RandomID);
            $Selenium->is_text_present_ok('closed successful');
            $Selenium->is_element_present_ok("css=table");
            $Selenium->is_element_present_ok("css=table thead tr th");
            $Selenium->is_element_present_ok("css=table tbody tr td");

            # go to new state again
            $Selenium->click_ok("link=$RandomID");
            $Selenium->wait_for_page_to_load_ok("30000");

            # check new state values
            $Selenium->value_is( 'Name',    $RandomID );
            $Selenium->value_is( 'TypeID',  2 );
            $Selenium->value_is( 'ValidID', 2 );
            $Selenium->value_is( 'Comment', '' );

            return 1;
        } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );

        return 1;

    } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );
}

1;
