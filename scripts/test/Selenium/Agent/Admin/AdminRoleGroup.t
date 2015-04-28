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

        my $RoleRandomID  = $Helper->GetRandomID();
        my $GroupRandomID = $Helper->GetRandomID();

        #add test role
        my $RoleID = $Kernel::OM->Get('Kernel::System::Group')->RoleAdd(
            Name    => $RoleRandomID,
            ValidID => 1,
            UserID  => 1,
        );

        # add test group
        my $GroupID = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
            Name    => $GroupRandomID,
            ValidID => 1,
            UserID  => 1,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminRoleGroup");

        # check overview AdminRoleGroup
        $Selenium->find_element( "#Roles",  'css' );
        $Selenium->find_element( "#Groups", 'css' );

        $Self->True(
            index( $Selenium->get_page_source(), $RoleRandomID ) > -1,
            "$RoleRandomID role found on page",
        );

        $Self->True(
            index( $Selenium->get_page_source(), $GroupRandomID ) > -1,
            "$GroupRandomID group found on page",
        );

        # test filter for Roles
        $Selenium->find_element( "#FilterRoles", 'css' )->send_keys($RoleRandomID);
        sleep 1;
        $Self->True(
            $Selenium->find_element( "$RoleRandomID", 'link_text' )->is_displayed(),
            "$RoleRandomID role found on page",
        );

        # test filter for Groups
        $Selenium->find_element( "#FilterGroups", 'css' )->send_keys($GroupRandomID);
        sleep 1;
        $Self->True(
            $Selenium->find_element( "$GroupRandomID", 'link_text' )->is_displayed(),
            "$GroupRandomID group found on page",
        );

        # clear test filter for Roles and Groups
        $Selenium->find_element( "#FilterRoles",  'css' )->clear();
        $Selenium->find_element( "#FilterGroups", 'css' )->clear();
        sleep 1;

        # edit group relations for test role
        $Selenium->find_element( $RoleRandomID, 'link_text' )->click();
        $Selenium->find_element("//input[\@value='$GroupID'][\@name='ro']")->click();
        $Selenium->find_element("//input[\@value='$GroupID'][\@name='note']")->click();
        $Selenium->find_element("//input[\@value='$GroupID'][\@name='owner']")->click();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

        # check edited test group permissions
        $Selenium->find_element( $RoleRandomID, 'link_text' )->click();
        $Self->Is(
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='ro']")->is_selected(),
            1,
            "ro permission for group $GroupRandomID is enabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='note']")->is_selected(),
            1,
            "note permission for group $GroupRandomID is enabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='owner']")->is_selected(),
            1,
            "owner permission for group $GroupRandomID is enabled",
        );

        $Self->Is(
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='move_into']")->is_selected(),
            0,
            "move_into permission for group $GroupRandomID is disabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='priority']")->is_selected(),
            0,
            "priority permission for group $GroupRandomID is disabled",
        );
        $Selenium->go_back();

        # edit role relations for test group
        $Selenium->find_element( $GroupRandomID, 'link_text' )->click();
        $Selenium->find_element("//input[\@value='$RoleID'][\@name='move_into']")->click();
        $Selenium->find_element("//input[\@value='$RoleID'][\@name='priority']")->click();
        $Selenium->find_element("//input[\@value='$RoleID'][\@name='create']")->click();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

        # check edited test group permissions
        $Selenium->find_element( $GroupRandomID, 'link_text' )->click();
        $Self->Is(
            $Selenium->find_element("//input[\@value='$RoleID'][\@name='ro']")->is_selected(),
            1,
            "ro permission for role $RoleRandomID is enabled",
        );

        $Self->Is(
            $Selenium->find_element("//input[\@value='$RoleID'][\@name='note']")->is_selected(),
            1,
            "note permission for role $RoleRandomID is enabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$RoleID'][\@name='owner']")->is_selected(),
            1,
            "owner permission for role $RoleRandomID is enabled",
        );

        $Self->Is(
            $Selenium->find_element("//input[\@value='$RoleID'][\@name='move_into']")->is_selected(),
            1,
            "move_into permission for role $RoleRandomID is enabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$RoleID'][\@name='priority']")->is_selected(),
            1,
            "priority permission for role $RoleRandomID is enabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$RoleID'][\@name='create']")->is_selected(),
            1,
            "create permission for role $RoleRandomID is enabled",
        );

        # Since there are no tickets that rely on our test group and role, we can remove them again
        # from the DB.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        if ($GroupID) {
            my $Success = $DBObject->Do(
                SQL => "DELETE FROM group_role WHERE group_id = $GroupID",
            );

            if ($Success) {
                $Self->True(
                    $Success,
                    "GroupRoleDelete - for $GroupRandomID",
                );
            }

            $Success = $DBObject->Do(
                SQL => "DELETE FROM groups WHERE id = $GroupID",
            );

            $Self->True(
                $Success,
                "GroupDelete - $GroupRandomID",
            );
        }

        if ($RoleID) {

            my $Success = $DBObject->Do(
                SQL => "DELETE FROM roles WHERE id = $RoleID",
            );

            $Self->True(
                $Success,
                "RoleDelete - $RoleRandomID",
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Group' );
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Role' );

    }
);

1;
