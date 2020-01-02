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

use Kernel::System::VariableCheck qw(:all);

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Disable email checks to create new user.
        $ConfigObject->Set(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        my $CustomerUser = $ConfigObject->Get('CustomerUser');
        $CustomerUser->{CustomerUserListFields} = [ 'first_name', 'last_name', 'customer_id', 'email' ];
        $Helper->ConfigSettingChange(
            Key   => 'CustomerUser',
            Value => $CustomerUser,
        );

        my $RandomNumber = $Helper->GetRandomNumber();

        # Create customer.
        my $CustomerID        = "CustomerID$RandomNumber";
        my $CustomerCompanyID = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
            CustomerID             => $CustomerID,
            CustomerCompanyName    => "CompanyName$RandomNumber",
            CustomerCompanyStreet  => 'Some Street',
            CustomerCompanyZIP     => '12345',
            CustomerCompanyCity    => 'Some city',
            CustomerCompanyCountry => 'Germany',
            CustomerCompanyURL     => 'http://example.com',
            CustomerCompanyComment => 'some comment',
            ValidID                => 1,
            UserID                 => 1,
        );
        $Self->True(
            $CustomerCompanyID,
            "CustomerCompanyAdd() - $CustomerCompanyID",
        );

        # Add user to customer.
        my $UserFirstname = "Firstname$RandomNumber";
        my $UserLastname  = "Lastname$RandomNumber";
        my $UserEmail     = "email$RandomNumber\@example.com";
        my $UserLogin     = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $UserFirstname,
            UserLastname   => $UserLastname,
            UserCustomerID => $CustomerCompanyID,
            UserLogin      => $RandomNumber . '-1',
            UserEmail      => $UserEmail,
            UserPassword   => 'some_pass',
            UserTitle      => 'Mr.',
            UserCountry    => 'Germany',
            ValidID        => 1,
            UserID         => 1,
        );
        $Self->True(
            $UserLogin,
            "CustomerUserAdd() - $UserLogin",
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

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Go to AgentTicketEmail screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketEmail");

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#OptionCustomerUserAddressBookToCustomer').length === 1;"
        );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '#OptionCustomerUserAddressBookToCustomer',
        );

        # Open customer user address book search.
        $Selenium->find_element( "#OptionCustomerUserAddressBookToCustomer", 'css' )->click();

        # Wait for dialog to appears.
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.Dialog.Modal').length === 1;"
        );
        $Selenium->SwitchToFrame(
            FrameSelector => '.CustomerUserAddressBook',
            WaitForLoad   => 1,
        );

        # Search customer in customer user address book by Firstname.
        $Selenium->find_element( 'UserFirstname', 'name' )->send_keys($UserFirstname);
        $Selenium->switch_to_frame();

        $Selenium->find_element( '#SearchFormSubmit', 'css' )->click();
        $Selenium->SwitchToFrame(
            FrameSelector => '.CustomerUserAddressBook',
            WaitForLoad   => 1,
        );

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#SelectAllCustomerUser').length === 1;"
        );
        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '#SelectAllCustomerUser',
            Event       => 'click',
        );

        # Select customer user in search results.
        $Selenium->find_element( '#SelectAllCustomerUser', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#SelectAllCustomerUser').prop('checked') === true;"
        );

        $Selenium->switch_to_frame();
        $Selenium->find_element( '#RecipientSelect', 'css' )->click();

        # Check if CustomerUserListFields are correctly joined.
        # See bug#13821 (https://bugs.otrs.org/show_bug.cgi?id=13821).
        $Self->Is(
            $Selenium->execute_script("return \$('input[id*=\"CustomerTicketText_\"]').val()"),
            "\"$UserFirstname $UserLastname $CustomerID\" \<$UserEmail\>",
            "Customer User email is displayed correctly"
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete CustomerUser.
        my $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$UserLogin ],
        );
        $Self->True(
            $Success,
            "CustomerUserID $UserLogin is deleted",
        );

        # Delete CustomerID.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
            Bind => [ \$CustomerCompanyID ],
        );
        $Self->True(
            $Success,
            "CustomerCompanyID $CustomerCompanyID is deleted",
        );

        # Make sure that the cache is correct.
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        for my $Cache (qw (CustomerUser CustomerCompany)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
