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

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Group' );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGroup");

        # check overview AdminGroup
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # click 'Add group' linK
        $Selenium->find_element("//button[\@value='Add'][\@type='submit']")->VerifiedClick();

        # check add page
        my $Element = $Selenium->find_element( "#GroupName", 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Selenium->find_element( "#Comment", 'css' );
        $Selenium->find_element( "#ValidID", 'css' );

        # check breadcrumb on Add screen
        my $Count = 0;
        my $IsLinkedBreadcrumbText;
        for my $BreadcrumbText ( 'You are here:', 'Group Management', 'Add Group' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $IsLinkedBreadcrumbText =
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').children('a').length");

            if ( $BreadcrumbText eq 'Group Management' ) {
                $Self->Is(
                    $IsLinkedBreadcrumbText,
                    1,
                    "Breadcrumb text '$BreadcrumbText' is linked"
                );
            }
            else {
                $Self->Is(
                    $IsLinkedBreadcrumbText,
                    0,
                    "Breadcrumb text '$BreadcrumbText' is not linked"
                );
            }

            $Count++;
        }

        # check client side validation
        $Selenium->find_element( "#GroupName", 'css' )->clear();
        $Selenium->find_element( "#GroupName", 'css' )->VerifiedSubmit();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#GroupName').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # create a real test group
        my $GroupName = 'TestGroup' . $Helper->GetRandomID();
        $Selenium->find_element( "#GroupName", 'css' )->send_keys($GroupName);
        $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Comment",   'css' )->send_keys('Selenium test group');
        $Selenium->find_element( "#GroupName", 'css' )->VerifiedSubmit();

        # after add group followed screen is AddUserGroup(Subaction=Group),
        # there is posible to set permission for added group
        $Self->True(
            index( $Selenium->get_page_source(), $GroupName ) > -1,
            "$GroupName found on page",
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # give full read and write access to the tickets in test group for test user
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        $Selenium->find_element("//input[\@value='$UserID'][\@name='rw']")->VerifiedClick();
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # check if test group is present in AdminUserGroup
        $Self->True(
            index( $Selenium->get_page_source(), $GroupName ) > -1,
            "$GroupName found on page",
        );

        # check overview AdminUserGroup
        $Selenium->find_element( "div.Size1of2 #Users",  'css' );
        $Selenium->find_element( "div.Size1of2 #Groups", 'css' );

        # edit test group permissions
        $Selenium->find_element( $GroupName, 'link_text' )->VerifiedClick();
        $Selenium->find_element("//input[\@value='$UserID'][\@name='rw']")->VerifiedClick();
        $Selenium->find_element("//input[\@value='$UserID'][\@name='ro']")->VerifiedClick();
        $Selenium->find_element("//input[\@value='$UserID'][\@name='note']")->VerifiedClick();
        $Selenium->find_element("//input[\@value='$UserID'][\@name='owner']")->VerifiedClick();
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # check edited test group permissions
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

        # go back to overview
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGroup");

        # try to change the name of the admin group and see if validation kicks in
        $Selenium->find_element( 'admin',      'link_text' )->VerifiedClick();
        $Selenium->find_element( "#GroupName", 'css' )->send_keys('some_other_name');
        $Selenium->find_element( "#GroupName", 'css' )->VerifiedSubmit();

        # we should now see a dialog telling us changing the admin group name has some implications
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;'
        );

        # cancel the action & go back to the overview
        $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGroup");

        # check link to AdminGroup from AdminUserGroup
        $Selenium->find_element( $GroupName, 'link_text' )->VerifiedClick();

        # check test group values
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

        # check breadcrumb on Edit screen
        $Count = 0;
        for my $BreadcrumbText ( 'You are here:', 'Group Management', 'Edit Group: ' . $GroupName ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $IsLinkedBreadcrumbText =
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').children('a').length");

            if ( $BreadcrumbText eq 'Group Management' ) {
                $Self->Is(
                    $IsLinkedBreadcrumbText,
                    1,
                    "Breadcrumb text '$BreadcrumbText' is linked"
                );
            }
            else {
                $Self->Is(
                    $IsLinkedBreadcrumbText,
                    0,
                    "Breadcrumb text '$BreadcrumbText' is not linked"
                );
            }

            $Count++;
        }

        # set test group to invalid
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Comment",   'css' )->clear();
        $Selenium->find_element( "#GroupName", 'css' )->VerifiedSubmit();

        #check is there notification after group is updated
        my $Notification = 'Group updated!';
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # chack class of invalid Group in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($GroupName)').length"
            ),
            "There is a class 'Invalid' for test Group",
        );

        # since there are no tickets that rely on our test group, we can remove them again
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

        # make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Group' );

    }

);

1
