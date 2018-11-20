# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $ScriptAlias  = $ConfigObject->Get('ScriptAlias');

        # Navigate to AdminState screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminState");

        $Self->True(
            index( $Selenium->get_page_source(), 'closed successful' ) > -1,
            'closed successful found on page',
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Click 'add new state' link.
        $Selenium->find_element( "a.Create", 'css' )->VerifiedClick();

        # Check add page.
        my $Element = $Selenium->find_element( "#Name", 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Selenium->find_element( "#TypeID",  'css' );
        $Selenium->find_element( "#ValidID", 'css' );

        # Check client side validation.
        $Selenium->find_element( "#Name",   'css' )->clear();
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Create a real test state.
        my $RandomState = "New State " . $Helper->GetRandomID();

        $Selenium->find_element( "#Name", 'css' )->send_keys($RandomState);
        $Selenium->execute_script("\$('#TypeID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Comment", 'css' )->send_keys('Selenium test state');
        $Selenium->find_element( "#Submit",  'css' )->VerifiedClick();

        my $StateObject = $Kernel::OM->Get('Kernel::System::State');
        my $StateIDNew  = $StateObject->StateLookup(
            State => 'new',
        );
        my $StateIDClose = $StateObject->StateLookup(
            State => 'closed successful',
        );
        my $StateIDTest = $StateObject->StateLookup(
            State => $RandomState,
        );

        my $StateLink = "/${ScriptAlias}index.pl?Action=AdminState;Subaction=Change;ID=";

        # Check overview page.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('a[href=\"${StateLink}$StateIDClose\"]').text();"
            ),
            'closed successful',
            "State 'closed successful' found on page",
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('a[href=\"${StateLink}$StateIDNew\"]').text();"
            ),
            'new',
            "State 'new' found on page",
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('a[href=\"${StateLink}$StateIDTest\"]').text();"
            ),
            $RandomState,
            "State '$RandomState' found on page",
        );

        my $IndexNewState =
            $Selenium->execute_script(
            "return \$('.DataTable tr:visible').index(\$('a[href=\"${StateLink}$StateIDNew\"]').closest('tr'))"
            );
        my $IndexTestState =
            $Selenium->execute_script(
            "return \$('.DataTable tr:visible').index(\$('a[href=\"${StateLink}$StateIDTest\"]').closest('tr'))"
            );

        # Check sorting in state overview table..
        $Self->True(
            $IndexNewState < $IndexTestState,
            "Order of states in the table is well.",
        );

        # Go to test state again.
        $Selenium->find_element( $RandomState, 'link_text' )->VerifiedClick();

        # Check test state values.
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $RandomState,
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

        # Set test state to invalid.
        $Selenium->execute_script("\$('#TypeID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Comment", 'css' )->clear();
        $Selenium->find_element( "#Submit",  'css' )->VerifiedClick();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" &&  $(".DataTable").length;' );

        # Check class of invalid state in the overview table.
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($RandomState)').length"
            ),
            "There is a class 'Invalid' for test State",
        );

        # Go to test state again.
        $Selenium->find_element( $RandomState, 'link_text' )->VerifiedClick();

        # Check updated test state values.
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $RandomState,
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

        # Since there are no tickets that rely on our test state, we can remove them again.
        # from the DB.
        my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => "DELETE FROM ticket_state WHERE id = $StateIDTest",
        );
        $Self->True(
            $Success,
            "StateDelete - $RandomState",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'State',
        );

    }
);

1;
