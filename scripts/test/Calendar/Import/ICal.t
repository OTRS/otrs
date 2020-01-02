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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');
my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
my $GroupObject       = $Kernel::OM->Get('Kernel::System::Group');
my $UserObject        = $Kernel::OM->Get('Kernel::System::User');

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
    $Success = $TeamObject->TeamAdd(
        Name    => 'Test Team',
        GroupID => 1,             # admin
        ValidID => 1,
        UserID  => 1,             # root
    );

    $Self->True(
        $Success,
        'TeamAdd() - Test team created',
    );

    my %Team = $TeamObject->TeamGet(
        Name   => 'Test Team',
        UserID => 1,
    );

    $Success = $TeamObject->TeamUserAdd(
        TeamID     => $Team{ID},
        TeamUserID => 1,           # root
        UserID     => 1,
    );

    $Self->True(
        $Success,
        'TeamUserAdd() - Added root user to test team',
    );

    push @TeamID,     $Team{ID};
    push @ResourceID, 1;
}

# this will be ok
my %Calendar = $CalendarObject->CalendarCreate(
    CalendarName => 'Test calendar',
    Color        => '#3A87AD',
    GroupID      => $GroupID,
    UserID       => $UserID,
);

$Self->True(
    $Calendar{CalendarID},
    "CalendarCreate( CalendarName => 'Test calendar', Color => '#3A87AD', GroupID => $GroupID, UserID => $UserID ) - CalendarID",
);

# read sample .ics file
my $Content = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
    Directory => $Kernel::OM->Get('Kernel::Config')->{Home} . '/scripts/test/sample/Calendar/',
    Filename  => 'SampleCalendar.ics',
);

$Self->True(
    ${$Content},
    '.ics string loaded',
);

my $ImportSuccess = $Kernel::OM->Get('Kernel::System::Calendar::Import::ICal')->Import(
    CalendarID => $Calendar{CalendarID},
    ICal       => ${$Content},
    UserID     => $UserID,
    UntilLimit => '2018-01-01 00:00:00',
);

$Self->True(
    $ImportSuccess,
    'Import success',
);

my @Appointments = $AppointmentObject->AppointmentList(
    CalendarID => $Calendar{CalendarID},
    Result     => 'HASH',
);

$Self->Is(
    scalar @Appointments,
    171,
    'Appointment count',
);

# this will be ok
my %CalendarCR = $CalendarObject->CalendarCreate(
    CalendarName => 'CR Test calendar',
    Color        => '#DDDDDD',
    GroupID      => $GroupID,
    UserID       => $UserID,
);

$Self->True(
    $CalendarCR{CalendarID},
    "CalendarCreate( CalendarName => 'CR Test calendar', Color => '#DDDDDD', GroupID => $GroupID, UserID => $UserID ) - CalendarID",
);

# read sample .ics file
my $ContentCR = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
    Directory => $Kernel::OM->Get('Kernel::Config')->{Home} . '/scripts/test/sample/Calendar/',
    Filename  => 'SampleCalendarCR.ics',
);

$Self->True(
    ${$ContentCR},
    '.ics string with CR line endings loaded',
);

my $ImportSuccessCR = $Kernel::OM->Get('Kernel::System::Calendar::Import::ICal')->Import(
    CalendarID => $CalendarCR{CalendarID},
    ICal       => ${$ContentCR},
    UserID     => $UserID,
    UntilLimit => '2018-01-01 00:00:00',
);

$Self->True(
    $ImportSuccessCR,
    'Import success',
);

my @AppointmentsCR = $AppointmentObject->AppointmentList(
    CalendarID => $CalendarCR{CalendarID},
    Result     => 'HASH',
);

$Self->Is(
    scalar @AppointmentsCR,
    171,
    'CR Appointment count',
);

