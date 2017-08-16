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

        # do not check RichText
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Hook',
            Value => 'TestTicket#',
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::HookDivider',
            Value => '::',
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

        # create test tickets
        my $TicketID1 = $TicketObject->TicketCreate(
            Title        => 'Selenium Test Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => 'SeleniumCustomer@localhost.com',
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );
        $Self->True(
            $TicketID1,
            "Ticket is created - ID $TicketID1",
        );

        my $TitleRandom = "Title" . $Helper->GetRandomID();
        my $TicketID2   = $TicketObject->TicketCreate(
            Title        => $TitleRandom,
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => 'SeleniumCustomer@localhost.com',
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );
        $Self->True(
            $TicketID2,
            "Ticket is created - ID $TicketID2",
        );

        for my $TicketID ( $TicketID1, $TicketID2 ) {

            if ( $TicketID eq $TicketID2 ) {
                $Helper->ConfigSettingChange(
                    Valid => 1,
                    Key   => 'Ticket::Frontend::RedirectAfterCloseDisabled',
                    Value => '1',
                );
            }

            # get script alias
            my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

            # navigate to zoom view of created test ticket
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

            # click on 'Close' and switch window
            $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketClose;TicketID=$TicketID' )]")
                ->VerifiedClick();

            $Selenium->WaitFor( WindowCount => 2 );
            my $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[1] );

            # wait until page has loaded, if necessary
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#NewStateID").length' );

            # check page
            for my $ID (
                qw(NewStateID Subject RichText FileUpload IsVisibleForCustomer submitRichText)
                )
            {
                my $Element = $Selenium->find_element( "#$ID", 'css' );
                $Element->is_enabled();
                $Element->is_displayed();
            }

            # change ticket state
            $Selenium->execute_script("\$('#NewStateID').val('2').trigger('redraw.InputField').trigger('change');");
            $Selenium->find_element( "#Subject",        'css' )->send_keys('Test');
            $Selenium->find_element( "#RichText",       'css' )->send_keys('Test');
            $Selenium->find_element( "#submitRichText", 'css' )->click();

            $Selenium->WaitFor( WindowCount => 1 );
            $Selenium->switch_to_window( $Handles->[0] );

            # confirm close action
            if ( $TicketID eq $TicketID1 ) {
                my $CloseMsg = "Dashboard";
                $Self->True(
                    index( $Selenium->get_page_source(), $CloseMsg ) > -1,
                    "RedirectedToDashboard",
                );
            }
            else {
                $Self->True(
                    $Selenium->execute_script("return \$('h1:contains(TestTicket#::)')"),
                    "Ticket::Hook and Ticket::HookDivider found",
                );

                $Self->True(
                    $Selenium->execute_script("return \$('h1:contains($TitleRandom)')"),
                    "Ticket $TitleRandom found",
                );
            }

            # delete created test tickets
            my $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );
            $Self->True(
                $Success,
                "Ticket is deleted - ID $TicketID"
            );
        }

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

1;
