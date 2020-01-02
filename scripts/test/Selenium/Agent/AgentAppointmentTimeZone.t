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

        my $Helper            = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $GroupObject       = $Kernel::OM->Get('Kernel::System::Group');
        my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');
        my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
        my $UserObject        = $Kernel::OM->Get('Kernel::System::User');

        # Make sure system is based on UTC.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'OTRSTimeZone',
            Value => 'UTC',
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'UserDefaultTimeZone',
            Value => 'UTC',
        );

        my $RandomID = $Helper->GetRandomID();

        # Create test group.
        my $GroupName = "test-calendar-group-$RandomID";
        my $GroupID   = $GroupObject->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Change resolution (desktop mode).
        $Selenium->set_window_size( 768, 1050 );

        # Create test user.
        my $Language      = 'en';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'users', $GroupName ],
            Language => $Language,
        ) || die 'Did not get test user';

        # Get UserID for later manipulation of preferences.
        my $UserID = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Create a test calendar.
        my %Calendar = $CalendarObject->CalendarCreate(
            CalendarName => "Calendar-$RandomID",
            Color        => '#3A87AD',
            GroupID      => $GroupID,
            UserID       => $UserID,
            ValidID      => 1,
        );

        # Go to calendar overview page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentCalendarOverview");

        # Wait for AJAX to finish.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".fc-timelineWeek-view .fc-slats td.fc-widget-content:nth-child(5)").length;'
        );

        # Hide indicator line if visible. This was causing issue in some of tests in specific execution time.
        if ( $Selenium->execute_script("return \$('.fc-now-indicator.fc-now-indicator-line:visible').length;") ) {
            $Selenium->execute_script("\$('.fc-now-indicator.fc-now-indicator-line').hide();");
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" &&  $(".fc-now-indicator.fc-now-indicator-line:visible").length === 0;'
            );
        }

        # Click on the timeline view for an appointment dialog.
        $Selenium->find_element( '.fc-timelineWeek-view .fc-slats td.fc-widget-content:nth-child(5)', 'css' )->click();

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );

        # Enter some data, and put end hour to 18h for nice long appointment.
        $Selenium->find_element( 'Title', 'name' )->send_keys('Time Zone Appointment');
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendar{CalendarID},
        );
        $Selenium->find_element( 'EndHour', 'name' )->send_keys('18');

        # Create fake date time object for easier time zone conversion later.
        #   Use exact date and time from created appointment in order for conversion to be correct.
        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        $DateTimeObject->Set(
            Year    => $Selenium->find_element( 'StartYear',   'name' )->get_value(),
            Month   => $Selenium->find_element( 'StartMonth',  'name' )->get_value(),
            Day     => $Selenium->find_element( 'StartDay',    'name' )->get_value(),
            Hour    => $Selenium->find_element( 'StartHour',   'name' )->get_value(),
            Minute  => $Selenium->find_element( 'StartMinute', 'name' )->get_value(),
            Seconds => 0,
        );

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();

        # Wait for dialog to close and AJAX to finish.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
        );

        # Verify appointment is visible.
        $Self->Is(
            $Selenium->execute_script(
                "return \$('.fc-timeline-event .fc-title').text();"
            ),
            'Time Zone Appointment',
            'Appointment visible (Calendar Overview)'
        );

        # Go to agenda overview page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentAgendaOverview;Filter=Week");

        sleep 1;

        # Verify appointment is visible.
        $Self->True(
            index( $Selenium->get_page_source(), 'Time Zone Appointment' ) > -1,
            'Appointment visible (Agenda Overview)'
        );

        # Get appointment ID.
        my $AppointmentID = $Selenium->execute_script(
            "return \$('.MasterActionLink').data('appointmentId');"
        );

        # Get displayed start date.
        my $StartDate
            = $Selenium->find_element( "//*[\@id='AppointmentID_$AppointmentID']/td[4]", 'xpath' )->get_text();

        # Check start time.
        $StartDate =~ /(\d{2}:\d{2}:\d{2})$/;
        my $StartTime = $1;
        $Self->Is(
            $StartTime,
            sprintf(
                "%02d:%02d:00",
                $DateTimeObject->Get()->{Hour},
                $DateTimeObject->Get()->{Minute}
            ),
            'Start time in local time'
        );

        # Set user's time zone.
        my $UserTimeZone = 'Europe/Berlin';
        $UserObject->SetPreferences(
            Key    => 'UserTimeZone',
            Value  => $UserTimeZone,
            UserID => $UserID,
        );

        # Make sure cache is correct.
        for my $Cache (qw(Calendar Appointment)) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => $Cache );
        }

        # Log in again.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Go to agenda overview page again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentAgendaOverview;Filter=Week");

        sleep 1;

        # Get displayed start date.
        my $StartDateTZ
            = $Selenium->find_element( "//*[\@id='AppointmentID_$AppointmentID']/td[4]", 'xpath' )->get_text();

        # Convert date time object to user time zone.
        $DateTimeObject->ToTimeZone(
            TimeZone => $UserTimeZone,
        );

        # Check start time again.
        $StartDateTZ =~ /(\d{2}:\d{2}:\d{2}\s\(.*?\))$/;
        my $StartTimeTZ = $1;
        $Self->Is(
            $StartTimeTZ,
            sprintf(
                "%02d:%02d:00 (%s)",
                $DateTimeObject->Get()->{Hour},
                $DateTimeObject->Get()->{Minute},
                $UserTimeZone
            ),
            "Start time in user's time zone"
        );

        # Go to calendar overview page again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentCalendarOverview");

        # Wait for AJAX to finish.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length' );
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        $Selenium->execute_script(
            "\$('.fc-timeline-event')[0].scrollIntoView(true);",
        );

        # Click on an appointment.
        $Selenium->execute_script("\$('.fc-timeline-event').click();");

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.Dialog').length && \$('#StartHour').length"
        );

        # Check start hour.
        my $StartHourTZ = $Selenium->find_element( 'StartHour', 'name' )->get_value();
        $Self->Is(
            $StartHourTZ,
            $DateTimeObject->Get()->{Hour},
            "Start hour in user's time zone",
        );

        # Cleanup

        # Delete test appointment.
        my $Success = $AppointmentObject->AppointmentDelete(
            AppointmentID => $AppointmentID,
            UserID        => $UserID,
        );
        $Self->True(
            $Success,
            "Deleted test appointment - $AppointmentID",
        );

        # Delete test calendar.
        if ( $Calendar{CalendarID} ) {
            my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL  => 'DELETE FROM calendar WHERE id = ?',
                Bind => [ \$Calendar{CalendarID} ],
            );
            $Self->True(
                $Success,
                "Deleted test calendar - $Calendar{CalendarID}",
            );
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (qw(Calendar Appointment)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    },
);

1;
