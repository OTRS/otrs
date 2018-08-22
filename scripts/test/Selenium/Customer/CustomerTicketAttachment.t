# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # do not check RichText
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # do not check service and type
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

        # set download type to inline
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'AttachmentDownloadType',
            Value => 'inline'
        );

        # create test customer user and login
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        # click on 'Create your first ticket'
        $Selenium->find_element( ".Button", 'css' )->VerifiedClick();

        # create needed variables
        my $SubjectRandom  = "Subject" . $Helper->GetRandomID();
        my $TextRandom     = "Text" . $Helper->GetRandomID();
        my $AttachmentName = "StdAttachment-Test1.txt";
        my $Location       = $Kernel::OM->Get('Kernel::Config')->Get('Home')
            . "/scripts/test/sample/StdAttachment/$AttachmentName";

        # input fields and create ticket
        $Selenium->execute_script("\$('#Dest').val('2||Raw').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Subject",    'css' )->send_keys($SubjectRandom);
        $Selenium->find_element( "#RichText",   'css' )->send_keys($TextRandom);
        $Selenium->find_element( "#Attachment", 'css' )->send_keys($Location);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Attachment").length' );
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # get test created ticket ID and number
        my %TicketIDs = $TicketObject->TicketSearch(
            Result         => 'HASH',
            Limit          => 1,
            CustomerUserID => $TestCustomerUserLogin,
        );
        my $TicketID     = (%TicketIDs)[0];
        my $TicketNumber = (%TicketIDs)[1];

        $Self->True(
            $TicketNumber,
            "Ticket was created and found",
        );

        # click on test created ticket on CustomerTicketOverview screen
        $Selenium->find_element( $TicketNumber, 'link_text' )->VerifiedClick();

        # click on attachment to open it
        $Selenium->find_element("//*[text()=\"$AttachmentName\"]")->VerifiedClick();

        # switch to another window
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        sleep 3;

        # check if attachment is genuine
        my $ExpectedAttachmentContent = "Some German Text with Umlaut";
        $Self->True(
            index( $Selenium->get_page_source(), $ExpectedAttachmentContent ) > -1,
            "$AttachmentName opened successfully",
        ) || die;

        # clean up test data from the DB
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket with ticket number $TicketNumber is deleted"
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
