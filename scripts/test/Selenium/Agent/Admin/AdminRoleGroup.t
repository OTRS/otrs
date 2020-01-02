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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Add test role.
        my $RoleName = $Helper->GetRandomID();
        my $RoleID   = $Kernel::OM->Get('Kernel::System::Group')->RoleAdd(
            Name    => $RoleName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $RoleID,
            "Created Role - $RoleName",
        );

        # Add test group.
        my $GroupName = $Helper->GetRandomID();
        my $GroupID   = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $GroupID,
            "Created Group - $RoleName",
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminRoleGroup screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminRoleGroup");

        # Check overview AdminRoleGroup.
        $Selenium->find_element( "#Roles",  'css' );
        $Selenium->find_element( "#Groups", 'css' );

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        $Self->True(
            index( $Selenium->get_page_source(), $RoleName ) > -1,
            "$RoleName role found on page",
        );

        $Self->True(
            index( $Selenium->get_page_source(), $GroupName ) > -1,
            "$GroupName group found on page",
        );

        # Edit group relations for test role.
        $Selenium->find_element( $RoleName, 'link_text' )->VerifiedClick();

        # Check breadcrumb on change screen.
        my $Count = 1;
        for my $BreadcrumbText (
            'Manage Role-Group Relations',
            'Change Group Relations for Role \'' . $RoleName . '\''
            )
        {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Set permissions.
        for my $Permission (qw(ro note owner)) {
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='$Permission']")->click();
            $Selenium->WaitFor(
                JavaScript => "return \$('input[value=$GroupID][name=$Permission]:checked').length"
            );
        }

        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        my %TestFirst = (
            'ro'        => 1,
            'move_into' => 0,
            'create'    => 0,
            'note'      => 1,
            'owner'     => 1,
            'priority'  => 0,
            'rw'        => 0,
        );

        my %TestSecond = (
            'ro'        => 1,
            'move_into' => 1,
            'create'    => 1,
            'note'      => 0,
            'owner'     => 1,
            'priority'  => 1,
            'rw'        => 0,
        );

        # Check edited test group permissions.
        $Selenium->find_element( $RoleName, 'link_text' )->VerifiedClick();

        # Check permissions.
        for my $Permission ( sort keys %TestFirst ) {
            my $Enabled = $TestFirst{$Permission} ? 'enabled' : 'disabled';
            $Self->Is(
                $Selenium->find_element("//input[\@value='$GroupID'][\@name='$Permission']")->is_selected(),
                $TestFirst{$Permission},
                "$Permission permission for group $GroupName and role $RoleName is $Enabled",
            );
        }

        # Test checked and unchecked values while filter by group is used.
        # Test filter with "WrongFilterGroup" to uncheck all values.
        $Selenium->find_element( "#Filter", 'css' )->clear();
        $Selenium->find_element( "#Filter", 'css' )->send_keys("WrongFilterGroup");
        $Selenium->WaitFor(
            JavaScript => "return \$('.FilterMessage.Hidden > td:visible').length"
        );

        # Test if no data is matches.
        $Self->True(
            $Selenium->find_element( ".FilterMessage.Hidden>td", 'css' )->is_displayed(),
            "'No data matches' is displayed'"
        );
        $Selenium->find_element( "#Filter", 'css' )->clear();

        # Check permissions.
        for my $Permission ( sort keys %TestFirst ) {
            my $Enabled = $TestFirst{$Permission} ? 'enabled' : 'disabled';
            $Self->Is(
                $Selenium->find_element("//input[\@value='$GroupID'][\@name='$Permission']")->is_selected(),
                $TestFirst{$Permission},
                "$Permission permission for group $GroupName and role $RoleName is $Enabled",
            );
        }

        # Navigate to AdminRoleGroup screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminRoleGroup");

        # Edit role relations for test group.
        $Selenium->find_element( $GroupName, 'link_text' )->VerifiedClick();

        # Set permissions.
        for my $Permission (qw(note move_into priority create)) {
            my $Length = $Permission eq 'note' ? 0 : 1;

            $Selenium->find_element("//input[\@value='$RoleID'][\@name='$Permission']")->click();
            $Selenium->WaitFor(
                JavaScript => "return \$('input[value=$RoleID][name=$Permission]:checked').length === $Length"
            );
        }
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # Check edited test group permissions.
        $Selenium->find_element( $GroupName, 'link_text' )->VerifiedClick();

        # Check permissions.
        for my $Permission ( sort keys %TestSecond ) {
            my $Enabled = $TestSecond{$Permission} ? 'enabled' : 'disabled';
            $Self->Is(
                $Selenium->find_element("//input[\@value='$RoleID'][\@name='$Permission']")->is_selected(),
                $TestSecond{$Permission},
                "$Permission permission for group $GroupName and role $RoleName is $Enabled",
            );
        }

        # Test checked and unchecked values while filter is used for Role.
        # Test filter with "WrongFilterRole" to uncheck all values.
        $Selenium->find_element( "#Filter", 'css' )->clear();
        $Selenium->find_element( "#Filter", 'css' )->send_keys("WrongFilterRole");
        $Selenium->WaitFor(
            JavaScript => "return \$('.FilterMessage.Hidden > td:visible').length"
        );

        # Test is no data matches.
        $Self->True(
            $Selenium->find_element( ".FilterMessage.Hidden>td", 'css' )->is_displayed(),
            "'No data matches' is displayed'"
        );
        $Selenium->find_element( "#Filter", 'css' )->clear();

        # Check role relations for group after using filter by role.
        # Check permissions.
        for my $Permission ( sort keys %TestSecond ) {
            my $Enabled = $TestSecond{$Permission} ? 'enabled' : 'disabled';
            $Self->Is(
                $Selenium->find_element("//input[\@value='$RoleID'][\@name='$Permission']")->is_selected(),
                $TestSecond{$Permission},
                "$Permission permission for group $GroupName and role $RoleName is $Enabled",
            );
        }

        # Since there are no tickets that rely on our test group and role, we can remove them again
        # from the DB
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        if ($GroupID) {
            my $Success = $DBObject->Do(
                SQL => "DELETE FROM group_role WHERE group_id = $GroupID",
            );

            $Self->True(
                $Success,
                "GroupRoleDelete - for $GroupName",
            );

            $Success = $DBObject->Do(
                SQL => "DELETE FROM groups WHERE id = $GroupID",
            );

            $Self->True(
                $Success,
                "GroupDelete - $GroupName",
            );
        }

        if ($RoleID) {

            my $Success = $DBObject->Do(
                SQL => "DELETE FROM roles WHERE id = $RoleID",
            );

            $Self->True(
                $Success,
                "RoleDelete - $RoleName",
            );
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw(Group Role)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
