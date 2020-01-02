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

use Kernel::System::PostMaster;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Enable MIME-Viewer for PDF attachment.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'MIME-Viewer###application/pdf',
            Value => "echo 'OTRS.org TEST'",
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Some Ticket Title',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );

        # Add article to test ticket with PDF test attachment.
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.pdf";

        my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Location,
            Mode     => 'binmode',
        );
        my $Content = ${$ContentRef};

        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Internal',
        );

        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 0,
            SenderType           => 'agent',
            Subject              => 'some short description',
            Body                 => 'the message text',
            ContentType          => 'text/html; charset=ISO-8859-15',
            HistoryType          => 'AddNote',
            HistoryComment       => 'Some free text!',
            UserID               => $TestUserID,
            Attachment           => [
                {
                    Content     => $Content,
                    ContentType => 'application/pdf',
                    Filename    => 'StdAttachment-Test1.pdf',
                },
            ],
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Go to ticket zoom page of created test ticket.
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Check are there Download and Viewer links for test attachment.
        $Self->True(
            $Selenium->find_element("//a[contains(\@title, \'Download' )]"),
            "Download link for attachment is found"
        );

        $Self->True(
            $Selenium->find_element("//a[contains(\@title, \'View' )]"),
            "View link for attachment is found"
        );

        # Check test attachment in MIME-Viwer, WaitFor will be done after switch to window.
        $Selenium->execute_script("\$('a.ViewAttachment i').click();");

        # Switch to link object window.
        $Selenium->WaitFor( WindowCount => 2 );

        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait for page to load if necessary.
        $Selenium->WaitFor( JavaScript => 'return document.readyState === "complete";' );

        # Check expected values in PDF test attachment.
        for my $ExpectedValue (qw(OTRS.org TEST)) {
            $Self->True(
                index( $Selenium->get_page_source(), $ExpectedValue ) > -1,
                "Value is found on screen - $ExpectedValue"
            );
        }
        $Selenium->close();

        $Selenium->WaitFor( WindowCount => 1 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[0] );

        # Import sample email.
        $Location   = $ConfigObject->Get('Home') . '/scripts/test/sample/PostMaster/PostMaster-Test20.box';
        $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Location,
            Mode     => 'binmode',
            Result   => 'ARRAY',
        );

        # Set ticket number in mail subject to get a follow-up.
        my $TicketNumber = $TicketObject->TicketNumberLookup(
            TicketID => $TicketID,
        );
        my @Content = ();
        for my $Line ( @{$ContentRef} ) {
            if ( $Line =~ /^Subject:/ ) {
                $Line = 'Subject: '
                    . $ConfigObject->Get('Ticket::Hook')
                    . $TicketNumber;
            }
            push @Content, $Line;
        }

        my @Return;

        # Execute PostMaster with the read email.
        {
            my $CommunicationLogObject = $Kernel::OM->Create(
                'Kernel::System::CommunicationLog',
                ObjectParams => {
                    Transport => 'Email',
                    Direction => 'Incoming',
                },
            );
            $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

            my $PostMasterObject = Kernel::System::PostMaster->new(
                CommunicationLogObject => $CommunicationLogObject,
                Email                  => \@Content,
            );

            @Return = $PostMasterObject->Run();

            $CommunicationLogObject->ObjectLogStop(
                ObjectLogType => 'Message',
                Status        => 'Successful',
            );
            $CommunicationLogObject->CommunicationStop(
                Status => 'Successful',
            );
        }

        # Check we actually got a follow-up.
        $Self->Is(
            $Return[0] || 0,
            2,
            "PostMaster::Run() - FollowUp",
        );

        # Check we actually got the same ticket ID.
        $Self->Is(
            $Return[1] || 0,
            $TicketID,
            "PostMaster::Run() - FollowUp/TicketID",
        );

        # Refresh the screen.
        $Selenium->VerifiedRefresh();

        # Find article IFRAME content URL.
        $Selenium->get_page_source() =~ m{<iframe [^>]+ src="(?!about:blank)(?<HTMLViewURL>.*?)"}xms;
        die 'Could not find IFRAME content URL!' if !$+{HTMLViewURL};

        # Get current SessionID and SessionName.
        my $SessionID   = $Selenium->execute_script('return Core.Config.Get("SessionID");');
        my $SessionName = $Kernel::OM->Get('Kernel::Config')->Get('SessionName');

        # Append session information to the url, since in the next selenium get request
        # we don't have session information in the cookie.
        my $URL = $+{HTMLViewURL} . ";$SessionName=$SessionID";

        # Load article content only.
        $Selenium->get($URL);

        # Wait for page to load if necessary.
        $Selenium->WaitFor( JavaScript => 'return document.readyState === "complete";' );

        # Check if article is displayed in expected encoding.
        $Self->True(
            index( $Selenium->get_page_source(), 'Munguía' ) > -1,
            'Article displayed using correct encoding'
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
            "Ticket with ticket id $TicketID is deleted"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket'
        );
    }
);

1;
