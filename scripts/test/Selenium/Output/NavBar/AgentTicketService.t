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

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get SysConfigObject object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # disable frontend service module
        my %FrontendAgentTicketService = $SysConfigObject->ConfigItemGet(
            Name => 'Frontend::Module###AgentTicketService',
        );
        $SysConfigObject->ConfigItemUpdate(
            Valid => 0,
            Key   => 'Frontend::Module###AgentTicketService',
            Value => \%FrontendAgentTicketService,
        );

        # check for NavBarAgentTicketService button when frontend service module is disabled
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentDashboard");
        $Self->True(
            index( $Selenium->get_page_source(), 'Action=AgentTicketService' ) == -1,
            "NavBar 'Service view' button NOT available when frontend service module is disabled",
        );

        # enable frontend service module
        $SysConfigObject->ConfigItemReset(
            Name => 'Frontend::Module###AgentTicketService',
        );

        # disable service feature
        $SysConfigObject->ConfigItemReset(
            Name => 'Ticket::Service',
        );

        # check for NavBarAgentTicketService button when frontend service module is enabled but service feature is disabled
        $Selenium->refresh();
        $Self->True(
            index( $Selenium->get_page_source(), 'Action=AgentTicketService' ) == -1,
            "NavBar 'Service view' button NOT available when service feature is disabled",
        );

        # enable ticket service feature
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1,
        );

        # check for NavBarAgentTicketService button when frontend service module and service feature are enabled
        $Selenium->refresh();
        $Self->True(
            index( $Selenium->get_page_source(), 'Action=AgentTicketService' ) > -1,
            "NavBar 'Service view' button IS available when frontend service module and service feature are enabled",
        );

        # disable NavBarAgentTicketSearch feature and verify that 'Service view' button is present when frontend service module is enabled
        # and service features is disabled
        my %NavBarAgentTicketService = $SysConfigObject->ConfigItemGet(
            Name => 'Frontend::NavBarModule###7-AgentTicketService',
        );
        $SysConfigObject->ConfigItemUpdate(
            Valid => 0,
            Key   => 'Frontend::NavBarModule###7-AgentTicketService',
            Value => \%NavBarAgentTicketService,
        );
        $SysConfigObject->ConfigItemReset(
            Name => 'Ticket::Service',
        );

        $Selenium->refresh();
        $Self->True(
            index( $Selenium->get_page_source(), 'Action=AgentTicketService' ) > -1,
            "NavBar 'Service view' button IS available when frontend service module is enabled, while service feature and NavBarAgentTicketService are disabled",
        );
    }
);

1;
