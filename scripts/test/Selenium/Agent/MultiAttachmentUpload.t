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

        # Get helper object.
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

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

        # Get article object.
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

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get config object and script alias.
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $ScriptAlias  = $ConfigObject->Get('ScriptAlias');

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
                $Selenium->execute_script(
                    "\$('.DnDUpload').css('display', 'none')"
                );
                $Selenium->execute_script(
                    "\$('#FileUpload').css('display', 'block')"
                );

                # Upload files.
                for my $UploadExtension (qw(doc pdf png txt xls)) {

                    my $Location
                        = $ConfigObject->Get('Home') . "/scripts/test/sample/Main/Main-Test1." . $UploadExtension;
                    $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);

                    # Check if uploaded.
                    $Self->Is(
                        $Selenium->execute_script(
                            "return \$('#AttachmentList tbody tr td.Filename:contains(Main-Test1.$UploadExtension)').length"
                        ),
                        1,
                        "Upload file correct"
                    );
                }

                # Upload file again.
                my $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/Main/Main-Test1.txt";
                $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);

                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;'
                );

                # Verify dialog message.
                my $UploadAgainMessage
                    = "The following files were already uploaded and have not been uploaded again: Main-Test1.txt";
                $Self->True(
                    index( $Selenium->get_page_source(), $UploadAgainMessage ) > -1,
                    "UploadAgainMessage message is found",
                );

                # Confirm dialog action.
                $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

                # Check max size.
                $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/EmailParser/PostMaster-Test9.box";
                $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);

                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;'
                );

                # Verify dialog message.
                my $UploadMaxMessage = "No space left for the following files: PostMaster-Test9.box";
                $Self->True(
                    index( $Selenium->get_page_source(), $UploadMaxMessage ) > -1,
                    "UploadMaxMessage message is found",
                );

                # Confirm dialog action.
                $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

                # Submit and check later if files still there.
                $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

                # Delete files.
                for my $DeleteExtension (qw(doc pdf png txt xls)) {

                    $Self->Is(
                        $Selenium->execute_script(
                            "return \$('#AttachmentList tbody tr td.Filename:contains(Main-Test1.$DeleteExtension)').length"
                        ),
                        1,
                        "Uploaded file still there"
                    );

                    # Delete Attachment.
                    $Selenium->execute_script(
                        "\$('#AttachmentList tbody tr td.Filename:contains(Main-Test1.$DeleteExtension)').next().next().next().find('.AttachmentDelete').trigger('click')"
                    );
                    sleep 1;

                    # Check if deleted.
                    $Self->Is(
                        $Selenium->execute_script(
                            "return \$('#AttachmentList tbody tr td.Filename:contains(Main-Test1.$DeleteExtension)').length"
                        ),
                        0,
                        "Upload file deleted"
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
                    )
                {
                    $Selenium->WaitFor(
                        JavaScript =>
                            'return typeof($) === "function" && $("#nav-Communication ul").css({ "height": "auto", "opacity": "100" });'
                    );
                }
                elsif ( $Action eq 'AgentTicketOwner' ) {
                    $Selenium->WaitFor(
                        JavaScript =>
                            'return typeof($) === "function" && $("#nav-People ul").css({ "height": "auto", "opacity": "100" });'
                    );
                }

                $Selenium->find_element("//a[contains(\@href, \'Action=$Action;TicketID=$TicketID' )]")
                    ->VerifiedClick();

                $Selenium->WaitFor( WindowCount => 2 );
                my $Handles = $Selenium->get_window_handles();
                $Selenium->switch_to_window( $Handles->[1] );

                # Wait until page has loaded, if necessary.
                $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function'" );

                # Check DnDUpload.
                my $Element = $Selenium->find_element( ".DnDUpload", 'css' );
                $Element->is_enabled();
                $Element->is_displayed();

                # Upload files.
                for my $UploadExtension (qw(doc pdf png txt xls)) {

                    # Hide DnDUpload and show input field.
                    $Selenium->execute_script(
                        "\$('.DnDUpload').css('display', 'none')"
                    );
                    $Selenium->execute_script(
                        "\$('#FileUpload').css('display', 'block')"
                    );

                    my $Location
                        = $ConfigObject->Get('Home') . "/scripts/test/sample/Main/Main-Test1." . $UploadExtension;
                    $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);

                    # Check if uploaded.
                    $Self->Is(
                        $Selenium->execute_script(
                            "return \$('#AttachmentList tbody tr td.Filename:contains(Main-Test1.$UploadExtension)').length"
                        ),
                        1,
                        "Upload file correct"
                    );
                }

                # Upload file again.
                my $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/Main/Main-Test1.txt";
                $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);

                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;'
                );

                # Verify dialog message.
                my $UploadAgainMessage
                    = "The following files were already uploaded and have not been uploaded again: Main-Test1.txt";
                $Self->True(
                    index( $Selenium->get_page_source(), $UploadAgainMessage ) > -1,
                    "UploadAgainMessage message is found",
                );

                # Confirm dialog action.
                $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

                # Check max size.
                $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/EmailParser/PostMaster-Test9.box";
                $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);

                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;'
                );

                # Verify dialog message.
                my $UploadMaxMessage = "No space left for the following files: PostMaster-Test9.box";
                $Self->True(
                    index( $Selenium->get_page_source(), $UploadMaxMessage ) > -1,
                    "UploadMaxMessage message is found",
                );

                # Confirm dialog action.
                $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

                # Submit to check if files still there.
                $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

                # Delete files.
                for my $DeleteExtension (qw(doc pdf png txt xls)) {

                    # Check if files still there.
                    $Self->Is(
                        $Selenium->execute_script(
                            "return \$('#AttachmentList tbody tr td.Filename:contains(Main-Test1.$DeleteExtension)').length"
                        ),
                        1,
                        "Uploaded file still there"
                    );

                    # Delete Attachment.
                    $Selenium->execute_script(
                        "\$('#AttachmentList tbody tr td.Filename:contains(Main-Test1.$DeleteExtension)').next().next().next().find('.AttachmentDelete').trigger('click')"
                    );
                    sleep 1;

                    # Check if deleted.
                    $Self->Is(
                        $Selenium->execute_script(
                            "return \$('#AttachmentList tbody tr td.Filename:contains(Main-Test1.$DeleteExtension)').length"
                        ),
                        0,
                        "Upload file deleted"
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
        $Self->True(
            $Success,
            "Ticket ID $TicketID is deleted"
        );
    }
);

1;
