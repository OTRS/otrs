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

        # disable 'Ticket Information', 'Customer Information' and 'Linked Object' widgets in AgentTicketZoom screen
        for my $WidgetDisable (qw(0100-TicketInformation 0200-CustomerInformation 0300-LinkTable)) {
            $Helper->ConfigSettingChange(
                Valid => 0,
                Key   => "Ticket::Frontend::AgentTicketZoom###Widgets###$WidgetDisable",
                Value => '',
            );
        }

        # do not check email addresses
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # get test customer data
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

        # create test customer company
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

        # create test customer user
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

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
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

        # create and login test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentTicketZoom for test created ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # verify its right screen
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page",
        );

        # verify there is no 'Customer Information' widget, it's disabled
        $Self->True(
            index( $Selenium->get_page_source(), "$CustomerData{CustomerFirstName}" ) == -1,
            "Customer Information widget is disabled",
        );

        # reset 'Customer Information' widget sysconfig, enable it and refresh screen
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketZoom###Widgets###0200-CustomerInformation',
            Value => {
                'Location' => 'Sidebar',
                'Module'   => 'Kernel::Output::HTML::TicketZoom::CustomerInformation'
            },
        );

        $Selenium->VerifiedRefresh();

        # verify there is 'Customer Information' widget, it's enabled
        $Self->Is(
            $Selenium->find_element( '.Header>h2', 'css' )->get_text(),
            'Customer Information',
            'Customer Information widget is enabled',
        );

        # verify 'Customer Information' widget values
        for my $CustomerInformationCheck ( sort keys %CustomerData ) {
            $Self->True(
                $Selenium->find_element("//p[contains(\@title, \'$CustomerData{$CustomerInformationCheck}' )]"),
                "$CustomerInformationCheck - $CustomerData{$CustomerInformationCheck} found in Customer Information widget"
            );
        }

        # verify there is link to CustomerCompany ticket search
        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'CustomerIDRaw=$CompanyNameID;StateType=Open\')]"),
            "Found Ticket search link in Customer Information"
        );

        # verify there is no collapsed elements on the screen
        $Self->True(
            $Selenium->find_element("//div[contains(\@class, \'WidgetSimple Expanded')]"),
            "Customer Information Widget is expanded"
        );

        # toggle to collapse 'Customer Information' widget
        $Selenium->find_element("//a[contains(\@title, \'Show or hide the content' )]")->VerifiedClick();

        # verify there is collapsed element on the screen
        $Self->True(
            $Selenium->find_element("//div[contains(\@class, \'WidgetSimple Collapsed')]"),
            "Customer Information Widget is collapsed"
        );

        # cleanup test data
        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # delete test customer user
        $CustomerData{CustomerLogin} = $DBObject->Quote( $CustomerData{CustomerLogin} );
        my $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$CustomerData{CustomerLogin} ],
        );
        $Self->True(
            $Success,
            "Customer user $CustomerData{CustomerLogin} is deleted",
        );

        # delete test customer company
        $CompanyNameID = $DBObject->Quote($CompanyNameID);
        $Success       = $DBObject->Do(
            SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
            Bind => [ \$CompanyNameID ],
        );
        $Self->True(
            $Success,
            "Customer company $CompanyNameID is deleted",
        );

        # clean up test data from the DB
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

        # make sure the cache is correct
        for my $Cache (qw(Ticket CustomerCompany CustomerUser)) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
