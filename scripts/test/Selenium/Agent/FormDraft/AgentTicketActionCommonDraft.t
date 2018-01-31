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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Hide Fred.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Fred::Active',
            Value => 0
        );

        # Enable Responsible feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => "Ticket::Responsible",
            Value => 1
        );

        # Enable Drafts in AgentTicketActionCommon screens.
        for my $SysConfig (qw(Priority Owner Note FreeText Pending Close Responsible)) {
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => "Ticket::Frontend::AgentTicket${SysConfig}###FormDraft",
                Value => 1
            );
        }

        # Enable NoteMandatory for AgentTicketOwner and AgentTicketResponsible screen.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => "Ticket::Frontend::AgentTicketOwner###NoteMandatory",
            Value => 1
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => "Ticket::Frontend::AgentTicketResponsible###NoteMandatory",
            Value => 1
        );

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

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $ScriptAlias  = $ConfigObject->Get('ScriptAlias');

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Create test case matrix.
        my @Tests = (
            {
                Module => 'Priority',
                Fields => {
                    Priority => {
                        ID     => 'NewPriorityID',
                        Type   => 'DropDown',
                        Value  => 1,
                        Update => 2,
                    },
                    Subject => {
                        ID     => 'Subject',
                        Type   => 'Input',
                        Value  => 'Selenium Priority Subject',
                        Update => 'Selenium Priority Subject - Update'
                    },
                    Body => {
                        ID     => 'RichText',
                        Type   => 'RichText',
                        Value  => 'Selenium Priority Body',
                        Update => 'Selenium Priority Body - Update',
                    },
                    Attachments => {
                        ID   => 'FileUpload',
                        Type => 'Attachment',
                    },
                },
            },

            {
                Module => 'Note',
                Fields => {
                    Subject => {
                        ID     => 'Subject',
                        Type   => 'Input',
                        Value  => 'Selenium Note Subject',
                        Update => 'Selenium Note Subject - Update'
                    },
                    Body => {
                        ID     => 'RichText',
                        Type   => 'RichText',
                        Value  => 'Selenium Note Body',
                        Update => 'Selenium Note Body - Update',
                    },
                    Attachments => {
                        ID   => 'FileUpload',
                        Type => 'Attachment',
                    },
                },
            },
            {
                Module => 'Close',
                Fields => {
                    State => {
                        ID     => 'NewStateID',
                        Type   => 'DropDown',
                        Value  => 2,
                        Update => 3,
                    },
                    Subject => {
                        ID     => 'Subject',
                        Type   => 'Input',
                        Value  => 'Selenium Close Subject',
                        Update => 'Selenium Close Subject - Update'
                    },
                    Body => {
                        ID     => 'RichText',
                        Type   => 'RichText',
                        Value  => 'Selenium Close Body',
                        Update => 'Selenium Close Body - Update',
                    },
                    Attachments => {
                        ID   => 'FileUpload',
                        Type => 'Attachment',
                    },
                },
            },
            {
                Module => 'Pending',
                Fields => {
                    State => {
                        ID     => 'NewStateID',
                        Type   => 'DropDown',
                        Value  => 7,
                        Update => 8,
                    },
                    Subject => {
                        ID     => 'Subject',
                        Type   => 'Input',
                        Value  => 'Selenium Pending Subject',
                        Update => 'Selenium Pending Subject - Update'
                    },
                    Body => {
                        ID     => 'RichText',
                        Type   => 'RichText',
                        Value  => 'Selenium Pending Body',
                        Update => 'Selenium Pending Body - Update',
                    },
                    Attachments => {
                        ID   => 'FileUpload',
                        Type => 'Attachment',
                    },
                },
            },
            {
                Module => 'Owner',
                Fields => {
                    Subject => {
                        ID     => 'Subject',
                        Type   => 'Input',
                        Value  => 'Selenium Owner Subject',
                        Update => 'Selenium Owner Subject - Update'
                    },
                    Body => {
                        ID     => 'RichText',
                        Type   => 'RichText',
                        Value  => 'Selenium Owner Body',
                        Update => 'Selenium Owner Body - Update',
                    },
                    Attachments => {
                        ID   => 'FileUpload',
                        Type => 'Attachment',
                    },
                },
            },
            {
                Module => 'Responsible',
                Fields => {
                    Title => {
                        ID     => 'Title',
                        Type   => 'Input',
                        Value  => 'Selenium Responsible Title',
                        Update => 'Selenium Responsible Title - Update'
                    },
                    Subject => {
                        ID     => 'Subject',
                        Type   => 'Input',
                        Value  => 'Selenium Responsible Subject',
                        Update => 'Selenium Responsible Subject - Update'
                    },
                    Body => {
                        ID     => 'RichText',
                        Type   => 'RichText',
                        Value  => 'Selenium Responsible Body',
                        Update => 'Selenium Responsible Body - Update',
                    },
                    Attachments => {
                        ID   => 'FileUpload',
                        Type => 'Attachment',
                    },
                },
            },
            {
                Module => 'FreeText',
                Fields => {
                    Title => {
                        ID     => 'Title',
                        Type   => 'Input',
                        Value  => 'Selenium FreeText Title',
                        Update => 'Selenium FreeText Title - Update'
                    },
                },
            },
        );

        # Execute test scenarios.
        my $Handles;
        for my $Test (@Tests) {

            # Create Draft name.
            my $Title = $Test->{Module} . 'Draft' . $RandomID;

            # Force sub menus to be visible in order to be able to click one of the links.
            if ( $Test->{Module} eq 'Note' ) {
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && $("#nav-Communication ul").css({ "height": "auto", "opacity": "100" });'
                );
            }
            elsif ( $Test->{Module} eq 'Owner' || $Test->{Module} eq 'Responsible' ) {
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && $("#nav-People ul").css({ "height": "auto", "opacity": "100" });'
                );
            }
            elsif ( $Test->{Module} eq 'FreeText' ) {
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && $("#nav-Miscellaneous ul").css({ "height": "auto", "opacity": "100" });'
                );
            }

            # Click on module and switch window.
            $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicket$Test->{Module};TicketID=$TicketID' )]")
                ->click();

            $Selenium->WaitFor( WindowCount => 2 );
            $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[1] );

            # Wait until page has loaded, if necessary.
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $(".WidgetSimple").length;'
            );

            # Input fields.
            for my $Field ( sort keys %{ $Test->{Fields} } ) {

                if ( $Test->{Fields}->{$Field}->{Type} eq 'DropDown' ) {
                    $Selenium->WaitFor(
                        JavaScript =>
                            "return typeof(\$) === 'function' && \$('#$Test->{Fields}->{$Field}->{ID}').length"
                    );

                    $Selenium->execute_script(
                        "\$('#$Test->{Fields}->{$Field}->{ID}').val('$Test->{Fields}->{$Field}->{Value}').trigger('redraw.InputField').trigger('change');"
                    );
                }
                elsif ( $Test->{Fields}->{$Field}->{Type} eq 'Attachment' ) {

                    # make the file upload field visible
                    $Selenium->execute_script(
                        "\$('#FileUpload').css('display', 'block')"
                    );

                    # upload a file
                    $Selenium->find_element( "#FileUpload", 'css' )
                        ->send_keys( $ConfigObject->Get('Home') . "/scripts/test/sample/Main/Main-Test1.pdf" );

                    $Selenium->WaitFor(
                        JavaScript =>
                            "return typeof(\$) === 'function' && \$('.AttachmentList tbody tr td.Filename:contains(Main-Test1.pdf)').length === 1"
                    );

                    # Check if uploaded.
                    $Self->Is(
                        $Selenium->execute_script(
                            "return \$('.AttachmentList tbody tr td.Filename:contains(Main-Test1.pdf)').length"
                        ),
                        1,
                        $Test->{Module} . " - Uploaded file correctly"
                    );
                }
                elsif ( $Test->{Fields}->{$Field}->{Type} eq 'RichText' ) {

                    # wait for the CKE to load
                    $Selenium->WaitFor(
                        JavaScript =>
                            "return \$('body.cke_editable', \$('.cke_wysiwyg_frame').contents()).length == 1"
                    );

                    $Selenium->execute_script(
                        "return CKEDITOR.instances.RichText.setData('$Test->{Fields}->{$Field}->{Value}');"
                    );

                    $Selenium->execute_script(
                        "return CKEDITOR.instances.RichText.updateElement();"
                    );
                }
                else {
                    $Selenium->WaitFor(
                        JavaScript =>
                            "return typeof(\$) === 'function' && \$('#$Test->{Fields}->{$Field}->{ID}').length"
                    );

                    $Selenium->find_element( "#$Test->{Fields}->{$Field}->{ID}", 'css' )->clear();
                    $Selenium->find_element( "#$Test->{Fields}->{$Field}->{ID}", 'css' )
                        ->send_keys( $Test->{Fields}->{$Field}->{Value} );
                }
            }

            # Create Draft and submit.
            $Selenium->find_element( "#FormDraftSave", 'css' )->click();
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

            # Verify Draft is created in zoom screen.
            $Self->True(
                index( $Selenium->get_page_source(), $Title ) > -1,
                "Draft for $Test->{Module} $Title is found",
            );

            my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
            my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Phone' );

            # Create test Article to trigger that draft is outdated.
            my $ArticleID = $ArticleBackendObject->ArticleCreate(
                TicketID             => $TicketID,
                IsVisibleForCustomer => 1,
                SenderType           => 'customer',
                Subject              => "Article $Test->{Module} OutDate Draft trigger",
                Body                 => 'Selenium body article',
                MimeType             => 'text/plain',
                Charset              => 'ISO-8859-15',
                UserID               => 1,
                HistoryType          => 'AddNote',
                HistoryComment       => 'Some free text!',
            );

            $Self->True(
                $ArticleID,
                "Article ID $ArticleID is created",
            );

            # Refresh screen.
            $Selenium->VerifiedRefresh();

            # Click on test created Draft and switch window.
            $Selenium->find_element(
                "//a[contains(\@href, \'Action=AgentTicket$Test->{Module};TicketID=$TicketID;LoadFormDraft=1' )]"
            )->click();

            $Selenium->WaitFor( WindowCount => 2 );
            $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[1] );

            # Wait until page has loaded, if necessary.
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $(".WidgetSimple").length;'
            );

            # Make sure that draft loaded notification is present.
            $Self->True(
                index( $Selenium->get_page_source(), "You have loaded the draft \"$Title\"" ) > 0,
                'Draft loaded notification is present',
            );

            # Make sure that outdated notification is present.
            $Self->True(
                index(
                    $Selenium->get_page_source(),
                    "Please note that this draft is outdated because the ticket was modified since this draft was created."
                    )
                    > 0,
                'Outdated notification is present',
            );

            # Verify initial Draft values and update them.
            for my $FieldValue ( sort keys %{ $Test->{Fields} } ) {

                if ( $Test->{Fields}->{$FieldValue}->{Type} eq 'DropDown' ) {
                    my $ID    = $Test->{Fields}->{$FieldValue}->{ID};
                    my $Value = $Test->{Fields}->{$FieldValue}->{Value};

                    $Selenium->WaitFor(
                        JavaScript =>
                            "return typeof(\$) === 'function' && \$('#$ID').length && \$('#$ID').val() == '$Value'"
                    );

                    $Self->Is(
                        $Selenium->execute_script("return \$('#$ID').val()"),
                        $Value,
                        "Initial Draft value for $Test->{Module} field $FieldValue is correct - $Value"
                    );

                    $Selenium->execute_script(
                        "\$('#$ID').val('$Test->{Fields}->{$FieldValue}->{Update}').trigger('redraw.InputField').trigger('change');"
                    );
                }
                elsif ( $Test->{Fields}->{$FieldValue}->{Type} eq 'Attachment' ) {

                    # there should be only one file with a certain name
                    $Self->Is(
                        $Selenium->execute_script(
                            "return \$('.AttachmentList tbody tr td.Filename:contains(Main-Test1.pdf)').length"
                        ),
                        1,
                        $Test->{Module} . " - Uploaded file correctly"
                    );
                    $Self->Is(
                        $Selenium->execute_script(
                            "return \$('.AttachmentList tbody tr td.Filename').length"
                        ),
                        1,
                        $Test->{Module} . " - Only one file present"
                    );

                    # add a second file
                    $Selenium->execute_script(
                        "\$('#FileUpload').css('display', 'block')"
                    );

                    # upload a file
                    $Selenium->find_element( "#FileUpload", 'css' )
                        ->send_keys( $ConfigObject->Get('Home') . "/scripts/test/sample/Main/Main-Test1.doc" );

                    $Selenium->WaitFor(
                        JavaScript =>
                            "return typeof(\$) === 'function' && \$('.AttachmentList tbody tr td.Filename:contains(Main-Test1.doc)').length === 1"
                    );

                    # Check if uploaded.
                    $Self->Is(
                        $Selenium->execute_script(
                            "return \$('.AttachmentList tbody tr td.Filename:contains(Main-Test1.doc)').length"
                        ),
                        1,
                        $Test->{Module} . " - Uploaded file correctly"
                    );
                }
                elsif ( $Test->{Fields}->{$FieldValue}->{Type} eq 'RichText' ) {

                    # wait for the CKE to load
                    $Selenium->WaitFor(
                        JavaScript =>
                            "return \$('body.cke_editable', \$('.cke_wysiwyg_frame').contents()).length == 1"
                    );

                    $Self->Is(
                        $Selenium->execute_script('return CKEDITOR.instances.RichText.getData();'),
                        $Test->{Fields}->{$FieldValue}->{Value},
                        "Initial Draft value for $Test->{Module} field $FieldValue is correct"
                    );

                    $Selenium->execute_script(
                        "return CKEDITOR.instances.RichText.setData('$Test->{Fields}->{$FieldValue}->{Update}');"
                    );

                    $Selenium->execute_script(
                        "return CKEDITOR.instances.RichText.updateElement();"
                    );
                }
                else {
                    my $ID    = $Test->{Fields}->{$FieldValue}->{ID};
                    my $Value = $Test->{Fields}->{$FieldValue}->{Value};

                    $Selenium->WaitFor(
                        JavaScript =>
                            "return typeof(\$) === 'function' && \$('#$ID').length && \$('#$ID').val() == '$Value'"
                    );

                    $Self->Is(
                        $Selenium->execute_script("return \$('#$ID').val()"),
                        $Value,
                        "Initial Draft value for $Test->{Module} field $FieldValue is correct - $Value"
                    );

                    $Selenium->find_element( "#$ID", 'css' )->clear();
                    $Selenium->find_element( "#$ID", 'css' )->send_keys( $Test->{Fields}->{$FieldValue}->{Update} );
                }
            }

            # Try to add draft with same name.
            $Selenium->find_element( "#FormDraftSave", 'css' )->click();
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $("#FormDraftTitle").length && $("#SaveFormDraft").length;'
            );
            $Selenium->find_element( "#FormDraftTitle", 'css' )->send_keys($Title);
            $Selenium->find_element( "#SaveFormDraft",  'css' )->click();

            $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert not found';

            # Verify the alert message.
            my $ExpectedAlertText = "Draft name $Title is already in use!";
            $Self->True(
                ( $Selenium->get_alert_text() =~ /$ExpectedAlertText/ ),
                "Check alert message text.",
            );

            # Accept the alert to continue with the tests.
            $Selenium->accept_alert();

            $Selenium->find_element( ".CloseDialog", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length;' );

            $Selenium->find_element( "#FormDraftUpdate", 'css' )->click();

            # Switch back window.
            $Selenium->WaitFor( WindowCount => 1 );
            $Selenium->switch_to_window( $Handles->[0] );

            # Refresh screen.
            $Selenium->VerifiedRefresh();

            # Verify Draft is updated.
            $Self->True(
                index( $Selenium->get_page_source(), $Title ) > -1,
                "Draft for $Test->{Module} $Title is found",
            );

            # Click on test created Draft and switch window.
            $Selenium->find_element(
                "//a[contains(\@href, \'Action=AgentTicket$Test->{Module};TicketID=$TicketID;LoadFormDraft=1' )]"
            )->click();

            $Selenium->WaitFor( WindowCount => 2 );
            $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[1] );

            # Wait until page has loaded, if necessary.
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $(".WidgetSimple").length;'
            );

            # Verify updated Draft values.
            for my $FieldValue ( sort keys %{ $Test->{Fields} } ) {

                if ( $Test->{Fields}->{$FieldValue}->{Type} eq 'DropDown' ) {
                    my $ID           = $Test->{Fields}->{$FieldValue}->{ID};
                    my $UpdatedValue = $Test->{Fields}->{$FieldValue}->{Update};

                    $Selenium->WaitFor(
                        JavaScript =>
                            "return typeof(\$) === 'function' && \$('#$ID').length && \$('#$ID').val() == '$UpdatedValue'"
                    );

                    $Self->Is(
                        $Selenium->execute_script("return \$('#$ID').val()"),
                        $UpdatedValue,
                        "Updated Draft value for $Test->{Module} field $FieldValue is correct - $UpdatedValue"
                    );
                }
                elsif ( $Test->{Fields}->{$FieldValue}->{Type} eq 'Attachment' ) {

                    $Selenium->WaitFor(
                        JavaScript =>
                            "return typeof(\$) === 'function' && \$('.AttachmentList tbody tr td.Filename').length === 2"
                    );

                    # there should be two files now
                    $Self->Is(
                        $Selenium->execute_script(
                            "return \$('.AttachmentList tbody tr td.Filename').length"
                        ),
                        2,
                        $Test->{Module} . " - Uploaded file correctly"
                    );
                }
                elsif ( $Test->{Fields}->{$FieldValue}->{Type} eq 'RichText' ) {

                    # wait for the CKE to load
                    $Selenium->WaitFor(
                        JavaScript =>
                            "return \$('body.cke_editable', \$('.cke_wysiwyg_frame').contents()).length == 1"
                    );

                    $Self->Is(
                        $Selenium->execute_script('return CKEDITOR.instances.RichText.getData();'),
                        $Test->{Fields}->{$FieldValue}->{Update},
                        "Updated Draft value for $Test->{Module} field $FieldValue is correct"
                    );
                }
                else {
                    my $ID           = $Test->{Fields}->{$FieldValue}->{ID};
                    my $UpdatedValue = $Test->{Fields}->{$FieldValue}->{Update};

                    $Selenium->WaitFor(
                        JavaScript =>
                            "return typeof(\$) === 'function' && \$('#$ID').length && \$('#$ID').val() == '$UpdatedValue'"
                    );

                    $Self->Is(
                        $Selenium->execute_script("return \$('#$ID').val()"),
                        $UpdatedValue,
                        "Updated Draft value for $Test->{Module} field $FieldValue is correct - $UpdatedValue"
                    );
                }
            }

            $Selenium->find_element( ".CancelClosePopup", 'css' )->click();

            # Switch back window.
            $Selenium->WaitFor( WindowCount => 1 );
            $Selenium->switch_to_window( $Handles->[0] );

            # Delete draft
            $Selenium->find_element( ".FormDraftDelete", 'css' )->click();
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $("#DeleteConfirm").length;'
            );
            $Selenium->find_element( "#DeleteConfirm", 'css' )->click();

            my $Deleted = $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $(".FormDraftDelete").length == 0;'
            );

            $Self->True(
                $Deleted,
                "Check if Draft is deleted.",
            );
        }

        # Test for Save the draft without JSON error in window, bug#13556 https://bugs.otrs.org/show_bug.cgi?id=13556.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#nav-Communication ul").css({ "height": "auto", "opacity": "100" });'
        );

        # Click on 'Note' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketNote;TicketID=$TicketID' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        # Save form in Draft.
        $Selenium->find_element( "#FormDraftSave", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#FormDraftTitle").length && $("#SaveFormDraft").length;'
        );

        # Click on save Draft title dialog.
        $Selenium->find_element( "#SaveFormDraft", 'css' )->click();

        # Wait alert to appear.
        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert not found';

        # Verify the alert message.
        my $ExpectedAlertText = "Draft name is required!";
        $Self->True(
            ( $Selenium->get_alert_text() =~ /$ExpectedAlertText/ ),
            "Check alert message text.",
        );

        # Accept the validation alert.
        $Selenium->accept_alert();

        # Close save draft title dialog.
        $Selenium->find_element( ".CloseDialog", 'css' )->click();

        # Wait to close Dialog.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 0;' );

        # Submit empty form to check validation.
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        # Wait error Dialog to be visible.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;' );

        # Close error Dialog.
        $Selenium->find_element( "#DialogButton1", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 0;' );

        # Check validation.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Subject').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
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
