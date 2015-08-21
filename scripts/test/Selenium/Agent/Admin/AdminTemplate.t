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
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create and log in test user
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

        # navigate to AdminTemplate screen
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminTemplate");

        # chech overview screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );
        $Selenium->find_element( "#Filter",           'css' );

        # click 'Add template'
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminTemplate;Subaction=Add' )]")->click();
        $Selenium->WaitFor( JavaScript => "return \$('#TemplateType').length" );

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
        $Selenium->find_element( "#Name", 'css' )->submit();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # create real test template
        my $TemplateRandomID = "Template" . $Helper->GetRandomID();
        $Selenium->find_element( "#Name",                      'css' )->send_keys($TemplateRandomID);
        $Selenium->find_element( "#Comment",                   'css' )->send_keys("Selenium template test");
        $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Name",                      'css' )->submit();

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
        $Selenium->find_element( $TemplateRandomID, 'link_text' )->click();

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

        # edit test template
        $Selenium->find_element( "#Comment",                             'css' )->clear();
        $Selenium->execute_script("\$('#TemplateType').val('Create').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Name",                                'css' )->submit();

        # test search filter
        $Selenium->find_element( "#Filter", 'css' )->clear();
        $Selenium->find_element( "#Filter", 'css' )->send_keys($TemplateRandomID);

        # check class of invalid Template in the overview table
        $Self->True(
            $Selenium->find_element( "tr.Invalid", 'css' ),
            "There is a class 'Invalid' for test Template",
        );

        # check edited test template
        $Selenium->find_element( $TemplateRandomID, 'link_text' )->click();

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
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminTemplate");

        # test template delete button
        my $TemplateID = $Kernel::OM->Get('Kernel::System::StandardTemplate')->StandardTemplateLookup(
            StandardTemplate => $TemplateRandomID,
        );

        $Selenium->find_element("//a[contains(\@href, \'Subaction=Delete;ID=$TemplateID' )]")->click();

    }
);

1;
