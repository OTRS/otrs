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

        # navigate to AdminType screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminType");

        # check overview screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # click 'add new type' link
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminType;Subaction=Add' )]")->VerifiedClick();

        # check add page
        my $Element = $Selenium->find_element( "#Name", 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Selenium->find_element( "#ValidID", 'css' );

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
        my $Count = 1;
        for my $BreadcrumbText ( 'Type Management', 'Add Type' ) {
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

        # create a real test type
        my $TypeRandomID = "Type" . $Helper->GetRandomID();

        $Selenium->find_element( "#Name", 'css' )->send_keys($TypeRandomID);
        $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Name", 'css' )->VerifiedSubmit();

        $Self->True(
            index( $Selenium->get_page_source(), $TypeRandomID ) > -1,
            "$TypeRandomID found on page",
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # go to new type again
        $Selenium->find_element( $TypeRandomID, 'link_text' )->VerifiedClick();

        # check breadcrumb on Edit screen
        $Count = 1;
        for my $BreadcrumbText ( 'Type Management', 'Edit Type: ' . $TypeRandomID ) {
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

        # check new type values
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $TypeRandomID,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );

        # get current value of Ticket::Type::Default
        my $DefaultTicketType = $ConfigObject->Get('Ticket::Type::Default');

        # set test Type as a default ticket type
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type::Default',
            Value => $TypeRandomID
        );

        # Allow apache to pick up the changed SysConfig via Apache::Reload.
        sleep 1;

        # try to set test type to invalid
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Name", 'css' )->VerifiedSubmit();

        # default ticket type cannot be set to invalid
        $Self->True(
            index(
                $Selenium->get_page_source(),
                "The ticket type is set as a default ticket type, so it cannot be set to invalid!"
                ) > -1,
            "$TypeRandomID ticket type is set as a default ticket type, so it cannot be set to invalid!",
        ) || die;

        # reset default ticket type
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type::Default',
            Value => $DefaultTicketType
        );

        # Allow apache to pick up the changed SysConfig via Apache::Reload.
        sleep 1;

        # set test type to invalid
        $Selenium->find_element( "#Name", 'css' )->clear();
        $Selenium->find_element( "#Name", 'css' )->send_keys($TypeRandomID);
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Name", 'css' )->VerifiedSubmit();

        # check class of invalid Type in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($TypeRandomID)').length"
            ),
            "There is a class 'Invalid' for test Type",
        );

        # check overview page
        $Self->True(
            index( $Selenium->get_page_source(), $TypeRandomID ) > -1,
            "$TypeRandomID found on page",
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # go to new type again
        $Selenium->find_element( $TypeRandomID, 'link_text' )->VerifiedClick();

        # check new type values
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $TypeRandomID,
            "#Name updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            2,
            "#ValidID updated value",
        );

        # since there are no tickets that rely on our test types, we can remove them again
        # from the DB
        if ($TypeRandomID) {
            my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
            $TypeRandomID = $DBObject->Quote($TypeRandomID);
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM ticket_type WHERE name = ?",
                Bind => [ \$TypeRandomID ],
            );
            $Self->True(
                $Success,
                "TypeDelete - $TypeRandomID",
            );
        }

        # make sure the cache is corrects
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Type',
        );

    }
);

1;
