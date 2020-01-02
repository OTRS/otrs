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

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminState");

        $Self->True(
            index( $Selenium->get_page_source(), 'closed successful' ) > -1,
            'closed successful found on page',
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # click 'add new state' link
        $Selenium->find_element( "a.Create", 'css' )->VerifiedClick();

        # check add page
        my $Element = $Selenium->find_element( "#Name", 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Selenium->find_element( "#TypeID",  'css' );
        $Selenium->find_element( "#ValidID", 'css' );

        # check client side validation
        $Selenium->find_element( "#Name",   'css' )->clear();
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # create a real test state
        my $RandomID = $Helper->GetRandomID();

        $Selenium->find_element( "#Name", 'css' )->send_keys($RandomID);
        $Selenium->execute_script("\$('#TypeID').val('1').change();");
        $Selenium->execute_script("\$('#ValidID').val('1').change();");
        $Selenium->find_element( "#Comment", 'css' )->send_keys('Selenium test state');
        $Selenium->find_element( "#Submit",  'css' )->VerifiedClick();

        # check overview page
        $Self->True(
            index( $Selenium->get_page_source(), 'closed successful' ) > -1,
            'closed successful found on page',
        );
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID found on page",
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # go to new state again
        $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

        # check new state values
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $RandomID,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#TypeID', 'css' )->get_value(),
            1,
            "#TypeID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            'Selenium test state',
            "#Comment stored value",
        );

        # set test state to invalid
        $Selenium->execute_script("\$('#TypeID').val('2').change();");
        $Selenium->execute_script("\$('#ValidID').val('2').change();");
        $Selenium->find_element( "#Comment", 'css' )->clear();
        $Selenium->find_element( "#Submit",  'css' )->VerifiedClick();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" &&  $(".DataTable").length;' );

        # check overview page
        $Self->True(
            index( $Selenium->get_page_source(), 'closed successful' ) > -1,
            'closed successful found on page',
        );
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID found on page",
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # go to new state again
        $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

        # check new state values
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $RandomID,
            "#Name updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#TypeID', 'css' )->get_value(),
            2,
            "#TypeID updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            2,
            "#ValidID updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            '',
            "#Comment updated value",
        );
    }
);

1;
