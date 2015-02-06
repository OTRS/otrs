# --
# AdminCustomerUserGroup.t - frontend tests for AdminCustomerUserGroup
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
my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
my $DBObject        = $Kernel::OM->Get('Kernel::System::DB');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose => 1,
);

$Selenium->RunTest(
    sub {

        my $Helper = Kernel::System::UnitTest::Helper->new(
            RestoreSystemConfiguration => 1,
        );

        # enable CustomerGroupSupport
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'CustomerGroupSupport',
            Value => 1
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # create new CustomerUser for the tests
        my $UserRandomID = "user" . $Helper->GetRandomID();
        my $UserID       = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            UserFirstname  => $UserRandomID,
            UserLastname   => $UserRandomID,
            UserCustomerID => $UserRandomID,
            UserLogin      => $UserRandomID,
            UserEmail      => $UserRandomID . '@localhost.com',
            ValidID        => 1,
            UserID         => 1,
        );

        # create new Group for the tests
        my $GroupRandomID = "group" . $Helper->GetRandomID();
        my $GroupID       = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
            Name    => $GroupRandomID,
            ValidID => 1,
            UserID  => 1,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminCustomerUserGroup");

        # check overview AdminCustomerUserGroup
        $Selenium->find_element( "#Customers",          'css' );
        $Selenium->find_element( "#Group",              'css' );
        $Selenium->find_element( "#CustomerUserSearch", 'css' );
        $Selenium->find_element( "#FilterGroups",       'css' );
        $Selenium->find_element( "#AlwaysGroups",       'css' );

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
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->submit();

        $Self->True(
            index( $Selenium->get_page_source(), $UserRandomID ) > -1,
            "$UserRandomID user found on page",
        );

        # clear CustomerUser filter
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->clear();
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->submit();

        # test Filter for Groups
        $Selenium->find_element( "#FilterGroups", 'css' )->send_keys($GroupRandomID);
        sleep 1;

        $Self->True(
            $Selenium->find_element( "$GroupRandomID", 'link_text' )->is_displayed(),
            "$GroupRandomID group found on page",
        );

        # change test CustomerUser relations for test Group
        $Selenium->find_element( $GroupRandomID, 'link_text' )->click();

        $Selenium->find_element("//input[\@value='$UserRandomID'][\@name='rw']")->click();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

        # check test Group relation for test CustomerUser
        my $CustomerUserLink = "$UserRandomID $UserRandomID <$UserRandomID\@localhost.com> ($UserRandomID)";
        $Selenium->find_element( $CustomerUserLink, 'link_text' )->click();

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
        $Selenium->find_element("//input[\@value='$GroupID'][\@name='rw']")->click();
        $Selenium->find_element("//input[\@value='$GroupID'][\@name='ro']")->click();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

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

        # enable CustomerGroupSupport
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'CustomerGroupSupport',
            Value => 0
        );

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
