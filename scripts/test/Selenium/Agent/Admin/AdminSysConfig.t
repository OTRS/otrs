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

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AdminSysConfig screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSysConfig");

        # Check for AdminSysConfig groups.
        for my $SysGroupValues (qw(DynamicFields Framework GenericInterface ProcessManagement Daemon Ticket)) {
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#SysConfigGroup option[value=$SysGroupValues]').length;"
            );
            $Selenium->find_element( "#SysConfigGroup option[value='$SysGroupValues']", 'css' );
        }

        # Select Ticket sysconfig group.
        $Selenium->execute_script(
            "\$('#SysConfigGroup').val('Ticket').trigger('redraw.InputField').trigger('change');"
        );

        # Wait for reload to kick in.
        sleep 1;
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete;'
        );

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".DataTable").length && $("#SysConfigGroup").length;'
        );

        # Remove selected Ticket sysconfig group.
        $Selenium->execute_script(
            "\$('#SysConfigGroup').val('').trigger('redraw.InputField').trigger('change');"
        );

        # Wait for reload to kick in.
        sleep 1;
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete;'
        );

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".DataTable tbody td").text().trim().includes("No data found.");'
        );

        # Verify no result are found on after removing sysconfig group.
        $Self->Is(
            $Selenium->execute_script("return \$('.DataTable tbody td').text().trim();"),
            'No data found.',
            "No result message is found"
        );

        # Check for the import button.
        my $Setting = $ConfigObject->Get(
            Name => 'ConfigImportAllowed',
        );

        if ( defined $Setting && $Setting ) {
            $Selenium->find_element("//a[contains(\@href, \'Subaction=Import')]");
        }

        # Test search AdminSysConfig and check for some of the results
        #   e.g Core::PerformanceLog and Core::Ticket.
        $Selenium->find_element( "#SysConfigSearch", 'css' )->send_keys("admin");

        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        for my $SysConfSearch (qw(PerformanceLog Ticket)) {
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('a[href*=\"SysConfigSubGroup=Core%3A%3A$SysConfSearch\"]:visible').length;"
            );

            $Self->True(
                $Selenium->find_element("//a[contains(\@href, \'SysConfigSubGroup=Core%3A%3A$SysConfSearch')]")
                    ->is_displayed(),
                "Core::$SysConfSearch found on screen",
            );
        }

        my $CustomQueue                  = $ConfigObject->Get('Ticket::CustomQueue');
        my $CustomService                = $ConfigObject->Get('Ticket::CustomService');
        my $NewArticleIgnoreSystemSender = $ConfigObject->Get('Ticket::NewArticleIgnoreSystemSender');

        $Selenium->execute_script(
            "\$('a[href*=\"SysConfigSubGroup=Core%3A%3ATicket\"]')[0].scrollIntoView(true);",
        );

        # Check for some of Core::Ticket default values.
        $Selenium->find_element("//a[contains(\@href, \'SysConfigSubGroup=Core%3A%3ATicket')]")->VerifiedClick();

        $Self->Is(
            $Selenium->find_element("//input[\@name='Ticket::CustomQueue']")->get_value(),
            $CustomQueue,
            "CustomQueue default value",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@name='Ticket::CustomService']")->get_value(),
            $CustomService,
            "CustomerService default value",
        );
        $Self->Is(
            $Selenium->find_element("//select[\@name='Ticket::NewArticleIgnoreSystemSender']")->get_value(),
            $NewArticleIgnoreSystemSender,
            "NewArticleIgnoreSystemSender default value is no",
        );

        # Edit those values.
        $Selenium->find_element("//input[\@name='Ticket::CustomQueue']")->clear();
        $Selenium->find_element("//input[\@name='Ticket::CustomQueue']")->send_keys("My Queuesedit");
        $Selenium->find_element("//input[\@name='Ticket::CustomService']")->clear();
        $Selenium->find_element("//input[\@name='Ticket::CustomService']")->send_keys("My Servicesedit");
        $Selenium->execute_script(
            "\$('select[name=\"Ticket\\:\\:NewArticleIgnoreSystemSender\"]').val('1').trigger('redraw.InputField').trigger('change');"
        );

        $Selenium->execute_script(
            "\$('button[value=Update]')[0].scrollIntoView(true);",
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('button[value=Update]').length;"
            ),
            "Update button is found",
        );
        $Selenium->find_element("//button[\@value='Update']")->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('input[name=\"Ticket\\:\\:CustomQueue\"]').val() == 'My Queuesedit' && \$('input[name=\"Ticket\\:\\:CustomService\"]').val() == 'My Servicesedit';"
        );

        # Check for edited values.
        $Self->Is(
            $Selenium->find_element("//input[\@name='Ticket::CustomQueue']")->get_value(),
            "My Queuesedit",
            "CustomQueue updated value",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@name='Ticket::CustomService']")->get_value(),
            "My Servicesedit",
            "CustomerService updated value",
        );
        $Self->Is(
            $Selenium->find_element("//select[\@name='Ticket::NewArticleIgnoreSystemSender']")->get_value(),
            1,
            "NewArticleIgnoreSystemSender updated value is Yes",
        );

        # Restore edited values back to default.
        for my $ResetDefault (qw(CustomQueue CustomService NewArticleIgnoreSystemSender)) {

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('button[name=\"ResetTicket\\:\\:$ResetDefault\"]').length;"
            );
            $Selenium->execute_script(
                "\$('button[name=\"ResetTicket\\:\\:$ResetDefault\"]')[0].scrollIntoView(true);",
            );
            $Self->True(
                $Selenium->execute_script(
                    "return \$('button[name=\"ResetTicket\\:\\:$ResetDefault\"]').length;"
                ),
                "'$ResetDefault' restore button is found",
            );

            $Selenium->find_element("//button[\@name='ResetTicket::$ResetDefault']")->VerifiedClick();

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && !\$('button[name=\"ResetTicket\\:\\:$ResetDefault\"]').length;"
            );

            $Self->True(
                $Selenium->execute_script(
                    "return !\$('button[name=\"ResetTicket\\:\\:$ResetDefault\"]').length;"
                ),
                "'$ResetDefault' restore button is not found",
            );
        }
    }
);

1;
