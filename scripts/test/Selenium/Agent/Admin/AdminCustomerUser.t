# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
my $Selenium     = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'CheckEmailAddresses',
            Value => 0
        );
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'CheckMXRecord',
            Value => 0
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $RandomID = 'TestCustomer' . $Helper->GetRandomID();

        # Also create a CustomerCompany so that it can be selected in the dropdown
        $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
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
        ) || die "Could not create test CustomerCompany";

        my $RandomID2 = 'TestCustomer' . $Helper->GetRandomID();

        # Also create a CustomerCompany so that it can be selected in the dropdown
        $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
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
        ) || die "Could not create test CustomerCompany";

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminCustomerUser");

        # check AdminCustomerCompany screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );
        $Selenium->find_element( "#Source",           'css' );
        $Selenium->find_element( "#Search",           'css' );

        # click 'Add customer user' link
        $Selenium->find_element( "button.CallForAction", 'css' )->click();

        # check add customer user screen
        for my $ID (
            qw(UserFirstname UserLastname UserLogin UserEmail UserCustomerID ValidID)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check client side validation
        $Selenium->find_element( "#UserFirstname", 'css' )->clear();
        $Selenium->find_element( "#UserFirstname", 'css' )->submit();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#UserFirstname').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # create a real test customer user
        $Selenium->find_element( "#UserFirstname", 'css' )->send_keys($RandomID);
        $Selenium->find_element( "#UserLastname",  'css' )->send_keys($RandomID);
        $Selenium->find_element( "#UserLogin",     'css' )->send_keys($RandomID);
        $Selenium->find_element( "#UserEmail",     'css' )->send_keys( $RandomID . "\@localhost.com" );
        $Selenium->execute_script("\$('#UserCustomerID').val('$RandomID').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#UserFirstname",                            'css' )->submit();

        # check overview page
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID found on page",
        );

        # create another test customer user for filter search test
        $Selenium->find_element( "button.CallForAction", 'css' )->click();
        $Selenium->find_element( "#UserFirstname",       'css' )->send_keys($RandomID2);
        $Selenium->find_element( "#UserLastname",        'css' )->send_keys($RandomID2);
        $Selenium->find_element( "#UserLogin",           'css' )->send_keys($RandomID2);
        $Selenium->find_element( "#UserEmail",           'css' )->send_keys( $RandomID2 . "\@localhost.com" );
        $Selenium->execute_script("\$('#UserCustomerID').val('$RandomID2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#UserFirstname",                             'css' )->submit();

        # test search filter only for test Customer users
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys('TestCustomer');
        $Selenium->find_element( "#Search", 'css' )->submit();

        # check for another customer user
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID2 ) > -1,
            "$RandomID2 found on page",
        );

        # test search filter by customer user $RandomID
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($RandomID);
        $Selenium->find_element( "#Search", 'css' )->submit();

        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID found on page",
        );

        $Self->False(
            index( $Selenium->get_page_source(), $RandomID2 ) > -1,
            "$RandomID2 not found on page",
        );

        # check and edit new customer user
        $Selenium->find_element( $RandomID, 'link_text' )->click();

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

        # set test customer user to invalid
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#UserFirstname",             'css' )->submit();

        # test search filter
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($RandomID);
        $Selenium->find_element( "#Search", 'css' )->submit();

        # chack class of invalid customer user in the overview table
        $Self->True(
            $Selenium->find_element( "tr.Invalid", 'css' ),
            "There is a class 'Invalid' for test Customer User",
        );

        # delete created test customer user and customer company
        for my $CustomerID ( $RandomID, $RandomID2 ) {
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE customer_id = ?",
                Bind => [ \$CustomerID ],
            );
            $Self->True(
                $Success,
                "Deleted Customers - $CustomerID",
            );

            $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
                Bind => [ \$CustomerID ],
            );
            $Self->True(
                $Success,
                "Deleted CustomerUser - $CustomerID",
            );
        }

        # make sure the cache is correct.
        for my $Cache (qw(CustomerCompany CustomerUser)) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }

);

1;
