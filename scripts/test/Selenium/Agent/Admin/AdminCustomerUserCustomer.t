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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # disable check email address
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => 'CheckEmailAddresses',
            Value => 0
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # create test CustomerUser
        my $CustomerUserName = "CustomerUser" . $Helper->GetRandomID();
        my $CustomerUserID   = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            UserFirstname  => $CustomerUserName,
            UserLastname   => $CustomerUserName,
            UserCustomerID => $CustomerUserName,
            UserLogin      => $CustomerUserName,
            UserEmail      => $CustomerUserName . '@localhost.com',
            ValidID        => 1,
            UserID         => 1,
        );
        $Self->True(
            $CustomerUserID,
            "CustomerUserAdd - $CustomerUserID",
        );

        # create test Customer
        my $CustomerName = 'Customer' . $Helper->GetRandomID();
        my $CustomerID   = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
            CustomerID          => $CustomerName,
            CustomerCompanyName => $CustomerName,
            ValidID             => 1,
            UserID              => 1,
        );
        $Self->True(
            $CustomerID,
            "CustomerCompanyAdd - $CustomerID",
        );

        # navigate AdminCustomerUserCustomer screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminCustomerUserCustomer");

        # check overview AdminCustomerUserCustomer
        $Selenium->find_element( "#Search",        'css' );
        $Selenium->find_element( "#CustomerUsers", 'css' );
        $Selenium->find_element( "#Customers",     'css' );

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # test search filter for CustomerUser
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($CustomerUserName);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();
        $Self->True(
            index( $Selenium->get_page_source(), $CustomerUserName ) > -1,
            "CustomerUser $CustomerUserName found on page",
        );

        # test search filter for Customer
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($CustomerName);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();
        $Self->True(
            index( $Selenium->get_page_source(), $CustomerName ) > -1,
            "Customer $CustomerName found on page",
        );

        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();

        # assign test customer to test customer user
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminCustomerUserCustomer;Subaction=CustomerUser;ID=$CustomerUserName"
        );

        $Selenium->find_element("//input[\@value='$CustomerID']")->click();
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # check test customer user assignment to test customer
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminCustomerUserCustomer;Subaction=Customer;ID=$CustomerID"
        );

        $Self->Is(
            $Selenium->find_element("//input[\@value=\"$CustomerUserID\"]")->is_selected(),
            1,
            "Customer $CustomerName is active for CustomerUser $CustomerUserName",
        );

        # check breadcrumb on change screen
        my $Count = 1;
        my $IsLinkedBreadcrumbText;
        for my $BreadcrumbText (
            'Manage Customer User-Customer Relations',
            'Change Customer User Relations for Customer \'' . $CustomerID . '\''
            )
        {
            $Self->Is(
                $Selenium->execute_script("return \$(\$('.BreadCrumb li')[$Count]).text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # remove test customer user assignment from test customer
        $Selenium->find_element("//input[\@value=\"$CustomerUserName\"]")->click();
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # check if there is any test customer assignment to test customer user
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminCustomerUserCustomer;Subaction=CustomerUser;ID=$CustomerUserID"
        );

        $Self->Is(
            $Selenium->find_element("//input[\@value='$CustomerID']")->is_selected(),
            0,
            "Customer $CustomerName is not active for CustomerUser $CustomerUserName",
        );

        # Check if Customer user has customer relation information in search result screen. See bug#14760.
        # navigate AdminCustomerUserCustomer screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminCustomerUserCustomer");

        # Search for customer user.
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($CustomerUserName);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();

        $Selenium->find_element(
            "//ul[contains(\@id, \'CustomerUsers')]//li//a[contains(\@href, \'ID=$CustomerUserName' )]"
        )->VerifiedClick();

        # Check if customer is displayed after customer user search.
        $Self->Is(
            $Selenium->execute_script("return \$('a[href*=\"$CustomerName\"]').length"),
            "1",
            "Customer is displayed correctly"
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminCustomerUserCustomer");

        # Search for customer.
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($CustomerName);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();

        $Selenium->find_element("//ul[contains(\@id, \'Customers')]//li//a[contains(\@href, \'ID=$CustomerName' )]")
            ->VerifiedClick();

        # Check if customer user is displayed after customer search.
        $Self->Is(
            $Selenium->execute_script("return \$('a[href*=\"$CustomerUserName\"]').length"),
            "1",
            "Customer user is displayed correctly"
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # delete created test entities
        if ($CustomerID) {
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
                Bind => [ \$CustomerID ],
            );
            $Self->True(
                $Success,
                "Deleted Customer - $CustomerName",
            );
        }

        if ($CustomerUserID) {
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE login = ?",
                Bind => [ \$CustomerUserID ],
            );
            $Self->True(
                $Success,
                "Deleted CustomerUser - $CustomerUserName",
            );
        }

        # make sure the cache is correct.
        for my $Cache (qw(CustomerUser CustomerCompany)) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    },
);

1;
