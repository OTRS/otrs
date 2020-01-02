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

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Disable 'Ticket Information', 'Customer Information' and 'Linked Object' widgets in AgentTicketZoom screen.
        for my $WidgetDisable (qw(0100-TicketInformation 0200-CustomerInformation 0300-LinkTable)) {
            $Helper->ConfigSettingChange(
                Valid => 0,
                Key   => "Ticket::Frontend::AgentTicketZoom###Widgets###$WidgetDisable",
                Value => '',
            );
        }

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Get test customer data.
        my $RandomID     = $Helper->GetRandomID();
        my %CustomerData = (
            CustomerFirstName => "FirstName$RandomID",
            CustomerLastName  => "LastName$RandomID",
            CustomerLogin     => "Login$RandomID",
            CustomerEmail     => "$RandomID\@localhost.com",
            CompanyName       => "Company$RandomID",
            CompanyStreet     => "Street$RandomID",
            CompanyZip        => $Helper->GetRandomNumber(),
            CompanyCity       => "City$RandomID",
            CompanyURL        => "http://www.$RandomID.org",
            CompanyComment    => "Comment$RandomID",
        );

        # Create test customer company.
        my $CompanyNameID     = "CompanyID$RandomID";
        my $CustomerCompanyID = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
            CustomerID             => $CompanyNameID,
            CustomerCompanyName    => $CustomerData{CompanyName},
            CustomerCompanyStreet  => $CustomerData{CompanyStreet},
            CustomerCompanyZIP     => $CustomerData{CompanyZip},
            CustomerCompanyCity    => $CustomerData{CompanyCity},
            CustomerCompanyURL     => $CustomerData{CompanyURL},
            CustomerCompanyComment => $CustomerData{CompanyComment},
            ValidID                => 1,
            UserID                 => 1,
        );
        $Self->True(
            $CustomerCompanyID,
            "CustomerCompanyID $CustomerCompanyID is created"
        );

        # Create test customer user.
        my $CustomerUserID = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $CustomerData{CustomerFirstName},
            UserLastname   => $CustomerData{CustomerLastName},
            UserCustomerID => $CompanyNameID,
            UserLogin      => $CustomerData{CustomerLogin},
            UserEmail      => $CustomerData{CustomerEmail},
            ValidID        => 1,
            UserID         => 1,
        );
        $Self->True(
            $CustomerUserID,
            "CustomerUserID $CustomerUserID is created"
        );

        # Create test ticket.
        my $TitleRandom = "Title" . $Helper->GetRandomID();
        my $TicketID    = $TicketObject->TicketCreate(
            Title        => $TitleRandom,
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerID   => $CompanyNameID,
            CustomerUser => $CustomerUserID,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID is created",
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketZoom for test created ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Verify its right screen.
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page",
        );

        # Verify there is no 'Customer Information' widget, it's disabled.
        $Self->True(
            index( $Selenium->get_page_source(), "$CustomerData{CustomerFirstName}" ) == -1,
            "Customer Information widget is disabled",
        );

        # Reset 'Customer Information' widget sysconfig, enable it and refresh screen.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketZoom###Widgets###0200-CustomerInformation',
            Value => {
                'Location' => 'Sidebar',
                'Module'   => 'Kernel::Output::HTML::TicketZoom::CustomerInformation'
            },
        );

        $Selenium->VerifiedRefresh();

        # Verify there is 'Customer Information' widget, it's enabled.
        $Self->Is(
            $Selenium->find_element( '.Header>h2', 'css' )->get_text(),
            'Customer Information',
            'Customer Information widget is enabled',
        );

        # Verify 'Customer Information' widget values.
        for my $CustomerInformationCheck ( sort keys %CustomerData ) {
            $Self->True(
                $Selenium->find_element("//p[contains(\@title, \'$CustomerData{$CustomerInformationCheck}' )]"),
                "$CustomerInformationCheck - $CustomerData{$CustomerInformationCheck} found in Customer Information widget"
            );
        }

        # Verify there is link to CustomerCompany ticket search.
        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'CustomerIDRaw=$CompanyNameID;StateType=Open\')]"),
            "Found Ticket search link in Customer Information"
        );

        # Verify there is no collapsed elements on the screen.
        $Self->True(
            $Selenium->find_element("//div[contains(\@class, \'WidgetSimple Expanded')]"),
            "Customer Information Widget is expanded"
        );

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".SidebarColumn a[title*=\'Show or hide the content\']").length;'
        );

        # Toggle to collapse 'Customer Information' widget.
        $Selenium->find_element(
            "//div[contains(\@class, 'SidebarColumn')]//a[contains(\@title, \'Show or hide the content' )]"
        )->click();

        $Selenium->WaitFor(
            JavaScript => 'return $(".SidebarColumn div.WidgetSimple.Collapsed").length;'
        );

        # Verify there is collapsed element on the screen.
        $Self->True(
            $Selenium->find_element(
                "//div[contains(\@class, 'SidebarColumn')]//div[contains(\@class, \'WidgetSimple Collapsed')]"
            ),
            "Customer Information Widget is collapsed"
        );

        # Cleanup test data.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete test customer user.
        $CustomerData{CustomerLogin} = $DBObject->Quote( $CustomerData{CustomerLogin} );
        my $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$CustomerData{CustomerLogin} ],
        );
        $Self->True(
            $Success,
            "Customer user $CustomerData{CustomerLogin} is deleted",
        );

        # Delete test customer company.
        $CompanyNameID = $DBObject->Quote($CompanyNameID);
        $Success       = $DBObject->Do(
            SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
            Bind => [ \$CompanyNameID ],
        );
        $Self->True(
            $Success,
            "Customer company $CompanyNameID is deleted",
        );

        # Clean up test data from the DB.
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
            "TicketID $TicketID is deleted"
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw(Ticket CustomerCompany CustomerUser)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
