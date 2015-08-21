# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminSysConfig");

        # check for AdminSysConfig groups
        for my $SysGroupValues (
            qw (DynamicFields Framework GenericInterface ProcessManagement Daemon Ticket)
            )
        {
            $Selenium->find_element( "#SysConfigGroup option[value='$SysGroupValues']", 'css' );

        }

        # check for export and import buttons
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Download')]");
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Import')]");

        # test search AdminSysConfig and check for some of the results
        # e.g Core::PerformanceLog and Core::Ticket
        $Selenium->find_element( "#SysConfigSearch", 'css' )->send_keys("admin");
        $Selenium->find_element( "#SysConfigSearch", 'css' )->submit();

        for my $SysConfSearch (
            qw (PerformanceLog Ticket)
            )
        {
            $Self->True(
                $Selenium->find_element("//a[contains(\@href, \'SysConfigSubGroup=Core%3A%3A$SysConfSearch')]")
                    ->is_displayed(),
                "Core::$SysConfSearch found on screen",
            );
        }

        # check for some of Core::Ticket default values
        $Selenium->find_element("//a[contains(\@href, \'SysConfigSubGroup=Core%3A%3ATicket')]")->click();
        $Self->Is(
            $Selenium->find_element("//input[\@name='Ticket::CustomQueue']")->get_value(),
            "My Queues",
            "CustomQueue default value",
        );
        $Self->Is(
            $Selenium->find_element("//input[\@name='Ticket::CustomService']")->get_value(),
            "My Services",
            "CustomerService default value",
        );
        $Self->Is(
            $Selenium->find_element("//select[\@name='Ticket::NewArticleIgnoreSystemSender']")->get_value(),
            0,
            "NewArticleIgnoreSystemSender default value is no",
        );

        # edit those values
        $Selenium->find_element("//input[\@name='Ticket::CustomQueue']")->send_keys("edit");
        $Selenium->find_element("//input[\@name='Ticket::CustomService']")->send_keys("edit");
        $Selenium->execute_script("\$('select[name=\"Ticket\\:\\:NewArticleIgnoreSystemSender\"]').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element("//input[\@name='Ticket::CustomQueue']")->submit();

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
        for my $ResetDefault (
            qw (CustomQueue CustomService NewArticleIgnoreSystemSender)
            )
        {
            $Selenium->find_element("//button[\@value='Reset this setting'][\@name='ResetTicket::$ResetDefault']")
                ->click();
        }

    }

);

1;
