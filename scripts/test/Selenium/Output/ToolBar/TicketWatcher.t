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

        # enable ticket watcher feature
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Watcher',
            Value => 1
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

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title         => 'Selenium test ticket',
            Queue         => 'Raw',
            Lock          => 'unlock',
            Priority      => '3 normal',
            State         => 'open',
            CustomerID    => 'SeleniumCustomerID',
            CustomerUser  => 'test@localhost.com',
            OwnerID       => 1,
            UserID        => 1,
            ResponsibleID => 1,
        );

        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID"
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to AgentTicketZoom and check watcher feature - subscribe ticket to watch it
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketWatcher\' )]")->VerifiedClick();

        # click on tool bar AgentTicketWatchView
        $Selenium->find_element("//a[contains(\@title, \'Watched Tickets Total:\' )]")->VerifiedClick();

        # verify that test is on the correct screen
        my $ExpectedURL = "${ScriptAlias}index.pl?Action=AgentTicketWatchView";

        $Self->True(
            index( $Selenium->get_current_url(), $ExpectedURL ) > -1,
            "ToolBar AgentTicketWatcherView shortcut - success",
        );

        # delete test ticket
        my $Success = $TicketObject->TicketDelete(
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
            "Ticket is deleted - $TicketID"
        );
    }
);

1;
