# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # disable check email address
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0
        );

        # enable CustomerGroupSupport
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CustomerGroupSupport',
            Value => 1
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # create new CustomerUser for the tests
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

        # create new Group for the tests
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

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AdminCustomerUserGroup
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminCustomerUserGroup");

        # check overview AdminCustomerUserGroup
        $Selenium->find_element( "#Customers",          'css' );
        $Selenium->find_element( "#Group",              'css' );
        $Selenium->find_element( "#CustomerUserSearch", 'css' );
        $Selenium->find_element( "#FilterGroups",       'css' );
        $Selenium->find_element( "#AlwaysGroups",       'css' );

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        #check for Customer default Groups
        my @CustomerAlwaysGroups = @{ $ConfigObject->Get('CustomerGroupAlwaysGroups') };
        if (@CustomerAlwaysGroups) {
            for my $AlwaysGroupID (@CustomerAlwaysGroups) {
                $Self->True(
                    index( $Selenium->get_page_source(), $AlwaysGroupID ) > -1,
                    "$AlwaysGroupID default AlwaysGroup found on page",
                );
            }
        }

        # check for created test CustomerUser and Group on screen
        $Self->True(
            index( $Selenium->get_page_source(), $UserRandomID ) > -1,
            "$UserRandomID user found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $GroupRandomID ) > -1,
            "$GroupRandomID group found on page",
        );

        # test CustomerUser filter
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->clear();
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->send_keys($UserRandomID);
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->VerifiedSubmit();

        $Self->True(
            index( $Selenium->get_page_source(), $UserRandomID ) > -1,
            "$UserRandomID user found on page",
        );

        # clear CustomerUser filter
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->clear();
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->VerifiedSubmit();

        # test Filter for Groups
        $Selenium->find_element( "#FilterGroups", 'css' )->send_keys($GroupRandomID);
        sleep 1;

        $Self->True(
            $Selenium->find_element( "$GroupRandomID", 'link_text' )->is_displayed(),
            "$GroupRandomID group found on page",
        );

        # change test CustomerUser relations for test Group
        $Selenium->find_element( $GroupRandomID, 'link_text' )->VerifiedClick();

        # check breadcrumb on change screen
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

        $Selenium->find_element("//input[\@value='$UserRandomID'][\@name='rw']")->VerifiedClick();
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # check test Group relation for test CustomerUser
        my $CustomerUserLink = "$UserRandomID $UserRandomID <$UserRandomID\@localhost.com> ($UserRandomID)";
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

        # remove test Group relation for test CustomerUser
        $Selenium->find_element("//input[\@value='$GroupID'][\@name='rw']")->VerifiedClick();
        $Selenium->find_element("//input[\@value='$GroupID'][\@name='ro']")->VerifiedClick();
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Since there are no tickets that rely on our test CustomerUserGroup we can remove
        # it from DB, delete test CustomerUser and test Group
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

        # make sure cache is correct
        for my $Cache (
            qw(Group User DBGroupUserGet)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => $Cache );
        }

    }

);

1;
