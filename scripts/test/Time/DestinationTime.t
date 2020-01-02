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

use Time::Local;

use vars (qw($Self));

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my @Tests = (
    {
        Name            => 'UTC',
        TimeStampStart  => '2015-02-17 12:00:00',
        ServerTZ        => 'UTC',
        Time            => 60 * 60 * 24 * 90,       # 90 days
        TimeDate        => '90 days',
        DestinationTime => '2015-05-18 12:00:00',
    },
    {
        Name            => 'Europe/Berlin ( Daylight Saving Time UTC+1 => UTC+2 )',
        TimeStampStart  => '2015-02-17 12:00:00',
        ServerTZ        => 'Europe/Berlin',
        Time            => 60 * 60 * 24 * 90 + 60 * 60,
        TimeDate        => '90 days and 1h',                                          # 90 days and 1h
        DestinationTime => '2015-05-18 13:00:00',
    },
    {
        Name            => 'UTC',
        TimeStampStart  => '2015-02-21 22:00:00',
        ServerTZ        => 'UTC',
        Time            => 60 * 60 * 6,                                               # 6h
        TimeDate        => '6h',
        DestinationTime => '2015-02-22 04:00:00',
    },
    {
        Name            => 'America/Sao_Paulo - end DST from 00 to 23  ( UTC-2 => UTC-3 )',
        TimeStampStart  => '2015-02-21 22:00:00',
        ServerTZ        => 'America/Sao_Paulo',
        Time            => 60 * 60 * 5,                                                       # 5h
        TimeDate        => '5h',
        DestinationTime => '2015-02-22 02:00:00',
    },
    {
        Name            => 'UTC with min and sec',
        TimeStampStart  => '2015-02-20 22:10:05',
        ServerTZ        => 'UTC',
        Time            => 60 * 60 * 24 * 4 + 60 * 60 * 6 + 60 * 20 + 15,                     # 4 days 06:20:15
        TimeDate        => '4 days 06:20:15',
        DestinationTime => '2015-02-25 04:30:20',
    },
    {
        Name           => 'America/Sao_Paulo - end DST from 00 to 23 - with min and sec ( UTC-2 => UTC-3 )',
        TimeStampStart => '2015-02-21 22:10:05',
        ServerTZ       => 'America/Sao_Paulo',
        Time            => 60 * 60 * 24 * 4 + 60 * 60 * 5 + 60 * 20 + 15,                     # 4 days 05:20:15
        TimeDate        => '4 days 05:20:15',
        DestinationTime => '2015-02-26 02:30:20',
    },
    {
        Name            => 'UTC',
        TimeStampStart  => '2015-10-17 22:00:00',
        ServerTZ        => 'UTC',
        Time            => 60 * 60 * 6,                                                       # 6h
        TimeDate        => '6h',
        DestinationTime => '2015-10-18 04:00:00',
    },
    {
        Name            => 'America/Sao_Paulo - start DST from 00 to 01 ( UTC-3 => UTC-2 )',
        TimeStampStart  => '2015-10-17 22:00:00',
        ServerTZ        => 'America/Sao_Paulo',
        Time            => 60 * 60 * 7,                                                        # 7h
        TimeDate        => '7h',
        DestinationTime => '2015-10-18 06:00:00',
    },
    {
        Name            => 'UTC',
        TimeStampStart  => '2015-03-21 12:00:00',
        ServerTZ        => 'UTC',
        Time            => 60 * 60 * 24,                                                       # 24h
        TimeDate        => '24h',
        DestinationTime => '2015-03-22 12:00:00',
    },
    {
        Name            => 'UTC',
        TimeStampStart  => '2015-09-21 12:00:00',
        ServerTZ        => 'UTC',
        Time            => 60 * 60 * 16,                                                       # 16h
        TimeDate        => '16h',
        DestinationTime => '2015-09-22 04:00:00',
    },
    {
        Name            => 'Asia/Tehran - end DST from 00 to 23  ( UTC+3:30 => UTC+4:30 )',
        TimeStampStart  => '2015-09-21 12:00:00',
        ServerTZ        => 'Asia/Tehran',
        Time            => 60 * 60 * 15,                                                       # 15h
        TimeDate        => '15h',
        DestinationTime => '2015-09-22 02:00:00',
    },
    {
        Name            => 'UTC',
        TimeStampStart  => '2015-03-21 12:00:00',
        ServerTZ        => 'UTC',
        Time            => 60 * 60 * 16,                                                       # 16h
        TimeDate        => '16h',
        DestinationTime => '2015-03-22 04:00:00',
    },
    {
        Name            => 'Asia/Tehran - end DST from 00 to 01  ( UTC+4:30 => UTC+3:30 )',
        TimeStampStart  => '2015-03-21 12:00:00',
        ServerTZ        => 'Asia/Tehran',
        Time            => 60 * 60 * 17,                                                       # 17h
        TimeDate        => '17h',
        DestinationTime => '2015-03-22 06:00:00',
    },
    {
        Name            => 'UTC',
        TimeStampStart  => '2015-01-21 12:00:00',
        ServerTZ        => 'UTC',
        Time            => 60 * 60 * 24 * 90 + 60 * 60 * 16,                                   # 90 days and 16h
        TimeDate        => '90 days and 16h',
        DestinationTime => '2015-04-22 04:00:00',
    },
    {
        Name            => 'Australia/Sydney - end DST from 00 to 01  ( UTC+11 => UTC+10 )',
        TimeStampStart  => '2015-01-21 12:00:00',
        ServerTZ        => 'Asia/Tehran',
        Time            => 60 * 60 * 24 * 90 + 60 * 60 * 17,                                   # 90 days and 17h
        TimeDate        => '90 days and 17h',
        DestinationTime => '2015-04-22 06:00:00',
    },
);

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# use a calendar with the same business hours for every day so that the UT runs correctly
# on every day of the week and outside usual business hours
my %Week;
my @Days = qw(Sun Mon Tue Wed Thu Fri Sat);
for my $Day (@Days) {
    $Week{$Day} = [ 0 .. 23 ];
}
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'TimeWorkingHours',
    Value => \%Week,
);

