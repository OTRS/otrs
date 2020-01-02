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

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Disable setting.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketZoom###CustomerZoomExpand',
            Value => 0,
        );

        # Disable check email address.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Create test customer user.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # Change customer user first and last name.
        my $RandomID          = $Helper->GetRandomID();
        my $CustomerFirstName = 'FirstName';
        my $CustomerLastName  = 'LastName, test (12345)';
        $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserUpdate(
            Source         => 'CustomerUser',
            ID             => $TestCustomerUserLogin,
            UserCustomerID => $TestCustomerUserLogin,
            UserLogin      => $TestCustomerUserLogin,
            UserFirstname  => $CustomerFirstName,
            UserLastname   => $CustomerLastName,
            UserEmail      => "$RandomID\@localhost.com",
            ValidID        => 1,
            UserID         => 1,
        );

        # Create test ticket.
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN           => $TicketNumber,
            Title        => 'Some Ticket Title',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => $TestCustomerUserLogin,
            CustomerUser => $TestCustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - $TicketID",
        );

        # Create test article for test ticket.
        my $SubjectRandom = "Subject" . $Helper->GetRandomID();
        my $TextRandom    = "Text" . $Helper->GetRandomID();

        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Phone',
        );

        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'customer',
            IsVisibleForCustomer => 1,
            Subject              => $SubjectRandom,
            Body                 => $TextRandom,
            Charset              => 'charset=ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'AddNote',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );

        $Self->True(
            $ArticleID,
            "Article #1 is created - $ArticleID",
        );

        my $ArticleID2 = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'customer',
            IsVisibleForCustomer => 1,
            Subject              => $SubjectRandom,
            Body                 => $TextRandom,
            Charset              => 'charset=ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'AddNote',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );

        $Self->True(
            $ArticleID2,
            "Article #2 is created - $ArticleID2",
        );

        # Account some time to the ticket.
        my $Success = $TicketObject->TicketAccountTime(
            TicketID  => $TicketID,
            ArticleID => $ArticleID,
            TimeUnit  => '7',
            UserID    => 1,
        );
        $Self->True(
            $Success,
            "Time accounted to the ticket",
        );

        # Login as test customer user.
        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketZoom;TicketNumber=123123123");

        $Self->True(
            index( $Selenium->get_page_source(), 'No Permission' ) > -1,
            "No permission message for tickets the user may not see, even if they don't exist.",
        );

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketZoom;TicketNumber=");

        $Self->True(
            index( $Selenium->get_page_source(), 'Need TicketID' ) > -1,
            "Error message for missing TicketID/TicketNumber.",
        );

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketOverview");

        # Search for new created ticket on CustomerTicketOverview screen.
        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'Action=CustomerTicketZoom;TicketNumber=$TicketNumber' )]"),
            "Ticket with ticket number $TicketNumber is found on screen"
        );

        # Check customer ticket zoom screen.
        $Selenium->find_element("//a[contains(\@href, \'Action=CustomerTicketZoom;TicketNumber=$TicketNumber' )]")
            ->VerifiedClick();

        # Check add page.
        for my $ID (
            qw(Messages FollowUp ZoomSidebar)
            )
        {
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#$ID').length" );
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check ticket data.
        $Self->True(
            index( $Selenium->get_page_source(), $TicketNumber ) > -1,
            "Ticket number is $TicketNumber",
        );

        $Self->True(
            index( $Selenium->get_page_source(), $SubjectRandom ) > -1,
            "Subject is $SubjectRandom",
        );

        $Self->True(
            index( $Selenium->get_page_source(), $TextRandom ) > -1,
            "Article body is $TextRandom",
        );

        $Self->True(
            index( $Selenium->get_page_source(), 'Raw' ) > -1,
            "Queue is Raw",
        );

        # Accounted time should not be displayed.
        $Self->False(
            index( $Selenium->get_page_source(), '<span class="Key">Accounted time:</span>' ) > -1,
            "Accounted time is not displayed",
        );

        # Enable displaying accounted time.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketZoom###ZoomTimeDisplay',
            Value => 1
        );

        # Reload the page.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketZoom;TicketNumber=$TicketNumber");

        my $NumberOfExpandedArticles = $Selenium->execute_script(
            'return $("ul#Messages li.Visible").length'
        );
        $Self->Is(
            $NumberOfExpandedArticles,
            1,
            'Make sure that only one article is expanded.'
        );

        # Enable expanding.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketZoom###CustomerZoomExpand',
            Value => 1,
        );

        # Reload the page.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketZoom;TicketNumber=$TicketNumber");

        $NumberOfExpandedArticles = $Selenium->execute_script(
            'return $("ul#Messages li.Visible").length'
        );
        $Self->Is(
            $NumberOfExpandedArticles,
            2,
            'Make sure that all articles are expanded.'
        );

        # Accounted time should now be displayed.
        $Self->True(
            index( $Selenium->get_page_source(), '<span class="Key">Accounted time:</span>' ) > -1,
            "Accounted time is displayed",
        );

        # Check reply button.
        $Selenium->find_element("//a[contains(\@id, \'ReplyButton' )]")->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#FollowUp.Visible').length" );
        $Selenium->find_element( '#RichText', 'css' )->send_keys('TestBody');
        $Selenium->find_element("//button[contains(\@value, \'Submit' )]")->VerifiedClick();

        # Change the ticket state to 'merged'.
        my $Merged = $TicketObject->TicketStateSet(
            State    => 'merged',
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Merged,
            "Ticket state changed to 'merged'",
        );

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketZoom;TicketNumber=$TicketNumber");

        # Check if reply button is missing in merged ticket (bug#7301).
        $Self->Is(
            $Selenium->execute_script('return $("a#ReplyButton").length'),
            0,
            "Reply button not found",
        );

        # Check if print button exists on the screen.
        $Self->Is(
            $Selenium->execute_script('return $("a[href*=\'Action=CustomerTicketPrint\']").length'),
            1,
            "Print button is found",
        );

        my $ArticleBackendObjectInternal = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Internal',
        );

        my $TestOriginalFrom = 'Agent Some Agent Some Agent' . $Helper->GetRandomID();

        # Add article from agent, with enabled IsVisibleForCustomer.
        my $ArticleID3 = $ArticleBackendObjectInternal->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'agent',
            IsVisibleForCustomer => 1,
            From                 => $TestOriginalFrom . ' <email@example.com>',
            Subject              => $SubjectRandom,
            Body                 => $TextRandom,
            Charset              => 'charset=ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'AddNote',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );

        $Self->True(
            $ArticleID2,
            "Article #2 is created - $ArticleID2",
        );

        # Use From field value.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketZoom###DisplayNoteFrom',
            Value => 'FromField',
        );

        # Allow apache to pick up the changed SysConfig via Apache::Reload.
        sleep 2;

        # Refresh the page.
        $Selenium->VerifiedRefresh();

        # Check From field value.
        my $FromString = $Selenium->execute_script(
            "return \$('.MessageBody:eq(3) span:eq(0)').text().trim();"
        );
        $Self->Is(
            $FromString,
            $TestOriginalFrom,
            "Test From content",
        );

        # Use default agent name setting.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketZoom###DisplayNoteFrom',
            Value => 'DefaultAgentName',
        );

        my $TestDefaultAgentName = 'ADefaultValueForAgentName' . $Helper->GetRandomID();

        # Set a default value for agent.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketZoom###DefaultAgentName',
            Value => $TestDefaultAgentName,
        );

        # Allow apache to pick up the changed SysConfig via Apache::Reload.
        sleep 2;

        # Refresh the page.
        $Selenium->VerifiedRefresh();

        # Check From field value.
        $FromString = $Selenium->execute_script(
            "return \$('.MessageBody:eq(3) span:eq(0)').text().trim();"
        );
        $Self->Is(
            $FromString,
            $TestDefaultAgentName,
            "Test From content",
        );

        # Login to Agent interface and verify customer name in answer article.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Navigate to AgentTicketZoom screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        $Self->True(
            $Selenium->execute_script(
                'return $("#ArticleTable a:contains(\'FirstName LastName, test (12345)\')").length;'
            ),
            "Customer name found in reply article",
        );

        # Clean up test data from the DB.
        $Success = $TicketObject->TicketDelete(
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
            "Ticket is deleted - $TicketID",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

1;
