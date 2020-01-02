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
        my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');

        my $RandomID = $Helper->GetRandomID();

        # Create test group.
        my $GroupName = "test-calendar-group-$RandomID";
        my $GroupID   = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Get current system time.
        my $StartTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                TimeZone => 'UTC',    # override local time zone
            },
        );

        # Add one month.
        $StartTimeObject->Add(
            Months => 1,
        );

        my $StartTimeSettings = $StartTimeObject->Get();

        # Change resolution (desktop mode).
        $Selenium->set_window_size( 768, 1050 );

        # Create test user.
        my $Language      = 'en';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'users', $GroupName ],
            Language => $Language,
        ) || die "Did not get test user";

        # Get UserID.
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Start test.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Create a few test calendars.
        my %Calendar1 = $Kernel::OM->Get('Kernel::System::Calendar')->CalendarCreate(
            CalendarName => "My Calendar $RandomID",
            Color        => '#3A87AD',
            GroupID      => $GroupID,
            UserID       => $UserID,
            ValidID      => 1,
        );

        # Go to calendar overview page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentCalendarOverview");

        # Wait for AJAX to finish.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # Click on the month view.
        $Selenium->find_element( '.fc-month-button', 'css' )->click();

        # Wait for AJAX to finish.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".fc-month-view").length;' );

        # Go to next month.
        $Selenium->find_element( '.fc-toolbar .fc-next-button', 'css' )->click();

        # Wait for AJAX to finish.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length;' );

        # Get first date of the month.
        my $DataDate = sprintf( "%02d-%02d-01", $StartTimeSettings->{Year}, $StartTimeSettings->{Month} );

        # Create every day appointment.
        $Selenium->find_elements("//td[contains(\@data-date,'$DataDate')]")->[1]->click();

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );
        $Selenium->WaitFor( JavaScript => "return \$('#CalendarID').length && \$('#EditFormSubmit').length;" );

        # Click on Save, without required input fields.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title.Error').length" );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Title').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Enter some data.
        $Selenium->find_element( '#Title', 'css' )->send_keys('Every day');
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendar1{CalendarID},
        );
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceType',
            Value   => 'Daily',
        );

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();

        # Wait for dialog to close and AJAX to finish.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
        );

        my @Appointments1 = $AppointmentObject->AppointmentList(
            CalendarID => $Calendar1{CalendarID},
            Result     => 'HASH',
        );

        # Make sure there are 4 appointments.
        $Self->Is(
            scalar @Appointments1,
            4,
            "Create daily recurring appointment."
        );

        my $Delete1 = $AppointmentObject->AppointmentDelete(
            AppointmentID => $Appointments1[0]->{AppointmentID},
            UserID        => $UserID,
        );

        # Delete appointments.
        $Self->True(
            $Delete1,
            "Delete daily recurring appointments.",
        );

        # Create every week appointment.
        $Selenium->find_elements("//td[contains(\@data-date,'$DataDate')]")->[1]->click();

        # Wait until form and overlay has loaded, if neccessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );
        $Selenium->WaitFor( JavaScript => "return \$('#CalendarID').length && \$('#EditFormSubmit').length;" );

        # Enter some data.
        $Selenium->find_element( '#Title', 'css' )->send_keys('Every week');
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendar1{CalendarID},
        );
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceType',
            Value   => 'Weekly'
        );

        # Create 3 appointment.
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceLimit',
            Value   => 2,
        );

        # Enter some data.
        $Selenium->find_element( '#RecurrenceCount', 'css' )->send_keys('3');

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();

        # Wait for AJAX to finish.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
        );

        my @Appointments2 = $AppointmentObject->AppointmentList(
            CalendarID => $Calendar1{CalendarID},
            Result     => 'HASH',
        );

        # Make sure there are 3 appointments.
        $Self->Is(
            scalar @Appointments2,
            3,
            "Create weekly recurring appointment."
        );

        my $AppointmentTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String   => "$DataDate 00:00:00",
                TimeZone => 'UTC',                  # override local time zone
            },
        );

        my $OneWeekTimeObject = $AppointmentTimeObject->Clone();
        $OneWeekTimeObject->Add(
            Weeks => 1,
        );

        my $TwoWeeksTimeObject = $AppointmentTimeObject->Clone();
        $TwoWeeksTimeObject->Add(
            Weeks => 2,
        );

        my @Appointment2StartTimes = (
            $AppointmentTimeObject->ToString(),
            $OneWeekTimeObject->ToString(),
            $TwoWeeksTimeObject->ToString(),
        );

        for my $Index ( 0 .. 2 ) {
            $Self->Is(
                $Appointments2[$Index]->{StartTime},
                $Appointment2StartTimes[$Index],
                "Check start time #$Index",
            );
        }

        # Delete appointments.
        my $Delete2 = $AppointmentObject->AppointmentDelete(
            AppointmentID => $Appointments2[0]->{AppointmentID},
            UserID        => $UserID,
        );

        # Delete appointments.
        $Self->True(
            $Delete2,
            "Delete weekly recurring appointments.",
        );

        # Create every month appointment.
        $Selenium->find_elements("//td[contains(\@data-date,'$DataDate')]")->[1]->click();

        # Wait until form and overlay has loaded, if neccessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );
        $Selenium->WaitFor( JavaScript => "return \$('#CalendarID').length && \$('#EditFormSubmit').length;" );

        # Enter some data.
        $Selenium->find_element( '#Title', 'css' )->send_keys('Every month');
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendar1{CalendarID},
        );
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceType',
            Value   => 'Monthly',
        );

        # Create 3 appointment.
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceLimit',
            Value   => 2,
        );

        # Enter some data.
        $Selenium->find_element( '#RecurrenceCount', 'css' )->send_keys('3');

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();

        # Wait for AJAX to finish.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
        );

        my @Appointments3 = $AppointmentObject->AppointmentList(
            CalendarID => $Calendar1{CalendarID},
            Result     => 'HASH',
        );

        # Make sure there are 3 appointments.
        $Self->Is(
            scalar @Appointments3,
            3,
            "Create monthly recurring appointment."
        );

        my $OneMonthTimeObject = $AppointmentTimeObject->Clone();
        $OneMonthTimeObject->Add(
            Months => 1,
        );

        my $TwoMonthsTimeObject = $AppointmentTimeObject->Clone();
        $TwoMonthsTimeObject->Add(
            Months => 2,
        );

        my @Appointment3StartTimes = (
            $AppointmentTimeObject->ToString(),
            $OneMonthTimeObject->ToString(),
            $TwoMonthsTimeObject->ToString(),
        );

        for my $Index ( 0 .. 2 ) {
            $Self->Is(
                $Appointments3[$Index]->{StartTime},
                $Appointment3StartTimes[$Index],
                "Check start time #$Index",
            );
        }

        # Delete appointments.
        my $Delete3 = $AppointmentObject->AppointmentDelete(
            AppointmentID => $Appointments3[0]->{AppointmentID},
            UserID        => $UserID,
        );

        # Delete appointments.
        $Self->True(
            $Delete3,
            "Delete monthly recurring appointments.",
        );

        # Create every year appointment.
        $Selenium->find_elements("//td[contains(\@data-date,'$DataDate')]")->[1]->click();

        # Wait until form and overlay has loaded, if neccessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );
        $Selenium->WaitFor( JavaScript => "return \$('#CalendarID').length && \$('#EditFormSubmit').length;" );

        # Enter some data.
        $Selenium->find_element( '#Title', 'css' )->send_keys('Every year');
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendar1{CalendarID},
        );
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceType',
            Value   => 'Yearly',
        );

        # Create 3 appointment.
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceLimit',
            Value   => 2,
        );

        # Enter some data.
        $Selenium->find_element( '#RecurrenceCount', 'css' )->send_keys('3');

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();

        # Wait for AJAX to finish.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
        );

        my @Appointments4 = $AppointmentObject->AppointmentList(
            CalendarID => $Calendar1{CalendarID},
            Result     => 'HASH',
        );

        # Make sure there are 3 appointments.
        $Self->Is(
            scalar @Appointments4,
            3,
            "Create yearly recurring appointment."
        );

        my $OneYearTimeObject = $AppointmentTimeObject->Clone();
        $OneYearTimeObject->Add(
            Years => 1,
        );

        my $TwoYearsTimeObject = $AppointmentTimeObject->Clone();
        $TwoYearsTimeObject->Add(
            Years => 2,
        );

        my @Appointment4StartTimes = (
            $AppointmentTimeObject->ToString(),
            $OneYearTimeObject->ToString(),
            $TwoYearsTimeObject->ToString(),
        );

        for my $Index ( 0 .. 2 ) {
            $Self->Is(
                $Appointments4[$Index]->{StartTime},
                $Appointment4StartTimes[$Index],
                "Check start time #$Index",
            );
        }

        # Delete appointments.
        my $Delete4 = $AppointmentObject->AppointmentDelete(
            AppointmentID => $Appointments4[0]->{AppointmentID},
            UserID        => $UserID,
        );

        # Delete appointments.
        $Self->True(
            $Delete4,
            "Delete yearly recurring appointments.",
        );

        # Create appointment every second day.
        $Selenium->find_elements("//td[contains(\@data-date,'$DataDate')]")->[1]->click();

        # Wait until form and overlay has loaded, if neccessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );
        $Selenium->WaitFor( JavaScript => "return \$('#CalendarID').length && \$('#EditFormSubmit').length;" );

        # Enter some data.
        $Selenium->find_element( '#Title', 'css' )->send_keys('Every 2nd day');
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendar1{CalendarID},
        );
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceType',
            Value   => 'Custom',
        );

        # Wait until js shows Interval.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceInterval:visible").length;'
        );

        # Set each 2nd day.
        $Selenium->execute_script(
            "\$('#RecurrenceInterval').val(2);"
        );

        # Create 3 appointment.
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceLimit',
            Value   => 2,
        );
        $Selenium->find_element( '#RecurrenceCount', 'css' )->send_keys('3');

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();

        # Wait for dialog to close and AJAX to finish.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
        );

        my @Appointments5 = $AppointmentObject->AppointmentList(
            CalendarID => $Calendar1{CalendarID},
            Result     => 'HASH',
        );

        # Make sure there are 3 appointments.
        $Self->Is(
            scalar @Appointments5,
            3,
            "Create custom daily recurring appointment."
        );

        my $TwoDaysTimeObject = $AppointmentTimeObject->Clone();
        $TwoDaysTimeObject->Add(
            Days => 2,
        );

        my $FourDaysTimeObject = $AppointmentTimeObject->Clone();
        $FourDaysTimeObject->Add(
            Days => 4,
        );

        my @Appointment5StartTimes = (
            $AppointmentTimeObject->ToString(),
            $TwoDaysTimeObject->ToString(),
            $FourDaysTimeObject->ToString(),
        );

        for my $Index ( 0 .. 2 ) {
            $Self->Is(
                $Appointments5[$Index]->{StartTime},
                $Appointment5StartTimes[$Index],
                "Check start time #$Index",
            );
        }

        my $Delete5 = $AppointmentObject->AppointmentDelete(
            AppointmentID => $Appointments5[0]->{AppointmentID},
            UserID        => $UserID,
        );

        # Delete appointments.
        $Self->True(
            $Delete5,
            "Delete custom daily recurring appointments.",
        );

        # Create custom weekly recurring appointment.
        $Selenium->find_elements("//td[contains(\@data-date,'$DataDate')]")->[1]->click();

        # Wait until form and overlay has loaded, if neccessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );
        $Selenium->WaitFor( JavaScript => "return \$('#CalendarID').length && \$('#EditFormSubmit').length;" );

        # Enter some data.
        $Selenium->find_element( '#Title', 'css' )->send_keys('Every 2nd Monday, Wednesday and Sunday');
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendar1{CalendarID},
        );
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceType',
            Value   => 'Custom',
        );

        # Wait until js shows Interval.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceInterval:visible").length;'
        );

        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceCustomType',
            Value   => 'CustomWeekly',
        );

        # Wait for js.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceCustomWeeklyDiv:visible").length;'
        );

        # Deselect selected day.
        $Selenium->execute_script(
            "\$('#RecurrenceCustomWeeklyDiv button.fc-state-active').click();"
        );

        # Make sure it's deselected.
        my $Deselected6 = $Selenium->WaitFor(
            JavaScript =>
                'return !$("#RecurrenceCustomWeeklyDiv button.fc-state-active").length;'
        );
        $Self->True(
            $Deselected6,
            "Check if nothing is selected (#6)"
        );

        # Select Mon.
        $Selenium->execute_script(
            "\$('#RecurrenceCustomWeeklyDiv button[value=\"1\"]').click();"
        );

        # Check if selected successful.
        my $Wait6For1 = $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceCustomWeeklyDiv button[value=\"1\"]").hasClass("fc-state-active");'
        );
        $Self->True(
            $Wait6For1,
            "Custom weekly appointment - check if Monday is selected."
        );

        # Select Wed.
        $Selenium->execute_script(
            "\$('#RecurrenceCustomWeeklyDiv button[value=\"3\"]').click();"
        );

        # Check if selected successful.
        my $Wait6For3 = $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceCustomWeeklyDiv button[value=\"3\"]").hasClass("fc-state-active");'
        );
        $Self->True(
            $Wait6For3,
            "Custom weekly appointment - check if Wednesday is selected."
        );

        # Select Sun.
        $Selenium->execute_script(
            "\$('#RecurrenceCustomWeeklyDiv button[value=\"7\"]').click();"
        );

        # Check if selected successful.
        my $Wait6For7 = $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceCustomWeeklyDiv button[value=\"7\"]").hasClass("fc-state-active");'
        );
        $Self->True(
            $Wait6For7,
            "Custom weekly appointment - check if Sunday is selected."
        );

        # Set each 2nd week.
        $Selenium->execute_script(
            "\$('#RecurrenceInterval').val(2);"
        );

        # Create 6 appointments.
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceLimit',
            Value   => 2,
        );
        $Selenium->find_element( '#RecurrenceCount', 'css' )->send_keys('6');

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();

        # Wait for dialog to close and AJAX to finish.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
        );

        my @Appointments6 = $AppointmentObject->AppointmentList(
            CalendarID => $Calendar1{CalendarID},
            Result     => 'HASH',
        );

        # Make sure there are 6 appointments.
        $Self->Is(
            scalar @Appointments6,
            6,
            "Create custom weekly recurring appointment."
        );

        my @Appointment6StartTimes;
        my $Appointment6TimeObject = $AppointmentTimeObject->Clone();

        my $LastCW6;

        while ( scalar @Appointment6StartTimes != 6 ) {
            my $Appointment6TimeSettings = $Appointment6TimeObject->Get();

            # Add current day.
            if ( !$LastCW6 ) {
                push @Appointment6StartTimes, $Appointment6TimeObject->ToString();
                $LastCW6 = $Appointment6TimeObject->{CPANDateTimeObject}->week_number();
            }
            elsif (
                ( grep { $Appointment6TimeSettings->{DayOfWeek} == $_ } ( 1, 3, 7 ) )    # Check if day is valid
                && (
                    ( $Appointment6TimeObject->{CPANDateTimeObject}->week_number() - $LastCW6 ) % 2
                    == 0
                )                                                                        # Check if Interval matches
                )
            {
                push @Appointment6StartTimes, $Appointment6TimeObject->ToString();
                $LastCW6 = $Appointment6TimeObject->{CPANDateTimeObject}->week_number();
            }

            # Add one day.
            $Appointment6TimeObject->Add(
                Days => 1,
            );
        }

        for my $Index ( 0 .. 5 ) {
            $Self->Is(
                $Appointments6[$Index]->{StartTime},
                $Appointment6StartTimes[$Index],
                "Check start time #$Index",
            );
        }

        my $Delete6 = $AppointmentObject->AppointmentDelete(
            AppointmentID => $Appointments6[0]->{AppointmentID},
            UserID        => $UserID,
        );

        # Delete appointments.
        $Self->True(
            $Delete6,
            "Delete custom weekly recurring appointments.",
        );

        # Create custom weekly recurring appointment(without anything selected).
        $Selenium->find_elements("//td[contains(\@data-date,'$DataDate')]")->[1]->click();

        # Wait until form and overlay has loaded, if neccessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );
        $Selenium->WaitFor( JavaScript => "return \$('#CalendarID').length && \$('#EditFormSubmit').length;" );

        # Enter some data.
        $Selenium->find_element( '#Title', 'css' )->send_keys('Custom weekly without anything selected');
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendar1{CalendarID},
        );
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceType',
            Value   => 'Custom',
        );

        # Wait until js shows Interval.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceInterval:visible").length;'
        );

        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceCustomType',
            Value   => 'CustomWeekly',
        );

        # Wait for js.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceCustomWeeklyDiv:visible").length;'
        );

        # Deselect selected day.
        $Selenium->execute_script(
            "\$('#RecurrenceCustomWeeklyDiv button.fc-state-active').click();"
        );

        # Make sure it's deselected.
        my $Deselected7 = $Selenium->WaitFor(
            JavaScript =>
                'return !$("#RecurrenceCustomWeeklyDiv button.fc-state-active").length;'
        );
        $Self->True(
            $Deselected7,
            "Check if nothing is selected (#7)"
        );

        # Set each 2nd week.
        $Selenium->execute_script(
            "\$('#RecurrenceInterval').val(2);"
        );

        # Create 3 appointments.
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceLimit',
            Value   => 2,
        );
        $Selenium->find_element( '#RecurrenceCount', 'css' )->send_keys('3');

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();

        # Wait for dialog to close and AJAX to finish.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
        );

        my @Appointments7 = $AppointmentObject->AppointmentList(
            CalendarID => $Calendar1{CalendarID},
            Result     => 'HASH',
        );

        # Make sure there are 3 appointments.
        $Self->Is(
            scalar @Appointments7,
            3,
            "Create custom weekly recurring appointment(without any day selected)."
        );

        my @Appointment7StartTimes;
        my $Appointment7TimeObject = $AppointmentTimeObject->Clone();

        my $LastCW7;
        my $DayOfWeek7;

        while ( scalar @Appointment7StartTimes != 3 ) {
            my $Appointment7TimeSettings = $Appointment7TimeObject->Get();

            # Add current day.
            if ( !$LastCW7 ) {
                push @Appointment7StartTimes, $Appointment7TimeObject->ToString();
                $LastCW7    = $Appointment7TimeObject->{CPANDateTimeObject}->week_number();
                $DayOfWeek7 = $Appointment7TimeSettings->{DayOfWeek};
            }
            elsif (
                ( $Appointment7TimeSettings->{DayOfWeek} == $DayOfWeek7 )    # Check if day is valid
                && (
                    ( $Appointment7TimeObject->{CPANDateTimeObject}->week_number() - $LastCW7 ) % 2
                    == 0
                )                                                            # Check if Interval matches
                )
            {
                push @Appointment7StartTimes, $Appointment7TimeObject->ToString();
                $LastCW7 = $Appointment7TimeObject->{CPANDateTimeObject}->week_number();
            }

            # Add one day.
            $Appointment7TimeObject->Add(
                Days => 1,
            );
        }

        for my $Index ( 0 .. 2 ) {
            $Self->Is(
                $Appointments7[$Index]->{StartTime},
                $Appointment7StartTimes[$Index],
                "Check start time #$Index",
            );
        }

        my $Delete7 = $AppointmentObject->AppointmentDelete(
            AppointmentID => $Appointments7[0]->{AppointmentID},
            UserID        => $UserID,
        );

        # Delete appointments.
        $Self->True(
            $Delete7,
            "Delete custom weekly recurring appointments.",
        );

        # Create custom monthly recurring appointment.
        $Selenium->find_elements("//td[contains(\@data-date,'$DataDate')]")->[1]->click();

        # Wait until form and overlay has loaded, if neccessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );
        $Selenium->WaitFor( JavaScript => "return \$('#CalendarID').length && \$('#EditFormSubmit').length;" );

        # Enter some data.
        $Selenium->find_element( '#Title', 'css' )->send_keys('Every 2nd month, on 3th, 10th and 31th of month');
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendar1{CalendarID},
        );

        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceType',
            Value   => 'Custom',
        );

        # Wait until js shows Interval.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceInterval:visible").length;'
        );

        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceCustomType',
            Value   => 'CustomMonthly',
        );

        # Wait for js.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceCustomMonthlyDiv:visible").length;'
        );

        # Deselect selected day.
        $Selenium->execute_script(
            "\$('#RecurrenceCustomMonthlyDiv button.fc-state-active').click();"
        );

        # Make sure it's deselected.
        my $Deselected8 = $Selenium->WaitFor(
            JavaScript =>
                'return !$("#RecurrenceCustomMonthlyDiv button.fc-state-active").length;'
        );
        $Self->True(
            $Deselected8,
            "Check if nothing is selected (#8)"
        );

        # Select 3th.
        $Selenium->execute_script(
            "\$('#RecurrenceCustomMonthlyDiv button[value=\"3\"]').click();"
        );

        # Check if selected successful.
        my $Wait8For3 = $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceCustomMonthlyDiv button[value=\"3\"]").hasClass("fc-state-active");'
        );
        $Self->True(
            $Wait8For3,
            "Custom monthly appointment - check if 3 is selected."
        );

        # Select 10th.
        $Selenium->execute_script(
            "\$('#RecurrenceCustomMonthlyDiv button[value=\"10\"]').click();"
        );

        # Check if selected successful.
        my $Wait8For10 = $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceCustomMonthlyDiv button[value=\"10\"]").hasClass("fc-state-active");'
        );
        $Self->True(
            $Wait8For10,
            "Custom monthly appointment - check if 10 is selected."
        );

        # Select 31.
        $Selenium->execute_script(
            "\$('#RecurrenceCustomMonthlyDiv button[value=\"31\"]').click();"
        );

        # Check if selected successful.
        my $Wait8For31 = $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceCustomMonthlyDiv button[value=\"31\"]").hasClass("fc-state-active");'
        );
        $Self->True(
            $Wait8For31,
            "Custom monthly appointment - check if 31 is selected."
        );

        # Set each 2nd week.
        $Selenium->execute_script(
            "\$('#RecurrenceInterval').val(2);"
        );

        # Create 20 appointments.
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceLimit',
            Value   => 2,
        );
        $Selenium->find_element( '#RecurrenceCount', 'css' )->send_keys('20');

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();

        # Wait for dialog to close and AJAX to finish.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
        );

        my @Appointments8 = $AppointmentObject->AppointmentList(
            CalendarID => $Calendar1{CalendarID},
            Result     => 'HASH',
        );

        # Make sure there are 20 appointments.
        $Self->Is(
            scalar @Appointments8,
            20,
            "Create custom monthly recurring appointment."
        );

        my @Appointment8StartTimes;
        my $Appointment8TimeObject = $AppointmentTimeObject->Clone();

        my $LastMonth8;

        while ( scalar @Appointment8StartTimes != 20 ) {
            my $Appointment8TimeSettings = $Appointment8TimeObject->Get();

            if ( !$LastMonth8 ) {
                push @Appointment8StartTimes, $Appointment8TimeObject->ToString();
                $LastMonth8 = $Appointment8TimeSettings->{Month};
            }
            elsif (
                ( grep { $Appointment8TimeSettings->{Day} == $_ } ( 3, 10, 31 ) )    # Check if day is valid
                && (
                    ( $Appointment8TimeSettings->{Month} - $LastMonth8 ) % 2 == 0    # Check if Interval matches
                )
                )
            {
                push @Appointment8StartTimes, $Appointment8TimeObject->ToString();
            }

            # Add one day.
            $Appointment8TimeObject->Add(
                Days => 1,
            );
        }

        for my $Index ( 0 .. 19 ) {
            $Self->Is(
                $Appointments8[$Index]->{StartTime},
                $Appointment8StartTimes[$Index],
                "Check start time #$Index",
            );
        }

        my $Delete8 = $AppointmentObject->AppointmentDelete(
            AppointmentID => $Appointments8[0]->{AppointmentID},
            UserID        => $UserID,
        );

        # Delete appointments.
        $Self->True(
            $Delete8,
            "Delete custom monthly recurring appointments.",
        );

        # Create custom weekly recurring appointment(without anything selected).
        $Selenium->find_elements("//td[contains(\@data-date,'$DataDate')]")->[1]->click();

        # Wait until form and overlay has loaded, if neccessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );
        $Selenium->WaitFor( JavaScript => "return \$('#CalendarID').length && \$('#EditFormSubmit').length;" );

        # Enter some data.
        $Selenium->find_element( '#Title', 'css' )->send_keys('Custom monthly without anything selected');
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendar1{CalendarID},
        );

        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceType',
            Value   => 'Custom',
        );

        # Wait until js shows Interval.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceInterval:visible").length;'
        );

        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceCustomType',
            Value   => 'CustomMonthly',
        );

        # Wait for js.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceCustomMonthlyDiv:visible").length;'
        );

        # Deselect selected day.
        $Selenium->execute_script(
            "\$('#RecurrenceCustomMonthlyDiv button.fc-state-active').click();"
        );

        # Make sure it's deselected.
        my $Deselected9 = $Selenium->WaitFor(
            JavaScript =>
                'return !$("#RecurrenceCustomMonthlyDiv button.fc-state-active").length;'
        );
        $Self->True(
            $Deselected9,
            "Check if nothing is selected (#9)"
        );

        # Set each 2nd year.
        $Selenium->execute_script(
            "\$('#RecurrenceInterval').val(2);"
        );

        # Create 3 appointments.
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceLimit',
            Value   => 2,
        );
        $Selenium->find_element( '#RecurrenceCount', 'css' )->send_keys('3');

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();

        # Wait for dialog to close and AJAX to finish.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
        );

        my @Appointments9 = $AppointmentObject->AppointmentList(
            CalendarID => $Calendar1{CalendarID},
            Result     => 'HASH',
        );

        # Make sure there are 3 appointments.
        $Self->Is(
            scalar @Appointments9,
            3,
            "Create custom monthly recurring appointment(without any day selected)."
        );

        my @Appointment9StartTimes;
        my $Appointment9TimeObject = $AppointmentTimeObject->Clone();

        my $LastMonth9;
        my $Day9;

        while ( scalar @Appointment9StartTimes != 3 ) {
            my $Appointment9TimeSettings = $Appointment9TimeObject->Get();

            # Add current day.
            if ( !$LastMonth9 ) {
                push @Appointment9StartTimes, $Appointment9TimeObject->ToString();
                $LastMonth9 = $Appointment9TimeSettings->{Month};
                $Day9       = $Appointment9TimeSettings->{Day};
            }
            elsif (
                ( $Appointment9TimeSettings->{Day} == $Day9 )                           # Check if day is valid
                && ( ( $Appointment9TimeSettings->{Month} - $LastMonth9 ) % 2 == 0 )    # Check if Interval matches
                )
            {
                push @Appointment9StartTimes, $Appointment9TimeObject->ToString();
                $LastMonth9 = $Appointment9TimeSettings->{Month};
            }

            # Add one day.
            $Appointment9TimeObject->Add(
                Days => 1,
            );
        }

        for my $Index ( 0 .. 2 ) {
            $Self->Is(
                $Appointments9[$Index]->{StartTime},
                $Appointment9StartTimes[$Index],
                "Check start time #$Index",
            );
        }

        my $Delete9 = $AppointmentObject->AppointmentDelete(
            AppointmentID => $Appointments9[0]->{AppointmentID},
            UserID        => $UserID,
        );

        # Delete appointments.
        $Self->True(
            $Delete9,
            "Delete custom weekly recurring appointments.",
        );

        # Create custom yearly recurring appointment.
        $Selenium->find_elements("//td[contains(\@data-date,'$DataDate')]")->[1]->click();

        # Wait until form and overlay has loaded, if neccessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );
        $Selenium->WaitFor( JavaScript => "return \$('#CalendarID').length && \$('#EditFormSubmit').length;" );

        # Enter some data.
        $Selenium->find_element( '#Title', 'css' )->send_keys('Every 2nd year, in February, October and December');
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendar1{CalendarID},
        );

        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceType',
            Value   => 'Custom',
        );

        # Wait until js shows Interval.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceInterval:visible").length;'
        );

        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceCustomType',
            Value   => 'CustomYearly',
        );

        # Wait for js.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceCustomYearlyDiv:visible").length;'
        );

        # Deselect selected month.
        $Selenium->execute_script(
            "\$('#RecurrenceCustomYearlyDiv button.fc-state-active').click();"
        );

        # Make sure it's deselected.
        my $Deselected10 = $Selenium->WaitFor(
            JavaScript =>
                'return !$("#RecurrenceCustomYearlyDiv button.fc-state-active").length;'
        );
        $Self->True(
            $Deselected10,
            "Check if nothing is selected (#10)"
        );

        # Select February.
        $Selenium->execute_script(
            "\$('#RecurrenceCustomYearlyDiv button[value=\"2\"]').click();"
        );

        # Check if selected successful.
        my $Wait10For2 = $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceCustomYearlyDiv button[value=\"2\"]").hasClass("fc-state-active");'
        );
        $Self->True(
            $Wait10For2,
            "Custom yearly appointment - check if February is selected."
        );

        # Select October.
        $Selenium->execute_script(
            "\$('#RecurrenceCustomYearlyDiv button[value=\"10\"]').click();"
        );

        # Check if selected successful.
        my $Wait10For10 = $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceCustomYearlyDiv button[value=\"10\"]").hasClass("fc-state-active");'
        );
        $Self->True(
            $Wait10For10,
            "Custom yearly appointment - check if October is selected."
        );

        # Select December.
        $Selenium->execute_script(
            "\$('#RecurrenceCustomYearlyDiv button[value=\"12\"]').click();"
        );

        # Check if selected successful.
        my $Wait10For12 = $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceCustomYearlyDiv button[value=\"12\"]").hasClass("fc-state-active");'
        );
        $Self->True(
            $Wait10For12,
            "Custom yearly appointment - check if December is selected."
        );

        # Set each 2nd week.
        $Selenium->execute_script(
            "\$('#RecurrenceInterval').val(2);"
        );

        # Create 6 appointments.
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceLimit',
            Value   => 2,
        );
        $Selenium->find_element( '#RecurrenceCount', 'css' )->send_keys('6');

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();

        # Wait for dialog to close and AJAX to finish.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
        );

        my @Appointments10 = $AppointmentObject->AppointmentList(
            CalendarID => $Calendar1{CalendarID},
            Result     => 'HASH',
        );

        # Make sure there are 6 appointments.
        $Self->Is(
            scalar @Appointments10,
            6,
            "Create custom yearly recurring appointment."
        );

        my @Appointment10StartTimes;
        my $Appointment10TimeObject = $AppointmentTimeObject->Clone();

        my $LastYear10;
        my $Day10;

        while ( scalar @Appointment10StartTimes != 6 ) {
            my $Appointment10TimeSettings = $Appointment10TimeObject->Get();

            if ( !$LastYear10 ) {
                push @Appointment10StartTimes, $Appointment10TimeObject->ToString();
                $LastYear10 = $Appointment10TimeSettings->{Year};
                $Day10      = $Appointment10TimeSettings->{Day};
            }
            elsif (
                $Appointment10TimeSettings->{Day} == $Day10
                && ( grep { $Appointment10TimeSettings->{Month} == $_ } ( 2, 10, 12 ) )    # Check if day is valid
                && ( ( $Appointment10TimeSettings->{Year} - $LastYear10 ) % 2 == 0 )       # Check if Interval matches
                )
            {
                push @Appointment10StartTimes, $Appointment10TimeObject->ToString();
            }

            # Add one day.
            $Appointment10TimeObject->Add(
                Days => 1,
            );
        }

        for my $Index ( 0 .. 5 ) {
            $Self->Is(
                $Appointments10[$Index]->{StartTime},
                $Appointment10StartTimes[$Index],
                "Check start time #$Index",
            );
        }

        my $Delete10 = $AppointmentObject->AppointmentDelete(
            AppointmentID => $Appointments10[0]->{AppointmentID},
            UserID        => $UserID,
        );

        # Delete appointments.
        $Self->True(
            $Delete10,
            "Delete custom monthly recurring appointments.",
        );

        # Create custom weekly recurring appointment(without anything selected).
        $Selenium->find_elements("//td[contains(\@data-date,'$DataDate')]")->[1]->click();

        # Wait until form and overlay has loaded, if neccessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );
        $Selenium->WaitFor( JavaScript => "return \$('#CalendarID').length && \$('#EditFormSubmit').length;" );

        # Enter some data.
        $Selenium->find_element( '#Title', 'css' )->send_keys('Custom yearly without anything selected');
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendar1{CalendarID},
        );

        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceType',
            Value   => 'Custom',
        );

        # Wait until js shows Interval.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceInterval:visible").length'
        );

        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceCustomType',
            Value   => 'CustomYearly',
        );

        # Wait for js.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#RecurrenceCustomYearlyDiv:visible").length;'
        );

        # Deselect selected month.
        $Selenium->execute_script(
            "\$('#RecurrenceCustomYearlyDiv button.fc-state-active').click();"
        );

        # Make sure it's deselected.
        my $Deselected11 = $Selenium->WaitFor(
            JavaScript =>
                'return !$("#RecurrenceCustomYearlyDiv button.fc-state-active").length;'
        );
        $Self->True(
            $Deselected11,
            "Check if nothing is selected (#11)"
        );

        # Set each 2nd year.
        $Selenium->execute_script(
            "\$('#RecurrenceInterval').val(2);"
        );

        # Create 3 appointments.
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceLimit',
            Value   => 2,
        );
        $Selenium->find_element( '#RecurrenceCount', 'css' )->send_keys('3');

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();

        # Wait for dialog to close and AJAX to finish.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
        );

        my @Appointments11 = $AppointmentObject->AppointmentList(
            CalendarID => $Calendar1{CalendarID},
            Result     => 'HASH',
        );

        # Make sure there are 3 appointments.
        $Self->Is(
            scalar @Appointments11,
            3,
            "Create custom yearly recurring appointment(without any month selected)."
        );

        my @Appointment11StartTimes;
        my $Appointment11TimeObject = $AppointmentTimeObject->Clone();

        my $LastYear11;
        my $Day11;
        my $Month11;

        while ( scalar @Appointment11StartTimes != 3 ) {
            my $Appointment11TimeSettings = $Appointment11TimeObject->Get();

            # Add current day.
            if ( !$LastYear11 ) {
                push @Appointment11StartTimes, $Appointment11TimeObject->ToString();
                $LastYear11 = $Appointment11TimeSettings->{Year};
                $Day11      = $Appointment11TimeSettings->{Day};
                $Month11    = $Appointment11TimeSettings->{Month};
            }
            elsif (
                ( $Appointment11TimeSettings->{Day} == $Day11 )    # Check if day is valid
                && $Appointment11TimeSettings->{Month} == $Month11
                && ( ( $Appointment11TimeSettings->{Year} - $LastYear11 ) % 2 == 0 )    # Check if Interval matches
                )
            {
                push @Appointment11StartTimes, $Appointment11TimeObject->ToString();
            }

            # Add one day.
            $Appointment11TimeObject->Add(
                Days => 1,
            );
        }

        for my $Index ( 0 .. 2 ) {
            $Self->Is(
                $Appointments11[$Index]->{StartTime},
                $Appointment11StartTimes[$Index],
                "Check start time #$Index",
            );
        }

        my $Delete11 = $AppointmentObject->AppointmentDelete(
            AppointmentID => $Appointments11[0]->{AppointmentID},
            UserID        => $UserID,
        );

        # Delete appointments.
        $Self->True(
            $Delete11,
            "Delete custom yearly recurring appointments(without any month selected).",
        );
    },
);

1;
