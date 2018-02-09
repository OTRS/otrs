# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Test Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => 'SeleniumCustomer@localhost.com',
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Force sub menu to be visible in order to be able to click one of the links.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function'" );
        $Selenium->execute_script("\$('#nav-Miscellaneous-container').css('height', 'auto')");
        $Selenium->execute_script("\$('#nav-Miscellaneous-container').css('opacity', '1')");
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#nav-Miscellaneous-container').css('height') !== '0px' && \$('#nav-Miscellaneous-container').css('opacity') == '1'"
        );

        # Click on 'Free Fields' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketFreeText;TicketID=$TicketID' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Title").length' );

        # Check page.
        for my $ID (
            qw(Title submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Change ticket title.
        $Selenium->find_element( "#Title",          'css' )->clear();
        $Selenium->find_element( "#Title",          'css' )->send_keys('FreeText');
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Navigate to AgentTicketHistory of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

        # Confirm free text action.
        my $FreeFieldMsg = "Title updated: Old: \"Selenium Test Ticket\", New: \"FreeText\"";
        $Self->True(
            index( $Selenium->get_page_source(), $FreeFieldMsg ) > -1,
            "Ticket free text action completed",
        );

        # Delete created test tickets.
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
        }
        $Self->True(
            $Success,
            "Ticket is deleted - ID $TicketID"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

1;
