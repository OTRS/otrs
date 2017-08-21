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

# Get selenium object.
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Disable check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Disable RichText control.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Set to change queue for ticket in a new window.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::MoveType',
            Value => 'link'
        );

        # Enable FormDraft in AgentTicketMove screen.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => "Ticket::Frontend::AgentTicketMove###FormDraft",
            Value => 1
        );

        # Get ticket object.
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Test Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => 'SeleniumCustomer@localhost.com',
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket ID $TicketID is created",
        );

        # Get RandomID.
        my $RandomID = $Helper->GetRandomID();

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get script alias.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Create test fields for FormDraft.
        my $Title         = 'MoveFormDraft' . $RandomID;
        my $FormDraftCase = {
            Module => 'Move',
            Fields => {
                Queue => {
                    ID     => 'DestQueueID',
                    Value  => 1,
                    Update => 3,
                },
                State => {
                    ID     => 'NewStateID',
                    Value  => '',
                    Update => 3,
                },
            },
        };

        # Click on Queue and switch window.
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentTicket$FormDraftCase->{Module};TicketID=$TicketID' )]"
        )->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#submitRichText").length;'
        );

        # Select FormDraft values.
        for my $Field ( sort keys %{ $FormDraftCase->{Fields} } ) {
            $Selenium->execute_script(
                "\$('#$FormDraftCase->{Fields}->{$Field}->{ID}').val('$FormDraftCase->{Fields}->{$Field}->{Value}').trigger('redraw.InputField').trigger('change');"
            );
        }

        # Create FormDraft and submit.
        $Selenium->find_element( "#FormDraftSave", 'css' )->VerifiedClick();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#FormDraftTitle").length;'
        );
        $Selenium->find_element( "#FormDraftTitle", 'css' )->send_keys($Title);
        $Selenium->find_element( "#SaveFormDraft",  'css' )->click();

        # Switch back window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Verify FormDraft is created in zoom screen.
        $Self->True(
            index( $Selenium->get_page_source(), $Title ) > -1,
            "FormDraft for $FormDraftCase->{Module} $Title is found",
        );

        # Try to create identical FormDraft to check for error.
        $Selenium->find_element( "Queue", 'link_text' )->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#submitRichText").length;'
        );

        # Select FormDraft values.
        for my $Field ( sort keys %{ $FormDraftCase->{Fields} } ) {
            $Selenium->execute_script(
                "\$('#$FormDraftCase->{Fields}->{$Field}->{ID}').val('$FormDraftCase->{Fields}->{$Field}->{Value}').trigger('redraw.InputField').trigger('change');"
            );

        }

        # Try to create FormDraft with same name, expecting error.
        $Selenium->find_element( "#FormDraftSave", 'css' )->VerifiedClick();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#FormDraftTitle").length;'
        );
        $Selenium->find_element( "#FormDraftTitle", 'css' )->send_keys($Title);
        $Selenium->find_element( "#SaveFormDraft",  'css' )->click();

        # Wait for alert dialog to appear.
        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert not found';

        # Check alert dialog message.
        my $ExpectedAlertText = "FormDraft name $Title is already in use!";
        $Self->True(
            ( $Selenium->get_alert_text() =~ /$ExpectedAlertText/ ),
            "Check alert message text.",
        );

        # Accept alert.
        $Selenium->accept_alert();

        # Close screen and switch back window.
        $Selenium->close();

        # Switch back window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Get article object.
        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Phone' );

        # Create test email Article.
        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'customer',
            Subject              => "Article $FormDraftCase->{Module} OutDate FormDraft trigger",
            Body                 => 'Selenium body article',
            Charset              => 'ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'AddNote',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
            IsVisibleForCustomer => 1,
        );
        $Self->True(
            $ArticleID,
            "Article ID $ArticleID is created",
        );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Click on test created FormDraft and switch window.
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentTicket$FormDraftCase->{Module};TicketID=$TicketID;LoadFormDraft=1' )]"
        )->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#submitRichText").length;'
        );

        # Make sure that outdated notification is present.
        $Self->True(
            index( $Selenium->get_page_source(), "You have loaded the draft \"$Title\"" ) > 0,
            'Draft loaded notification is present',
        );

        # Make sure that outdated notification is present.
        $Self->True(
            index(
                $Selenium->get_page_source(),
                "Please note that this draft is outdated because the ticket was modified since this draft was created."
                ) > 0,
            'Outdated notification is present',
        );

        # Verify FormDraft values.
        for my $FieldValue ( sort keys %{ $FormDraftCase->{Fields} } ) {
            $Self->Is(
                $Selenium->execute_script("return \$('#$FormDraftCase->{Fields}->{$FieldValue}->{ID}').val()"),
                $FormDraftCase->{Fields}->{$FieldValue}->{Value},
                "Initial FormDraft value for $FormDraftCase->{Module} field $FieldValue is correct"
            );

            $Selenium->execute_script(
                "\$('#$FormDraftCase->{Fields}->{$FieldValue}->{ID}').val('$FormDraftCase->{Fields}->{$FieldValue}->{Update}').trigger('redraw.InputField').trigger('change');"
            );
        }

        $Selenium->find_element( "#FormDraftUpdate", 'css' )->click();

        # Switch back window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Click on test created FormDraft and switch window.
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentTicket$FormDraftCase->{Module};TicketID=$TicketID;LoadFormDraft=1' )]"
        )->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#submitRichText").length;'
        );

        # Verify updated FormDraft values.
        for my $FieldValue ( sort keys %{ $FormDraftCase->{Fields} } ) {
            $Self->Is(
                $Selenium->execute_script("return \$('#$FormDraftCase->{Fields}->{$FieldValue}->{ID}').val()"),
                $FormDraftCase->{Fields}->{$FieldValue}->{Update},
                "Updated FormDraft value for $FormDraftCase->{Module} field $FieldValue is correct"
            );
        }

        $Selenium->close();

        # switch back window
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Delete draft
        $Selenium->find_element( ".FormDraftDelete", 'css' )->VerifiedClick();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#DeleteConfirm").length;'
        );
        $Selenium->find_element( "#DeleteConfirm", 'css' )->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".FormDraftDelete").length==0;'
        ) || die 'FormDraft was not deleted!';

        # Wait until all current AJAX requests have completed, before cleaning up test entities. Otherwise, it could
        #   happen some asynchronous calls prevent entries from being deleted by running into race conditions.
        #   jQuery property $.active contains number of active AJAX calls on the page.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $.active === 0' );

        # Delete created test ticket.
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket ID $TicketID is deleted"
        );
    }
);

1;
