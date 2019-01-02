# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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
        Name              => 'UTC',
        TimeStampUTCStart => '2015-02-17 12:00:00',
        TimeStampUTCStop  => '2015-05-18 12:00:00',
        ServerTZ          => 'UTC',
        Result            => '7776000',               # 90 days
        ResultTime        => '90 days',
    },
    {
        Name              => 'Europe/Berlin ( Daylight Saving Time UTC+1 => UTC+2 )',
        TimeStampUTCStart => '2015-02-17 12:00:00',
        TimeStampUTCStop  => '2015-05-18 12:00:00',
        ServerTZ          => 'Europe/Berlin',
        Result            => '7779600',                                                 # 90 days and 1h
        ResultTime        => '90 days and 1h',
    },
    {
        Name              => 'UTC',
        TimeStampUTCStart => '2015-02-21 22:00:00',
        TimeStampUTCStop  => '2015-02-22 04:00:00',
        ServerTZ          => 'UTC',
        Result            => '21600',                                                   # 6h
        ResultTime        => '6h',
    },
    {
        Name              => 'America/Sao_Paulo - end DST from 00 to 23  ( UTC-2 => UTC-3 )',
        TimeStampUTCStart => '2015-02-21 22:00:00',
        TimeStampUTCStop  => '2015-02-22 04:00:00',
        ServerTZ          => 'America/Sao_Paulo',
        Result            => '18000',                                                           # 5h
        ResultTime        => '5h',
    },
    {
        Name              => 'UTC with min and sec',
        TimeStampUTCStart => '2015-02-20 22:10:05',
        TimeStampUTCStop  => '2015-02-25 04:30:20',
        ServerTZ          => 'UTC',
        Result            => '368415',                                                          # 4 days 06:20:15
        ResultTime        => '4 days 06:20:15',
    },
    {
        Name              => 'America/Sao_Paulo - end DST from 00 to 23 - with min and sec',
        TimeStampUTCStart => '2015-02-20 22:10:05',
        TimeStampUTCStop  => '2015-02-25 04:30:20',
        ServerTZ          => 'America/Sao_Paulo',
        Result            => '364815',                                                          # 4 days 05:20:15
        ResultTime        => '4 days 05:20:15',
    },
    {
        Name              => 'UTC',
        TimeStampUTCStart => '2015-10-17 22:00:00',
        TimeStampUTCStop  => '2015-10-18 04:00:00',
        ServerTZ          => 'UTC',
        Result            => '21600',                                                           # 6h
        ResultTime        => '6h',
    },
    {
        Name              => 'America/Sao_Paulo - start DST from 00 to 01 ( UTC-3 => UTC-2 )',
        TimeStampUTCStart => '2015-10-17 22:00:00',
        TimeStampUTCStop  => '2015-10-18 04:00:00',
        ServerTZ          => 'America/Sao_Paulo',
        Result            => '25200',                                                            # 7h
        ResultTime        => '7h',
    },
    {
        Name              => 'UTC',
        TimeStampUTCStart => '2015-03-21 12:00:00',
        TimeStampUTCStop  => '2015-03-22 12:00:00',
        ServerTZ          => 'UTC',
        Result            => '86400',                                                            # 24h
        ResultTime        => '24h',
    },
    {
        Name              => 'UTC',
        TimeStampUTCStart => '2015-09-21 12:00:00',
        TimeStampUTCStop  => '2015-09-22 04:00:00',
        ServerTZ          => 'UTC',
        Result            => '57600',                                                            # 16h
        ResultTime        => '16h',
    },
    {
        Name              => 'Asia/Tehran - end DST from 00 to 23  ( UTC+3:30 => UTC+4:30 )',
        TimeStampUTCStart => '2015-09-21 12:00:00',
        TimeStampUTCStop  => '2015-09-22 04:00:00',
        ServerTZ          => 'Asia/Tehran',
        Result            => '54000',                                                            # 15h
        ResultTime        => '15h',
    },
    {
        Name              => 'UTC',
        TimeStampUTCStart => '2015-03-21 12:00:00',
        TimeStampUTCStop  => '2015-03-22 04:00:00',
        ServerTZ          => 'UTC',
        Result            => '57600',                                                            # 16h
        ResultTime        => '16h',
    },
    {
        Name              => 'Asia/Tehran - end DST from 00 to 01  ( UTC+4:30 => UTC+3:30 )',
        TimeStampUTCStart => '2015-03-21 12:00:00',
        TimeStampUTCStop  => '2015-03-22 04:00:00',
        ServerTZ          => 'Asia/Tehran',
        Result            => '61200',                                                            # 17h
        ResultTime        => '17h',
    },
    {
        Name              => 'UTC',
        TimeStampUTCStart => '2015-01-21 12:00:00',
        TimeStampUTCStop  => '2015-04-22 04:00:00',
        ServerTZ          => 'UTC',
        Result            => '7833600',                                                          # 90 days and 16h
        ResultTime        => '90 days and 16h',
    },
    {
        Name              => 'Australia/Sydney - end DST from 00 to 01  ( UTC+11 => UTC+10 )',
        TimeStampUTCStart => '2015-01-21 12:00:00',
        TimeStampUTCStop  => '2015-04-22 04:00:00',
        ServerTZ          => 'Asia/Tehran',
        Result            => '7837200',                                                          # 90 days and 17h
        ResultTime        => '90 days and 17h',
    },
);

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# use a calendar with the same business hours for every day so that the UT runs correctly
# on every day of the week and outside usual business hours.
my %Week;
my @Days = qw(Sun Mon Tue Wed Thu Fri Sat);
for my $Day (@Days) {
    $Week{$Day} = [ 0 .. 23 ];
}
$ConfigObject->Set(
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

    # Convert UTC timestamp to system time and set it.
    $Test->{TimeStampUTCStart} =~ m/(\d{4})-(\d{1,2})-(\d{1,2})\s(\d{1,2}):(\d{1,2}):(\d{1,2})/;

    my $FixedTimeStart = Time::Local::timegm(
        $6, $5, $4, $3, ( $2 - 1 ), $1
    );

    # Convert UTC timestamp to system time and set it.
    $Test->{TimeStampUTCStop} =~ m/(\d{4})-(\d{1,2})-(\d{1,2})\s(\d{1,2}):(\d{1,2}):(\d{1,2})/;

    my $FixedTimeStop = Time::Local::timegm(
        $6, $5, $4, $3, ( $2 - 1 ), $1
    );

    $HelperObject->FixedTimeSet(
        $FixedTimeStart,
    );

    # Set OTRS time zone to arbitrary value to make sure it is ignored.
    $ConfigObject->Set(
        Key   => 'TimeZone',
        Value => -8,
    );

    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::System::Time'],
    );

    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    my $StopTime = $TimeObject->SystemTime();
    my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WDay ) = localtime $FixedTimeStop;
    $Year  += 1900;
    $Month += 1;
    my $Stop = "$Day-$Month-$Year $Hour:$Min:$Sec";
    ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WDay ) = localtime $FixedTimeStart;
    $Year  += 1900;
    $Month += 1;
    my $Start = "$Day-$Month-$Year $Hour:$Min:$Sec";

    my $WorkingTime = $TimeObject->WorkingTime(
        StartTime => $FixedTimeStart,
        StopTime  => $FixedTimeStop,
    );

    $Self->Is(
        $WorkingTime,
        $Test->{Result},
        "$Test->{Name} ($Test->{ServerTZ}) working time from $Start to $Stop: $WorkingTime ($Test->{ResultTime})",
    );

    $HelperObject->FixedTimeUnset();
}

1;
