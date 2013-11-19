# --
# 100-AdminState.t - frontend tests for AdminState
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: 100-AdminState.t,v 1.1.2.2 2011-02-09 15:45:46 mg Exp $
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

require Kernel::System::UnitTest::Selenium;

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
        my $sel = Kernel::System::UnitTest::Selenium->new(
            Verbose        => 1,
            UnitTestObject => $Self,
            %{$SeleniumScenario},
        );

        eval {

            $sel->Login(
                Type     => 'Agent',
                User     => $TestUserLogin,
                Password => $TestUserLogin,
            );

            my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

            $sel->open_ok("${ScriptAlias}index.pl?Action=AdminState");
            $sel->wait_for_page_to_load_ok("30000");

            $sel->is_text_present_ok('closed successful');
            $sel->is_element_present_ok("css=table");
            $sel->is_element_present_ok("css=table thead tr th");
            $sel->is_element_present_ok("css=table tbody tr td");

            # click 'add new state' link
            $sel->click_ok("css=a.Plus");
            $sel->wait_for_page_to_load_ok("30000");

            # check add page
            $sel->is_editable_ok("Name");
            $sel->is_element_present_ok("css=#TypeID");
            $sel->is_element_present_ok("css=#ValidID");

            # check client side validation
            $sel->type_ok( "Name", "" );
            $sel->click_ok("css=button#Submit");
            $Self->Is(
                $sel->get_eval(
                    "this.browserbot.getCurrentWindow().\$('#Name').hasClass('Error')"
                ),
                'true',
                'Client side validation correctly detected missing input value',
            );

            # create a real test state
            my $RandomID = $Helper->GetRandomID();

            $sel->type_ok( "Name", $RandomID );
            $sel->select_ok( "TypeID",  "value=1" );    # new
            $sel->select_ok( "ValidID", "value=1" );    # valid
            $sel->type_ok( "Comment", 'Selenium test state' );
            $sel->click_ok("css=button#Submit");
            $sel->wait_for_page_to_load_ok("30000");

            # check overview page
            $sel->is_text_present_ok($RandomID);
            $sel->is_text_present_ok('closed successful');
            $sel->is_element_present_ok("css=table");
            $sel->is_element_present_ok("css=table thead tr th");
            $sel->is_element_present_ok("css=table tbody tr td");

            # go to new state again
            $sel->click_ok("link=$RandomID");
            $sel->wait_for_page_to_load_ok("30000");

            # check new state values
            $sel->value_is( 'Name',    $RandomID );
            $sel->value_is( 'TypeID',  1 );
            $sel->value_is( 'ValidID', 1 );
            $sel->value_is( 'Comment', 'Selenium test state' );

            # set test state to invalid
            $sel->select_ok( "TypeID",  "value=2" );
            $sel->select_ok( "ValidID", "value=2" );
            $sel->type_ok( "Comment", '' );
            $sel->click_ok("css=button#Submit");
            $sel->wait_for_page_to_load_ok("30000");

            # check overview page
            $sel->is_text_present_ok($RandomID);
            $sel->is_text_present_ok('closed successful');
            $sel->is_element_present_ok("css=table");
            $sel->is_element_present_ok("css=table thead tr th");
            $sel->is_element_present_ok("css=table tbody tr td");

            # go to new state again
            $sel->click_ok("link=$RandomID");
            $sel->wait_for_page_to_load_ok("30000");

            # check new state values
            $sel->value_is( 'Name',    $RandomID );
            $sel->value_is( 'TypeID',  2 );
            $sel->value_is( 'ValidID', 2 );
            $sel->value_is( 'Comment', '' );

            return 1;
        } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );

        return 1;

    } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );
}

1;
