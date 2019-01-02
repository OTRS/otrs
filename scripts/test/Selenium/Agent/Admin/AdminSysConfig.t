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

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminSysConfig screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSysConfig");

        # check for AdminSysConfig groups
        for my $SysGroupValues (qw(DynamicFields Framework GenericInterface ProcessManagement Daemon Ticket)) {
            $Selenium->find_element( "#SysConfigGroup option[value='$SysGroupValues']", 'css' );

        }

        # select Ticket sysconfig group
        $Selenium->execute_script(
            "\$('#SysConfigGroup').val('Ticket').trigger('redraw.InputField').trigger('change');"
        );

        sleep 1;

        # Wait for reload to kick in
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Remove").length' );

        # remove selected Ticket sysconfig group
        sleep 2;
        $Selenium->execute_script(
            "\$('#SysConfigGroup').val('').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".DataTable tbody td").text().trim().includes("No data found.");'
        );

        # verify no result are found on after removing sysconfig group
        $Self->Is(
            $Selenium->execute_script("return \$('.DataTable tbody td').text().trim();"),
            'No data found.',
            "No result message is found"
        );

        # check for the import button
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Import')]");

        # test search AdminSysConfig and check for some of the results
        # e.g Core::PerformanceLog and Core::Ticket
        $Selenium->find_element( "#SysConfigSearch", 'css' )->send_keys("admin");
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        for my $SysConfSearch (qw(PerformanceLog Ticket)) {
            $Self->True(
                $Selenium->find_element("//a[contains(\@href, \'SysConfigSubGroup=Core%3A%3A$SysConfSearch')]")
                    ->is_displayed(),
                "Core::$SysConfSearch found on screen",
            );
        }

        my $CustomQueue   = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::CustomQueue');
        my $CustomService = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::CustomService');
        my $NewArticleIgnoreSystemSender
            = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::NewArticleIgnoreSystemSender');

        # check for some of Core::Ticket default values
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

        # edit those values
        $Selenium->find_element("//input[\@name='Ticket::CustomQueue']")->clear();
        $Selenium->find_element("//input[\@name='Ticket::CustomQueue']")->send_keys("My Queuesedit");
        $Selenium->find_element("//input[\@name='Ticket::CustomService']")->clear();
        $Selenium->find_element("//input[\@name='Ticket::CustomService']")->send_keys("My Servicesedit");
        $Selenium->execute_script(
            "\$('select[name=\"Ticket\\:\\:NewArticleIgnoreSystemSender\"]').val('1').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->execute_script("\$('button[value=Update').click();");

        # check for edited values
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

        # restore edited values back to default
        for my $ResetDefault (qw(CustomQueue CustomService NewArticleIgnoreSystemSender)) {
            $Selenium->execute_script("\$('button[name=$ResetDefault]').click();");
            sleep 1;
        }
    }
);

1;
