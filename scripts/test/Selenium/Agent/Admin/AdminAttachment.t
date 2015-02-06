# --
# AdminAttachment.t - frontend tests for AdminAttachment
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

use Kernel::System::UnitTest::Helper;
use Kernel::System::UnitTest::Selenium;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose => 1,
);

$Selenium->RunTest(
    sub {

        my $Helper = Kernel::System::UnitTest::Helper->new(
            RestoreSystemConfiguration => 0,
        );

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
            $Selenium->find_element("//a[contains(\@href, \'Subaction=Add' )]")->click();

            # file checks
            my $Location = $ConfigObject->Get('Home')
                . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.$File";
            my $RandomID = $Helper->GetRandomID();
            $Selenium->find_element( "#Name",                      'css' )->send_keys($RandomID);
            $Selenium->find_element( "#ValidID option[value='1']", 'css' )->click();
            $Selenium->find_element( "#FileUpload",                'css' )->send_keys($Location);
            $Selenium->find_element( "#Name",                      'css' )->submit();

            # check if standard attachment show on AdminAttacnment screen
            $Self->True(
                index( $Selenium->get_page_source(), $RandomID ) > -1,
                "$RandomID standard attachment found on page",
            );
            $Selenium->find_element( "table",             'css' );
            $Selenium->find_element( "table thead tr th", 'css' );
            $Selenium->find_element( "table tbody tr td", 'css' );

            # go to new standard attacment again and edit
            $Selenium->find_element( $RandomID,                    'link_text' )->click();
            $Selenium->find_element( "#ValidID option[value='2']", 'css' )->click();
            $Selenium->find_element( "#Comment",                   'css' )->send_keys('Selenium test attachment');
            $Selenium->find_element( "#Name",                      'css' )->submit();

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
            $Selenium->go_back();

            # check delete button
            my $ID = $Kernel::OM->Get('Kernel::System::StdAttachment')->StdAttachmentLookup(
                StdAttachment => $RandomID,
            );
            $Selenium->find_element("//a[contains(\@href, \'Subaction=Delete;ID=$ID' )]")->click();

        }
        }
);

1;
