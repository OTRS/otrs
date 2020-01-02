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

use Kernel::Language;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        $Selenium->set_window_size( 600, 400 );

        my $Language      = 'de';
        my $TestUserLogin = $Helper->TestUserCreate(
            Language => $Language,
            Groups   => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentDashboard screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        # Wait until jquery is ready.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function'" );

        # The mobile navigation toggle should be visible.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveNavigationHandle:visible').length"),
            1,
            "Mobile navigation toggle should be visible"
        );

        # The mobile sidebar toggle should be visible.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveSidebarHandle:visible').length"),
            1,
            "Mobile sidebar toggle should be visible"
        );

        # Check for toolbar visibility.
        $Self->Is(
            $Selenium->execute_script("return parseInt(\$('#ToolBar').css('height'), 10)"),
            0,
            "Toolbar height should be 0"
        );

        # Expand navigation bar.
        $Selenium->find_element( "#ResponsiveNavigationHandle", "css" )->click();

        # Wait for animation has finished.
        sleep 2;

        $Self->Is(
            $Selenium->execute_script("return \$('#NavigationContainer:visible').length"),
            1,
            "Navigation bar should be visible"
        );

        # Collapse navigation bar again.
        $Selenium->find_element( "#ResponsiveNavigationHandle", "css" )->click();

        # Wait for animation has finished.
        sleep 2;

        $Self->Is(
            $Selenium->execute_script("return \$('#NavigationContainer:visible').length"),
            0,
            "Navigation bar should be hidden again"
        );

        # Expand sidebar.
        $Selenium->find_element( "#ResponsiveSidebarHandle", "css" )->click();

        # Wait for animation has finished.
        sleep 2;

        $Self->Is(
            $Selenium->execute_script("return \$('.ResponsiveSidebarContainer:visible').length"),
            1,
            "Sidebar bar should be visible"
        );

        # Collapse sidebar again.
        $Selenium->find_element( "#ResponsiveSidebarHandle", "css" )->click();

        # Wait for animation has finished.
        sleep 2;

        $Self->Is(
            $Selenium->execute_script("return \$('.ResponsiveSidebarContainer:visible').length"),
            0,
            "Sidebar bar should be hidden again"
        );

        # Expand toolbar.
        $Selenium->find_element( "#Logo", "css" )->click();
        $Selenium->WaitFor( JavaScript => "return parseInt(\$('#ToolBar').css('height'), 10) > 0" );
        $Self->True(
            $Selenium->execute_script("return parseInt(\$('#ToolBar').css('height'), 10) > 0"),
            "Toolbar should be visible"
        );

        # Wait for animation has finished.
        sleep 2;

        # While the toolbar is expanded, navigation and sidebar toggle should be hidden.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveNavigationHandle:visible').length"),
            0,
            "Mobile navigation toggle should be hidden"
        );

        # The mobile sidebar toggle should be visible.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveSidebarHandle:visible').length"),
            0,
            "Mobile sidebar toggle should be hidden"
        );

        # Collapse toolbar again.
        $Selenium->find_element( "#Logo", "css" )->click();
        $Selenium->WaitFor( JavaScript => "return parseInt(\$('#ToolBar').css('height'), 10) === 0" );
        $Self->True(
            $Selenium->execute_script("return parseInt(\$('#ToolBar').css('height'), 10) == 0"),
            "Toolbar should be hidden again"
        );

        # Wait for animation has finished.
        sleep 2;

        # Now that the toolbar is collapsed again, navigation and sidebar toggle should be visible.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveNavigationHandle:visible').length"),
            1,
            "Mobile navigation toggle should be visible"
        );

        # The mobile sidebar toggle should be visible.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveSidebarHandle:visible').length"),
            1,
            "Mobile sidebar toggle should be visible"
        );

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        # Check for the viewmode switch.
        $Self->Is(
            $Selenium->execute_script("return \$('#ViewModeSwitch > a').text();"),
            $LanguageObject->Translate(
                'Switch to desktop mode'
            ),
            'Check for mobile mode switch text',
        );

        # Toggle the switch.
        $Selenium->find_element( "#ViewModeSwitch", "css" )->click();

        # Wait until jquery is ready.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function'" );
        sleep 1;

        # Check for the viewmode switch.
        $Self->Is(
            $Selenium->execute_script("return \$('#ViewModeSwitch > a').text();"),
            $LanguageObject->Translate(
                'Switch to mobile mode'
            ),
            'Check for mobile mode switch text',
        );

        # We should now be in desktop mode, thus the toggles should be hidden.
        # While the toolbar is expanded, navigation and sidebar toggle should be hidden.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveNavigationHandle:visible').length"),
            0,
            "Mobile navigation toggle should be hidden"
        );

        # The mobile sidebar toggle should be visible.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveSidebarHandle:visible').length"),
            0,
            "Mobile sidebar toggle should be hidden"
        );

        # Toggle the switch again.
        $Selenium->find_element( "#ViewModeSwitch", "css" )->click();

        # Wait until jquery is ready.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function'" );
        sleep 1;

        # Check for the viewmode switch.
        $Self->Is(
            $Selenium->execute_script("return \$('#ViewModeSwitch > a').text();"),
            $LanguageObject->Translate(
                'Switch to desktop mode'
            ),
            'Check for mobile mode switch text',
        );

        # We should now be in desktop mode, thus the toggles should be hidden.
        # While the toolbar is expanded, navigation and sidebar toggle should be hidden.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveNavigationHandle:visible').length"),
            1,
            "Mobile navigation toggle should be visible"
        );

        # The mobile sidebar toggle should be visible.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveSidebarHandle:visible').length"),
            1,
            "Mobile sidebar toggle should be visible"
        );
    }
);

1;
