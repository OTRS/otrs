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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper                = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
        my $CustomerUserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');

        # Disable email checks when create new customer user.
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

        my @CustomerCompanies;
        my @CustomerUsers;

        my $RandomID = $Helper->GetRandomID();

        # Create test customer companies, create customer user and ticket for each one.
        for my $Counter ( 1 .. 2 ) {

            my $CustomerCompanyID = $CustomerCompanyObject->CustomerCompanyAdd(
                CustomerID             => 'Company' . $Counter . $RandomID,
                CustomerCompanyName    => 'CompanyName' . $Counter . $RandomID,
                CustomerCompanyStreet  => 'CompanyStreet' . $RandomID,
                CustomerCompanyZIP     => $RandomID,
                CustomerCompanyCity    => 'Miami',
                CustomerCompanyCountry => 'USA',
                CustomerCompanyURL     => 'http://www.example.org',
                CustomerCompanyComment => 'comment',
                ValidID                => 1,
                UserID                 => 1,
            );
            $Self->True(
                $CustomerCompanyID,
                "CustomerCompanyID $CustomerCompanyID is created",
            );

            my %CustomerCompany = $CustomerCompanyObject->CustomerCompanyGet(
                CustomerID => $CustomerCompanyID,
            );
            push @CustomerCompanies, \%CustomerCompany;

            my $CustomerUserID = $CustomerUserObject->CustomerUserAdd(
                Source         => 'CustomerUser',
                UserFirstname  => 'Firstname' . $Counter . $RandomID,
                UserLastname   => 'Lastname' . $Counter . $RandomID,
                UserCustomerID => $CustomerCompanyID,
                UserLogin      => 'CustomerUser' . $Counter . $RandomID,
                UserEmail      => $Counter . $RandomID . '@example.com',
                UserPassword   => 'password',
                ValidID        => 1,
                UserID         => 1,
            );
            $Self->True(
                $CustomerUserID,
                "CustomerUserID $CustomerUserID is created",
            );

            my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
                User => $CustomerUserID,
            );
            push @CustomerUsers, \%CustomerUser;
        }

        # set customer user as a member of company
        $CustomerUserObject->CustomerUserCustomerMemberAdd(
            CustomerUserID => $CustomerUsers[0]->{UserLogin},
            CustomerID     => $CustomerCompanies[1]->{CustomerID},
            Active         => 1,
            UserID         => 1,
        );

        # get needed objects
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test data parameters
        my @TicketIDs;
        my @AssigendTicketNumbers;
        my @AccessibleTicketNumbers;

        my %CustomerTickets = (
            Assigend => [
                {
                    CustomerID   => $CustomerCompanies[0]->{CustomerID},
                    CustomerUser => $CustomerUsers[0]->{UserLogin},
                },
                {
                    CustomerID   => $CustomerCompanies[0]->{CustomerID},
                    CustomerUser => $CustomerUsers[0]->{UserLogin},
                },
                {
                    CustomerID   => $CustomerCompanies[0]->{CustomerID},
                    CustomerUser => $CustomerUsers[0]->{UserLogin},
                },
            ],
            Accessible => [
                {
                    CustomerID   => $CustomerCompanies[1]->{CustomerID},
                    CustomerUser => $CustomerUsers[0]->{UserLogin},
                },
                {
                    CustomerID   => $CustomerCompanies[0]->{CustomerID},
                    CustomerUser => $CustomerUsers[1]->{UserLogin},
                },
                {
                    CustomerID   => $CustomerCompanies[1]->{CustomerID},
                    CustomerUser => $CustomerUsers[1]->{UserLogin},
                },
            ],
        );

        # create open and closed tickets
        for my $PermissionType ( sort keys %CustomerTickets ) {
            for my $TicketData ( @{ $CustomerTickets{$PermissionType} } ) {
                my $TicketNumber = $TicketObject->TicketCreateNumber();
                my $TicketID     = $TicketObject->TicketCreate(
                    TN           => $TicketNumber,
                    Title        => 'Selenium Test Ticket',
                    Queue        => 'Raw',
                    Lock         => 'unlock',
                    Priority     => '3 normal',
                    State        => 'open',
                    %{ $TicketData },
                    OwnerID      => $TestUserID,
                    UserID       => $TestUserID,
                );
                $Self->True(
                    $TicketID,
                    "Ticket with TicketID $TicketID - created - TN $TicketNumber",
                );
                push @TicketIDs, $TicketID;
                push @AccessibleTicketNumbers, $TicketNumber;

                if ( $PermissionType eq 'Assigend') {
                    push @AssigendTicketNumbers, $TicketNumber;
                }
            }
        }

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminCustomerUserInformationCenter screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentCustomerUserInformationCenter");
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#AgentCustomerUserInformationCenterSearchCustomerUser").length'
        );

        $Selenium->find_element( "#AgentCustomerUserInformationCenterSearchCustomerUser", 'css' )->send_keys($CustomerUsers[0]->{UserLogin});
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->find_element("//*[text()='$CustomerUsers[0]->{UserMailString}']")->VerifiedClick();

        # Check customer user information center page.
        $Self->True(
            index( $Selenium->get_page_source(), "Customer User Information Center" ) > -1,
            "Found looked value on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Customer IDs" ) > -1,
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

        # Check if there is link to CIC search modal dialog from heading (name of the customer user).
        $Self->True(
            $Selenium->find_element( "#CustomerUserInformationCenterHeading", 'css' ),
            'There is link to customer user information center search modal dialog.',
        );

        # Check if the assigend ticket numbers are visible in the widget the site (default filter).
        for my $AssigendTicketNumber (@AssigendTicketNumbers) {
            $Self->True(
                index( $Selenium->get_page_source(), $AssigendTicketNumber ) > -1,
                "Assigned ticket $AssigendTicketNumber found in widget on page",
            );
        }


        $Selenium->find_element( "#DashboardAdditionalFilter0130-CUIC-TicketOpenAccessibleForCustomerUser", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$("#Dashboard0120-CUIC-TicketNew-box.Loading").length'
        );
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("li.AdditionalFilter.Selected #DashboardAdditionalFilter0130-CUIC-TicketOpenAccessibleForCustomerUser").length'
        );

        # Check if the assigend ticket numbers are visible in the widget the site (default filter).
        for my $AccessibleTicketNumber (@AccessibleTicketNumbers) {
            $Self->True(
                index( $Selenium->get_page_source(), $AccessibleTicketNumber ) > -1,
                "Accesible ticket $AccessibleTicketNumber found in widget on page",
            );
        }

        # Click on the customer ID link in the customer ID list (go to the AgentCustomerInformationCenter).
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentCustomerInformationCenter;CustomerID=$CustomerCompanies[1]->{CustomerID}' )]"
        )->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), "Customer Information Center" ) > -1,
            "Found title value on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $CustomerCompanies[1]->{CustomerID} ) > -1,
            "Found customer ID on page",
        );

        my $Success;

        # delete created test tickets
        for my $TicketID (@TicketIDs) {

            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );

            $Self->True(
                $Success,
                "Delete ticket - $TicketID"
            );
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete test created customer users.
        for my $CustomerUser (@CustomerUsers) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE customer_id = ?",
                Bind => [ \$CustomerUser->{UserID} ],
            );
            $Self->True(
                $Success,
                "CustomerUserID $CustomerUser->{UserID} is deleted",
            );
        }

        # Delete test created customer companies.
        for my $CustomerCompany (@CustomerCompanies) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
                Bind => [ \$CustomerCompany->{CustomerID} ],
            );
            $Self->True(
                $Success,
                "CustomerCompanyID $CustomerCompany->{CustomerID} is deleted",
            );
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct after the test is done.
        for my $Cache (qw(Ticket CustomerUser CustomerCompany)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
