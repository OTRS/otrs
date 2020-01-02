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
# Tests for subtracting durations from DateTime object
#
my @TestConfigs = (
    {
        From => {
            Year     => 2016,
            Month    => 2,
            Day      => 29,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Subtract => {
            Years => 1,
        },
        ExpectedResult => {
            Year      => 2015,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 28,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 6,
            DayAbbr   => 'Sat',
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        From => {
            Year     => 2017,
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Subtract => {
            Years => 1,
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 29,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 1,
            DayAbbr   => 'Mon',
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        From => {
            Year     => 2016,
            Month    => 2,
            Day      => 29,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Subtract => {
            Days => 1,
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 28,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 7,
            DayAbbr   => 'Sun',
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        From => {
            Year     => 2016,
            Month    => 2,
            Day      => 29,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'America/New_York',
        },
        Subtract => {
            Days => 1,
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 28,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 7,
            DayAbbr   => 'Sun',
            TimeZone  => 'America/New_York',
        },
    },
    {
        From => {
            Year     => 2016,
            Month    => 3,
            Day      => 13,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Subtract => {
            Weeks => 2,
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 28,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 7,
            DayAbbr   => 'Sun',
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        From => {
            Year     => 2026,
            Month    => 5,
            Day      => 18,
            Hour     => 22,
            Minute   => 1,
            Second   => 1,
            TimeZone => 'Europe/Berlin',
        },
        Subtract => {
            Years   => 10,
            Months  => 2,
            Weeks   => 2,
            Days    => 5,
            Hours   => 4,
            Minutes => 121,
            Seconds => 61,
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 29,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 1,
            DayAbbr   => 'Mon',
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        From => {
            Year     => 2016,
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Subtract => {
            Years => 'invalid',
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 28,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 7,
            DayAbbr   => 'Sun',
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        From => {
            Year     => 2016,
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Subtract => {
            Days => -5,    # results in adding 5 days
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 3,
            MonthAbbr => 'Mar',
            Day       => 4,
            Hour      => 14,
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
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Subtract => {
            Days   => -5,    # results in adding 5 days
            Years  => -1,    # results in adding 1 year
            Months => +3,    # results in substracting 3 months
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 12,
            MonthAbbr => 'Dec',
            Day       => 4,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 7,
            DayAbbr   => 'Sun',
            TimeZone  => 'Europe/Berlin',
        },
    },
);

TESTCONFIG:
for my $TestConfig (@TestConfigs) {

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{From},
    );
    $DateTimeObject->Subtract( %{ $TestConfig->{Subtract} } );

    my @SubtractStrings;
    while ( my ( $Key, $Value ) = each %{ $TestConfig->{Subtract} } ) {
        push @SubtractStrings, "$Value $Key";
    }
    my $SubtractString = join ', ', sort @SubtractStrings;

    $Self->IsDeeply(
        $DateTimeObject->Get(),
        $TestConfig->{ExpectedResult},
        'Subtracting '
            . $SubtractString
            . ' from '
            . $DateTimeObject->Format( Format => '%Y-%m-%d %H:%M:%S %{time_zone_long_name}' )
            . ' must match the expected values.',
    );
}

# Tests for failing calls to Subtract()
my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
@TestConfigs = (
    {
        Name   => 'without parameters',
        Params => {},
    },
    {
        Name   => 'with invalid seconds',
        Params => {
            Seconds => 'invalid',
        }
    },
    {
        Name   => 'with valid minutes and invalid days',
        Params => {
            Minutes => 4,
            Days    => 'invalid',
        },
    },
    {
        Name   => 'with unsupported parameter',
        Params => {
            UnsupportedParameter => 2,
        },
    },
    {
        Name   => 'with unsupported parameter and valid years',
        Params => {
            UnsupportedParameter => 2,
            Years                => 1,
        },
    },
);

for my $TestConfig (@TestConfigs) {
    my $DateTimeObjectClone = $DateTimeObject->Clone();
    my $Result              = $DateTimeObjectClone->Subtract( %{ $TestConfig->{Params} } );
    $Self->False(
        $Result,
        "Subtract() $TestConfig->{Name} must fail.",
    );

    $Self->IsDeeply(
        $DateTimeObjectClone->Get(),
        $DateTimeObject->Get(),
        'DateTime object must be unchanged after failed Subtract().',
    );
}

1;
