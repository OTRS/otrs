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

        my $Helper                = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');

        # Disable check email address.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckEmailAddresses',
            Value => 0
        );

        # Also create a CustomerCompany so that it can be selected in the dropdown.
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

        # Also create a CustomerCompany so that it can be selected in the dropdown.
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

        # Navigate to AdminCustomerUser screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminCustomerUser");

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

        # Click 'Add customer'.
        $Selenium->find_element( "button.CallForAction", 'css' )->VerifiedClick();

        # Check add customer user screen.
        for my $ID (
            qw(UserFirstname UserLastname UserLogin UserEmail UserCustomerID ValidID)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check breadcrumb on Add screen.
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

        # Check client side validation.
        $Selenium->find_element( "#UserFirstname", 'css' )->clear();
        $Selenium->find_element( "#Submit",        'css' )->click();
        $Selenium->WaitFor( JavaScript => "return \$('#UserFirstname.Error').length" );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#UserFirstname').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Navigate to AdminCustomerUser screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminCustomerUser");

        # Click 'Add customer'.
        $Selenium->find_element( "button.CallForAction", 'css' )->VerifiedClick();

        # Create a real test customer user.
        $Selenium->find_element( "#UserFirstname", 'css' )->send_keys($RandomID);
        $Selenium->find_element( "#UserLastname",  'css' )->send_keys($RandomID);
        $Selenium->find_element( "#UserLogin",     'css' )->send_keys($RandomID);
        $Selenium->find_element( "#UserEmail",     'css' )->send_keys( $RandomID . "\@localhost.com" );
        $Selenium->InputFieldValueSet(
            Element => '#UserCustomerID',
            Value   => $RandomID,
        );

        # Change one preference entry, to check if preferences fields exists on the page.
        $Selenium->InputFieldValueSet(
            Element => '#UserTimeZone',
            Value   => 'Europe/Berlin',
        );

        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check overview page.
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID found on page",
        );

        # Check is there notification after customer user is added.
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

        # Check add customer screen if auto complete is activated.
        my $AutoCompleteElement = $Selenium->find_element( '.CustomerAutoCompleteSimple', 'css' );
        $AutoCompleteElement->is_enabled();
        $AutoCompleteElement->is_displayed();

        $Selenium->find_element( "#UserFirstname", 'css' )->send_keys($RandomID2);
        $Selenium->find_element( "#UserLastname",  'css' )->send_keys($RandomID2);
        $Selenium->find_element( "#UserLogin",     'css' )->send_keys($RandomID2);
        $Selenium->find_element( "#UserEmail",     'css' )->send_keys( $RandomID2 . "\@localhost.com" );

        # Try to add a not existing CustomerID.
        $Selenium->find_element( "#UserCustomerID", 'css' )->send_keys( $RandomID2 . '-wrong' );
        $Selenium->find_element( "#Submit",         'css' )->click();
        $Selenium->WaitFor( JavaScript => "return \$('.Dialog.Modal #DialogButton1').length" );

        # Confirm JS error.
        $Selenium->find_element( "#DialogButton1", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return !\$('.Dialog.Modal').length" );

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

        # Test search filter only for test Customer users.
        $Selenium->find_element( "#Search",           'css' )->clear();
        $Selenium->find_element( "#Search",           'css' )->send_keys('TestCustomer');
        $Selenium->find_element( ".SearchBox button", 'css' )->VerifiedClick();

        # Check for another customer user.
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID2 ) > -1,
            "$RandomID2 found on page",
        );

        # Test search filter by customer user $RandomID.
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

        # Check and edit new customer user.
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

        # Check breadcrumb on Edit screen.
        $Count = 1;
        for my $BreadcrumbText ( 'Customer User Management', 'Edit Customer User: ' . $RandomID ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Set test customer user to invalid.
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check is there notification after customer user is updated.
        $Notification = "Customer user updated!";
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # Test search filter.
        $Selenium->find_element( "#Search",           'css' )->clear();
        $Selenium->find_element( "#Search",           'css' )->send_keys($RandomID);
        $Selenium->find_element( ".SearchBox button", 'css' )->VerifiedClick();

        # Check class of invalid customer user in the overview table.
        $Self->True(
            $Selenium->find_element( "tr.Invalid", 'css' ),
            "There is a class 'Invalid' for test Customer User",
        );

        # Navigate to AgentTicketPhone.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        # Click on '[ Customer User ]' to test customer user creation from iframe.
        $Selenium->find_element( "#OptionCustomer", 'css' )->click();
        $Selenium->SwitchToFrame(
            FrameSelector => '.TextOption',
            WaitForLoad   => 1,
        );

        # Click on 'Add customer user' button.
        $Selenium->find_element("//button[\@class='CallForAction Fullsize Center']")->VerifiedClick();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#UserFirstname").length' );

        # Create new test customer user.
        my $RandomID3 = 'TestCustomer' . $Helper->GetRandomID();
        my $UserEmail = $RandomID3 . "\@localhost.com";
        $Selenium->find_element( "#UserFirstname", 'css' )->send_keys($RandomID3);
        $Selenium->find_element( "#UserLastname",  'css' )->send_keys($RandomID3);
        $Selenium->find_element( "#UserLogin",     'css' )->send_keys($RandomID3);
        $Selenium->find_element( "#UserEmail",     'css' )->send_keys( $RandomID3 . "\@localhost.com" );
        $Selenium->InputFieldValueSet(
            Element => '#UserCustomerID',
            Value   => $RandomID,
        );
        $Selenium->execute_script("\$('#Submit').click();");

        # Return focus back on AgentTicketPhone window.
        $Selenium->switch_to_frame();

        # Verify created customer user is added directly in AgentTicketPhone form.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#CustomerID").val().length' );
        $Self->Is(
            $Selenium->find_element( "#CustomerID", 'css' )->get_value(),
            $RandomID,
            "Test customer user $RandomID3 is successfully created from AgentTicketPhone screen"
        );

        # Verify created customer user is added directly in AgentTicketPhone form.
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

        # Test search filter only for test Customer users.
        $Selenium->find_element( "#Search",           'css' )->clear();
        $Selenium->find_element( "#Search",           'css' )->send_keys($RandomID2);
        $Selenium->find_element( ".SearchBox button", 'css' )->VerifiedClick();

        # Check for another customer user.
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

        # Create a test case for bug#13782 (https://bugs.otrs.org/show_bug.cgi?id=13782).
        # Creating CustomerUser with according DynamicField when AutoLoginCreation is enabled.
        my $RandomID4          = $Helper->GetRandomID();
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $DynamicFieldName   = 'Text' . $RandomID4;
        my $DynamicFieldID     = $DynamicFieldObject->DynamicFieldAdd(
            Name       => $DynamicFieldName,
            Label      => $DynamicFieldName,
            FieldOrder => 9990,
            FieldType  => 'Text',
            ObjectType => 'CustomerUser',
            Config     => {
                DefaultValue => '',
                Link         => '',
            },
            Reorder => 1,
            ValidID => 1,
            UserID  => 1,
        );

        # Get CustomerUser map, enable AutoLoginCreation, AutoLoginCreationPrefix and set created
        #   DynamicField in the CustomerUser map.
        my $CustomerUserConfig = $ConfigObject->Get('CustomerUser');
        $CustomerUserConfig->{AutoLoginCreation}       = 1;
        $CustomerUserConfig->{AutoLoginCreationPrefix} = 'auto';
        push @{ $CustomerUserConfig->{Map} }, [
            'DynamicField_' . $DynamicFieldName, undef, $DynamicFieldName, 0, 0, 'dynamic_field',
            undef, 0,
        ];

        $Helper->ConfigSettingChange(
            Key   => 'CustomerUser',
            Value => $CustomerUserConfig,
        );

        # Navigate to AdminCustomerUser screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminCustomerUser");

        # Click to 'Add Customer User'.
        $Selenium->find_element( "button.CallForAction", 'css' )->VerifiedClick();

        # Create Customer User with AutoLoginCreation and Customer User DynamicField.
        $Selenium->find_element( "#UserFirstname", 'css' )->send_keys($RandomID4);
        $Selenium->find_element( "#UserLastname",  'css' )->send_keys($RandomID4);
        $Selenium->find_element( "#UserEmail",     'css' )->send_keys( $RandomID4 . "\@localhost.com" );
        $Selenium->InputFieldValueSet(
            Element => '#UserCustomerID',
            Value   => $RandomID,
        );

        my $DynamicFieldValue = 'DF' . $RandomID4;
        $Selenium->find_element( "#DynamicField_$DynamicFieldName", 'css' )->send_keys($DynamicFieldValue);
        $Selenium->execute_script(
            "\$('#Submit')[0].scrollIntoView(true);",
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Verify there was no error when creating Customer User with AutoLoginCreation and DynamicField.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.Notice p:contains(\"Unable to set value for dynamic field $DynamicFieldName!\")').length;"
            ),
            0,
            'There is no error when creating CustomerUser with DunyamicField and enabled AutoLoginCreation.',
        ) || die;

        # Search by latest created Customer User.
        $Selenium->find_element( "#Search",           'css' )->clear();
        $Selenium->find_element( "#Search",           'css' )->send_keys($RandomID4);
        $Selenium->find_element( ".SearchBox button", 'css' )->VerifiedClick();

        # Click on latest created Customer User and verify DynamicField value.
        $Selenium->find_element("//a[contains(\@href, \'Search=$RandomID4' )]")->VerifiedClick();
        $Self->Is(
            $Selenium->find_element( "#DynamicField_$DynamicFieldName", 'css' )->get_value(),
            $DynamicFieldValue,
            "CustomerUser DynamicField value, AutoLoginCreation enabled correct"
        );

        # Edit DynamicField value.
        $Selenium->find_element( "#DynamicField_$DynamicFieldName", 'css' )->send_keys('-edit');
        $Selenium->execute_script(
            "\$('#Submit')[0].scrollIntoView(true);",
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Search by latest created Customer User.
        $Selenium->find_element( "#Search",           'css' )->clear();
        $Selenium->find_element( "#Search",           'css' )->send_keys($RandomID4);
        $Selenium->find_element( ".SearchBox button", 'css' )->VerifiedClick();

        # Click on latest created Customer User and verify edited DynamicField value.
        $DynamicFieldValue = $DynamicFieldValue . '-edit';
        $Selenium->find_element("//a[contains(\@href, \'Search=$RandomID4' )]")->VerifiedClick();
        $Self->Is(
            $Selenium->find_element( "#DynamicField_$DynamicFieldName", 'css' )->get_value(),
            $DynamicFieldValue,
            "CustomerUser edited DynamicField value, AutoLoginCreation enabled correct"
        );

        # Delete CustomerUser which is created with AutoLoginCreation.
        my $DBObject         = $Kernel::OM->Get('Kernel::System::DB');
        my $FirstNameQueoted = $DBObject->Quote($RandomID4);
        $DBObject->Prepare(
            SQL  => "SELECT login FROM customer_user WHERE first_name = ?",
            Bind => [ \$FirstNameQueoted ]
        );
        my $CustomerUserLogin;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $CustomerUserLogin = $Row[0];
        }

        my $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$CustomerUserLogin ],
        );
        $Self->True(
            $Success,
            "CustomerUser $CustomerUserLogin created with AutoLoginCreation is deleted.",
        );

        # Delete created test CustomerUsers and CustomerCompanies.
        for my $ID ( $RandomID, $RandomID2, $RandomID3 ) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE login = ?",
                Bind => [ \$ID ],
            );
            $Self->True(
                $Success,
                "CustomerUser $ID is deleted.",
            );

            $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
                Bind => [ \$ID ],
            );
            $Self->True(
                $Success,
                "CustomerCompany $ID is deleted.",
            );
        }

        # Delete relation CustomerUser and DynamicField from 'dynamic_field_obj_id_name' table.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM dynamic_field_obj_id_name WHERE object_name = ?",
            Bind => [ \$CustomerUserLogin ],
        );
        $Self->True(
            $Success,
            "CustomerUser - DynamicField relation is deleted.",
        );

        # Delete created DynamicField.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM dynamic_field_value WHERE value_text = ?",
            Bind => [ \$DynamicFieldValue ],
        );
        $Success = $DynamicFieldObject->DynamicFieldDelete(
            ID     => $DynamicFieldID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "DynamicField ID $DynamicFieldID is deleted.",
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw(CustomerCompany CustomerUser CustomerUser_CustomerSearch)) {
            $CacheObject->CleanUp(
                Type => $Cache,
            );
        }
    }

);

1;
