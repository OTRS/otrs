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

my @Tests = (

    {
        Name            => 'Europe/Berlin - 2d 8h 59m 59s',
        StartDateString => '2015-12-23 08:10:15',
        StopDateString  => '2015-12-28 17:10:14',
        OTRSTimeZone    => 'Europe/Berlin',
        Result          => 205199,
        ResultTime      => '2d 8h 59m 59s',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Europe/Berlin - 5 hours',
        StartDateString => '2015-02-17 22:35:49',
        StopDateString  => '2015-02-18 03:35:49',
        OTRSTimeZone    => 'Europe/Berlin',
        Result          => 60 * 60 * 5,
        ResultTime      => '5h',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Europe/Berlin - 48.5 hours',
        StartDateString => '2015-02-17 22:35:49',
        StopDateString  => '2015-02-19 23:05:49',
        OTRSTimeZone    => 'Europe/Berlin',
        Result          => 60 * 60 * 48.5,
        ResultTime      => '48.5h',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Europe/Berlin - DST start',
        StartDateString => '2016-03-26 22:24:39',
        StopDateString  => '2016-03-28 23:24:39',
        OTRSTimeZone    => 'Europe/Berlin',
        Result          => 60 * 60 * 48,
        ResultTime      => '48h',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Europe/Berlin - 24/7',
        StartDateString => '2016-02-01 12:15:41',
        StopDateString  => '2016-02-06 10:15:41',
        OTRSTimeZone    => 'Europe/Berlin',
        Result          => 60 * 60 * 118,
        ResultTime      => '118h',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Europe/Berlin - 7 days a week, 8 to 12 and 14 to 17',
        StartDateString => '2016-02-01 12:15:41',
        StopDateString  => '2016-02-06 12:15:41',
        OTRSTimeZone    => 'Europe/Berlin',
        Result          => 60 * 60 * 45,
        ResultTime      => '45h',
        WorkingHours    => $WorkingHours{MonToSun}->{'8To12_14To17'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Europe/Berlin - DST start with specific working hours',
        StartDateString => '2016-03-25 12:15:41',
        StopDateString  => '2016-03-29 10:15:41',
        OTRSTimeZone    => 'Europe/Berlin',
        Result          => 60 * 60 * 16,
        ResultTime      => '16h',
        WorkingHours    => $WorkingHours{MonToFri}->{'8To12_14To17'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Europe/Berlin - DST start with specific working hours',
        StartDateString => '2016-03-24 12:15:41',
        StopDateString  => '2016-03-30 10:15:41',
        OTRSTimeZone    => 'Europe/Berlin',
        Result          => 60 * 60 * 34,
        ResultTime      => '34h',
        WorkingHours    => $WorkingHours{MonToFri}->{'8To12_14To17'},
        VacationDays    => \%VacationDays,
    },

    {
        Name            => 'Europe/Berlin - specific working hours',
        StartDateString => '2016-03-25 08:15:41',
        StopDateString  => '2016-03-25 14:15:41',
        OTRSTimeZone    => 'Europe/Berlin',
        Result          => 60 * 60 * 5,
        ResultTime      => '5h',
        WorkingHours    => $WorkingHours{MonToFri}->{'8To12_14To17'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Europe/Berlin - specific working hours',
        StartDateString => '2016-03-25 08:00:00',
        StopDateString  => '2016-03-25 15:00:00',
        OTRSTimeZone    => 'Europe/Berlin',
        Result          => 60 * 60 * 6,
        ResultTime      => '6h',
        WorkingHours    => $WorkingHours{MonToFri}->{'8To12_14To17'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'UTC',
        StartDateString => '2015-02-17 12:00:00',
        StopDateString  => '2015-05-18 12:00:00',
        OTRSTimeZone    => 'UTC',
        Result          => '7776000',                            # 90 days
        ResultTime      => '90 days',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => {},
    },
    {
        Name            => 'Europe/Berlin ( Daylight Saving Time UTC+1 => UTC+2 )',
        StartDateString => '2015-02-17 12:00:00',
        StopDateString  => '2015-05-18 12:00:00',
        OTRSTimeZone    => 'Europe/Berlin',
        Result          => 90 * 24 * ( 60 * 60 ) - 1 * ( 60 * 60 ),                   # 90 days minus 1h
        ResultTime      => '90 days and 1h',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => {},
    },
    {
        Name            => 'UTC',
        StartDateString => '2015-02-21 22:00:00',
        StopDateString  => '2015-02-22 04:00:00',
        OTRSTimeZone    => 'UTC',
        Result          => '21600',                                                   # 6h
        ResultTime      => '6h',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => {},
    },
    {
        Name            => 'America/Sao_Paulo - end DST from 00 to 23  ( UTC-2 => UTC-3 )',
        StartDateString => '2015-02-21 22:00:00',
        StopDateString  => '2015-02-22 02:00:00',
        OTRSTimeZone    => 'America/Sao_Paulo',
        Result          => '18000',                                                           # 5h
        ResultTime      => '5h',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => {},
    },
    {
        Name            => 'UTC with min and sec',
        StartDateString => '2015-02-20 22:10:05',
        StopDateString  => '2015-02-25 04:30:20',
        OTRSTimeZone    => 'UTC',
        Result          => '368415',                                                          # 4 days 06:20:15
        ResultTime      => '4 days 06:20:15',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => {},
    },
    {
        Name            => 'America/Sao_Paulo - end DST from 00 to 23 - with min and sec',
        StartDateString => '2015-02-20 22:10:05',
        StopDateString  => '2015-02-25 04:30:20',
        OTRSTimeZone    => 'America/Sao_Paulo',
        Result          => '372015',                                                          # 4 days 07:20:15
        ResultTime      => '4 days 07:20:15',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => {},
    },
    {
        Name            => 'UTC',
        StartDateString => '2015-10-17 22:00:00',
        StopDateString  => '2015-10-18 04:00:00',
        OTRSTimeZone    => 'UTC',
        Result          => '21600',                                                           # 6h
        ResultTime      => '6h',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => {},
    },
    {
        Name            => 'America/Sao_Paulo - start DST from 00 to 01 ( UTC-3 => UTC-2 )',
        StartDateString => '2015-10-17 22:00:00',
        StopDateString  => '2015-10-18 04:00:00',
        OTRSTimeZone    => 'America/Sao_Paulo',
        Result          => '18000',                                                            # 5h
        ResultTime      => '5h',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => {},
    },
    {
        Name            => 'UTC',
        StartDateString => '2015-03-21 12:00:00',
        StopDateString  => '2015-03-22 12:00:00',
        OTRSTimeZone    => 'UTC',
        Result          => '86400',                                                            # 24h
        ResultTime      => '24h',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => {},
    },
    {
        Name            => 'UTC',
        StartDateString => '2015-09-21 12:00:00',
        StopDateString  => '2015-09-22 04:00:00',
        OTRSTimeZone    => 'UTC',
        Result          => '57600',                                                            # 16h
        ResultTime      => '16h',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => {},
    },
    {
        Name            => 'Asia/Tehran - end DST from 00 to 23  ( UTC+3:30 => UTC+4:30 )',
        StartDateString => '2015-09-21 12:00:00',
        StopDateString  => '2015-09-22 04:00:00',
        OTRSTimeZone    => 'Asia/Tehran',
        Result          => '61200',                                                            # 17h
        ResultTime      => '17h',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => {},
    },
    {
        Name            => 'UTC',
        StartDateString => '2015-03-21 12:00:00',
        StopDateString  => '2015-03-22 04:00:00',
        OTRSTimeZone    => 'UTC',
        Result          => '57600',                                                            # 16h
        ResultTime      => '16h',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => {},
    },
    {
        Name            => 'Asia/Tehran - start DST from 00 to 01  ( UTC+4:30 => UTC+3:30 )',
        StartDateString => '2015-03-21 12:00:00',
        StopDateString  => '2015-03-22 04:00:00',
        OTRSTimeZone    => 'Asia/Tehran',
        Result          => '54000',                                                             # 15h
        ResultTime      => '15h',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => {},
    },
    {
        Name            => 'UTC',
        StartDateString => '2015-01-21 12:00:00',
        StopDateString  => '2015-04-22 04:00:00',
        OTRSTimeZone    => 'UTC',
        Result          => '7833600',                                                           # 90 days and 16h
        ResultTime      => '90 days and 16h',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => {},
    },
    {
        Name            => 'Australia/Sydney - end DST from 00 to 01  ( UTC+11 => UTC+10 )',
        StartDateString => '2015-01-21 12:00:00',
        StopDateString  => '2015-04-22 04:00:00',
        OTRSTimeZone    => 'Australia/Sydney',
        Result          => '7837200',                                                           # 90 days and 17h
        ResultTime      => '90 days and 17h',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => {},
    },
);

for my $Test (@Tests) {

    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => 'TimeWorkingHours',
        Value => $Test->{WorkingHours},
    );

    $ConfigObject->Set(
        Key   => 'TimeVacationDays',
        Value => $Test->{VacationDays},
    );

    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => 'OTRSTimeZone',
        Value => $Test->{OTRSTimeZone},
    );

    # Discard time object because of changed time zone
    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::System::Time', ],
    );
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    my $StartTime = $TimeObject->TimeStamp2SystemTime(
        String => $Test->{StartDateString},
    );

    my $StopTime = $TimeObject->TimeStamp2SystemTime(
        String => $Test->{StopDateString},
    );

    my $WorkingTime = $TimeObject->WorkingTime(
        StartTime => $StartTime,
        StopTime  => $StopTime,
    );

    $Self->Is(
        $WorkingTime,
        $Test->{Result},
        "$Test->{Name} ($Test->{OTRSTimeZone}) working time from $Test->{StartDateString} to $Test->{StopDateString}: $WorkingTime ($Test->{ResultTime})",
    );
}

1;
