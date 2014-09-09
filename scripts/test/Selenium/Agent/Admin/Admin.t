# --
# Admin.t - frontend tests for admin area
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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

        my @AdminModules = qw(
            AdminAttachment
            AdminAutoResponse
            AdminCustomerCompany
            AdminCustomerUser
            AdminCustomerUserGroup
            AdminCustomerUserService
            AdminEmail
            AdminGenericAgent
            AdminGroup
            AdminLog
            AdminMailAccount
            AdminNotification
            AdminNotificationEvent
            AdminPGP
            AdminPackageManager
            AdminPerformanceLog
            AdminPostMasterFilter
            AdminPriority
            AdminQueue
            AdminQueueAutoResponse
            AdminQueueTemplates
            AdminTemplate
            AdminTemplateAttachment
            AdminRole
            AdminRoleGroup
            AdminRoleUser
            AdminSLA
            AdminSMIME
            AdminSalutation
            AdminSelectBox
            AdminService
            AdminSession
            AdminSignature
            AdminState
            AdminSysConfig
            AdminSystemAddress
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
