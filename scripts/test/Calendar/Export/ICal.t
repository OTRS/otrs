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
use Kernel::System::VariableCheck qw(:all);

# override local time zone for duration of the test
local $ENV{TZ} = 'UTC';

# get needed objects
my $UserObject        = $Kernel::OM->Get('Kernel::System::User');
my $GroupObject       = $Kernel::OM->Get('Kernel::System::Group');
my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');
my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
my $ExportObject      = $Kernel::OM->Get('Kernel::System::Calendar::Export::ICal');
my $ImportObject      = $Kernel::OM->Get('Kernel::System::Calendar::Import::ICal');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# create test user
my ( $UserLogin, $UserID ) = $Helper->TestUserCreate();

$Self->True(
    $UserID,
    "Test user $UserID created",
);

# create test group
my $GroupName = 'test-calendar-group-' . $Helper->GetRandomID();
my $GroupID   = $GroupObject->GroupAdd(
    Name    => $GroupName,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $GroupID,
    "Test group $UserID created",
);

# add test user to test group
my $Success = $GroupObject->PermissionGroupUserAdd(
    GID        => $GroupID,
    UID        => $UserID,
    Permission => {
        ro        => 1,
        move_into => 1,
        create    => 1,
        owner     => 1,
        priority  => 1,
        rw        => 1,
    },
    UserID => 1,
);

$Self->True(
    $Success,
    "Test user $UserID added to test group $GroupID",
);

my @TeamID;
my @ResourceID;

# check if team object is registered
if ( $Kernel::OM->Get('Kernel::System::Main')->Require( 'Kernel::System::Calendar::Team', Silent => 1 ) ) {

    my $TeamObject = $Kernel::OM->Get('Kernel::System::Calendar::Team');

    # create test team
    my $TeamName = 'test-team-' . $Helper->GetRandomID();
    $Success = $TeamObject->TeamAdd(
        Name    => $TeamName,
        GroupID => $GroupID,
        ValidID => 1,
        UserID  => $UserID,
    );

    $Self->True(
        $Success,
        'TeamAdd() - Test team created',
    );

    my %Team = $TeamObject->TeamGet(
        Name   => $TeamName,
        UserID => $UserID,
    );

    $Success = $TeamObject->TeamUserAdd(
        TeamID     => $Team{ID},
        TeamUserID => $UserID,
        UserID     => $UserID,
    );

    $Self->True(
        $Success,
        'TeamUserAdd() - Added test user to test team',
    );

    push @TeamID,     $Team{ID};
    push @ResourceID, $UserID;
}

# create a test calendar for export
my $ExportCalendarName = 'Export ' . $Helper->GetRandomID();
my %ExportCalendar     = $CalendarObject->CalendarCreate(
    CalendarName => $ExportCalendarName,
    Color        => '#3A87AD',
    GroupID      => $GroupID,
    UserID       => $UserID,
);

$Self->True(
    $ExportCalendar{CalendarID},
    "CalendarCreate( CalendarName => '$ExportCalendarName', Color => '#3A87AD', GroupID => $GroupID, UserID => $UserID ) - CalendarID: $ExportCalendar{CalendarID}",
);

