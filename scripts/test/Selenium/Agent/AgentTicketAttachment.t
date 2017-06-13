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

        # Get needed objects.
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

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

        my %OutputFilterTextAutoLinkSysConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemGet(
            Name    => 'Frontend::Output::FilterText###OutputFilterTextAutoLink',
            Default => 1,
        );

        my %OutputFilterTextAutoLink;

        ITEMCONF:
        for my $Item ( @{ $OutputFilterTextAutoLinkSysConfig{Setting}->[1]->{Hash}->[1]->{Item} } ) {
            next ITEMCONF if !defined $Item->{Key};

            my $Key     = $Item->{Key};
            my $Content = $Item->{Content};

            if ( $Content =~ m/^\s+$/ ) {
                $Content = {
                    map { $_->{Key} => $_->{Content} } grep { defined $_->{Key} } @{ $Item->{Hash}->[1]->{Item} }
                };
            }
            $OutputFilterTextAutoLink{$Key} = $Content;
        }

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::Output::FilterText###OutputFilterTextAutoLink',
            Value => {
                %OutputFilterTextAutoLink,
            },
        );

        my %OutputFilterTextAutoLinkCVESysConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemGet(
            Name    => 'Frontend::Output::OutputFilterTextAutoLink###CVE',
            Default => 1,
        );

        my %OutputFilterTextAutoLinkCVE;

        ITEMCONF:
        for my $Item ( @{ $OutputFilterTextAutoLinkCVESysConfig{Setting}->[1]->{Hash}->[1]->{Item} } ) {
            next ITEMCONF if !defined $Item->{Key};

            my $Key     = $Item->{Key};
            my $Content = $Item->{Content};

            if ( $Content =~ m/^\s+$/ ) {
                if ( $Item->{Array} ) {
                    $Content = [ $Item->{Array}->[1]->{Item}->[1]->{Content} ];
                }
                elsif ( $Item->{Hash} ) {
                    $Content = {
                        map { $_->{Key} => $_->{Content} } grep { defined $_->{Key} } @{ $Item->{Hash}->[1]->{Item} }
                    };
                }
            }
            $OutputFilterTextAutoLinkCVE{$Key} = $Content;
        }

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::Output::OutputFilterTextAutoLink###CVE',
            Value => {
                %OutputFilterTextAutoLinkCVE,
            },
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

            my $ArticleID = $TicketObject->ArticleCreate(
                TicketID       => $TicketID,
                ArticleType    => 'note-internal',
                SenderType     => 'agent',
                Subject        => 'Selenium subject test',
                Body           => "Selenium body test $CVENumber",
                ContentType    => 'text/plain; charset=ISO-8859-15',
                HistoryType    => 'OwnerUpdate',
                HistoryComment => 'Some free text!',
                UserID         => 1,
                Attachment     => [
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
                    "return \$('.ArticleMailHeader a[href*=\"Action=AgentTicketAttachment;ArticleID=$ArticleID\"]:contains($TestAttachment->{Name})').length;"
                ),
                "'$TestAttachment->{Name}' is found on page",
            );

            # Check if links are added for CVE number.
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
                "${ScriptAlias}index.pl?Action=AgentTicketAttachment;ArticleID=$ArticleID;FileID=1",
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

        # Enable rich text editor for checking HTML content formatting in article body.
        $Success = $ConfigObject->Set(
            Key   => 'Frontend::RichText',
            Value => 1,
        );
        $Self->True(
            $Success,
            "Enable RichText with true",
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
        my $AttachmentName = $Image{Filename};
        my $Location       = $ConfigObject->Get('Home')
            . "/scripts/test/sample/StdAttachment/$AttachmentName";
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
        my $ArticleID = $TicketObject->ArticleCreate(
            TicketID    => $TicketID,
            ArticleType => 'note-internal',
            SenderType  => 'agent',
            Subject     => 'Article with HTML content',
            Body        => '
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
            $Selenium->find_element("//*[text()='$NormalText']"),
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
        my %AttachmentIndex = $TicketObject->ArticleAttachmentIndex(
            ArticleID => $ArticleID,
            UserID    => 1,
        );

        # Pass through all attachments to check image attachment.
        for my $FileID ( sort keys %AttachmentIndex ) {
            my %Attachment = $TicketObject->ArticleAttachment(
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
