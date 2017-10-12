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

use Kernel::Output::HTML::Layout;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Change web max file upload.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'WebMaxFileUpload',
            Value => '68000'
        );

        # Change config for AgentTicketMove.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::MoveType',
            Value => 'link'
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketMove###Note',
            Value => 1
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketMove###NoteMandatory',
            Value => 1
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketOwner###NoteMandatory',
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

        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Phone' );

        # Create test email Article.
        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'customer',
            Subject              => "Selenium subject article",
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

        # Get RandomID.
        my $RandomID = $Helper->GetRandomID();

        my $Language = 'en';

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'admin', 'users' ],
            Language => $Language,
        ) || die "Did not get test user";

        my $LayoutObject = Kernel::Output::HTML::Layout->new(
            Lang         => $Language,
            UserTimeZone => 'UTC',
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $ScriptAlias  = $ConfigObject->Get('ScriptAlias');
        my $Home         = $ConfigObject->Get('Home');

        # Check screens.
        for my $Action (
            qw(
            AgentTicketPhone
            AgentTicketEmail
            AgentTicketNote
            AgentTicketOwner
            AgentTicketPhoneOutbound
            AgentTicketEmailOutbound
            AgentTicketPhoneInbound
            AgentTicketMove
            AgentTicketClose
            AgentTicketPending
            AgentTicketPriority
            AgentTicketForward
            )
            )
        {

            if ( $Action eq 'AgentTicketPhone' || $Action eq 'AgentTicketEmail' ) {

                $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=$Action");

                # Check DnDUpload.
                my $Element = $Selenium->find_element( ".DnDUpload", 'css' );
                $Element->is_enabled();
                $Element->is_displayed();

                # Hide DnDUpload and show input field.
                $Selenium->execute_script("\$('.DnDUpload').css('display', 'none')");
                $Selenium->execute_script("\$('#FileUpload').css('display', 'block')");

                # limit the allowed file types
                $Selenium->execute_script(
                    "\$('#FileUpload').data('file-types', 'myext')"
                );

                my $CheckFileTypeFilename = 'Test1.png';
                my $Location              = "$Home/scripts/test/sample/Cache/$CheckFileTypeFilename";
                $Selenium->find_element( "#FileUpload", 'css' )->clear();
                $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length'
                );

                # Verify dialog message.
                my $FileTypeMessage = "The following files are not allowed to be uploaded: $CheckFileTypeFilename";
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('.Dialog.Modal .InnerContent:contains(\"$FileTypeMessage\")').length"
                    ),
                    "$Action - FileTypeMessage is found",
                );

                # Confirm dialog action.
                $Selenium->find_element( "#DialogButton1", 'css' )->click();
                $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

                $Selenium->find_element( "#FileUpload", 'css' )->clear();

                # limit the max amount of files
                $Selenium->execute_script(
                    "\$('#FileUpload').removeData('file-types')"
                );
                $Selenium->execute_script(
                    "\$('#FileUpload').data('max-files', 2)"
                );

                $Location = "$Home/scripts/test/sample/Cache/Test1.pdf";
                $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && $(".AttachmentList tbody tr td.Filename:contains(\'Test1.pdf\')").length'
                );

                $Location = "$Home/scripts/test/sample/Cache/Test1.doc";
                $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && $(".AttachmentList tbody tr td.Filename:contains(\'Test1.doc\')").length'
                );

                $Location = "$Home/scripts/test/sample/Cache/Test1.txt";
                $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
                $Selenium->WaitFor(
                    AlertPresent => 1,
                );

                # Verify alert text.
                $Self->Is(
                    $Selenium->get_alert_text(),
                    'Sorry, you can only upload 2 files.',
                    "$Action - alert for max files shown correctly",
                );

                # Accept alert.
                $Selenium->accept_alert();

                # Remove the existing files.
                for my $DeleteExtension (qw(doc pdf)) {
                    $Self->True(
                        $Selenium->execute_script(
                            "return \$('.AttachmentList tbody tr td.Filename:contains(\"Test1.$DeleteExtension\")').length"
                        ),
                        "$Action - Uploaded '$DeleteExtension' file still there"
                    );

                    # Delete Attachment.
                    $Selenium->execute_script(
                        "\$('.AttachmentList tbody tr:contains(\"Test1.$DeleteExtension\")').find('a.AttachmentDelete').trigger('click')"
                    );

                    # Wait until attachment is deleted.
                    $Selenium->WaitFor(
                        JavaScript =>
                            'return typeof($) === "function" && !$(".fa.fa-spinner.fa-spin:visible").length'
                    );

                    # Check if deleted.
                    $Self->False(
                        $Selenium->execute_script(
                            "return \$('.AttachmentList tbody tr td.Filename:contains(\"Test1.$DeleteExtension\")').length"
                        ),
                        "$Action - Upload '$DeleteExtension' file deleted"
                    );
                }

                # Limit the max size per file (to 6 KB).
                $Selenium->execute_script(
                    "\$('#FileUpload').removeData('max-files')"
                );
                $Selenium->execute_script(
                    "\$('#FileUpload').data('max-size-per-file', 6000)"
                );
                $Selenium->execute_script(
                    "\$('#FileUpload').data('max-size-per-file-hr', '6 KB')"
                );

        # Now try to upload two files of which one exceeds the max size (.pdf should work (5KB), .png shouldn't (20KB)).
                $Location = "$Home/scripts/test/sample/Cache/Test1.pdf";
                $Selenium->find_element( "#FileUpload", 'css' )->clear();
                $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && $(".AttachmentList tbody tr td.Filename:contains(\'Test1.pdf\')").length'
                );

                my $CheckMaxAllowedSizeFilename = 'Test1.png';
                $Location = "$Home/scripts/test/sample/Cache/$CheckMaxAllowedSizeFilename";
                $Selenium->find_element( "#FileUpload", 'css' )->clear();
                $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length'
                );

                # Verify dialog message.
                my $MaxAllowedSizeMessage
                    = "The following files exceed the maximum allowed size per file of 6 KB and were not uploaded: $CheckMaxAllowedSizeFilename";
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('.Dialog.Modal .InnerContent:contains(\"$MaxAllowedSizeMessage\")').length"
                    ),
                    "$Action - MaxAllowedSizeMessage is found",
                );

                # Confirm dialog action.
                $Selenium->find_element( "#DialogButton1", 'css' )->click();
                $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

                # Remove the limitations again.
                $Selenium->execute_script(
                    "\$('#FileUpload').removeData('max-size-per-file')"
                );

                # Delete the remaining file.
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('.AttachmentList tbody tr td.Filename:contains(\"Test1.pdf\")').length"
                    ),
                    "$Action - Uploaded 'pdf' file still there"
                );

                # Delete Attachment.
                $Selenium->execute_script(
                    "\$('.AttachmentList tbody tr:contains(\"Test1.pdf\")').find('a.AttachmentDelete').trigger('click')"
                );

                # Wait until attachment is deleted.
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && !$(".fa.fa-spinner.fa-spin:visible").length'
                );

                # Check if deleted.
                $Self->False(
                    $Selenium->execute_script(
                        "return \$('.AttachmentList tbody tr td.Filename:contains(\"Test1.pdf\")').length"
                    ),
                    "$Action - Upload 'pdf' file deleted"
                );

                # Upload files.
                for my $UploadExtension (qw(doc pdf png txt xls)) {

                    my $Location = "$Home/scripts/test/sample/Main/Main-Test1.$UploadExtension";
                    $Selenium->find_element( "#FileUpload", 'css' )->clear();
                    $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
                    $Selenium->WaitFor(
                        JavaScript =>
                            "return typeof(\$) === 'function' && \$('.AttachmentList tbody tr td.Filename:contains(\"Main-Test1.$UploadExtension\")').length"
                    );

                    # Check if uploaded.
                    $Self->True(
                        $Selenium->execute_script(
                            "return \$('.AttachmentList tbody tr td.Filename:contains(\"Main-Test1.$UploadExtension\")').length"
                        ),
                        "$Action - Upload '$UploadExtension' file correct"
                    );
                }

                # Upload file again.
                my $CheckUploadAgainFilename = 'Main-Test1.txt';
                $Location = "$Home/scripts/test/sample/Main/$CheckUploadAgainFilename";
                $Selenium->find_element( "#FileUpload", 'css' )->clear();
                $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length'
                );

                # Verify dialog message.
                my $UploadAgainMessage
                    = "The following files were already uploaded and have not been uploaded again: $CheckUploadAgainFilename";
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('.Dialog.Modal .InnerContent:contains(\"$UploadAgainMessage\")').length"
                    ),
                    "$Action - UploadAgainMessage is found",
                );

                # Confirm dialog action.
                $Selenium->find_element( "#DialogButton1", 'css' )->click();
                $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

                # Check max size.
                my $CheckMaxSizeFilename = 'PostMaster-Test13.box';
                $Location = "$Home/scripts/test/sample/EmailParser/$CheckMaxSizeFilename";
                $Selenium->find_element( "#FileUpload", 'css' )->clear();
                $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length'
                );

                # Verify dialog message.
                my $UploadMaxMessage = "No space left for the following files: $CheckMaxSizeFilename";
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('.Dialog.Modal .InnerContent:contains(\"$UploadMaxMessage\")').length"
                    ),
                    "$Action - UploadMaxMessage is found",
                );

                # Confirm dialog action.
                $Selenium->find_element( "#DialogButton1", 'css' )->click();
                $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

                # Submit and check later if files still there.
                $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

                # Delete files.
                for my $DeleteExtension (qw(doc pdf png txt xls)) {

                    $Self->True(
                        $Selenium->execute_script(
                            "return \$('.AttachmentList tbody tr td.Filename:contains(\"Main-Test1.$DeleteExtension\")').length"
                        ),
                        "$Action - Uploaded '$DeleteExtension' file still there"
                    );

                    # Delete Attachment.
                    $Selenium->execute_script(
                        "\$('.AttachmentList tbody tr:contains(\"Main-Test1.$DeleteExtension\")').find('a.AttachmentDelete').trigger('click')"
                    );

                    # Wait until attachment is deleted.
                    $Selenium->WaitFor(
                        JavaScript =>
                            'return typeof($) === "function" && !$(".fa.fa-spinner.fa-spin:visible").length'
                    );

                    # Check if deleted.
                    $Self->False(
                        $Selenium->execute_script(
                            "return \$('.AttachmentList tbody tr td.Filename:contains(\"Main-Test1.$DeleteExtension\")').length"
                        ),
                        "$Action - Upload '$DeleteExtension' file deleted"
                    );
                }
            }
            elsif (
                $Action eq 'AgentTicketNote'
                || $Action eq 'AgentTicketOwner'
                || $Action eq 'AgentTicketPhoneOutbound'
                || $Action eq 'AgentTicketEmailOutbound'
                || $Action eq 'AgentTicketPhoneInbound'
                || $Action eq 'AgentTicketMove'
                || $Action eq 'AgentTicketClose'
                || $Action eq 'AgentTicketPending'
                || $Action eq 'AgentTicketPriority'
                || $Action eq 'AgentTicketForward'
                )
            {

                $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");
                sleep 1;

                if (
                    $Action eq 'AgentTicketNote'
                    || $Action eq 'AgentTicketPhoneOutbound'
                    || $Action eq 'AgentTicketEmailOutbound'
                    || $Action eq 'AgentTicketPhoneInbound'
                    || $Action eq 'AgentTicketOwner'
                    )
                {

                    $Selenium->WaitFor(
                        JavaScript =>
                            'return typeof($) === "function" && $(".Cluster ul ul").length'
                    );

                    # Force sub menus to be visible in order to be able to click one of the links.
                    $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");
                }

                $Selenium->find_element("//a[contains(\@href, \'Action=$Action;TicketID=$TicketID' )]")->click();

                $Selenium->WaitFor( WindowCount => 2 );
                my $Handles = $Selenium->get_window_handles();
                $Selenium->switch_to_window( $Handles->[1] );

                # Wait until page has loaded, if necessary.
                $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('.DnDUpload').length" );

                # Check DnDUpload.
                my $Element = $Selenium->find_element( ".DnDUpload", 'css' );
                $Element->is_enabled();
                $Element->is_displayed();

                # Upload files.
                for my $UploadExtension (qw(doc pdf png txt xls)) {

                    # Hide DnDUpload and show input field.
                    $Selenium->execute_script("\$('.DnDUpload').css('display', 'none')");
                    $Selenium->execute_script("\$('#FileUpload').css('display', 'block')");

                    my $Location = "$Home/scripts/test/sample/Main/Main-Test1.$UploadExtension";
                    $Selenium->find_element( "#FileUpload", 'css' )->clear();
                    $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
                    $Selenium->WaitFor(
                        JavaScript =>
                            "return typeof(\$) === 'function' && \$('.AttachmentList tbody tr td.Filename:contains(\"Main-Test1.$UploadExtension\")').length"
                    );

                    # Check if uploaded.
                    $Self->True(
                        $Selenium->execute_script(
                            "return \$('.AttachmentList tbody tr td.Filename:contains(\"Main-Test1.$UploadExtension\")').length"
                        ),
                        "$Action - Upload '$UploadExtension' file correct"
                    );
                }

                # Upload file again.
                my $CheckUploadAgainFilename = 'Main-Test1.txt';
                my $Location                 = "$Home/scripts/test/sample/Main/$CheckUploadAgainFilename";
                $Selenium->find_element( "#FileUpload", 'css' )->clear();
                $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length'
                );

                # Verify dialog message.
                my $UploadAgainMessage
                    = "The following files were already uploaded and have not been uploaded again: $CheckUploadAgainFilename";
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('.Dialog.Modal .InnerContent:contains(\"$UploadAgainMessage\")').length"
                    ),
                    "$Action - UploadAgainMessage is found",
                );

                # Confirm dialog action.
                $Selenium->find_element( "#DialogButton1", 'css' )->click();
                $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

                # Check max size.
                my $CheckMaxSizeFilename = 'PostMaster-Test13.box';
                $Location = "$Home/scripts/test/sample/EmailParser/$CheckMaxSizeFilename";
                my $CheckMaxSizeFileSize = $LayoutObject->HumanReadableDataSize(
                    Size => -s $Location,
                );
                $Selenium->find_element( "#FileUpload", 'css' )->clear();
                $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length'
                );

                # Verify dialog message.
                my $UploadMaxMessage = "No space left for the following files: $CheckMaxSizeFilename ($CheckMaxSizeFileSize)";
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('.Dialog.Modal .InnerContent:contains(\"$UploadMaxMessage\")').length"
                    ),
                    "$Action - UploadMaxMessage is found",
                );

                # Confirm dialog action.
                $Selenium->find_element( "#DialogButton1", 'css' )->click();
                $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

                # Submit to check if files still there.
                $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

                # Delete files.
                for my $DeleteExtension (qw(doc pdf png txt xls)) {

                    # Check if files still there.
                    $Self->True(
                        $Selenium->execute_script(
                            "return \$('.AttachmentList tbody tr td.Filename:contains(\"Main-Test1.$DeleteExtension\")').length"
                        ),
                        "$Action - Uploaded '$DeleteExtension' file still there"
                    );

                    # Delete Attachment.
                    $Selenium->execute_script(
                        "\$('.AttachmentList tbody tr:contains(\"Main-Test1.$DeleteExtension\")').find('a.AttachmentDelete').trigger('click')"
                    );

                    # Wait until attachment is deleted.
                    $Selenium->WaitFor(
                        JavaScript =>
                            'return typeof($) === "function" && !$(".fa.fa-spinner.fa-spin:visible").length'
                    );

                    # Check if deleted.
                    $Self->False(
                        $Selenium->execute_script(
                            "return \$('.AttachmentList tbody tr td.Filename:contains(\"Main-Test1.$DeleteExtension\")').length"
                        ),
                        "$Action - Upload '$DeleteExtension' file deleted"
                    );
                }

                $Selenium->close();
                $Selenium->WaitFor( WindowCount => 1 );
                $Selenium->switch_to_window( $Handles->[0] );
            }
        }

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
    }
);

1;
