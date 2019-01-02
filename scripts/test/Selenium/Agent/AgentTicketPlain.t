# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

        # get needed objects
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # do not check email addresses
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # check to see tickets in plain view
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::PlainView',
            Value => 1
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

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN           => $TicketNumber,
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
            "Ticket is created - ID $TicketID",
        );

        # create test email article
        my $TicketSubject = "test 1";
        my $TicketBody    = "This is the first test.";
        my $ArticleID     = $TicketObject->ArticleCreate(
            TicketID       => $TicketID,
            ArticleType    => 'email-external',
            SenderType     => 'customer',
            Subject        => $TicketSubject,
            Body           => $TicketBody,
            Charset        => 'ISO-8859-15',
            MimeType       => 'text/plain',
            HistoryType    => 'EmailCustomer',
            HistoryComment => 'Some free text!',
            UserID         => 1,
        );
        $Self->True(
            $ArticleID,
            "Article is created - ID $ArticleID",
        );

        # write test sample email as article plain
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/EmailParser/PostMaster-Test1.box";

        my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Location,
            Mode     => 'utf8',
            Result   => 'SCALAR',
        );

        my $Success = $TicketObject->ArticleWritePlain(
            ArticleID => $ArticleID,
            Email     => ${$ContentRef},
            UserID    => 1,
        );
        $Self->True(
            $Success,
            "ArticleWritePlain for article ID $ArticleID - success",
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to zoom view of created test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # click to show ticket in plain view
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketPlain' )]")->VerifiedClick();

        # switch to plain window
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length' );

        # check for values in AgentTicketPlain screen
        $Self->True(
            index( $Selenium->get_page_source(), $TicketNumber ) > -1,
            "Created test ticket $TicketNumber found in Plain Format",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $TicketSubject ) > -1,
            "Created test ticket subject found in Plain Format",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $TicketBody ) > -1,
            "Created test ticket body found in Plain Format",
        );

        # close plain view window
        $Selenium->find_element( ".CancelClosePopup", 'css' )->click();
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # delete created test ticket
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
            "Ticket with ticket ID $TicketID is deleted"
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

1;
