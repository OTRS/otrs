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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        my $TicketHookValue = 'abc';

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Hook',
            Value => $TicketHookValue,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketQueue###QueueSort',
            Value => {
                '7' => 2,
                '3' => 1,
            },
        );

        # Rebuild system configuration.
        my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Config::Rebuild');
        my $ExitCode      = $CommandObject->Execute('--cleanup');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminSysConfig screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemConfiguration;");

        # Wait until page is loaded with jstree content in sidebar.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#SysConfigSearch").length && $("#ConfigTree > ul:visible").length',
        );

        $Selenium->find_element( "#SysConfigSearch", "css" )->clear();
        $Selenium->find_element( "#SysConfigSearch", "css" )->send_keys('Ticket::Hook');
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && !$("#AJAXLoaderSysConfigSearch:visible").length'
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->find_element( "button[type='submit']", "css" )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".fa-exclamation-triangle").length',
        );

        my $Message = $Selenium->execute_script("return \$('.fa-exclamation-triangle').attr('title');");
        $Self->True(
            $Message
                =~ m{^This setting is currently being overridden in Kernel\/Config\/Files\/ZZZZUnitTest\d+.pm and can't thus be changed here!$}
            ? 1
            : 0,
            "Check if setting overridden message is present."
        );

        # Check if overridden Effective value is displayed.
        my $Value = $Selenium->find_element( "#Ticket\\:\\:Hook", "css" )->get_value();
        $Self->Is(
            $Value // '',
            $TicketHookValue,
            'Ticket::Hook value is rendered ok.',
        );

        # Navigate to AdminSysConfig screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfigurationGroup;RootNavigation=Frontend::Agent::View::TicketQueue"
        );

        # Wait until page is loaded with jstree content in sidebar.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".fa-exclamation-triangle").length && $("#ConfigTree > ul:visible").length',
        );

        $Message = $Selenium->find_element( ".fa-exclamation-triangle", "css" )->get_attribute('title');
        $Self->True(
            $Message
                =~ m{^This setting is currently being overridden in Kernel\/Config\/Files\/ZZZZUnitTest\d+.pm and can't thus be changed here!$}
            ? 1
            : 0,
            "Check if setting overridden message is present (when navigation is used)."
        );

        # Check if overridden Effective value is displayed.
        my $HashValue1 = $Selenium->find_element(
            "#Ticket\\:\\:Frontend\\:\\:AgentTicketQueue\\#\\#\\#QueueSort_Hash\\#\\#\\#3",
            "css"
        )->get_value();
        $Self->Is(
            $HashValue1 // '',
            '1',
            'Check first hash item value',
        );

        my $HashValue2 = $Selenium->find_element(
            "#Ticket\\:\\:Frontend\\:\\:AgentTicketQueue\\#\\#\\#QueueSort_Hash\\#\\#\\#7",
            "css"
        )->get_value();
        $Self->Is(
            $HashValue2 // '',
            '2',
            'Check second hash item value',
        );

        # Navigate to AdminSysConfig screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=View;Setting=Frontend%3A%3ACSSPath"
        );

        # Check if setting is overridden
        my $CSSPathOverridden = $Selenium->execute_script(
            'return $(".SettingsList .WidgetSimple i.fa-exclamation-triangle").length;'
        );
        $Self->False(
            $CSSPathOverridden,
            'Make sure that Frontend::CSSPath is not overridden.'
        );

        if ( $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSBusinessIsInstalled() ) {

            # Navigate to AgentPreferences screen.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=Advanced");

            # Wait until page is loaded with jstree content in sidebar.
            $Selenium->WaitFor(
                JavaScript => 'return typeof($) === "function" && $("#ConfigTree > ul:visible").length',
            );

            # Expand navigation.
            $Selenium->WaitFor(
                JavaScript => 'return $("#ConfigTree li#Frontend > i").length;',
            );
            $Selenium->execute_script("\$('#ConfigTree li#Frontend > i').trigger('click')");

            $Selenium->WaitFor(
                JavaScript =>
                    'return $("#ConfigTree li#Frontend\\\\:\\\\:Agent > i").length;',
            );
            $Selenium->execute_script("\$('#ConfigTree li#Frontend\\\\:\\\\:Agent > i').trigger('click')");

            $Selenium->WaitFor(
                JavaScript =>
                    'return $("#ConfigTree li#Frontend\\\\:\\\\:Agent\\\\:\\\\:View > i").length;',
            );
            $Selenium->execute_script(
                "\$('#ConfigTree li#Frontend\\\\:\\\\:Agent\\\\:\\\\:View > i').trigger('click')"
            );

            $Selenium->WaitFor(
                JavaScript =>
                    'return $("a#Frontend\\\\:\\\\:Agent\\\\:\\\\:View\\\\:\\\\:TicketEscalation_anchor").length;',
            );
            $Selenium->execute_script(
                "\$('a#Frontend\\\\:\\\\:Agent\\\\:\\\\:View\\\\:\\\\:TicketEscalation_anchor').trigger('click')"
            );

            # Wait for AJAX.
            $Selenium->WaitFor(
                JavaScript =>
                    'return !$(".AJAXLoader:visible").length && $("#Ticket\\\\:\\\\:Frontend\\\\:\\\\:AgentTicketEscalationView\\\\#\\\\#\\\\#Order\\\\:\\\\:Default").length',
            );

            # Update setting and save.
            $Selenium->InputFieldValueSet(
                Element =>
                    '#Ticket\\\\:\\\\:Frontend\\\\:\\\\:AgentTicketEscalationView\\\\#\\\\#\\\\#Order\\\\:\\\\:Default',
                Value => 'Down',
            );

            $Selenium->execute_script("\$('.SettingsList li:nth-child(1) .SettingUpdateBox .Update').trigger('click')");

            # Wait for AJAX.
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $(".SettingsList li:nth-child(1) .SettingUpdateBox .Update").length',
            );

            # Search for setting in the System Configuration.
            $Selenium->VerifiedGet(
                "${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=Search;;Category=All;Search=Ticket::Frontend::AgentTicketEscalationView%23%23%23Order::Default"
            );

            my $ModificationAllowed = $Selenium->execute_script(
                'return typeof($) === "function" && !$(".fa-exclamation-triangle").length',
            );

            $Self->True(
                $ModificationAllowed,
                'Make sure modification is still possible.'
            );

            # Search for overridden setting in the System Configuration.
            $Selenium->VerifiedGet(
                "${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=Search;;Category=All;Search=Ticket::Frontend::AgentTicketQueue%23%23%23QueueSort"
            );

            my $ModificationNotAllowed = $Selenium->execute_script(
                'return typeof($) === "function" && $(".fa-exclamation-triangle").length === 1',
            );

            $Self->True(
                $ModificationNotAllowed,
                'Make sure modification is not possible.'
            );
        }
    }
);

1;
