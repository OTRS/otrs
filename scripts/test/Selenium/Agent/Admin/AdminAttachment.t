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

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Selenium     = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminAttachment");

        # check overview AdminGroup
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # create test stdanard attachments
        for my $File (qw(xls txt doc png pdf)) {

            # click 'add new attachment' link
            $Selenium->find_element("//a[contains(\@href, \'Action=AdminAttachment;Subaction=Add' )]")->click();

            # file checks
            my $Location = $ConfigObject->Get('Home')
                . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.$File";
            my $RandomID = 'StdAttachment' . $Helper->GetRandomID();
            $Selenium->find_element( "#Name", 'css' )->send_keys($RandomID);
            $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
            $Selenium->find_element( "#Name",       'css' )->submit();

            # check if standard attachment show on AdminAttacnment screen
            $Self->True(
                index( $Selenium->get_page_source(), $RandomID ) > -1,
                "$RandomID standard attachment found on page",
            );
            $Selenium->find_element( "table",             'css' );
            $Selenium->find_element( "table thead tr th", 'css' );
            $Selenium->find_element( "table tbody tr td", 'css' );

            # go to new standard attacment again and edit
            $Selenium->find_element( $RandomID, 'link_text' )->click();
            $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
            $Selenium->find_element( "#Comment", 'css' )->send_keys('Selenium test attachment');
            $Selenium->find_element( "#Name",    'css' )->submit();

            # check overview page
            $Self->True(
                index( $Selenium->get_page_source(), $RandomID ) > -1,
                '$RandomID found on table'
            );
            $Selenium->find_element( $RandomID, 'link_text' )->click();

            # check updated standard attacment values
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
            $Selenium->get("${ScriptAlias}index.pl?Action=AdminAttachment");

            # chack class of invalid Attachment in the overview table
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

            # check overview page
            $Self->True(
                index( $Selenium->get_page_source(), $RandomID ) == -1,
                'Standard attacment is deleted - $RandomID'
            );

        }
    }
);

1;
