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

        # do not check RichText
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # create test customer user
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
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

        # create test article for test ticket
        my $SubjectRandom = "Subject" . $Helper->GetRandomID();
        my $TextRandom    = "Text" . $Helper->GetRandomID();
        my $ArticleID     = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleCreate(
            TicketID       => $TicketID,
            ArticleType    => 'phone',
            SenderType     => 'customer',
            Subject        => $SubjectRandom,
            Body           => $TextRandom,
            ContentType    => 'text/html; charset=ISO-8859-15',
            HistoryType    => 'AddNote',
            HistoryComment => 'Some free text!',
            UserID         => 1,
        );
        $Self->True(
            $ArticleID,
            "Article is created - $ArticleID",
        );

        # login test customer user
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

        # search for new created ticket on CustomerTicketOverview screen
        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'Action=CustomerTicketZoom;TicketNumber=$TicketNumber' )]"),
            "Ticket with ticket number $TicketNumber is found on screen"
        );

        # check customer ticket zoom screen
        $Selenium->find_element("//a[contains(\@href, \'Action=CustomerTicketZoom;TicketNumber=$TicketNumber' )]")
            ->VerifiedClick();

        # check add page
        for my $ID (
            qw(Messages FollowUp ZoomSidebar)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check ticket data
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

        # check reply button
        $Selenium->find_element("//a[contains(\@id, \'ReplyButton' )]")->VerifiedClick();
        $Selenium->find_element("//button[contains(\@value, \'Submit' )]");

        # change the ticket state to 'merged'
        my $Merged = $TicketObject->TicketStateSet(
            State    => 'merged',
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Merged,
            "Ticket state changed to 'merged'",
        );

        # refresh the page
        $Selenium->VerifiedRefresh();

        # check if reply button is missing in merged ticket (bug#7301)
        $Self->Is(
            $Selenium->execute_script('return $("a#ReplyButton").length'),
            0,
            "Reply button not found",
        );

        # check print button
        $Selenium->find_element("//a[contains(\@href, \'Action=CustomerTicketPrint;' )]")->VerifiedClick();

        # clean up test data from the DB
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket is deleted - $TicketID",
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);