# disable default Vacation days
$ConfigObject->Set(
    Key   => 'TimeVacationDays',
    Value => {},
);

for my $Test (@Tests) {

    # set the server time zone
    local $ENV{TZ} = $Test->{ServerTZ};

    # convert UTC timestamp to system time and set it
    $Test->{TimeStampStart} =~ m/(\d{4})-(\d{1,2})-(\d{1,2})\s(\d{1,2}):(\d{1,2}):(\d{1,2})/;

    my $TimeStart = Time::Local::timegm(
        $6, $5, $4, $3, ( $2 - 1 ), $1
    );

    $HelperObject->FixedTimeSet(
        $TimeStart,
    );

    # set OTRS time zone to arbitrary value to make sure it is ignored
    $ConfigObject->Set(
        Key   => 'TimeZone',
        Value => -8,
    );

    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::System::Time'],
    );

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    my $StartTime = $TimeObject->TimeStamp2SystemTime(
        String => $Test->{TimeStampStart},
    );

    my $DestinationTime = $TimeObject->DestinationTime(
        StartTime => $StartTime,
        Time      => $Test->{Time},
    );
    my $DestinationTimeStamp = $TimeObject->SystemTime2TimeStamp(
        SystemTime => $DestinationTime,
    );

    $Self->Is(
        $DestinationTimeStamp,
        $Test->{DestinationTime},
        "$Test->{Name} ($Test->{ServerTZ}) destination time ($Test->{TimeDate}) from $Test->{TimeStampStart}: ($Test->{DestinationTime})",
    );

    $HelperObject->FixedTimeUnset();
}

1;
