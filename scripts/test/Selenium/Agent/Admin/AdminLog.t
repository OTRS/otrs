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

        # get log object
        my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # set log module in sysconfig
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'LogModule',
            Value => 'Kernel::System::Log::SysLog',
        );

        # clear log
        $LogObject->CleanUp();

        # destroy and instantiate log object
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Log'] );
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::Log' => {
                LogPrefix => 'TestAdminLog',
            },
        );
        $LogObject = $Kernel::OM->Get('Kernel::System::Log');

        my @LogMessages;

        # create log entries
        for ( 0 .. 1 ) {
            my $LogMessage = 'LogMessage' . $Helper->GetRandomNumber();

            $LogObject->Log(
                Priority => 'error',
                Message  => $LogMessage,
            );

            push @LogMessages, $LogMessage;
        }

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminLog screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminLog");

        # filter with the first log entry
        $Selenium->find_element( "#FilterLogEntries", 'css' )->clear();
        $Selenium->find_element( "#FilterLogEntries", 'css' )->send_keys( $LogMessages[0], "\N{U+E007}" );
        sleep 1;

        # check if the first log entry is shown in the table
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#LogEntries tr td:contains($LogMessages[0])').parent().css('display')"
            ),
            'table-row',
            "First log entry exists in the table",
        );

        # check if the second log entry is not shown in the table
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#LogEntries tr td:contains($LogMessages[1])').parent().css('display')"
            ),
            'none',
            "Second log entry does not exist in the table",
        );

        # click on 'Hide this message'
        $Selenium->find_element( "#HideHint", 'css' )->VerifiedClick();
        sleep 1;

        # check if sidebar column is shown
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.SidebarColumn').css('display')"
            ),
            'none',
            "Sidebar column is not visible on the screen",
        );

        # clear log
        $LogObject->CleanUp();

        # make sure cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
    }
);

1;
