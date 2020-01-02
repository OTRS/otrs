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

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # disable frontend service module
        my $FrontendAgentTicketService = $ConfigObject->Get('Frontend::Module')->{AgentTicketService};
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'Frontend::Module###AgentTicketService',
            Value => $FrontendAgentTicketService,
        );

        # check for NavBarAgentTicketService button when frontend service module is disabled
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");
        $Self->True(
            index( $Selenium->get_page_source(), 'Action=AgentTicketService' ) == -1,
            "NavBar 'Service view' button NOT available when frontend service module is disabled",
        ) || die;

        # enable frontend service module
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::Module###AgentTicketService',
            Value => $FrontendAgentTicketService,
        );

        # disable service feature
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0,
        );

        # check for NavBarAgentTicketService button
        # when frontend service module is enabled but service feature is disabled
        $Selenium->VerifiedRefresh();
        $Self->True(
            index( $Selenium->get_page_source(), 'Action=AgentTicketService' ) == -1,
            "NavBar 'Service view' button NOT available when service feature is disabled",
        ) || die;

        # enable ticket service feature
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1,
        );

        # check for NavBarAgentTicketService button when frontend service module and service feature are enabled
        $Selenium->VerifiedRefresh();
        $Self->True(
            index( $Selenium->get_page_source(), 'Action=AgentTicketService' ) > -1,
            "NavBar 'Service view' button IS available when frontend service module and service feature are enabled",
        ) || die;

        # disable NavBarAgentTicketSearch feature and verify that 'Service view' button
        # is present when frontend service module is enabled and service features is disabled
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'Frontend::NavBarModule###7-AgentTicketService',
            Value => {},
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0,
        );

        $Selenium->VerifiedRefresh();
        $Self->True(
            index( $Selenium->get_page_source(), 'Action=AgentTicketService' ) > -1,
            "NavBar 'Service view' button IS available when frontend service module is enabled, while service feature and NavBarAgentTicketService are disabled",
        ) || die;
    }
);

1;
