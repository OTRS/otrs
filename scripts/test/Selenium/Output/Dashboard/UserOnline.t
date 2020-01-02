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

        # First delete all pre-existing sessions.
        $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Session::DeleteAll')->Execute();

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Get UserOnline config.
        my %UserOnlineSysConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name    => 'DashboardBackend###0400-UserOnline',
            Default => 1,
        );

        # Enable UserOnline and set it to load as default plugin.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0400-UserOnline',
            Value => {
                %{ $UserOnlineSysConfig{EffectiveValue} },
                Default => 1,
            },
        );

        # Create test customer user and login several times in order to rack up number of user sessions.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        for ( 1 .. 5 ) {
            $Selenium->Login(
                Type     => 'Customer',
                User     => $TestCustomerUserLogin,
                Password => $TestCustomerUserLogin,
            );

            # Remove all cookies for current session.
            $Selenium->delete_all_cookies();
        }

        # Clean up the dashboard cache.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Dashboard' );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Verify only one agent user is accounted for.
        my $AgentsLink = $Selenium->find_element("//a[contains(\@id, \'UserOnlineAgent' )]");
        $Self->Is(
            $AgentsLink->get_text() // '',
            'Agents (1)',
            'Only one agent user accounted for'
        );

        if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Agent::UnavailableForExternalChatsOnLogin') ) {
            $Self->True(
                1,
                "UnavailableForExternalChatsOnLogin config is set, skipping test..."
            );
            return 1;
        }

        # Test UserOnline plugin for agent.
        my $ExpectedAgent = "$TestUserLogin";
        $Self->True(
            index( $Selenium->get_page_source(), $ExpectedAgent ) > -1,
            "$TestUserLogin - found on UserOnline plugin"
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('table.DashboardUserOnline span.UserStatusIcon.Inline.Active:visible').length"
            ),
            "$TestUserLogin - found active status icon",
        ) || die;

        # Verify only one customer user is accounted for.
        my $CustomersLink = $Selenium->find_element("//a[contains(\@id, \'UserOnlineCustomer' )]");
        $Self->Is(
            $CustomersLink->get_text() // '',
            'Customers (1)',
            'Only one customer user accounted for'
        );

        # Switch to online customers and test UserOnline plugin for customers.
        $CustomersLink->click();

        # Wait for AJAX.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('table.DashboardUserOnline a:contains(\"$TestCustomerUserLogin\")').length;"
        );

        $Self->True(
            $Selenium->execute_script(
                "return \$('table.DashboardUserOnline span.UserStatusIcon.Inline.Active:visible').length"
            ),
            "$TestCustomerUserLogin - found active status icon",
        ) || die;

        $Self->Is(
            $Selenium->execute_script(
                "return \$('table.DashboardUserOnline a:contains(\"$TestCustomerUserLogin\")').length;"
            ),
            1,
            "$TestCustomerUserLogin - found on UserOnline plugin"
        ) || die;
    }
);

1;
