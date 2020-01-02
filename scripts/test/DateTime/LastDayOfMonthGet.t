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

#
# Tests for adding durations to DateTime object
#
my @TestConfigs = (
    {
        From => {
            String   => '2016-02-29 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Day       => 29,
            DayOfWeek => 1,
            DayAbbr   => 'Mon',
        },
    },
    {
        From => {
            String   => '2016-02-28 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Day       => 29,
            DayOfWeek => 1,
            DayAbbr   => 'Mon',
        },
    },
    {
        From => {
            String   => '2016-03-28 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Day       => 31,
            DayOfWeek => 4,
            DayAbbr   => 'Thu',
        },
    },
    {
        From => {
            String   => '2015-02-02 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Day       => 28,
            DayOfWeek => 6,
            DayAbbr   => 'Sat',
        },
    },
    {
        From => {
            String   => '2012-04-02 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Day       => 30,
            DayOfWeek => 1,
            DayAbbr   => 'Mon',
        },
    },
);

TESTCONFIG:
for my $TestConfig (@TestConfigs) {

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{From},
    );
    my $LastDayOfMonth = $DateTimeObject->LastDayOfMonthGet();

    $Self->IsDeeply(
        $LastDayOfMonth,
        $TestConfig->{ExpectedResult},
        'Last day of month for '
            . $DateTimeObject->Format( Format => '%Y-%m-%d %H:%M:%S %{time_zone_long_name}' )
            . ' must match the expected one.'
    );
}

1;
