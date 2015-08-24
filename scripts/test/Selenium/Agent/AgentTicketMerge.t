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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

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
                OwnerID      => $TestUserID,
                UserID       => $TestUserID,
            );

            $Self->True(
                $TicketID,
                "Ticket is created - $TicketID",
            );

            push @TicketIDs,     $TicketID;
            push @TicketNumbers, $TicketNumber;

        }

        # naviage to zoom view of created test ticket
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[0]");

        # force sub menus to be visible in order to be able to click one of the links
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");

        # click on merge
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketMerge;TicketID=$TicketIDs[0]' )]")->click();

        # switch to merge window
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

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
        $Element->submit();

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#MainTicketNumber').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # expect error when try to merge ticket with itself
        $Selenium->find_element( "#MainTicketNumber", 'css' )->send_keys( $TicketNumbers[0] );
        $Selenium->find_element( "#submitRichText",   'css' )->click();

        $Self->True(
            index( $Selenium->get_page_source(), 'Can\'t merge ticket with itself!' ) > -1,
            "Successfully can't merge ticket with itself",
        );
        $Selenium->close();

        $Selenium->switch_to_window( $Handles->[0] );

        # force sub menus to be visible in order to be able to click one of the links
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");

        # click on merge
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketMerge;TicketID=$TicketIDs[0]' )]")->click();

        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # go back to merge screen and clear ticket number input
        $Selenium->find_element( "#MainTicketNumber", 'css' )->clear();

        # merge with second test ticket
        $Selenium->find_element( "#MainTicketNumber", 'css' )->send_keys( $TicketNumbers[1] );
        $Selenium->find_element( "#submitRichText",   'css' )->click();

        # return back to zoom view and click on history and switch to its view
        $Selenium->switch_to_window( $Handles->[0] );

        # force sub menus to be visible in order to be able to click one of the links
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");

        $Selenium->find_element("//*[text()='History']")->click();

        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

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
                UserID   => $TestUserID,
            );
            $Self->True(
                $Success,
                "Delete ticket - $Ticket"
            );
        }

        # make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

1;
