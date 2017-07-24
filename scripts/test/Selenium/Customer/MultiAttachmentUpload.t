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

        # Get helper object.
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Change web max file upload.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'WebMaxFileUpload',
            Value => '68000'
        );

        # Create test customer user and login.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # Get ticket object.
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create test ticket.
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN           => $TicketNumber,
            Title        => 'Selenium Test Ticket',
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
            "Ticket ID $TicketID is created",
        );

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        # Get config object and script alias.
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $ScriptAlias  = $ConfigObject->Get('ScriptAlias');

        # Check screens.
        for my $Action (
            qw(
            CustomerTicketMessage
            CustomerTicketZoom
            )
            )
        {
            if ( $Action eq 'CustomerTicketMessage' ) {

                # Navigate to CustomerTicketMessage screen.
                $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=$Action");
            }
            elsif ( $Action eq 'CustomerTicketZoom' ) {

                # Navigate to CustomerTicketZoom screen.
                $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=$Action;TicketNumber=$TicketNumber");

                # Check reply button.
                $Selenium->find_element("//a[contains(\@id, \'ReplyButton' )]")->VerifiedClick();
            }

            # Check DnDUpload.
            my $Element = $Selenium->find_element( ".DnDUpload", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();

            # Hide DnDUpload and show input field.
            $Selenium->execute_script(
                "\$('.DnDUpload').css('display', 'none')"
            );
            $Selenium->execute_script(
                "\$('#FileUpload').css('display', 'block')"
            );

            # Upload files.
            for my $UploadExtension (qw(doc pdf png txt xls)) {

                my $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/Main/Main-Test1." . $UploadExtension;
                $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);

                # Check if uploaded.
                $Self->Is(
                    $Selenium->execute_script(
                        "return \$('#AttachmentList tbody tr td.Filename:contains(Main-Test1.$UploadExtension)').length"
                    ),
                    1,
                    "Upload file correct"
                );
            }

            # Upload file again.
            my $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/Main/Main-Test1.txt";
            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);

            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;' );

            # Verify dialog message.
            my $UploadAgainMessage
                = "The following files were already uploaded and have not been uploaded again: Main-Test1.txt";
            $Self->True(
                index( $Selenium->get_page_source(), $UploadAgainMessage ) > -1,
                "UploadAgainMessage message is found",
            );

            # Confirm dialog action.
            $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

            # Check max size.
            $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/EmailParser/PostMaster-Test9.box";
            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);

            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;' );

            # Verify dialog message.
            my $UploadMaxMessage = "No space left for the following files: PostMaster-Test9.box";
            $Self->True(
                index( $Selenium->get_page_source(), $UploadMaxMessage ) > -1,
                "UploadMaxMessage message is found",
            );

            # Confirm dialog action.
            $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

            # Submit and check if files still there.
            $Selenium->find_element("//button[contains(\@value, \'Submit' )]")->VerifiedClick();

            # Delete files.
            for my $DeleteExtension (qw(doc pdf png txt xls)) {

                # Check if files still there.
                $Self->Is(
                    $Selenium->execute_script(
                        "return \$('#AttachmentList tbody tr td.Filename:contains(Main-Test1.$DeleteExtension)').length"
                    ),
                    1,
                    "Uploaded file still there"
                );

                # Delete Attachment.
                $Selenium->execute_script(
                    "\$('#AttachmentList tbody tr td.Filename:contains(Main-Test1.$DeleteExtension)').next().next().next().find('.AttachmentDelete').trigger('click')"
                );
                sleep 1;

                # Check if deleted.
                $Self->Is(
                    $Selenium->execute_script(
                        "return \$('#AttachmentList tbody tr td.Filename:contains(Main-Test1.$DeleteExtension)').length"
                    ),
                    0,
                    "Upload file deleted"
                );
            }
        }

        # Clean up test data from the DB.
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket with ticket ID $TicketID is deleted"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

1;
