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

        # Disable check email address.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0
        );

        # Enable CustomerGroupSupport.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CustomerGroupSupport',
            Value => 1
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

        # Create new CustomerUser for the tests.
        my $UserRandomID   = "user" . $Helper->GetRandomID();
        my $CustomerUserID = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            UserFirstname  => $UserRandomID,
            UserLastname   => $UserRandomID,
            UserCustomerID => $UserRandomID,
            UserLogin      => $UserRandomID,
            UserEmail      => $UserRandomID . '@localhost.com',
            ValidID        => 1,
            UserID         => 1,
        );
        $Self->True(
            $CustomerUserID,
            "CustomerUserAdd - $CustomerUserID",
        );

        # Create new Group for the tests.
        my $GroupRandomID = "group" . $Helper->GetRandomID();
        my $GroupID       = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
            Name    => $GroupRandomID,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $GroupID,
            "GroupAdd - $GroupID",
        );

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AdminCustomerUserGroup.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminCustomerUserGroup");

        # Check overview AdminCustomerUserGroup.
        $Selenium->find_element( "#Customers",          'css' );
        $Selenium->find_element( "#Group",              'css' );
        $Selenium->find_element( "#CustomerUserSearch", 'css' );
        $Selenium->find_element( "#FilterGroups",       'css' );
        $Selenium->find_element( "#AlwaysGroups",       'css' );

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Check for Customer default Groups.
        my @CustomerAlwaysGroups = @{ $ConfigObject->Get('CustomerGroupAlwaysGroups') };
        if (@CustomerAlwaysGroups) {
            for my $AlwaysGroupID (@CustomerAlwaysGroups) {
                $Self->True(
                    index( $Selenium->get_page_source(), $AlwaysGroupID ) > -1,
                    "$AlwaysGroupID default AlwaysGroup found on page",
                );
            }
        }

        # Test CustomerUser filter.
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->clear();
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->send_keys($UserRandomID);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();

        # Check for created test CustomerUser and Group on screen.
        $Self->True(
            index( $Selenium->get_page_source(), $UserRandomID ) > -1,
            "$UserRandomID user found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $GroupRandomID ) > -1,
            "$GroupRandomID group found on page",
        );

        # Clear CustomerUser filter.
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->clear();
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();

        # Test Filter for Groups.
        $Selenium->find_element( "#FilterGroups", 'css' )->send_keys($GroupRandomID);
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#Group li:not(.Header):visible').length === 1"
        );

        $Self->True(
            $Selenium->find_element( "$GroupRandomID", 'link_text' )->is_displayed(),
            "$GroupRandomID group found on page",
        );

        # Change test CustomerUser relations for test Group.
        $Selenium->find_element( $GroupRandomID, 'link_text' )->VerifiedClick();

        # Check breadcrumb on change screen.
        my $Count = 1;
        my $IsLinkedBreadcrumbText;
        for my $BreadcrumbText (
            'Manage Customer User-Group Relations',
            'Change Customer User Relations for Group \'' . $GroupRandomID . '\''
            )
        {
            $Self->Is(
                $Selenium->execute_script("return \$(\$('.BreadCrumb li')[$Count]).text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        $Selenium->find_element( "#CustomerUserSearch", 'css' )->clear();
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->send_keys($UserRandomID);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();

        $Selenium->find_element("//input[\@value='$UserRandomID'][\@name='rw']")->click();
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # Check test Group relation for test CustomerUser.
        my $CustomerUserLink = "$UserRandomID $UserRandomID <$UserRandomID\@localhost.com> ($UserRandomID)";
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('a:contains($CustomerUserLink)').length"
        );

        $Selenium->find_element( $CustomerUserLink, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='rw']")->is_selected(),
            1,
            "Full read and write permission for $GroupRandomID is enabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='ro']")->is_selected(),
            1,
            "Read only permission for $GroupRandomID is enabled",
        );

        # Remove test Group relation for test CustomerUser.
        $Selenium->find_element("//input[\@value='$GroupID'][\@name='rw']")->click();
        $Selenium->find_element("//input[\@value='$GroupID'][\@name='ro']")->click();

        $Self->Is(
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='rw']")->is_selected(),
            0,
            "Full read and write permission for $GroupRandomID is disabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='ro']")->is_selected(),
            0,
            "Read only permission for $GroupRandomID is disabled",
        );

        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Since there are no tickets that rely on our test CustomerUserGroup we can remove
        # it from DB, delete test CustomerUser and test Group.
        if ($UserRandomID) {
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE customer_id = ?",
                Bind => [ \$UserRandomID ],
            );
            $Self->True(
                $Success,
                "Deleted CustomerUser - $UserRandomID",
            );
        }

        if ($GroupRandomID) {
            my $Success = $DBObject->Do(
                SQL => "DELETE FROM groups WHERE id = $GroupID",
            );
            $Self->True(
                $Success,
                "Deleted Group - $GroupRandomID",
            );
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (qw(Group User DBGroupUserGet)) {
            $CacheObject->CleanUp( Type => $Cache );
        }

    }

);

1;
