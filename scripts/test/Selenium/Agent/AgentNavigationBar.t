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

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        # Wait for the drag & drop initialization to be completed.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#nav-Admin.CanDrag').length;"
        );

        # TODO: remove limitation to firefox.
        if ( $Selenium->{browser_name} eq 'firefox' ) {
            $Self->True(
                1,
                "TODO: DragAndDrop is currently disabled in Firefox",
            );
        }
        else {

            # Try to drag the admin item to the front of the nav bar.
            $Selenium->DragAndDrop(
                Element      => 'li#nav-Admin',
                Target       => 'ul#Navigation',
                TargetOffset => {
                    X => 0,
                    Y => 0,
                }
            );

            # Wait for the success arrow to show up.
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#NavigationContainer > .fa-check').length"
            );

            # Now reload the page and see if the new position of the admin item has been re-stored correctly
            # (should be the first element in the list now).
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

            # Wait for the navigation bar to be visible.
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && parseInt(\$('#Navigation').css('opacity'), 10) == 1;"
            );

            # Check if the admin item is in the correct position.
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#Navigation li:first-child').attr('id');"
                ),
                'nav-Admin',
                'Admin item found on correct position',
            );
        }
    }
);

1;
