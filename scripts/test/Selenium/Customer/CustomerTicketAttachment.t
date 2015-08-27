# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # do not check RichText
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # do not check service and type
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

        # set download type to inline
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'AttachmentDownloadType',
            Value => 'inline'
        );

        # create test customer user and login
        my $TestUserLogin = $Helper->TestCustomerUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get customer user object
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        # get customer user ID
        my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
            User => $TestUserLogin,
        );

        # click on 'Create your first ticket'
        $Selenium->find_element( ".Button", 'css' )->click();

        # create needed variables
        my $SubjectRandom  = "Subject" . $Helper->GetRandomID();
        my $TextRandom     = "Text" . $Helper->GetRandomID();
        my $AttachmentName = "StdAttachment-Test1.txt";
        my $Location       = $Kernel::OM->Get('Kernel::Config')->Get('Home')
            . "/scripts/test/sample/StdAttachment/$AttachmentName";

        # input fields and create ticket
        $Selenium->execute_script("\$('#Dest').val('2||Raw').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Subject",                     'css' )->send_keys($SubjectRandom);
        $Selenium->find_element( "#RichText",                    'css' )->send_keys($TextRandom);
        $Selenium->find_element( "#Attachment",                  'css' )->send_keys($Location);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Attachment").length' );
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        # Wait until form has loaded, if neccessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("div#MainBox").length' );

        # obtain ticket number
        my @User = $CustomerUserObject->CustomerIDs(
            User => $TestUserLogin,
        );
        my $UserID = $User[0];

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my %TicketIDs = $TicketObject->TicketSearch(
            Result         => 'HASH',
            Limit          => 1,
            CustomerUserID => $UserID,
        );
        my $TicketNumber = (%TicketIDs)[1];

        $Self->True(
            $TicketNumber,
            "Ticket was created and found",
        );

        # click on test created ticket on CustomerTicketOverview screen
        $Selenium->find_element( $TicketNumber, 'link_text' )->click();

        # get article id
        my @ArticleIDs = $TicketObject->ArticleIndex(
            TicketID => (%TicketIDs)[0],
        );

        # click on attachment to open it
        $Selenium->find_element("//*[text()=\"$AttachmentName\"]")->click();

        # switch to another window
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # check if attachment is genuine
        my $ExpectedAttachmentContent = "Some German Text with Umlaut: ÄÖÜß";
        $Self->True(
            index( $Selenium->get_page_source(), $ExpectedAttachmentContent ) > -1,
            "$AttachmentName opened successfully",
        );

        # clean up test data from the DB
        my $TicketID = (%TicketIDs)[0];
        my $Success  = $Kernel::OM->Get('Kernel::System::Ticket')->TicketDelete(
            TicketID => $TicketID,
            UserID   => $UserID,
        );
        $Self->True(
            $Success,
            "Ticket with ticket number $TicketNumber is deleted"
        );

        # make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
