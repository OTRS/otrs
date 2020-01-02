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

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # enable tool bar AgentTicketQueue
        my %AgentTicketQueue = (
            AccessKey => 'q',
            Action    => 'AgentTicketQueue',
            CssClass  => 'QueueView',
            Icon      => 'fa fa-folder',
            Link      => 'Action=AgentTicketQueue',
            Module    => 'Kernel::Output::HTML::ToolBar::Link',
            Name      => 'Queue view',
            Priority  => '1010010',
        );

        $Helper->ConfigSettingChange(
            Key   => 'Frontend::ToolBarModule###1-Ticket::AgentTicketQueue',
            Value => \%AgentTicketQueue,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::ToolBarModule###1-Ticket::AgentTicketQueue',
            Value => \%AgentTicketQueue
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

        # click on tool bar AgentTicketQueue
        $Selenium->find_element("//a[contains(\@title, \'Queue view:\' )]")->VerifiedClick();

        # verify that test is on the correct screen
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        my $ExpectedURL = "${ScriptAlias}index.pl?Action=AgentTicketQueue";

        $Self->True(
            index( $Selenium->get_current_url(), $ExpectedURL ) > -1,
            "ToolBar AgentTicketQueue shortcut - success",
        );
    }
);

1;
