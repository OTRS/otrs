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

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');
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

        # get test user ID
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        #add test role
        my $RoleRandomID = "role" . $Helper->GetRandomID();

        my $RoleID = $GroupObject->RoleAdd(
            Name    => $RoleRandomID,
            ValidID => 1,
            UserID  => $UserID,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminRoleUser");

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
            index( $Selenium->get_page_source(), $RoleRandomID ) > -1,
            "$RoleRandomID role found on page",
        );

        # test filter for Users
        $Selenium->find_element( "#FilterUsers", 'css' )->send_keys($TestUserLogin);
        sleep 1;

        $Self->True(
            $Selenium->find_element( "$FullUserID", 'link_text' )->is_displayed(),
            "$TestUserLogin user found on page",
        );

        # test filter for Roles
        $Selenium->find_element( "#FilterRoles", 'css' )->send_keys($RoleRandomID);
        sleep 1;

        $Self->True(
            $Selenium->find_element( "$RoleRandomID", 'link_text' )->is_displayed(),
            "$RoleRandomID role found on page",
        );

        # change test role relation for test user
        $Selenium->find_element( $FullUserID, 'link_text' )->click();

        $Selenium->find_element("//input[\@value='$RoleID']")->click();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

        #check and edit test user relation for test role
        $Selenium->find_element( $RoleRandomID, 'link_text' )->click();

        $Self->Is(
            $Selenium->find_element("//input[\@value='$UserID']")->is_selected(),
            1,
            "Role $RoleRandomID relation for user $TestUserLogin is enabled",
        );

        # remove test relation
        $Selenium->find_element("//input[\@value='$UserID']")->click();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

        # check if relation is clear
        $Selenium->find_element( $RoleRandomID, 'link_text' )->click();

        $Self->Is(
            $Selenium->find_element("//input[\@value='$UserID']")->is_selected(),
            0,
            "User $TestUserLogin is not in relation with role $RoleRandomID",
        );

        # Since there are no tickets that rely on our test role we can remove it from DB
        if ($RoleID) {
            my $Success = $DBObject->Do(
                SQL => "DELETE FROM roles WHERE id = $RoleID",
            );
            $Self->True(
                $Success,
                "RoleDelete - $RoleRandomID",
            );
        }

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Group'
        );

        }

);

1;
