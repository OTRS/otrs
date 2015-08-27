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

        # enable ticket responsible feature
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Responsible',
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

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # add test customer for testing
        my $TestCustomer = 'Customer' . $Helper->GetRandomID();
        my $UserLogin    = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestCustomer,
            UserLastname   => $TestCustomer,
            UserCustomerID => $TestCustomer,
            UserLogin      => $TestCustomer,
            UserEmail      => "$TestCustomer\@localhost.com",
            ValidID        => 1,
            UserID         => $TestUserID,
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test tickets
        my @TicketIDs;
        for ( 1 .. 3 ) {
            my $TicketID = $TicketObject->TicketCreate(
                Title         => 'Selenium Test Ticket',
                Queue         => 'Raw',
                Lock          => 'unlock',
                Priority      => '3 normal',
                State         => 'open',
                CustomerID    => $TestCustomer,
                CustomerUser  => "$TestCustomer\@localhost.com",
                OwnerID       => $TestUserID,
                UserID        => $TestUserID,
                ResponsibleID => $TestUserID,
            );

            $Self->True(
                $TicketID,
                "Ticket is created - $TicketID",
            );

            push @TicketIDs, $TicketID;

        }

        # go to AgentTicketResponsibleView
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketResponsibleView");

        # test if tickets show with appropriate filters
        FILTER:
        for my $Filter (qw(All New Reminder ReminderReached)) {

            # check for control button (All / New Arcticle / Pending / Reminder Reached)
            my $Element = $Selenium->find_element(
                "//a[contains(\@href, \'Action=AgentTicketResponsibleView;SortBy=Age;OrderBy=Up;View=;Filter=$Filter\' )]"
            );
            $Element->is_enabled();
            $Element->is_displayed();
            $Element->click();

            # expect to find no tickets for Reminder Reached filter
            if ( $Filter eq 'ReminderReached' ) {
                $Self->True(
                    index( $Selenium->get_page_source(), 'No ticket data found.' ) > -1,
                    "No tickets found with Reminder Reached filter ",
                );
                last FILTER;
            }

            # check different views for filters
            for my $View (qw(Small Medium Preview)) {

                # click on viewer controler
                $Selenium->find_element(
                    "//a[contains(\@href, \'Action=AgentTicketResponsibleView;Filter=$Filter;View=$View;\' )]"
                )->click();

                # check screen output
                $Selenium->find_element( "table",             'css' );
                $Selenium->find_element( "table tbody tr td", 'css' );

                # verify that all tickets are present
                for my $TicketID (@TicketIDs) {

                    my $TicketNumber = $TicketObject->TicketNumberLookup(
                        TicketID => $TicketID,
                        UserID   => $TestUserID,
                    );

                    $Self->True(
                        index( $Selenium->get_page_source(), $TicketNumber ) > -1,
                        "Ticket found on page - $TicketNumber ",
                    );
                }
            }

            # change status for test tickets with bulk action
            if ( $Filter eq 'New' ) {
                for my $TicketID (@TicketIDs) {

                    # select all created test tickets
                    $Selenium->find_element("//input[\@type='checkbox'][\@value='$TicketID']")->click();
                }

                # click on bulk action and switch window
                $Selenium->find_element("//*[text()='Bulk']")->click();
                my $Handles = $Selenium->get_window_handles();
                $Selenium->switch_to_window( $Handles->[1] );

                # change state to 'pending reminder'
                $Selenium->execute_script("\$('#StateID').val('6').trigger('redraw.InputField').trigger('change');");
                $Selenium->find_element( "#submitRichText", 'css' )->click();

                # switch back to AgentTicketResponsibleView
                $Selenium->switch_to_window( $Handles->[0] );

            }

            # switch back to AgentTicketResponsibleView
            $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketResponsibleView");

        }

        # delete created test tickets
        my $Success;
        for my $TicketID (@TicketIDs) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );
            $Self->True(
                $Success,
                "Delete ticket - $TicketID"
            );
        }

        # delete created test customer user
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        $TestCustomer = $DBObject->Quote($TestCustomer);
        $Success      = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$TestCustomer ],
        );
        $Self->True(
            $Success,
            "Delete customer user - $TestCustomer",
        );

        # make sure the cache is correct.
        for my $Cache (
            qw (Ticket CustomerUser)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }
);

1;
