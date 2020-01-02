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

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # Do not check service and type.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

        # Disable global external content blocking.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::BlockLoadingRemoteContent',
            Value => 0,
        );

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketCreate - ID $TicketID",
        );

        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Email',
        );

        # Create test email article.
        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'customer',
            IsVisibleForCustomer => 1,
            Subject              => 'some short description',
            Body                 => 'the message text',
            Charset              => 'ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'EmailCustomer',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );
        $Self->True(
            $ArticleID,
            "ArticleCreate - ID $ArticleID",
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Add test customer for testing.
        my $TestCustomer       = 'Customer' . $Helper->GetRandomID();
        my $TestCustomerUserID = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestCustomer,
            UserLastname   => $TestCustomer,
            UserCustomerID => $TestCustomer,
            UserLogin      => $TestCustomer,
            UserEmail      => "$TestCustomer\@localhost.com",
            ValidID        => 1,
            UserID         => $TestUserID,
        );
        $Self->True(
            $TestCustomerUserID,
            "CustomerUserAdd - $TestCustomerUserID",
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketForward page.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketForward;TicketID=$TicketID;ArticleID=$ArticleID"
        );

        # Check AgentTicketFoward page.
        for my $ID (
            qw(ToCustomer CcCustomer BccCustomer Subject RichText
            FileUpload ComposeStateID IsVisibleForCustomer submitRichText)
            )
        {
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#$ID').length;" );
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Input fields and send forward.
        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys($TestCustomer);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length;' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCustomer)').click();");

        $Selenium->InputFieldValueSet(
            Element => '#ComposeStateID',
            Value   => '4',
        );

        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # Navigate to AgentTicketHistory of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

        # Verify for expected action.
        $Self->True(
            index( $Selenium->get_page_source(), "Forwarded to " ) > -1,
            'Action Forward executed correctly'
        );

        # Test external content loading depends on BlockLoadingRemoteContent setting (see bug#14398).
        # Enable RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 1,
        );

        my $RandomID = $Helper->GetRandomID();

        # Create another email article.
        my $ImgSource           = 'http://example.com/image.png';
        my $ArticleIDExtContent = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'customer',
            IsVisibleForCustomer => 1,
            Subject              => 'some short description',
            Body =>
                '<!DOCTYPE html><html><body>'
                . $RandomID . '<br /><img src="' . $ImgSource . '"/>'
                . '<applet code="foo.class"></applet>'
                . '<object data="bar.swf"></object>'
                . '<embed src="baz.swf">'
                . '<svg width="100" height="100"><circle cx="50" cy="50" r="40" fill="yellow" /></svg>'
                . '<script type="text/javascript">alert(1);</script>'
                . '</body></html>',
            Charset        => 'utf-8',
            MimeType       => 'text/html',
            HistoryType    => 'EmailCustomer',
            HistoryComment => 'Some free text!',
            UserID         => 1,
        );
        $Self->True(
            $ArticleID,
            "ArticleID $ArticleIDExtContent is created",
        );

        # Navigate to AgentTicketForward page of article with external content.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketForward;TicketID=$TicketID;ArticleID=$ArticleIDExtContent"
        );

        # Wait until CKEditor content is updated.
        $Selenium->WaitFor(
            JavaScript => "return CKEDITOR.instances.RichText.getData().indexOf('$ImgSource') > -1;",
        );

        # Verify external content is loaded due to disabled BlockLoadingRemoteContent.
        $Self->True(
            $Selenium->execute_script("return CKEDITOR.instances.RichText.getData().indexOf('$ImgSource') > -1;"),
            "BlockLoadingRemoteContent is disabled - external content is loaded"
        );

        # Verify potentially unsafe tags are not present.
        $Self->False(
            $Selenium->execute_script("return CKEDITOR.instances.RichText.getData().indexOf('<applet') > -1;"),
            'APPLET tag is stripped from the quoted content'
        );
        $Self->False(
            $Selenium->execute_script("return CKEDITOR.instances.RichText.getData().indexOf('<embed') > -1;"),
            'EMBED tag is stripped from the quoted content'
        );
        $Self->False(
            $Selenium->execute_script("return CKEDITOR.instances.RichText.getData().indexOf('<svg') > -1;"),
            'SVG tag is stripped from the quoted content'
        );
        $Self->False(
            $Selenium->execute_script("return CKEDITOR.instances.RichText.getData().indexOf('<script') > -1;"),
            'SCRIPT tag is stripped from the quoted content'
        );

        # Enable global external content blocking.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::BlockLoadingRemoteContent',
            Value => 1,
        );

        $Selenium->VerifiedRefresh();

        # Wait until CKEditor content is updated.
        $Selenium->WaitFor(
            JavaScript => "return CKEDITOR.instances.RichText.getData().indexOf('$RandomID') > -1;",
        );

        # Verify external content is not loaded due to enabled BlockLoadingRemoteContent.
        $Self->False(
            $Selenium->execute_script("return CKEDITOR.instances.RichText.getData().indexOf('$ImgSource') > -1;"),
            "BlockLoadingRemoteContent is enabled - external content is not loaded"
        );

        # Verify potentially unsafe tags are not present.
        $Self->False(
            $Selenium->execute_script("return CKEDITOR.instances.RichText.getData().indexOf('<applet') > -1;"),
            'APPLET tag is stripped from the quoted content'
        );
        $Self->False(
            $Selenium->execute_script("return CKEDITOR.instances.RichText.getData().indexOf('<embed') > -1;"),
            'EMBED tag is stripped from the quoted content'
        );
        $Self->False(
            $Selenium->execute_script("return CKEDITOR.instances.RichText.getData().indexOf('<svg') > -1;"),
            'SVG tag is stripped from the quoted content'
        );
        $Self->False(
            $Selenium->execute_script("return CKEDITOR.instances.RichText.getData().indexOf('<script') > -1;"),
            'SCRIPT tag is stripped from the quoted content'
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

        # Delete created test customer user.
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

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw (Ticket CustomerUser )) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
