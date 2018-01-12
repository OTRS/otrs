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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # disable check email address
        $Helper->ConfigSettingChange(
            Valid => 1,
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

        # get customer company object
        my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');

        # also create a CustomerCompany so that it can be selected in the dropdown
        my $RandomID        = 'TestCustomer' . $Helper->GetRandomID();
        my $CustomerCompany = $CustomerCompanyObject->CustomerCompanyAdd(
            CustomerID             => $RandomID,
            CustomerCompanyName    => $RandomID,
            CustomerCompanyStreet  => $RandomID,
            CustomerCompanyZIP     => $RandomID,
            CustomerCompanyCity    => $RandomID,
            CustomerCompanyCountry => 'Germany',
            CustomerCompanyURL     => 'http://www.otrs.com',
            CustomerCompanyComment => $RandomID,
            ValidID                => 1,
            UserID                 => 1,
        );
        $Self->True(
            $CustomerCompany,
            "CustomerCompanyAdd - $CustomerCompany",
        );

        # Also create a CustomerCompany so that it can be selected in the dropdown
        my $RandomID2        = 'TestCustomer' . $Helper->GetRandomID();
        my $CustomerCompany2 = $CustomerCompanyObject->CustomerCompanyAdd(
            CustomerID             => $RandomID2,
            CustomerCompanyName    => $RandomID2,
            CustomerCompanyStreet  => $RandomID2,
            CustomerCompanyZIP     => $RandomID2,
            CustomerCompanyCity    => $RandomID2,
            CustomerCompanyCountry => 'Germany',
            CustomerCompanyURL     => 'http://www.otrs.com',
            CustomerCompanyComment => $RandomID2,
            ValidID                => 1,
            UserID                 => 1,
        );
        $Self->True(
            $CustomerCompany2,
            "CustomerCompanyAdd - $CustomerCompany2",
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminCustomerUser screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminCustomerUser");

        # check overview AdminCustomerCompany
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );
        $Selenium->find_element( "#Source",           'css' );
        $Selenium->find_element( "#Search",           'css' );

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # click 'Add customer'
        $Selenium->find_element( "button.CallForAction", 'css' )->VerifiedClick();

        # check add customer user screen
        for my $ID (
            qw(UserFirstname UserLastname UserLogin UserEmail UserCustomerID ValidID)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check breadcrumb on Add screen
        my $Count = 1;
        my $IsLinkedBreadcrumbText;
        for my $BreadcrumbText ( 'Customer User Management', 'Add Customer User' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # check client side validation
        $Selenium->find_element( "#UserFirstname", 'css' )->clear();
        $Selenium->find_element( "#Submit",        'css' )->VerifiedClick();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#UserFirstname').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # navigate to AdminCustomerUser screen again
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminCustomerUser");

        # click 'Add customer'
        $Selenium->find_element( "button.CallForAction", 'css' )->VerifiedClick();

        # create a real test customer user
        $Selenium->find_element( "#UserFirstname", 'css' )->send_keys($RandomID);
        $Selenium->find_element( "#UserLastname",  'css' )->send_keys($RandomID);
        $Selenium->find_element( "#UserLogin",     'css' )->send_keys($RandomID);
        $Selenium->find_element( "#UserEmail",     'css' )->send_keys( $RandomID . "\@localhost.com" );
        $Selenium->execute_script(
            "\$('#UserCustomerID').val('$RandomID').trigger('redraw.InputField').trigger('change');"
        );

        # Change one preference entry, to check if preferences fields exists on the page.
        $Selenium->execute_script(
            "\$('#UserTimeZone').val('Europe/Berlin').trigger('redraw.InputField').trigger('change');"
        );

        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # check overview page
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID found on page",
        );

        #check is there notification after customer user is added
        my $Notification = "Customer $RandomID added ( New phone ticket - New email ticket )!";
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # Create another test customer user for filter search test (with CustomerID as a auto complete field).
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'AdminCustomerUser::UseAutoComplete',
            Value => 1,
        );

        $Selenium->find_element( "button.CallForAction", 'css' )->VerifiedClick();

        # Check add customer screen if auto complete is activated
        my $AutoCompleteElement = $Selenium->find_element( '.CustomerAutoCompleteSimple', 'css' );
        $AutoCompleteElement->is_enabled();
        $AutoCompleteElement->is_displayed();

        $Selenium->find_element( "#UserFirstname", 'css' )->send_keys($RandomID2);
        $Selenium->find_element( "#UserLastname",  'css' )->send_keys($RandomID2);
        $Selenium->find_element( "#UserLogin",     'css' )->send_keys($RandomID2);
        $Selenium->find_element( "#UserEmail",     'css' )->send_keys( $RandomID2 . "\@localhost.com" );

        # Try to add a not existing CustomerID
        $Selenium->find_element( "#UserCustomerID", 'css' )->send_keys( $RandomID2 . '-wrong' );
        $Selenium->find_element( "#Submit",         'css' )->VerifiedClick();

        # Confirm JS error.
        $Selenium->find_element( "#DialogButton1", 'css' )->click();

        $Selenium->find_element( "#UserCustomerID", 'css' )->clear();
        $Selenium->find_element( "#UserCustomerID", 'css' )->send_keys($RandomID2);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($RandomID2)').click()");

        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'AdminCustomerUser::UseAutoComplete',
            Value => 0,
        );

        # test search filter only for test Customer users
        $Selenium->find_element( "#Search",           'css' )->clear();
        $Selenium->find_element( "#Search",           'css' )->send_keys('TestCustomer');
        $Selenium->find_element( ".SearchBox button", 'css' )->VerifiedClick();

        # check for another customer user
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID2 ) > -1,
            "$RandomID2 found on page",
        );

        # test search filter by customer user $RandomID
        $Selenium->find_element( "#Search",           'css' )->clear();
        $Selenium->find_element( "#Search",           'css' )->send_keys($RandomID);
        $Selenium->find_element( ".SearchBox button", 'css' )->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID found on page",
        );

        $Self->False(
            index( $Selenium->get_page_source(), $RandomID2 ) > -1,
            "$RandomID2 not found on page",
        );

        # check and edit new customer user
        $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#UserFirstname', 'css' )->get_value(),
            $RandomID,
            "#UserFirstname updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserLastname', 'css' )->get_value(),
            $RandomID,
            "#UserLastname updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserLogin', 'css' )->get_value(),
            $RandomID,
            "#UserLogin updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserEmail', 'css' )->get_value(),
            "$RandomID\@localhost.com",
            "#UserLastname updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserCustomerID', 'css' )->get_value(),
            $RandomID,
            "#UserCustomerID updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserTimeZone', 'css' )->get_value(),
            'Europe/Berlin',
            "#UserTimeZone updated value",
        );

        # check breadcrumb on Edit screen
        $Count = 1;
        for my $BreadcrumbText ( 'Customer User Management', 'Edit Customer User: ' . $RandomID ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # set test customer user to invalid
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # check is there notification after customer user is updated
        $Notification = "Customer user updated!";
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # test search filter
        $Selenium->find_element( "#Search",           'css' )->clear();
        $Selenium->find_element( "#Search",           'css' )->send_keys($RandomID);
        $Selenium->find_element( ".SearchBox button", 'css' )->VerifiedClick();

        # check class of invalid customer user in the overview table
        $Self->True(
            $Selenium->find_element( "tr.Invalid", 'css' ),
            "There is a class 'Invalid' for test Customer User",
        );

        # navigate to AgentTicketPhone
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        # click on '[ Customer User ]' to test customer user creation from iframe
        $Selenium->find_element( "#OptionCustomer", 'css' )->click();
        $Selenium->switch_to_frame( $Selenium->find_element( '.TextOption', 'css' ) );

        # FIXME: Hard sleep is needed here too because in some browser versions the following check for page load
        #   complete will query the main page instead of the IFRAME. Find a more performant solution!
        sleep 5;

        # Wait until the frame has loaded, before continuing.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

        # Click on 'Add customer user' button.
        $Selenium->find_element("//button[\@class='CallForAction Fullsize Center']")->VerifiedClick();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#UserFirstname").length' );

        # create new test customer user
        my $RandomID3 = 'TestCustomer' . $Helper->GetRandomID();
        my $UserEmail = $RandomID3 . "\@localhost.com";
        $Selenium->find_element( "#UserFirstname", 'css' )->send_keys($RandomID3);
        $Selenium->find_element( "#UserLastname",  'css' )->send_keys($RandomID3);
        $Selenium->find_element( "#UserLogin",     'css' )->send_keys($RandomID3);
        $Selenium->find_element( "#UserEmail",     'css' )->send_keys( $RandomID3 . "\@localhost.com" );
        $Selenium->execute_script(
            "\$('#UserCustomerID').val('$RandomID').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->execute_script("\$('#Submit').click();");

        # return focus back on AgentTicketPhone window
        $Selenium->switch_to_frame();

        # verify created customer user is added directly in AgentTicketPhone form
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#CustomerID").val().length' );
        $Self->Is(
            $Selenium->find_element( "#CustomerID", 'css' )->get_value(),
            $RandomID,
            "Test customer user $RandomID3 is successfully created from AgentTicketPhone screen"
        );

        # verify created customer user is added directly in AgentTicketPhone form
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#CustomerID").val().length' );
        $Self->Is(
            $Selenium->find_element( "#CustomerID", 'css' )->get_value(),
            $RandomID,
            "Test customer user $RandomID3 is successfully created from AgentTicketPhone screen"
        );

        # Change the CustomerID for one CustomerUser directly to non existing CustomerID,
        #   to check if the CustomerUser can be changed.
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
        my %CustomerUserData   = $CustomerUserObject->CustomerUserDataGet(
            User => $RandomID2,
        );

        $CustomerUserObject->CustomerUserUpdate(
            %CustomerUserData,
            UserCustomerID => $RandomID2 . '-not-existing',
            ID             => $RandomID2,
            UserID         => 1,
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminCustomerUser;Subaction=Change;ID=$RandomID2");

        $Self->Is(
            $Selenium->find_element( '#UserCustomerID', 'css' )->get_value(),
            $RandomID2 . '-not-existing',
            "#UserCustomerID updated value",
        );

        $Selenium->find_element( "#UserFirstname", 'css' )->send_keys('-edit');
        $Selenium->find_element( "#UserLastname",  'css' )->send_keys('-edit');
        $Selenium->find_element( "#Submit",        'css' )->VerifiedClick();

        # test search filter only for test Customer users
        $Selenium->find_element( "#Search",           'css' )->clear();
        $Selenium->find_element( "#Search",           'css' )->send_keys($RandomID2);
        $Selenium->find_element( ".SearchBox button", 'css' )->VerifiedClick();

        # check for another customer user
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID2 ) > -1,
            "$RandomID2 found on page",
        );

        $Selenium->find_element( $RandomID2, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#UserFirstname', 'css' )->get_value(),
            $RandomID2 . '-edit',
            "#UserFirstname updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserLastname', 'css' )->get_value(),
            $RandomID2 . '-edit',
            "#UserLastname updated value",
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # delete created test customer user and customer company
        for my $ID ( $RandomID, $RandomID2, $RandomID3 ) {
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE login = ?",
                Bind => [ \$ID ],
            );
            $Self->True(
                $Success,
                "Deleted Customers - $ID",
            );

            $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
                Bind => [ \$ID ],
            );
            $Self->True(
                $Success,
                "Deleted CustomerUser - $ID",
            );
        }

        # make sure the cache is correct
        for my $Cache (qw(CustomerCompany CustomerUser CustomerUser_CustomerSearch)) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }

);

1;
