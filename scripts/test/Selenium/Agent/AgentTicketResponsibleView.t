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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Enable ticket responsible feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Responsible',
            Value => 1
        );

        # Create test user .
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create test tickets.
        my @TicketIDs;
        for ( 1 .. 3 ) {
            my $TicketID = $TicketObject->TicketCreate(
                Title         => 'Selenium Test Ticket',
                Queue         => 'Raw',
                Lock          => 'unlock',
                Priority      => '3 normal',
                State         => 'open',
                CustomerID    => 'SeleniumCustomer',
                CustomerUser  => 'SeleniumCustomer@localhost.com',
                OwnerID       => $TestUserID,
                UserID        => $TestUserID,
                ResponsibleID => $TestUserID,
            );
            $Self->True(
                $TicketID,
                "Ticket is created - ID $TicketID",
            );

            push @TicketIDs, $TicketID;
        }

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketResponsibleView screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketResponsibleView");

        # Test if tickets show with appropriate filters.
        FILTER:
        for my $Filter (qw(All New Reminder ReminderReached)) {

            # Check for control button (All / New Article / Pending / Reminder Reached).
            my $Element = $Selenium->find_element(
                "//a[contains(\@href, \'Action=AgentTicketResponsibleView;SortBy=Age;OrderBy=Up;View=;Filter=$Filter\' )]"
            );
            $Element->is_enabled();
            $Element->is_displayed();
            $Element->VerifiedClick();

            # Expect to find no tickets for Reminder Reached filter.
            if ( $Filter eq 'ReminderReached' ) {
                $Self->True(
                    index( $Selenium->get_page_source(), 'No ticket data found.' ) > -1,
                    "No tickets found with Reminder Reached filter ",
                ) || die "No ticket data message";
                last FILTER;
            }

            # Check different views for filters.
            for my $View (qw(Small Medium Preview)) {

                # Click on viewer controller.
                $Selenium->find_element(
                    "//a[contains(\@href, \'Action=AgentTicketResponsibleView;Filter=$Filter;View=$View;\' )]"
                )->VerifiedClick();

                # Check screen output.
                $Selenium->find_element( "table",             'css' );
                $Selenium->find_element( "table tbody tr td", 'css' );

                # Verify that all tickets are present.
                for my $TicketID (@TicketIDs) {

                    my $TicketNumber = $TicketObject->TicketNumberLookup(
                        TicketID => $TicketID,
                        UserID   => $TestUserID,
                    );

                    $Self->True(
                        index( $Selenium->get_page_source(), $TicketNumber ) > -1,
                        "Ticket found on page - $TicketNumber ",
                    ) || die "Ticket $TicketNumber not found on page";
                }
            }

            # Change status for test tickets.
            if ( $Filter eq 'New' ) {
                for my $TicketID (@TicketIDs) {
                    my $Result = $TicketObject->TicketStateSet(
                        StateID  => 6,
                        TicketID => $TicketID,
                        UserID   => $TestUserID,
                    );
                    $Self->True(
                        $Result,
                        "Ticket ${TicketID} - set pending reminder state successfully",
                    );

                    my $SuccessPendingTimeSet = $TicketObject->TicketPendingTimeSet(
                        Diff     => ( 2 * 24 * 60 ),
                        TicketID => $TicketID,
                        UserID   => $TestUserID,
                    );
                    $Self->True(
                        $SuccessPendingTimeSet,
                        "Set pending time successfully",
                    );

                    my %TicketGet = $TicketObject->TicketGet(
                        TicketID => $TicketID,
                        UserID   => $TestUserID,
                    );
                }
            }

            # Switch back to AgentTicketResponsibleView.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketResponsibleView");
        }

        # Delete created test tickets.
        my $Success;
        for my $TicketID (@TicketIDs) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $TicketID,
                    UserID   => $TestUserID,
                );
            }
            $Self->True(
                $Success,
                "Delete ticket - ID $TicketID"
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

1;
