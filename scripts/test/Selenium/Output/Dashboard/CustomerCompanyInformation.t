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
        my $TestCustomerID  = $Helper->GetRandomID() . "CID";
        my $TestCompanyName = "Company" . $Helper->GetRandomID();
        my @CustomerCompany
            = ( 'Selenium Street', 'Selenium ZIP', 'Selenium City', 'Selenium Country', 'Selenium URL' );
        my $CustomerCompanyID = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
            CustomerID             => $TestCustomerID,
            CustomerCompanyName    => $TestCompanyName,
            CustomerCompanyStreet  => $CustomerCompany[0],
            CustomerCompanyZIP     => $CustomerCompany[1],
            CustomerCompanyCity    => $CustomerCompany[2],
            CustomerCompanyCountry => $CustomerCompany[3],
            CustomerCompanyURL     => $CustomerCompany[4],
            CustomerCompanyComment => 'some comment',
            ValidID                => 1,
            UserID                 => $TestUserID,
        );

        # go to customer information center screen
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentCustomerInformationCenter;CustomerID=$TestCustomerID");

        # test customer information widget
        for my $Test (@CustomerCompany) {
            $Self->True(
                index( $Selenium->get_page_source(), $Test ) > -1,
                "$Test - found on screen"
            );
        }

        # delete test customer company
        my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
            Bind => [ \$CustomerCompanyID ],
        );
        $Self->True(
            $Success,
            "Deleted CustomerCompany - $CustomerCompanyID",
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'CustomerCompany',
        );

    }
);

1;
