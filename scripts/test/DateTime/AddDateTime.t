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
            Year     => 2016,
            Month    => 2,
            Day      => 29,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Add => {
            Years => 1,
        },
        ExpectedResult => {
            Year      => 2017,
            Month     => 3,
            MonthAbbr => 'Mar',
            Day       => 1,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 3,
            DayAbbr   => 'Wed',
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
        Add => {
            Years => 1,
        },
        ExpectedResult => {
            Year      => 2017,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 28,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 2,
            DayAbbr   => 'Tue',
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
        Add => {
            Days => 1,
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
            TimeZone => 'America/New_York',
        },
        Add => {
            Days => 1,
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
            TimeZone  => 'America/New_York',
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
        Add => {
            Weeks => 2,
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 3,
            MonthAbbr => 'Mar',
            Day       => 13,
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
        Add => {
            Years   => 10,
            Months  => 2,
            Weeks   => 2,
            Days    => 5,
            Hours   => 4,
            Minutes => 121,
            Seconds => 61,
        },
        ExpectedResult => {
            Year      => 2026,
            Month     => 5,
            MonthAbbr => 'May',
            Day       => 18,
            Hour      => 22,
            Minute    => 1,
            Second    => 1,
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
        Add => {
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
        Add => {
            Days => -5,    # results in subtracting 5 days
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 23,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 2,
            DayAbbr   => 'Tue',
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
        Add => {
            Days   => -5,    # results in subtracting 5 days
            Years  => -1,    # results in subtracting 1 year
            Months => +3,
        },
        ExpectedResult => {
            Year      => 2015,
            Month     => 5,
            MonthAbbr => 'May',
            Day       => 23,
            Hour      => 15,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 6,
            DayAbbr   => 'Sat',
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
    $DateTimeObject->Add( %{ $TestConfig->{Add} } );

    my @AddStrings;
    while ( my ( $Key, $Value ) = each %{ $TestConfig->{Add} } ) {
        push @AddStrings, "$Value $Key";
    }
    my $AddString = join ', ', sort @AddStrings;

    $Self->IsDeeply(
        $DateTimeObject->Get(),
        $TestConfig->{ExpectedResult},
        'Adding '
            . $AddString . ' to '
            . $DateTimeObject->Format( Format => '%Y-%m-%d %H:%M:%S %{time_zone_long_name}' )
            . ' must match the expected values.',
    );
}

# Tests for failing calls to Add()
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
        },
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
