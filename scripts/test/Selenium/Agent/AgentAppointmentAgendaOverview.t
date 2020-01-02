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

        my $Helper         = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
        my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');

        my $RandomID = $Helper->GetRandomID();

        # Create test group.
        my $GroupName = "test-calendar-group-$RandomID";
        my $GroupID   = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

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
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendars[0]->{CalendarID},
        );

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && !\$('.Dialog.Modal').length" );
        $Selenium->VerifiedRefresh();

        # Verify the regular appointment is visible.
        $Self->True(
            $Selenium->execute_script("return \$('tbody tr:contains($AppointmentNames[0])').length;"),
            "First appointment '$AppointmentNames[0]' found in the table"
        );

        # Create all-day appointment.
        $Selenium->find_element( '#AppointmentCreateButton', 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Title').length" );
        $Selenium->find_element( 'Title',  'name' )->send_keys( $AppointmentNames[1] );
        $Selenium->find_element( 'AllDay', 'name' )->click();
        $Selenium->WaitFor( JavaScript => "return \$('input[name=AllDay]:checked').length" );
        for my $Group (qw(Start End)) {
            for my $Field (qw(Day Month Year)) {
                $Selenium->execute_script(
                    "\$('#$Group$Field').val($StartTime{$Field});"
                );
            }
        }
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendars[1]->{CalendarID},
        );

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && !\$('.Dialog.Modal').length" );
        $Selenium->VerifiedRefresh();

        # Verify the all-day appointment is visible.
        $Self->True(
            $Selenium->execute_script("return \$('tbody tr:contains($AppointmentNames[1])').length;"),
            "Second appointment '$AppointmentNames[1]' found in the table"
        );

        my $RecurrenceCount = 3;

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
        $Selenium->InputFieldValueSet(
            Element => '#CalendarID',
            Value   => $Calendars[2]->{CalendarID},
        );
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceType',
            Value   => 'Daily',
        );
        $Selenium->InputFieldValueSet(
            Element => '#RecurrenceLimit',
            Value   => '2',
        );
        $Selenium->find_element( 'RecurrenceCount', 'name' )->send_keys($RecurrenceCount);

        # Click on Save.
        $Selenium->find_element( '#EditFormSubmit', 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && !\$('.Dialog.Modal').length" );
        $Selenium->VerifiedRefresh();

        # Verify all third appointment occurrences are visible.
        $Self->True(
            $Selenium->execute_script(
                "return \$('tbody tr:contains($AppointmentNames[2])').length === $RecurrenceCount;"
            ),
            "All third appointment occurrences found in the table"
        );

        # Delete third appointment master.
        $Selenium->find_element( $AppointmentNames[2], 'link_text' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.Dialog.Modal #EditFormDelete').length"
        );
        sleep 2;
        $Selenium->find_element( "#EditFormDelete", 'css' )->click();

        $Selenium->WaitFor( AlertPresent => 1 );
        $Selenium->accept_alert();
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' &&  \$('tbody tr:contains($AppointmentNames[2])').length === 0;"
        );

        # Verify all third appointment occurences have been removed.
        $Self->False(
            $Selenium->execute_script("return \$('tbody tr:contains($AppointmentNames[2])').length;"),
            "All third appointment occurences deleted"
        );
    },
);

1;
