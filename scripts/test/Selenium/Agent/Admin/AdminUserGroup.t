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

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get test user ID.
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Group' );

        # Create test group.
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

        # Navigate to AdminUserGroup screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminUserGroup");

        # Check overview AdminUserGroup.
        $Selenium->find_element( "#Users",  'css' );
        $Selenium->find_element( "#Groups", 'css' );

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Click on created test group.
        $Selenium->find_element( $GroupName, 'link_text' )->VerifiedClick();

        # Check breadcrumb on change screen.
        my $Count = 1;
        for my $BreadcrumbText (
            'Manage Agent-Group Relations',
            'Change Agent Relations for Group \'' . $GroupName . '\''
            )
        {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Give full read and write access to the tickets in test group for test user.
        $Selenium->find_element("//input[\@value='$UserID'][\@name='rw']")->click();
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('input[value=$UserID][name=rw]:checked').length"
        );
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # Test filter for Users.
        my $FullTestUserLogin = "$TestUserLogin ($TestUserLogin $TestUserLogin)";
        $Selenium->find_element( "#FilterUsers", 'css' )->send_keys($FullTestUserLogin);
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#Users li:not(.Header):visible').length === 1"
        );
        $Self->True(
            $Selenium->find_element( "$FullTestUserLogin", 'link_text' )->is_displayed(),
            "$FullTestUserLogin user found on page",
        );

        # Test filter for groups.
        $Selenium->find_element( "#FilterGroups", 'css' )->send_keys($GroupName);
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#Groups li:not(.Header):visible').length === 1"
        );
        $Self->True(
            $Selenium->find_element( "$GroupName", 'link_text' )->is_displayed(),
            "$GroupName group found on page",
        );

        # Edit test group permission for test agent.
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

        # Check permissions.
        for my $Permission ( sort keys %TestFirst ) {
            $Self->True(
                $Selenium->find_element("//input[\@value='$UserID'][\@name='$Permission']"),
                "$Permission permission for user $TestUserLogin in group $GroupName is enabled",
            );
        }

        # Set permissions.
        for my $Permission (qw(rw ro note owner)) {
            $Selenium->find_element("//input[\@value='$UserID'][\@name='$Permission']")->click();
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('input[value=$GroupID][name=$Permission]:checked').length === $TestSecond{$Permission}"
            );
        }

        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # Check edited test group permissions.
        $Selenium->find_element( $GroupName, 'link_text' )->VerifiedClick();

        # Check permissions.
        for my $Permission ( sort keys %TestSecond ) {
            my $Enabled = $TestSecond{$Permission} ? 'enabled' : 'disabled';
            $Self->Is(
                $Selenium->find_element("//input[\@value='$UserID'][\@name='$Permission']")->is_selected(),
                $TestSecond{$Permission},
                "$Permission permission for user $TestUserLogin in group $GroupName is $Enabled",
            );
        }

        # Test checked and unchecked values while filter by user is used.
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

        # Check group relations for user after using filter by group.
        # Check permissions.
        for my $Permission ( sort keys %TestSecond ) {
            my $Enabled = $TestSecond{$Permission} ? 'enabled' : 'disabled';
            $Self->Is(
                $Selenium->find_element("//input[\@value='$UserID'][\@name='$Permission']")->is_selected(),
                $TestSecond{$Permission},
                "$Permission permission for user $TestUserLogin in group $GroupName is $Enabled",
            );
        }

        # Go back to AdminUserGroup screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminUserGroup");

        # Edit test group permission for test agent.
        $Selenium->find_element( $FullTestUserLogin, 'link_text' )->VerifiedClick();

        # Set permissions.
        for my $Permission (qw(ro note priority)) {
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='$Permission']")->click();
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('input[value=$GroupID][name=$Permission]:checked').length === $TestThird{$Permission}"
            );
        }

        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # Check edited test agent permissions.
        $Selenium->find_element( $FullTestUserLogin, 'link_text' )->VerifiedClick();

        for my $Permission ( sort keys %TestThird ) {
            my $Enabled = $TestThird{$Permission} ? 'enabled' : 'disabled';
            $Self->Is(
                $Selenium->find_element("//input[\@value='$GroupID'][\@name='$Permission']")->is_selected(),
                $TestThird{$Permission},
                "$Permission permission for user $TestUserLogin in group $GroupName is $Enabled",
            );
        }

        # Check if top level inputs are enabled.
        $Self->Is(
            $Selenium->execute_script("return \$('table th:nth-child(2) input:not([name=\"rw\"])').prop('disabled')"),
            0,
            "Top row inputs are enabled.",
        );

        # Click on Master Switch.
        $Selenium->find_element( "#SelectAllrw", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('table input[type=checkbox]:checked').length === \$('table input[type=checkbox]:visible').length"
        );

        # Check if top level inputs are disabled.
        $Self->Is(
            $Selenium->execute_script("return \$('table th:nth-child(2) input:not([name=\"rw\"])').prop('disabled')"),
            1,
            "Top row inputs are disabled.",
        );

        # Check if bottom level inputs are disabled.
        $Self->Is(
            $Selenium->execute_script("return \$('table td:nth-child(2) input:not([name=\"rw\"])').prop('disabled')"),
            1,
            "Table inputs are disabled.",
        );

        # Check if test row is disabled and checked.
        $Self->Is(
            $Selenium->execute_script(
                "return \$(\"a[href*='ID=$GroupID']\").parent().next().children('input').prop('disabled');"
            ),
            1,
            "Selected row is disabled.",
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$(\"a[href*='ID=$GroupID']\").parent().next().children('input').prop('checked');"
            ),
            1,
            "Selected row is checked.",
        );

        $Selenium->find_element( "#SelectAllrw", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('input[name=rw]:checked').length"
        );

        # Find test group in the table and pass its value to filter.
        $Selenium->find_element( "#Filter", 'css' )->send_keys($GroupName);
        $Selenium->WaitFor(
            JavaScript =>
                'return $("input[name=rw]:not(#SelectAllrw):visible").length === 1 && $(".FilterRemove:visible").length'
        );

        # Click on Master check if not already checked.
        if ( !$Selenium->execute_script("return \$('#SelectAllrw:checked').length") ) {
            $Selenium->find_element( "#SelectAllrw", 'css' )->click();
            $Selenium->WaitFor(
                JavaScript =>
                    "return \$('table input[type=checkbox]:checked:visible').length === \$('table input[type=checkbox]:visible').length"
            );
        }

        # Remove selected filter.
        $Selenium->find_element( ".FilterRemove", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('table input[name=rw]:visible').length === \$('table input[name=rw]').length"
        );

        # Check if test row is disabled and checked.
        $Self->Is(
            $Selenium->execute_script(
                "return \$(\"a[href*='ID=$GroupID']\").parent().next().children('input').prop('disabled');"
            ),
            1,
            "Selected row is disabled.",
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$(\"a[href*='ID=$GroupID']\").parent().next().children('input').prop('checked');"
            ),
            1,
            "Selected row is checked.",
        );

        # Since there are no tickets that rely on our test group, we can remove them again
        # from the DB.
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

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Group' );
    }
);

1;
