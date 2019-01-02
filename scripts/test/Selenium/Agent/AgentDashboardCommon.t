# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentDashboard screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        # check agent dashboard page
        $Self->True(
            index( $Selenium->get_page_source(), "Dashboard" ) > -1,
            "Found dashboard value on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "New Tickets" ) > -1,
            "New Tickets widget found on page",
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
            index( $Selenium->get_page_source(), "Ticket Queue Overview" ) > -1,
            "Ticket Queue Overview widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Settings" ) > -1,
            "Setting for toggle widgets found on page",
        );

    }
);

1;
