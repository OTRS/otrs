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

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test tickets
        my @TicketIDs;
        my @TicketNumbers;
        for my $Ticket ( 1 .. 2 ) {
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN           => $TicketNumber,
                Title        => "Selenium Test Ticket $Ticket",
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'new',
                CustomerID   => 'SeleniumCustomer',
                CustomerUser => "SeleniumCustomer\@localhost.com",
                OwnerID      => 1,
                UserID       => 1,
            );
            $Self->True(
                $TicketID,
                "Ticket is created - ID $TicketID",
            );

            push @TicketIDs,     $TicketID;
            push @TicketNumbers, $TicketNumber;

        }

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to zoom view of created test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[0]");

        # force sub menus to be visible in order to be able to click one of the links
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");

        # click on merge
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketMerge;TicketID=$TicketIDs[0]' )]")
            ->VerifiedClick();

        # switch to merge window
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#MainTicketNumber").length' );

        # check page
        for my $ID (
            qw(MainTicketNumber InformSender To Subject RichText submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check client side validation
        my $Element = $Selenium->find_element( "#MainTicketNumber", 'css' );
        $Element->send_keys("");
        $Element->VerifiedSubmit();

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#MainTicketNumber').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # expect error when try to merge ticket with itself
        $Selenium->find_element( "#MainTicketNumber", 'css' )->send_keys( $TicketNumbers[0] );
        $Selenium->find_element( "#submitRichText",   'css' )->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), 'Can\'t merge ticket with itself!' ) > -1,
            "Successfully can't merge ticket with itself",
        );
        $Selenium->close();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Wait for reload to kick in.
        sleep 1;
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

        # force sub menus to be visible in order to be able to click one of the links
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");

        # click on merge
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketMerge;TicketID=$TicketIDs[0]' )]")
            ->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#MainTicketNumber").length' );

        # go back to merge screen and clear ticket number input
        $Selenium->find_element( "#MainTicketNumber", 'css' )->clear();

        # merge with second test ticket
        $Selenium->find_element( "#MainTicketNumber", 'css' )->send_keys( $TicketNumbers[1] );
        $Selenium->find_element( "#submitRichText",   'css' )->click();

        # return back to zoom view and click on history and switch to its view
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Wait for reload to kick in.
        sleep 1;
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

        # force sub menus to be visible in order to be able to click one of the links
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");

        $Selenium->find_element("//*[text()='History']")->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length' );

        # confirm merge action
        my $MergeMsg = "Merged Ticket ($TicketNumbers[0]/$TicketIDs[0]) to ($TicketNumbers[1]/$TicketIDs[1])";
        $Self->True(
            index( $Selenium->get_page_source(), $MergeMsg ) > -1,
            "Merge action completed",
        );

        # delete created test tickets
        for my $Ticket (@TicketIDs) {
            my $Success = $TicketObject->TicketDelete(
                TicketID => $Ticket,
                UserID   => 1,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $Ticket,
                    UserID   => 1,
                );
            }
            $Self->True(
                $Success,
                "Ticket with ticket ID $Ticket is deleted"
            );
        }

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

1;
