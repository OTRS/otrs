# --
# 100-Admin.t - frontend tests for admin area
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::System::UnitTest::Helper;

if ( !$Self->{ConfigObject}->Get('SeleniumTestsActive') ) {
    $Self->True( 1, 'Selenium testing is not active' );
    return 1;
}

require Kernel::System::UnitTest::Selenium;    ## no critic

my $Helper = Kernel::System::UnitTest::Helper->new(
    UnitTestObject => $Self,
    %{$Self},
    RestoreSystemConfiguration => 0,
);

my $TestUserLogin = $Helper->TestUserCreate(
    Groups => ['admin'],
) || die "Did not get test user";

for my $SeleniumScenario ( @{ $Helper->SeleniumScenariosGet() } ) {
    eval {
        my $Selenium = Kernel::System::UnitTest::Selenium->new(
            Verbose        => 1,
            UnitTestObject => $Self,
            %{$SeleniumScenario},
        );

        eval {

            $Selenium->Login(
                Type     => 'Agent',
                User     => $TestUserLogin,
                Password => $TestUserLogin,
            );

            my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

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
                $Selenium->open_ok("${ScriptAlias}index.pl?Action=$AdminModule");
                $Selenium->wait_for_page_to_load_ok("30000");

                # Guess if the page content is ok or an error message. Here we
                #   check for the presence of div.SidebarColumn because all Admin
                #   modules have this sidebar column present.
                $Selenium->is_element_present_ok("css=div.SidebarColumn");

                # Also check if the navigation is present (this is not the case
                #   for error messages and has "Admin" highlighted
                $Selenium->is_element_present_ok("css=li#nav-Admin.Selected");
            }
            return 1;
        } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );

        return 1;

    } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );
}

1;
