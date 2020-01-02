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

        # Enable CustomerUserGenericTicket sysconfig.
        my @CustomerSysConfig = (
            '15-OpenTickets',   '16-OpenTicketsForCustomerUserLogin',
            '17-ClosedTickets', '18-ClosedTicketsForCustomerUserLogin'
        );

        for my $SysConfigChange (@CustomerSysConfig) {

            # Get default sysconfig.
            my $SysConfigName = 'Frontend::CustomerUser::Item###' . $SysConfigChange;
            my %Config        = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
                Name    => $SysConfigName,
                Default => 1,
            );

            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => $SysConfigName,
                Value => $Config{EffectiveValue},
            );
        }

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create test customer user.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # Get test customer user ID.
        my @CustomerIDs = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerIDs(
            User => $TestCustomerUserLogin,
        );
        my $CustomerID = $CustomerIDs[0];

        # Create test data parameters.
        my %TicketData = (
            'Open' => {
                TicketState   => 'open',
                TicketCount   => '',
                TicketNumbers => [],
                TicketIDs     => [],
                TicketLink    => 'Open',
            },
            'Closed' => {
                TicketState   => 'closed successful',
                TicketCount   => '',
                TicketNumbers => [],
                TicketIDs     => [],
                TicketLink    => 'Closed',
            },
        );

        # Create open and closed tickets.
        for my $TicketCreate ( sort keys %TicketData ) {
            for my $TestTickets ( 1 .. 5 ) {
                my $TicketNumber = $TicketObject->TicketCreateNumber();
                my $TicketID     = $TicketObject->TicketCreate(
                    TN           => $TicketNumber,
                    Title        => 'Selenium Test Ticket',
                    Queue        => 'Raw',
                    Lock         => 'unlock',
                    Priority     => '3 normal',
                    State        => $TicketData{$TicketCreate}->{TicketState},
                    CustomerID   => $CustomerID,
                    CustomerUser => $TestCustomerUserLogin,
                    OwnerID      => $TestUserID,
                    UserID       => $TestUserID,
                );
                $Self->True(
                    $TicketID,
                    "$TicketCreate - ticket TicketID $TicketID - created - TN $TicketNumber",
                );
                push @{ $TicketData{$TicketCreate}->{TicketIDs} },     $TicketID;
                push @{ $TicketData{$TicketCreate}->{TicketNumbers} }, $TicketNumber;
            }
            my $TicketCount = $TicketObject->TicketSearch(
                Result     => 'Count',
                StateType  => $TicketCreate,
                CustomerID => $CustomerID,
                UserID     => $TestUserID,
            );
            $TicketData{$TicketCreate}->{TicketCount} = $TicketCount;
        }

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Go to zoom view of created test ticket.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketData{Open}->{TicketIDs}->[0]"
        );

        # Wait until page and customer info widget have loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("body").length && $(".WidgetIsLoading").length === 0'
        );

        # Test CustomerUserGenericTicket module.
        for my $TestLinks ( sort keys %TicketData ) {

            # Check for layout and ticket count.
            my $ExpectedText = $TestLinks . " tickets (customer) ($TicketData{$TestLinks}->{TicketCount})";
            $Self->True(
                index( $Selenium->get_page_source(), $ExpectedText ) > -1,
                "$ExpectedText - found on screen"
            );

            # Click on link.
            $Selenium->find_element(
                "//a[contains(\@href, \'$TicketData{$TestLinks}->{TicketLink};CustomerUserLoginRaw=$TestCustomerUserLogin' )]"
            )->click();

            $Selenium->WaitFor( WindowCount => 2 );

            # Link open in new window, switch to it.
            my $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[1] );

            # Wait until page has loaded, if necessary.
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

            # Check for test ticket numbers on search screen.
            for my $CheckTicketNumbers ( @{ $TicketData{$TestLinks}->{TicketNumbers} } ) {
                $Self->True(
                    index( $Selenium->get_page_source(), $CheckTicketNumbers ) > -1,
                    "TicketNumber $CheckTicketNumbers - found on screen"
                );
            }

            # Click on 'Change search option'.
            $Selenium->find_element(
                "//a[contains(\@href, \'AgentTicketSearch;Subaction=LoadProfile' )]"
            )->click();

            # Link open in new window switch to it.
            $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[2] );

            # Wait until search dialog has been loaded.
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#SearchFormSubmit").length' );

            # Verify state search attributes are shown in search screen, see bug #10853.
            $Selenium->find_element( "#StateIDs", 'css' );

            # Close current window and return to original.
            $Selenium->close();
            $Selenium->WaitFor( WindowCount => 1 );
            $Selenium->switch_to_window( $Handles->[0] );
        }

        # Delete created test tickets.
        for my $TicketState ( sort keys %TicketData ) {
            for my $TicketID ( @{ $TicketData{$TicketState}->{TicketIDs} } ) {

                my $Success = $TicketObject->TicketDelete(
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
                    "Delete ticket - $TicketID",
                );
            }
        }

        # Make sure cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

1;
