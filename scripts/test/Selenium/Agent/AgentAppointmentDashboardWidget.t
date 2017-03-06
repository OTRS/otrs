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
        my $Helper            = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $GroupObject       = $Kernel::OM->Get('Kernel::System::Group');
        my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');
        my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');

        # dashboard widget config key
        my $DashboardConfigKey = '0500-AppointmentCalendar';

        # turn on dashboard widget by default
        my $DashboardConfig = $Kernel::OM->Get('Kernel::Config')->Get('DashboardBackend')->{$DashboardConfigKey};
        $DashboardConfig->{Default} = 1;
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => "DashboardBackend###$DashboardConfigKey",
            Value => $DashboardConfig,
        );

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
            "Created test group - $GroupID",
        );

        # create test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [$GroupName],
        ) || die 'Did not get test user';
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup( UserLogin => $TestUserLogin );
        $Self->True(
            $UserID,
            "Created test user - $UserID",
        );

        # create a test calendar
        my %Calendar = $CalendarObject->CalendarCreate(
            CalendarName => "Calendar $RandomID",
            Color        => '#3A87AD',
            GroupID      => $GroupID,
            UserID       => $UserID,
            ValidID      => 1,
        );
        $Self->True(
            $Calendar{CalendarID},
            "Created test calendar - $Calendar{CalendarID}",
        );

        # Get current time.
        my $StartTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

        # Just before midnight today.
        my $TodayTimeObject = $StartTimeObject->Clone();
        $TodayTimeObject->Set(
            Hour   => 23,
            Minute => 59,
            Second => 59,
        );

        my $TomorrowTimeObject = $StartTimeObject->Clone();
        $TomorrowTimeObject->Add(
            Days => 1,
        );

        my $DayAfterTomorrowTimeObject = $StartTimeObject->Clone();
        $DayAfterTomorrowTimeObject->Add(
            Days => 2,
        );

        my $TwoDaysAfterTomorrowTimeObject = $StartTimeObject->Clone();
        $TwoDaysAfterTomorrowTimeObject->Add(
            Days => 3,
        );

        # Sample appointments.
        my @Appointments = (

            # Today.
            {
                CalendarID => $Calendar{CalendarID},
                StartTime  => $TodayTimeObject->ToString(),
                EndTime    => $TodayTimeObject->ToString(),
                Title      => "Today $RandomID",
                UserID     => $UserID,
                Filter     => 'Today',
            },

            # Tomorrow.
            {
                CalendarID => $Calendar{CalendarID},
                StartTime  => $TomorrowTimeObject->ToString(),
                EndTime    => $TomorrowTimeObject->ToString(),
                Title      => "Tomorrow $RandomID",
                UserID     => $UserID,
                Filter     => 'Tomorrow',
            },

            # Day after tomorrow.
            {
                CalendarID => $Calendar{CalendarID},
                StartTime  => $DayAfterTomorrowTimeObject->ToString(),
                EndTime    => $DayAfterTomorrowTimeObject->ToString(),
                Title      => "Day after tomorrow $RandomID",
                UserID     => $UserID,
                Filter     => 'Soon',
            },

            # Two days after tomorrow.
            {
                CalendarID => $Calendar{CalendarID},
                StartTime  => $TwoDaysAfterTomorrowTimeObject->ToString(),
                EndTime    => $TwoDaysAfterTomorrowTimeObject->ToString(),
                Title      => "Two days after tomorrow $RandomID",
                UserID     => $UserID,
                Filter     => 'Soon',
            },
        );

        # create appointments
        for my $Appointment (@Appointments) {
            my $AppointmentID = $AppointmentObject->AppointmentCreate(
                %{$Appointment},
            );
            $Self->True(
                $AppointmentID,
                "Created test appointment - $AppointmentID",
            );
            $Appointment->{AppointmentID} = $AppointmentID;
        }

        # change resolution (desktop mode)
        $Selenium->set_window_size( 768, 1050 );

        # login test user
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # verify widget is present
        my $DashboardWidget = $Selenium->find_element( "#Dashboard$DashboardConfigKey", 'css' );
        $Selenium->mouse_move_to_location(
            element => $DashboardWidget,
            xoffset => 0,
            yoffset => 0,
        );

        # check appointments
        my %FilterCount;
        for my $Appointment (@Appointments) {

            # remember filter
            $FilterCount{ $Appointment->{Filter} } += 1;

            # switch filter
            $Selenium->execute_script(
                "\$('.AppointmentFilter #Dashboard${DashboardConfigKey}$Appointment->{Filter}').trigger('click');"
            );

            sleep 2;

            # wait for AJAX
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && !\$('.WidgetSimple.Loading').length"
            );

            # verify appointment is visible
            $Selenium->find_element("//a[contains(\@href, \'AppointmentID=$Appointment->{AppointmentID}\')]");
        }

        # check filter count
        for my $Filter ( sort keys %FilterCount ) {

            # get filter link
            my $FilterLink = $Selenium->find_element( "#Dashboard${DashboardConfigKey}${Filter}", 'css' );

            $Self->Is(
                $FilterLink->get_text(),
                "$Filter ($FilterCount{$Filter})",
                "Filter count - $Filter",
            );
        }

        # cleanup

        # delete test appointments
        for my $Appointment (@Appointments) {
            my $Success = $AppointmentObject->AppointmentDelete(
                AppointmentID => $Appointment->{AppointmentID},
                UserID        => $UserID,
            );
            $Self->True(
                $Success,
                "Deleted test appointment - $Appointment->{AppointmentID}",
            );
        }

        # delete test calendar
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

        # make sure cache is correct
        for my $Cache (qw(Calendar Appointment)) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => $Cache );
        }
    },
);

1;
