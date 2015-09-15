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
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => 'CheckEmailAddresses',
            Value => 0,
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

        # create test customers
        my @CustomerNames;
        my @CustomerIDs;
        for my $Customers ( 1 .. 3 ) {
            my $TestCustomerLogin = "Customer" . $Helper->GetRandomID();
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
            push @CustomerNames, $TestCustomerLogin;
            push @CustomerIDs,   $CustomerID;
        }

        # go to customer information center screen
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentCustomerInformationCenter;CustomerID=$TestCustomerID");

        # test customer user list
        for my $Test (@CustomerNames) {
            $Self->True(
                index( $Selenium->get_page_source(), $Test ) > -1,
                "$Test - found on screen"
            );
        }

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
        for my $CustomerDelete (@CustomerIDs) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE customer_id = ?",
                Bind => [ \$CustomerDelete ],
            );
            $Self->True(
                $Success,
                "Deleted CustomerUser - $CustomerDelete",
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
