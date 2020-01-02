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
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
        my $GroupObject       = $Kernel::OM->Get('Kernel::System::Group');
        my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');
        my $UserObject        = $Kernel::OM->Get('Kernel::System::User');

        my $RandomID = $Helper->GetRandomID();

        # Create test group.
        my $GroupName = "test-calendar-group-$RandomID";
        my $GroupID   = $GroupObject->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        my $NextMonthObject = $Kernel::OM->Create('Kernel::System::DateTime');
        $NextMonthObject->Add(
            Months => 1,
        );
        my $NextMonthSettings = $NextMonthObject->Get();

        my $LastYearDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        $LastYearDateTimeObject->Subtract(
            Years => 1,
        );
        my $LastYearSettings = $LastYearDateTimeObject->Get();

        my $YearBeforeLastDateTimeObject = $LastYearDateTimeObject->Clone();
        $YearBeforeLastDateTimeObject->Subtract(
            Years => 1,
        );
        my $YearBeforeLastSettings = $YearBeforeLastDateTimeObject->Get();

        # Change resolution (desktop mode).
        $Selenium->set_window_size( 768, 1050 );

        # Create test user.
        my $Language      = 'en';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'users', $GroupName ],
            Language => $Language,
        ) || die "Did not get test user";

        # Get UserID.
        my $UserID = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Create test calendars.
        my %Calendar1 = $CalendarObject->CalendarCreate(
            CalendarName => "My Calendar $RandomID",
            Color        => '#3A87AD',
            GroupID      => $GroupID,
            UserID       => $UserID,
            ValidID      => 1,
        );

        # Go to calendar overview page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentCalendarOverview");

        # Wait for AJAX to finish.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length;' );

        # Click on the month view.
        $Selenium->find_element( '.fc-month-button', 'css' )->click();

        # Wait for AJAX to finish.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length;' );

        # Go to next month.
        $Selenium->find_element( '.fc-toolbar .fc-next-button', 'css' )->click();

        # Wait for AJAX to finish.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length;' );

        my $DataDate = sprintf( "%04d-%02d-01", $NextMonthSettings->{Year}, $NextMonthSettings->{Month} );

        # Pre-Defined Templates.

        # Define appointment test with pre-defined notification templates.
        my @TemplateCreateTests = (

            # No active notification template.
            {
                Data => {
                    Description          => 'No notification',
                    NotificationTemplate => 0,
                    Offset               => 0,
                },
                Result => {
                    NotificationDate                      => '',
                    NotificationTemplate                  => '',
                    NotificationCustom                    => '',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => '',
                    NotificationCustomRelativePointOfTime => '',
                },
            },

            # Notification template start (appointment start time).
            {
                Data => {
                    Description          => 'Appointment start',
                    NotificationTemplate => 'Start',
                    Offset               => 0,
                },
                Result => {
                    NotificationTemplate                  => 'Start',
                    NotificationCustom                    => '',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                },
            },

            # Notification template 5 minutes before.
            {
                Data => {
                    Description          => '5 minutes before',
                    NotificationTemplate => 300,
                    Offset               => 300,
                },
                Result => {
                    NotificationTemplate                  => 300,
                    NotificationCustom                    => '',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                },
            },

            # Notification template 15 minutes before.
            {
                Data => {
                    Description          => '15 minutes before',
                    NotificationTemplate => 900,
                    Offset               => 900,
                },
                Result => {
                    NotificationTemplate                  => 900,
                    NotificationCustom                    => '',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                },
            },

            # Notification template 30 minutes before.
            {
                Data => {
                    Description          => '30 minutes before',
                    NotificationTemplate => 1800,
                    Offset               => 1800,
                },
                Result => {
                    NotificationTemplate                  => 1800,
                    NotificationCustom                    => '',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                },
            },

            # Notification template 1 hour before.
            {
                Data => {
                    Description          => '1 hour before',
                    NotificationTemplate => 3600,
                    Offset               => 3600,
                },
                Result => {
                    NotificationTemplate                  => 3600,
                    NotificationCustom                    => '',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                },
            },

            # Notification template 2 hours before.
            {
                Data => {
                    Description          => '2 hours before',
                    NotificationTemplate => 7200,
                    Offset               => 7200,
                },
                Result => {
                    NotificationTemplate                  => 7200,
                    NotificationCustom                    => '',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                },
            },

            # Notification template 12 hours before.
            {
                Data => {
                    Description          => '12 hours before',
                    NotificationTemplate => 43200,
                    Offset               => 43200,
                },
                Result => {
                    NotificationTemplate                  => 43200,
                    NotificationCustom                    => '',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                },
            },

            # Notification template 1 day before.
            {
                Data => {
                    Description          => '1 day before',
                    NotificationTemplate => 86400,
                    Offset               => 86400,
                },
                Result => {
                    NotificationTemplate                  => 86400,
                    NotificationCustom                    => '',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                },
            },

            # Notification template 2 days before.
            {
                Data => {
                    Description          => '2 days before',
                    NotificationTemplate => 172800,
                    Offset               => 172800,
                },
                Result => {
                    NotificationTemplate                  => 172800,
                    NotificationCustom                    => '',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                },
            },

            # Notification template 1 week before.
            {
                Data => {
                    Description          => '1 week before',
                    NotificationTemplate => 604800,
                    Offset               => 604800,
                },
                Result => {
                    NotificationTemplate                  => 604800,
                    NotificationCustom                    => '',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                },
            },
        );

        # Notification pre-defined template test execution.
        for my $Test (@TemplateCreateTests) {

            # Create appointment.
            $Selenium->find_elements("//td[contains(\@data-date,'$DataDate')]")->[1]->click();

            # Wait until form and overlay has loaded, if neccessary.
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );

            # Enter some data.
            $Selenium->find_element( '#Title', 'css' )->send_keys("$Test->{Data}->{Description}");
            $Selenium->InputFieldValueSet(
                Element => '#CalendarID',
                Value   => $Calendar1{CalendarID},
            );

            $Selenium->InputFieldValueSet(
                Element => '#NotificationTemplate',
                Value   => $Test->{Data}->{NotificationTemplate},
            );

            # Click on Save.
            $Selenium->execute_script(
                "\$('#EditFormSubmit')[0].scrollIntoView(true);",
            );

            # Wait for reload to kick in.
            $Selenium->WaitForjQueryEventBound(
                CSSSelector => "#EditFormSubmit",
            );
            $Selenium->find_element( '#EditFormSubmit', 'css' )->click();

            # Wait until all AJAX calls finished.
            $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

            # Wait for dialog to close and AJAX to finish.
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
            );

            my @AppointmentList = $AppointmentObject->AppointmentList(
                CalendarID => $Calendar1{CalendarID},
                Result     => 'HASH',
            );

            # Make sure there is an appointment.
            $Self->Is(
                scalar @AppointmentList,
                1,
                "Appointment list verification - $Test->{Data}->{Description} ."
            );

            if ( $Test->{Data}->{NotificationTemplate} ) {

                my $NotificationDateObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => "$DataDate 00:00:00",
                    },
                );
                $NotificationDateObject->Subtract(
                    Seconds => $Test->{Data}->{Offset},
                );

                $Self->Is(
                    $AppointmentList[0]->{NotificationDate},
                    $NotificationDateObject->ToString(),
                    "Verify notification date - $Test->{Data}->{Description} ."
                );
            }

            # Verify results.
            for my $ResultKey ( sort keys %{ $Test->{Result} } ) {

                $Self->Is(
                    $AppointmentList[0]->{$ResultKey} // '',
                    $Test->{Result}->{$ResultKey},
                    'Notification appointment result: ' . $ResultKey . ' - ' . $Test->{Data}->{Description},
                );
            }

            my $Delete = $AppointmentObject->AppointmentDelete(
                AppointmentID => $AppointmentList[0]->{AppointmentID},
                UserID        => $UserID,
            );

            # Delete appointment.
            $Self->True(
                $Delete,
                "Delete appointment verification - $Test->{Data}->{Description} .",
            );
        }

        # Custom Relative Templates.

        # Define appointment test with custom notification templates.
        my @TemplateCustomRelativeCreateTests = (

            # Custom relative notification 0 minutes before start.
            {
                Data => {
                    Description                           => 'Custom relative 0 minutes before start',
                    NotificationTemplate                  => 'Custom',
                    NotificationCustomRelativeInput       => 1,
                    NotificationCustomDateTimeInput       => 0,
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    UserID                                => $UserID,
                },
                Result => {
                    NotificationTemplate                  => 'Custom',
                    NotificationCustom                    => 'relative',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                },
            },

            # Custom relative notification -2 minutes before start.
            {
                Data => {
                    Description                           => 'Custom relative -2 minutes before start',
                    NotificationTemplate                  => 'Custom',
                    NotificationCustomRelativeInput       => 1,
                    NotificationCustomDateTimeInput       => 0,
                    NotificationCustomRelativeUnitCount   => -2,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    UserID                                => $UserID,
                },
                Result => {
                    NotificationTemplate                  => 'Custom',
                    NotificationCustom                    => 'relative',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                },
            },

            # Custom relative notification 2 minutes before start.
            {
                Data => {
                    Description                           => 'Custom relative 2 minutes before start',
                    NotificationTemplate                  => 'Custom',
                    NotificationCustomRelativeInput       => 1,
                    NotificationCustomDateTimeInput       => 0,
                    NotificationCustomRelativeUnitCount   => 2,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    UserID                                => $UserID,
                },
                Result => {
                    NotificationTemplate                  => 'Custom',
                    NotificationCustom                    => 'relative',
                    NotificationCustomRelativeUnitCount   => 2,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                },
            },

            # Custom relative notification 0 minutes after start.
            {
                Data => {
                    Description                           => 'Custom relative 0 minutes after start',
                    NotificationTemplate                  => 'Custom',
                    NotificationCustomRelativeInput       => 1,
                    NotificationCustomDateTimeInput       => 0,
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'afterstart',
                    UserID                                => $UserID,
                },
                Result => {
                    NotificationTemplate                  => 'Custom',
                    NotificationCustom                    => 'relative',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'afterstart',
                },
            },

            # Custom relative notification 0 minutes before end.
            {
                Data => {
                    Description                           => 'Custom relative 0 minutes before end',
                    NotificationTemplate                  => 'Custom',
                    NotificationCustomRelativeInput       => 1,
                    NotificationCustomDateTimeInput       => 0,
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforeend',
                    UserID                                => $UserID,
                },
                Result => {
                    NotificationTemplate                  => 'Custom',
                    NotificationCustom                    => 'relative',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforeend',
                },
            },

            # Custom relative notification 0 minutes after end.
            {
                Data => {
                    Description                           => 'Custom relative 0 minutes after end',
                    NotificationTemplate                  => 'Custom',
                    NotificationCustomRelativeInput       => 1,
                    NotificationCustomDateTimeInput       => 0,
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'afterend',
                    UserID                                => $UserID,
                },
                Result => {
                    NotificationTemplate                  => 'Custom',
                    NotificationCustom                    => 'relative',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'afterend',
                },
            },
        );

        # Notification custom relative template test execution.
        for my $Test (@TemplateCustomRelativeCreateTests) {

            # Create appointment.
            $Selenium->find_elements("//td[contains(\@data-date,'$DataDate')]")->[1]->click();

            # Wait until form and overlay has loaded, if neccessary.
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );

            # Enter some data.
            $Selenium->find_element( '#Title', 'css' )->send_keys("$Test->{Data}->{Description}");
            $Selenium->InputFieldValueSet(
                Element => '#CalendarID',
                Value   => $Calendar1{CalendarID},
            );

            # Select custom template.
            $Selenium->InputFieldValueSet(
                Element => '#NotificationTemplate',
                Value   => $Test->{Data}->{NotificationTemplate},
            );

            # Activate the relative notifications.
            $Selenium->find_element( "#NotificationCustomRelativeInput", 'css' )->click();

            # Fill out the custom unit count field.
            $Selenium->execute_script(
                "\$('#NotificationCustomRelativeUnitCount').val('$Test->{Data}->{NotificationCustomRelativeUnitCount}');"
            );

            # Fill out the custom unit field.
            $Selenium->InputFieldValueSet(
                Element => '#NotificationCustomRelativeUnit',
                Value   => $Test->{Data}->{NotificationCustomRelativeUnit},
            );

            # Fill out the custom unit point of time field.
            $Selenium->InputFieldValueSet(
                Element => '#NotificationCustomRelativePointOfTime',
                Value   => $Test->{Data}->{NotificationCustomRelativePointOfTime},
            );

            # Click on Save.
            $Selenium->find_element( '#EditFormSubmit', 'css' )->click();

            # Wait for dialog to close and AJAX to finish.
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
            );

            my @AppointmentList = $AppointmentObject->AppointmentList(
                CalendarID => $Calendar1{CalendarID},
                Result     => 'HASH',
            );

            # Make sure there is an appointment.
            $Self->Is(
                scalar @AppointmentList,
                1,
                "Appointment list verification - $Test->{Data}->{Description} ."
            );

            # Get the needed notification params.
            my $CustomUnitCount = $Test->{Data}->{NotificationCustomRelativeUnitCount};

            # The backend treats negative values as 0.
            if ( $CustomUnitCount < 0 ) {
                $CustomUnitCount = 0;
            }

            my $CustomUnit      = $Test->{Data}->{NotificationCustomRelativeUnit};
            my $CustomUnitPoint = $Test->{Data}->{NotificationCustomRelativePointOfTime};

            # Setup the count to compute for the offset.
            my %UnitOffsetCompute = (
                minutes => 60,
                hours   => 3600,
                days    => 86400,
            );

            my $NotificationLocalTimeObject;

            # Compute from start time.
            if ( $CustomUnitPoint eq 'beforestart' || $CustomUnitPoint eq 'afterstart' ) {
                $NotificationLocalTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $AppointmentList[0]->{StartTime},
                    },
                );
            }

            # Compute from end time.
            elsif ( $CustomUnitPoint eq 'beforeend' || $CustomUnitPoint eq 'afterend' ) {
                $NotificationLocalTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $AppointmentList[0]->{EndTime},
                    },
                );
            }

            # Compute the offset to be used.
            my $Offset = ( $CustomUnitCount * $UnitOffsetCompute{$CustomUnit} );

            if ( $CustomUnitPoint eq 'beforestart' || $CustomUnitPoint eq 'beforeend' ) {
                $NotificationLocalTimeObject->Subtract(
                    Seconds => $Offset,
                );
            }
            else {
                $NotificationLocalTimeObject->Add(
                    Seconds => $Offset,
                );
            }

            $Self->Is(
                $AppointmentList[0]->{NotificationDate},
                $NotificationLocalTimeObject->ToString(),
                "Verify notification date - $Test->{Data}->{Description}"
            );

            my $Delete = $AppointmentObject->AppointmentDelete(
                AppointmentID => $AppointmentList[0]->{AppointmentID},
                UserID        => $UserID,
            );

            # Delete appointment.
            $Self->True(
                $Delete,
                "Delete appointment verification - $Test->{Data}->{Description}",
            );
        }

        # Custom DateTime Templates.

        # Define appointment test with custom notification templates.
        my @TemplateCustomDateTimeCreateTests = (

            # Custom datetime notification $YearBeforeLast-09-01 10:10:00.
            {
                Data => {
                    Description                     => "Custom datetime $YearBeforeLastSettings->{Year}-09-01 10:10:00",
                    NotificationTemplate            => 'Custom',
                    NotificationCustomRelativeInput => 0,
                    NotificationCustomDateTimeInput => 1,
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    DateTimeDay                           => '1',
                    DateTimeMonth                         => '9',
                    DateTimeYear                          => $YearBeforeLastSettings->{Year},
                    DateTimeHour                          => '10',
                    DateTimeMinute                        => '10',
                    UserID                                => $UserID,
                },
                Result => {
                    NotificationDate                      => "$YearBeforeLastSettings->{Year}-09-01 10:10:00",
                    NotificationTemplate                  => 'Custom',
                    NotificationCustom                    => 'datetime',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    NotificationCustomDateTime            => "$YearBeforeLastSettings->{Year}-09-01 10:10:00",
                },
            },

            # Custom datetime notification $YearBeforeLast-10-18 00:03:00.
            {
                Data => {
                    Description                     => "Custom datetime $YearBeforeLastSettings->{Year}-10-18 01:03:00",
                    NotificationTemplate            => 'Custom',
                    NotificationCustomRelativeInput => 0,
                    NotificationCustomDateTimeInput => 1,
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    DateTimeDay                           => '18',
                    DateTimeMonth                         => '10',
                    DateTimeYear                          => $YearBeforeLastSettings->{Year},
                    DateTimeHour                          => '1',
                    DateTimeMinute                        => '3',
                    UserID                                => $UserID,
                },
                Result => {
                    NotificationDate                      => "$YearBeforeLastSettings->{Year}-10-18 01:03:00",
                    NotificationTemplate                  => 'Custom',
                    NotificationCustom                    => 'datetime',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    NotificationCustomDateTime            => "$YearBeforeLastSettings->{Year}-10-18 01:03:00",
                },
            },

            # Custom datetime notification $LastYear-10-18 00:03:00.
            {
                Data => {
                    Description                           => "Custom datetime $LastYearSettings->{Year}-10-18 03:03:00",
                    NotificationTemplate                  => 'Custom',
                    NotificationCustomRelativeInput       => 0,
                    NotificationCustomDateTimeInput       => 1,
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    DateTimeDay                           => '18',
                    DateTimeMonth                         => '10',
                    DateTimeYear                          => $LastYearSettings->{Year},
                    DateTimeHour                          => '3',
                    DateTimeMinute                        => '3',
                    UserID                                => $UserID,
                },
                Result => {
                    NotificationDate                      => "$LastYearSettings->{Year}-10-18 03:03:00",
                    NotificationTemplate                  => 'Custom',
                    NotificationCustom                    => 'datetime',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    NotificationCustomDateTime            => "$LastYearSettings->{Year}-10-18 03:03:00",
                },
            },

            # Custom datetime notification $YearBeforeLast-10-18 02:03:00.
            {
                Data => {
                    Description                     => "Custom datetime $YearBeforeLastSettings->{Year}-10-18 02:03:00",
                    NotificationTemplate            => 'Custom',
                    NotificationCustomRelativeInput => 0,
                    NotificationCustomDateTimeInput => 1,
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    DateTimeDay                           => '18',
                    DateTimeMonth                         => '10',
                    DateTimeYear                          => $YearBeforeLastSettings->{Year},
                    DateTimeHour                          => '2',
                    DateTimeMinute                        => '3',
                    UserID                                => $UserID,
                },
                Result => {
                    NotificationDate                      => "$YearBeforeLastSettings->{Year}-10-18 02:03:00",
                    NotificationTemplate                  => 'Custom',
                    NotificationCustom                    => 'datetime',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    NotificationCustomDateTime            => "$YearBeforeLastSettings->{Year}-10-18 02:03:00",
                },
            },
        );

        # Notification datetime template test execution.
        for my $Test (@TemplateCustomDateTimeCreateTests) {

            # Create appointment.
            $Selenium->find_elements("//td[contains(\@data-date,'$DataDate')]")->[1]->click();

            # Wait until form and overlay has loaded, if neccessary.
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length;" );

            # Enter some data.
            $Selenium->find_element( '#Title', 'css' )->send_keys("$Test->{Data}->{Description}");
            $Selenium->InputFieldValueSet(
                Element => '#CalendarID',
                Value   => $Calendar1{CalendarID},
            );

            # Select custom template.
            $Selenium->InputFieldValueSet(
                Element => '#NotificationTemplate',
                Value   => $Test->{Data}->{NotificationTemplate},
            );

            # Activate the relative notifications.
            $Selenium->find_element( "#NotificationCustomDateTimeInput", 'css' )->click();
            $Selenium->WaitFor( JavaScript => "return \$('#NotificationCustomDateTimeInput:checked').length;" );

            # Select day.
            $Selenium->InputFieldValueSet(
                Element => '#NotificationCustomDateTimeDay',
                Value   => $Test->{Data}->{DateTimeDay},
            );

            # Select month.
            $Selenium->InputFieldValueSet(
                Element => '#NotificationCustomDateTimeMonth',
                Value   => $Test->{Data}->{DateTimeMonth},
            );

            # Select year.
            $Selenium->InputFieldValueSet(
                Element => '#NotificationCustomDateTimeYear',
                Value   => $Test->{Data}->{DateTimeYear},
            );

            # Select hour.
            $Selenium->InputFieldValueSet(
                Element => '#NotificationCustomDateTimeHour',
                Value   => $Test->{Data}->{DateTimeHour},
            );

            # Select minute.
            $Selenium->InputFieldValueSet(
                Element => '#NotificationCustomDateTimeMinute',
                Value   => $Test->{Data}->{DateTimeMinute},
            );

            # Click on Save.
            $Selenium->find_element( '#EditFormSubmit', 'css' )->click();

            # Wait for dialog to close and AJAX to finish.
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length;'
            );

            my @AppointmentList = $AppointmentObject->AppointmentList(
                CalendarID => $Calendar1{CalendarID},
                Result     => 'HASH',
            );

            # Make sure there is an appointment.
            $Self->Is(
                scalar @AppointmentList,
                1,
                "Appointment list verification - $Test->{Data}->{Description} ."
            );

            # Verify results.
            for my $ResultKey ( sort keys %{ $Test->{Result} } ) {

                $Self->Is(
                    $AppointmentList[0]->{$ResultKey},
                    $Test->{Result}->{$ResultKey},
                    'Notification appointment result: ' . $ResultKey . ' - ' . $Test->{Data}->{Description},
                );
            }

            # Delete appointment.
            my $Delete = $AppointmentObject->AppointmentDelete(
                AppointmentID => $AppointmentList[0]->{AppointmentID},
                UserID        => $UserID,
            );

            $Self->True(
                $Delete,
                "Delete appointment verification - $Test->{Data}->{Description} .",
            );
        }
    },
);

1;
