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
use File::Path qw(mkpath rmtree);

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get needed objects
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $JSONObject   = $Kernel::OM->Get('Kernel::System::JSON');

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

        # get configured agent frontend modules
        my $FrontendModules = $ConfigObject->Get('Frontend::Module');

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

            # Navigate to appropriate screen in the test
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=$AdminModule");

            # Check if needed frontend module is registered in sysconfig.
            # Skip test for unregistered modules (e.g. OTRS Business)
            if ( !$FrontendModules->{$AdminModule} ) {

                next ADMINMODULE if $AdminModule eq 'AdminOTRSBusiness';
                $Self->True(
                    index(
                        $Selenium->get_page_source(),
                        "Module Kernel::Modules::$AdminModule not registered in Kernel/Config.pm!"
                    ) > 0,
                    "Module $AdminModule is not registered in sysconfig, skipping test..."
                );
                next ADMINMODULE;
            }

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

        # Delete needed test directories.
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

        # Apply a text filter to the admin tiles and wait until it's done.
        #   We do this by subscribing to a specific event that will be raised when the filter is applied. When the
        #   filter text has been set, the test will until a global flag variable is set to a true value. In the end,
        #   event subscription will be cleared.
        my $ApplyFilter = sub {
            my $FilterText = shift;

            return if !$FilterText;

            # Set up a callback on the filter change event.
            my $Handle = $Selenium->execute_script(
                "return Core.App.Subscribe('Event.UI.Table.InitTableFilter.Change', function () {
                    window.Filtered = true;
                });"
            );

            # Reset the flag.
            $Selenium->execute_script('window.Filtered = false;');

            # Apply a filter.
            $Selenium->find_element( 'input#Filter', 'css' )->clear();
            $Selenium->find_element( 'input#Filter', 'css' )->send_keys($FilterText);

            # Wait until the flag is set.
            $Selenium->WaitFor( JavaScript => 'return window.Filtered;' );

            my $HandleJSON = $JSONObject->Encode(
                Data => $Handle,
            );

            # Clear the callback.
            $Selenium->execute_script("Core.App.Unsubscribe($HandleJSON);");

            return 1;
        };

        # Check a count of visible tiles in specific category.
        my $CheckTileCount = sub {
            my ( $ContainerTitle, $ExpectedTileCount ) = @_;

            return if !$ContainerTitle || !$ExpectedTileCount;

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('.Header h2:contains(\"$ContainerTitle\")').parents('.WidgetSimple').find('.ItemListGrid li:visible').length;"
                ),
                $ExpectedTileCount,
                "Tile count for '$ContainerTitle'"
            );

            return 1;
        };

        # Filter a complete category (see bug#14039 for more information).
        $ApplyFilter->('users');

        # Verify 12 tiles from affected category are shown.
        $CheckTileCount->( 'Users, Groups & Roles', 12 );

        # Filter a couple of tiles.
        $ApplyFilter->('customer');

        # Verify 6 tiles from affected category are shown.
        $CheckTileCount->( 'Users, Groups & Roles', 6 );

        # Filter just a single tile.
        $ApplyFilter->('Communication Log');

        # Verify only one tile from affected category is shown.
        $CheckTileCount->( 'Communication & Notifications', 1 );
    }
);

1;
