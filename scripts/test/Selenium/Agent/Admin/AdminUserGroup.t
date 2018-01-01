# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
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
        my $GroupName = 'group' . $Helper->GetRandomID();
        my $GroupID   = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
            Name    => $GroupName,
            Comment => 'Selenium test group',
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $GroupID,
            "Created Group - $GroupName",
        );

        # navigate to AdminUserGroup screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminUserGroup");

        # check overview AdminUserGroup
        $Selenium->find_element( "#Users",  'css' );
        $Selenium->find_element( "#Groups", 'css' );

        # click on created test group
        $Selenium->find_element( $GroupName, 'link_text' )->VerifiedClick();

        # give full read and write access to the tickets in test group for test user
        $Selenium->find_element("//input[\@value='$UserID'][\@name='rw']")->VerifiedClick();
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
        $Selenium->find_element( "#FilterGroups", 'css' )->send_keys($GroupName);
        sleep 1;
        $Self->True(
            $Selenium->find_element( "$GroupName", 'link_text' )->is_displayed(),
            "$GroupName group found on page",
        );

        # clear test filter for Users and Groups
        $Selenium->find_element( "#FilterUsers",  'css' )->clear();
        $Selenium->find_element( "#FilterGroups", 'css' )->clear();
        sleep 1;

        # edit test group permission for test agent
        $Selenium->find_element( $GroupName, 'link_text' )->VerifiedClick();

        my %TestFirst = (
            'ro'        => 1,
            'move_into' => 1,
            'create'    => 1,
            'note'      => 1,
            'owner'     => 1,
            'priority'  => 1,
            'rw'        => 1,
        );

        my %TestSecond = (
            'ro'        => 0,
            'move_into' => 1,
            'create'    => 1,
            'note'      => 0,
            'owner'     => 0,
            'priority'  => 1,
            'rw'        => 0,
        );

        my %TestThird = (
            'ro'        => 1,
            'move_into' => 1,
            'create'    => 1,
            'note'      => 1,
            'owner'     => 0,
            'priority'  => 0,
            'rw'        => 0,
        );

        # check permissions
        for my $Permission ( sort keys %TestFirst ) {
            $Self->True(
                $Selenium->find_element("//input[\@value='$UserID'][\@name='$Permission']"),
                "$Permission permission for user $TestUserLogin in group $GroupName is enabled",
            );
        }

        # set permissions
        for my $Permission (qw(rw ro note owner)) {
            $Selenium->find_element("//input[\@value='$UserID'][\@name='$Permission']")->VerifiedClick();
        }

        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # check edited test group permissions
        $Selenium->find_element( $GroupName, 'link_text' )->VerifiedClick();

        # check permissions
        for my $Permission ( sort keys %TestSecond ) {
            my $Enabled = $TestSecond{$Permission} ? 'enabled' : 'disabled';
            $Self->Is(
                $Selenium->find_element("//input[\@value='$UserID'][\@name='$Permission']")->is_selected(),
                $TestSecond{$Permission},
                "$Permission permission for user $TestUserLogin in group $GroupName is $Enabled",
            );
        }

        # test checked and unchecked values while filter by user is used
        # test filter with "WrongFilterGroup" to uncheck all values
        $Selenium->find_element( "#Filter", 'css' )->clear();
        $Selenium->find_element( "#Filter", 'css' )->send_keys("WrongFilterGroup");
        sleep 1;

        # test if no data is matches
        $Self->True(
            $Selenium->find_element( ".FilterMessage.Hidden>td", 'css' )->is_displayed(),
            "'No data matches' is displayed'"
        );
        $Selenium->find_element( "#Filter", 'css' )->clear();

        # check group relations for user after using filter by group
        # check permissions
        for my $Permission ( sort keys %TestSecond ) {
            my $Enabled = $TestSecond{$Permission} ? 'enabled' : 'disabled';
            $Self->Is(
                $Selenium->find_element("//input[\@value='$UserID'][\@name='$Permission']")->is_selected(),
                $TestSecond{$Permission},
                "$Permission permission for user $TestUserLogin in group $GroupName is $Enabled",
            );
        }

        # go back to AdminUserGroup screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminUserGroup");

        # edit test group permission for test agent
        $Selenium->find_element( $FullTestUserLogin, 'link_text' )->VerifiedClick();

        # set permissions
        for my $Permission (qw(ro note priority)) {
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='$Permission']")->VerifiedClick();
        }

        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # check edited test agent permissions
        $Selenium->find_element( $FullTestUserLogin, 'link_text' )->VerifiedClick();

        for my $Permission ( sort keys %TestThird ) {
            my $Enabled = $TestThird{$Permission} ? 'enabled' : 'disabled';
            $Self->Is(
                $Selenium->find_element("//input[\@value='$GroupID'][\@name='$Permission']")->is_selected(),
                $TestThird{$Permission},
                "$Permission permission for user $TestUserLogin in group $GroupName is $Enabled",
            );
        }

        # since there are no tickets that rely on our test group, we can remove them again
        # from the DB
        if ($GroupName) {
            my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
            my $Success  = $DBObject->Do(
                SQL => "DELETE FROM group_user WHERE group_id = $GroupID",
            );
            if ($Success) {
                $Self->True(
                    $Success,
                    "GroupUserDelete - $GroupName",
                );
            }

            $GroupName = $DBObject->Quote($GroupName);
            $Success   = $DBObject->Do(
                SQL  => "DELETE FROM groups WHERE name = ?",
                Bind => [ \$GroupName ],
            );
            $Self->True(
                $Success,
                "GroupDelete - $GroupName",
            );
        }

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Group' );

    }

);

1;
