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

        my $ConfigObject     = $Kernel::OM->Get('Kernel::Config');
        my $Helper           = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $AttachmentObject = $Kernel::OM->Get('Kernel::System::StdAttachment');

        my $Home = $ConfigObject->Get('Home');
        my %Attachments;
        my $Count;
        my $IsLinkedBreadcrumbText;

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AdminAttachment screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminAttachment");

        # check overview AdminAttachment
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # create test standard attachments
        for my $File (qw(xls txt doc png pdf)) {

            # click 'add new attachment' link
            $Selenium->find_element("//a[contains(\@href, \'Action=AdminAttachment;Subaction=Add' )]")->VerifiedClick();

            # check breadcrumb on Add screen
            $Count = 1;
            for my $BreadcrumbText ( 'Attachment Management', 'Add Attachment' ) {
                $Self->Is(
                    $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                    $BreadcrumbText,
                    "Breadcrumb text '$BreadcrumbText' is found on screen"
                );

                $Count++;
            }

            # check form action
            $Self->True(
                $Selenium->find_element( '#Submit', 'css' ),
                "Submit is found on Add screen.",
            );

            # file checks
            my $Location = $Home . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.$File";

            my $AttachmentName = 'StdAttachment' . $Helper->GetRandomNumber();
            $Attachments{$File} = $AttachmentName;

            $Selenium->find_element( "#Name", 'css' )->send_keys($AttachmentName);
            $Selenium->InputFieldValueSet(
                Element => '#ValidID',
                Value   => 1,
            );
            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
            $Selenium->find_element( "#Submit",     'css' )->VerifiedClick();

            # check if standard attachment show on AdminAttachment screen
            $Self->True(
                index( $Selenium->get_page_source(), $AttachmentName ) > -1,
                "Attachment $AttachmentName is found on page",
            );
            $Selenium->find_element( "table",             'css' );
            $Selenium->find_element( "table thead tr th", 'css' );
            $Selenium->find_element( "table tbody tr td", 'css' );

            # go to new standard attachment again and edit
            $Selenium->find_element( $AttachmentName, 'link_text' )->VerifiedClick();

            # check breadcrumb on Edit screen
            $Count = 1;
            for my $BreadcrumbText ( 'Attachment Management', 'Edit Attachment: ' . $AttachmentName ) {
                $Self->Is(
                    $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                    $BreadcrumbText,
                    "Breadcrumb text '$BreadcrumbText' is found on screen"
                );

                $Count++;
            }

            # check form actions
            for my $Action (qw(Submit SubmitAndContinue)) {
                $Self->True(
                    $Selenium->find_element( "#$Action", 'css' ),
                    "$Action is found on Edit screen.",
                );
            }

            $Selenium->InputFieldValueSet(
                Element => '#ValidID',
                Value   => 2,
            );
            $Selenium->find_element( "#Comment", 'css' )->send_keys('Selenium test attachment');
            $Selenium->find_element( "#Submit",  'css' )->VerifiedClick();

            # check overview page
            $Self->Is(
                $Selenium->execute_script("return \$('table tbody tr td:contains($AttachmentName)').length"),
                1,
                "Attachment $AttachmentName is found on table"
            );
            $Selenium->find_element( $AttachmentName, 'link_text' )->VerifiedClick();

            # check updated standard attachment values
            $Self->Is(
                $Selenium->find_element( '#ValidID', 'css' )->get_value(),
                2,
                "Validity is updated successfully",
            );
            $Self->Is(
                $Selenium->find_element( '#Comment', 'css' )->get_value(),
                'Selenium test attachment',
                "Comment is updated successfully",
            );

            # go back to AdminAttachment overview screen
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminAttachment");

            # check class of invalid Attachment in the overview table
            $Self->True(
                $Selenium->execute_script(
                    "return \$('tr.Invalid td a:contains($AttachmentName)').length"
                ),
                "There is a class 'Invalid' for attachment $AttachmentName",
            );
        }

        # create test case
        my @Tests = (
            {
                Name     => 'Filter table with xls test filename',
                Content  => $Attachments{xls},
                Expected => {
                    xls => 1,
                    txt => 0,
                    doc => 0,
                    png => 0,
                    pdf => 0,
                },
            },
            {
                Name     => 'Filter table with txt test filename',
                Content  => $Attachments{txt},
                Expected => {
                    xls => 0,
                    txt => 1,
                    doc => 0,
                    png => 0,
                    pdf => 0,
                },
            },
            {
                Name     => 'Filter table with doc test filename',
                Content  => $Attachments{doc},
                Expected => {
                    xls => 0,
                    txt => 0,
                    doc => 1,
                    png => 0,
                    pdf => 0,
                },
            },
            {
                Name     => 'Filter table with png test filename',
                Content  => $Attachments{png},
                Expected => {
                    xls => 0,
                    txt => 0,
                    doc => 0,
                    png => 1,
                    pdf => 0,
                },
            },
            {
                Name     => 'Filter table with pdf test filename',
                Content  => $Attachments{pdf},
                Expected => {
                    xls => 0,
                    txt => 0,
                    doc => 0,
                    png => 0,
                    pdf => 1,
                },
            },
        );

        for my $Test (@Tests) {
            $Selenium->find_element( "#FilterAttachments", 'css' )->clear();
            $Selenium->find_element( "#FilterAttachments", 'css' )->send_keys( $Test->{Content}, "\N{U+E007}" );
            sleep 1;

            for my $Key ( sort keys %{ $Test->{Expected} } ) {

                my $CSSDisplay = $Selenium->execute_script(
                    "return \$('table tbody tr td:contains($Attachments{$Key})').parent().css('display')"
                );

                if ( $Test->{Expected}->{$Key} == 1 ) {
                    $Self->Is(
                        $CSSDisplay,
                        'table-row',
                        "Attachment $Attachments{$Key} is found in the table"
                    );
                }
                else {
                    $Self->Is(
                        $CSSDisplay,
                        'none',
                        "Attachment $Attachments{$Key} is not found in the table"
                    );
                }
            }
        }

        # clear FilterAttachment field
        $Selenium->find_element( "#FilterAttachments", 'css' )->clear();
        $Selenium->find_element( "#FilterAttachments", 'css' )->send_keys("\N{U+E007}");
        sleep 1;

        for my $File ( sort keys %Attachments ) {

            $Selenium->execute_script(
                "\$('tbody tr:contains($Attachments{$File}) td .TrashCan').trigger('click')"
            );
            $Selenium->WaitFor( JavaScript => 'return $(".Dialog:visible").length === 1;' );

            # Verify delete dialog message.
            my $DeleteMessage = "Do you really want to delete this attachment?";
            $Self->True(
                $Selenium->execute_script(
                    "return \$('#DeleteAttachmentDialog:contains($DeleteMessage)').length"
                ),
                "Delete dialog message is found",
            );

            # Confirm delete action.
            $Selenium->find_element( "#DialogButton1", 'css' )->click();
            $Selenium->WaitFor(
                JavaScript =>
                    "return !\$('.Dialog:visible').length && !\$('tbody tr:contains($Attachments{$File})').length"
            );

            $Self->True(
                $Selenium->execute_script(
                    "return \$('tbody tr:contains($Attachments{$File})').length === 0"
                ),
                "Attachment $Attachments{$File} is deleted",
            );
        }

        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
    }
);

1;
