# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
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

        # get needed objects
        my $Helper      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

        my $RandomID = $Helper->GetRandomID();

        # create test group
        my $GroupName = "test-calendar-group-$RandomID";
        my $GroupID   = $GroupObject->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $GroupID,
            'Test group created',
        );

        # create test queue
        my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => "Queue$RandomID",
            ValidID         => 1,
            GroupID         => $GroupID,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Some comment',
            UserID          => 1,
        );
        $Self->True(
            $QueueID,
            'Test queue created',
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # change resolution (desktop mode)
        $Selenium->set_window_size( 768, 1050 );

        # create test user
        my $Language      = 'en';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [$GroupName],
            Language => $Language,
        ) || die 'Did not get test user';

        # start test
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # open AgentAppointmentCalendarManage page
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentCalendarManage");

        # click Add new calendar
        $Selenium->find_element( '.SidebarColumn ul.ActionList a#Add', 'css' )->VerifiedClick();

        # write calendar name
        $Selenium->find_element( 'form#CalendarFrom input#CalendarName', 'css' )->send_keys("Calendar $RandomID");

        # set it to test group
        $Selenium->execute_script(
            "return \$('#GroupID').val($GroupID).trigger('redraw.InputField').trigger('change');"
        );

        # submit
        $Selenium->find_element( 'form#CalendarFrom button#Submit', 'css' )->VerifiedClick();

        # Verify download and copy-to-clipboard links.
        for my $Class (qw(DownloadLink CopyToClipboard)) {
            my $Element = $Selenium->find_element( ".$Class", 'css' );

            my $URL;
            if ( $Class eq 'DownloadLink' ) {
                $URL = $Element->get_attribute('href');
            }
            elsif ( $Class eq 'CopyToClipboard' ) {
                $URL = $Element->get_attribute('data-clipboard-text');
            }

            $Self->True(
                $URL,
                "$Class URL present"
            );

            # URL should not contain OTRS specific URL delimiter of semicolon (;).
            #   For better compatibility, use standard ampersand (&) instead.
            #   Please see bug#12667 for more information.
            $Self->False(
                ( $URL =~ /[;]/ ) ? 1 : 0,
                "$Class URL does not contain forbidden characters"
            );
        }

        #
        # let's try to add calendar with same name
        #
        # click Add new calendar
        $Selenium->find_element( '.SidebarColumn ul.ActionList a#Add', 'css' )->VerifiedClick();

        # write calendar name
        $Selenium->find_element( 'form#CalendarFrom input#CalendarName', 'css' )->send_keys("Calendar $RandomID");

        # set it to test group
        $Selenium->execute_script(
            "return \$('#GroupID').val($GroupID).trigger('redraw.InputField').trigger('change');"
        );

        # submit
        $Selenium->find_element( 'form#CalendarFrom button#Submit', 'css' )->VerifiedClick();

        # wait for server side error
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('div.Dialog button#DialogButton1').length"
        );

        # click ok to dismiss
        $Selenium->find_element( 'div.Dialog button#DialogButton1', 'css' )->VerifiedClick();

        # wait for tooltip message
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('div#OTRS_UI_Tooltips_ErrorTooltip').length"
        );

        # update calendar name
        $Selenium->find_element( 'form#CalendarFrom input#CalendarName', 'css' )->clear();
        $Selenium->find_element( 'form#CalendarFrom input#CalendarName', 'css' )->send_keys("Calendar $RandomID 2");

        # set it to invalid
        $Selenium->execute_script(
            "return \$('#ValidID').val(2).trigger('redraw.InputField').trigger('change');"
        );

        # add ticket appointment rule
        $Selenium->find_element( '.WidgetSimple.Collapsed .WidgetAction.Toggle a', 'css' )->VerifiedClick();
        $Selenium->find_element( '#AddRuleButton',                                 'css' )->VerifiedClick();

        # set a queue
        $Selenium->execute_script(
            "return \$('#QueueID_1').val('$QueueID').trigger('redraw.InputField').trigger('change');"
        );

        # Add title as search parameter.
        $Selenium->execute_script(
            "return \$('#SearchParams').val('Title').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( '.AddButton',           'css' )->VerifiedClick();
        $Selenium->find_element( '#SearchParam_1_Title', 'css' )->send_keys('Test*');

        # submit
        $Selenium->find_element( 'form#CalendarFrom button#Submit', 'css' )->VerifiedClick();

        # verify two calendars are shown
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.ContentColumn table tbody tr:visible').length;"
            ),
            2,
            'All calendars are displayed',
        );

        # filter just added calendar
        $Selenium->find_element( 'input#FilterCalendars', 'css' )->send_keys("Calendar $RandomID 2");

        sleep 1;

        # verify only one calendar is shown
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.ContentColumn table tbody tr:visible').length;"
            ),
            1,
            'Calendars are filtered correctly',
        );

        # verify the calendar is invalid
        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );
        $Self->Is(
            $Selenium->find_element( '.ContentColumn table tbody tr:nth-of-type(2) td:nth-of-type(4)', 'css' )
                ->get_text(),
            $LanguageObject->Translate('invalid'),
            'Calendar is marked invalid',
        );

        # edit invalid calendar
        $Selenium->find_element( '.ContentColumn table tbody tr:nth-of-type(2) td a', 'css' )->VerifiedClick();

        # set it to invalid-temporarily
        $Selenium->execute_script(
            "return \$('#ValidID').val(3).trigger('redraw.InputField').trigger('change');"
        );

        # verify rule has been stored properly
        $Self->IsDeeply(
            $Selenium->execute_script(
                "return \$('select[id*=\"QueueID_\"]').val();"
            ),
            [$QueueID],
            'Queue stored properly',
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('input[id*=\"_Title\"]').val();"
            ),
            'Test*',
            'Search param stored properly',
        );

        # remove the rule
        $Selenium->find_element( '.RemoveButton', 'css' )->VerifiedClick();

        # submit
        $Selenium->find_element( 'form#CalendarFrom button#Submit', 'css' )->VerifiedClick();

        # verify the calendar is invalid temporarily
        $Self->Is(
            $Selenium->find_element( '.ContentColumn table tbody tr:nth-of-type(2) td:nth-of-type(4)', 'css' )
                ->get_text(),
            $LanguageObject->Translate('invalid-temporarily'),
            'Calendar is marked invalid temporarily',
        );

        # cleanup

        my $DBObject          = $Kernel::OM->Get('Kernel::System::DB');
        my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

        # delete test calendars
        my $Success = $DBObject->Do(
            SQL  => 'DELETE FROM calendar WHERE name = ? OR name = ?',
            Bind => [ \"Calendar $RandomID", \"Calendar $RandomID 2", ],
        );
        $Self->True(
            $Success,
            "Deleted test calendars - Calendar $RandomID (2)",
        );

        # delete test queue
        $Success = $DBObject->Do(
            SQL  => 'DELETE FROM queue WHERE id = ?',
            Bind => [ \$QueueID, ],
        );
        $Self->True(
            $Success,
            "Deleted test queue - $QueueID",
        );

        # Remove scheduled asynchronous tasks from DB, as they may interfere with tests run later.
        my @TaskIDs;
        my @AllTasks = $SchedulerDBObject->TaskList(
            Type => 'AsynchronousExecutor',
        );
        for my $Task (@AllTasks) {
            if ( $Task->{Name} eq 'Kernel::System::Calendar-TicketAppointmentProcessCalendar()' ) {
                push @TaskIDs, $Task->{TaskID};
            }
        }
        for my $TaskID (@TaskIDs) {
            my $Success = $SchedulerDBObject->TaskDelete(
                TaskID => $TaskID,
            );
            $Self->True(
                $Success,
                "TaskDelete - Removed scheduled asynchronous task $TaskID",
            );
        }

        # make sure cache is correct
        for my $Cache (qw(Calendar Queue)) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => $Cache );
        }
    },
);

1;
