# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my %WorkingHours;
for my $Day (qw(Mon Tue Wed Thu Fri Sat Sun)) {
    $WorkingHours{MonToSun}->{'0To23'}->{$Day}        = [ 0 .. 23 ];
    $WorkingHours{MonToSun}->{'8To17'}->{$Day}        = [ 8 .. 17 ];
    $WorkingHours{MonToSun}->{'8To12_14To17'}->{$Day} = [ 8 .. 12, 14 .. 17 ];
}
for my $Day (qw(Mon Tue Wed Thu Fri)) {
    $WorkingHours{MonToFri}->{'0To23'}->{$Day}        = [ 0 .. 23 ];
    $WorkingHours{MonToFri}->{'8To17'}->{$Day}        = [ 8 .. 17 ];
    $WorkingHours{MonToFri}->{'8To12_14To17'}->{$Day} = [ 8 .. 12, 14 .. 17 ];
}

my %VacationDays = (
    1 => {
        1 => 'New Year\'s Day',
    },
    5 => {
        1 => 'International Workers\' Day',
    },
    12 => {
        24 => 'Christmas Eve',
        25 => 'First Christmas Day',
        26 => 'Second Christmas Day',
        31 => 'New Year\'s Eve',
    },
);

# configure calendar 9
$ConfigObject->Set(
    Key   => 'TimeZone::Calendar9',
    Value => 'Europe/Berlin',
);

$ConfigObject->Set(
    Key   => 'TimeWorkingHours::Calendar9',
    Value => $WorkingHours{MonToFri}->{'8To12_14To17'},
);

$ConfigObject->Set(
    Key   => 'TimeVacationDays::Calendar9',
    Value => \%VacationDays,
);

