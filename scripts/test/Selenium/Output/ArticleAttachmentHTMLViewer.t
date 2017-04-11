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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable MIME-Viewer for PDF attachment
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'MIME-Viewer###application/pdf',
            Value => "echo 'OTRS.org TEST'",
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
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

        # add article to test ticket with PDF test attachment
        my $Location = $Kernel::OM->Get('Kernel::Config')->Get('Home')
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

        # go to ticket zoom page of created test ticket
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # check are there Download and Viewer links for test attachment
        $Self->True(
            $Selenium->find_element("//a[contains(\@title, \'Download' )]"),
            "Download link for attachment is found"
        );
        $Self->True(
            $Selenium->find_element("//a[contains(\@title, \'Viewer' )]"),
            "Viewer link for attachment is found"
        );

        # check test attachment in MIME-Viwer, WaitFor will be done after switch to window
        $Selenium->find_element("//a[contains(\@title, \'Viewer' )]")->VerifiedClick();

        # switch to link object window
        $Selenium->WaitFor( WindowCount => 2 );

        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait for page to load if necessary.
        $Selenium->WaitFor( JavaScript => 'return document.readyState === "complete";' );

        # check expected values in PDF test attachment
        for my $ExpectedValue (qw(OTRS.org TEST)) {
            $Self->True(
                index( $Selenium->get_page_source(), $ExpectedValue ) > -1,
                "Value is found on screen - $ExpectedValue"
            );
        }
        $Selenium->close();

        # delete created test ticket
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket with ticket id $TicketID is deleted"
        );

        # make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket'
        );
    }
);

1;
