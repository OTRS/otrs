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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # disable check email address
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # enable CustomerGroupSupport
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CustomerGroupSupport',
            Value => 1,
        );

        # activate external context
        my $PermissionContextDirect          = 'UnitTestPermission-direct';
        my $PermissionContextOtherCustomerID = 'UnitTestPermission-other-CustomerID';
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CustomerGroupPermissionContext',
            Value => {
                '001-CustomerID-same'  => { Value => $PermissionContextDirect },
                '100-CustomerID-other' => { Value => $PermissionContextOtherCustomerID },
            },
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

        # create new CustomerCompany for the tests
        my $CustomerRandomID = 'customer' . $Helper->GetRandomID();
        my $CustomerID       = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
            CustomerID          => $CustomerRandomID,
            CustomerCompanyName => $CustomerRandomID,
            ValidID             => 1,
            UserID              => 1,
        );
        $Self->True(
            $CustomerID,
            "CustomerCompanyAdd - $CustomerID",
        );

        # create new Group for the tests
        my $GroupRandomID = 'group' . $Helper->GetRandomID();
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

        # navigate to AdminCustomerGroup
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminCustomerGroup");

        # check overview AdminCustomerGroup
        $Selenium->find_element( "#Customers",      'css' );
        $Selenium->find_element( "#Group",          'css' );
        $Selenium->find_element( "#CustomerSearch", 'css' );
        $Selenium->find_element( "#FilterGroups",   'css' );
        $Selenium->find_element( "#AlwaysGroups",   'css' );

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # check for Customer default Groups
        my @CustomerAlwaysGroups = @{ $ConfigObject->Get('CustomerGroupCompanyAlwaysGroups') };
        if (@CustomerAlwaysGroups) {
            for my $AlwaysGroupID (@CustomerAlwaysGroups) {
                $Self->True(
                    index( $Selenium->get_page_source(), $AlwaysGroupID ) > -1,
                    "$AlwaysGroupID default AlwaysGroup found on page",
                );
            }
        }

        # check for created test Customer and Group on screen
        $Self->True(
            index( $Selenium->get_page_source(), $CustomerRandomID ) > -1,
            "$CustomerRandomID user found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), $GroupRandomID ) > -1,
            "$GroupRandomID group found on page",
        );

        # test Customer search
        $Selenium->find_element( "#CustomerSearch", 'css' )->clear();
        $Selenium->find_element( "#CustomerSearch", 'css' )->send_keys($CustomerRandomID);
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), $CustomerRandomID ) > -1,
            "$CustomerRandomID user found on page",
        );

        # clear CustomerUser filter
        $Selenium->find_element( "#CustomerSearch", 'css' )->clear();
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # test Filter for Groups
        $Selenium->find_element( "#FilterGroups", 'css' )->send_keys($GroupRandomID);
        sleep 1;

        $Self->True(
            $Selenium->find_element( "$GroupRandomID", 'link_text' )->is_displayed(),
            "$GroupRandomID group found on page",
        );

        # change test Customer relations for test Group
        $Selenium->find_element( $GroupRandomID, 'link_text' )->VerifiedClick();

        # check breadcrumb on change screen
        my $Count = 1;
        my $IsLinkedBreadcrumbText;
        for my $BreadcrumbText (
            'Manage Customer-Group Relations',
            'Change Customer Relations for Group \'' . $GroupRandomID . '\''
            )
        {
            $Self->Is(
                $Selenium->execute_script("return \$(\$('.BreadCrumb li')[$Count]).text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        $Selenium->find_element("//input[\@value='$CustomerRandomID'][\@name='${PermissionContextDirect}_rw']")
            ->click();
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # check test Group relation for test CustomerUser
        my $CustomerLink = "$CustomerRandomID $CustomerRandomID";
        $Selenium->find_element( $CustomerLink, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='${PermissionContextDirect}_rw']")
                ->is_selected(),
            1,
            "Full read and write permission for $GroupRandomID is enabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='${PermissionContextDirect}_ro']")
                ->is_selected(),
            1,
            "Read only permission for $GroupRandomID is enabled",
        );

        # remove test Group relation for test Customer
        $Selenium->find_element("//input[\@value='$GroupID'][\@name='${PermissionContextDirect}_rw']")->click();
        $Selenium->find_element("//input[\@value='$GroupID'][\@name='${PermissionContextDirect}_ro']")->click();
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # change test Customer external relations for test Group
        $Selenium->find_element( $GroupRandomID, 'link_text' )->VerifiedClick();

        $Selenium->find_element("//input[\@value='$CustomerRandomID'][\@name='${PermissionContextOtherCustomerID}_rw']")
            ->click();
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # check test Group relation for test Customer
        $Selenium->find_element( $CustomerLink, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='${PermissionContextOtherCustomerID}_rw']")
                ->is_selected(),
            1,
            "Full external read and write permission for $GroupRandomID is enabled",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@value='$GroupID'][\@name='${PermissionContextOtherCustomerID}_ro']")
                ->is_selected(),
            1,
            "External read only permission for $GroupRandomID is enabled",
        );

        # remove test Group relation for test CustomerUser
        $Selenium->find_element("//input[\@value='$GroupID'][\@name='${PermissionContextOtherCustomerID}_rw']")
            ->click();
        $Selenium->find_element("//input[\@value='$GroupID'][\@name='${PermissionContextOtherCustomerID}_ro']")
            ->click();
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Since there are no tickets that rely on our test CustomerGroup we can remove
        # it from DB, delete test CustomerUser and test Group
        if ($CustomerRandomID) {
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
                Bind => [ \$CustomerRandomID ],
            );
            $Self->True(
                $Success,
                "Deleted Customer - $CustomerRandomID",
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
            qw(Group CustomerCompany DBGroupCustomerGet)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => $Cache );
        }
    },
);

1;
