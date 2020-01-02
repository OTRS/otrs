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

        # get test user ID
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # get needed objects
        my $ConfigObject           = $Kernel::OM->Get('Kernel::Config');
        my $StdAttachmentObject    = $Kernel::OM->Get('Kernel::System::StdAttachment');
        my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');
        my $MainObject             = $Kernel::OM->Get('Kernel::System::Main');

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # create test attachment
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/StdAttachment/StdAttachment-Test1.txt";

        my $ContentRef = $MainObject->FileRead(
            Location => $Location,
            Mode     => 'binmode',
        );

        my $Content = ${$ContentRef};
        my $MD5     = $MainObject->MD5sum( String => \$Content );

        my $AttachmentRandomID = "attachment" . $Helper->GetRandomID();
        my $AttachmentID       = $StdAttachmentObject->StdAttachmentAdd(
            Name        => $AttachmentRandomID,
            ValidID     => 1,
            Content     => $Content,
            ContentType => 'text/xml',
            Filename    => 'StdAttachment Test1äöüß.txt',
            Comment     => 'Some Comment',
            UserID      => $UserID,
        );
        $Self->True(
            $AttachmentID,
            "Created StdAttachment - $AttachmentRandomID",
        );

        # create test template
        my $TemplateRandomID = "template" . $Helper->GetRandomID();
        my $TemplateID       = $StandardTemplateObject->StandardTemplateAdd(
            Name         => $TemplateRandomID,
            Template     => 'Thank you for your email.',
            ContentType  => 'text/plain; charset=utf-8',
            TemplateType => 'Answer',
            ValidID      => 1,
            UserID       => $UserID,
        );
        $Self->True(
            $TemplateID,
            "Created Template - $TemplateRandomID",
        );

        # navigate to AdminTemplateAttachment screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminTemplateAttachment");

        # check overview AdminTemplateAttachment screen
        for my $ID (
            qw(Templates Attachments FilterTemplates FilterAttachments)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check for test template and test attachment on screen
        $Self->True(
            index( $Selenium->get_page_source(), $TemplateRandomID ) > -1,
            "$TemplateRandomID found on screen"
        );
        $Self->True(
            index( $Selenium->get_page_source(), $AttachmentRandomID ) > -1,
            "$AttachmentRandomID found on screen"
        );

        # test search filters
        $Selenium->find_element( "#FilterTemplates",   'css' )->send_keys($TemplateRandomID);
        $Selenium->find_element( "#FilterAttachments", 'css' )->send_keys($AttachmentRandomID);
        sleep 1;

        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'Subaction=Template;ID=$TemplateID' )]")->is_displayed(),
            "$TemplateRandomID found on screen with filter on",
        );

        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'Subaction=Attachment;ID=$AttachmentID' )]")->is_displayed(),
            "$AttachmentRandomID found on screen with filter on",
        );

        # change test Attachment relation for test Template
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Template;ID=$TemplateID' )]")->VerifiedClick();

        $Selenium->find_element("//input[\@value='$AttachmentID'][\@type='checkbox']")->VerifiedClick();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # check test Template relation for test Attachment
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Attachment;ID=$AttachmentID' )]")->VerifiedClick();

        $Self->True(
            $Selenium->find_element("//input[\@value='$TemplateID'][\@type='checkbox']")->is_selected(),
            "$AttachmentRandomID is in a relation with $TemplateRandomID",
        );

        $Selenium->find_element("//input[\@value='$TemplateID'][\@type='checkbox']")->VerifiedClick();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # since there are no tickets that rely on our test TemplateAttachment,
        # we can remove test template and  test attachment from the DB
        my $Success = $StdAttachmentObject->StdAttachmentStandardTemplateMemberAdd(
            AttachmentID       => $AttachmentID,
            StandardTemplateID => $TemplateID,
            Active             => 0,
            UserID             => $UserID
        );
        $Self->True(
            $Success,
            "StdAttachmentStandardTemplateMemberAdd() removal for Attachment -> Template tests | with True",
        );

        $Success = $StdAttachmentObject->StdAttachmentDelete( ID => $AttachmentID );
        $Self->True(
            $Success,
            "StdAttachemntDelete() for Attachment -> Template tests | with True",
        );

        $Success = $StandardTemplateObject->StandardTemplateDelete(
            ID => $TemplateID,
        );

        $Self->True(
            $Success,
            "StandardTemplateDelete() for Attachment -> Template tests | with True",
        );

    }

);

1;
