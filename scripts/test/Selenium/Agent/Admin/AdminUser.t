# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

        # do not check email addresses
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
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

        # navigate to AdminUser screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminUser");

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
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();
        $Self->True(
            index( $Selenium->get_page_source(), $TestUserLogin ) > -1,
            "$TestUserLogin found on page",
        );

        # check add agent page
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminUser;Subaction=Add' )]")->VerifiedClick();

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
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#UserFirstname').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Reload page
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminUser;Subaction=Add");

        # create a real test agent
        my $UserRandomID = 'TestAgent' . $Helper->GetRandomID();
        $Selenium->find_element( "#UserFirstname", 'css' )->send_keys($UserRandomID);
        $Selenium->find_element( "#UserLastname",  'css' )->send_keys($UserRandomID);
        $Selenium->find_element( "#UserLogin",     'css' )->send_keys($UserRandomID);
        $Selenium->find_element( "#UserEmail",     'css' )->send_keys( $UserRandomID . '@localhost.com' );
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # test search filter by agent $UserRandomID
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminUser");
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($UserRandomID);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();

        # edit real test agent values
        my $EditRandomID = 'EditedTestAgent' . $Helper->GetRandomID();
        $Selenium->find_element( $UserRandomID,    'link_text' )->VerifiedClick();
        $Selenium->find_element( "#UserFirstname", 'css' )->clear();
        $Selenium->find_element( "#UserFirstname", 'css' )->send_keys($EditRandomID);
        $Selenium->find_element( "#UserLastname",  'css' )->clear();
        $Selenium->find_element( "#UserLastname",  'css' )->send_keys($EditRandomID);
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # test search filter by agent $EditRandomID
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($EditRandomID);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();

        #check new agent values
        $Selenium->find_element( $UserRandomID, 'link_text' )->VerifiedClick();
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
            $UserRandomID,
            "#UserLogin stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserEmail', 'css' )->get_value(),
            "$UserRandomID\@localhost.com",
            "#UserEmail stored value",
        );

        # set added test agent to invalid
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # test search filter by agent $UserRandomID
        $Selenium->find_element( "#Search", 'css' )->clear();
        $Selenium->find_element( "#Search", 'css' )->send_keys($UserRandomID);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();

        # check class of invalid Agent in the overview table
        $Self->True(
            $Selenium->find_element( "tr.Invalid", 'css' ),
            "There is a class 'Invalid' for test Agent",
        );

    }

);

1;