# sample appointments
my @Appointments = (

    # regular
    {
        CalendarID  => $ExportCalendar{CalendarID},
        StartTime   => '2016-03-01 10:00:00',
        EndTime     => '2016-03-01 12:00:00',
        Title       => 'Regular Appointment',
        Description => 'Sample description',
        UserID      => $UserID,
    },

    # all-day with resource
    {
        CalendarID => $ExportCalendar{CalendarID},
        StartTime  => '2016-03-01 00:00:00',
        EndTime    => '2016-03-02 00:00:00',
        AllDay     => 1,
        Title      => 'All-day Appointment',
        Location   => 'Sample location',
        TeamID     => \@TeamID,
        ResourceID => \@ResourceID,
        UserID     => $UserID,
    },

    # recurring daily
    {
        CalendarID      => $ExportCalendar{CalendarID},
        StartTime       => '2016-03-01 15:00:00',
        EndTime         => '2016-03-01 16:00:00',
        Recurring       => 1,
        RecurrenceType  => 'Daily',
        RecurrenceCount => 3,
        Title           => 'Recurring Daily Appointment',
        Description     => 'Every day, for 3 days',
        UserID          => $UserID,
    },

    # recurring weekly
    {
        CalendarID      => $ExportCalendar{CalendarID},
        StartTime       => '2016-03-02 15:00:00',
        EndTime         => '2016-03-02 16:00:00',
        Recurring       => 1,
        RecurrenceType  => 'Weekly',
        RecurrenceCount => 3,
        Title           => 'Recurring Weekly Appointment',
        Description     => 'Every week, for 3 weeks',
        UserID          => $UserID,
    },

    # recurring monthly
    {
        CalendarID      => $ExportCalendar{CalendarID},
        StartTime       => '2016-03-03 15:00:00',
        EndTime         => '2016-03-03 16:00:00',
        Recurring       => 1,
        RecurrenceType  => 'Monthly',
        RecurrenceCount => 3,
        Title           => 'Recurring Monthly Appointment',
        Description     => 'Every month, for 3 months',
        UserID          => $UserID,
    },

    # recurring yearly
    {
        CalendarID      => $ExportCalendar{CalendarID},
        StartTime       => '2016-03-04 15:00:00',
        EndTime         => '2016-03-04 16:00:00',
        Recurring       => 1,
        RecurrenceType  => 'Yearly',
        RecurrenceCount => 3,
        Title           => 'Recurring Yearly Appointment',
        Description     => 'Every Yearly, for 3 years',
        UserID          => $UserID,
    },

    # custom daily recurring
    {
        CalendarID         => $ExportCalendar{CalendarID},
        StartTime          => '2016-03-01 15:00:00',
        EndTime            => '2016-03-01 16:00:00',
        Recurring          => 1,
        RecurrenceType     => 'CustomDaily',
        RecurrenceInterval => 2,
        RecurrenceCount    => 3,
        Title              => 'Custom Daily Recurring Appointment',
        Description        => 'Every 2 days, 3 times',
        UserID             => $UserID,
    },

    #  custom weekly recurring
    {
        CalendarID          => $ExportCalendar{CalendarID},
        StartTime           => '2016-03-02 15:00:00',
        EndTime             => '2016-03-02 16:00:00',
        Recurring           => 1,
        RecurrenceType      => 'CustomWeekly',
        RecurrenceInterval  => 2,
        RecurrenceFrequency => [ 1, 3, 7 ],                                            # Mon, Wed, Sun
        RecurrenceCount     => 6,
        Title               => 'Custom Weekly Recurring Appointment',
        Description         => 'Every monday, wednesday and sunday, 6 appointments',
        UserID              => $UserID,
    },

    # custom monthly recurring monthly
    {
        CalendarID          => $ExportCalendar{CalendarID},
        StartTime           => '2016-03-03 15:00:00',
        EndTime             => '2016-03-03 16:00:00',
        Recurring           => 1,
        RecurrenceType      => 'CustomMonthly',
        RecurrenceInterval  => 2,
        RecurrenceFrequency => [ 1, 3, 31 ],                                      # 1st, 3th and 31st
        RecurrenceUntil     => '2017-10-01 00:00:00',
        Title               => 'Custom Monthly Recurring Appointment',
        Description         => 'Every 1st, 3th and 31st day, until 2017-10-01',
        UserID              => $UserID,
    },

    # custom yearly recurring yearly
    {
        CalendarID          => $ExportCalendar{CalendarID},
        StartTime           => '2016-03-04 15:00:00',
        EndTime             => '2016-03-04 16:00:00',
        Recurring           => 1,
        RecurrenceType      => 'CustomYearly',
        RecurrenceFrequency => [ 1, 3, 12 ],                                     # jan, mar, dec
        RecurrenceInterval  => 2,
        RecurrenceCount     => 10,
        Title               => 'Custom Yearly Recurring Appointment',
        Description         => 'Every 2 Years in Jan, Feb and Mar - 10 times',
        UserID              => $UserID,
    },
);

for my $Appointment (@Appointments) {
    my $AppointmentID = $AppointmentObject->AppointmentCreate(
        %{$Appointment},
    );

    $Self->True(
        $AppointmentID,
        "AppointmentCreate() - AppointmentID: $AppointmentID",
    );
}

# export appointments
my $ICalString = $ExportObject->Export(
    CalendarID => $ExportCalendar{CalendarID},
    UserID     => $UserID,
);

# get exported appointments
my @ExportedAppointments = $AppointmentObject->AppointmentList(
    CalendarID => $ExportCalendar{CalendarID},
    Result     => 'HASH',
);

$Self->True(
    $ICalString,
    'Export() - Calendar exported to iCal format',
);

# create a test calendar for import
my $ImportCalendarName = 'Import ' . $Helper->GetRandomID();
my %ImportCalendar     = $CalendarObject->CalendarCreate(
    CalendarName => $ImportCalendarName,
    Color        => '#EC9073',
    GroupID      => $GroupID,
    UserID       => $UserID,
);

$Self->True(
    $ImportCalendar{CalendarID},
    "CalendarCreate( CalendarName => '$ImportCalendarName', GroupID => $GroupID, UserID => $UserID ) - CalendarID: $ImportCalendar{CalendarID}",
);

# import appointments
$Success = $ImportObject->Import(
    CalendarID => $ImportCalendar{CalendarID},
    ICal       => $ICalString,
    UserID     => $UserID,
);

$Self->True(
    $Success,
    'Import() - Calendar imported from iCal format',
);

# get imported appointments
my @ImportedAppointments = $AppointmentObject->AppointmentList(
    CalendarID => $ImportCalendar{CalendarID},
    Result     => 'HASH',
);

# number of imported and exported appointments match
$Self->Is(
    scalar @ImportedAppointments,
    scalar @ExportedAppointments,
    'Imported appointment count'
);

my $Count = 1;
for my $ImportedAppointment (@ImportedAppointments) {

    # delete specific keys
    delete $ImportedAppointment->{AppointmentID};
    delete $ImportedAppointment->{CalendarID};
    delete $ImportedAppointment->{UniqueID};
    delete $ImportedAppointment->{ParentID};
    delete $ExportedAppointments[ $Count - 1 ]->{AppointmentID};
    delete $ExportedAppointments[ $Count - 1 ]->{CalendarID};
    delete $ExportedAppointments[ $Count - 1 ]->{UniqueID};
    delete $ExportedAppointments[ $Count - 1 ]->{ParentID};

    # compare imported and exported appointments
    $Self->IsDeeply(
        $ImportedAppointment,
        $ExportedAppointments[ $Count - 1 ],
        "Imported appointment $Count",
    );
    $Count++;
}

1;
