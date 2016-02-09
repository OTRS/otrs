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

# get needed objects
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

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Group' );

        # create test group
        my $GroupRandomID = 'group' . $Helper->GetRandomID();
        my $GroupID       = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
            Name    => $GroupRandomID,
            Comment => 'Selenium test group',
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $GroupID,
            "Created Group - $GroupRandomID",
        );

        # navigate to AdminUserGroup screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminUserGroup");

        # check overview AdminUserGroup
        $Selenium->find_element( "#Users",  'css' );
        $Selenium->find_element( "#Groups", 'css' );

        # click on created test group
        $Selenium->find_element( $GroupRandomID, 'link_text' )->VerifiedClick();

        # give full read and write access to the tickets in test group for test user
        $Selenium->find_element("//input[\@value='$UserID'][\@name='rw']")->click();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # test filter for Users
        my $FullTestUserLogin = "$TestUserLogin ($TestUserLogin $TestUserLogin)";
        $Selenium->find_element( "#FilterUsers", 'css' )->send_keys($FullTestUserLogin);
        sleep 1;
        $Self->True(
            $Selenium->find_element( "$FullTestUserLogin", 'link_text' )->is_displayed(),
            "$FullTestUserLogin user found on page",
        );

        # test filter for groups
        $Selenium->find_element( "#FilterGroups", 'css' )->send_keys($GroupRandomID);
        sleep 1;
        $Self->True(
            $Selenium->find_element( "$GroupRandomID", 'link_text' )->is_displayed(),
            "$GroupRandomID group found on page",
        );

        # clear test filter for Users and Groups
        $Selenium->find_element( "#FilterUsers",  'css' )->clear();
        $Selenium->find_element( "#FilterGroups", 'css' )->clear();
        sleep 1;

        # edit test group permission for test agent
        $Selenium->find_element( $GroupRandomID, 'link_text' )->VerifiedClick();

        $Selenium->find_element("//input[\@value='$UserID'][\@name='rw']")->click();
        $Selenium->find_element("//input[\@value='$UserID'][\@name='ro']")->click();
        $Selenium->find_element("//input[\@value='$UserID'][\@name='note']")->click();
        $Selenium->find_element("//input[\@value='$UserID'][\@name='owner']")->click();

        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # check edited test group permissions
        $Selenium->find_element( $GroupRandomID, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element("//input[\@value='$UserID'][\@name='move_into']")->is_selected(),
            1,
            "move_into permission for group $GroupRandomID is enabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$UserID'][\@name='create']")->is_selected(),
            1,
            "create permission for group $GroupRandomID is enabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$UserID'][\@name='rw']")->is_selected(),
            0,
            "rw permission for group $GroupRandomID is disabled",
        );

        # go back to AdminUserGroup screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminUserGroup");

        # edit test group permission for test agent
        $Selenium->find_element( $FullTestUserLogin, 'link_text' )->VerifiedClick();
        $Selenium->find_element("//input[\@value='$GroupID'][\@name='ro']")->click();
        $Selenium->find_element("//input[\@value='$GroupID'][\@name='note']")->click();

        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # check edited test agent permissions
        $Selenium->find_element( $FullTestUserLogin, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='ro']")->is_selected(),
            1,
            "ro permission for group $GroupID is enabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='note']")->is_selected(),
            1,
            "note permission for group $GroupID is enabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='rw']")->is_selected(),
            0,
            "rw permission for group $GroupID is disabled",
        );

        # since there are no tickets that rely on our test group, we can remove them again
        # from the DB
        if ($GroupRandomID) {
            my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
            my $Success  = $DBObject->Do(
                SQL => "DELETE FROM group_user WHERE group_id = $GroupID",
            );
            if ($Success) {
                $Self->True(
                    $Success,
                    "GroupUserDelete - $GroupRandomID",
                );
            }

            $GroupRandomID = $DBObject->Quote($GroupRandomID);
            $Success       = $DBObject->Do(
                SQL  => "DELETE FROM groups WHERE name = ?",
                Bind => [ \$GroupRandomID ],
            );
            $Self->True(
                $Success,
                "GroupDelete - $GroupRandomID",
            );
        }

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Group' );

    }

);

1;
