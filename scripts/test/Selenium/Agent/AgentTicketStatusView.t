# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
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
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # do not check email addresses
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
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

        # create test tickets
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

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AgentTicketStatusView screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketStatusView");

        # test if tickets show with appropriate filters
        for my $Filter (qw(Open Closed)) {

            # check for control button (Open / Close)
            my $Element = $Selenium->find_element(
                "//a[contains(\@href, \'Action=AgentTicketStatusView;SortBy=Age;OrderBy=Down;View=;Filter=$Filter\' )]"
            );
            $Element->is_enabled();
            $Element->is_displayed();
            $Element->VerifiedClick();

            # check different views for filters
            for my $View (qw(Small Medium Preview)) {

                # click on viewer controller
                $Selenium->find_element(
                    "//a[contains(\@href, \'Action=AgentTicketStatusView;Filter=$Filter;View=$View;\' )]"
                )->VerifiedClick();

                # check screen output
                $Selenium->find_element( "table",             'css' );
                $Selenium->find_element( "table tbody tr td", 'css' );

                # verify that all expected tickets are present
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

            # close all ticket with bulk action
            if ( $Filter eq 'Open' ) {
                for my $TicketID (@TicketIDs) {

                    # select all created test tickets
                    $Selenium->find_element("//input[\@type='checkbox'][\@value='$TicketID']")->VerifiedClick();
                }

                # click on bulk action and switch window
                $Selenium->find_element("//*[text()='Bulk']")->VerifiedClick();

                $Selenium->WaitFor( WindowCount => 2 );
                my $Handles = $Selenium->get_window_handles();
                $Selenium->switch_to_window( $Handles->[1] );

                # wait until page has loaded, if necessary
                $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#StateID").length' );

                # change state to 'closed successful'
                $Selenium->execute_script("\$('#StateID').val('2').trigger('redraw.InputField').trigger('change');");
                $Selenium->find_element( "#submitRichText", 'css' )->click();

                # switch back to AgentTicketStatusView
                $Selenium->WaitFor( WindowCount => 1 );
                $Selenium->switch_to_window( $Handles->[0] );
                $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketStatusView");
            }

        }

        # delete created test tickets
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

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
