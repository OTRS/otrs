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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # Get needed objects.
        my $Helper                = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject          = $Kernel::OM->Get('Kernel::System::Ticket');
        my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
        my $CustomerUserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        my $RandomNumber = $Helper->GetRandomNumber();

        # Create test customer companies.
        my @CustomerCompanyIDs;
        for my $Count ( 1 .. 2 ) {
            my $TestCompany       = $Count . '-Company-' . $RandomNumber;
            my $CustomerCompanyID = $CustomerCompanyObject->CustomerCompanyAdd(
                CustomerID             => $TestCompany,
                CustomerCompanyName    => $TestCompany,
                CustomerCompanyStreet  => $TestCompany,
                CustomerCompanyZIP     => $TestCompany,
                CustomerCompanyCity    => $TestCompany,
                CustomerCompanyCountry => 'Germany',
                CustomerCompanyURL     => 'http://example.com',
                CustomerCompanyComment => $TestCompany,
                ValidID                => 1,
                UserID                 => 1,
            );
            $Self->True(
                $CustomerCompanyID,
                "CustomerCompanyID $CustomerCompanyID is created",
            );
            push @CustomerCompanyIDs, $CustomerCompanyID;
        }

        # Create test customer users.
        my @CustomerUserLogins;
        for my $Count ( 1 .. 2 ) {
            my $TestUser          = $Count . '-User-' . $RandomNumber;
            my $CustomerUserLogin = $CustomerUserObject->CustomerUserAdd(
                Source         => 'CustomerUser',
                UserFirstname  => $TestUser,
                UserLastname   => $TestUser,
                UserCustomerID => $Count == 1 ? $CustomerCompanyIDs[0] : $CustomerCompanyIDs[1],
                UserLogin      => $TestUser,
                UserEmail      => "$TestUser\@example.com",
                ValidID        => 1,
                UserID         => 1
            );
            $Self->True(
                $CustomerUserLogin,
                "CustomerUser $CustomerUserLogin is created",
            );
            push @CustomerUserLogins, $CustomerUserLogin;
        }

        # Create test tickets.
        my @TicketIDs;
        for my $Count ( 1 .. 2 ) {
            my $TicketID = $TicketObject->TicketCreate(
                Title        => $Count . '-SeleniumTicket-' . $RandomNumber,
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'open',
                CustomerID   => $Count == 1 ? $CustomerCompanyIDs[0] : $CustomerCompanyIDs[1],
                CustomerUser => $Count == 1 ? $CustomerUserLogins[0] : $CustomerUserLogins[1],
                OwnerID      => 1,
                UserID       => 1,
            );
            $Self->True(
                $TicketID,
                "TicketID $TicketID is created",
            );
            push @TicketIDs, $TicketID;
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

        # Get script alias.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        my @Tests = (
            {
                Screen  => 'AgentTicketPhone',
                FieldID => 'FromCustomer',
            },
            {
                Screen  => 'AgentTicketEmail',
                FieldID => 'ToCustomer',
            },
        );

        for my $Test (@Tests) {

            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=$Test->{Screen}");

            # Choose both customer users.
            for my $CustomerUserLogin (@CustomerUserLogins) {
                $Selenium->find_element( "#" . $Test->{FieldID}, 'css' )->clear();
                $Selenium->find_element( "#" . $Test->{FieldID}, 'css' )->send_keys($CustomerUserLogin);
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length'
                );
                $Selenium->execute_script("\$('li.ui-menu-item:contains($CustomerUserLogin)').click()");
                $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".OverviewBox").length' );

                # we wait a second to make sure the content has been set correctly
                sleep 1;
            }

            # Check customer history table existence.
            $Self->True(
                $Selenium->execute_script("return \$('.OverviewBox').length;"),
                "Customer History table is found",
            );

            my $CustomerContentID = 'TicketCustomerContent' . $Test->{FieldID};

            # Remove one of the entered customer users.
            $Selenium->execute_script(
                "\$('#$CustomerContentID input[value=\"$CustomerUserLogins[1]\"]').siblings('a.RemoveButton').trigger('click');"
            );

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && !\$('#$CustomerContentID input[value=\"$CustomerUserLogins[1]\"]').length"
            );

            # Check customer history table existence.
            $Self->True(
                $Selenium->execute_script("return \$('.OverviewBox').length;"),
                "Customer History table is found after removing one customer user from the list",
            );

            # Remove another (the last) customer user.
            $Selenium->execute_script(
                "\$('#$CustomerContentID input[value=\"$CustomerUserLogins[0]\"]').siblings('a.RemoveButton').trigger('click');"
            );

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && !\$('#$CustomerContentID input[value=\"$CustomerUserLogins[0]\"]').length"
            );

            # Check customer history table existence - should be gone.
            $Self->False(
                $Selenium->execute_script("return \$('.OverviewBox').length;"),
                "Customer History table is not found after removing the last customer user from the list",
            );
        }

        # Navigate to the AgentTicketCustomer screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketCustomer;TicketID=$TicketIDs[0]");

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".OverviewBox").length' );

        # Check customer info sidebar and customer history table.
        $Self->IsNot(
            $Selenium->execute_script("return \$('#CustomerInfo .Content').text();"),
            "none",
            "Customer info sidebar is not empty in the AgentTicketCustomer screen",
        );
        $Self->True(
            $Selenium->execute_script("return \$('.OverviewBox').length;"),
            "Customer History table is found in the AgentTicketCustomer screen",
        );

        # Clear input 'CustomerAutoComplete' field and click outside of it.
        $Selenium->find_element( "#CustomerAutoComplete", 'css' )->clear();
        $Selenium->find_element( "#CustomerID",           'css' )->send_keys("\N{U+E007}");

        # Check customer info sidebar and customer history table.
        $Self->Is(
            $Selenium->execute_script("return \$('#CustomerInfo .Content').text();"),
            "none",
            "Customer info sidebar is empty in the AgentTicketCustomer screen",
        );
        $Self->False(
            $Selenium->execute_script("return \$('.OverviewBox').length;"),
            "Customer History table is not found in the AgentTicketCustomer screen",
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Success;

        # Delete test created tickets.
        for my $TicketID (@TicketIDs) {
            $Success = $TicketObject->TicketDelete(
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
                "Ticket $TicketID is deleted"
            );
        }

        # Delete test created customer users.
        for my $CustomerUserLogin (@CustomerUserLogins) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE login = ?",
                Bind => [ \$CustomerUserLogin ],
            );
            $Self->True(
                $Success,
                "CustomerUser $CustomerUserLogin is deleted",
            );
        }

        # Delete test created customer companies.
        for my $CustomerCompanyID (@CustomerCompanyIDs) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
                Bind => [ \$CustomerCompanyID ],
            );
            $Self->True(
                $Success,
                "CustomerCompanyID $CustomerCompanyID is deleted",
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

    }
);

1;
