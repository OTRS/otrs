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

        # disable check email addresses
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # create test customer user
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # get test customer user ID
        my @CustomerIDs = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerIDs(
            User => $TestCustomerUserLogin,
        );
        my $CustomerID            = $CustomerIDs[0];
        my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
        my $CustomerUserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');

        my $RandomID    = $Helper->GetRandomID();
        my $CompanyRand = 'Customer-Company' . $RandomID;

        my $CustomersID = $CustomerCompanyObject->CustomerCompanyAdd(
            CustomerID             => $CompanyRand,
            CustomerCompanyName    => $CompanyRand . ' Inc',
            CustomerCompanyStreet  => 'Some Street',
            CustomerCompanyZIP     => '12345',
            CustomerCompanyCity    => 'Some city',
            CustomerCompanyCountry => 'USA',
            CustomerCompanyURL     => 'http://example.com',
            CustomerCompanyComment => 'some comment',
            ValidID                => 1,
            UserID                 => 1,
        );

        $Self->True(
            $CustomerID,
            "CustomerCompanyAdd() - $CustomerID",
        );

        my @CustomerUserIDs;
        my @UserEmails;
        for my $Key ( 1 .. 5 ) {
            my $UserEmail = 'unittest-' . $Key . $RandomID . '-Email@example.com';

            my $CustomerUserID = $CustomerUserObject->CustomerUserAdd(
                Source         => 'CustomerUser',
                UserFirstname  => 'Firstname' . $Key,
                UserLastname   => 'Lastname' . $Key,
                UserCustomerID => $CustomerID,
                UserLogin      => $RandomID . 'CustomerUser' . $Key,
                UserEmail      => $UserEmail,
                UserPassword   => 'some_pass',
                ValidID        => 1,
                UserID         => 1,
            );

            $Self->True(
                $CustomerUserID,
                "CustomerUserAdd() - $CustomerUserID",
            );

            push @CustomerUserIDs, $CustomerUserID;
            push @UserEmails,      $UserEmail;

        }

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test data parameters
        my %TicketData = (
            'Open' => {
                TicketState   => 'open',
                TicketCount   => '',
                TicketNumbers => [],
                TicketIDs     => [],
                TicketLink    => 'Open',
            },
            'Closed' => {
                TicketState   => 'closed successful',
                TicketCount   => '',
                TicketNumbers => [],
                TicketIDs     => [],
                TicketLink    => 'Closed',
            },
        );

        # create open and closed tickets
        for my $TicketCreate ( sort keys %TicketData ) {
            for my $TestTickets ( 1 .. 5 ) {
                my $TicketNumber = $TicketObject->TicketCreateNumber();
                my $TicketID     = $TicketObject->TicketCreate(
                    TN           => $TicketNumber,
                    Title        => 'Selenium Test Ticket',
                    Queue        => 'Raw',
                    Lock         => 'unlock',
                    Priority     => '3 normal',
                    State        => $TicketData{$TicketCreate}->{TicketState},
                    CustomerID   => $CustomerID,
                    CustomerUser => $TestCustomerUserLogin,
                    OwnerID      => $TestUserID,
                    UserID       => $TestUserID,
                );
                $Self->True(
                    $TicketID,
                    "$TicketCreate - ticket TicketID $TicketID - created - TN $TicketNumber",
                );
                push @{ $TicketData{$TicketCreate}->{TicketIDs} },     $TicketID;
                push @{ $TicketData{$TicketCreate}->{TicketNumbers} }, $TicketNumber;
            }
            my $TicketCount = $TicketObject->TicketSearch(
                Result     => 'Count',
                StateType  => $TicketCreate,
                CustomerID => $CustomerID,
                UserID     => $TestUserID,
            );
            $TicketData{$TicketCreate}->{TicketCount} = $TicketCount;
        }

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminCustomerInformationCenter screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentCustomerInformationCenter");
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#AgentCustomerInformationCenterSearchCustomerID").length'
        );

        # input search parameters for CustomerUser
        $Selenium->find_element( "#AgentCustomerInformationCenterSearchCustomerUser", 'css' )
            ->send_keys( $RandomID . 'CustomerUser' . '*' );

        $Selenium->WaitFor( JavaScript => "return \$('.ui-menu:eq(1) li').length > 0;" );

        $Self->Is(
            $Selenium->execute_script("return \$('.ui-menu:eq(1) li').length;"), 5,
            'Check result of customer user search.',
        );
        $Selenium->find_element( "#AgentCustomerInformationCenterSearchCustomerUser", 'css' )->clear();

        # input search parameters CustomerID
        $Selenium->find_element( "#AgentCustomerInformationCenterSearchCustomerID", 'css' )
            ->send_keys($TestCustomerUserLogin);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCustomerUserLogin)').click()");

        # check customer information center page
        $Self->True(
            index( $Selenium->get_page_source(), "Customer Information Center" ) > -1,
            "Found looked value on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Customer Users" ) > -1,
            "Customer Users widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Reminder Tickets" ) > -1,
            "Reminder Tickets widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Escalated Tickets" ) > -1,
            "Escalated Tickets widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Open Tickets / Need to be answered" ) > -1,
            "Open Tickets / Need to be answered widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Settings" ) > -1,
            "Setting for toggle widgets found on page",
        );

        # check if there is link to CIC search modal dialog from heading (name of the company)
        $Self->True(
            $Selenium->find_element( "#CustomerInformationCenterHeading", 'css' ),
            'There is link to customer information center search modal dialog.',
        );

        # test links in Company Status widget
        for my $TestLinks ( sort keys %TicketData ) {

            # click on link
            $Selenium->find_element(
                "//a[contains(\@href, \'Subaction=Search;StateType=$TicketData{$TestLinks}->{TicketLink};CustomerIDRaw=$TestCustomerUserLogin' )]"
            )->VerifiedClick();

            # wait until page has loaded, if necessary
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

            # check for test ticket numbers on search screen
            for my $CheckTicketNumbers ( @{ $TicketData{$TestLinks}->{TicketNumbers} } ) {
                $Self->True(
                    index( $Selenium->get_page_source(), $CheckTicketNumbers ) > -1,
                    "TicketNumber $CheckTicketNumbers - found on screen"
                );
            }

            # click on 'Change search option'
            $Selenium->find_element(
                "//a[contains(\@href, \'AgentTicketSearch;Subaction=LoadProfile' )]"
            )->VerifiedClick();

            # wait until search dialog has been loaded
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#SearchFormSubmit").length' );

            # verify state search attributes are shown in search screen, see bug #10853
            $Selenium->find_element( "#StateIDs", 'css' );

            # open CIC again for the next test case
            $Selenium->VerifiedGet(
                "${ScriptAlias}index.pl?Action=AgentCustomerInformationCenter;CustomerID=$TestCustomerUserLogin"
            );

        }

        # Create new Email ticket.
        $Selenium->find_element(
            "//a[contains(\@href, \"Action=AgentTicketEmail;Subaction=StoreNew;ExpandCustomerName=2;CustomerUser=$CustomerUserIDs[0]\" )]"
        )->VerifiedClick();

        # Confirm I'm on New Email Ticket screen.
        $Self->True(
            index( $Selenium->get_page_source(), "Create New Email Ticket" ) > -1,
            "Found looked value on page",
        );

        # Select input field and type inside.
        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys( $CustomerUserIDs[0] );

        # Click on wanted element in dropdown menu.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($CustomerUserIDs[0])').click()");

        # Error is expected.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Dialog.Modal").length' );

        $Self->Is(
            $Selenium->execute_script('return $(".Dialog.Modal .Header h1").text().trim();'),
            'Duplicated entry',
            "Warning dialog for entry duplication is found",
        );

        # Close error message.
        $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

        # Go to previous.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentCustomerInformationCenter;CustomerID=$TestCustomerUserLogin"
        );

        # Create new Phone ticket.
        $Selenium->find_element(
            "//a[contains(\@href, \"AgentTicketPhone;Subaction=StoreNew;ExpandCustomerName=2;CustomerUser=$CustomerUserIDs[0]\" )]"
        )->VerifiedClick();

        # Confirm I'm on New Phone Ticket screen.
        $Self->True(
            index( $Selenium->get_page_source(), "Create New Phone Ticket" ) > -1,
            "Found looked value on page",
        );

        # Select input field and type inside.
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys( $CustomerUserIDs[0] );

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($CustomerUserIDs[0])').click()");

        # Error is expected.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Dialog.Modal").length' );

        $Self->Is(
            $Selenium->execute_script('return $(".Dialog.Modal .Header h1").text().trim();'),
            'Duplicated entry',
            "Warning dialog for entry duplication is found",
        );

        # delete created test tickets
        for my $TicketState ( sort keys %TicketData ) {
            for my $TicketID ( @{ $TicketData{$TicketState}->{TicketIDs} } ) {

                my $Success = $TicketObject->TicketDelete(
                    TicketID => $TicketID,
                    UserID   => $TestUserID,
                );

                $Self->True(
                    $Success,
                    "Delete ticket - $TicketID"
                );
            }
        }

        # delete created test customer user and customer company
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        for my $CustomerID (@CustomerUserIDs) {
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE login = ?",
                Bind => [ \$CustomerID ],
            );
            $Self->True(
                $Success,
                "Deleted Customers - $CustomerID",
            );
        }

        my $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
            Bind => [ \$CompanyRand ],
        );
        $Self->True(
            $Success,
            "Deleted CustomerUser - $CustomerID",
        );

        # make sure cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

1;
