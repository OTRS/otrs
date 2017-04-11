# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
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

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # create test customer user
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # get test customer user ID
        my @CustomerIDs = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerIDs(
            User => $TestCustomerUserLogin,
        );
        my $CustomerID = $CustomerIDs[0];

        # get needed objects
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test data parameters
        my %TicketData = (
            'Open' => {
                TicketState   => 'open',
                TicketCount   => '',
                TicketNumbers => [],
                TicketIDs     => [],
                TicketLink    => 'Open',
            },
            'closed' => {
                TicketState   => 'closed successful',
                TicketCount   => '',
                TicketNumbers => [],
                TicketIDs     => [],
                TicketLink    => 'closed',
            },
        );

        # create open and closed tickets
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

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminCustomerInformationCenter screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentCustomerInformationCenter");
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#AgentCustomerInformationCenterSearchCustomerID").length',
        );

        # input search parameters
        $Selenium->find_element( "#AgentCustomerInformationCenterSearchCustomerID", 'css' )->send_keys($TestCustomerUserLogin);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->find_element("//*[text()='$TestCustomerUserLogin']")->VerifiedClick();

        # check customer information center page
        $Self->True(
            index( $Selenium->get_page_source(), "Customer Information Center" ) > -1,
            "Found looked value on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Customer Users" ) > -1,
            "Customer Users widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Reminder Tickets" ) > -1,
            "Reminder Tickets widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Escalated Tickets" ) > -1,
            "Escalated Tickets widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Open Tickets / Need to be answered" ) > -1,
            "Open Tickets / Need to be answered widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Settings" ) > -1,
            "Setting for toggle widgets found on page",
        );

        # check if there is link to CIC search modal dialog from heading (name of the company)
        $Self->True(
            $Selenium->find_element( "#CustomerInformationCenterHeading", 'css' ),
            'There is link to customer information center search modal dialog.',
        );

        # test links in Company Status widget
        for my $TestLinks ( sort keys %TicketData ) {

            # click on link
            $Selenium->find_element(
                "//a[contains(\@href, \'Subaction=Search;StateType=$TicketData{$TestLinks}->{TicketLink};CustomerIDRaw=$TestCustomerUserLogin' )]"
            )->VerifiedClick();

            # wait until page has loaded, if necessary
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

            # check for test ticket numbers on search screen
            for my $CheckTicketNumbers ( @{ $TicketData{$TestLinks}->{TicketNumbers} } ) {
                $Self->True(
                    index( $Selenium->get_page_source(), $CheckTicketNumbers ) > -1,
                    "TicketNumber $CheckTicketNumbers - found on screen"
                );
            }

            # click on 'Change search option'
            $Selenium->find_element(
                "//a[contains(\@href, \'AgentTicketSearch;Subaction=LoadProfile' )]"
            )->VerifiedClick();

            # wait until search dialog has been loaded
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#SearchFormSubmit").length' );

            # verify state search attributes are shown in search screen, see bug #10853
            $Selenium->find_element( "#StateIDs", 'css' );

            # open CIC again for the next test case
            $Selenium->VerifiedGet(
                "${ScriptAlias}index.pl?Action=AgentCustomerInformationCenter;CustomerID=$TestCustomerUserLogin"
            );

        }

        # Click on the customer user link in the customer user list (go to the AgentCustomerUserInformationCenter).
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentCustomerUserInformationCenter;CustomerUserID=$TestCustomerUserLogin' )]"
        )->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), "Customer User Information Center" ) > -1,
            "Found title value on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $TestCustomerUserLogin ) > -1,
            "Found customer user login on page",
        );

        # delete created test tickets
        for my $TicketState ( sort keys %TicketData ) {
            for my $TicketID ( @{ $TicketData{$TicketState}->{TicketIDs} } ) {

                my $Success = $TicketObject->TicketDelete(
                    TicketID => $TicketID,
                    UserID   => $TestUserID,
                );

                $Self->True(
                    $Success,
                    "Delete ticket - $TicketID"
                );
            }
        }

        # make sure cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

1;
