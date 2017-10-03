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

        my $Helper         = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
        my $GroupObject    = $Kernel::OM->Get('Kernel::System::Group');
        my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');
        my $UserObject     = $Kernel::OM->Get('Kernel::System::User');

        my $RandomID = $Helper->GetRandomID();

        # Create test group.
        my $GroupName = "test-calendar-group-$RandomID";
        my $GroupID   = $GroupObject->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );

        # Get script alias.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

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

        # Create test customer user.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate() || die "Did not get test customer user";

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Create a few test calendars.
        my @Calendars;
        my $Count = 1;
        for my $Color ( '#3A87AD', '#EC9073', '#6BAD54' ) {
            my %Calendar = $CalendarObject->CalendarCreate(
                CalendarName => "Calendar$Count-$RandomID",
                Color        => $Color,
                GroupID      => $GroupID,
                UserID       => $UserID,
                ValidID      => 1,
            );
            push @Calendars, \%Calendar;

            $Count++;
        }

        my $CalendarWeekDayStart = $ConfigObject->Get('CalendarWeekDayStart') || 7;

        # Get start of the week.
        my $StartTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        while ( $StartTimeObject->Get()->{DayOfWeek} != $CalendarWeekDayStart ) {
            $StartTimeObject->Subtract(
                Days => 1,
            );
        }
        my $StartTimeSettings = $StartTimeObject->Get();

        # Appointment times will always be the same at the start of the week.
        my %StartTime = (
            Day    => $StartTimeSettings->{Day},
            Month  => $StartTimeSettings->{Month},
            Year   => $StartTimeSettings->{Year},
            Hour   => 12,
            Minute => 15,
        );

        # Define appointment names.
        my @AppointmentNames = ( 'Appointment 1', 'Appointment 2', 'Appointment 3' );

        # Go to agenda overview page.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentAppointmentAgendaOverview");

        # Create a regular appointment.
        $Selenium->find_element( '#AppointmentCreateButton', 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );
        $Selenium->find_element( 'Title', 'name' )->send_keys( $AppointmentNames[0] );
        for my $Group (qw(Start End)) {
            for my $Field (qw(Hour Minute Day Month Year)) {
                $Selenium->execute_script(
                    "\$('#$Group$Field').val($StartTime{$Field});"
                );
            }
        }
        $Selenium->execute_script(
            "\$('#CalendarID').val("
                . $Calendars[0]->{CalendarID}
                . ").trigger('redraw.InputField').trigger('change');"
        );

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && !\$('.Dialog.Modal').length" );
        $Selenium->VerifiedRefresh();

        # Verify the regular appointment is visible.
        $Self->True(
            index( $Selenium->get_page_source(), $AppointmentNames[0] ) > -1,
            'First appointment visible',
        );

        # Create all-day appointment.
        $Selenium->find_element( '#AppointmentCreateButton', 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );
        $Selenium->find_element( 'Title',  'name' )->send_keys( $AppointmentNames[1] );
        $Selenium->find_element( 'AllDay', 'name' )->VerifiedClick();
        for my $Group (qw(Start End)) {
            for my $Field (qw(Day Month Year)) {
                $Selenium->execute_script(
                    "\$('#$Group$Field').val($StartTime{$Field});"
                );
            }
        }
        $Selenium->execute_script(
            "\$('#CalendarID').val("
                . $Calendars[1]->{CalendarID}
                . ").trigger('redraw.InputField').trigger('change');"
        );

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && !\$('.Dialog.Modal').length" );
        $Selenium->VerifiedRefresh();

        # Verify the all-day appointment is visible.
        $Self->True(
            index( $Selenium->get_page_source(), $AppointmentNames[1] ) > -1,
            'Second appointment visible',
        );

        # Create recurring appointment.
        $Selenium->find_element( '#AppointmentCreateButton', 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );
        $Selenium->find_element( 'Title', 'name' )->send_keys( $AppointmentNames[2] );
        for my $Group (qw(Start End)) {
            for my $Field (qw(Hour Minute Day Month Year)) {
                $Selenium->execute_script(
                    "\$('#$Group$Field').val($StartTime{$Field});"
                );
            }
        }
        $Selenium->execute_script(
            "\$('#CalendarID').val("
                . $Calendars[2]->{CalendarID}
                . ").trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->execute_script(
            "\$('#RecurrenceType').val('Daily').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->execute_script(
            "\$('#RecurrenceLimit').val('2').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( 'RecurrenceCount', 'name' )->send_keys('3');

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && !\$('.Dialog.Modal').length" );
        $Selenium->VerifiedRefresh();

        # Verify the first occurrence of the third appointment is visible.
        $Self->True(
            index( $Selenium->get_page_source(), $AppointmentNames[2] ) > -1,
            'Third appointment visible',
        );

        # Delete third appointment master.
        $Selenium->find_element( $AppointmentNames[2], 'link_text' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );

        $Selenium->execute_script('$("#EditFormDelete").click();');

        $Selenium->accept_alert();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && !\$('.OverviewControl.Loading').length"
        );

        # Verify all third appointment occurences have been removed.
        $Self->True(
            index( $Selenium->get_page_source(), $AppointmentNames[2] ) == -1,
            'All third appointment occurrences removed',
        );
    },
);

1;
