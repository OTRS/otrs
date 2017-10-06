# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create test tickets.
        my @TicketIDs;
        my @TicketNumbers;
        for my $Ticket ( 1 .. 2 ) {
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN           => $TicketNumber,
                Title        => "Selenium Test Ticket $Ticket",
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'new',
                CustomerID   => $Ticket == 1 ? 'SeleniumCustomer' : undef,    # no CustomerID for second test ticket
                CustomerUser => "SeleniumCustomer\@localhost.com",
                OwnerID      => 1,
                UserID       => 1,
            );
            $Self->True(
                $TicketID,
                "Ticket is created - ID $TicketID",
            );

            push @TicketIDs,     $TicketID;
            push @TicketNumbers, $TicketNumber;

        }

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[0]");

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#nav-Miscellaneous-container').css('opacity') === '1'"
        );

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # Click on 'Merge' and switch to merge window.
        $Selenium->execute_script("\$('#nav-Merge a').click()");
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#MainTicketNumber").length' );

        # Check page.
        for my $ID (
            qw(MainTicketNumber InformSender To Subject RichText submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Expand the widget if it is collapsed.
        my $Expanded = $Selenium->execute_script(
            "return \$('#WidgetInformSender a[title=\"Toggle this widget\"]').attr('aria-expanded')"
        );

        if ( $Expanded eq 'false' ) {
            $Selenium->find_element( "#WidgetInformSender a[title=\'Toggle this widget\']", 'css' )->click();

            # Wait until widget is expanded.
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#WidgetInformSender a[title=\"Toggle this widget\"]').attr('aria-expanded') === 'true'"
            );

            # Verify the widget is expanded.
            $Self->True(
                $Selenium->execute_script(
                    "return \$('#WidgetInformSender a[title=\"Toggle this widget\"]').attr('aria-expanded') === 'true'"
                ),
                "The widget 'Inform Sender' is expanded",
            );
        }

        # Set checkbox to uncheck.
        $Selenium->execute_script("\$('#InformSender').prop('checked', false)");

        # Collapse the widget.
        $Selenium->find_element( "#WidgetInformSender .WidgetAction a[title='Toggle this widget']", 'css' )->click();

        # Wait until widget is collapsed.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#WidgetInformSender .WidgetAction a[title=\"Toggle this widget\"]').attr('aria-expanded') === 'false'"
        );

        # Verify the widget is collapsed.
        $Self->True(
            $Selenium->execute_script(
                "return \$('#WidgetInformSender a[title=\"Toggle this widget\"]').attr('aria-expanded') === 'false'"
            ),
            "The widget 'Inform Sender' is collapsed",
        );

        # Expand the widget again.
        $Selenium->find_element( "#WidgetInformSender .WidgetAction a[title='Toggle this widget']", 'css' )->click();

        # Wait until widget is expanded.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#WidgetInformSender .WidgetAction a[title=\"Toggle this widget\"]').attr('aria-expanded') === 'true'"
        );

        # Verify the widget is expanded.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetInformSender a[title=\"Toggle this widget\"]').attr('aria-expanded')"
            ),
            'true',
            "The widget 'Inform Sender' is expanded",
        );

        # Check if the checkbox is checked.
        $Self->True(
            $Selenium->execute_script("return \$('#InformSender').prop('checked') === true"),
            "The checkbox 'Inform sender' is checked",
        );

        # Check if fields are mandatory.
        for my $Label (qw(To Subject RichText)) {
            $Self->True(
                $Selenium->execute_script("return \$('label[for=$Label]').hasClass('Mandatory')"),
                "Label '$Label' has class 'Mandatory'",
            );
        }

        # Set fields to be not mandatory.
        $Selenium->execute_script("\$('#InformSender').prop('checked', false)");

        # Check client side validation.
        my $Element = $Selenium->find_element( "#MainTicketNumber", 'css' );
        $Element->send_keys("");
        $Selenium->execute_script("\$('#submitRichText').click()");
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#MainTicketNumber.Error').length" );

        $Self->True(
            $Selenium->execute_script("return \$('#MainTicketNumber').hasClass('Error')"),
            'Client side validation correctly detected missing input value',
        );

        # Expect error when try to merge ticket with itself.
        $Selenium->find_element( "#MainTicketNumber", 'css' )->send_keys( $TicketNumbers[0] );
        $Selenium->execute_script("\$('#submitRichText').click()");
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('div.Content > p:contains(\"merge ticket with itself!\")').length"
        );

        $Self->True(
            $Selenium->execute_script("return \$('div.Content > p:contains(\"merge ticket with itself!\")').length"),
            "Successfully can't merge ticket with itself",
        );

        # Close popup and switch back to the main window.
        $Selenium->close();
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Refresh screen and wait until page has loaded, if necessary.
        $Selenium->VerifiedRefresh();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Cluster ul ul").length' );

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#nav-Miscellaneous-container').css('opacity') === '1'"
        );

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # Click on 'Merge' and switch to merge window.
        $Selenium->execute_script("\$('#nav-Merge a').click()");
        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#MainTicketNumber").length' );

        # Try to merge with second test ticket.
        $Selenium->find_element( '#MainTicketNumber', 'css' )->clear();
        $Selenium->find_element( '#MainTicketNumber', 'css' )->send_keys( $TicketNumbers[1] );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader").length' );

        $Self->False(
            $Selenium->execute_script("return \$('li.ui-menu-item:visible').length;"),
            'Ticket with undefined CustomerID correctly filtered'
        );

        # Clear the Customer ID filter.
        $Selenium->find_element( '#TicketSearchFilter', 'css' )->click();

        # Try again to merge with second test ticket.
        $Selenium->find_element( '#MainTicketNumber', 'css' )->clear();
        $Selenium->find_element( '#MainTicketNumber', 'css' )->send_keys( $TicketNumbers[1] );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TicketNumbers[1])').click()");
        $Selenium->execute_script("\$('#submitRichText').click();");

        # Return back to zoom view and click on history and switch to its view.
        $Selenium->WaitFor( WindowCount => 1 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[0] );

        # Refresh screen and wait until page has loaded, if necessary.
        $Selenium->VerifiedRefresh();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Cluster ul ul").length' );

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#nav-Miscellaneous-container').css('opacity') === '1'"
        );

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # Click on 'History'.
        $Selenium->execute_script("\$('#nav-History a').click()");

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length' );

        # Confirm merge action.
        my $MergeMsg = "Merged Ticket ($TicketNumbers[0]/$TicketIDs[0]) to ($TicketNumbers[1]/$TicketIDs[1])";
        $Self->True(
            index( $Selenium->get_page_source(), $MergeMsg ) > -1,
            "Merge action completed",
        );

        # Close popup.
        $Selenium->find_element( ".CancelClosePopup", 'css' )->click();
        $Selenium->WaitFor( WindowCount => 1 );

        # Delete created test tickets.
        for my $Ticket (@TicketIDs) {
            my $Success = $TicketObject->TicketDelete(
                TicketID => $Ticket,
                UserID   => 1,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $Ticket,
                    UserID   => 1,
                );
            }
            $Self->True(
                $Success,
                "Ticket with ticket ID $Ticket is deleted"
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

1;
