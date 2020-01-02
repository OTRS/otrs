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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Selenium     = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my ( $TestUserLogin, $UserID ) = $Helper->TestUserCreate(
            Groups => ['admin'],
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Group' );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGroup");

        # Check overview AdminGroup.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Filter for Groups are shown on wrong screens. See bug#14148.
        # Check that filter is included on page.
        $Self->True(
            $Selenium->execute_script("return \$('#FilterGroups').length === 1;"),
            "Filter is shown on page"
        );

        # Click 'Add group' link, it should not be a form link.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminGroup;Subaction=Add' )]")->VerifiedClick();

        # Check that filter is not included on page.
        $Self->True(
            $Selenium->execute_script("return \$('#FilterGroups').length === 0;"),
            "Filter is not on page"
        );

        # Check add page.
        my $Element = $Selenium->find_element( "#GroupName", 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Selenium->find_element( "#Comment", 'css' );
        $Selenium->find_element( "#ValidID", 'css' );

        # Check breadcrumb on Add screen.
        my $Count = 1;
        my $IsLinkedBreadcrumbText;
        for my $BreadcrumbText ( 'Group Management', 'Add Group' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Check client side validation.
        $Selenium->find_element( "#GroupName", 'css' )->clear();
        $Selenium->find_element( "#Submit",    'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#GroupName.Error').length"
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#GroupName').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Create a real test group.
        my $GroupName = 'TestGroup' . $Helper->GetRandomID();
        $Selenium->find_element( "#GroupName", 'css' )->send_keys($GroupName);
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 1,
        );
        $Selenium->find_element( "#Comment", 'css' )->send_keys('Selenium test group');
        $Selenium->find_element( "#Submit",  'css' )->VerifiedClick();

        # After add group followed screen is AddUserGroup(Subaction=Group),
        # there is possible to set permission for added group.
        $Self->True(
            index( $Selenium->get_page_source(), $GroupName ) > -1,
            "$GroupName found on page",
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        $Selenium->find_element("//input[\@value='$UserID'][\@name='rw']")->click();
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # Check if test group is present in AdminUserGroup.
        $Self->True(
            index( $Selenium->get_page_source(), $GroupName ) > -1,
            "$GroupName found on page",
        );

        # Check overview AdminUserGroup.
        $Selenium->find_element( "div.Size1of2 #Users",  'css' );
        $Selenium->find_element( "div.Size1of2 #Groups", 'css' );

        # Edit test group permissions.
        $Selenium->find_element( $GroupName, 'link_text' )->VerifiedClick();
        $Selenium->find_element("//input[\@value='$UserID'][\@name='rw']")->click();
        $Selenium->find_element("//input[\@value='$UserID'][\@name='ro']")->click();
        $Selenium->find_element("//input[\@value='$UserID'][\@name='note']")->click();
        $Selenium->find_element("//input[\@value='$UserID'][\@name='owner']")->click();
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # Check edited test group permissions.
        $Selenium->find_element( $GroupName, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element("//input[\@value='$UserID'][\@name='move_into']")->is_selected(),
            1,
            "move_into permission for group $GroupName is enabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$UserID'][\@name='create']")->is_selected(),
            1,
            "create permission for group $GroupName is enabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$UserID'][\@name='rw']")->is_selected(),
            0,
            "rw permission for group $GroupName is disabled",
        );

        # Go back to overview.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGroup");

        # Try to change the name of the admin group and see if validation kicks in.
        $Selenium->find_element( 'admin',      'link_text' )->VerifiedClick();
        $Selenium->find_element( "#GroupName", 'css' )->send_keys('some_other_name');
        $Selenium->find_element( "#Submit",    'css' )->click();

        # We should now see a dialog telling us changing the admin group name has some implications.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length'
        );

        # Check that filter is not included on page.
        $Self->True(
            $Selenium->execute_script("return \$('#FilterGroups').length === 0;"),
            "Filter is not on page"
        );

        # Cancel the action & go back to the overview.
        $Selenium->find_element( "#DialogButton1", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && !$(".Dialog:visible").length'
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGroup");

        # Check link to AdminGroup from AdminUserGroup.
        $Selenium->find_element( $GroupName, 'link_text' )->VerifiedClick();

        # Check test group values.
        $Self->Is(
            $Selenium->find_element( '#GroupName', 'css' )->get_value(),
            $GroupName,
            "#GroupName stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            'Selenium test group',
            "#Comment stored value",
        );

        # Check breadcrumb on Edit screen.
        $Count = 1;
        for my $BreadcrumbText ( 'Group Management', 'Edit Group: ' . $GroupName ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Set test group to invalid.
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element( "#Comment", 'css' )->clear();
        $Selenium->find_element( "#Submit",  'css' )->VerifiedClick();

        # Check is there notification after group is updated.
        my $Notification = 'Group updated!';

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' &&  \$('.MessageBox.Notice p:contains($Notification)').length"
        );

        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # Check class of invalid Group in the overview table.
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($GroupName)').length"
            ),
            "There is a class 'Invalid' for test Group",
        );

        # Navigate to Admin User Group page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminUserGroup");

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('a[href*=\"ID=$UserID\"]').length"
        );

        # Select test agent.
        $Selenium->find_element("//a[contains(\@href, \'ID=$UserID' )]")->VerifiedClick();

        # Test checkboxes.
        if ( $Selenium->execute_script("return \$('#SelectAllrw:checked').length") ) {

            # Check if top level inputs are disabled.
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('table th:nth-child(2) input:not([name=rw])').prop('disabled')"
                ),
                1,
                "Top row inputs are disabled.",
            );

            # Check if bottom level inputs are disabled.
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('table td:nth-child(2) input:not([name=rw])').prop('disabled')"
                ),
                1,
                "Table inputs are disabled.",
            );

            # Click on Master Switch.
            $Selenium->find_element( "#SelectAllrw", 'css' )->click();

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('table th:nth-child(2) input:not([name=rw])').prop('disabled') === false && \$('table td:nth-child(2) input:not([name=rw])').prop('disabled') === false"
            );

            # Check if top level inputs are enabled.
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('table th:nth-child(2) input:not([name=rw])').prop('disabled')"
                ),
                0,
                "Top row inputs are enabled.",
            );

            # Check if bottom level inputs are enabled.
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('table td:nth-child(2) input:not([name=rw])').prop('disabled')"
                ),
                0,
                "Table inputs are enabled.",
            );

        }
        else {

            # Click on Master Switch.
            $Selenium->find_element( "#SelectAllrw", 'css' )->click();

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('table th:nth-child(2) input:not([name=rw])').prop('disabled') === true && \$('table td:nth-child(2) input:not([name=rw])').prop('disabled') === true"
            );

            # Check if top level inputs are disabled.
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('table th:nth-child(2) input:not([name=rw])').prop('disabled')"
                ),
                1,
                "Top row inputs are disabled.",
            );

            # Check if bottom level inputs are disabled.
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('table td:nth-child(2) input:not([name=rw])').prop('disabled')"
                ),
                1,
                "Table inputs are disabled.",
            );
        }

        # Find first group in the table and pass its value to filter.
        my $FirstRowName = $Selenium->execute_script("return \$('table td:first-child').first().text()");
        $Selenium->find_element( "#Filter", 'css' )->send_keys($FirstRowName);

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(\'input[name="rw"]:visible\').length !== $(\'input[name="rw"]\').length;'
        );

        # Click on Master check if not already checked.
        if ( !$Selenium->execute_script("return \$('#SelectAllrw:checked').length") ) {
            $Selenium->find_element( "#SelectAllrw", 'css' )->click();
        }

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".FilterRemove:visible").length === 1;'
        );

        # Remove selected filter.
        $Selenium->find_element( ".FilterRemove", 'css' )->click();

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("table td:nth-child(2) input:not([name=rw])").prop("disabled") === true'
        );

        # Check if first line is disabled.
        $Self->Is(
            $Selenium->execute_script("return \$('table td:nth-child(2) input:not([name=rw])').prop('disabled')"),
            1,
            "First line is disabled.",
        );

        # Since there are no tickets that rely on our test group, we can remove them again
        # from the DB.
        if ($GroupName) {
            my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
            my $GroupID  = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup(
                Group => $GroupName,
            );

            my $Success = $DBObject->Do(
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
