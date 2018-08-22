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

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AdminAttachment screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminAttachment");

        # check overview AdminAttachment
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # create test standard attachments
        for my $File (qw(xls )) {

            # click 'add new attachment' link
            $Selenium->find_element("//a[contains(\@href, \'Action=AdminAttachment;Subaction=Add' )]")->VerifiedClick();

            # file checks
            my $Location = $ConfigObject->Get('Home')
                . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.$File";
            my $RandomID = 'StdAttachment' . $Helper->GetRandomID();
            $Selenium->find_element( "#Name", 'css' )->send_keys($RandomID);
            $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

            # check if standard attachment show on AdminAttacnment screen
            $Self->True(
                index( $Selenium->get_page_source(), $RandomID ) > -1,
                "$RandomID standard attachment found on page",
            );
            $Selenium->find_element( "table",             'css' );
            $Selenium->find_element( "table thead tr th", 'css' );
            $Selenium->find_element( "table tbody tr td", 'css' );

            # go to new standard attachment again and edit
            $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

            $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
            $Selenium->find_element( "#Comment", 'css' )->send_keys('Selenium test attachment');
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

            # check overview page
            $Self->True(
                index( $Selenium->get_page_source(), $RandomID ) > -1,
                '$RandomID found on table'
            );
            $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

            # check updated standard attachment values
            $Self->Is(
                $Selenium->find_element( '#ValidID', 'css' )->get_value(),
                2,
                "#ValidID updated value",
            );
            $Self->Is(
                $Selenium->find_element( '#Comment', 'css' )->get_value(),
                'Selenium test attachment',
                "#Comment updated value",
            );

            # go back to AdminAttachment overview screen
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminAttachment");

            # check class of invalid Attachment in the overview table
            $Self->True(
                $Selenium->execute_script(
                    "return \$('tr.Invalid td a:contains($RandomID)').length"
                ),
                "There is a class 'Invalid' for test Attachment",
            );

            # check delete button
            my $ID = $Kernel::OM->Get('Kernel::System::StdAttachment')->StdAttachmentLookup(
                StdAttachment => $RandomID,
            );
            $Selenium->find_element("//a[contains(\@href, \'Subaction=Delete;ID=$ID' )]")->click();
            $Selenium->WaitFor( AlertPresent => 1 );

            # Accept delete confirmation dialog
            $Selenium->accept_alert();

            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' &&  \$('tbody tr:contains($RandomID)').length === 0;"
            );

            # check overview page
            $Self->True(
                index( $Selenium->get_page_source(), $RandomID ) == -1,
                'Standard attachment is deleted - $RandomID'
            );

        }
    }
);

1;
