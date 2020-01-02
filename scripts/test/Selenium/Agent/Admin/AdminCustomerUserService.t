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

        # Create test CustomerUser.
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
        $Self->True(
            $CustomerUserID,
            "CustomerUserAdd - $CustomerUserID",
        );

        # Create test Service.
        my $ServiceName = 'SomeService' . $Helper->GetRandomID();
        my $ServiceID   = $Kernel::OM->Get('Kernel::System::Service')->ServiceAdd(
            Name    => $ServiceName,
            Comment => 'Some Comment',
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $ServiceID,
            "ServiceAdd - $ServiceID",
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

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate AdminCustomerUserService screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminCustomerUserService");

        # Check overview AdminCustomerUserService.
        $Selenium->find_element( "#FilterServices",     'css' );
        $Selenium->find_element( "#CustomerUserSearch", 'css' );
        $Selenium->find_element( "#Customers",          'css' );
        $Selenium->find_element( "#Service",            'css' );

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Filter for service. It is auto complete, submit is not necessary.
        $Selenium->find_element( "#FilterServices", 'css' )->send_keys($ServiceName);
        $Self->True(
            $Selenium->find_element( "$ServiceName", 'link_text' )->is_displayed(),
            "$ServiceName service found on page",
        );
        $Selenium->find_element( "#FilterServices", 'css' )->clear();

        # Test search filter for CustomerUser.
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->clear();
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->send_keys($CustomerUserName);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), $CustomerUserName ) > -1,
            "CustomerUser $CustomerUserName found on page",
        );

        # Allocate test service to test customer user.
        $Selenium->find_element("//a[contains(\@href, \'CustomerUserLogin=$CustomerUserName' )]")->VerifiedClick();

        # Check breadcrumb on allocate screen.
        my $Count = 1;
        my $IsLinkedBreadcrumbText;
        for my $BreadcrumbText (
            'Manage Customer User-Service Relations',
            'Allocate Services to Customer User \''
            . $CustomerUserName . ' '
            . $CustomerUserName . ' ('
            . $CustomerUserName . ')\''
            )
        {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        $Selenium->find_element("//input[\@value='$ServiceID']")->click();
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # Check test customer user allocation to test service.
        $Selenium->find_element( $ServiceName, 'link_text' )->VerifiedClick();

        $Selenium->find_element( "#CustomerUserSearch", 'css' )->clear();
        $Selenium->find_element( "#CustomerUserSearch", 'css' )->send_keys($CustomerUserName);
        $Selenium->find_element("//button[\@value='Search'][\@type='submit']")->VerifiedClick();

        $Self->Is(
            $Selenium->find_element("//input[contains(\@title, \'Toggle active state for $CustomerUserName' )]")
                ->is_selected(),
            1,
            "Service $ServiceName is active for CustomerUser $CustomerUserName",
        ) || die;

        # Remove test customer user allocations from test service.
        $Selenium->find_element( "#SelectAllItemsSelected", 'css' )->click();
        $Selenium->find_element("//button[\@value='Save'][\@type='submit']")->VerifiedClick();

        # Check if there is any test service allocation towards test customer user
        $Selenium->find_element("//a[contains(\@href, \'CustomerUserLogin=$CustomerUserName' )]")->VerifiedClick();
        $Selenium->find_element( "#FilterServices", 'css' )->send_keys($ServiceName);

        $Self->Is(
            $Selenium->find_element("//input[\@title=\'Toggle active state for $ServiceName\']")->is_selected(),
            0,
            "Service $ServiceName is not active for CustomerUser $CustomerUserName",
        ) || die;

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete created test customer user.
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

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw( CustomerUser Service )) {
            $CacheObject->CleanUp(
                Type => $Cache,
            );
        }
    }

);

1;
