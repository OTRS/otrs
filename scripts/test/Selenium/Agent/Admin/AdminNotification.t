# --
# AdminNotification.t - frontend tests for AdminNotification
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

use Kernel::System::UnitTest::Helper;
use Kernel::System::UnitTest::Selenium;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose => 1,
);

$Selenium->RunTest(
    sub {

        my $Helper = Kernel::System::UnitTest::Helper->new(
            RestoreSystemConfiguration => 0,
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AdminNotification");

        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # select English language
        $Selenium->find_element("//option[\@value='en']")->click();

        # test filter for Notification
        $Selenium->find_element( "#FilterNotification", 'css' )->send_keys("Agent::AddNote");
        sleep 1;

        $Self->True(
            $Selenium->find_element( "Agent::AddNote", 'link_text' )->is_displayed(),
            "Agent::AddNote found on page",
        );

        my $Success;
        eval {
            $Success = $Selenium->find_element( "Agent::Escalation ", 'link_text' )->is_displayed(),
        };

        $Self->False(
            $Success,
            "Agent::Escalation is not found on page",
        );

        # clear test filter for Notification
        $Selenium->find_element( "#FilterNotification", 'css' )->clear();
        sleep 1;

        # check defoult notification
        for my $Notification (
            qw(AddNote Escalation EscalationNotifyBefore FollowUp Move LockTimeout NewTicket OwnerUpdate PendingReminder ResponsibleUpdate)
            )
        {

            $Selenium->find_element( "Agent::$Notification", 'link_text' )->click();

            # edit notification
            my $CurrentNotificationSubject = $Selenium->find_element( "#Subject", 'css' )->get_value();
            $Selenium->find_element( "#Subject", 'css' )->clear();
            $Selenium->find_element( "#Subject", 'css' )->send_keys("$CurrentNotificationSubject - test notification");
            $Selenium->find_element( "#Subject", 'css' )->submit();

            # check edited notification
            $Selenium->find_element( "Agent::$Notification", 'link_text' )->click();

            $Self->Is(
                $Selenium->find_element( '#Subject', 'css' )->get_value(),
                "$CurrentNotificationSubject - test notification",
                "#Subject stored value",
            );

            # restore previous value for Subject of notification
            $Selenium->find_element( "#Subject", 'css' )->clear();
            $Selenium->find_element( "#Subject", 'css' )->send_keys("$CurrentNotificationSubject");
            $Selenium->find_element( "#Subject", 'css' )->submit();

        }

    }
);

1;
