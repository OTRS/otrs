# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));
use File::Path qw(mkpath rmtree);

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get needed objects
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # create directory for certificates and private keys
        my $CertPath    = $ConfigObject->Get('Home') . "/var/tmp/certs";
        my $PrivatePath = $ConfigObject->Get('Home') . "/var/tmp/private";
        mkpath( [$CertPath],    0, 0770 );    ## no critic
        mkpath( [$PrivatePath], 0, 0770 );    ## no critic

        # make sure to enable cloud services
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CloudServices::Disabled',
            Value => 0,
        );

        # enable SMIME in config
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME',
            Value => 1
        );

        # set SMIME paths in sysConfig
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME::CertPath',
            Value => $CertPath,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME::PrivatePath',
            Value => $PrivatePath,
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

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # get test data
        my @AdminModules = qw(
            AdminACL
            AdminAttachment
            AdminAutoResponse
            AdminCustomerCompany
            AdminCustomerUser
            AdminCustomerUserGroup
            AdminCustomerUserService
            AdminDynamicField
            AdminEmail
            AdminGenericAgent
            AdminGenericInterfaceWebservice
            AdminGroup
            AdminLog
            AdminMailAccount
            AdminNotificationEvent
            AdminOTRSBusiness
            AdminPGP
            AdminPackageManager
            AdminPerformanceLog
            AdminPostMasterFilter
            AdminPriority
            AdminProcessManagement
            AdminQueue
            AdminQueueAutoResponse
            AdminQueueTemplates
            AdminTemplate
            AdminTemplateAttachment
            AdminRegistration
            AdminRole
            AdminRoleGroup
            AdminRoleUser
            AdminSLA
            AdminSMIME
            AdminSalutation
            AdminSelectBox
            AdminService
            AdminSupportDataCollector
            AdminSession
            AdminSignature
            AdminState
            AdminSystemConfiguration
            AdminSystemConfigurationGroup
            AdminSystemAddress
            AdminSystemMaintenance
            AdminType
            AdminUser
            AdminUserGroup
        );

        ADMINMODULE:
        for my $AdminModule (@AdminModules) {

            # navigate to appropriate screen in the test
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=$AdminModule");

            # Guess if the page content is ok or an error message. Here we
            #   check for the presence of div.SidebarColumn because all Admin
            #   modules have this sidebar column present.
            $Selenium->find_element( "div.SidebarColumn", 'css' );

            # check if a breadcrumb is present
            $Selenium->find_element( "ul.BreadCrumb", 'css' );

            # Also check if the navigation is present (this is not the case
            #   for error messages and has "Admin" highlighted
            $Selenium->find_element( "li#nav-Admin.Selected", 'css' );
        }

        # delete needed test directories
        for my $Directory ( $CertPath, $PrivatePath ) {
            my $Success = rmtree( [$Directory] );
            $Self->True(
                $Success,
                "Directory deleted - '$Directory'",
            );
        }

        # Go to grid view.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=Admin");

        # Add AdminACL to favourites.
        $Selenium->execute_script(
            "\$('span[data-module=AdminACL]').trigger('click')"
        );

        # Wait until AdminACL gets class IsFavourite.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('li[data-module=\"AdminACL\"]').hasClass('IsFavourite');"
        );

        # Remove AdminACL from favourites.
        $Selenium->execute_script(
            "\$('.DataTable .RemoveFromFavourites').trigger('click')"
        );

        # Checks if Add as Favourite star is visible again.
        $Self->True(
            $Selenium->execute_script(
                "return \$('span[data-module=AdminACL]').length === 1"
            ),
            "AddAsFavourite (Star) button is displayed as expected.",
        );

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.RemoveFromFavourites').length === 1;"
        );

        # Removes AdminACL from favourites.
        $Selenium->execute_script(
            "\$('.DataTable .RemoveFromFavourites').trigger('click')"
        );

        # Wait until IsFavourite class is removed from AdminACL row.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && !\$('tr[data-module=\"AdminACL\"]').hasClass('IsFavourite');"
        );

        # Check if AddAsFavourite on list view has IsFavourite class, false is expected.
        $Self->True(
            $Selenium->execute_script(
                "return !\$('tr[data-module=\"AdminACL\"] a.AddAsFavourite').hasClass('IsFavourite')"
            ),
            "AddAsFavourite (star) on list view is visible.",
        );
        }
);

1;
