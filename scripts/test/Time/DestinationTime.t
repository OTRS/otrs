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
    $WorkingHours{MonToSun}->{'0To23'}->{$Day} = [ 0 .. 23 ];
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
    {
        Name            => 'UTC',
        TimeStampStart  => '2015-02-17 12:00:00',
        OTRSTimeZone    => 'UTC',
        Time            => 60 * 60 * 24 * 365 * 2,               # ca. 2 years
        TimeDate        => '2 years',
        DestinationTime => '2017-02-28 12:00:00',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'UTC',
        TimeStampStart  => '2015-02-17 12:00:00',
        OTRSTimeZone    => 'UTC',
        Time            => 60 * 60 * 24 * 90,                    # 90 days, contains 05-01 vacation day
        TimeDate        => '90 days',
        DestinationTime => '2015-05-19 12:00:00',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name           => 'Europe/Berlin ( Daylight Saving Time UTC+1 => UTC+2 )',
        TimeStampStart => '2015-02-17 12:00:00',
        OTRSTimeZone   => 'Europe/Berlin',
        Time           => 60 * 60 * 24 * 90 + 60 * 60,
        TimeDate        => '90 days and 1h',                     # 90 days and 1h, contains 05-01 vacation day
        DestinationTime => '2015-05-19 14:00:00',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'UTC',
        TimeStampStart  => '2015-02-21 22:00:00',
        OTRSTimeZone    => 'UTC',
        Time            => 60 * 60 * 6,                          # 6h
        TimeDate        => '6h',
        DestinationTime => '2015-02-22 04:00:00',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'America/Sao_Paulo - end DST from 00 to 23  ( UTC-2 => UTC-3 )',
        TimeStampStart  => '2015-02-21 22:00:00',
        OTRSTimeZone    => 'America/Sao_Paulo',
        Time            => 60 * 60 * 5,                                                       # 5h
        TimeDate        => '5h',
        DestinationTime => '2015-02-22 02:00:00',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'UTC with min and sec',
        TimeStampStart  => '2015-02-20 22:10:05',
        OTRSTimeZone    => 'UTC',
        Time            => 60 * 60 * 24 * 4 + 60 * 60 * 6 + 60 * 20 + 15,                     # 4 days 06:20:15
        TimeDate        => '4 days 06:20:15',
        DestinationTime => '2015-02-25 04:30:20',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name           => 'America/Sao_Paulo - end DST from 00 to 23 - with min and sec ( UTC-2 => UTC-3 )',
        TimeStampStart => '2015-02-21 22:10:05',
        OTRSTimeZone   => 'America/Sao_Paulo',
        Time            => 60 * 60 * 24 * 4 + 60 * 60 * 5 + 60 * 20 + 15,                     # 4 days 05:20:15
        TimeDate        => '4 days 05:20:15',
        DestinationTime => '2015-02-26 02:30:20',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => {},
    },
    {
        Name            => 'UTC',
        TimeStampStart  => '2015-10-17 22:00:00',
        OTRSTimeZone    => 'UTC',
        Time            => 60 * 60 * 6,                                                       # 6h
        TimeDate        => '6h',
        DestinationTime => '2015-10-18 04:00:00',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'America/Sao_Paulo - start DST from 00 to 01 ( UTC-3 => UTC-2 )',
        TimeStampStart  => '2015-10-17 22:00:00',
        OTRSTimeZone    => 'America/Sao_Paulo',
        Time            => 60 * 60 * 7,                                                        # 7h
        TimeDate        => '7h',
        DestinationTime => '2015-10-18 06:00:00',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'UTC',
        TimeStampStart  => '2015-03-21 12:00:00',
        OTRSTimeZone    => 'UTC',
        Time            => 60 * 60 * 24,                                                       # 24h
        TimeDate        => '24h',
        DestinationTime => '2015-03-22 12:00:00',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'UTC',
        TimeStampStart  => '2015-09-21 12:00:00',
        OTRSTimeZone    => 'UTC',
        Time            => 60 * 60 * 16,                                                       # 16h
        TimeDate        => '16h',
        DestinationTime => '2015-09-22 04:00:00',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Asia/Tehran - end DST from 00 to 23  ( UTC+3:30 => UTC+4:30 )',
        TimeStampStart  => '2015-09-21 12:00:00',
        OTRSTimeZone    => 'Asia/Tehran',
        Time            => 60 * 60 * 15,                                                       # 15h
        TimeDate        => '15h',
        DestinationTime => '2015-09-22 02:00:00',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'UTC',
        TimeStampStart  => '2015-03-21 12:00:00',
        OTRSTimeZone    => 'UTC',
        Time            => 60 * 60 * 16,                                                       # 16h
        TimeDate        => '16h',
        DestinationTime => '2015-03-22 04:00:00',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Asia/Tehran - start DST from 00 to 01  ( UTC+4:30 => UTC+3:30 )',
        TimeStampStart  => '2015-03-21 12:00:00',
        OTRSTimeZone    => 'Asia/Tehran',
        Time            => 60 * 60 * 17,                                                        # 17h
        TimeDate        => '17h',
        DestinationTime => '2015-03-22 06:00:00',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Asia/Tehran - start DST from 00 to 01  ( UTC+4:30 => UTC+3:30 )',
        TimeStampStart  => '2015-01-21 12:00:00',
        OTRSTimeZone    => 'Asia/Tehran',
        Time            => 60 * 60 * 24 * 90 + 60 * 60 * 17,                                    # 90 days and 17h
        TimeDate        => '90 days and 17h',
        DestinationTime => '2015-04-22 06:00:00',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'UTC',
        TimeStampStart  => '2015-01-21 12:00:00',
        OTRSTimeZone    => 'UTC',
        Time            => 60 * 60 * 24 * 90 + 60 * 60 * 16,                                    # 90 days and 16h
        TimeDate        => '90 days and 16h',
        DestinationTime => '2015-04-22 04:00:00',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Australia/Sydney - end DST from 00 to 01  ( UTC+11 => UTC+10 )',
        TimeStampStart  => '2016-04-02 12:00:00',
        OTRSTimeZone    => 'Australia/Sydney',
        Time            => ( 60 * 60 * 24 * 1 ) + ( 60 * 60 * 17 ),
        TimeDate        => '1d 17h',
        DestinationTime => '2016-04-04 04:00:00',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Europe/Berlin - Mon to Fri, 8 to 17',
        TimeStampStart  => '2016-01-31 12:25:30',
        OTRSTimeZone    => 'Europe/Berlin',
        Time            => 60 * 60 * 5,                             # 5h
        TimeDate        => '5h',
        DestinationTime => '2016-02-01 13:00:00',
        WorkingHours    => $WorkingHours{MonToFri}->{'8To17'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Europe/Berlin - Mon to Fri, 8 to 17',
        TimeStampStart  => '2016-02-01 16:59:30',
        OTRSTimeZone    => 'Europe/Berlin',
        Time            => 60 * 60 * 3.5,                           # 3.5h
        TimeDate        => '3.5h',
        DestinationTime => '2016-02-02 10:29:30',
        WorkingHours    => $WorkingHours{MonToFri}->{'8To17'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Europe/Berlin - Mon to Fri, 8 to 12 and 14 to 17',
        TimeStampStart  => '2016-02-01 12:25:30',
        OTRSTimeZone    => 'Europe/Berlin',
        Time            => 60 * 60 * 5,                                          # 5h
        TimeDate        => '5h',
        DestinationTime => '2016-02-02 08:25:30',
        WorkingHours    => $WorkingHours{MonToFri}->{'8To12_14To17'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Europe/Berlin - Mon to Fri, 8 to 12 and 14 to 17',
        TimeStampStart  => '2015-12-22 16:24:49',
        OTRSTimeZone    => 'Europe/Berlin',
        Time            => 60 * 60 * 20,                                         # 20h
        TimeDate        => '20h',
        DestinationTime => '2015-12-29 08:24:49',
        WorkingHours    => $WorkingHours{MonToFri}->{'8To12_14To17'},
        VacationDays    => \%VacationDays,
    },

    {
        Name            => 'Asia/Tehran - start DST from 00 to 01  ( UTC+4:30 => UTC+3:30 )',
        TimeStampStart  => '2016-03-20 00:00:00',
        OTRSTimeZone    => 'Asia/Tehran',
        Time            => 60 * 60 * 5,
        TimeDate        => '5h',
        DestinationTime => '2016-03-21 13:00:00',
        WorkingHours    => $WorkingHours{MonToFri}->{'8To17'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Asia/Tehran - start DST from 00 to 01  ( UTC+4:30 => UTC+3:30 )',
        TimeStampStart  => '2016-03-20 00:00:00',
        OTRSTimeZone    => 'Asia/Tehran',
        Time            => 60 * 60 * 13,
        TimeDate        => '13h',
        DestinationTime => '2016-03-22 11:00:00',
        WorkingHours    => $WorkingHours{MonToFri}->{'8To17'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Asia/Tehran - start DST from 00 to 01  ( UTC+4:30 => UTC+3:30 )',
        TimeStampStart  => '2016-03-20 00:00:00',
        OTRSTimeZone    => 'Asia/Tehran',
        Time            => ( 60 * 60 * 24 * 1 ) + ( 60 * 60 * 5 ),
        TimeDate        => '1d 5h',
        DestinationTime => '2016-03-21 06:00:00',
        WorkingHours    => $WorkingHours{MonToSun}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Asia/Tehran - start DST from 00 to 01  ( UTC+4:30 => UTC+3:30 )',
        TimeStampStart  => '2016-03-20 00:00:00',
        OTRSTimeZone    => 'Asia/Tehran',
        Time            => ( 60 * 60 * 24 * 1 ) + ( 60 * 60 * 5 ),
        TimeDate        => '1d 5h',
        DestinationTime => '2016-03-22 06:00:00',
        WorkingHours    => $WorkingHours{MonToFri}->{'0To23'},
        VacationDays    => \%VacationDays,
    },

    {
        Name            => 'Asia/Tehran - end DST from 00 to 23  ( UTC+3:30 => UTC+4:30 )',
        TimeStampStart  => '2016-09-20 22:00:00',
        OTRSTimeZone    => 'Asia/Tehran',
        Time            => 60 * 60 * 5,
        TimeDate        => '5h',
        DestinationTime => '2016-09-21 13:00:00',
        WorkingHours    => $WorkingHours{MonToFri}->{'8To17'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Asia/Tehran - end DST from 00 to 23  ( UTC+3:30 => UTC+4:30 )',
        TimeStampStart  => '2016-09-20 22:00:00',
        OTRSTimeZone    => 'Asia/Tehran',
        Time            => 60 * 60 * 5,
        TimeDate        => '5h',
        DestinationTime => '2016-09-21 02:00:00',
        WorkingHours    => $WorkingHours{MonToFri}->{'0To23'},
        VacationDays    => \%VacationDays,
    },
    {
        Name            => 'Europe/Berlin - Weekend',
        TimeStampStart  => '2013-03-16 10:00:00',
        OTRSTimeZone    => 'Europe/Berlin',
        Time            => 60 * 1,
        TimeDate        => '1m',
        DestinationTime => '2013-03-18 08:01:00',
        WorkingHours    => $WorkingHours{MonToFri}->{'8To17'},
        VacationDays    => \%VacationDays,
    },

    # test for calendar 9
    {
        Name => 'OTRS time zone UTC, Calendar 9 time zone Europe/Berlin ( Daylight Saving Time UTC+1 => UTC+2 )',
        TimeStampStart  => '2015-03-27 11:00:00',    # UTC
        OTRSTimeZone    => 'UTC',
        Calendar        => 9,
        Time            => 60 * 60 * 15,             # Cal. 9 has 9 hours per day, Mon - Fri
        TimeDate        => '15h',                    # 90 days and 1h, contains 05-01 vacation day
        DestinationTime => '2015-03-31 07:00:00',    # UTC
    },
);

for my $Test (@Tests) {

    if ( defined $Test->{WorkingHours} ) {
        $ConfigObject->Set(
            Key   => 'TimeWorkingHours',
            Value => $Test->{WorkingHours},
        );
    }

    if ( defined $Test->{VacationDays} ) {
        $ConfigObject->Set(
            Key   => 'TimeVacationDays',
            Value => $Test->{VacationDays},
        );
    }

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
        String => $Test->{TimeStampStart},
    );

    my $DestinationTime = $TimeObject->DestinationTime(
        StartTime => $StartTime,
        Time      => $Test->{Time},
        Calendar  => $Test->{Calendar},
    );

    my $DestinationTimeStamp = $TimeObject->SystemTime2TimeStamp(
        SystemTime => $DestinationTime,
    );

    $Self->Is(
        $DestinationTimeStamp,
        $Test->{DestinationTime},
        "$Test->{Name} ($Test->{OTRSTimeZone}) destination time ($Test->{TimeDate}) from $Test->{TimeStampStart}: ($Test->{DestinationTime})",
    );
}

1;
