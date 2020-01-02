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

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # enable tool bar CICSearchCustomerID
        my %CICSearchCustomerID = (
            Block       => 'ToolBarCICSearchCustomerID',
            CSS         => 'Core.Agent.Toolbar.CICSearch.css',
            Description => 'CustomerID search',
            Module      => 'Kernel::Output::HTML::ToolBar::Generic',
            Name        => 'CustomerID search',
            Priority    => '1990030',
            Size        => '10',
        );

        $Helper->ConfigSettingChange(
            Key   => 'Frontend::ToolBarModule###13-Ticket::CICSearchCustomerID',
            Value => \%CICSearchCustomerID,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::ToolBarModule###13-Ticket::CICSearchCustomerID',
            Value => \%CICSearchCustomerID,
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

        # create test company
        my $TestCustomerID    = $Helper->GetRandomID() . 'CID';
        my $TestCompanyName   = 'Company' . $Helper->GetRandomID();
        my $CustomerCompanyID = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
            CustomerID             => $TestCustomerID,
            CustomerCompanyName    => $TestCompanyName,
            CustomerCompanyStreet  => '5201 Blue Lagoon Drive',
            CustomerCompanyZIP     => '33126',
            CustomerCompanyCity    => 'Miami',
            CustomerCompanyCountry => 'USA',
            CustomerCompanyURL     => 'http://www.example.org',
            CustomerCompanyComment => 'some comment',
            ValidID                => 1,
            UserID                 => $TestUserID,
        );

        $Self->True(
            $CustomerCompanyID,
            "CustomerCompany is created - ID $CustomerCompanyID",
        );

        # create test customer
        my $TestCustomerLogin = 'Customer' . $Helper->GetRandomID();
        my $CustomerID        = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestCustomerLogin,
            UserLastname   => $TestCustomerLogin,
            UserCustomerID => $TestCustomerID,
            UserLogin      => $TestCustomerLogin,
            UserEmail      => $TestCustomerLogin . '@localhost.com',
            ValidID        => 1,
            UserID         => $TestUserID,
        );

        $Self->True(
            $CustomerID,
            "CustomerUser is created - ID $CustomerID",
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # input test user in search CustomerID
        $Selenium->find_element( "#ToolBarCICSearchCustomerID", 'css' )->send_keys($TestCustomerID);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCustomerID)').click()");

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' &&  \$('tbody a:contains($TestCustomerLogin)').length;"
        );

        $Self->True(
            $Selenium->execute_script("return \$('tbody a:contains($TestCustomerLogin)').length;"),
            "Search by CustomerID success - found $TestCustomerLogin",
        );

        $Self->True(
            $Selenium->find_element( '#CustomerInformationCenterHeading', 'css' ),
            "Check heading for CustomerInformationCenter",
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # delete test customer company
        my $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
            Bind => [ \$CustomerCompanyID ],
        );
        $Self->True(
            $Success,
            "CustomerCompany is deleted - ID $CustomerCompanyID",
        );

        # delete test customer
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE customer_id = ?",
            Bind => [ \$CustomerID ],
        );
        $Self->True(
            $Success,
            "CustomerUser is deleted - ID $CustomerID",
        );

        # make sure the cache is correct
        for my $Cache (
            qw (CustomerCompany CustomerUser)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }
);

1;
