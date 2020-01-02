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
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Overload CustomerUser => Map setting defined in the Defaults.pm.
        my $DefaultCustomerUser = $ConfigObject->Get("CustomerUser");
        $DefaultCustomerUser->{Map}->[5] = [
            'UserEmail',
            'Email',
            'email',
            1,
            1,
            'var',
            '[% Env("CGIHandle") %]?Action=AgentTicketCompose;ResponseID=1;TicketID=[% Data.TicketID | uri %];ArticleID=[% Data.ArticleID | uri %]',
            0,
            '',
            'AsPopup OTRSPopup_TicketAction',
        ];
        $Helper->ConfigSettingChange(
            Key   => 'CustomerUser',
            Value => $DefaultCustomerUser,
        );

        # Make sure we start with RuntimeDB search.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Hook',
            Value => 'TestTicket#',
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::HookDivider',
            Value => '::',
        );

        my $RandomID    = $Helper->GetRandomID();
        my $SessionName = "OTRS$RandomID";
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SessionName',
            Value => $SessionName,
        );

        # Create and login test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Create test customer.
        my $TestCustomerUser = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # Get test customer user ID.
        my %TestCustomerUserID = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $TestCustomerUser,
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create test ticket.
        my $TitleRandom  = "Title$RandomID";
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN           => $TicketNumber,
            Title        => $TitleRandom,
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerID   => $TestCustomerUserID{UserCustomerID},
            CustomerUser => $TestCustomerUser,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        # Get image attachment.
        my $AttachmentName = 'StdAttachment-Test1.png';
        my $Location       = $ConfigObject->Get('Home')
            . "/scripts/test/sample/StdAttachment/$AttachmentName";
        my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Location,
            Mode     => 'binmode',
        );
        my $Content   = ${$ContentRef};
        my $ContentID = 'inline173020.131906379.1472199795.695365.264540139@localhost';

        # Add article.
        my $ArticleID = $TicketObject->ArticleCreate(
            TicketID    => $TicketID,
            ArticleType => 'email-external',
            SenderType  => 'customer',
            Subject     => 'First article',
            Body =>
                "<!DOCTYPE html><html><body>the message text<br><img src=\"cid:$ContentID\" /></body></html>",
            ContentType    => 'text/html; charset="utf8"',
            HistoryType    => 'EmailCustomer',
            HistoryComment => 'Some free text!',
            UserID         => 1,
            Attachment     => [
                {
                    Content     => $Content,
                    ContentID   => $ContentID,
                    ContentType => 'image/png; name="' . $AttachmentName . '"',
                    Disposition => 'inline',
                    FileID      => 1,
                    Filename    => $AttachmentName,
                },
            ],
        );
        $Self->True(
            $ArticleID,
            "Article is created - ID $ArticleID",
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketZoom for test created ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        $Self->True(
            $Selenium->execute_script("return \$('h1:contains(TestTicket#::)').length"),
            "Ticket::Hook and Ticket::HookDivider found",
        );

        $Self->True(
            $Selenium->execute_script("return \$('h1:contains($TitleRandom)').length"),
            "Ticket $TitleRandom found",
        );

        # Check page.
        for my $Action (
            qw( AgentTicketLock AgentTicketHistory AgentTicketPrint AgentTicketPriority
            AgentTicketFreeText AgentLinkObject AgentTicketOwner AgentTicketCustomer AgentTicketNote
            AgentTicketPhoneOutbound AgentTicketPhoneInbound AgentTicketEmailOutbound AgentTicketMerge
            AgentTicketPending)
            )
        {
            my $Element = $Selenium->find_element("//a[contains(\@href, \'Action=$Action')]");
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Try to click on the email (link) that should open a popup window.
        $Selenium->find_element( ".SidebarColumn .WidgetSimple:nth-of-type(2) a.AsPopup", "css" )->click();

        # Wait for popup and switch.
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("a.UndoClosePopup").length' );

        # Close note pop-up window.
        $Selenium->close();

        $Selenium->switch_to_window( $Handles->[0] );

        # Check if the IFRAME element DOES NOT contain the session ID parameter.
        my $IframeElement = $Selenium->find_element('//iframe[not(contains(@id, "AttachmentWindow"))]');
        $Self->False(
            ( $IframeElement->get_attribute('src') =~ m{$SessionName=} ) // 0,
            'Session ID not present in the IFRAME source URL'
        );

        # Switch off usage of session cookies.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SessionUseCookie',
            Value => 0,
        );

        # Get current session ID.
        my $SessionID = $Selenium->execute_script('return Core.Config.Get("SessionID");');

        # Reload the ticket zoom screen, but make sure to append the session ID parameter, as now the cookies will not
        #   be used.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID;$SessionName=$SessionID"
        );

        # Check if the IFRAME element now DOES contain the session ID parameter.
        $IframeElement = $Selenium->find_element('//iframe[not(contains(@id, "AttachmentWindow"))]');
        $Self->True(
            ( $IframeElement->get_attribute('src') =~ m{$SessionName=} ) // 0,
            'Session ID present in the IFRAME source URL'
        );

        # Clean up test data from the DB.
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
            "Ticket is deleted - ID $TicketID"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

1;
