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

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create two test tickets
        my @Tickets;
        for my $TicketCreate (qw(One Two)) {
            my $TicketTitle = "TestTicket" . $TicketCreate;
            my $TicketID    = $TicketObject->TicketCreate(
                Title      => $TicketTitle,
                Queue      => 'Raw',
                Lock       => 'unlock',
                Priority   => '3 normal',
                State      => 'open',
                CustomerID => 'TestCustomer',
                OwnerID    => 1,
                UserID     => 1,
            );

            # get tickets number
            my %TicketData = $TicketObject->TicketGet(
                TicketID => $TicketID,
            );

            $Self->True(
                $TicketID,
                "Ticket created -  $TicketTitle, $TicketData{TicketNumber} ",
            );

            my %Ticket = (
                TicketID     => $TicketID,
                TicketNumber => $TicketData{TicketNumber},
            );

            push @Tickets, \%Ticket;
        }

        # navigate to AgentTicketStatusView
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketStatusView");

        # verify that both tickets are in open state
        $Self->True(
            index( $Selenium->get_page_source(), $Tickets[0]->{TicketNumber} ) > -1,
            "Open ticket $Tickets[0]->{TicketNumber} found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $Tickets[1]->{TicketNumber} ) > -1,
            "Open ticket $Tickets[1]->{TicketNumber} found on page",
        );

        # select both tickets and click on "bulk"
        $Selenium->find_element("//input[\@value='$Tickets[0]->{TicketID}']")->click();
        $Selenium->find_element("//input[\@value='$Tickets[1]->{TicketID}']")->click();
        $Selenium->find_element( "Bulk", 'link_text' )->click();

        # switch to bulk window
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # check ticket bulk page
        for my $ID (
            qw(StateID OwnerID QueueID PriorityID OptionMergeTo MergeTo
            OptionMergeToOldest LinkTogether LinkTogetherParent Unlock submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # close state and change priority in bulk action for test tickets
        $Selenium->execute_script("\$('#PriorityID').val('4').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#StateID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#submitRichText",               'css' )->click();

        # return to status view
        $Selenium->switch_to_window( $Handles->[0] );

        # select closed view to verify ticket bulk functionality
        $Selenium->find_element("//a[contains(\@href, \'Filter=Closed' )]")->click();

        # verify that both tickets are shown in ticket closed view
        $Self->True(
            index( $Selenium->get_page_source(), $Tickets[0]->{TicketNumber} ) > -1,
            "Closed ticket $Tickets[0]->{TicketNumber} found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $Tickets[1]->{TicketNumber} ) > -1,
            "Closed ticket $Tickets[1]->{TicketNumber} found on page",
        );

        # clean up test data from the DB
        for my $Ticket (@Tickets) {
            my $Success = $TicketObject->TicketDelete(
                TicketID => $Ticket->{TicketID},
                UserID   => 1,
            );
            $Self->True(
                $Success,
                "Ticket is deleted - $Ticket->{TicketNumber} "
            );

        }

        # make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
