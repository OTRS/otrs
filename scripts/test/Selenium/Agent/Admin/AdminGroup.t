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

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminGroup");

        # check overview AdminGroup
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # click 'add group' linK
        $Selenium->find_element("//button[\@value='Add'][\@type='submit']")->click();

        # check add page
        my $Element = $Selenium->find_element( "#GroupName", 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Selenium->find_element( "#Comment", 'css' );
        $Selenium->find_element( "#ValidID", 'css' );

        # check client side validation
        $Selenium->find_element( "#GroupName", 'css' )->clear();
        $Selenium->find_element( "#GroupName", 'css' )->submit();
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#GroupName').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # create a real test group
        my $RandomID = 'TestGroup' . $Helper->GetRandomID();
        $Selenium->find_element( "#GroupName", 'css' )->send_keys($RandomID);
        $Selenium->execute_script("\$('#ValidID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Comment",   'css' )->send_keys('Selenium test group');
        $Selenium->find_element( "#GroupName", 'css' )->submit();

        # after add group followed screen is AddUserGroup(Subaction=Group),
        # there is posible to set permission for added group
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID found on page",
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # give full read and write access to the tickets in test group for test user
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        $Selenium->find_element("//input[\@value='$UserID'][\@name='rw']")->click();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

        # check if test group is present in AdminUserGroup
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID found on page",
        );

        # check overview AdminUserGroup
        $Selenium->find_element( "div.Size1of2 #Users",  'css' );
        $Selenium->find_element( "div.Size1of2 #Groups", 'css' );

        # edit test group permissions
        $Selenium->find_element( $RandomID, 'link_text' )->click();
        $Selenium->find_element("//input[\@value='$UserID'][\@name='rw']")->click();
        $Selenium->find_element("//input[\@value='$UserID'][\@name='ro']")->click();
        $Selenium->find_element("//input[\@value='$UserID'][\@name='note']")->click();
        $Selenium->find_element("//input[\@value='$UserID'][\@name='owner']")->click();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

        # wait until overview screen has loaded, if neccessary
        $Selenium->WaitFor( JavaScript => 'return $("#Groups").length' );

        # check edited test group permissions
        $Selenium->find_element( $RandomID, 'link_text' )->click();

        $Self->Is(
            $Selenium->find_element("//input[\@value='$UserID'][\@name='move_into']")->is_selected(),
            1,
            "move_into permission for group $RandomID is enabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$UserID'][\@name='create']")->is_selected(),
            1,
            "create permission for group $RandomID is enabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$UserID'][\@name='rw']")->is_selected(),
            0,
            "rw permission for group $RandomID is disabled",
        );

        # check link to AdminGroup from AdminUserGroup
        $Selenium->find_element( $RandomID, 'link_text' )->click();

        # check test group values
        $Self->Is(
            $Selenium->find_element( '#GroupName', 'css' )->get_value(),
            $RandomID,
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

        # set test group to invalid
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Comment",   'css' )->clear();
        $Selenium->find_element( "#GroupName", 'css' )->submit();

        # chack class of invalid Group in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($RandomID)').length"
            ),
            "There is a class 'Invalid' for test Group",
        );

        # since there are no tickets that rely on our test group, we can remove them again
        # from the DB.
        if ($RandomID) {
            my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
            my $GroupID  = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup(
                Group => $RandomID,
            );

            my $Success = $DBObject->Do(
                SQL => "DELETE FROM group_user WHERE group_id = $GroupID",
            );
            if ($Success) {
                $Self->True(
                    $Success,
                    "GroupUserDelete - $RandomID",
                );
            }

            $RandomID = $DBObject->Quote($RandomID);
            $Success  = $DBObject->Do(
                SQL  => "DELETE FROM groups WHERE name = ?",
                Bind => [ \$RandomID ],
            );
            $Self->True(
                $Success,
                "GroupDelete - $RandomID",
            );
        }

        # make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Group' );

    }

);

1
