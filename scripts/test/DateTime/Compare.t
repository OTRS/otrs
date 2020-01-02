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
# Tests for comparing DateTime objects
#
my @TestConfigs = (
    {
        Date1 => {
            Year     => 2016,
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Date2 => {
            Year     => 2018,
            Month    => 2,
            Day      => 14,
            Hour     => 14,
            Minute   => 54,
            Second   => 10,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => -1,
    },
    {
        Date1 => {
            Year     => 2016,
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Date2 => {
            Year     => 2016,
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => 0,
    },
    {
        Date1 => {
            Year     => 2018,
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Date2 => {
            Year     => 2016,
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => 1,
    },
    {
        Date1 => {
            Year     => 2016,
            Month    => 1,
            Day      => 26,
            Hour     => 12,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'UTC',
        },
        Date2 => {
            Year     => 2016,
            Month    => 1,
            Day      => 26,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => -1,
    },
    {
        Date1 => {
            Year     => 2016,
            Month    => 1,
            Day      => 26,
            Hour     => 13,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'UTC',
        },
        Date2 => {
            Year     => 2016,
            Month    => 1,
            Day      => 26,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => 0,
    },
    {
        Date1 => {
            Year     => 2016,
            Month    => 1,
            Day      => 26,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'UTC',
        },
        Date2 => {
            Year     => 2016,
            Month    => 1,
            Day      => 26,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => 1,
    },
    {
        Date1 => {
            Year     => 2016,
            Month    => 6,
            Day      => 26,
            Hour     => 12,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'UTC',
        },
        Date2 => {
            Year     => 2016,
            Month    => 6,
            Day      => 26,
            Hour     => 15,
            Minute   => 0,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => -1,
    },
    {
        Date1 => {
            Year     => 2016,
            Month    => 6,
            Day      => 26,
            Hour     => 13,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'UTC',
        },
        Date2 => {
            Year     => 2016,
            Month    => 6,
            Day      => 26,
            Hour     => 15,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => 0,
    },
    {
        Date1 => {
            Year     => 2016,
            Month    => 6,
            Day      => 26,
            Hour     => 15,
            Minute   => 0,
            Second   => 0,
            TimeZone => 'UTC',
        },
        Date2 => {
            Year     => 2016,
            Month    => 6,
            Day      => 26,
            Hour     => 16,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => 1,
    },
);

TESTCONFIG:
for my $TestConfig (@TestConfigs) {

    my $DateTimeObject1 = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{Date1},
    );
    my $DateTimeObject2 = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{Date2},
    );

    # Compare
    my $Result = $DateTimeObject1->Compare( DateTimeObject => $DateTimeObject2 );
    $Self->Is(
        $Result,
        $TestConfig->{ExpectedComparisonResult},
        'Comparison of two DateTime objects ('
            . $DateTimeObject1->ToString() . ' and '
            . $DateTimeObject2->ToString()
            . ') via Compare must match expected result.',
    );
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

# Compare
my $Result = $DateTimeObject->Compare( DateTimeObject => 'No DateTime object but a string' );
$Self->False(
    $Result,
    'Comparison with invalid DateTime object via Compare must fail.',
);

1;
