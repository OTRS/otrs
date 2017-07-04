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

        my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
        my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Internal');

        # Define CVE number for test.
        my $CVENumber = 'CVE-2016-8655';

        # Disable rich text editor.
        my $Success = $ConfigObject->Set(
            Key   => 'Frontend::RichText',
            Value => 0,
        );
        $Self->True(
            $Success,
            "Disable RichText with true",
        );

        my %OutputFilterTextAutoLink = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name    => 'Frontend::Output::FilterText###OutputFilterTextAutoLink',
            Default => 1,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::Output::FilterText###OutputFilterTextAutoLink',
            Value => $OutputFilterTextAutoLink{EffectiveValue},
        );

        my %OutputFilterTextAutoLinkCVE = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name    => 'Frontend::Output::OutputFilterTextAutoLink###CVE',
            Default => 1,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::Output::OutputFilterTextAutoLink###CVE',
            Value => $OutputFilterTextAutoLinkCVE{EffectiveValue},
        );

        # Disable rich text and zoom article forcing, in order to get inline HTML attachment (file-1.html) to show up.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::ZoomRichTextForce',
            Value => 0,
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

        # Get script alias.
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Get CVE config.
        my $CVE = $ConfigObject->Get('Frontend::Output::OutputFilterTextAutoLink')->{CVE};

        my @TestAttachments = (
            {
                Name            => 'StdAttachment-Test1.txt',
                ExpectedContent => 'Some German Text with Umlaut: ÄÖÜß',
            },
            {
                Name            => 'file-1.html',
                ExpectedContent => 'This is file-1.html content.',
            }
        );

        for my $TestAttachment (@TestAttachments) {

            # Create test ticket.
            my $TicketID = $TicketObject->TicketCreate(
                Title        => 'Selenium Ticket',
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'new',
                CustomerID   => '123465',
                CustomerUser => 'customer@example.com',
                OwnerID      => 1,
                UserID       => 1,
            );
            $Self->True(
                $TicketID,
                "TicketCreate - ID $TicketID",
            );

            # Create article for test ticket with attachment.
            my $Location = $ConfigObject->Get('Home')
                . "/scripts/test/sample/StdAttachment/$TestAttachment->{Name}";
            my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
                Location => $Location,
                Mode     => 'binmode',
            );
            my $Content = ${$ContentRef};

            my $ArticleID = $ArticleBackendObject->ArticleCreate(
                TicketID             => $TicketID,
                IsVisibleForCustomer => 0,
                SenderType           => 'agent',
                Subject              => 'Selenium subject test',
                Body                 => "Selenium body test $CVENumber",
                ContentType          => 'text/plain; charset=ISO-8859-15',
                HistoryType          => 'OwnerUpdate',
                HistoryComment       => 'Some free text!',
                UserID               => 1,
                Attachment           => [
                    {
                        Content     => $Content,
                        ContentType => 'text/plain; charset=ISO-8859-15',
                        Filename    => $TestAttachment->{Name},
                    },
                ],
                NoAgentNotify => 1,
            );
            $Self->True(
                $ArticleID,
                "ArticleCreate - ID $ArticleID",
            );

            # Navigate to AgentTicketZoom screen of created test ticket.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

            # Check if attachment exists.
            $Self->True(
                $Selenium->execute_script(
                    "return \$('.ArticleAttachments a[href*=\"Action=AgentTicketAttachment;TicketID=$TicketID;ArticleID=$ArticleID;FileID=1\"][title*=\"$TestAttachment->{Name}\"]').length;"
                ),
                "'$TestAttachment->{Name}' is found on page"
            );

            # Check if there is replaced links for CVE number.
            for my $Item ( 1 .. 3 ) {
                my $CVEConfig = $CVE->{"URL$Item"};
                my $CVEURL = substr( $CVEConfig->{URL}, 0, index( $CVEConfig->{URL}, '=' ) );
                $Self->True(
                    $Selenium->find_element("//a[contains(\@href, \'$CVEURL=$CVENumber' )]"),
                    "$CVEConfig->{Description} link is found - $CVEURL",
                );

                $Self->True(
                    $Selenium->find_element("//img[contains(\@src, \'$CVEConfig->{Image}' )]"),
                    "Image for $CVEConfig->{Description} link is found - $CVEConfig->{Image}",
                );
            }

            # Set download type to inline.
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => 'AttachmentDownloadType',
                Value => 'inline'
            );

            # Check ticket attachment.
            $Selenium->get(
                "${ScriptAlias}index.pl?Action=AgentTicketAttachment;TicketID=$TicketID;ArticleID=$ArticleID;FileID=1",
                {
                    NoVerify => 1,
                }
            );

            # Check if attachment is genuine.
            $Self->True(
                index( $Selenium->get_page_source(), $TestAttachment->{ExpectedContent} ) > -1,
                "'$TestAttachment->{Name}' opened successfully",
            );

            # Delete created test ticket.
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
            $Self->True(
                $Success,
                "Ticket with ticket ID $TicketID is deleted"
            );
        }

        # Enable rich text and zoom article forcing.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::ZoomRichTextForce',
            Value => 1,
        );

        my $RandomNumber = $Helper->GetRandomNumber();
        my $NormalText   = 'NormalText' . $RandomNumber;
        my $BoldText     = 'BoldText' . $RandomNumber;

        # Get image attachment.
        my %Image = (
            Filename    => 'StdAttachment-Test1.png',
            ContentID   => 'inline173020.131906379.1472199795.695365.264540139@localhost',
            Disposition => 'inline',
        );
        my $Location = $ConfigObject->Get('Home')
            . '/scripts/test/sample/StdAttachment/' . $Image{Filename};
        my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Location,
            Mode     => 'binmode',
        );
        my $Content = ${$ContentRef};

        # Create test ticket with HTML content in article.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketCreate - ID $TicketID",
        );
        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 0,
            ArticleType          => 'note-internal',
            SenderType           => 'agent',
            Subject              => 'Article with HTML content',
            Body                 => '
