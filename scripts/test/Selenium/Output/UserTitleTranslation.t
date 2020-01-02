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

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
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
        my $UserLogin     = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $UserFirstname,
            UserLastname   => "Lastname$RandomNumber",
            UserCustomerID => $CustomerCompanyID,
            UserLogin      => $RandomNumber . '-1',
            UserEmail      => "email$RandomNumber\@localhost.com",
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
        my $Language      = 'de';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'admin', 'users' ],
            Language => $Language,
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Go to AgentCustomerUserInformationCenter screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentCustomerUserInformationCenter;CustomerUserID=$UserLogin"
        );

        # Define title.
        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );
        my $Mr = $LanguageObject->Translate('Mr.');

        # Check if Title or salutation is translated.
        $Self->Is(
            $Selenium->execute_script("return \$('.SidebarColumn .TableLike p:first').text().trim()"),
            $Mr,
            "Title or salutation '$Mr' correctly translated"
        );

        # Go to AgentTicketPhone screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        # Select test customer.
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys($UserFirstname);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($UserFirstname)').click()");
        $Selenium->InputFieldValueSet(
            Element => '#Dest',
            Value   => '2||Raw',
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Wait for Customer information to appear.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Value.FixedValueSmall:visible").length > 0;'
        );

        # Check if Title or salutation is translated.
        $Self->Is(
            $Selenium->execute_script("return \$('.SidebarColumn .TableLike p:first').text().trim()"),
            $Mr,
            "Title of salutation '$Mr' correctly translated"
        );
        $Selenium->find_element( "#Subject",        'css' )->send_keys('Some Subject');
        $Selenium->find_element( "#RichText",       'css' )->send_keys('Some Text');
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # Get created test ticket ID and number.
        my @Ticket   = split( 'TicketID=', $Selenium->get_current_url() );
        my $TicketID = $Ticket[1];

        # Go to ticket zoom page of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $.active == 0;' );

        # Check if Title or salutation is translated.
        my $CustomerInformation = $LanguageObject->Translate('Customer Information');
        $Self->Is(
            $Selenium->execute_script(
                "return \$('h2:contains($CustomerInformation)').closest('.WidgetSimple').find('p:contains($Mr)').length"
            ),
            1,
            "Title or salutation '$Mr' is found on screen."
        );

        # Go to AgentTicketCustomer screen to check title translation.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketCustomer;TicketID=$TicketID");
        $Self->Is(
            $Selenium->execute_script(
                "return \$('h2:contains($CustomerInformation)').closest('.WidgetSimple').find('p:contains($Mr)').length"
            ),
            1,
            "Title or salutation '$Mr' is found on screen."
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
