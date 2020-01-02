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

my @TestConfigs = (
    {
        Name                => '~2 years',
        TimeZone            => 'UTC',
        StartDateTimeString => '2015-02-17 12:00:00',
        WorkingTimeToAdd    => {
            Days => 365 * 2,
        },
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
        ExpectedEndDateTimeString => '2017-02-28 12:00:00',
    },

    # must fail because of not supported parameter 'Years' for working time
    {
        Name                => 'Using parameter Years to add working time - must fail',
        TimeZone            => 'UTC',
        StartDateTimeString => '2015-02-17 12:00:00',
        WorkingTimeToAdd    => {
            Years => 2,    # invalid param
        },
        WorkingHoursConfig => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig => \%VacationDays,
        ExpectedEndDateTimeString => '2015-02-17 12:00:00',    # because of invalid param, date must not be changed
    },

    # must fail because of not negative parameters
    {
        Name                => 'Using negative hours to add working time - must fail',
        TimeZone            => 'UTC',
        StartDateTimeString => '2015-02-17 12:00:00',
        WorkingTimeToAdd    => {
            Hours => -2,                                       # invalid param
        },
        WorkingHoursConfig => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig => \%VacationDays,
        ExpectedEndDateTimeString => '2015-02-17 12:00:00',    # because of invalid param, date must not be changed
    },

    {
        Name                => '15h via Calendar 9',
        TimeZone            => 'UTC',
        Calendar            => 9,                              # time zone Europe/Berlin
        StartDateTimeString => '2015-03-27 11:00:00',          # UTC
        WorkingTimeToAdd    => {
            Hours => 15,
        },
        ExpectedEndDateTimeString => '2015-03-31 07:00:00',    # UTC
    },
    {
        Name                => '90d',
        TimeZone            => 'UTC',
        StartDateTimeString => '2015-02-17 12:00:00',
        WorkingTimeToAdd    => {
            Days => 90,
        },
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
        ExpectedEndDateTimeString => '2015-05-19 12:00:00',
    },
    {
        Name                => '90d 1h, (Daylight Saving Time UTC+1 => UTC+2)',
        StartDateTimeString => '2015-02-17 12:00:00',
        TimeZone            => 'Europe/Berlin',
        WorkingTimeToAdd    => {
            Days  => 90,
            Hours => 1
        },
        ExpectedEndDateTimeString => '2015-05-19 14:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '6h',
        StartDateTimeString       => '2015-02-21 22:00:00',
        TimeZone                  => 'UTC',
        WorkingTimeToAdd          => { Hours => 6 },
        ExpectedEndDateTimeString => '2015-02-22 04:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '5h, end DST from 00 to 23  ( UTC-2 => UTC-3 )',
        StartDateTimeString       => '2015-02-21 22:00:00',
        TimeZone                  => 'America/Sao_Paulo',
        WorkingTimeToAdd          => { Hours => 5 },
        ExpectedEndDateTimeString => '2015-02-22 02:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                => '4d 6h 20m 15s',
        StartDateTimeString => '2015-02-20 22:10:05',
        TimeZone            => 'UTC',
        WorkingTimeToAdd    => {
            Days    => 4,
            Hours   => 6,
            Minutes => 20,
            Seconds => 15
        },
        ExpectedEndDateTimeString => '2015-02-25 04:30:20',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },

    {
        Name                => '4d 5h 20m 15s, end DST from 00 to 23 - with min and sec ( UTC-2 => UTC-3 )',
        StartDateTimeString => '2015-02-21 22:10:05',
        TimeZone            => 'America/Sao_Paulo',
        WorkingTimeToAdd    => {
            Days    => 4,
            Hours   => 5,
            Minutes => 20,
            Seconds => 15
        },
        ExpectedEndDateTimeString => '2015-02-26 02:30:20',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => {},
    },
    {
        Name                      => '6h',
        StartDateTimeString       => '2015-10-17 22:00:00',
        TimeZone                  => 'UTC',
        WorkingTimeToAdd          => { Hours => 6 },
        ExpectedEndDateTimeString => '2015-10-18 04:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '7h, start DST from 00 to 01 ( UTC-3 => UTC-2 )',
        StartDateTimeString       => '2015-10-17 22:00:00',
        TimeZone                  => 'America/Sao_Paulo',
        WorkingTimeToAdd          => { Hours => 7 },
        ExpectedEndDateTimeString => '2015-10-18 06:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '1d',
        StartDateTimeString       => '2015-03-21 12:00:00',
        TimeZone                  => 'UTC',
        WorkingTimeToAdd          => { Days => 1 },
        ExpectedEndDateTimeString => '2015-03-22 12:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '16h',
        StartDateTimeString       => '2015-09-21 12:00:00',
        TimeZone                  => 'UTC',
        WorkingTimeToAdd          => { Hours => 16 },
        ExpectedEndDateTimeString => '2015-09-22 04:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '15h, end DST from 00 to 23  ( UTC+3:30 => UTC+4:30 )',
        StartDateTimeString       => '2015-09-21 12:00:00',
        TimeZone                  => 'Asia/Tehran',
        WorkingTimeToAdd          => { Hours => 15 },
        ExpectedEndDateTimeString => '2015-09-22 02:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '2d, end DST from 00 to 23  ( UTC+3:30 => UTC+4:30 )',
        StartDateTimeString       => '2015-09-20 12:00:00',
        TimeZone                  => 'Asia/Tehran',
        WorkingTimeToAdd          => { Hours => 48 },
        ExpectedEndDateTimeString => '2015-09-22 11:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '2d, end DST from 00 to 23  ( UTC+3:30 => UTC+4:30 )',
        StartDateTimeString       => '2015-09-19 12:00:00',
        TimeZone                  => 'Asia/Tehran',
        WorkingTimeToAdd          => { Hours => 96 },
        ExpectedEndDateTimeString => '2015-09-23 11:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '16h',
        StartDateTimeString       => '2015-03-21 12:00:00',
        TimeZone                  => 'UTC',
        WorkingTimeToAdd          => { Hours => 16 },
        ExpectedEndDateTimeString => '2015-03-22 04:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '17h, start DST from 00 to 01  ( UTC+4:30 => UTC+3:30 )',
        StartDateTimeString       => '2015-03-21 12:00:00',
        TimeZone                  => 'Asia/Tehran',
        WorkingTimeToAdd          => { Hours => 17 },
        ExpectedEndDateTimeString => '2015-03-22 06:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                => '90d 17h, start DST from 00 to 01  ( UTC+4:30 => UTC+3:30 )',
        StartDateTimeString => '2015-01-21 12:00:00',
        TimeZone            => 'Asia/Tehran',
        WorkingTimeToAdd    => {
            Days  => 90,
            Hours => 17
        },
        ExpectedEndDateTimeString => '2015-04-22 06:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                => '90d 16h',
        StartDateTimeString => '2015-01-21 12:00:00',
        TimeZone            => 'UTC',
        WorkingTimeToAdd    => {
            Days  => 90,
            Hours => 16
        },
        ExpectedEndDateTimeString => '2015-04-22 04:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                => '1d 17h, end DST from 00 to 01  ( UTC+11 => UTC+10 )',
        StartDateTimeString => '2016-04-02 12:00:00',
        TimeZone            => 'Australia/Sydney',
        WorkingTimeToAdd    => {
            Days  => 1,
            Hours => 17
        },
        ExpectedEndDateTimeString => '2016-04-04 04:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '5h',
        StartDateTimeString       => '2016-01-31 12:25:30',
        TimeZone                  => 'Europe/Berlin',
        WorkingTimeToAdd          => { Hours => 5 },
        ExpectedEndDateTimeString => '2016-02-01 13:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToFri}->{'8To17'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '3.5h',
        StartDateTimeString       => '2016-02-01 16:59:30',
        TimeZone                  => 'Europe/Berlin',
        WorkingTimeToAdd          => { Hours => 3.5 },
        ExpectedEndDateTimeString => '2016-02-02 10:29:30',
        WorkingHoursConfig        => $WorkingHours{MonToFri}->{'8To17'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '5h',
        StartDateTimeString       => '2016-02-01 12:25:30',
        TimeZone                  => 'Europe/Berlin',
        WorkingTimeToAdd          => { Hours => 5 },
        ExpectedEndDateTimeString => '2016-02-02 08:25:30',
        WorkingHoursConfig        => $WorkingHours{MonToFri}->{'8To12_14To17'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                => '45h 25m 30s',
        StartDateTimeString => '2016-01-31 12:25:30',
        TimeZone            => 'Europe/Berlin',
        WorkingTimeToAdd    => {
            Hours   => 45,
            Minutes => 25,
            Seconds => 30
        },
        ExpectedEndDateTimeString => '2016-02-08 08:25:30',
        WorkingHoursConfig        => $WorkingHours{MonToFri}->{'8To12_14To17'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '20h',
        StartDateTimeString       => '2015-12-22 16:24:49',
        TimeZone                  => 'Europe/Berlin',
        WorkingTimeToAdd          => { Hours => 20 },
        ExpectedEndDateTimeString => '2015-12-29 08:24:49',
        WorkingHoursConfig        => $WorkingHours{MonToFri}->{'8To12_14To17'},
        VacationDaysConfig        => \%VacationDays,
    },

    {
        Name                      => '5h, start DST from 00 to 01  ( UTC+4:30 => UTC+3:30 )',
        StartDateTimeString       => '2016-03-20 00:00:00',
        TimeZone                  => 'Asia/Tehran',
        WorkingTimeToAdd          => { Hours => 5 },
        ExpectedEndDateTimeString => '2016-03-21 13:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToFri}->{'8To17'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '13h, start DST from 00 to 01  ( UTC+4:30 => UTC+3:30 )',
        StartDateTimeString       => '2016-03-20 00:00:00',
        TimeZone                  => 'Asia/Tehran',
        WorkingTimeToAdd          => { Hours => 13 },
        ExpectedEndDateTimeString => '2016-03-22 11:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToFri}->{'8To17'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                => '1d 5h, start DST from 00 to 01  ( UTC+4:30 => UTC+3:30 )',
        StartDateTimeString => '2016-03-20 00:00:00',
        TimeZone            => 'Asia/Tehran',
        WorkingTimeToAdd    => {
            Days  => 1,
            Hours => 5
        },
        ExpectedEndDateTimeString => '2016-03-21 06:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToSun}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                => '1d 5h, start DST from 00 to 01  ( UTC+4:30 => UTC+3:30 )',
        StartDateTimeString => '2016-03-20 00:00:00',
        TimeZone            => 'Asia/Tehran',
        WorkingTimeToAdd    => {
            Days  => 1,
            Hours => 5
        },
        ExpectedEndDateTimeString => '2016-03-22 06:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToFri}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '5h, end DST from 00 to 23  ( UTC+3:30 => UTC+4:30 )',
        StartDateTimeString       => '2016-09-20 22:00:00',
        TimeZone                  => 'Asia/Tehran',
        WorkingTimeToAdd          => { Hours => 5 },
        ExpectedEndDateTimeString => '2016-09-21 13:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToFri}->{'8To17'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '5h, end DST from 00 to 23  ( UTC+3:30 => UTC+4:30 )',
        StartDateTimeString       => '2016-09-20 22:00:00',
        TimeZone                  => 'Asia/Tehran',
        WorkingTimeToAdd          => { Hours => 5 },
        ExpectedEndDateTimeString => '2016-09-21 02:00:00',
        WorkingHoursConfig        => $WorkingHours{MonToFri}->{'0To23'},
        VacationDaysConfig        => \%VacationDays,
    },
    {
        Name                      => '1m',
        StartDateTimeString       => '2013-03-16 10:00:00',
        TimeZone                  => 'Europe/Berlin',
        WorkingTimeToAdd          => { Minutes => 1 },
        TimeDate                  => '1m',
        ExpectedEndDateTimeString => '2013-03-18 08:01:00',
        WorkingHoursConfig        => $WorkingHours{MonToFri}->{'8To17'},
        VacationDaysConfig        => \%VacationDays,
    },
);

for my $TestConfig (@TestConfigs) {

    if ( defined $TestConfig->{WorkingHoursConfig} ) {
        $ConfigObject->Set(
            Key   => 'TimeWorkingHours',
            Value => $TestConfig->{WorkingHoursConfig},
        );
    }

    if ( defined $TestConfig->{VacationDaysConfig} ) {
        $ConfigObject->Set(
            Key   => 'TimeVacationDays',
            Value => $TestConfig->{VacationDaysConfig},
        );
    }

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String   => $TestConfig->{StartDateTimeString},
            TimeZone => $TestConfig->{TimeZone},
        },
    );

    $DateTimeObject->Add(
        %{ $TestConfig->{WorkingTimeToAdd} },
        AsWorkingTime => 1,
        Calendar      => $TestConfig->{Calendar},
    );

    $Self->Is(
        $DateTimeObject->ToString(),
        $TestConfig->{ExpectedEndDateTimeString},
        $TestConfig->{TimeZone} . ' - ' . $TestConfig->{Name} . ': calculated end date must match expected one.',
    );
}

# Tests for failing calls to Add()
my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
@TestConfigs = (
    {
        Name   => 'without parameters',
        Params => {
            AsWorkingTime => 1,
        },
    },
    {
        Name   => 'with invalid seconds',
        Params => {
            AsWorkingTime => 1,
            Seconds       => 'invalid',
        },
    },
    {
        Name   => 'with valid minutes and invalid days',
        Params => {
            AsWorkingTime => 1,
            Minutes       => 4,
            Days          => 'invalid',
        },
    },
    {
        Name   => 'with unsupported parameter',
        Params => {
            AsWorkingTime        => 1,
            UnsupportedParameter => 2,
        },
    },
    {
        Name   => 'with unsupported parameter and valid years',
        Params => {
            AsWorkingTime        => 1,
            UnsupportedParameter => 2,
            Years                => 1,
        },
    },
);

for my $TestConfig (@TestConfigs) {
    my $DateTimeObjectClone = $DateTimeObject->Clone();
    my $Result              = $DateTimeObjectClone->Add( %{ $TestConfig->{Params} } );
    $Self->False(
        $Result,
        "Add() $TestConfig->{Name} must fail.",
    );

    $Self->IsDeeply(
        $DateTimeObjectClone->Get(),
        $DateTimeObject->Get(),
        'DateTime object must be unchanged after failed Add().',
    );
}

1;