<!DOCTYPE html>
<html>
<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head>
<body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;"><img src="cid:'
                . $Image{ContentID}
                . '" /><br />'
                .
                $NormalText . '<br /> <strong>' . $BoldText . '</strong><br /> ' . $CVENumber . '<br />
</body>
</html>',
            ContentType    => 'text/html; charset=ISO-8859-15',
            HistoryType    => 'OwnerUpdate',
            HistoryComment => 'History comment!',
            UserID         => 1,
            Attachment     => [
                {
                    Content     => $Content,
                    ContentID   => $Image{ContentID},
                    ContentType => 'image/png; name="' . $Image{Filename} . '"',
                    Disposition => 'inline',
                    FileID      => 1,
                    Filename    => $Image{Filename},
                },
            ],
            NoAgentNotify => 1,
        );
        $Self->True(
            $ArticleID,
            "ArticleCreate - ID $ArticleID",
        );

        # Navigate to AgentTicketZoom screen of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Get frame id.
        my $FrameID = $Selenium->execute_script(
            "return \$('#ArticleItems .ArticleMailContent Iframe').attr('id');"
        );
        $Self->True(
            $FrameID,
            "FrameID - $FrameID",
        );

        # Switch to frame.
        $Selenium->switch_to_frame($FrameID);

        # Check text formatting.
        $Self->True(
            $Selenium->find_element("//body[text()='$NormalText']"),
            "Normal text '$NormalText' is found in article body",
        );
        $Self->True(
            $Selenium->find_element("//strong[text()='$BoldText']"),
            "Bold text '$BoldText' is found in article body",
        );

        # Check if links added for CVE number.
        for my $Item ( 1 .. 3 ) {
            my $CVEConfig = $CVE->{"URL$Item"};
            my $CVEURL = substr( $CVEConfig->{URL}, 0, index( $CVEConfig->{URL}, '=' ) );

            $Self->True(
                $Selenium->find_element("//a[contains(\@href, \'$CVEURL=$CVENumber' )]"),
                "$CVEConfig->{Description} link is found - $CVEURL",
            );
            $Self->True(
                $Selenium->find_element("//img[contains(\@src, \'$CVEConfig->{Image}' )]"),
                "Image for $CVEConfig->{Description} link is found - $CVEConfig->{Image}",
            );
        }

        # Get article attachments.
        my %AttachmentIndex = $ArticleBackendObject->ArticleAttachmentIndex(
            ArticleID => $ArticleID,
            UserID    => 1,
        );

        # Pass through all attachments to check image attachment.
        for my $FileID ( sort keys %AttachmentIndex ) {
            my %Attachment = $ArticleBackendObject->ArticleAttachment(
                ArticleID => $ArticleID,
                FileID    => $FileID,
                UserID    => 1,
            );

            # Check image attachment data.
            if ( $Attachment{ContentType} =~ /^image\/png/ ) {
                $Self->Is(
                    $Attachment{Disposition},
                    $Image{Disposition},
                    'Inline image attachment found',
                );
                $Self->Is(
                    $Attachment{Filename},
                    $Image{Filename},
                    "Image attachment with filename '$Image{Filename}' found",
                );
            }
        }

        # Switch back from frame.
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[0] );

        # Delete created test ticket.
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "TicketID $TicketID is deleted"
        );

        # Make sure the cache is correct.
        for my $Cache (qw( Ticket CustomerUser )) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => $Cache );
        }

    }
);

1;
