# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Overload CustomerUser => Map setting defined in the Defaults.pm.
        my $DefaultCustomerUser = $Kernel::OM->Get('Kernel::Config')->Get("CustomerUser");
        $DefaultCustomerUser->{Map}->[5] = [
            'UserEmail',
            'Email',
            'email',
            1,
            1,
            'var',
            '[% Env("CGIHandle") %]?Action=AgentTicketCompose;ResponseID=1;TicketID=[% Data.TicketID | uri %];ArticleID=[% Data.ArticleID | uri %]',
            0,
            '',
            'AsPopup OTRSPopup_TicketAction',
        ];
        $Helper->ConfigSettingChange(
            Key   => 'CustomerUser',
            Value => $DefaultCustomerUser,
        );

        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # Do not check service and type.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Add customer users and tickets for testing.
        my @TestCustomers;
        my @TicketIDs;
        for my $Count ( 1 .. 2 )
        {
            my $TestCustomer = 'CustomerUser' . $Helper->GetRandomID();
            my $UserLogin    = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
                Source         => 'CustomerUser',
                UserFirstname  => $TestCustomer,
                UserLastname   => $TestCustomer,
                UserCustomerID => $TestCustomer,
                UserLogin      => $TestCustomer,
                UserEmail      => "$TestCustomer\@localhost.com",
                ValidID        => 1,
                UserID         => $TestUserID,
            );

            $Self->True(
                $UserLogin,
                "Test customer user is created - $UserLogin",
            );

            push @TestCustomers, $TestCustomer;

            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN           => $TicketNumber,
                Title        => 'Selenium Test Ticket',
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'open',
                CustomerID   => 'TestCustomer',
                CustomerUser => $Count == 1 ? $TestCustomers[0] : 'TestCustomerUser',
                OwnerID      => $TestUserID,
                UserID       => $TestUserID,
            );
            $Self->True(
                $TicketID,
                "Ticket is created - $TicketID",
            );

            push @TicketIDs, $TicketID;
        }

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[0]");

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");

        # Go to AgentTicketCustomer, it causes open popup screen, wait will be done by WaitFor.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketCustomer' )]")->click();

        # Switch to another window.
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Set size for small screens, because of sidebar with customer info overflow form for customer data.
        $Selenium->set_window_size( 1000, 700 );
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#CustomerInfo a:contains(Open tickets)").attr("target") === "_blank"'
        );

        # Check if user email is a link in the Customer Information widget and has target property.
        $Self->Is(
            $Selenium->execute_script("return \$('#CustomerInfo a:contains(Open tickets)').attr('target');"),
            '_blank',
            "Check if user email is a link in the Customer Information widget and has target property."
        );

        # Check AgentTicketCustomer screen.
        for my $ID (
            qw(CustomerAutoComplete CustomerID Submit CustomerInfo CustomerTickets)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '#CustomerAutoComplete',
            Event       => 'change',
        );

        $Selenium->find_element( "#CustomerAutoComplete", 'css' )->clear();
        $Selenium->find_element( "#CustomerAutoComplete", 'css' )->send_keys( $TestCustomers[1] );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCustomers[1])').click()");

        # Wait until customer data is loading (CustomerID is filled after CustomerAutoComplete).
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#CustomerID").val().length' );

        # Submit customer data, it causes close popup screen, wait will be done by WaitFor.
        $Selenium->execute_script("\$('#submitRichText').click();");
        $Selenium->close();

        # Wait for update.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketIDs[0]");

        # Verify that action worked as expected.
        my $HistoryText = "CustomerID=$TestCustomers[1];CustomerUser=$TestCustomers[1]";

        $Self->True(
            index( $Selenium->get_page_source(), 'CustomerUpdate' ) > -1,
            "Action AgentTicketCustomer executed correctly",
        );

        # Navigate to the second ticket to check if widget hasn't got any information.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[1]");

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");

        # Go to AgentTicketCustomer, it causes open popup screen, wait will be done by WaitFor.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketCustomer' )]")->click();

        # Switch to another window.
        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#CustomerInfo div.Content").text().trim() === "none"'
        );

        # Check if user email is a link in the Customer Information widget and has target property.
        $Self->Is(
            $Selenium->execute_script("return \$('#CustomerInfo div.Content').text().trim()"),
            'none',
            "There is no any info in Customer Information widget"
        );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '#CustomerAutoComplete',
            Event       => 'change',
        );

        # Select new customer and verify customer field value is not cleared after focus lost.
        # See bug#13880 (https://bugs.otrs.org/show_bug.cgi?id=13880).
        $Selenium->find_element( "#CustomerAutoComplete", 'css' )->clear();
        $Selenium->find_element( "#CustomerAutoComplete", 'css' )->send_keys( $TestCustomers[0] );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCustomers[0])').click()");

        # Wait until customer data is loading (CustomerID is filled after CustomerAutoComplete).
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#CustomerID").val().length' );

        # Change focus and verify customer auto complete field.
        $Selenium->execute_script("\$(':focus').blur();");
        sleep 1;
        $Self->Is(
            $Selenium->execute_script("return \$('#CustomerAutoComplete').val()"),
            "\"$TestCustomers[0] $TestCustomers[0]\" <$TestCustomers[0]\@localhost.com>",
            "Customer auto complete field after focus lost"
        );

        # Check if CustomerID read only field can be disabled. See bug#14412.
        # Disable CustomerID read only.
        $Selenium->find_element( "a.CancelClosePopup", 'css' )->click();

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketCustomer::CustomerIDReadOnly',
            Value => 0
        );

        # Wait for update.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[0]");

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");

        # Go to AgentTicketCustomer, it causes open popup screen, wait will be done by WaitFor.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketCustomer' )]")->click();

        # Switch to another window.
        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#SelectionCustomerID").length === 1'
        );

        my $RandomCustomerUser = 'RandomCustomerUser' . $Helper->GetRandomID();
        $Selenium->find_element( "#CustomerAutoComplete", 'css' )->clear();
        $Selenium->find_element( "#CustomerID",           'css' )->clear();
        $Selenium->find_element( "#CustomerAutoComplete", 'css' )->send_keys($RandomCustomerUser);
        $Selenium->find_element( "#CustomerID",           'css' )->send_keys($RandomCustomerUser);

        # Check if select button is enabled.
        $Self->Is(
            $Selenium->execute_script("return \$('#SelectionCustomerID').prop('disabled')"),
            0,
            "Button to select a other CustomerID is disabled",
        );

        # Check if CustomerID is not cleared on blur event.
        $Selenium->find_element( "#CustomerAutoComplete", 'css' )->click();
        $Selenium->find_element( "#CustomerID",           'css' )->click();

        $Self->Is(
            $Selenium->execute_script("return \$('#CustomerID').val().trim();"),
            $RandomCustomerUser,
            "CustomerID is not cleared"
        );

        # Return CustomerID read only to default.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketCustomer::CustomerIDReadOnly',
            Value => 1
        );

        $Selenium->find_element( "#Submit", 'css' )->click();

        # Wait for update.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        $Selenium->VerifiedRefresh();

        # Wait for "Customer Information".
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".SidebarColumn fieldset .Value").length'
        );

        # Check if CustomerID is changed correctly.
        $Self->True(
            $Selenium->find_element(
                "//a[contains(\@href, \'Action=AgentCustomerInformationCenter;CustomerID=$RandomCustomerUser')]"
            ),
            "CustomerID is change to $RandomCustomerUser",
        );

        # Delete created test tickets.
        for my $TicketID (@TicketIDs) {
            my $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
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
                "Ticket with ticket id $TicketID is deleted"
            );
        }

        # Delete created test customer users.
        for my $TestCustomer (@TestCustomers) {
            my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
            $TestCustomer = $DBObject->Quote($TestCustomer);
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE login = ?",
                Bind => [ \$TestCustomer ],
            );
            $Self->True(
                $Success,
                "Delete customer user - $TestCustomer",
            );
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (
            qw (Ticket CustomerUser)
            )
        {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
