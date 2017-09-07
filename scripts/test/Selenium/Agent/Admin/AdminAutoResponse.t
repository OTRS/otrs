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

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # do not check RichText
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

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

        # navigate to AdminAutoResponse screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminAutoResponse");

        # check overview AdminAutoResponse
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # click 'Add auto response'
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminAutoResponse;Subaction=Add' )]")->VerifiedClick();

        # get needed variables
        my $Count;

        # check breadcrumb on Add screen
        $Count = 1;
        for my $BreadcrumbText ( 'Auto Response Management', 'Add Auto Response' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # check page
        for my $ID (
            qw(Name Subject RichText TypeID AddressID ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check client side validation
        my $Element = $Selenium->find_element( "#Name", 'css' );
        $Element->send_keys("");
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # check form action
        $Self->True(
            $Selenium->find_element( '#Submit', 'css' ),
            "Submit is found on Add screen.",
        );

        # get needed variables
        my $RandomNumber = $Helper->GetRandomNumber();
        my @AutoResponseNames;

        # create a real test auto responses
        for my $Item (qw(First Second)) {

            # navigate to 'Add auto response' screen in second case
            if ( $Item eq 'Second' ) {
                $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminAutoResponse;Subaction=Add");
            }

            my $AutoResponseName = $Item . 'AutoResponse' . $RandomNumber;
            my $Text             = "Selenium auto response text";

            $Selenium->find_element( "#Name",     'css' )->send_keys($AutoResponseName);
            $Selenium->find_element( "#Subject",  'css' )->send_keys($AutoResponseName);
            $Selenium->find_element( "#RichText", 'css' )->send_keys($Text);
            $Selenium->execute_script("\$('#TypeID').val('1').trigger('redraw.InputField').trigger('change');");
            $Selenium->execute_script("\$('#AddressID').val('1').trigger('redraw.InputField').trigger('change');");
            $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
            $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

            # check if test auto response show on AdminAutoResponse screen
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('table tbody tr td:contains($AutoResponseName)').length"
                ),
                1,
                "Auto response job '$AutoResponseName' is found in the table",
            );

            push @AutoResponseNames, $AutoResponseName;
        }

        # edit test job and set it to invalid
        $Selenium->find_element( $AutoResponseNames[0], 'link_text' )->VerifiedClick();

        # check breadcrumb on Edit screen
        $Count = 1;
        for my $BreadcrumbText (
            'Auto Response Management',
            'Edit Auto Response: ' . $AutoResponseNames[0]
            )
        {
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

        $AutoResponseNames[0] = 'Update' . $AutoResponseNames[0];
        $Selenium->find_element( "#Name", 'css' )->clear();
        $Selenium->find_element( "#Name", 'css' )->send_keys( $AutoResponseNames[0] );
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # check if edited auto response show on AdminAutoResponse
        $Self->Is(
            $Selenium->execute_script(
                "return \$('table tbody tr td:contains($AutoResponseNames[0])').length"
            ),
            1,
            "Auto response job '$AutoResponseNames[0]' is found in the table",
        );

        # check class of invalid AutoResponse in the overview table
        $Self->Is(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($AutoResponseNames[0])').length"
            ),
            1,
            "There is a class 'Invalid' for auto response $AutoResponseNames[0]",
        );

        # navigate to AdminAutoResponse screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminAutoResponse");

        # filter auto responses
        $Selenium->find_element( "#FilterAutoResponses", 'css' )->clear();
        $Selenium->find_element( "#FilterAutoResponses", 'css' )->send_keys( $AutoResponseNames[0], "\N{U+E007}" );
        sleep 1;

        $Self->Is(
            $Selenium->execute_script(
                "return \$('table tbody tr td:contains($AutoResponseNames[0])').parent().css('display')"
            ),
            'table-row',
            "Auto response '$AutoResponseNames[0]' is found in the table"
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('table tbody tr td:contains($AutoResponseNames[1])').parent().css('display')"
            ),
            'none',
            "Auto response '$AutoResponseNames[1]' is not found in the table"
        );

        # cleanup
        # since there are no tickets that rely on our test auto response,
        # we can remove them from the DB
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Success;

        for my $TestARName (@AutoResponseNames) {
            $TestARName = $DBObject->Quote($TestARName);
            $Success    = $DBObject->Do(
                SQL  => "DELETE FROM auto_response WHERE name = ?",
                Bind => [ \$TestARName ],
            );
            $Self->True(
                $Success,
                "Auto response '$TestARName' is deleted",
            );
        }
    }
);

1;
