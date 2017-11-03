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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
        my $GroupObject       = $Kernel::OM->Get('Kernel::System::Group');
        my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');
        my $UserObject        = $Kernel::OM->Get('Kernel::System::User');

        my $RandomID = $Helper->GetRandomID();

        # create test group
        my $GroupName = "test-calendar-group-$RandomID";
        my $GroupID   = $GroupObject->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        my $NextMonthObject = $Kernel::OM->Create('Kernel::System::DateTime');
        $NextMonthObject->Add(
            Months => 1,
        );
        my $NextMonthSettings = $NextMonthObject->Get();

        # change resolution (desktop mode)
        $Selenium->set_window_size( 768, 1050 );

        # create test user
        my $Language      = 'en';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'users', $GroupName ],
            Language => $Language,
        ) || die "Did not get test user";

        # get UserID
        my $UserID = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # start test
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # create a few test calendars
        my %Calendar1 = $CalendarObject->CalendarCreate(
            CalendarName => "My Calendar $RandomID",
            Color        => '#3A87AD',
            GroupID      => $GroupID,
            UserID       => $UserID,
            ValidID      => 1,
        );

        # go to calendar overview page
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentCalendarOverview");

        # wait for AJAX to finish
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length' );

        # click on the month view
        $Selenium->find_element( '.fc-month-button', 'css' )->VerifiedClick();

        # wait for AJAX to finish
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length' );

        # go to next month
        $Selenium->find_element( '.fc-toolbar .fc-next-button', 'css' )->VerifiedClick();

        # wait for AJAX to finish
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".CalendarWidget.Loading").length' );

        my $DataDate = sprintf( "%04d-%02d-01", $NextMonthSettings->{Year}, $NextMonthSettings->{Month} );

        #
        # Pre-Defined Templates
        #

        # define appointment test with pre-defined notification templates
        my @TemplateCreateTests = (

            # no active notification template
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

            # notification template start (appointment start time)
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

            # notification template 5 minutes before
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

            # notification template 15 minutes before
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

            # notification template 30 minutes before
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

            # notification template 1 hour before
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

            # notification template 2 hours before
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

            # notification template 12 hours before
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

            # notification template 1 day before
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

            # notification template 2 days before
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

            # notification template 1 week before
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

        # notification pre-defined template test execution
        for my $Test (@TemplateCreateTests) {

            # create appointment
            $Selenium->find_element( ".fc-widget-content td[data-date=\"$DataDate\"]", 'css' )->VerifiedClick();

            # wait until form and overlay has loaded, if neccessary
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );

            # enter some data
            $Selenium->find_element( 'Title', 'name' )->send_keys("$Test->{Data}->{Description}");
            $Selenium->execute_script(
                "\$('#CalendarID').val("
                    . $Calendar1{CalendarID}
                    . ").trigger('redraw.InputField').trigger('change');"
            );

            $Selenium->execute_script(
                "\$('#NotificationTemplate').val('$Test->{Data}->{NotificationTemplate}').trigger('redraw.InputField').trigger('change');"
            );

            # click on Save
            $Selenium->find_element( '#EditFormSubmit', 'css' )->VerifiedClick();

            # wait for dialog to close and AJAX to finish
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length'
            );

            my @AppointmentList = $AppointmentObject->AppointmentList(
                CalendarID => $Calendar1{CalendarID},
                Result     => 'HASH',
            );

            # make sure there is an appointment
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

            # verify results
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

            # delete appointment
            $Self->True(
                $Delete,
                "Delete appointment verification - $Test->{Data}->{Description} .",
            );
        }

        #
        # Custom Relative Templates
        #

        # define appointment test with custom notification templates
        my @TemplateCustomRelativeCreateTests = (

            # custom relative notification 0 minutes before start
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

            # custom relative notification -2 minutes before start
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

            # custom relative notification 2 minutes before start
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

            # custom relative notification 0 minutes after start
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

            # custom relative notification 0 minutes before end
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

            # custom relative notification 0 minutes after end
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

        # notification custom relative template test execution
        for my $Test (@TemplateCustomRelativeCreateTests) {

            # create appointment
            $Selenium->find_element( ".fc-widget-content td[data-date=\"$DataDate\"]", 'css' )->VerifiedClick();

            # wait until form and overlay has loaded, if neccessary
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );

            # enter some data
            $Selenium->find_element( 'Title', 'name' )->send_keys("$Test->{Data}->{Description}");
            $Selenium->execute_script(
                "\$('#CalendarID').val("
                    . $Calendar1{CalendarID}
                    . ").trigger('redraw.InputField').trigger('change');"
            );

            # select custom template
            $Selenium->execute_script(
                "\$('#NotificationTemplate').val('$Test->{Data}->{NotificationTemplate}').trigger('redraw.InputField').trigger('change');"
            );

            # activate the relative notifications
            $Selenium->find_element( "#NotificationCustomRelativeInput", 'css' )->VerifiedClick();

            # fill out the custom unit count field
            $Selenium->execute_script(
                "return \$('#NotificationCustomRelativeUnitCount').val('$Test->{Data}->{NotificationCustomRelativeUnitCount}');"
            );

            # fill out the custom unit field
            $Selenium->execute_script(
                "\$('#NotificationCustomRelativeUnit').val('$Test->{Data}->{NotificationCustomRelativeUnit}').trigger('redraw.InputField').trigger('change');"
            );

            # fill out the custom unit point of time field
            $Selenium->execute_script(
                "\$('#NotificationCustomRelativePointOfTime').val('$Test->{Data}->{NotificationCustomRelativePointOfTime}').trigger('redraw.InputField').trigger('change');"
            );

            # click on Save
            $Selenium->find_element( '#EditFormSubmit', 'css' )->VerifiedClick();

            # wait for dialog to close and AJAX to finish
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length'
            );

            my @AppointmentList = $AppointmentObject->AppointmentList(
                CalendarID => $Calendar1{CalendarID},
                Result     => 'HASH',
            );

            # make sure there is an appointment
            $Self->Is(
                scalar @AppointmentList,
                1,
                "Appointment list verification - $Test->{Data}->{Description} ."
            );

            # get the needed notification params
            my $CustomUnitCount = $Test->{Data}->{NotificationCustomRelativeUnitCount};

            # the backend treats negative values as 0
            if ( $CustomUnitCount < 0 ) {
                $CustomUnitCount = 0;
            }

            my $CustomUnit      = $Test->{Data}->{NotificationCustomRelativeUnit};
            my $CustomUnitPoint = $Test->{Data}->{NotificationCustomRelativePointOfTime};

            # setup the count to compute for the offset
            my %UnitOffsetCompute = (
                minutes => 60,
                hours   => 3600,
                days    => 86400,
            );

            my $NotificationLocalTimeObject;

            # compute from start time
            if ( $CustomUnitPoint eq 'beforestart' || $CustomUnitPoint eq 'afterstart' ) {
                $NotificationLocalTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $AppointmentList[0]->{StartTime},
                    },
                );
            }

            # compute from end time
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

            # delete appointment
            $Self->True(
                $Delete,
                "Delete appointment verification - $Test->{Data}->{Description}",
            );
        }

        #
        # Custom DateTime Templates
        #

        # define appointment test with custom notification templates
        my @TemplateCustomDateTimeCreateTests = (

            # custom datetime notification 2016-09-01 10:10:00
            {
                Data => {
                    Description                           => 'Custom datetime 2016-09-01 10:10:00',
                    NotificationTemplate                  => 'Custom',
                    NotificationCustomRelativeInput       => 0,
                    NotificationCustomDateTimeInput       => 1,
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    DateTimeDay                           => '1',
                    DateTimeMonth                         => '9',
                    DateTimeYear                          => '2016',
                    DateTimeHour                          => '10',
                    DateTimeMinute                        => '10',
                    UserID                                => $UserID,
                },
                Result => {
                    NotificationDate                      => '2016-09-01 10:10:00',
                    NotificationTemplate                  => 'Custom',
                    NotificationCustom                    => 'datetime',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    NotificationCustomDateTime            => '2016-09-01 10:10:00'
                },
            },

            # custom datetime notification 2016-10-18 00:03:00
            {
                Data => {
                    Description                           => 'Custom datetime 2016-10-18 01:03:00',
                    NotificationTemplate                  => 'Custom',
                    NotificationCustomRelativeInput       => 0,
                    NotificationCustomDateTimeInput       => 1,
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    DateTimeDay                           => '18',
                    DateTimeMonth                         => '10',
                    DateTimeYear                          => '2016',
                    DateTimeHour                          => '1',
                    DateTimeMinute                        => '3',
                    UserID                                => $UserID,
                },
                Result => {
                    NotificationDate                      => '2016-10-18 01:03:00',
                    NotificationTemplate                  => 'Custom',
                    NotificationCustom                    => 'datetime',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    NotificationCustomDateTime            => '2016-10-18 01:03:00'
                },
            },

            # custom datetime notification 2017-10-18 00:03:00
            {
                Data => {
                    Description                           => 'Custom datetime 2017-10-18 03:03:00',
                    NotificationTemplate                  => 'Custom',
                    NotificationCustomRelativeInput       => 0,
                    NotificationCustomDateTimeInput       => 1,
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    DateTimeDay                           => '18',
                    DateTimeMonth                         => '10',
                    DateTimeYear                          => '2017',
                    DateTimeHour                          => '3',
                    DateTimeMinute                        => '3',
                    UserID                                => $UserID,
                },
                Result => {
                    NotificationDate                      => '2017-10-18 03:03:00',
                    NotificationTemplate                  => 'Custom',
                    NotificationCustom                    => 'datetime',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    NotificationCustomDateTime            => '2017-10-18 03:03:00'
                },
            },

            # custom datetime notification 2012-10-18 00:03:00
            {
                Data => {
                    Description                           => 'Custom datetime 2012-10-18 02:03:00',
                    NotificationTemplate                  => 'Custom',
                    NotificationCustomRelativeInput       => 0,
                    NotificationCustomDateTimeInput       => 1,
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    DateTimeDay                           => '18',
                    DateTimeMonth                         => '10',
                    DateTimeYear                          => '2012',
                    DateTimeHour                          => '2',
                    DateTimeMinute                        => '3',
                    UserID                                => $UserID,
                },
                Result => {
                    NotificationDate                      => '2012-10-18 02:03:00',
                    NotificationTemplate                  => 'Custom',
                    NotificationCustom                    => 'datetime',
                    NotificationCustomRelativeUnitCount   => 0,
                    NotificationCustomRelativeUnit        => 'minutes',
                    NotificationCustomRelativePointOfTime => 'beforestart',
                    NotificationCustomDateTime            => '2012-10-18 02:03:00'
                },
            },
        );

        # notification datetime template test execution
        for my $Test (@TemplateCustomDateTimeCreateTests) {

            # create appointment
            $Selenium->find_element( ".fc-widget-content td[data-date=\"$DataDate\"]", 'css' )->VerifiedClick();

            # wait until form and overlay has loaded, if neccessary
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );

            # enter some data
            $Selenium->find_element( 'Title', 'name' )->send_keys("$Test->{Data}->{Description}");
            $Selenium->execute_script(
                "\$('#CalendarID').val("
                    . $Calendar1{CalendarID}
                    . ").trigger('redraw.InputField').trigger('change');"
            );

            # select custom template
            $Selenium->execute_script(
                "\$('#NotificationTemplate').val('$Test->{Data}->{NotificationTemplate}').trigger('redraw.InputField').trigger('change');"
            );

            # activate the relative notifications
            $Selenium->find_element( "#NotificationCustomDateTimeInput", 'css' )->VerifiedClick();

            # select day
            $Selenium->execute_script(
                "\$('#NotificationCustomDateTimeDay').val('$Test->{Data}->{DateTimeDay}').trigger('redraw.InputField').trigger('change');"
            );

            # select month
            $Selenium->execute_script(
                "\$('#NotificationCustomDateTimeMonth').val('$Test->{Data}->{DateTimeMonth}').trigger('redraw.InputField').trigger('change');"
            );

            # select year
            $Selenium->execute_script(
                "\$('#NotificationCustomDateTimeYear').val('$Test->{Data}->{DateTimeYear}').trigger('redraw.InputField').trigger('change');"
            );

            # select hour
            $Selenium->execute_script(
                "\$('#NotificationCustomDateTimeHour').val('$Test->{Data}->{DateTimeHour}').trigger('redraw.InputField').trigger('change');"
            );

            # select minute
            $Selenium->execute_script(
                "\$('#NotificationCustomDateTimeMinute').val('$Test->{Data}->{DateTimeMinute}').trigger('redraw.InputField').trigger('change');"
            );

            # click on Save
            $Selenium->find_element( '#EditFormSubmit', 'css' )->VerifiedClick();

            # wait for dialog to close and AJAX to finish
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && !$(".Dialog:visible").length && !$(".CalendarWidget.Loading").length'
            );

            my @AppointmentList = $AppointmentObject->AppointmentList(
                CalendarID => $Calendar1{CalendarID},
                Result     => 'HASH',
            );

            # make sure there is an appointment
            $Self->Is(
                scalar @AppointmentList,
                1,
                "Appointment list verification - $Test->{Data}->{Description} ."
            );

            # verify results
            for my $ResultKey ( sort keys %{ $Test->{Result} } ) {

                $Self->Is(
                    $AppointmentList[0]->{$ResultKey},
                    $Test->{Result}->{$ResultKey},
                    'Notification appointment result: ' . $ResultKey . ' - ' . $Test->{Data}->{Description},
                );
            }

            # delete appointment
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
