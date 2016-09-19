# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
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

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminTemplate screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminTemplate");

        # check overview screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );
        $Selenium->find_element( "#Filter",           'css' );

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # click 'Add template'
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminTemplate;Subaction=Add' )]")->VerifiedClick();

        for my $ID (
            qw(TemplateType Name IDs ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check client side validation
        $Selenium->find_element( "#Name", 'css' )->clear();
        $Selenium->find_element( "#Name", 'css' )->VerifiedSubmit();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # check breadcrumb on Add screen
        my $Count = 0;
        my $IsLinkedBreadcrumbText;
        for my $BreadcrumbText ( 'You are here:', 'Manage Templates', 'Add Template' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $IsLinkedBreadcrumbText =
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').children('a').length");

            if ( $BreadcrumbText eq 'Manage Templates' ) {
                $Self->Is(
                    $IsLinkedBreadcrumbText,
                    1,
                    "Breadcrumb text '$BreadcrumbText' is linked"
                );
            }
            else {
                $Self->Is(
                    $IsLinkedBreadcrumbText,
                    0,
                    "Breadcrumb text '$BreadcrumbText' is not linked"
                );
            }

            $Count++;
        }

        # create real test template
        my $TemplateRandomID = "Template" . $Helper->GetRandomID();
        $Selenium->find_element( "#Name",    'css' )->send_keys($TemplateRandomID);
        $Selenium->find_element( "#Comment", 'css' )->send_keys("Selenium template test");
        $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Name", 'css' )->VerifiedSubmit();

        # check overview screen for test template
        $Self->True(
            index( $Selenium->get_page_source(), $TemplateRandomID ) > -1,
            "Template $TemplateRandomID found on page",
        );

        # test search filter
        $Selenium->find_element( "#Filter", 'css' )->clear();
        $Selenium->find_element( "#Filter", 'css' )->send_keys($TemplateRandomID);

        $Self->True(
            $Selenium->find_element( $TemplateRandomID, 'link_text' )->is_displayed(),
            "Template $TemplateRandomID found on screen",
        );

        # check test template values
        $Selenium->find_element( $TemplateRandomID, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $TemplateRandomID,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#TemplateType', 'css' )->get_value(),
            "Answer",
            "#TemplateType stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            "Selenium template test",
            "#Comment stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );

        # check breadcrumb on Edit screen
        $Count = 0;
        for my $BreadcrumbText ( 'You are here:', 'Manage Templates', 'Edit Template: ' . $TemplateRandomID ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $IsLinkedBreadcrumbText =
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').children('a').length");

            if ( $BreadcrumbText eq 'Manage Templates' ) {
                $Self->Is(
                    $IsLinkedBreadcrumbText,
                    1,
                    "Breadcrumb text '$BreadcrumbText' is linked"
                );
            }
            else {
                $Self->Is(
                    $IsLinkedBreadcrumbText,
                    0,
                    "Breadcrumb text '$BreadcrumbText' is not linked"
                );
            }

            $Count++;
        }

        # edit test template
        $Selenium->find_element( "#Comment", 'css' )->clear();
        $Selenium->execute_script("\$('#TemplateType').val('Create').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Name", 'css' )->VerifiedSubmit();

        #check is there notification after template is updated
        my $Notification = 'Template updated!';
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # test search filter
        $Selenium->find_element( "#Filter", 'css' )->clear();
        $Selenium->find_element( "#Filter", 'css' )->send_keys($TemplateRandomID);

        # check class of invalid Template in the overview table
        $Self->True(
            $Selenium->find_element( "tr.Invalid", 'css' ),
            "There is a class 'Invalid' for test Template",
        );

        # check edited test template
        $Selenium->find_element( $TemplateRandomID, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#TemplateType', 'css' )->get_value(),
            "Create",
            "#TemplateType updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            "",
            "#Comment updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            2,
            "#ValidID updated value",
        );

        # go back to AdminTemplate overview screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminTemplate");

        # test template delete button
        my $TemplateID = $Kernel::OM->Get('Kernel::System::StandardTemplate')->StandardTemplateLookup(
            StandardTemplate => $TemplateRandomID,
        );

        $Selenium->find_element("//a[contains(\@href, \'Subaction=Delete;ID=$TemplateID' )]")->VerifiedClick();

    }
);

1;
