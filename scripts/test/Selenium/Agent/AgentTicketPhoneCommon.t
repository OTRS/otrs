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

        # do not check RichText
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketPhoneOutbound###RequiredLock',
            Value => 1
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketPhoneInbound###RequiredLock',
            Value => 1
        );

        # do not check service and type
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
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
        my $TicketID     = $TicketObject->TicketCreate(
            Title         => 'Selenium Test Ticket',
            QueueID       => 2,
            Lock          => 'unlock',
            Priority      => '3 normal',
            State         => 'open',
            CustomerID    => 'SeleniumCustomer',
            CustomerUser  => "SeleniumCustomer\@localhost.com",
            OwnerID       => 1,
            UserID        => $TestUserID,
            ResponsibleID => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID"
        );

        # get test data
        my @Test = (
            {
                Name            => 'AgentTicketPhoneOutbound',
                HistoryText     => 'PhoneCallAgent',
                UndoLinkPresent => 1,
            },
            {
                Name        => 'AgentTicketPhoneInbound',
                HistoryText => 'PhoneCallCustomer',
                EmptyState  => 1,
            },
        );

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # do tests for Outbound and Inbound
        for my $Action (@Test)
        {

            # navigate to test action
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=$Action->{Name};TicketID=$TicketID");

            # if RequiredLock => 1, we want to make sure that the "undo" link is present if UndoLinkPresent is enabled.
            # for the second test (PhoneInbound), owner and lock will already be changed, so the undo link will not be
            # present anyway.
            my @Selectors = ( '#Subject', '#RichText', '#FileUpload', '#NextStateID', '#submitRichText' );
            if ( $Action->{UndoLinkPresent} ) {
                push @Selectors, '.UndoClosePopup';
            }
            else {

                # otherwise we want to make sure the link is *not* there
                $Self->False(
                    index( $Selenium->get_page_source(), 'UndoClosePopup' ) > -1,
                    'Undo link is not shown',
                );
            }

            # check page
            for my $Selector (@Selectors) {
                my $Element = $Selenium->find_element( "$Selector", 'css' );
                $Element->is_enabled();
                $Element->is_displayed();
            }

            # add body text and submit
            my $ActionText = $Action->{Name} . " Selenium Test";
            $Selenium->find_element( "#Subject",  'css' )->send_keys($ActionText);
            $Selenium->find_element( "#RichText", 'css' )->send_keys($ActionText);

            # Either clear next state field value or explicitly set it in order to test if ticket
            #   state will remain open (see bug#12516 for more information).
            if ( $Action->{EmptyState} ) {
                $Selenium->InputFieldValueSet(
                    Element => '#NextStateID',
                    Value   => '',
                );
            }
            else {
                $Selenium->InputFieldValueSet(
                    Element => '#NextStateID',
                    Value   => 4,
                );
            }

            $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

            # navigate to AgentTicketHistory screen
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

            # verify for expected action
            $Self->True(
                index( $Selenium->get_page_source(), $Action->{HistoryText} ) > -1,
                "Action $Action->{Name} executed correctly",
            );

            # Verify ticket state has not been changed.
            $Self->False(
                index( $Selenium->get_page_source(), 'StateUpdate' ) > -1,
                'Ticket state remained open',
            );
        }

        # Check if PendingDiffTime set to 0 submits phone inbound form if state not pending.
        # See bug#13906 https://bugs.otrs.org/show_bug.cgi?id=13906.

        # Setup 'PendingDiffTime' config to 0 seconds.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::PendingDiffTime',
            Value => 0,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketPhoneInbound###State',
        );

        # Navigate to AgentTicketPhoneInbound screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhoneInbound;TicketID=$TicketID");

        $Selenium->find_element( "#Subject",  'css' )->send_keys("Subject Test");
        $Selenium->find_element( "#RichText", 'css' )->send_keys("RichText Test");

        # Set next ticket state to pending reminder.
        $Selenium->InputFieldValueSet(
            Element => '#NextStateID',
            Value   => 6,
        );

        $Selenium->find_element( "#submitRichText", 'css' )->click();

        # Check if pending date has error class.
        $Self->Is(
            $Selenium->execute_script("return \$('#Day').hasClass('Error')"),
            '1',
            'Day has error class as it should.',
        );

        # Set next ticket state to open.
        $Selenium->InputFieldValueSet(
            Element => '#NextStateID',
            Value   => 4,
        );

        $Selenium->WaitFor(
            JavaScript => "return !\$('#Day.Validate_DateInFuture').length;"
        );

        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # Verify URL is redirected to AgentTicketZoom, successfully submitted AgentTicketPhoneInbound.
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' &&  \$('#ArticleTree').length;"
        );
        $Self->True(
            $Selenium->get_current_url() =~ /Action=AgentTicketZoom;TicketID=$TicketID/,
            "Current URL after AgentTicketPhoneInbound 'Submit' button click is correct"
        );

        # delete created test ticket
        my $Success = $TicketObject->TicketDelete(
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
            "Ticket with ticket ID $TicketID is deleted"
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