my @Tests = (

    # This test must result in 0 working time because start and end date are swapped
    {
        Name                => '2d 8h 59m 59s, swapped start and end date',
        TimeZone            => 'Europe/Berlin',
        StartDateTimeString => '2015-12-28 17:10:14',
        EndDateTimeString   => '2015-12-23 08:10:15',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => \%VacationDays,
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 0,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 0,
        },
    },

    {
        Name                => '2d 8h 59m 59s',
        TimeZone            => 'Europe/Berlin',
        StartDateTimeString => '2015-12-23 08:10:15',
        EndDateTimeString   => '2015-12-28 17:10:14',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => \%VacationDays,
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 56,
            Minutes         => 59,
            Seconds         => 59,
            AbsoluteSeconds => 205199,
        },
    },

    {
        Name                => '15h via Calendar 9',
        TimeZone            => 'UTC',
        Calendar            => 9,                        # time zone Europe/Berlin
        StartDateTimeString => '2015-03-27 11:00:00',    # UTC
        EndDateTimeString   => '2015-03-31 07:00:00',    # UTC
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 15,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 15,
        },
    },

    # The following test checks that adding 2 hours in UTC would normally stay within the start
    # date's working time, but extends to the next day because the used calendar uses
    # time zone Europe/Berlin. So the second hour moves to the next day according to the calendar.
    {
        Name                => '2h via Calendar 9',
        TimeZone            => 'UTC',
        Calendar            => 9,                                           # time zone Europe/Berlin
        StartDateTimeString => '2015-03-26 16:00:00',                       # UTC
        EndDateTimeString   => '2015-03-27 08:00:00',                       # UTC
        WorkingHoursConfig  => $WorkingHours{MonToFri}->{'8To12_14To17'},
        VacationDaysConfig  => \%VacationDays,
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 2,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 2,
        },
    },

    {
        Name                => '5h',
        TimeZone            => 'Europe/Berlin',
        StartDateTimeString => '2015-02-17 22:35:49',
        EndDateTimeString   => '2015-02-18 03:35:49',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => \%VacationDays,
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 5,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 5,
        },
    },
    {
        Name                => '2d 30m',
        TimeZone            => 'Europe/Berlin',
        StartDateTimeString => '2015-02-17 22:35:49',
        EndDateTimeString   => '2015-02-19 23:05:49',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => \%VacationDays,
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 48,
            Minutes         => 30,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 48.5,
        },
    },
    {
        Name                => '2d, DST start',
        TimeZone            => 'Europe/Berlin',
        StartDateTimeString => '2016-03-26 22:24:39',
        EndDateTimeString   => '2016-03-28 23:24:39',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => \%VacationDays,
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 48,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 48,
        },
    },
    {
        Name                => '4d 22h',
        TimeZone            => 'Europe/Berlin',
        StartDateTimeString => '2016-02-01 12:15:41',
        EndDateTimeString   => '2016-02-06 10:15:41',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => \%VacationDays,
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 118,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 118,
        },
    },
    {
        Name                => '1d 21h',
        TimeZone            => 'Europe/Berlin',
        StartDateTimeString => '2016-02-01 12:15:41',
        EndDateTimeString   => '2016-02-06 12:15:41',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'8To12_14To17'},
        VacationDaysConfig  => \%VacationDays,
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 45,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 45,
        },
    },
    {
        Name                => '16h, DST start with specific working hours',
        TimeZone            => 'Europe/Berlin',
        StartDateTimeString => '2016-03-25 12:15:41',
        EndDateTimeString   => '2016-03-29 10:15:41',
        WorkingHoursConfig  => $WorkingHours{MonToFri}->{'8To12_14To17'},
        VacationDaysConfig  => \%VacationDays,
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 16,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 16,
        },
    },
    {
        Name                => '1d 10h,  DST start with specific working hours',
        TimeZone            => 'Europe/Berlin',
        StartDateTimeString => '2016-03-24 12:15:41',
        EndDateTimeString   => '2016-03-30 10:15:41',
        WorkingHoursConfig  => $WorkingHours{MonToFri}->{'8To12_14To17'},
        VacationDaysConfig  => \%VacationDays,
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 34,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 34,
        },
    },
    {
        Name                => '5h',
        TimeZone            => 'Europe/Berlin',
        StartDateTimeString => '2016-03-25 08:15:41',
        EndDateTimeString   => '2016-03-25 14:15:41',
        WorkingHoursConfig  => $WorkingHours{MonToFri}->{'8To12_14To17'},
        VacationDaysConfig  => \%VacationDays,
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 5,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 5,
        },
    },
    {
        Name                => '6h',
        TimeZone            => 'Europe/Berlin',
        StartDateTimeString => '2016-03-25 08:00:00',
        EndDateTimeString   => '2016-03-25 15:00:00',
        WorkingHoursConfig  => $WorkingHours{MonToFri}->{'8To12_14To17'},
        VacationDaysConfig  => \%VacationDays,
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 6,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 6,
        },
    },
    {
        Name                => '90d',
        TimeZone            => 'UTC',
        StartDateTimeString => '2015-02-17 12:00:00',
        EndDateTimeString   => '2015-05-18 12:00:00',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => {},
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 2160,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 24 * 90,
        },
    },
    {
        Name                => '89d 23h, DST start',
        TimeZone            => 'Europe/Berlin',
        StartDateTimeString => '2015-02-17 12:00:00',
        EndDateTimeString   => '2015-05-18 12:00:00',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => {},
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 2159,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 90 * 24 * ( 60 * 60 ) - 1 * ( 60 * 60 ),
        },
    },
    {
        Name                => '6h',
        TimeZone            => 'UTC',
        StartDateTimeString => '2015-02-21 22:00:00',
        EndDateTimeString   => '2015-02-22 04:00:00',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => {},
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 6,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 6,
        },
    },
    {
        Name                => '5h, DST end',
        TimeZone            => 'America/Sao_Paulo',
        StartDateTimeString => '2015-02-21 22:00:00',
        EndDateTimeString   => '2015-02-22 02:00:00',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => {},
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 5,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 5,
        },
    },
    {
        Name                => '4d 6h 20m 15s',
        TimeZone            => 'UTC',
        StartDateTimeString => '2015-02-20 22:10:05',
        EndDateTimeString   => '2015-02-25 04:30:20',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => {},
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 102,
            Minutes         => 20,
            Seconds         => 15,
            AbsoluteSeconds => ( 60 * 60 * 24 * 4 ) + ( 60 * 60 * 6 ) + ( 60 * 20 ) + 15,
        },

    },
    {
        Name                => '4d 7h 20m 15s, DST end',
        TimeZone            => 'America/Sao_Paulo',
        StartDateTimeString => '2015-02-20 22:10:05',
        EndDateTimeString   => '2015-02-25 04:30:20',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => {},
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 103,
            Minutes         => 20,
            Seconds         => 15,
            AbsoluteSeconds => ( 60 * 60 * 24 * 4 ) + ( 60 * 60 * 7 ) + ( 60 * 20 ) + 15,
        },
    },
    {
        Name                => '6h',
        TimeZone            => 'UTC',
        StartDateTimeString => '2015-10-17 22:00:00',
        EndDateTimeString   => '2015-10-18 04:00:00',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => {},
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 6,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 6,
        },
    },
    {
        Name                => '5h, DST start',
        TimeZone            => 'America/Sao_Paulo',
        StartDateTimeString => '2015-10-17 22:00:00',
        EndDateTimeString   => '2015-10-18 04:00:00',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => {},
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 5,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 5,
        },
    },
    {
        Name                => '24h',
        TimeZone            => 'UTC',
        StartDateTimeString => '2015-03-21 12:00:00',
        EndDateTimeString   => '2015-03-22 12:00:00',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => {},
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 24,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 24,
        }
    },
    {
        Name                => '16h',
        TimeZone            => 'UTC',
        StartDateTimeString => '2015-09-21 12:00:00',
        EndDateTimeString   => '2015-09-22 04:00:00',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => {},
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 16,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 16,
        },
    },
    {
        Name                => '17h, DST end',
        TimeZone            => 'Asia/Tehran',
        StartDateTimeString => '2015-09-21 12:00:00',
        EndDateTimeString   => '2015-09-22 04:00:00',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => {},
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 17,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 17,
        },
    },
    {
        Name                => '16h',
        TimeZone            => 'UTC',
        StartDateTimeString => '2015-03-21 12:00:00',
        EndDateTimeString   => '2015-03-22 04:00:00',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => {},
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 16,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 16,
        },
    },
    {
        Name                => '15h, DST start',
        TimeZone            => 'Asia/Tehran',
        StartDateTimeString => '2015-03-21 12:00:00',
        EndDateTimeString   => '2015-03-22 04:00:00',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => {},
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 15,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => 60 * 60 * 15,
        },
    },
    {
        Name                => '90d 16h',
        TimeZone            => 'UTC',
        StartDateTimeString => '2015-01-21 12:00:00',
        EndDateTimeString   => '2015-04-22 04:00:00',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => {},
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 2176,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => ( 60 * 60 * 24 * 90 ) + ( 60 * 60 * 16 ),
        },
    },
    {
        Name                => '90d 17h, DST end',
        TimeZone            => 'Australia/Sydney',
        StartDateTimeString => '2015-01-21 12:00:00',
        EndDateTimeString   => '2015-04-22 04:00:00',
        WorkingHoursConfig  => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig  => {},
        ExpectedResult      => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 2177,
            Minutes         => 0,
            Seconds         => 0,
            AbsoluteSeconds => ( 60 * 60 * 24 * 90 ) + ( 60 * 60 * 17 ),
        },
    },
);

