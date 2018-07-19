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

use Kernel::Language;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Disable check of email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Disable the rich text control.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Disable RequiredLock for AgentTicketEmailResend.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketEmailResend###RequiredLock',
            Value => 0,
        );

        # Use test email backend for duration of the test.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::DoNotSendEmail',
        );

        my $RandomID = $Helper->GetRandomID();

        # Create test customer user.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
            Groups   => ['admin'],
            Language => 'en',
        ) || die 'Did not get test customer user';

        # Get test customer user data.
        my %TestCustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $TestCustomerUserLogin,
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium ticket',
            QueueID      => 1,
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => $TestCustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID"
        );

        my $ArticleBackendObject
            = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel( ChannelName => 'Email' );

        # Create test email article.
        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 1,
            SenderType           => 'customer',
            Subject              => 'some short description',
            Body                 => 'the message text',
            From           => "\"$TestCustomerUserLogin $TestCustomerUserLogin\" <$TestCustomerUserData{UserEmail}>",
            To             => 'Some Agent A <agent-a@example.com>',
            Charset        => 'ISO-8859-15',
            MimeType       => 'text/plain',
            HistoryType    => 'EmailCustomer',
            HistoryComment => 'Some free text!',
            UserID         => 1,
        );
        $Self->True(
            $ArticleID,
            "Article is created - ID $ArticleID"
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to created test ticket in AgentTicketZoom screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Click on Reply, we should try to send an email first.
        $Selenium->execute_script(
            "\$('#ResponseID$ArticleID').val('1').trigger('redraw.InputField').trigger('change');"
        );

        # Switch to compose window.
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#CustomerTicketText_1").length == 1;'
        );

        # Input several fields and submit compose.
        my %ComposeData = (
            ToCustomer  => "\"$TestCustomerUserLogin $TestCustomerUserLogin\" <$TestCustomerUserData{UserEmail}>",
            CcCustomer  => 'cc@example.com',
            BccCustomer => 'bcc@example.com',
            RichText    => 'Selenium Compose Text',
            FileUpload  => 'StdAttachment-Test1.txt',
        );
        FIELD:
        for my $Field ( sort keys %ComposeData ) {

            # Skip 'To' field, it's already set to correct customer by compose screen.
            next FIELD if $Field eq 'ToCustomer';

            my $Value = $ComposeData{$Field};

            if ( $Field eq 'FileUpload' ) {
                $Value = $Kernel::OM->Get('Kernel::Config')->Get('Home')
                    . "/scripts/test/sample/StdAttachment/$ComposeData{$Field}";

                # It's necessary to hide drag&drop upload and show input field.
                $Selenium->execute_script(
                    "\$('.DnDUpload').css('display', 'none')"
                );
                $Selenium->execute_script(
                    "\$('#FileUpload').css('display', 'block')"
                );
            }

            $Selenium->find_element( "#$Field", 'css' )->clear();
            $Selenium->find_element( "#$Field", 'css' )->send_keys($Value);

            # Lose the focus.
            $Selenium->find_element( 'body', 'css' )->click();

            next FIELD if $Field eq 'RichText';

            if ( $Field eq 'FileUpload' ) {
                $Selenium->WaitFor(
                    JavaScript =>
                        "return \$('.AttachmentList tbody tr td.Filename:contains($ComposeData{$Field})').length;"
                );
            }
            else {
                $Selenium->WaitFor(
                    JavaScript => "return typeof(\$) === 'function' && \$('#${Field}TicketText_1').length;"
                );
            }
        }

        $Selenium->find_element( '#submitRichText', 'css' )->click();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function";' );

        # Verify transmission status is shown as processing.
        $Self->Is(
            $Selenium->execute_script("return \$('#Row2 td.Channel span i.Warning').length;"),
            1,
            'Transmission status is shown as processing'
        );

        # Check if transmission processing message is shown.
        my $DisplayedTransmissionMessage = $Selenium->find_element( '.WidgetMessage.Top.Warning', 'css' )->get_text();
        $Self->True(
            ( $DisplayedTransmissionMessage =~ /This message has been queued for sending./ ) || 0,
            'Transmission processing message displayed correctly (1)'
        );

        # Verify css is correct for collapsed article widget.
        $Self->False(
            $Selenium->execute_script("return \$('.WidgetMenu').hasClass('SpacingBottom');"),
            "CSS is correct for collapsed article widget."
        );

        # Click to expand article widget information and verify css.
        $Selenium->find_element( '.WidgetAction.Expand', 'css' )->click();
        $Self->True(
            $Selenium->execute_script("return \$('.WidgetMenu').hasClass('SpacingBottom');"),
            "CSS is correct for expanded article widget."
        );

        # Get article ID of last message.
        my $ComposeArticleID = int $Selenium->execute_script("return \$('#Row2 td.No input.ArticleID').val();");
        $Self->True(
            $ComposeArticleID,
            "Found article ID of last message $ComposeArticleID"
        );

        # Introduce temporary error to mail queue entry, and check if processing message reflects that.
        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        $DateTimeObject->Add( Hours => 1 );
        my $Result = $Kernel::OM->Get('Kernel::System::MailQueue')->Update(
            Filters => {
                ArticleID => $ComposeArticleID,
            },
            Data => {
                Attempts => 1,
                DueTime  => $DateTimeObject->ToString(),
            },
        );
        $Self->True(
            $Result,
            'Introduce temporary error to mail queue entry'
        );

        $Selenium->VerifiedRefresh();

        # Verify transmission status is still shown as processing.
        $Self->Is(
            $Selenium->execute_script("return \$('#Row2 td.Channel span i.Warning').length;"),
            1,
            'Transmission status is still shown as processing'
        );

        # Check if transmission processing message contains information about temporary error.
        my $ProcessingMessage = sprintf(
            'This message is being processed. Already tried to send %s time(s). Next try will be %s.',
            '1',
            $DateTimeObject->Format( 'Format' => '%m/%d/%Y %H:%M' ),
        );
        my $DisplayedProcessingMessage = $Selenium->find_element( '.WidgetMessage.Top.Warning', 'css' )->get_text();

        $Self->True(
            ( $DisplayedProcessingMessage =~ /\Q$ProcessingMessage\E/ ) || 0,
            'Transmission processing message displayed correctly (2)'
        );

        # Manually create transmission error.
        my $ErrorMessage = 'Something went wrong';
        $Result = $ArticleBackendObject->ArticleCreateTransmissionError(
            ArticleID => $ComposeArticleID,
            Message   => $ErrorMessage,
        );
        $Self->True(
            $Result,
            'Manually create transmission error'
        );

        $Selenium->VerifiedRefresh();

        # Verify transmission status is shown as error.
        $Self->Is(
            $Selenium->execute_script("return \$('#Row2 td.Channel span i.Error').length;"),
            1,
            'Transmission status is shown as error'
        );

        # Check if transmission error message is shown.
        my $DisplayedErrorMessage = $Selenium->find_element( '.WidgetMessage.Top.Error', 'css' )->get_text();
        $Self->True(
            ( $DisplayedErrorMessage =~ /Sending of this message has failed./ ) || 0,
            'Transmission error message displayed correctly (1)'
        );
        $Self->True(
            ( $DisplayedErrorMessage =~ /\Q$ErrorMessage\E/ ) || 0,
            'Transmission error message displayed correctly (2)'
        );

        # Check for existence of resend action.
        $Selenium->find_element("//a[text()='Resend']")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function";'
        );

        # Check field values.
        for my $Field ( sort keys %ComposeData ) {
            my $Selector = $Field;

            # Text body.
            if ( $Field eq 'RichText' ) {
                $Self->Is(
                    $Selenium->find_element( "#$Selector", 'css' )->get_value(),
                    $ComposeData{$Field},
                    "Value for '$Field'"
                );
            }

            # Attachment.
            elsif ( $Field eq 'FileUpload' ) {
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('.AttachmentList tbody tr td.Filename:contains($ComposeData{$Field})').length;"
                    ),
                    "Value for '$Field'"
                );
            }

            # Recipient fields.
            else {

                # Special case for 'To' field.
                if ( $Field eq 'ToCustomer' ) {
                    $Selector =~ s{^To}{}x;
                }

                $Self->Is(
                    $Selenium->find_element( "#${Selector}TicketText_1", 'css' )->get_value(),
                    $ComposeData{$Field},
                    "Value for '$Field'"
                );
            }
        }

        # Remove all recipients.
        for my $Field (qw(RemoveCustomer CcRemoveCustomer BccRemoveCustomer)) {
            $Selenium->find_element( "#${Field}Ticket_1", 'css' )->click();
        }

        # Add a single 'To' recipient.
        my $ToCustomer = 'to@example.com';
        $Selenium->find_element( '#ToCustomer', 'css' )->send_keys($ToCustomer);
        $Selenium->find_element( 'body',        'css' )->click();

        $Selenium->execute_script("\$('#submitRichText').click();");

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function";' );

        # Verify transmission status is shown as processing.
        $Self->Is(
            $Selenium->execute_script("return \$('#Row3 td.Channel span i.Warning').length;"),
            1,
            'Transmission status is shown as processing'
        );

        # Check if transmission processing message is shown.
        $DisplayedTransmissionMessage = $Selenium->find_element( '.WidgetMessage.Top.Warning', 'css' )->get_text();
        $Self->True(
            ( $DisplayedTransmissionMessage =~ /This message has been queued for sending./ ) || 0,
            'Transmission processing message displayed correctly (2)'
        );

        # Verify message log details button is shown.
        $Selenium->find_element( 'Message Log', 'link_text' );

        # Expand sub-menus in order to be able to click one of the links.
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");

        $Selenium->find_element("//*[text()='History']")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length' );

        # Verify that resend screen worked as expected.
        my $HistoryText = "Resent email to \"$ToCustomer\".";
        $Self->True(
            index( $Selenium->get_page_source(), $HistoryText ) > -1,
            'Email resent correctly'
        );

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
            "Ticket with ticket ID $TicketID is deleted"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

1;
