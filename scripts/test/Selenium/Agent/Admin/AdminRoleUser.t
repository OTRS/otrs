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

        #add test role
        my $RoleName = "role" . $Helper->GetRandomID();

        my $RoleID = $Kernel::OM->Get('Kernel::System::Group')->RoleAdd(
            Name    => $RoleName,
            ValidID => 1,
            UserID  => $UserID,
        );
        $Self->True(
            $RoleID,
            "Created Role - $RoleName",
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminRoleUser screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminRoleUser");

        # check overview AdminRoleUser
        $Selenium->find_element( "#Users",       'css' );
        $Selenium->find_element( "#Roles",       'css' );
        $Selenium->find_element( "#FilterUsers", 'css' );
        $Selenium->find_element( "#FilterRoles", 'css' );

        my $FullUserID = "$TestUserLogin ($TestUserLogin $TestUserLogin)";
        $Self->True(
            index( $Selenium->get_page_source(), $FullUserID ) > -1,
            "$TestUserLogin user found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $RoleName ) > -1,
            "$RoleName role found on page",
        );

        # test filter for Users
        $Selenium->find_element( "#FilterUsers", 'css' )->send_keys($TestUserLogin);
        sleep 1;

        $Self->True(
            $Selenium->find_element( "$FullUserID", 'link_text' )->is_displayed(),
            "$TestUserLogin user found on page",
        );

        # test filter for Roles
        $Selenium->find_element( "#FilterRoles", 'css' )->send_keys($RoleName);
        sleep 1;

        $Self->True(
            $Selenium->find_element( "$RoleName", 'link_text' )->is_displayed(),
            "$RoleName role found on page",
        );

        # change test role relation for test user
        $Selenium->find_element( $FullUserID, 'link_text' )->VerifiedClick();

        $Selenium->find_element("//input[\@value='$RoleID']")->VerifiedClick();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        #check and edit test user relation for test role
        $Selenium->find_element( $RoleName, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element("//input[\@value='$UserID']")->is_selected(),
            1,
            "Role $RoleName relation for user $TestUserLogin is enabled",
        );

        # test checked and unchecked values while filter by role is used
        # test filter with "WrongFilterRole" to uncheck a value
        $Selenium->find_element( "#Filter", 'css' )->clear();
        $Selenium->find_element( "#Filter", 'css' )->send_keys("WrongFilterRole");
        sleep 1;

        # test if no data is matches
        $Self->True(
            $Selenium->find_element( ".FilterMessage.Hidden>td", 'css' )->is_displayed(),
            "'No data matches' is displayed'"
        );
        $Selenium->find_element( "#Filter", 'css' )->clear();
        $Selenium->find_element( "#Filter", 'css' )->send_keys($TestUserLogin);
        sleep 1;

        # check role relation for agent after using filter by agent
        $Self->Is(
            $Selenium->find_element("//input[\@value='$UserID']")->is_selected(),
            1,
            "Role $RoleName relation for user $TestUserLogin is enabled",
        );

        # remove test relation
        $Selenium->find_element("//input[\@value='$UserID']")->VerifiedClick();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # check if relation is clear
        $Selenium->find_element( $RoleName, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element("//input[\@value='$RoleID']")->is_selected(),
            0,
            "User $TestUserLogin is not in relation with role $RoleName",
        );

        # test checked and unchecked values while filter by user is used
        # test filter with "WrongFilterRole" to uncheck a value
        $Selenium->find_element( "#Filter", 'css' )->clear();
        $Selenium->find_element( "#Filter", 'css' )->send_keys("WrongFilterRole");
        sleep 1;

        # test if no data is matches
        $Self->True(
            $Selenium->find_element( ".FilterMessage.Hidden>td", 'css' )->is_displayed(),
            "'No data matches' is displayed'"
        );
        $Selenium->find_element( "#Filter", 'css' )->clear();
        $Selenium->find_element( "#Filter", 'css' )->send_keys($RoleName);
        sleep 1;

        # check role relation for agent after using filter by role
        $Self->Is(
            $Selenium->find_element("//input[\@value='$RoleID']")->is_selected(),
            0,
            "User $TestUserLogin is not in relation with role $RoleName",
        );

        # since there are no tickets that rely on our test role we can remove it from DB
        if ($RoleID) {
            my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL => "DELETE FROM roles WHERE id = $RoleID",
            );
            $Self->True(
                $Success,
                "RoleDelete - $RoleName",
            );
        }

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Group'
        );

    }

);

1;
