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
my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
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

        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # create test CustomerUser
        my $CustomerUserName = "CustomerUser" . $Helper->GetRandomID();
        my $CustomerUserID   = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            UserFirstname  => $CustomerUserName,
            UserLastname   => $CustomerUserName,
            UserCustomerID => $CustomerUserName,
            UserLogin      => $CustomerUserName,
            UserEmail      => $CustomerUserName . '@localhost.com',
            ValidID        => 1,
            UserID         => 1,
        );

        # create test Service
        my $ServiceName = 'SomeService' . $Helper->GetRandomID();
        my $ServiceID   = $Kernel::OM->Get('Kernel::System::Service')->ServiceAdd(
            Name    => $ServiceName,
            Comment => 'Some Comment',
            ValidID => 1,
            UserID  => 1,
        );

        # check AdminCustomerUserService screen
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminCustomerUserService");

        $Selenium->find_element( "#FilterServices",     'css' );
        $Selenium->find_element( "#CustomerUserSearch", 'css' );
        $Selenium->find_element( "#Customers",          'css' );
        $Selenium->find_element( "#Service",            'css' );

        # test search filter for CustomerUser
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->clear();
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->send_keys($CustomerUserName);
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->submit();
        $Self->True(
            index( $Selenium->get_page_source(), $CustomerUserName ) > -1,
            "CustomerUser $CustomerUserName found on page",
        );
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->clear();
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->submit();

        # filter for service. It is autocomplete, submit is not necessary
        $Selenium->find_element( "#FilterServices", 'css' )->send_keys($ServiceName);
        $Self->True(
            $Selenium->find_element( "$ServiceName", 'link_text' )->is_displayed(),
            "$ServiceName service found on page",
        );
        $Selenium->find_element( "#FilterServices", 'css' )->clear();

        # allocate test service to test customer user
        $Selenium->find_element("//a[contains(\@href, \'CustomerUserLogin=$CustomerUserName' )]")->click();
        $Selenium->find_element("//input[\@value='$ServiceID']")->click();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

        # check test customer user allocation to test service
        $Selenium->find_element( $ServiceName, 'link_text' )->click();

        $Self->Is(
            $Selenium->find_element("//input[\@value=\"$CustomerUserName\"]")->is_selected(),
            1,
            "Service $ServiceName is active for CustomerUser $CustomerUserName",
        );

        # remove test customer user allocations from test service
        $Selenium->find_element("//input[\@value=\"$CustomerUserName\"]")->click();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

        # check if there is any test service allocation towards test customer user
        $Selenium->find_element("//a[contains(\@href, \'CustomerUserLogin=$CustomerUserName' )]")->click();

        $Self->Is(
            $Selenium->find_element("//input[\@value='$ServiceID']")->is_selected(),
            0,
            "Service $ServiceName is not active for CustomerUser $CustomerUserName",
        );

        # delete created test customer user
        if ($ServiceID) {
            my $Success = $DBObject->Do(
                SQL => "DELETE FROM service_customer_user WHERE service_id = $ServiceID",
            );
            $Self->True(
                $Success,
                "Deleted ServiceCustomerUser - $ServiceName <=> $CustomerUserName",
            );

            $Success = $DBObject->Do(
                SQL  => "DELETE FROM service WHERE id = ?",
                Bind => [ \$ServiceID ],
            );
            $Self->True(
                $Success,
                "Deleted Service - $ServiceName",
            );
        }

        if ($CustomerUserID) {
            $CustomerUserName = $DBObject->Quote($CustomerUserName);
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE customer_id = ?",
                Bind => [ \$CustomerUserName ],
            );
            $Self->True(
                $Success,
                "Deleted CustomerUser - $CustomerUserName",
            );
        }

        # make sure the cache is correct.
        for my $Cache (qw( CustomerUser Service )) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }

);

1;
