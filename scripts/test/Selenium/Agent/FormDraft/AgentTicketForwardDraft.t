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

        # Enable FormDraft in AgentTicketForward screen.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => "Ticket::Frontend::AgentTicketForward###FormDraft",
            Value => 1,
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Get RandomID.
        my $RandomID = $Helper->GetRandomID();

        # Create test customer.
        my $TestCustomer       = 'Customer' . $RandomID;
        my $TestCustomerUserID = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestCustomer,
            UserLastname   => $TestCustomer,
            UserCustomerID => $TestCustomer,
            UserLogin      => $TestCustomer,
            UserEmail      => "$TestCustomer\@localhost.com",
            ValidID        => 1,
            UserID         => 1,
        );
        $Self->True(
            $TestCustomerUserID,
            "CustomerUserID $TestCustomerUserID is created",
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

        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $ArticleEmailChannelObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

        # Create test email Article.
        my $ArticleID = $ArticleEmailChannelObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'customer',
            Subject              => 'some short description',
            Body                 => 'the message text',
            Charset              => 'ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'EmailCustomer',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
            IsVisibleForCustomer => 1,
        );
        $Self->True(
            $ArticleID,
            "ArticleID $ArticleID is created",
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

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Expand article details.
        $Selenium->find_element( '.WidgetAction.Expand', 'css' )->click();

        # Create test fields for FormDraft.
        my $Title         = 'ForwardFormDraft' . $RandomID;
        my $FormDraftCase = {
            Module => 'Forward',
            Fields => {
                To => {
                    ID     => 'ToCustomer',
                    Type   => 'AutoComplete',
                    Value  => $TestCustomer,
                    Update => 3,
                },
                Body => {
                    ID     => 'RichText',
                    Type   => 'Input',
                    Value  => 'Selenium Forward Body',
                    Update => 'Selenium Forward Body - Update',
                },
                Attachments => {
                    ID   => 'FileUpload',
                    Type => 'Attachment',
                },
            },
        };

        # Click on Forward and switch window.
        $Selenium->find_element( "Forward", 'link_text' )->click();

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
            if ( $FormDraftCase->{Fields}->{$Field}->{Type} eq 'AutoComplete' ) {

                $Selenium->find_element( "#$FormDraftCase->{Fields}->{$Field}->{ID}", 'css' )->send_keys($TestCustomer);
                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('li.ui-menu-item:contains($TestCustomer):visible').length"
                );
                $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCustomer)').click()");

            }
            elsif ( $FormDraftCase->{Fields}->{$Field}->{Type} eq 'Attachment' ) {

                # Make the file upload field visible.
                $Selenium->execute_script(
                    "\$('#FileUpload').css('display', 'block')"
                );

                # Upload a file.
                $Selenium->find_element( "#FileUpload", 'css' )
                    ->send_keys( $ConfigObject->Get('Home') . "/scripts/test/sample/Main/Main-Test1.pdf" );

                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('.AttachmentList tbody tr td.Filename:contains(Main-Test1.pdf)').length === 1;"
                );

                # Check if uploaded.
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('.AttachmentList tbody tr td.Filename:contains(Main-Test1.pdf)').length === 1"
                    ),
                    "Uploaded file 'Main-Test1.pdf' correctly"
                );

            }
            else {
                $Selenium->find_element( "#$FormDraftCase->{Fields}->{$Field}->{ID}", 'css' )->clear();
                $Selenium->find_element( "#$FormDraftCase->{Fields}->{$Field}->{ID}", 'css' )
                    ->send_keys( $FormDraftCase->{Fields}->{$Field}->{Value} );
            }
        }

        # Create FormDraft and submit.
        $Selenium->find_element( "#FormDraftSave", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#FormDraftTitle").length;'
        );
        $Selenium->find_element( "#FormDraftTitle", 'css' )->send_keys($Title);
        $Selenium->find_element( "#SaveFormDraft",  'css' )->click();

        # Switch back to main window.
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
        $Selenium->find_element( "Forward", 'link_text' )->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#submitRichText").length;'
        );

        # Try to create FormDraft with same name, expecting error.
        $Selenium->find_element( "#FormDraftSave", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#FormDraftTitle").length;'
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

        # Close screen and switch back to the main window.
        $Selenium->close();
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        my $ArticlePhoneChannelObject = $ArticleObject->BackendForChannel( ChannelName => 'Phone' );

        # Create test Article to trigger that draft is outdated.
        $ArticleID = $ArticlePhoneChannelObject->ArticleCreate(
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
                'return typeof($) === "function" && $("#submitRichText").length;'
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

            if ( $FormDraftCase->{Fields}->{$FieldValue}->{Type} eq 'Input' ) {

                $Self->Is(
                    $Selenium->execute_script("return \$('#$FormDraftCase->{Fields}->{$FieldValue}->{ID}').val()"),
                    $FormDraftCase->{Fields}->{$FieldValue}->{Value},
                    "Initial FormDraft value for $FormDraftCase->{Module} field $FieldValue is correct"
                );

                $Selenium->find_element( "#$FormDraftCase->{Fields}->{$FieldValue}->{ID}", 'css' )->clear();
                $Selenium->find_element( "#$FormDraftCase->{Fields}->{$FieldValue}->{ID}", 'css' )
                    ->send_keys( $FormDraftCase->{Fields}->{$FieldValue}->{Update} );
            }
            elsif ( $FormDraftCase->{Fields}->{$FieldValue}->{Type} eq 'Attachment' ) {

                # Wait until field has loaded, if necessary.
                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('.AttachmentList tbody tr td.Filename').length === 1;"
                );

                # There should be only one file with a certain name.
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('.AttachmentList tbody tr td.Filename:contains(Main-Test1.pdf)').length === 1"
                    ),
                    "Uploaded file 'Main-Test1.pdf' correctly"
                );
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('.AttachmentList tbody tr td.Filename').length === 1"
                    ),
                    "Only one file present"
                );

                # Add a second file.
                $Selenium->execute_script(
                    "\$('#FileUpload').css('display', 'block')"
                );

                # Upload a file.
                $Selenium->find_element( "#FileUpload", 'css' )
                    ->send_keys( $ConfigObject->Get('Home') . "/scripts/test/sample/Main/Main-Test1.doc" );

                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('.AttachmentList tbody tr td.Filename:contains(Main-Test1.doc)').length === 1;"
                );

                # Check if uploaded.
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('.AttachmentList tbody tr td.Filename:contains(Main-Test1.doc)').length === 1"
                    ),
                    "Uploaded file 'Main-Test1.doc' correctly"
                );
            }
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
        )->click();

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
            if ( $FormDraftCase->{Fields}->{$FieldValue}->{Type} eq 'Input' ) {

                my $ID           = $FormDraftCase->{Fields}->{$FieldValue}->{ID};
                my $UpdatedValue = $FormDraftCase->{Fields}->{$FieldValue}->{Update};

                # Wait until input field has loaded, if necessary.
                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('#$ID').val() == '$UpdatedValue';"
                );

                $Self->Is(
                    $Selenium->execute_script("return \$('#$ID').val()"),
                    $UpdatedValue,
                    "Updated FormDraft value for $FormDraftCase->{Module} field $FieldValue is correct"
                );
            }
            elsif ( $FormDraftCase->{Fields}->{$FieldValue}->{Type} eq 'Attachment' ) {

                # Wait until input field has loaded, if necessary.
                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('.AttachmentList tbody tr td.Filename').length === 2;"
                );

                # there should be two files now
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('.AttachmentList tbody tr td.Filename').length === 2"
                    ),
                    "Uploaded file correctly"
                );
            }
        }

        $Selenium->close();
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

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

        # Delete test created customer.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        $TestCustomer = $DBObject->Quote($TestCustomer);
        $Success      = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$TestCustomer ],
        );
        $Self->True(
            $Success,
            "Delete customer user - $TestCustomer",
        );

        # Make sure the cache is correct.
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        for my $Cache (qw(Ticket Article CustomerUser)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
