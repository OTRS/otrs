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

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminCustomerCompany screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminCustomerCompany");

        # Check overview AdminCustomerCompany.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );
        $Selenium->find_element( "#Source",           'css' );
        $Selenium->find_element( "#Search",           'css' );

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Click 'Add customer' link.
        $Selenium->find_element( "button.CallForAction", 'css' )->VerifiedClick();

        # Check add customer screen.
        for my $ID (
            qw(CustomerID CustomerCompanyName CustomerCompanyComment ValidID)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check breadcrumb on Add screen.
        my $Count = 1;
        my $IsLinkedBreadcrumbText;
        for my $BreadcrumbText ( 'Customer Management', 'Add Customer' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Check client side validation.
        $Selenium->find_element( "#CustomerID", 'css' )->clear();
        $Selenium->find_element( "#Submit",     'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#CustomerID.Error').length"
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#CustomerID').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Create a real test customer company.
        my $RandomID = 'TestCustomerCompany' . $Helper->GetRandomID();
        $Selenium->find_element( "#CustomerID",          'css' )->send_keys($RandomID);
        $Selenium->find_element( "#CustomerCompanyName", 'css' )->send_keys($RandomID);
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 1,
        );
        $Selenium->find_element( "#CustomerCompanyComment", 'css' )->send_keys('Selenium test customer company');
        $Selenium->find_element( "#CustomerCompanyZIP",     'css' )->send_keys('0');
        $Selenium->find_element( "#Submit",                 'css' )->VerifiedClick();

        # Check overview page.
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID found on page",
        );

        # Check is there notification 'Customer company added!' after customer is added.
        my $Notification = 'Customer company added!';
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # Create another test customer company for filter search test.
        my $RandomID2 = 'TestCustomerCompany' . $Helper->GetRandomID();
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();
        $Selenium->find_element( "button.CallForAction", 'css' )->VerifiedClick();
        $Selenium->find_element( "#CustomerID",          'css' )->send_keys($RandomID2);
        $Selenium->find_element( "#CustomerCompanyName", 'css' )->send_keys($RandomID2);
        $Selenium->find_element( "#Submit",              'css' )->VerifiedClick();

        # Test search filter only for test Customer companies.
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys('TestCustomerCompany');
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # Check for another customer company.
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID2 ) > -1,
            "$RandomID2 found on page",
        );

        # Test search filter by test customers $RandomID.
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($RandomID);
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID found on page",
        );
        $Self->False(
            index( $Selenium->get_page_source(), $RandomID2 ) > -1,
            "$RandomID2 not found on page",
        );

        # Check and edit new customer company.
        my $LinkText = substr( $RandomID, 0, 17 ) . '...';
        $Selenium->find_element( $LinkText, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#CustomerID', 'css' )->get_value(),
            $RandomID,
            "#CustomerID updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#CustomerCompanyName', 'css' )->get_value(),
            $RandomID,
            "#CustomerCompanyName updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#CustomerCompanyZIP', 'css' )->get_value(),
            '0',
            "#CustomerCompanyComment updated value",
        );

        $Self->Is(
            $Selenium->find_element( '#CustomerCompanyComment', 'css' )->get_value(),
            'Selenium test customer company',
            "#CustomerCompanyComment updated value",
        );

        # Check breadcrumb on Edit screen.
        $Count = 1;
        for my $BreadcrumbText ( 'Customer Management', 'Edit Customer: ' . $RandomID ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Set test customer company to invalid and clear comment.
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element( "#CustomerCompanyComment", 'css' )->clear();
        $Selenium->find_element( "#Submit",                 'css' )->VerifiedClick();

        # Check is there notification 'Customer company updated!' after customer is updated.
        $Notification = 'Customer company updated!';
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # Test search filter.
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($RandomID);
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # Check class of invalid customer user in the overview table.
        $Self->True(
            $Selenium->find_element( "tr.Invalid", 'css' ),
            "There is a class 'Invalid' for test Customer Company",
        );

        # Delete created test customer companies.
        for my $CustomerID ( $RandomID, $RandomID2 ) {
            my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
                Bind => [ \$CustomerID ],
            );
            $Self->True(
                $Success,
                "Deleted CustomerCompany - $CustomerID",
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'CustomerCompany',
        );

    }
);

1;
