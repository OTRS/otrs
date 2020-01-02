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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my %DashboardOnlineWidgetConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name => 'DashboardBackend###0400-UserOnline',
        );

        # Make 'UserOnline' widget mandatory.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0400-UserOnline',
            Value => {
                %{ $DashboardOnlineWidgetConfig{EffectiveValue} },
                Mandatory => 1,
            },
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentDashboard screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        # check agent dashboard page
        $Self->True(
            index( $Selenium->get_page_source(), "Dashboard" ) > -1,
            "Found dashboard value on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "New Tickets" ) > -1,
            "New Tickets widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Reminder Tickets" ) > -1,
            "Reminder Tickets widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Escalated Tickets" ) > -1,
            "Escalated Tickets widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Open Tickets" ) > -1,
            "Open Tickets / Need to be answered widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Ticket Queue Overview" ) > -1,
            "Ticket Queue Overview widget found on page",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "Settings" ) > -1,
            "Setting for toggle widgets found on page",
        );

        # Check 'UserOnline' widget.
        my $Widget = $Selenium->find_element( "#Dashboard0400-UserOnline-box", 'css' );
        $Widget->is_enabled();
        $Widget->is_displayed();

        $Self->False(
            $Selenium->execute_script("return \$('#Dashboard0400-UserOnline-box > div.WidgetAction.Close').length"),
            "Remove button is not shown.",
        );

        $Self->True(
            $Selenium->execute_script("return \$('#Settings0400-UserOnline').prop('checked')"),
            "Widget is shown (checked).",
        );

        $Self->True(
            $Selenium->execute_script("return \$('#Settings0400-UserOnline').prop('disabled')"),
            "Widget is read-only.",
        );

        # Kill the session of the current user and see what happens - this needs to cause a redirect to login.
        my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
        my @Sessions      = $SessionObject->GetAllSessionIDs();
        for my $SessionID (@Sessions) {
            $SessionObject->RemoveSessionID(
                SessionID => $SessionID
            );
        }

        # Refresh the user online widget.
        $Selenium->execute_script("\$('#Dashboard0400-UserOnline-box .ActionMenu').show();");
        $Selenium->find_element( "#Dashboard0400-UserOnline-box .WidgetAction.Refresh a", "css" )->click();

        # We should now have been be redirected to the login screen.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#LoginBox:visible").length'
        ) || die "Login screen not found.";
    }
);

1;