for my $Test (@Tests) {

    if ( defined $Test->{WorkingHoursConfig} ) {
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => 'TimeWorkingHours',
            Value => $Test->{WorkingHoursConfig},
        );
    }

    if ( defined $Test->{VacationDaysConfig} ) {
        $ConfigObject->Set(
            Key   => 'TimeVacationDays',
            Value => $Test->{VacationDaysConfig},
        );
    }

    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => 'OTRSTimeZone',
        Value => $Test->{TimeZone},
    );

    my $StartDateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String   => $Test->{StartDateTimeString},
            TimeZone => $Test->{TimeZone},
        },
    );

    my $StopDateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String   => $Test->{EndDateTimeString},
            TimeZone => $Test->{TimeZone},
        },
    );

    my $Delta = $StartDateTimeObject->Delta(
        DateTimeObject => $StopDateTimeObject,
        ForWorkingTime => 1,
        Calendar       => $Test->{Calendar},
    );

    $Self->Is(
        ref $Delta,
        'HASH',
        $Test->{TimeZone} . ' - ' . $Test->{Name} . ': delta calculation of working time must result in hash ref.',
    );

    if ( ref $Delta && ref $Delta eq 'HASH' ) {
        $Self->IsDeeply(
            $Delta,
            $Test->{ExpectedResult},
            $Test->{TimeZone} . ' - ' . $Test->{Name} . ': calculated working time delta must match expected one.',
        );
    }
}

#
# Test with invalid DateTime object
#
my $DateTimeObject = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        String => '2016-04-06 13:46:00',
    },
);

my $Delta = $DateTimeObject->Delta(
    DateTimeObject => 'No DateTime object but a string',
    ForWorkingTime => 1,
);
$Self->False(
    $Delta,
    'Delta working time calculation with invalid DateTime object must fail.',
);
## nofilter(TidyAll::Plugin::OTRS::Migrations::OTRS6::TimeObject)
$Delta = $DateTimeObject->Delta(
    DateTimeObject => $Kernel::OM->Get('Kernel::System::Time'),
    ForWorkingTime => 1,
);
$Self->False(
    $Delta,
    'Delta working time calculation with invalid DateTime object must fail.',
);

1;
