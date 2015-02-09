# --
# AdminState.t - frontend tests for AdminState
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

use Kernel::System::UnitTest::Helper;
use Kernel::System::UnitTest::Selenium;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose => 1,
);

$Selenium->RunTest(
    sub {

        my $Helper = Kernel::System::UnitTest::Helper->new(
            RestoreSystemConfiguration => 0,
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminState");

        $Self->True(
            index( $Selenium->get_page_source(), 'closed successful' ) > -1,
            'closed successful found on page',
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # click 'add new state' link
        $Selenium->find_element( "a.Create", 'css' )->click();

        # check add page
        my $Element = $Selenium->find_element( "#Name", 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Selenium->find_element( "#TypeID",  'css' );
        $Selenium->find_element( "#ValidID", 'css' );

        # check client side validation
        $Selenium->find_element( "#Name", 'css' )->clear();
        $Selenium->find_element( "#Name", 'css' )->submit();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # create a real test state
        my $RandomID = $Helper->GetRandomID();

        $Selenium->find_element( "#Name",                      'css' )->send_keys($RandomID);
        $Selenium->find_element( "#TypeID option[value='1']",  'css' )->click();
        $Selenium->find_element( "#ValidID option[value='1']", 'css' )->click();
        $Selenium->find_element( "#Comment",                   'css' )->send_keys('Selenium test state');
        $Selenium->find_element( "#Name",                      'css' )->submit();

        # check overview page
        $Self->True(
            index( $Selenium->get_page_source(), 'closed successful' ) > -1,
            'closed successful found on page',
        );
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID found on page",
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # go to new state again
        $Selenium->find_element( $RandomID, 'link_text' )->click();

        # check new state values
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $RandomID,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#TypeID', 'css' )->get_value(),
            1,
            "#TypeID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            'Selenium test state',
            "#Comment stored value",
        );

        # set test state to invalid
        $Selenium->find_element( "#TypeID option[value='2']",  'css' )->click();
        $Selenium->find_element( "#ValidID option[value='2']", 'css' )->click();
        $Selenium->find_element( "#Comment",                   'css' )->clear();
        $Selenium->find_element( "#Name",                      'css' )->submit();

        # check overview page
        $Self->True(
            index( $Selenium->get_page_source(), 'closed successful' ) > -1,
            'closed successful found on page',
        );
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID found on page",
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # go to new state again
        $Selenium->find_element( $RandomID, 'link_text' )->click();

        # check new state values
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $RandomID,
            "#Name updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#TypeID', 'css' )->get_value(),
            2,
            "#TypeID updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            2,
            "#ValidID updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            '',
            "#Comment updated value",
        );

        # Since there are no tickets that rely on our test state, we can remove them again
        # from the DB.
        my $StateID = $Kernel::OM->Get('Kernel::System::State')->StateLookup(
            State => $RandomID,
        );
        my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => "DELETE FROM ticket_state WHERE id = $StateID",
        );
        $Self->True(
            $Success,
            "StateDelete - $RandomID",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'State',
        );

        }
);

1;
