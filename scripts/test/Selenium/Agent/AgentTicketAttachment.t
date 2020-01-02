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

        my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
        my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Internal');

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

        # Disable RichText and zoom article forcing, in order to get inline HTML attachment (file-1.html) to show up.
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

        # Enable meta floaters for AgentTicketZoom
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::ZoomCollectMeta',
            Value => 1
        );

        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        my $SettingName = 'Ticket::Frontend::ZoomCollectMetaFilters###CVE-Mitre';

        my %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => $SettingName,
            Value => $Setting{EffectiveValue},
        );

        $SettingName = 'Ticket::Frontend::ZoomCollectMetaFilters###CVE-Google';

        %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => $SettingName,
            Value => $Setting{EffectiveValue},
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

            my $CVENumber = 'CVE-2016-8655';
            my $ArticleID = $ArticleBackendObject->ArticleCreate(
                TicketID             => $TicketID,
                IsVisibleForCustomer => 0,
                SenderType           => 'agent',
                Subject              => 'Selenium subject test',
                Body                 => "$CVENumber: Hard-coded Credentials
R7-2018-01.1 [$CVENumber]: Hard-coded Credentials
R7-2018-01.1 {$CVENumber}: Hard-coded Credentials
R7-2018-01.1 ($CVENumber): Hard-coded Credentials
($CVENumber): Hard-coded Credentials
R7-2018-01.1 $CVENumber: Hard-coded Credentials
 $CVENumber: Hard-coded Credentials
Something:$CVENumber): Hard-coded Credentials
Something: $CVENumber): Hard-coded Credentials"
                ,
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
                    "return \$('.ArticleAttachments a[href*=\"Action=AgentTicketAttachment;TicketID=$TicketID;ArticleID=$ArticleID;FileID=1\"][title*=\"$TestAttachment->{Name}\"]').length;"
                ),
                "'$TestAttachment->{Name}' is found on page",
            );

            # Check if there is replaced links for CVE number.
            my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
            my $CVE          = $ConfigObject->Get('Frontend::Output::OutputFilterTextAutoLink')->{CVE};
            for my $Item ( 1 .. 3 ) {
                my $CVEConfig = $CVE->{"URL$Item"};
                my $CVEURL    = substr( $CVEConfig->{URL}, 0, index( $CVEConfig->{URL}, '=' ) );
                $Self->True(
                    $Selenium->find_element("//a[contains(\@href, \'$CVEURL=$CVENumber' )]"),
                    "$CVEConfig->{Description} link is found - $CVEURL",
                );

                $Self->True(
                    $Selenium->find_element("//img[contains(\@src, \'$CVEConfig->{Image}' )]"),
                    "Image for $CVEConfig->{Description} link is found - $CVEConfig->{Image}",
                );

                my %Response = $Kernel::OM->Get('Kernel::System::WebUserAgent')->Request(
                    Type => 'GET',
                    URL  => $CVEConfig->{Image},
                );

                if ( $Response{Status} =~ m{(500|443)} ) {
                    $Self->True(
                        1,
                        "Skipping the test case. Can't connect to server:(Connection refused)",
                    );
                }
                else {

                    # Check if is correct image for the link.
                    $Self->Is(
                        $Response{Status},
                        '200 OK',
                        "$CVEConfig->{Image} - there is correct image for the link",
                    );
                }

            }

            # set download type to inline
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
        }

        # Make sure the cache is correct.
        for my $Cache (qw( Ticket CustomerUser )) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => $Cache );
        }

    }
);

1;
