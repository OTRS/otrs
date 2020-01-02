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

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "a[title='Change Queue']",
        );

        # Click on 'Move' and switch window.
        $Selenium->find_element("//a[\@title='Change Queue']")->click();

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
            my $ID    = $FormDraftCase->{Fields}->{$Field}->{ID};
            my $Value = $FormDraftCase->{Fields}->{$Field}->{Value};

            $Selenium->InputFieldValueSet(
                Element => "#$ID",
                Value   => $Value,
            );
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#$ID').val() == '$Value'"
            );
            sleep 2;
        }

        # Create FormDraft and submit.
        $Selenium->execute_script("\$('#FormDraftSave').click();");
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#FormDraftTitle").length && $("#SaveFormDraft").length;'
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
            $Selenium->execute_script("return \$('.DraftName:contains($Title)').length === 1"),
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
                'return typeof($) === "function" && $("#FormDraftSave").length;'
        );

        # Select FormDraft values.
        for my $Field ( sort keys %{ $FormDraftCase->{Fields} } ) {
            my $ID    = $FormDraftCase->{Fields}->{$Field}->{ID};
            my $Value = $FormDraftCase->{Fields}->{$Field}->{Value};

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#$ID').length"
            );
            $Selenium->InputFieldValueSet(
                Element => "#$ID",
                Value   => $Value,
            );
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#$ID').val() == '$Value'"
            );
            sleep 2;
        }

        # Try to create FormDraft with same name, expecting error.
        $Selenium->execute_script("\$('#FormDraftSave').click();");
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#FormDraftTitle").length && $("#SaveFormDraft").length;'
        );
        $Selenium->find_element( "#FormDraftTitle", 'css' )->send_keys($Title);
        $Selenium->find_element( "#SaveFormDraft",  'css' )->click();

        # Wait for alert dialog to appear.
        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert not found';

        # Check alert dialog message.
        $Self->True(
            index( $Selenium->get_alert_text(), "FormDraft name $Title is already in use!" ) > -1,
            "Check alert message text.",
        );

        # Accept alert.
        $Selenium->accept_alert();
        sleep 1;

        # Close screen and switch back window.
        $Selenium->close();
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
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
        )->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#FormDraftUpdate").length;'
        );

        # Make sure that draft loaded notification is present.
        $Self->True(
            index( $Selenium->get_page_source(), "You have loaded the draft \"$Title\"" ) > -1,
            'Draft loaded notification is present',
        );

        # Make sure that outdated notification is present.
        $Self->True(
            index(
                $Selenium->get_page_source(),
                "Please note that this draft is outdated because the ticket was modified since this draft was created."
            ) > -1,
            'Outdated notification is present',
        );

        # Verify FormDraft values.
        for my $FieldValue ( sort keys %{ $FormDraftCase->{Fields} } ) {

            my $ID     = $FormDraftCase->{Fields}->{$FieldValue}->{ID};
            my $Value  = $FormDraftCase->{Fields}->{$FieldValue}->{Value};
            my $Update = $FormDraftCase->{Fields}->{$FieldValue}->{Update};

            $Self->Is(
                $Selenium->execute_script("return \$('#$ID').val()"),
                $Value,
                "Initial FormDraft value for $FormDraftCase->{Module} field $FieldValue is correct - $Value"
            );

            $Selenium->InputFieldValueSet(
                Element => "#$ID",
                Value   => $Update,
            );
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#$ID').val() == '$Update'"
            );
            sleep 2;
        }

        $Selenium->find_element( "#FormDraftUpdate", 'css' )->click();

        # Switch back window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('a[href*=\"Action=AgentTicket$FormDraftCase->{Module};TicketID=$TicketID;LoadFormDraft=1\"]').length"
        );

        # Click on test created FormDraft and switch window.
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentTicket$FormDraftCase->{Module};TicketID=$TicketID;LoadFormDraft=1' )]"
        )->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has completely loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

        # Wait until input field object has completely loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.UI) == "object" && Core.UI.InputFields'
        );

        # Verify updated FormDraft values.
        for my $FieldValue ( sort keys %{ $FormDraftCase->{Fields} } ) {

            my $ID           = $FormDraftCase->{Fields}->{$FieldValue}->{ID};
            my $UpdatedValue = $FormDraftCase->{Fields}->{$FieldValue}->{Update};

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#$ID').val() == $UpdatedValue;"
            );

            $Self->Is(
                $Selenium->execute_script("return \$('#$ID').val()"),
                $UpdatedValue,
                "Updated FormDraft value for $FormDraftCase->{Module} field $FieldValue is correct - $UpdatedValue"
            );
        }

        # Close and switch back to main window.
        $Selenium->close();
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Delete draft.
        $Selenium->find_element( ".FormDraftDelete", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#DeleteConfirm").length;'
        );
        $Selenium->find_element( "#DeleteConfirm", 'css' )->click();

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".FormDraftDelete").length == 0;'
        ) || die 'FormDraft was not deleted!';

        # Delete created test ticket.
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
            "Ticket ID $TicketID is deleted"
        );

        # Make sure the cache is correct.
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        for my $Cache (qw(Ticket Article)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
