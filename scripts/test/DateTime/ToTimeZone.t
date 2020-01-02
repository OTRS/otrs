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
# Tests for converting time zones
#
my @TestConfigs = (
    {
        From => {
            Year     => 2016,
            Month    => 1,
            Day      => 29,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'UTC',
        },
        ToTimeZone     => 'Europe/Berlin',
        ExpectedResult => {
            Year      => 2016,
            Month     => 1,
            MonthAbbr => 'Jan',
            Day       => 29,
            Hour      => 15,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 5,
            DayAbbr   => 'Fri',
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        From => {
            Year     => 2016,
            Month    => 4,
            Day      => 29,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'UTC',
        },
        ToTimeZone     => 'Europe/Berlin',
        ExpectedResult => {
            Year      => 2016,
            Month     => 4,
            MonthAbbr => 'Apr',
            Day       => 29,
            Hour      => 16,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 5,
            DayAbbr   => 'Fri',
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        From => {
            Year     => 2016,
            Month    => 1,
            Day      => 25,
            Hour     => 14,
            Minute   => 46,
            Second   => 34,
            TimeZone => 'Europe/Berlin',
        },
        ToTimeZone     => 'Africa/Abidjan',
        ExpectedResult => {
            Year      => 2016,
            Month     => 1,
            MonthAbbr => 'Jan',
            Day       => 25,
            Hour      => 13,
            Minute    => 46,
            Second    => 34,
            DayOfWeek => 1,
            DayAbbr   => 'Mon',
            TimeZone  => 'Africa/Abidjan',
        },
    },
    {
        From => {
            Year     => 2016,
            Month    => 1,
            Day      => 25,
            Hour     => 14,
            Minute   => 46,
            Second   => 34,
            TimeZone => 'Europe/Berlin',
        },
        ToTimeZone     => 'Australia/Adelaide',
        ExpectedResult => {
            Year      => 2016,
            Month     => 1,
            MonthAbbr => 'Jan',
            Day       => 26,
            Hour      => 0,
            Minute    => 16,
            Second    => 34,
            DayOfWeek => 2,
            DayAbbr   => 'Tue',
            TimeZone  => 'Australia/Adelaide',
        },
    },
    {
        From => {
            Year     => 2016,
            Month    => 1,
            Day      => 25,
            Hour     => 14,
            Minute   => 46,
            Second   => 34,
            TimeZone => 'Europe/Berlin',
        },
        ToTimeZone     => 'InvalidTimeZone',
        ExpectedResult => {
            Year      => 2016,
            Month     => 1,
            MonthAbbr => 'Jan',
            Day       => 25,
            Hour      => 14,
            Minute    => 46,
            Second    => 34,
            DayOfWeek => 1,
            DayAbbr   => 'Mon',
            TimeZone  => 'Europe/Berlin',
        },
    },

    # daylight saving time shortly before change in Germany
    {
        From => {
            Year     => 2016,
            Month    => 3,
            Day      => 27,
            Hour     => 1,
            Minute   => 59,
            Second   => 59,
            TimeZone => 'Europe/Berlin',
        },
        ToTimeZone     => 'Australia/Adelaide',
        ExpectedResult => {
            Year      => 2016,
            Month     => 3,
            MonthAbbr => 'Mar',
            Day       => 27,
            Hour      => 11,
            Minute    => 29,
            Second    => 59,
            DayOfWeek => 7,
            DayAbbr   => 'Sun',
            TimeZone  => 'Australia/Adelaide',
        },
    },

    # daylight saving time shortly after change in Germany
    {
        From => {
            Year     => 2016,
            Month    => 3,
            Day      => 27,
            Hour     => 3,
            Minute   => 0,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        ToTimeZone     => 'Australia/Adelaide',
        ExpectedResult => {
            Year      => 2016,
            Month     => 3,
            MonthAbbr => 'Mar',
            Day       => 27,
            Hour      => 11,
            Minute    => 30,
            Second    => 0,
            DayOfWeek => 7,
            DayAbbr   => 'Sun',
            TimeZone  => 'Australia/Adelaide',
        },
    },
);

TESTCONFIG:
for my $TestConfig (@TestConfigs) {

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{From},
    );
    $DateTimeObject->ToTimeZone( TimeZone => $TestConfig->{ToTimeZone} );

    $Self->IsDeeply(
        $DateTimeObject->Get(),
        $TestConfig->{ExpectedResult},
        "Date and time must match the expected values after time zone conversion ($TestConfig->{From}->{TimeZone} => $TestConfig->{ExpectedResult}->{TimeZone}).",
    );
}

# Tests for failing calls to ToTimeZone()
my $DateTimeObject = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        TimeZone => 'UTC',
    },
);

@TestConfigs = (
    {
        Name   => 'without parameters',
        Params => {},
    },
    {
        Name   => 'with invalid time zone',
        Params => {
            TimeZone => 'invalid',
        },
    },
    {
        Name   => 'with unsupported parameter',
        Params => {
            UnsupportedParameter => 2,
        },
    },
);

for my $TestConfig (@TestConfigs) {
    my $DateTimeObjectClone = $DateTimeObject->Clone();
    my $Result              = $DateTimeObjectClone->ToTimeZone( %{ $TestConfig->{Params} } );
    $Self->False(
        $Result,
        "ToTimeZone() $TestConfig->{Name} must fail.",
    );

    $Self->IsDeeply(
        $DateTimeObjectClone->Get(),
        $DateTimeObject->Get(),
        'DateTime object must be unchanged after failed ToTimeZone().',
    );
}

1;
