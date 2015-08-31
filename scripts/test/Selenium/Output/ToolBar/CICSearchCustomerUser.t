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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable tool bar CICSearchCustomerUser
        my %CICSearchCustomerUser = (
            Block       => "ToolBarCICSearchCustomerUser",
            CSS         => "Core.Agent.Toolbar.CICSearch.css",
            Description => "Customer user search",
            Module      => "Kernel::Output::HTML::ToolBar::Generic",
            Name        => "Customer user search",
            Priority    => "1990040",
            Size        => "10",
        );

        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => 'Frontend::ToolBarModule###14-Ticket::CICSearchCustomerUser',
            Value => \%CICSearchCustomerUser,
        );

        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::ToolBarModule###14-Ticket::CICSearchCustomerUser',
            Value => \%CICSearchCustomerUser,
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
        my $TestCustomerID    = $Helper->GetRandomID() . "CID";
        my $TestCompanyName   = "Company" . $Helper->GetRandomID();
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

        # create test customer
        my $TestCustomerLogin = "Customer" . $Helper->GetRandomID();
        my $TestCustomerEmail = $TestCustomerLogin . "\@localhost.com";
        my $CustomerID        = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestCustomerLogin,
            UserLastname   => $TestCustomerLogin,
            UserCustomerID => $TestCustomerID,
            UserLogin      => $TestCustomerLogin,
            UserEmail      => $TestCustomerEmail,
            ValidID        => 1,
            UserID         => $TestUserID,
        );

        # input test user in search Customer user
        my $AutoCCSearch = "\"$TestCustomerLogin $TestCustomerLogin\" <$TestCustomerEmail>";
        $Selenium->find_element( "#ToolBarCICSearchCustomerUser", 'css' )->send_keys($TestCustomerLogin);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->find_element("//*[text()='$AutoCCSearch']")->click();

        # verify search
        $Self->True(
            index( $Selenium->get_page_source(), $TestCustomerLogin ) > -1,
            "Search by Customer User success - found $TestCustomerLogin",
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
            "Deleted CustomerCompany - $CustomerCompanyID",
        );

        # delete test customer
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE customer_id = ?",
            Bind => [ \$CustomerID ],
        );
        $Self->True(
            $Success,
            "Deleted CustomerUser - $CustomerID",
        );

    }
);

1;
