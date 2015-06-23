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

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable SMIME in config
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'SMIME',
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

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

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
            AdminSysConfig
            AdminSystemAddress
            AdminSystemMaintenance
            AdminType
            AdminUser
            AdminUserGroup
        );

        ADMINMODULE:
        for my $AdminModule (@AdminModules) {

            $Selenium->get("${ScriptAlias}index.pl?Action=$AdminModule");

            # Guess if the page content is ok or an error message. Here we
            #   check for the presence of div.SidebarColumn because all Admin
            #   modules have this sidebar column present.
            $Selenium->find_element( "div.SidebarColumn", 'css' );

            # Also check if the navigation is present (this is not the case
            #   for error messages and has "Admin" highlighted
            $Selenium->find_element( "li#nav-Admin.Selected", 'css' );
        }
    }
);

1;
