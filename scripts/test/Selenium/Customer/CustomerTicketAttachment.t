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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

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

        # Set download type to inline.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'AttachmentDownloadType',
            Value => 'inline'
        );

        # Create test customer user and login.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        # Click on 'Create your first ticket'.
        $Selenium->find_element( ".Button", 'css' )->VerifiedClick();

        # Create needed variables.
        my $SubjectRandom  = "Subject" . $Helper->GetRandomID();
        my $TextRandom     = "Text" . $Helper->GetRandomID();
        my $AttachmentName = "StdAttachment-Test1.txt";
        my $Location       = $Kernel::OM->Get('Kernel::Config')->Get('Home')
            . "/scripts/test/sample/StdAttachment/$AttachmentName";

        # Hide DnDUpload and show input field.
        $Selenium->execute_script(
            "\$('.DnDUpload').css('display', 'none')"
        );
        $Selenium->execute_script(
            "\$('#FileUpload').css('display', 'block')"
        );

        # Input fields and create ticket.
        $Selenium->InputFieldValueSet(
            Element => '#Dest',
            Value   => '2||Raw',
        );
        $Selenium->find_element( "#Subject",    'css' )->send_keys($SubjectRandom);
        $Selenium->find_element( "#RichText",   'css' )->send_keys($TextRandom);
        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".AttachmentList").length' );
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Get test created ticket ID and number.
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

        # Click on test created ticket on CustomerTicketOverview screen.
        $Selenium->find_element( $TicketNumber, 'link_text' )->VerifiedClick();

        # Click on attachment to open it.
        $Selenium->find_element("//*[text()=\"$AttachmentName\"]")->click();

        # Switch to another window.
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        sleep 3;

        # Check if attachment is genuine.
        my $ExpectedAttachmentContent = "Some German Text with Umlaut";
        $Self->True(
            index( $Selenium->get_page_source(), $ExpectedAttachmentContent ) > -1,
            "$AttachmentName opened successfully",
        ) || die;

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
            "Ticket with ticket number $TicketNumber is deleted"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

1;
