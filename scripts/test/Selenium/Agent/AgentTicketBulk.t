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

        # get needed objects
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable bulk feature
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::BulkFeature',
            Value => 1,
        );

        # enable required lock feature in bulk
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketBulk###RequiredLock',
            Value => 1,
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

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my @Tests = (
            {
                TicketTitle => 'TestTicket-One',
                Lock        => 'lock',
                OwnerID     => $TestUserID,
                UserID      => $TestUserID,
            },
            {
                TicketTitle => 'TestTicket-Two',
                Lock        => 'unlock',
                OwnerID     => $TestUserID,
                UserID      => $TestUserID,
            },
            {
                # ticket locked by another agent
                TicketTitle => 'TestTicket-Three',
                Lock        => 'lock',
                OwnerID     => 1,
                UserID      => 1,
            },
        );

        # create three test tickets
        my @Tickets;
        for my $Test (@Tests) {
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN         => $TicketNumber,
                Title      => $Test->{TicketTitle},
                Queue      => 'Raw',
                Lock       => $Test->{Lock},
                Priority   => '3 normal',
                State      => 'open',
                CustomerID => 'TestCustomer',
                OwnerID    => $Test->{OwnerID},
                UserID     => $Test->{UserID},
            );
            $Self->True(
                $TicketID,
                "Ticket is created -  $Test->{TicketTitle}, $TicketNumber ",
            );

            my %Ticket = (
                TicketID     => $TicketID,
                TicketNumber => $TicketNumber,
                OwnerID      => $Test->{OwnerID}
            );

            push @Tickets, \%Ticket;
        }

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentTicketStatusView
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketStatusView");

        # verify that test tickets are in open state
        for my $Ticket (@Tickets) {
            $Self->True(
                index( $Selenium->get_page_source(), $Ticket->{TicketNumber} ) > -1,
                "Open ticket $Ticket->{TicketNumber} is found on page",
            );
        }

        # select both tickets and click on "bulk"
        # test case for the bug #11805 - http://bugs.otrs.org/show_bug.cgi?id=11805
        $Selenium->find_element("//input[\@value='$Tickets[0]->{TicketID}']")->click();
        $Selenium->find_element("//input[\@value='$Tickets[1]->{TicketID}']")->click();
        $Selenium->find_element("//input[\@value='$Tickets[2]->{TicketID}']")->click();
        $Selenium->find_element( "Bulk", 'link_text' )->VerifiedClick();

        # switch to bulk window
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#StateID").length' );

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

        # click on 'Undo & close' link
        $Selenium->find_element( ".UndoClosePopup", 'css' )->click();

        # return to status view
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # check ticket lock
        $Self->Is(
            $TicketObject->TicketLockGet(
                TicketID => $Tickets[0]->{TicketID},
            ),
            1,
            "Ticket remind locked after undo in bulk feature - $Tickets[0]->{TicketNumber}"
        );

        # select test tickets and click on "bulk"
        $Selenium->find_element("//input[\@value='$Tickets[0]->{TicketID}']")->click();
        $Selenium->find_element("//input[\@value='$Tickets[1]->{TicketID}']")->click();
        $Selenium->find_element("//input[\@value='$Tickets[2]->{TicketID}']")->click();
        $Selenium->find_element( "Bulk", 'link_text' )->click();

        # switch to bulk window
        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#StateID").length' );

        # check data
        my @ExpectedMessages = (
            $Tickets[0]->{TicketNumber} . ': Ticket selected.',
            $Tickets[1]->{TicketNumber} . ': Ticket locked.',
            $Tickets[2]->{TicketNumber} . ': Ticket is locked by another agent and will be ignored!',
        );
        for my $ExpectedMessage (@ExpectedMessages) {
            $Self->True(
                index( $Selenium->get_page_source(), $ExpectedMessage ) > -1,
                $ExpectedMessage,
            );
        }

        # change state and priority in bulk action for test tickets
        $Selenium->execute_script("\$('#PriorityID').val('4').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#StateID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        # return to status view
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Make sure main window is fully loaded
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketStatusView");

        # select closed view to verify ticket bulk functionality
        $Selenium->find_element("//a[contains(\@href, \'Filter=Closed' )]")->VerifiedClick();

        # verify which tickets are shown in ticket closed view
        for my $Ticket (@Tickets) {
            if ( $Ticket->{OwnerID} != 1 ) {
                $Self->True(
                    index( $Selenium->get_page_source(), $Ticket->{TicketNumber} ) > -1,
                    "Closed ticket $Ticket->{TicketNumber} is found on page",
                );
            }
            else {

                # ticket is locked by another agent and it was ignored in bulk feature
                $Self->True(
                    index( $Selenium->get_page_source(), $Ticket->{TicketNumber} ) == -1,
                    "Ticket $Ticket->{TicketNumber} is not found on page",
                );
            }

        }

        # clean up test data from the DB
        for my $Ticket (@Tickets) {
            my $Success = $TicketObject->TicketDelete(
                TicketID => $Ticket->{TicketID},
                UserID   => 1,
            );
            $Self->True(
                $Success,
                "Ticket is deleted - $Ticket->{TicketNumber}"
            );

        }

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
