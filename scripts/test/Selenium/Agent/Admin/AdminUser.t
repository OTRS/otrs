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

our $ObjectManagerDisabled = 1;

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

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminUser");

        # check overview AdminUser
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # check for test agent in AdminUser
        $Self->True(
            index( $Selenium->get_page_source(), $TestUserLogin ) > -1,
            "$TestUserLogin found on page",
        );

        # check search field
        $Selenium->find_element( "#Search", 'css' )->send_keys($TestUserLogin);
        $Selenium->find_element( "#Search", 'css' )->submit();
        $Self->True(
            index( $Selenium->get_page_source(), $TestUserLogin ) > -1,
            "$TestUserLogin found on page",
        );

        # check add agent page
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminUser;Subaction=Add' )]")->click();

        for my $ID (
            qw(UserFirstname UserLastname UserLogin UserEmail)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check client side validation
        my $Element = $Selenium->find_element( "#UserFirstname", 'css' );
        $Element->send_keys("");
        $Element->submit();

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#UserFirstname').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # create a real test agent
        my $RandomID = 'TestAgent' . $Helper->GetRandomID();
        $Selenium->find_element( "#UserFirstname", 'css' )->send_keys($RandomID);
        $Selenium->find_element( "#UserLastname",  'css' )->send_keys($RandomID);
        $Selenium->find_element( "#UserLogin",     'css' )->send_keys($RandomID);
        $Selenium->find_element( "#UserEmail",     'css' )->send_keys( $RandomID . '@localhost.com' );
        $Selenium->find_element( "#UserFirstname", 'css' )->submit();

        # test search filter by agent $RandomID
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminUser");
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($RandomID);
        $Selenium->find_element( "#Search", 'css' )->submit();

        # edit real test agent values
        my $EditRandomID = 'EditedTestAgent' . $Helper->GetRandomID();
        $Selenium->find_element( $RandomID,        'link_text' )->click();
        $Selenium->find_element( "#UserFirstname", 'css' )->clear();
        $Selenium->find_element( "#UserFirstname", 'css' )->send_keys($EditRandomID);
        $Selenium->find_element( "#UserLastname",  'css' )->clear();
        $Selenium->find_element( "#UserLastname",  'css' )->send_keys($EditRandomID);
        $Selenium->find_element( "#UserFirstname", 'css' )->submit();

        # test search filter by agent $EditRandomID
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Search").length' );
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($EditRandomID);
        $Selenium->find_element( "#Search", 'css' )->submit();

        #check new agent values
        $Selenium->find_element( $RandomID, 'link_text' )->click();
        $Self->Is(
            $Selenium->find_element( '#UserFirstname', 'css' )->get_value(),
            $EditRandomID,
            "#UserFirstname stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserLastname', 'css' )->get_value(),
            $EditRandomID,
            "#UserLastname stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserLogin', 'css' )->get_value(),
            $RandomID,
            "#UserLogin stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserEmail', 'css' )->get_value(),
            "$RandomID\@localhost.com",
            "#UserEmail stored value",
        );

        # set added test agent to invalid
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#UserFirstname", 'css' )->submit();

        # test search filter by agent $RandomID
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($RandomID);
        $Selenium->find_element( "#Search", 'css' )->submit();

        # chack class of invalid Agent in the overview table
        $Self->True(
            $Selenium->find_element( "tr.Invalid", 'css' ),
            "There is a class 'Invalid' for test Agent",
        );

    }

);

1;
