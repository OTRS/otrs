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

        # Create test tickets.
        my @TicketIDs;
        for ( 1 .. 3 ) {
            my $TicketID = $TicketObject->TicketCreate(
                Title        => 'Selenium Test Ticket',
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'open',
                CustomerID   => 'SeleniumCustomer',
                CustomerUser => 'SeleniumCustomer@localhost.com',
                OwnerID      => 1,
                UserID       => 1,
            );
            $Self->True(
                $TicketID,
                "Ticket is created - ID $TicketID",
            );

            push @TicketIDs, $TicketID;

        }

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketStatusView screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketStatusView");

        # Test if tickets show with appropriate filters.
        for my $Filter (qw(Open Closed)) {

            # Check for control button (Open / Close).
            my $Element = $Selenium->find_element(
                "//a[contains(\@href, \'Action=AgentTicketStatusView;SortBy=Age;OrderBy=Down;View=;Filter=$Filter\' )]"
            );
            $Element->is_enabled();
            $Element->is_displayed();
            $Element->VerifiedClick();

            # Check different views for filters.
            for my $View (qw(Small Medium Preview)) {

                # Click on viewer controller.
                $Selenium->find_element(
                    "//a[contains(\@href, \'Action=AgentTicketStatusView;Filter=$Filter;View=$View;\' )]"
                )->VerifiedClick();

                # Check screen output.
                $Selenium->find_element( "table",             'css' );
                $Selenium->find_element( "table tbody tr td", 'css' );

                # Verify that all expected tickets are present.
                for my $TicketID (@TicketIDs) {

                    my $TicketNumber = $TicketObject->TicketNumberLookup(
                        TicketID => $TicketID,
                        UserID   => 1,
                    );

                    $Self->True(
                        index( $Selenium->get_page_source(), $TicketNumber ) > -1,
                        "Ticket found on page - $TicketNumber ",
                    ) || die "Ticket $TicketNumber not found on page";

                }
            }

            # Close all ticket with bulk action.
            if ( $Filter eq 'Open' ) {
                for my $TicketID (@TicketIDs) {

                    # Select all created test tickets.
                    $Selenium->find_element("//input[\@type='checkbox'][\@value='$TicketID']")->click();
                    $Selenium->WaitFor(
                        JavaScript =>
                            "return typeof(\$) === 'function' && \$('input[value=$TicketID][type=checkbox]:checked').length"
                    );
                }

                # Click on bulk action and switch window.
                $Selenium->find_element("//*[text()='Bulk']")->click();

                $Selenium->WaitFor( WindowCount => 2 );
                my $Handles = $Selenium->get_window_handles();
                $Selenium->switch_to_window( $Handles->[1] );

                # Wait until page has loaded, if necessary.
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && $("#StateID").length && $("#submitRichText").length'
                );

                # Change state to 'closed successful'.
                $Selenium->execute_script("\$('#StateID').val('2').trigger('redraw.InputField').trigger('change');");
                $Selenium->WaitFor( JavaScript => 'return $("#StateID").val() == 2' );

                $Selenium->find_element( "#submitRichText", 'css' )->click();

                # Switch back to AgentTicketStatusView.
                $Selenium->WaitFor( WindowCount => 1 );
                $Selenium->switch_to_window( $Handles->[0] );
                $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketStatusView");
            }

        }

        # Check if sorting and ordering are saved in small view (see bug#13670).
        # Go to Small view.
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentTicketStatusView;Filter=Closed;View=Small;\' )]"
        )->VerifiedClick();

        # Sort tickets by queue.
        $Selenium->find_element(
            "//a[contains(\@href, \'SortBy=Queue;OrderBy=Up\' )]"
        )->VerifiedClick();

        $Self->True(
            $Selenium->find_element("//a[contains(\@title, \'Queue, sorted ascending' )]"),
            "Table is sorted by queue, order by ascending",
        );

        # Go to the other view (e.g. Medium).
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentTicketStatusView;Filter=Closed;View=Medium;\' )]"
        )->VerifiedClick();

        # Go back to the Small view to check if sorting and ordering are saved.
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentTicketStatusView;Filter=Closed;View=Small;\' )]"
        )->VerifiedClick();

        $Self->True(
            $Selenium->find_element("//a[contains(\@title, \'Queue, sorted ascending' )]"),
            "Table is still sorted by queue, order by ascending",
        );

        # Delete created test tickets.
        my $Success;
        for my $TicketID (@TicketIDs) {
            $Success = $TicketObject->TicketDelete(
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
                "Ticket is deleted - ID $TicketID"
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

1;
