# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Hook',
            Value => 'abc',
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketQueue###QueueSort',
            Value => {
                '7' => 2,
                '3' => 1,
            },
        );

        my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

        # Rebuild system configuration.
        my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Config::Rebuild');
        my $ExitCode      = $CommandObject->Execute('--cleanup');

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
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemConfiguration;");

        $Selenium->WaitFor(
            JavaScript => 'return $("#SysConfigSearch").length',
        );
        $Selenium->find_element( "#SysConfigSearch",      "css" )->send_keys("Ticket::Hook");
        $Selenium->find_element( "button[type='submit']", "css" )->VerifiedClick();

        my $Message = $Selenium->find_element( ".fa-exclamation-triangle", "css" )->get_attribute('title');
        $Self->True(
            $Message =~ m{^This setting is currently being overridden in Kernel\/Config\/Files\/ZZZZUnitTest\d+.pm and can't thus be changed here!$} ? 1 : 0,
            "Check if setting overrided message is present."
        );

        # Check if overrided Effective value is displayed
        my $Value = $Selenium->find_element( "#Ticket\\:\\:Hook", "css" )->get_value();
        $Self->Is(
            $Value // '',
            'abc',
            'Ticket::Hook value is rendered ok.',
        );

        # navigate to AdminSysConfig screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemConfiguration;");

        # Use navigation to get to the Frontend::Agent::View::TicketQueue.
        $Selenium->WaitFor(
            JavaScript => 'return $("li#Frontend > i").length',
        );
        $Selenium->find_element( "li#Frontend > i", "css" )->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript => 'return $("li#Frontend\\\\:\\\\:Agent > i").length',
        );
        $Selenium->find_element( "li#Frontend\\:\\:Agent > i", "css" )->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript => 'return $("li#Frontend\\\\:\\\\:Agent\\\\:\\\\:View > i").length',
        );
        $Selenium->find_element( "li#Frontend\\:\\:Agent\\:\\:View > i", "css" )->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript => 'return $("a#Frontend\\\\:\\\\:Agent\\\\:\\\\:View\\\\:\\\\:TicketQueue_anchor").length',
        );

        $Selenium->execute_script(
            "\$('a#Frontend\\\\:\\\\:Agent\\\\:\\\\:View\\\\:\\\\:TicketQueue_anchor')[0].scrollIntoView(true);",
        );
        $Selenium->find_element( "a#Frontend\\:\\:Agent\\:\\:View\\:\\:TicketQueue_anchor", "css" )->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript => 'return $(".fa-exclamation-triangle").length',
        );

        my $Message2 = $Selenium->find_element( ".fa-exclamation-triangle", "css" )->get_attribute('title');
        $Self->True(
            $Message2 =~ m{^This setting is currently being overridden in Kernel\/Config\/Files\/ZZZZUnitTest\d+.pm and can't thus be changed here!$} ? 1 : 0,
            "Check if setting overrided message is present (when navigation is used)."
        );

        # Check if overrided Effective value is displayed
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
    }
);

1;
