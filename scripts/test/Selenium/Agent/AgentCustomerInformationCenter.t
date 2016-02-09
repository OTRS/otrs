# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
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
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # create test customer
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminCustomerInformationCenter screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentCustomerInformationCenter");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#AgentCustomerInformationCenterSearchCustomerID").length' );

        # input search parameters
        $Selenium->find_element( "#AgentCustomerInformationCenterSearchCustomerID", 'css' )
            ->send_keys($TestCustomerUserLogin);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->find_element("//*[text()='$TestCustomerUserLogin']")->VerifiedClick();

        # check customer information center page
        $Self->True(
            index( $Selenium->get_page_source(), "Customer Information Center" ) > -1,
            "Found looked value on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Customer Users" ) > -1,
            "Customer Users widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Reminder Tickets" ) > -1,
            "Reminder Tickets widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Escalated Tickets" ) > -1,
            "Escalated Tickets widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Open Tickets / Need to be answered" ) > -1,
            "Open Tickets / Need to be answered widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Settings" ) > -1,
            "Setting for toggle widgets found on page",
        );

    }
);

1;
