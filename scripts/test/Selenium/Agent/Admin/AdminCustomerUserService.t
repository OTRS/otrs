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

use Kernel::System::UnitTest::Helper;
use Kernel::System::UnitTest::Selenium;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose => 1,
);

$Selenium->RunTest(
    sub {

        my $Helper = Kernel::System::UnitTest::Helper->new(
            RestoreSystemConfiguration => 0,
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # create test AdminCustomerUser
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminCustomerUser");

        $Selenium->find_element( "button.CallForAction", 'css' )->click();
        my $RandomID = $Helper->GetRandomID();

        $Selenium->find_element( "#UserFirstname",  'css' )->send_keys($RandomID);
        $Selenium->find_element( "#UserLastname",   'css' )->send_keys($RandomID);
        $Selenium->find_element( "#UserLogin",      'css' )->send_keys($RandomID);
        $Selenium->find_element( "#UserEmail",      'css' )->send_keys( $RandomID . "\@localhost.com" );
        $Selenium->find_element( "#UserCustomerID", 'css' )->send_keys($RandomID);
        $Selenium->find_element( "#UserFirstname",  'css' )->submit();

        # create test AdminService
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminService");

        $Selenium->find_element("//a[contains(\@href, \'ServiceID=NEW' )]")->click();
        my $RandomID2 = $Helper->GetRandomID();

        $Selenium->find_element( "#Name", 'css' )->send_keys($RandomID2);
        $Selenium->find_element( "#Name", 'css' )->submit();

        # check AdminCustomerUserService screen
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminCustomerUserService");

        $Selenium->find_element( "#FilterServices",     'css' );
        $Selenium->find_element( "#CustomerUserSearch", 'css' );
        $Selenium->find_element( "#Customers",          'css' );
        $Selenium->find_element( "#Service",            'css' );

        # test search filter for CustomerUser
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->clear();
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->send_keys($RandomID);
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->submit();
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "CustomerUser $RandomID found on page",
        );
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->clear();
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->submit();

        # filter for service. It is autocomplete, submit is not necessary
        $Selenium->find_element( "#FilterServices", 'css' )->send_keys($RandomID2);
        sleep 1;
        $Self->True(
            $Selenium->find_element( "$RandomID2", 'link_text' )->is_displayed(),
            "$RandomID2 service found on page",
        );
        $Selenium->find_element( "#FilterServices", 'css' )->clear();
        sleep 1;

        # allocate test service to test customer user
        $Selenium->find_element("//a[contains(\@href, \'CustomerUserLogin=$RandomID' )]")->click();

        my $ServiceID = $Kernel::OM->Get('Kernel::System::Service')->ServiceLookup(
            Name => $RandomID2,
        );
        $Selenium->find_element("//input[\@value='$ServiceID']")->click();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

        # check test customer user allocation to test service
        $Selenium->find_element( $RandomID2, 'link_text' )->click();

        my $CustomerUserID = $Kernel::OM->Get('Kernel::System::Service')->ServiceLookup(
            Name => $RandomID2,
        );

        $Self->Is(
            $Selenium->find_element("//input[\@value=\"$RandomID\"]")->is_selected(),
            1,
            "Service $RandomID2 is active for CustomerUser $RandomID",
        );

        # remove test customer user allocations from test service
        $Selenium->find_element("//input[\@value=\"$RandomID\"]")->click();
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->click();

        # check if there is any test service allocation towards test customer user
        $Selenium->find_element("//a[contains(\@href, \'CustomerUserLogin=$RandomID' )]")->click();

        $Self->Is(
            $Selenium->find_element("//input[\@value='$ServiceID']")->is_selected(),
            0,
            "Service $RandomID2 is not active for CustomerUser $RandomID",
        );

        # delete created test customer user
        if ($ServiceID) {
            my $Success = $DBObject->Do(
                SQL => "DELETE FROM service_customer_user WHERE service_id = $ServiceID",
            );
            $Self->True(
                $Success,
                "Deleted ServiceCustomerUser - $ServiceID",
            );

            $Success = $DBObject->Do(
                SQL  => "DELETE FROM service WHERE id = ?",
                Bind => [ \$ServiceID ],
            );
            $Self->True(
                $Success,
                "Deleted Service - $RandomID2",
            );
        }

        if ($RandomID) {
            $RandomID = $DBObject->Quote($RandomID);
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE customer_id = ?",
                Bind => [ \$RandomID ],
            );
            $Self->True(
                $Success,
                "Deleted CustomerUser - $RandomID",
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'CustomerUser',
        );
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Service',
        );

    }

);

1;
