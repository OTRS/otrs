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

        # Do not check RichText.
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

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create test tickets.
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

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        for my $TicketID ( $TicketID1, $TicketID2 ) {

            if ( $TicketID eq $TicketID2 ) {
                $Helper->ConfigSettingChange(
                    Valid => 1,
                    Key   => 'Ticket::Frontend::RedirectAfterCloseDisabled',
                    Value => '1',
                );
            }

            # Navigate to zoom view of created test ticket.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

            # Click on 'Close' and switch window.
            $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketClose;TicketID=$TicketID' )]")->click();

            $Selenium->WaitFor( WindowCount => 2 );
            my $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[1] );

            # Check page
            for my $ID (
                qw(NewStateID Subject RichText FileUpload IsVisibleForCustomer submitRichText)
                )
            {
                $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#$ID').length" );
                my $Element = $Selenium->find_element( "#$ID", 'css' );
                $Element->is_enabled();
                $Element->is_displayed();
            }

            # Change ticket state.
            $Selenium->InputFieldValueSet(
                Element => '#NewStateID',
                Value   => 2,
            );
            $Selenium->find_element( "#Subject",        'css' )->send_keys('Test');
            $Selenium->find_element( "#RichText",       'css' )->send_keys('Test');
            $Selenium->find_element( "#submitRichText", 'css' )->click();

            $Selenium->WaitFor( WindowCount => 1 );
            $Selenium->switch_to_window( $Handles->[0] );

            $Selenium->VerifiedRefresh();
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function'" );

            # Confirm close action.
            if ( $TicketID eq $TicketID1 ) {
                my $CloseMsg = "Dashboard";
                $Self->True(
                    index( $Selenium->get_page_source(), $CloseMsg ) > -1,
                    "RedirectedToDashboard",
                );
            }
            else {
                $Self->True(
                    $Selenium->execute_script("return \$('h1:contains(TestTicket#::)').length"),
                    "Ticket::Hook and Ticket::HookDivider found",
                );

                $Self->True(
                    $Selenium->execute_script("return \$('h1:contains($TitleRandom)').length"),
                    "Ticket $TitleRandom found",
                );
            }

            # Delete created test tickets.
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
                "Ticket is deleted - ID $TicketID"
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

1;
