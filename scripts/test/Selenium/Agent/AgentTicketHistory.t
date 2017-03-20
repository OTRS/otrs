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

        # get needed objects
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # disable check email addresses
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

        # create test ticket
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

        # create two test email articles
        my @ArticleIDs;
        for my $ArticleCreate ( 1 .. 2 ) {
            my $ArticleID = $ArticleObject->ArticleCreate(
                TicketID       => $TicketID,
                ArticleType    => 'email-external',
                SenderType     => 'customer',
                Subject        => 'some short description',
                Body           => 'the message text',
                Charset        => 'ISO-8859-15',
                MimeType       => 'text/plain',
                HistoryType    => 'EmailCustomer',
                HistoryComment => 'Some free text!',
                UserID         => 1,
            );
            $Self->True(
                $ArticleID,
                "ArticleCreate - ID $ArticleID",
            );
            push @ArticleIDs, $ArticleID;
        }

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to ticket zoom page of created test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # get current initial URL
        my $InitialURL = $Selenium->get_current_url();

        # force sub menus to be visible in order to be able to click one of the links
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#nav-Miscellaneous ul").css({ "height": "auto", "opacity": "100" });'
        );

        # click on 'History' and switch window
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketHistory;TicketID=$TicketID' )]")
            ->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length' );

        # click on 'Zoom view' for created second article
        $Selenium->find_element("//a[contains(\@href, 'AgentTicketZoom;TicketID=$TicketID;ArticleID=$ArticleIDs[1]')]")
            ->click();

        # switch window back
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # verify new URL
        my $ChangedURL = $Selenium->get_current_url();
        $Self->IsNot(
            $ChangedURL,
            $InitialURL,
            'AgentTicketHistory correctly changed parent window URL - JS is successful'
        );

        # delete created test ticket
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "TicketDelete - ID $TicketID"
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
