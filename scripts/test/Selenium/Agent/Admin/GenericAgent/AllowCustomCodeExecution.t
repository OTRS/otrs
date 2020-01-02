# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Check if needed frontend module is registered in sysconfig.
return 1 if !$ConfigObject->Get('Frontend::Module')->{AdminGenericAgent};

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Allow custom script and module execution.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentAllowCustomScriptExecution',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentAllowCustomModuleExecution',
            Value => 1,
        );

        # Navigate to AdminGenericAgent screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericAgent");

        # Check overview AdminGenericAgent.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check add job page.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Update' )]")->VerifiedClick();

        my $Element = $Selenium->find_element( "#Profile", 'css' );
        $Element->is_displayed();
        $Element->is_enabled();

        # Toggle widgets.
        $Selenium->execute_script('$(".WidgetSimple.Collapsed .WidgetAction.Toggle a").click();');

        # Check that custom code elements.
        $Self->True(
            $Selenium->execute_script("return \$('#NewCMD').length === 1;"),
            "CMD input found on page",
        );
        $Self->True(
            $Selenium->execute_script("return \$('#NewModule').length === 1;"),
            "CMD input found on page",
        );

        # Allow custom script and restrict module execution.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentAllowCustomScriptExecution',
            Value => 0,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentAllowCustomModuleExecution',
            Value => 1,
        );

        # Navigate to AdminGenericAgent screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericAgent");

        # Check add job page.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Update' )]")->VerifiedClick();

        # Toggle widgets.
        $Selenium->execute_script('$(".WidgetSimple.Collapsed .WidgetAction.Toggle a").click();');

        # Check that custom code elements.
        $Self->False(
            $Selenium->execute_script("return \$('#NewCMD').length === 1;"),
            "CMD input NOT found on page",
        );
        $Self->True(
            $Selenium->execute_script("return \$('#NewModule').length === 1;"),
            "CMD input NOT found on page",
        );

        # Restrict custom script and allow module execution.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentAllowCustomScriptExecution',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentAllowCustomModuleExecution',
            Value => 0,
        );

        # Navigate to AdminGenericAgent screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericAgent");

        # Check add job page.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Update' )]")->VerifiedClick();

        # Toggle widgets.
        $Selenium->execute_script('$(".WidgetSimple.Collapsed .WidgetAction.Toggle a").click();');

        # Check that custom code elements.
        $Self->True(
            $Selenium->execute_script("return \$('#NewCMD').length === 1;"),
            "CMD input NOT found on page",
        );
        $Self->False(
            $Selenium->execute_script("return \$('#NewModule').length === 1;"),
            "CMD input NOT found on page",
        );

        # Restrict custom script and module execution.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentAllowCustomScriptExecution',
            Value => 0,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentAllowCustomModuleExecution',
            Value => 0,
        );

        # Navigate to AdminGenericAgent screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericAgent");

        # Check add job page.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Update' )]")->VerifiedClick();

        # Toggle widgets.
        $Selenium->execute_script('$(".WidgetSimple.Collapsed .WidgetAction.Toggle a").click();');

        # Check that custom code elements.
        $Self->False(
            $Selenium->execute_script("return \$('#NewCMD').length === 1;"),
            "CMD input NOT found on page",
        );
        $Self->False(
            $Selenium->execute_script("return \$('#NewModule').length === 1;"),
            "CMD input NOT found on page",
        );

    },
);

1;
