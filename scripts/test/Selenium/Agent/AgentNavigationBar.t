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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # get test user ID
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

        # wait for the drag & drop initialization to be completed
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#nav-Admin.CanDrag').length"
        );

        # try to drag the admin item to the front of the nav bar
        $Selenium->DragAndDrop(
            Element      => 'li#nav-Admin',
            Target       => 'ul#Navigation',
            TargetOffset => {
                X => 0,
                Y => 0,
                }
        );

        # wait for the success arrow to show up
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#NavigationContainer > .fa-check').length"
        );

        # now reload the page and see if the new position of the admin item has been re-stored correctly
        # (should be the first element in the list now)
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        # wait for the navigation bar to be visible
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && parseInt(\$('#Navigation').css('opacity'), 10) == 1"
        );

        # check if the admin item is in the correct position
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Navigation li:first-child').attr('id');"
            ),
            'nav-Admin',
            'Admin item found on correct position',
        );
    }
);

1;
