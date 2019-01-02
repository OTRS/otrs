# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
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

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentDashboard screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        # wait until jquery is ready
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function'" );

        # the mobile navigation toggle should be visible
        my $ItemVisible = $Selenium->execute_script(
            q{
                return $('#ResponsiveNavigationHandle:visible').length;
            }
        );
        $Self->Is(
            $ItemVisible,
            1,
            "Mobile navigation toggle should be visible."
        );

        # the mobile sidebar toggle should be visible
        $ItemVisible = $Selenium->execute_script(
            q{
                return $('#ResponsiveSidebarHandle:visible').length;
            }
        );
        $Self->Is(
            $ItemVisible,
            1,
            "Mobile sidebar toggle should be visible."
        );

        # check for toolbar visibility
        $ItemVisible = $Selenium->execute_script(
            q{
                return $("ul#ToolBar").height();
            }
        );
        $Self->Is(
            $ItemVisible,
            0,
            "Toolbar height should be 0"
        );

        # expand navigation bar
        $Selenium->find_element( "#ResponsiveNavigationHandle", "css" )->VerifiedClick();
        sleep 1;
        $ItemVisible = $Selenium->execute_script(
            q{
                return $('#NavigationContainer:visible').length;
            }
        );
        $Self->Is(
            $ItemVisible,
            1,
            "Navigation bar should be visible"
        );

        # collapse navigation bar again
        $Selenium->find_element( "#ResponsiveNavigationHandle", "css" )->VerifiedClick();
        sleep 1;
        $ItemVisible = $Selenium->execute_script(
            q{
                return $('#NavigationContainer:visible').length;
            }
        );
        $Self->Is(
            $ItemVisible,
            0,
            "Navigation bar should be hidden again"
        );

        # expand sidebar
        $Selenium->find_element( "#ResponsiveSidebarHandle", "css" )->VerifiedClick();
        sleep 1;
        $ItemVisible = $Selenium->execute_script(
            q{
                return $('.ResponsiveSidebarContainer:visible').length;
            }
        );
        $Self->Is(
            $ItemVisible,
            1,
            "Sidebar bar should be visible"
        );

        # collapse sidebar again
        $Selenium->find_element( "#ResponsiveSidebarHandle", "css" )->VerifiedClick();
        sleep 1;
        $ItemVisible = $Selenium->execute_script(
            q{
                return $('.ResponsiveSidebarContainer:visible').length;
            }
        );
        $Self->Is(
            $ItemVisible,
            0,
            "Sidebar bar should be hidden again"
        );

        # expand toolbar
        $Selenium->find_element( "#Logo", "css" )->VerifiedClick();
        sleep 1;
        $ItemVisible = $Selenium->execute_script(
            q{
                return $('#ToolBar').css('height');
            }
        );
        $Self->True(
            $ItemVisible > 0,
            "Toolbar should be visible"
        );

        # while the toolbar is expanded, navigation and sidebar toggle should be hidden
        $ItemVisible = $Selenium->execute_script(
            q{
                return $('#ResponsiveNavigationHandle:visible').length;
            }
        );
        $Self->Is(
            $ItemVisible,
            0,
            "Mobile navigation toggle should be hidden."
        );

        # the mobile sidebar toggle should be visible
        $ItemVisible = $Selenium->execute_script(
            q{
                return $('#ResponsiveSidebarHandle:visible').length;
            }
        );
        $Self->Is(
            $ItemVisible,
            0,
            "Mobile sidebar toggle should be hidden."
        );

        # collapse toolbar again
        $Selenium->find_element( "#Logo", "css" )->VerifiedClick();
        sleep 1;
        $ItemVisible = $Selenium->execute_script(
            q{
                return $('#ToolBar').css('height');
            }
        );
        $Self->True(
            $ItemVisible == 0,
            "Toolbar should be hidden again"
        );

        # now that the toolbar is collapsed again, navigation and sidebar toggle should be visible
        $ItemVisible = $Selenium->execute_script(
            q{
                return $('#ResponsiveNavigationHandle:visible').length;
            }
        );
        $Self->Is(
            $ItemVisible,
            1,
            "Mobile navigation toggle should be visible."
        );

        # the mobile sidebar toggle should be visible
        $ItemVisible = $Selenium->execute_script(
            q{
                return $('#ResponsiveSidebarHandle:visible').length;
            }
        );
        $Self->Is(
            $ItemVisible,
            1,
            "Mobile sidebar toggle should be visible."
        );

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        # check for the viewmode switch
        $Self->Is(
            $Selenium->execute_script("return \$('#ViewModeSwitch > a').text();"),
            $LanguageObject->Translate(
                'Switch to desktop mode'
            ),
            'Check for mobile mode switch text',
        );

        # toggle the switch
        $Selenium->find_element( "#ViewModeSwitch", "css" )->VerifiedClick();

        # wait until jquery is ready
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function'" );

        # check for the viewmode switch
        $Self->Is(
            $Selenium->execute_script("return \$('#ViewModeSwitch > a').text();"),
            $LanguageObject->Translate(
                'Switch to mobile mode'
            ),
            'Check for mobile mode switch text',
        );

        # we should now be in desktop mode, thus the toggles should be hidden
        # while the toolbar is expanded, navigation and sidebar toggle should be hidden
        $ItemVisible = $Selenium->execute_script(
            q{
                return $('#ResponsiveNavigationHandle:visible').length;
            }
        );
        $Self->Is(
            $ItemVisible,
            0,
            "Mobile navigation toggle should be hidden."
        );

        # the mobile sidebar toggle should be visible
        $ItemVisible = $Selenium->execute_script(
            q{
                return $('#ResponsiveSidebarHandle:visible').length;
            }
        );
        $Self->Is(
            $ItemVisible,
            0,
            "Mobile sidebar toggle should be hidden."
        );

        # toggle the switch again
        $Selenium->find_element( "#ViewModeSwitch", "css" )->VerifiedClick();

        # wait until jquery is ready
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function'" );

        # check for the viewmode switch
        $Self->Is(
            $Selenium->execute_script("return \$('#ViewModeSwitch > a').text();"),
            $LanguageObject->Translate(
                'Switch to desktop mode'
            ),
            'Check for mobile mode switch text',
        );

        # we should now be in desktop mode, thus the toggles should be hidden
        # while the toolbar is expanded, navigation and sidebar toggle should be hidden
        $ItemVisible = $Selenium->execute_script(
            q{
                return $('#ResponsiveNavigationHandle:visible').length;
            }
        );
        $Self->Is(
            $ItemVisible,
            1,
            "Mobile navigation toggle should be visible."
        );

        # the mobile sidebar toggle should be visible
        $ItemVisible = $Selenium->execute_script(
            q{
                return $('#ResponsiveSidebarHandle:visible').length;
            }
        );
        $Self->Is(
            $ItemVisible,
            1,
            "Mobile sidebar toggle should be visible."
        );

    }
);

1;