my @Result = (
    {
        'TeamID'      => \@TeamID,
        'StartTime'   => '2016-04-05 00:00:00',
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'All day',
        'ResourceID'  => \@ResourceID,
        'EndTime'     => '2016-04-06 00:00:00',
        'Recurring'   => undef,
        'Description' => 'test all day event',
        'Location'    => undef,
        'AllDay'      => '1',
    },
    {
        'StartTime'   => '2016-04-12 09:30:00',
        'TeamID'      => [],
        'Title'       => 'Once per week',
        'CalendarID'  => $Calendar{CalendarID},
        'Description' => 'Only once per week',
        'Location'    => 'Belgrade',
        'ResourceID'  => [
            0,
        ],
        'EndTime'   => '2016-04-12 10:00:00',
        'Recurring' => '1',
        'AllDay'    => undef
    },
    {
        'StartTime'  => '2016-04-19 09:30:00',
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Once per week',
        'TeamID'     => [],
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2016-04-19 10:00:00',
        'Recurring'   => undef,
        'Description' => 'Only once per week',
        'Location'    => 'Belgrade',
        'AllDay'      => undef,
    },
    {
        'StartTime'  => '2016-04-26 09:30:00',
        'Title'      => 'Once per week',
        'CalendarID' => $Calendar{CalendarID},
        'TeamID'     => [],
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2016-04-26 10:00:00',
        'Recurring'   => undef,
        'Description' => 'Only once per week',
        'Location'    => 'Belgrade',
        'AllDay'      => undef,
    },
    {
        'StartTime'   => '2016-05-03 09:30:00',
        'TeamID'      => [],
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Once per week',
        'Description' => 'Only once per week',
        'Location'    => 'Belgrade',
        'ResourceID'  => [
            0,
        ],
        'Recurring' => undef,
        'EndTime'   => '2016-05-03 10:00:00',
        'AllDay'    => undef
    },
    {
        'AllDay'     => undef,
        'Recurring'  => undef,
        'EndTime'    => '2016-05-10 10:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => 'Belgrade',
        'Description' => 'Only once per week',
        'Title'       => 'Once per week',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
        'StartTime'   => '2016-05-10 09:30:00'
    },
    {
        'StartTime'  => '2016-05-17 09:30:00',
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Once per week',
        'TeamID'     => [],
        'EndTime'    => '2016-05-17 10:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => 'Belgrade',
        'Description' => 'Only once per week',
        'AllDay'      => undef,
    },
    {
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2016-05-24 10:00:00',
        'Recurring'   => undef,
        'Description' => 'Only once per week',
        'Location'    => 'Belgrade',
        'Title'       => 'Once per week',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
        'StartTime'   => '2016-05-24 09:30:00'
    },
    {
        'StartTime'  => '2016-05-31 09:30:00',
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Once per week',
        'TeamID'     => [],
        'EndTime'    => '2016-05-31 10:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => 'Belgrade',
        'Description' => 'Only once per week',
        'AllDay'      => undef,
    },
    {
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Once per week',
        'TeamID'     => [],
        'StartTime'  => '2016-06-07 09:30:00',
        'AllDay'     => undef,
        'EndTime'    => '2016-06-07 10:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => 'Belgrade',
        'Description' => 'Only once per week'
    },
    {
        'AllDay'      => undef,
        'Description' => 'Once per month',
        'Location'    => 'Germany',
        'ResourceID'  => [
            0,
        ],
        'Recurring'  => '1',
        'EndTime'    => '2016-04-12 12:00:00',
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Monthly meeting',
        'StartTime'  => '2016-04-12 11:15:00',
    },
    {
        'StartTime'   => '2016-05-12 11:15:00',
        'TeamID'      => [],
        'Title'       => 'Monthly meeting',
        'CalendarID'  => $Calendar{CalendarID},
        'Location'    => 'Germany',
        'Description' => 'Once per month',
        'Recurring'   => undef,
        'EndTime'     => '2016-05-12 12:00:00',
        'ResourceID'  => [
            0,
        ],
        'AllDay' => undef
    },
    {
        'Title'      => 'Monthly meeting',
        'CalendarID' => $Calendar{CalendarID},
        'TeamID'     => [],
        'StartTime'  => '2016-06-12 11:15:00',
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2016-06-12 12:00:00',
        'Recurring'   => undef,
        'Description' => 'Once per month',
        'Location'    => 'Germany'
    },
    {
        'Title'      => 'Monthly meeting',
        'CalendarID' => $Calendar{CalendarID},
        'TeamID'     => [],
        'StartTime'  => '2016-07-12 11:15:00',
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2016-07-12 12:00:00',
        'Description' => 'Once per month',
        'Location'    => 'Germany'
    },
    {
        'TeamID'      => [],
        'Title'       => 'Monthly meeting',
        'CalendarID'  => $Calendar{CalendarID},
        'StartTime'   => '2016-08-12 11:15:00',
        'AllDay'      => undef,
        'Location'    => 'Germany',
        'Description' => 'Once per month',
        'EndTime'     => '2016-08-12 12:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ]
    },
    {
        'StartTime'  => '2016-09-12 11:15:00',
        'Title'      => 'Monthly meeting',
        'CalendarID' => $Calendar{CalendarID},
        'TeamID'     => [],
        'Recurring'  => undef,
        'EndTime'    => '2016-09-12 12:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => 'Germany',
        'Description' => 'Once per month',
        'AllDay'      => undef,
    },
    {
        'Recurring'  => undef,
        'EndTime'    => '2016-10-12 12:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => 'Germany',
        'Description' => 'Once per month',
        'AllDay'      => undef,
        'StartTime'   => '2016-10-12 11:15:00',
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Monthly meeting',
        'TeamID'      => []
    },
    {
        'AllDay'      => undef,
        'Description' => 'Once per month',
        'Location'    => 'Germany',
        'ResourceID'  => [
            0,
        ],
        'EndTime'    => '2016-11-12 12:00:00',
        'Recurring'  => undef,
        'TeamID'     => [],
        'Title'      => 'Monthly meeting',
        'CalendarID' => $Calendar{CalendarID},
        'StartTime'  => '2016-11-12 11:15:00',
    },
    {
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Monthly meeting',
        'TeamID'     => [],
        'StartTime'  => '2016-12-12 11:15:00',
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2016-12-12 12:00:00',
        'Recurring'   => undef,
        'Description' => 'Once per month',
        'Location'    => 'Germany'
    },
    {
        'StartTime'  => '2017-01-12 11:15:00',
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Monthly meeting',
        'TeamID'     => [],
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2017-01-12 12:00:00',
        'Recurring'   => undef,
        'Description' => 'Once per month',
        'Location'    => 'Germany',
        'AllDay'      => undef,
    },
    {
        'AllDay'      => undef,
        'Location'    => 'Germany',
        'Description' => 'Once per month',
        'EndTime'     => '2017-02-12 12:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Monthly meeting',
        'StartTime'  => '2017-02-12 11:15:00',
    },
    {
        'StartTime'  => '2016-03-31 06:00:00',
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'End of the month',
        'TeamID'     => [],
        'ResourceID' => [
            0,
        ],
        'Recurring'   => '1',
        'EndTime'     => '2016-03-31 07:00:00',
        'Description' => undef,
        'Location'    => undef,
        'AllDay'      => undef,
    },
    {
        'StartTime'  => '2016-04-30 06:00:00',
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'End of the month',
        'TeamID'     => [],
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2016-04-30 07:00:00',
        'Description' => undef,
        'Location'    => undef,
        'AllDay'      => undef,
    },
    {
        'AllDay'     => undef,
        'EndTime'    => '2016-05-31 07:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => undef,
        'Title'       => 'End of the month',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
        'StartTime'   => '2016-05-31 06:00:00'
    },
    {
        'AllDay'      => undef,
        'Location'    => undef,
        'Description' => undef,
        'Recurring'   => undef,
        'EndTime'     => '2016-06-30 07:00:00',
        'ResourceID'  => [
            0,
        ],
        'TeamID'     => [],
        'Title'      => 'End of the month',
        'CalendarID' => $Calendar{CalendarID},
        'StartTime'  => '2016-06-30 06:00:00',
    },
    {
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2016-07-31 07:00:00',
        'Recurring'   => undef,
        'Description' => undef,
        'Location'    => undef,
        'AllDay'      => undef,
        'StartTime'   => '2016-07-31 06:00:00',
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'End of the month',
        'TeamID'      => [],
    },
    {
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2016-08-31 07:00:00',
        'Description' => undef,
        'Location'    => undef,
        'Title'       => 'End of the month',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
        'StartTime'   => '2016-08-31 06:00:00'
    },
    {
        'StartTime'  => '2016-09-30 06:00:00',
        'Title'      => 'End of the month',
        'CalendarID' => $Calendar{CalendarID},
        'TeamID'     => [],
        'EndTime'    => '2016-09-30 07:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => undef,
        'AllDay'      => undef,
    },
    {
        'Title'      => 'End of the month',
        'CalendarID' => $Calendar{CalendarID},
        'TeamID'     => [],
        'StartTime'  => '2016-10-31 06:00:00',
        'AllDay'     => undef,
        'Recurring'  => undef,
        'EndTime'    => '2016-10-31 07:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => undef
    },
    {
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2016-11-30 07:00:00',
        'Description' => undef,
        'Location'    => undef,
        'AllDay'      => undef,
        'StartTime'   => '2016-11-30 06:00:00',
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'End of the month',
        'TeamID'      => [],
    },
    {
        'StartTime'   => '2016-12-31 06:00:00',
        'TeamID'      => [],
        'Title'       => 'End of the month',
        'CalendarID'  => $Calendar{CalendarID},
        'Description' => undef,
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'Recurring' => undef,
        'EndTime'   => '2016-12-31 07:00:00',
        'AllDay'    => undef
    },
    {
        'AllDay'     => undef,
        'EndTime'    => '2017-01-31 07:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => undef,
        'Title'       => 'End of the month',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
        'StartTime'   => '2017-01-31 06:00:00'
    },
    {
        'TeamID'      => [],
        'Title'       => 'End of the month',
        'CalendarID'  => $Calendar{CalendarID},
        'StartTime'   => '2017-02-28 06:00:00',
        'AllDay'      => undef,
        'Description' => undef,
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'EndTime'   => '2017-02-28 07:00:00',
        'Recurring' => undef
    },
    {
        'StartTime'   => '2016-01-31 09:00:00',
        'TeamID'      => [],
        'Title'       => 'Each 2 months',
        'CalendarID'  => $Calendar{CalendarID},
        'Location'    => 'Test',
        'Description' => 'test',
        'Recurring'   => '1',
        'EndTime'     => '2016-01-31 10:00:00',
        'ResourceID'  => [
            0,
        ],
        'AllDay' => undef
    },
    {
        'Location'    => 'Test',
        'Description' => 'test',
        'EndTime'     => '2016-03-31 10:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
        'AllDay'     => undef,
        'StartTime'  => '2016-03-31 09:00:00',
        'TeamID'     => [],
        'Title'      => 'Each 2 months',
        'CalendarID' => $Calendar{CalendarID},
    },
    {
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2016-05-31 10:00:00',
        'Description' => 'test',
        'Location'    => 'Test',
        'Title'       => 'Each 2 months',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
        'StartTime'   => '2016-05-31 09:00:00'
    },
    {
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 2 months',
        'TeamID'     => [],
        'StartTime'  => '2016-07-31 09:00:00',
        'AllDay'     => undef,
        'Recurring'  => undef,
        'EndTime'    => '2016-07-31 10:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => 'Test',
        'Description' => 'test'
    },
    {
        'AllDay'      => undef,
        'Description' => 'test',
        'Location'    => 'Test',
        'ResourceID'  => [
            0,
        ],
        'Recurring'  => undef,
        'EndTime'    => '2017-01-31 10:00:00',
        'TeamID'     => [],
        'Title'      => 'Each 2 months',
        'CalendarID' => $Calendar{CalendarID},
        'StartTime'  => '2017-01-31 09:00:00',
    },
    {
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'Recurring'   => '1',
        'EndTime'     => '2016-04-12 08:00:00',
        'Description' => 'Test description',
        'Location'    => 'Stara Pazova',
        'Title'       => 'My event',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
        'StartTime'   => '2016-04-12 07:00:00'
    },
    {
        'Description' => 'Test description',
        'Location'    => 'Stara Pazova',
        'ResourceID'  => [
            0,
        ],
        'EndTime'    => '2016-04-14 08:00:00',
        'Recurring'  => undef,
        'AllDay'     => undef,
        'StartTime'  => '2016-04-14 07:00:00',
        'TeamID'     => [],
        'Title'      => 'My event',
        'CalendarID' => $Calendar{CalendarID},
    },
    {
        'Description' => 'Test description',
        'Location'    => 'Stara Pazova',
        'ResourceID'  => [
            0,
        ],
        'EndTime'    => '2016-04-16 08:00:00',
        'Recurring'  => undef,
        'AllDay'     => undef,
        'StartTime'  => '2016-04-16 07:00:00',
        'TeamID'     => [],
        'Title'      => 'My event',
        'CalendarID' => $Calendar{CalendarID},
    },
    {
        'TeamID'      => [],
        'Title'       => 'My event',
        'CalendarID'  => $Calendar{CalendarID},
        'StartTime'   => '2016-04-18 07:00:00',
        'AllDay'      => undef,
        'Description' => 'Test description',
        'Location'    => 'Stara Pazova',
        'ResourceID'  => [
            0,
        ],
        'Recurring' => undef,
        'EndTime'   => '2016-04-18 08:00:00'
    },
    {
        'Location'    => 'Stara Pazova',
        'Description' => 'Test description',
        'Recurring'   => undef,
        'EndTime'     => '2016-04-20 08:00:00',
        'ResourceID'  => [
            0,
        ],
        'AllDay'     => undef,
        'StartTime'  => '2016-04-20 07:00:00',
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'My event'
    },
    {
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'My event',
        'TeamID'     => [],
        'StartTime'  => '2016-04-22 07:00:00',
        'AllDay'     => undef,
        'Recurring'  => undef,
        'EndTime'    => '2016-04-22 08:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => 'Stara Pazova',
        'Description' => 'Test description'
    },
    {
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'My event',
        'TeamID'     => [],
        'StartTime'  => '2016-04-24 07:00:00',
        'AllDay'     => undef,
        'EndTime'    => '2016-04-24 08:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => 'Stara Pazova',
        'Description' => 'Test description'
    },
    {
        'StartTime'  => '2016-04-26 07:00:00',
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'My event',
        'TeamID'     => [],
        'Recurring'  => undef,
        'EndTime'    => '2016-04-26 08:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => 'Stara Pazova',
        'Description' => 'Test description',
        'AllDay'      => undef,
    },
    {
        'EndTime'    => '2016-04-28 08:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => 'Stara Pazova',
        'Description' => 'Test description',
        'AllDay'      => undef,
        'StartTime'   => '2016-04-28 07:00:00',
        'Title'       => 'My event',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => []
    },
    {
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'My event',
        'TeamID'     => [],
        'StartTime'  => '2016-04-30 07:00:00',
        'AllDay'     => undef,
        'Recurring'  => undef,
        'EndTime'    => '2016-04-30 08:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => 'Stara Pazova',
        'Description' => 'Test description'
    },
    {
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2016-05-02 08:00:00',
        'Recurring'   => undef,
        'Description' => 'Test description',
        'Location'    => 'Stara Pazova',
        'Title'       => 'My event',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
        'StartTime'   => '2016-05-02 07:00:00'
    },
    {
        'TeamID'      => [],
        'Title'       => 'My event',
        'CalendarID'  => $Calendar{CalendarID},
        'StartTime'   => '2016-05-04 07:00:00',
        'AllDay'      => undef,
        'Description' => 'Test description',
        'Location'    => 'Stara Pazova',
        'ResourceID'  => [
            0,
        ],
        'EndTime'   => '2016-05-04 08:00:00',
        'Recurring' => undef
    },
    {
        'Location'    => 'Stara Pazova',
        'Description' => 'Test description',
        'EndTime'     => '2016-05-06 08:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
        'AllDay'     => undef,
        'StartTime'  => '2016-05-06 07:00:00',
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'My event'
    },
    {
        'Title'      => 'My event',
        'CalendarID' => $Calendar{CalendarID},
        'TeamID'     => [],
        'StartTime'  => '2016-05-08 07:00:00',
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2016-05-08 08:00:00',
        'Recurring'   => undef,
        'Description' => 'Test description',
        'Location'    => 'Stara Pazova'
    },
    {
        'StartTime'   => '2016-05-10 07:00:00',
        'TeamID'      => [],
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'My event',
        'Location'    => 'Stara Pazova',
        'Description' => 'Test description',
        'Recurring'   => undef,
        'EndTime'     => '2016-05-10 08:00:00',
        'ResourceID'  => [
            0,
        ],
        'AllDay' => undef
    },
    {
        'AllDay'      => undef,
        'Description' => 'Test description',
        'Location'    => 'Stara Pazova',
        'ResourceID'  => [
            0,
        ],
        'EndTime'    => '2016-05-12 08:00:00',
        'Recurring'  => undef,
        'TeamID'     => [],
        'Title'      => 'My event',
        'CalendarID' => $Calendar{CalendarID},
        'StartTime'  => '2016-05-12 07:00:00',
    },
    {
        'Description' => 'Test description',
        'Location'    => 'Stara Pazova',
        'ResourceID'  => [
            0,
        ],
        'Recurring'  => undef,
        'EndTime'    => '2016-05-14 08:00:00',
        'AllDay'     => undef,
        'StartTime'  => '2016-05-14 07:00:00',
        'TeamID'     => [],
        'Title'      => 'My event',
        'CalendarID' => $Calendar{CalendarID},
    },
    {
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'My event',
        'TeamID'     => [],
        'StartTime'  => '2016-05-16 07:00:00',
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2016-05-16 08:00:00',
        'Description' => 'Test description',
        'Location'    => 'Stara Pazova'
    },
    {
        'StartTime'   => '2016-05-18 07:00:00',
        'TeamID'      => [],
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'My event',
        'Location'    => 'Stara Pazova',
        'Description' => 'Test description',
        'EndTime'     => '2016-05-18 08:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
        'AllDay' => undef
    },
    {
        'StartTime'   => '2016-05-20 07:00:00',
        'TeamID'      => [],
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'My event',
        'Description' => 'Test description',
        'Location'    => 'Stara Pazova',
        'ResourceID'  => [
            0,
        ],
        'Recurring' => undef,
        'EndTime'   => '2016-05-20 08:00:00',
        'AllDay'    => undef
    },
    {
        'TeamID'      => [],
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'My event',
        'StartTime'   => '2016-05-22 07:00:00',
        'AllDay'      => undef,
        'Description' => 'Test description',
        'Location'    => 'Stara Pazova',
        'ResourceID'  => [
            0,
        ],
        'Recurring' => undef,
        'EndTime'   => '2016-05-22 08:00:00'
    },
    {
        'EndTime'    => '2016-05-24 08:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => 'Stara Pazova',
        'Description' => 'Test description',
        'AllDay'      => undef,
        'StartTime'   => '2016-05-24 07:00:00',
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'My event',
        'TeamID'      => []
    },
    {
        'AllDay'      => undef,
        'Description' => 'Test description',
        'Location'    => 'Stara Pazova',
        'ResourceID'  => [
            0,
        ],
        'Recurring'  => undef,
        'EndTime'    => '2016-05-26 08:00:00',
        'TeamID'     => [],
        'Title'      => 'My event',
        'CalendarID' => $Calendar{CalendarID},
        'StartTime'  => '2016-05-26 07:00:00',
    },
    {
        'Location'    => 'Stara Pazova',
        'Description' => 'Test description',
        'EndTime'     => '2016-05-28 08:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
        'AllDay'     => undef,
        'StartTime'  => '2016-05-28 07:00:00',
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'My event'
    },
    {
        'StartTime'  => '2016-05-30 07:00:00',
        'Title'      => 'My event',
        'CalendarID' => $Calendar{CalendarID},
        'TeamID'     => [],
        'EndTime'    => '2016-05-30 08:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => 'Stara Pazova',
        'Description' => 'Test description',
        'AllDay'      => undef,
    },
    {
        'AllDay'      => undef,
        'Description' => 'Test description',
        'Location'    => 'Stara Pazova',
        'ResourceID'  => [
            0,
        ],
        'EndTime'    => '2016-06-01 08:00:00',
        'Recurring'  => undef,
        'TeamID'     => [],
        'Title'      => 'My event',
        'CalendarID' => $Calendar{CalendarID},
        'StartTime'  => '2016-06-01 07:00:00',
    },
    {
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2016-04-01 09:00:00',
        'Recurring'   => '1',
        'Description' => undef,
        'Location'    => undef,
        'AllDay'      => undef,
        'StartTime'   => '2016-04-01 08:00:00',
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Each 2 years',
        'TeamID'      => [],
    },
    {
        'TeamID'      => [],
        'Title'       => 'Each 2 years',
        'CalendarID'  => $Calendar{CalendarID},
        'StartTime'   => '2018-04-01 08:00:00',
        'AllDay'      => undef,
        'Location'    => undef,
        'Description' => undef,
        'Recurring'   => undef,
        'EndTime'     => '2018-04-01 09:00:00',
        'ResourceID'  => [
            0,
        ],
    },
    {
        'TeamID'      => [],
        'Title'       => 'Each 2 years',
        'CalendarID'  => $Calendar{CalendarID},
        'StartTime'   => '2020-04-01 08:00:00',
        'AllDay'      => undef,
        'Location'    => undef,
        'Description' => undef,
        'EndTime'     => '2020-04-01 09:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ]
    },
    {
        'TeamID'      => [],
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Each 3thd all day',
        'StartTime'   => '2016-04-02 00:00:00',
        'AllDay'      => '1',
        'Description' => undef,
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'EndTime'   => '2016-04-03 00:00:00',
        'Recurring' => '1'
    },
    {
        'StartTime'  => '2016-04-05 00:00:00',
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 3thd all day',
        'TeamID'     => [],
        'Recurring'  => undef,
        'EndTime'    => '2016-04-06 00:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => undef,
        'AllDay'      => '1',
    },
    {
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 3thd all day',
        'TeamID'     => [],
        'StartTime'  => '2016-04-08 00:00:00',
        'AllDay'     => '1',
        'Recurring'  => undef,
        'EndTime'    => '2016-04-09 00:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => undef
    },
    {
        'AllDay'      => '1',
        'Description' => undef,
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'EndTime'    => '2016-04-12 00:00:00',
        'Recurring'  => undef,
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 3thd all day',
        'StartTime'  => '2016-04-11 00:00:00',
    },
    {
        'StartTime'   => '2016-04-14 00:00:00',
        'TeamID'      => [],
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Each 3thd all day',
        'Description' => undef,
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'Recurring' => undef,
        'EndTime'   => '2016-04-15 00:00:00',
        'AllDay'    => '1'
    },
    {
        'StartTime'   => '2016-04-17 00:00:00',
        'TeamID'      => [],
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Each 3thd all day',
        'Description' => undef,
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'EndTime'   => '2016-04-18 00:00:00',
        'Recurring' => undef,
        'AllDay'    => '1'
    },
    {
        'AllDay'      => '1',
        'Location'    => undef,
        'Description' => undef,
        'EndTime'     => '2016-04-21 00:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
        'TeamID'     => [],
        'Title'      => 'Each 3thd all day',
        'CalendarID' => $Calendar{CalendarID},
        'StartTime'  => '2016-04-20 00:00:00',
    },
    {
        'AllDay'     => '1',
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2016-04-24 00:00:00',
        'Description' => undef,
        'Location'    => undef,
        'Title'       => 'Each 3thd all day',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
        'StartTime'   => '2016-04-23 00:00:00'
    },
    {
        'AllDay'      => '1',
        'Location'    => undef,
        'Description' => undef,
        'Recurring'   => undef,
        'EndTime'     => '2016-04-27 00:00:00',
        'ResourceID'  => [
            0,
        ],
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 3thd all day',
        'StartTime'  => '2016-04-26 00:00:00',
    },
    {
        'Recurring'  => undef,
        'EndTime'    => '2016-04-30 00:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => undef,
        'AllDay'      => '1',
        'StartTime'   => '2016-04-29 00:00:00',
        'Title'       => 'Each 3thd all day',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => []
    },
    {
        'AllDay'     => undef,
        'EndTime'    => '2016-03-07 16:00:00',
        'Recurring'  => '1',
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => undef,
        'Title'       => 'First 3 days',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
        'StartTime'   => '2016-03-07 15:00:00'
    },
    {
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2016-03-08 16:00:00',
        'Recurring'   => undef,
        'Description' => undef,
        'Location'    => undef,
        'AllDay'      => undef,
        'StartTime'   => '2016-03-08 15:00:00',
        'Title'       => 'First 3 days',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
    },
    {
        'Title'      => 'First 3 days',
        'CalendarID' => $Calendar{CalendarID},
        'TeamID'     => [],
        'StartTime'  => '2016-03-09 15:00:00',
        'AllDay'     => undef,
        'EndTime'    => '2016-03-09 16:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => undef
    },
    {
        'StartTime'  => '2016-03-02 17:00:00',
        'Title'      => 'Once per next 2 month',
        'CalendarID' => $Calendar{CalendarID},
        'TeamID'     => [],
        'Recurring'  => '1',
        'EndTime'    => '2016-03-02 18:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => undef,
        'AllDay'      => undef,
    },
    {
        'TeamID'      => [],
        'Title'       => 'Once per next 2 month',
        'CalendarID'  => $Calendar{CalendarID},
        'StartTime'   => '2016-04-02 17:00:00',
        'AllDay'      => undef,
        'Location'    => undef,
        'Description' => undef,
        'EndTime'     => '2016-04-02 18:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ]
    },
    {
        'Location'    => undef,
        'Description' => undef,
        'EndTime'     => '2016-01-03 18:00:00',
        'Recurring'   => '1',
        'ResourceID'  => [
            0,
        ],
        'AllDay'     => undef,
        'StartTime'  => '2016-01-03 17:00:00',
        'TeamID'     => [],
        'Title'      => 'January 3th next 3 years',
        'CalendarID' => $Calendar{CalendarID},
    },
    {
        'TeamID'      => [],
        'Title'       => 'January 3th next 3 years',
        'CalendarID'  => $Calendar{CalendarID},
        'StartTime'   => '2017-01-03 17:00:00',
        'AllDay'      => undef,
        'Description' => undef,
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'EndTime'   => '2017-01-03 18:00:00',
        'Recurring' => undef
    },
    {
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2018-01-03 18:00:00',
        'Description' => undef,
        'Location'    => undef,
        'AllDay'      => undef,
        'StartTime'   => '2018-01-03 17:00:00',
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'January 3th next 3 years',
        'TeamID'      => [],
    },
    {
        'StartTime'   => '2016-04-12 14:00:00',
        'TeamID'      => [],
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Each 2nd week',
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'EndTime'     => '2016-04-12 15:00:00',
        'Recurring'   => '1',
        'ResourceID'  => [
            0,
        ],
        'AllDay' => undef
    },
    {
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 2nd week',
        'TeamID'     => [],
        'StartTime'  => '2016-04-26 14:00:00',
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2016-04-26 15:00:00',
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef
    },
    {
        'StartTime'   => '2016-05-10 14:00:00',
        'TeamID'      => [],
        'Title'       => 'Each 2nd week',
        'CalendarID'  => $Calendar{CalendarID},
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'EndTime'   => '2016-05-10 15:00:00',
        'Recurring' => undef,
        'AllDay'    => undef
    },
    {
        'AllDay'      => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'Recurring'  => undef,
        'EndTime'    => '2016-05-24 15:00:00',
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 2nd week',
        'StartTime'  => '2016-05-24 14:00:00',
    },
    {
        'StartTime'   => '2016-06-07 14:00:00',
        'TeamID'      => [],
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Each 2nd week',
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'Recurring' => undef,
        'EndTime'   => '2016-06-07 15:00:00',
        'AllDay'    => undef
    },
    {
        'StartTime'  => '2016-06-21 14:00:00',
        'Title'      => 'Each 2nd week',
        'CalendarID' => $Calendar{CalendarID},
        'TeamID'     => [],
        'EndTime'    => '2016-06-21 15:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'AllDay'      => undef,
    },
    {
        'AllDay'     => undef,
        'Recurring'  => undef,
        'EndTime'    => '2016-07-05 15:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Each 2nd week',
        'TeamID'      => [],
        'StartTime'   => '2016-07-05 14:00:00'
    },
    {
        'TeamID'      => [],
        'Title'       => 'Each 2nd week',
        'CalendarID'  => $Calendar{CalendarID},
        'StartTime'   => '2016-07-19 14:00:00',
        'AllDay'      => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'EndTime'   => '2016-07-19 15:00:00',
        'Recurring' => undef
    },
    {
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 2nd week',
        'TeamID'     => [],
        'StartTime'  => '2016-08-02 14:00:00',
        'AllDay'     => undef,
        'Recurring'  => undef,
        'EndTime'    => '2016-08-02 15:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday'
    },
    {
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2016-08-16 15:00:00',
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'AllDay'      => undef,
        'StartTime'   => '2016-08-16 14:00:00',
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Each 2nd week',
        'TeamID'      => [],
    },
    {
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Recurring'   => undef,
        'EndTime'     => '2016-08-30 15:00:00',
        'ResourceID'  => [
            0,
        ],
        'AllDay'     => undef,
        'StartTime'  => '2016-08-30 14:00:00',
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 2nd week'
    },
    {
        'AllDay'      => undef,
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'EndTime'     => '2016-09-13 15:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 2nd week',
        'StartTime'  => '2016-09-13 14:00:00',
    },
    {
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'Recurring'  => undef,
        'EndTime'    => '2016-09-27 15:00:00',
        'AllDay'     => undef,
        'StartTime'  => '2016-09-27 14:00:00',
        'TeamID'     => [],
        'Title'      => 'Each 2nd week',
        'CalendarID' => $Calendar{CalendarID},
    },
    {
        'Title'      => 'Each 2nd week',
        'CalendarID' => $Calendar{CalendarID},
        'TeamID'     => [],
        'StartTime'  => '2016-10-11 14:00:00',
        'AllDay'     => undef,
        'EndTime'    => '2016-10-11 15:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday'
    },
    {
        'Recurring'  => undef,
        'EndTime'    => '2016-10-25 15:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'AllDay'      => undef,
        'StartTime'   => '2016-10-25 14:00:00',
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Each 2nd week',
        'TeamID'      => []
    },
    {
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2016-11-08 15:00:00',
        'Recurring'   => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Each 2nd week',
        'TeamID'      => [],
        'StartTime'   => '2016-11-08 14:00:00'
    },
    {
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 2nd week',
        'TeamID'     => [],
        'StartTime'  => '2016-11-22 14:00:00',
        'AllDay'     => undef,
        'EndTime'    => '2016-11-22 15:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday'
    },
    {
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2016-12-06 15:00:00',
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'Title'       => 'Each 2nd week',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
        'StartTime'   => '2016-12-06 14:00:00'
    },
    {
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2016-12-20 15:00:00',
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'AllDay'      => undef,
        'StartTime'   => '2016-12-20 14:00:00',
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Each 2nd week',
        'TeamID'      => [],
    },
    {
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2017-01-03 15:00:00',
        'Recurring'   => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'Title'       => 'Each 2nd week',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
        'StartTime'   => '2017-01-03 14:00:00'
    },
    {
        'StartTime'  => '2017-01-17 14:00:00',
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 2nd week',
        'TeamID'     => [],
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2017-01-17 15:00:00',
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'AllDay'      => undef,
    },
    {
        'EndTime'    => '2017-01-31 15:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'AllDay'      => undef,
        'StartTime'   => '2017-01-31 14:00:00',
        'Title'       => 'Each 2nd week',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => []
    },
    {
        'AllDay'     => undef,
        'EndTime'    => '2017-02-14 15:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Title'       => 'Each 2nd week',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
        'StartTime'   => '2017-02-14 14:00:00'
    },
    {
        'AllDay'      => undef,
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'EndTime'     => '2017-02-28 15:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 2nd week',
        'StartTime'  => '2017-02-28 14:00:00',
    },
    {
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 2nd week',
        'TeamID'     => [],
        'StartTime'  => '2017-03-14 14:00:00',
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2017-03-14 15:00:00',
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef
    },
    {
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'EndTime'    => '2017-03-28 15:00:00',
        'Recurring'  => undef,
        'AllDay'     => undef,
        'StartTime'  => '2017-03-28 14:00:00',
        'TeamID'     => [],
        'Title'      => 'Each 2nd week',
        'CalendarID' => $Calendar{CalendarID},
    },
    {
        'AllDay'      => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'EndTime'    => '2017-04-11 15:00:00',
        'Recurring'  => undef,
        'TeamID'     => [],
        'Title'      => 'Each 2nd week',
        'CalendarID' => $Calendar{CalendarID},
        'StartTime'  => '2017-04-11 14:00:00',
    },
    {
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2017-04-25 15:00:00',
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'AllDay'      => undef,
        'StartTime'   => '2017-04-25 14:00:00',
        'Title'       => 'Each 2nd week',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
    },
    {
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'EndTime'     => '2017-05-09 15:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
        'AllDay'     => undef,
        'StartTime'  => '2017-05-09 14:00:00',
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 2nd week'
    },
    {
        'AllDay'      => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'EndTime'    => '2017-05-23 15:00:00',
        'Recurring'  => undef,
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 2nd week',
        'StartTime'  => '2017-05-23 14:00:00',
    },
    {
        'TeamID'      => [],
        'Title'       => 'Each 2nd week',
        'CalendarID'  => $Calendar{CalendarID},
        'StartTime'   => '2017-06-06 14:00:00',
        'AllDay'      => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'EndTime'   => '2017-06-06 15:00:00',
        'Recurring' => undef
    },
    {
        'AllDay'      => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'Recurring'  => undef,
        'EndTime'    => '2017-06-20 15:00:00',
        'TeamID'     => [],
        'Title'      => 'Each 2nd week',
        'CalendarID' => $Calendar{CalendarID},
        'StartTime'  => '2017-06-20 14:00:00',
    },
    {
        'TeamID'      => [],
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Each 2nd week',
        'StartTime'   => '2017-07-04 14:00:00',
        'AllDay'      => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'EndTime'   => '2017-07-04 15:00:00',
        'Recurring' => undef
    },
    {
        'StartTime'   => '2017-07-18 14:00:00',
        'TeamID'      => [],
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Each 2nd week',
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'EndTime'     => '2017-07-18 15:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
        'AllDay' => undef
    },
    {
        'StartTime'  => '2017-08-01 14:00:00',
        'Title'      => 'Each 2nd week',
        'CalendarID' => $Calendar{CalendarID},
        'TeamID'     => [],
        'EndTime'    => '2017-08-01 15:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'AllDay'      => undef,
    },
    {
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'EndTime'     => '2017-08-15 15:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
        'AllDay'     => undef,
        'StartTime'  => '2017-08-15 14:00:00',
        'TeamID'     => [],
        'Title'      => 'Each 2nd week',
        'CalendarID' => $Calendar{CalendarID},
    },
    {
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2017-08-29 15:00:00',
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'Title'       => 'Each 2nd week',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
        'StartTime'   => '2017-08-29 14:00:00'
    },
    {
        'Title'      => 'Each 2nd week',
        'CalendarID' => $Calendar{CalendarID},
        'TeamID'     => [],
        'StartTime'  => '2017-09-12 14:00:00',
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2017-09-12 15:00:00',
        'Recurring'   => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef
    },
    {
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'EndTime'     => '2017-09-26 15:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
        'AllDay'     => undef,
        'StartTime'  => '2017-09-26 14:00:00',
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 2nd week'
    },
    {
        'TeamID'      => [],
        'Title'       => 'Each 2nd week',
        'CalendarID'  => $Calendar{CalendarID},
        'StartTime'   => '2017-10-10 14:00:00',
        'AllDay'      => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'Recurring' => undef,
        'EndTime'   => '2017-10-10 15:00:00'
    },
    {
        'AllDay'      => undef,
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Recurring'   => undef,
        'EndTime'     => '2017-10-24 15:00:00',
        'ResourceID'  => [
            0,
        ],
        'TeamID'     => [],
        'Title'      => 'Each 2nd week',
        'CalendarID' => $Calendar{CalendarID},
        'StartTime'  => '2017-10-24 14:00:00',
    },
    {
        'StartTime'  => '2017-11-07 14:00:00',
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 2nd week',
        'TeamID'     => [],
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2017-11-07 15:00:00',
        'Recurring'   => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'AllDay'      => undef,
    },
    {
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2017-11-21 15:00:00',
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'Title'       => 'Each 2nd week',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
        'StartTime'   => '2017-11-21 14:00:00'
    },
    {
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2017-12-05 15:00:00',
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Location'    => undef,
        'Title'       => 'Each 2nd week',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
        'StartTime'   => '2017-12-05 14:00:00'
    },
    {
        'AllDay'      => undef,
        'Location'    => undef,
        'Description' => 'Developer meeting each 2nd Tuesday',
        'Recurring'   => undef,
        'EndTime'     => '2017-12-19 15:00:00',
        'ResourceID'  => [
            0,
        ],
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Each 2nd week',
        'StartTime'  => '2017-12-19 14:00:00',
    },
    {
        'EndTime'    => '2016-01-11 09:00:00',
        'Recurring'  => '1',
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Start at Monday and repeat each 2nd Wednesday and Sunday.',
        'AllDay'      => undef,
        'StartTime'   => '2016-01-11 08:00:00',
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Custom 1',
        'TeamID'      => []
    },
    {
        'StartTime'  => '2016-01-13 08:00:00',
        'Title'      => 'Custom 1',
        'CalendarID' => $Calendar{CalendarID},
        'TeamID'     => [],
        'EndTime'    => '2016-01-13 09:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Start at Monday and repeat each 2nd Wednesday and Sunday.',
        'AllDay'      => undef,
    },
    {
        'AllDay'      => undef,
        'Description' => 'Start at Monday and repeat each 2nd Wednesday and Sunday.',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'Recurring'  => undef,
        'EndTime'    => '2016-01-17 09:00:00',
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Custom 1',
        'StartTime'  => '2016-01-17 08:00:00',
    },
    {
        'Description' => 'Start at Monday and repeat each 2nd Wednesday and Sunday.',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'EndTime'    => '2016-01-27 09:00:00',
        'Recurring'  => undef,
        'AllDay'     => undef,
        'StartTime'  => '2016-01-27 08:00:00',
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Custom 1'
    },
    {
        'Description' => 'Start at Monday and repeat each 2nd Wednesday and Sunday.',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'Recurring'  => undef,
        'EndTime'    => '2016-01-31 09:00:00',
        'AllDay'     => undef,
        'StartTime'  => '2016-01-31 08:00:00',
        'TeamID'     => [],
        'Title'      => 'Custom 1',
        'CalendarID' => $Calendar{CalendarID},
    },
    {
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2016-02-10 09:00:00',
        'Recurring'   => undef,
        'Description' => 'Start at Monday and repeat each 2nd Wednesday and Sunday.',
        'Location'    => undef,
        'AllDay'      => undef,
        'StartTime'   => '2016-02-10 08:00:00',
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Custom 1',
        'TeamID'      => [],
    },
    {
        'EndTime'    => '2016-02-14 09:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Start at Monday and repeat each 2nd Wednesday and Sunday.',
        'AllDay'      => undef,
        'StartTime'   => '2016-02-14 08:00:00',
        'Title'       => 'Custom 1',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => []
    },
    {
        'AllDay'     => undef,
        'Recurring'  => undef,
        'EndTime'    => '2016-02-24 09:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Start at Monday and repeat each 2nd Wednesday and Sunday.',
        'Title'       => 'Custom 1',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
        'StartTime'   => '2016-02-24 08:00:00'
    },
    {
        'TeamID'      => [],
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Custom 1',
        'StartTime'   => '2016-02-28 08:00:00',
        'AllDay'      => undef,
        'Description' => 'Start at Monday and repeat each 2nd Wednesday and Sunday.',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'Recurring' => undef,
        'EndTime'   => '2016-02-28 09:00:00'
    },
    {
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2016-03-09 09:00:00',
        'Recurring'   => undef,
        'Description' => 'Start at Monday and repeat each 2nd Wednesday and Sunday.',
        'Location'    => undef,
        'AllDay'      => undef,
        'StartTime'   => '2016-03-09 08:00:00',
        'Title'       => 'Custom 1',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
    },
    {
        'StartTime'   => '2016-03-13 08:00:00',
        'TeamID'      => [],
        'Title'       => 'Custom 1',
        'CalendarID'  => $Calendar{CalendarID},
        'Description' => 'Start at Monday and repeat each 2nd Wednesday and Sunday.',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'Recurring' => undef,
        'EndTime'   => '2016-03-13 09:00:00',
        'AllDay'    => undef
    },
    {
        'AllDay'      => undef,
        'Description' => 'Start at Monday and repeat each 2nd Wednesday and Sunday.',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'Recurring'  => undef,
        'EndTime'    => '2016-03-23 09:00:00',
        'TeamID'     => [],
        'Title'      => 'Custom 1',
        'CalendarID' => $Calendar{CalendarID},
        'StartTime'  => '2016-03-23 08:00:00',
    },
    {
        'StartTime'  => '2016-03-27 08:00:00',
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Custom 1',
        'TeamID'     => [],
        'Recurring'  => undef,
        'EndTime'    => '2016-03-27 09:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Start at Monday and repeat each 2nd Wednesday and Sunday.',
        'AllDay'      => undef,
    },
    {
        'TeamID'      => [],
        'Title'       => 'Custom 2',
        'CalendarID'  => $Calendar{CalendarID},
        'StartTime'   => '2016-01-12 08:00:00',
        'AllDay'      => undef,
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'Recurring' => '1',
        'EndTime'   => '2016-01-12 09:00:00'
    },
    {
        'StartTime'  => '2016-01-16 08:00:00',
        'Title'      => 'Custom 2',
        'CalendarID' => $Calendar{CalendarID},
        'TeamID'     => [],
        'Recurring'  => undef,
        'EndTime'    => '2016-01-16 09:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'AllDay'      => undef,
    },
    {
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Custom 2',
        'TeamID'     => [],
        'StartTime'  => '2016-01-31 08:00:00',
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2016-01-31 09:00:00',
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'Location'    => undef
    },
    {
        'AllDay'      => undef,
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'EndTime'    => '2016-02-16 09:00:00',
        'Recurring'  => undef,
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Custom 2',
        'StartTime'  => '2016-02-16 08:00:00',
    },
    {
        'Location'    => undef,
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'EndTime'     => '2016-03-16 09:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
        'AllDay'     => undef,
        'StartTime'  => '2016-03-16 08:00:00',
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Custom 2'
    },
    {
        'StartTime'   => '2016-03-31 08:00:00',
        'TeamID'      => [],
        'Title'       => 'Custom 2',
        'CalendarID'  => $Calendar{CalendarID},
        'Location'    => undef,
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'EndTime'     => '2016-03-31 09:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
        'AllDay' => undef
    },
    {
        'ResourceID' => [
            0,
        ],
        'Recurring'   => undef,
        'EndTime'     => '2016-04-16 09:00:00',
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'Location'    => undef,
        'AllDay'      => undef,
        'StartTime'   => '2016-04-16 08:00:00',
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Custom 2',
        'TeamID'      => [],
    },
    {
        'AllDay'     => undef,
        'EndTime'    => '2016-05-16 09:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Custom 2',
        'TeamID'      => [],
        'StartTime'   => '2016-05-16 08:00:00'
    },
    {
        'Location'    => undef,
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'EndTime'     => '2016-05-31 09:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
        'AllDay'     => undef,
        'StartTime'  => '2016-05-31 08:00:00',
        'TeamID'     => [],
        'Title'      => 'Custom 2',
        'CalendarID' => $Calendar{CalendarID},
    },
    {
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Custom 2',
        'TeamID'     => [],
        'StartTime'  => '2016-06-16 08:00:00',
        'AllDay'     => undef,
        'EndTime'    => '2016-06-16 09:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.'
    },
    {
        'StartTime'  => '2016-07-16 08:00:00',
        'Title'      => 'Custom 2',
        'CalendarID' => $Calendar{CalendarID},
        'TeamID'     => [],
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2016-07-16 09:00:00',
        'Recurring'   => undef,
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'Location'    => undef,
        'AllDay'      => undef,
    },
    {
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2016-07-31 09:00:00',
        'Recurring'   => undef,
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'Location'    => undef,
        'AllDay'      => undef,
        'StartTime'   => '2016-07-31 08:00:00',
        'Title'       => 'Custom 2',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
    },
    {
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'EndTime'    => '2016-08-16 09:00:00',
        'Recurring'  => undef,
        'AllDay'     => undef,
        'StartTime'  => '2016-08-16 08:00:00',
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Custom 2'
    },
    {
        'TeamID'      => [],
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Custom 2',
        'StartTime'   => '2016-08-31 08:00:00',
        'AllDay'      => undef,
        'Location'    => undef,
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'EndTime'     => '2016-08-31 09:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
    },
    {
        'Location'    => undef,
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'EndTime'     => '2016-09-16 09:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
        'AllDay'     => undef,
        'StartTime'  => '2016-09-16 08:00:00',
        'TeamID'     => [],
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Custom 2'
    },
    {
        'StartTime'   => '2016-10-16 08:00:00',
        'TeamID'      => [],
        'Title'       => 'Custom 2',
        'CalendarID'  => $Calendar{CalendarID},
        'Location'    => undef,
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'EndTime'     => '2016-10-16 09:00:00',
        'Recurring'   => undef,
        'ResourceID'  => [
            0,
        ],
        'AllDay' => undef
    },
    {
        'TeamID'      => [],
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Custom 2',
        'StartTime'   => '2016-10-31 08:00:00',
        'AllDay'      => undef,
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'Recurring' => undef,
        'EndTime'   => '2016-10-31 09:00:00'
    },
    {
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2016-11-16 09:00:00',
        'Recurring'   => undef,
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'Location'    => undef,
        'AllDay'      => undef,
        'StartTime'   => '2016-11-16 08:00:00',
        'Title'       => 'Custom 2',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
    },
    {
        'TeamID'      => [],
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Custom 2',
        'StartTime'   => '2016-12-16 08:00:00',
        'AllDay'      => undef,
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'Recurring' => undef,
        'EndTime'   => '2016-12-16 09:00:00'
    },
    {
        'StartTime'  => '2016-12-31 08:00:00',
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Custom 2',
        'TeamID'     => [],
        'EndTime'    => '2016-12-31 09:00:00',
        'Recurring'  => undef,
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => 'Start on jan 12, repeat each month on 16th and 31th.',
        'AllDay'      => undef,
    },
    {
        'ResourceID' => [
            0,
        ],
        'Recurring'   => '1',
        'EndTime'     => '2016-01-31 09:00:00',
        'Description' => undef,
        'Location'    => undef,
        'AllDay'      => undef,
        'StartTime'   => '2016-01-31 08:00:00',
        'Title'       => 'Custom 3',
        'CalendarID'  => $Calendar{CalendarID},
        'TeamID'      => [],
    },
    {
        'TeamID'      => [],
        'Title'       => 'Custom 3',
        'CalendarID'  => $Calendar{CalendarID},
        'StartTime'   => '2016-02-29 08:00:00',
        'AllDay'      => undef,
        'Description' => undef,
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'EndTime'   => '2016-02-29 09:00:00',
        'Recurring' => undef
    },
    {
        'Location'    => undef,
        'Description' => undef,
        'Recurring'   => undef,
        'EndTime'     => '2016-12-31 09:00:00',
        'ResourceID'  => [
            0,
        ],
        'AllDay'     => undef,
        'StartTime'  => '2016-12-31 08:00:00',
        'TeamID'     => [],
        'Title'      => 'Custom 3',
        'CalendarID' => $Calendar{CalendarID},
    },
    {
        'TeamID'      => [],
        'Title'       => 'Custom 4',
        'CalendarID'  => $Calendar{CalendarID},
        'StartTime'   => '2016-01-04 15:00:00',
        'AllDay'      => undef,
        'Description' => undef,
        'Location'    => undef,
        'ResourceID'  => [
            0,
        ],
        'Recurring' => '1',
        'EndTime'   => '2016-01-04 16:00:00'
    },
    {
        'StartTime'  => '2016-02-04 15:00:00',
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Custom 4',
        'TeamID'     => [],
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2016-02-04 16:00:00',
        'Recurring'   => undef,
        'Description' => undef,
        'Location'    => undef,
        'AllDay'      => undef,
    },
    {
        'StartTime'  => '2017-02-04 15:00:00',
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Custom 4',
        'TeamID'     => [],
        'ResourceID' => [
            0,
        ],
        'EndTime'     => '2017-02-04 16:00:00',
        'Recurring'   => undef,
        'Description' => undef,
        'Location'    => undef,
        'AllDay'      => undef,
    },
    {
        'AllDay'     => undef,
        'ResourceID' => [
            0,
        ],
        'Recurring'   => '1',
        'EndTime'     => '2016-01-04 16:00:00',
        'Description' => undef,
        'Location'    => undef,
        'CalendarID'  => $Calendar{CalendarID},
        'Title'       => 'Yearly',
        'TeamID'      => [],
        'StartTime'   => '2016-01-04 15:00:00'
    },
    {
        'StartTime'  => '2017-01-04 15:00:00',
        'CalendarID' => $Calendar{CalendarID},
        'Title'      => 'Yearly',
        'TeamID'     => [],
        'Recurring'  => undef,
        'EndTime'    => '2017-01-04 16:00:00',
        'ResourceID' => [
            0,
        ],
        'Location'    => undef,
        'Description' => undef,
        'AllDay'      => undef,
    },
);

LOOP:
for ( my $Index = 0; $Index < scalar @Appointments; $Index++ ) {
    KEY:
    for my $Key ( sort keys %{ $Result[$Index] } ) {

        # check if undef
        if ( !defined $Result[$Index]->{$Key} ) {

            $Self->Is(
                $Appointments[$Index]->{$Key},
                undef,
                "Check if $Key is undef.",
            );
        }
        elsif ( IsArrayRefWithData( $Result[$Index]->{$Key} ) ) {
            my %Items = ();
            $Items{$_} += 1 foreach ( @{ $Result[$Index]->{$Key} } );
            $Items{$_} -= 1 foreach ( @{ $Appointments[$Index]->{$Key} } );

            $Self->True(
                !( grep { $_ != 0 } values %Items ),
                "Check if array $Key is OK.",
            );
        }
        elsif ( IsStringWithData( $Result[$Index]->{$Key} ) ) {

            # Skip ParentID since this value can't match AppointmentID (every time is different)
            next KEY if $Key eq

                $Self->Is(
                $Appointments[$Index]->{$Key},
                $Result[$Index]->{$Key},
                "Check if $Key value is OK.",
                );
        }
    }
}

1;
