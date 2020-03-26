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

# Broken on certain Perl 5.28 versions due to a Perl crash that we can't work around.
my @BlacklistPerlVersions = (
    v5.26.1,
    v5.26.3,
    v5.28.1,
    v5.28.2,
    v5.30.0,
    v5.30.1,
    v5.30.2,
);

if ( grep { $^V eq $_ } @BlacklistPerlVersions ) {
    $Self->True( 1, "Current Perl version $^V is known to be buggy for this test, skipping." );
    return 1;
}

use Kernel::System::DateTime;

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

#
# Tests for DateTime object with current date and time
#

# Without specific time zone
my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

$Self->Is(
    ref $DateTimeObject,
    'Kernel::System::DateTime',
    'Creation of DateTime object must succeed.'
);

my $Values = $DateTimeObject->Get();

$Self->Is(
    $Values->{TimeZone},
    $DateTimeObject->OTRSTimeZoneGet(),
    'Time zone of DateTime object must match the one configured for data storage.'
);

# With invalid time zone
$DateTimeObject = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        TimeZone => '+2',
    },
);

$Self->False(
    $DateTimeObject,
    'Creation of DateTime object must fail for invalid time zone.'
);

# With specific time zone
$DateTimeObject = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        TimeZone => 'Europe/Berlin',
    },
);

$Self->Is(
    ref $DateTimeObject,
    'Kernel::System::DateTime',
    'Creation of DateTime object must succeed.'
);

$Values = $DateTimeObject->Get();

$Self->Is(
    $Values->{TimeZone},
    'Europe/Berlin',
    'Time zone of DateTime object must match the one configured for data storage.'
);

#
# Test for ToOTRSDateTimeZone
#
$DateTimeObject = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        Year     => 2016,
        Month    => 1,
        Day      => 28,
        Hour     => 17,
        Minute   => 51,
        Second   => 0,
        TimeZone => 'Europe/Berlin',
    },
);

my $OriginalOTRSTimeZone = $DateTimeObject->OTRSTimeZoneGet();

# set specific time zone for data storage
$ConfigObject->Set(
    Key   => 'OTRSTimeZone',
    Value => 'UTC',
);

my $OTRSTimeZone = $DateTimeObject->OTRSTimeZoneGet();

$DateTimeObject->ToOTRSTimeZone();
my $DateTimeValues         = $DateTimeObject->Get();
my $ExpectedDateTimeValues = {
    Year      => 2016,
    Month     => 1,
    MonthAbbr => 'Jan',
    Day       => 28,
    DayOfWeek => 4,
    DayAbbr   => 'Thu',
    Hour      => 16,
    Minute    => 51,
    Second    => 0,
    TimeZone  => 'UTC',
};

$Self->IsDeeply(
    $DateTimeValues,
    $ExpectedDateTimeValues,
    'Date and time after call to ToOTRSTimeZone must match expected values.'
);

#
# Tests for creating DateTime objects with given date and time
#
my @TestConfigs = (
    {
        Params => {
            Year  => 2016,
            Month => 1,
            Day   => 22,
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year  => 2016,
            Month => 2,
            Day   => 29,
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year  => 2015,
            Month => 2,
            Day   => 29,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year  => 2015,
            Month => 12,
            Day   => 31,
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year  => 2015,
            Month => 4,
            Day   => 31,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year  => 15,
            Month => 4,
            Day   => 30,
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year  => 2015,
            Month => 13,
            Day   => 30,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year => 2015,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year  => 2015,
            Month => 13,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year => 2015,
            Day  => 30,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year  => 'test',
            Month => 4,
            Day   => 30,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year  => 2015,
            Month => 'test',
            Day   => 30,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year  => 2015,
            Month => 4,
            Day   => 'test',
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year   => 2015,
            Month  => 4,
            Day    => 30,
            Hour   => 0,
            Minute => 0,
            Second => 0,
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year   => 2015,
            Month  => 4,
            Day    => 30,
            Hour   => 23,
            Minute => 59,
            Second => 59,
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year   => 2015,
            Month  => 4,
            Day    => 30,
            Hour   => 24,
            Minute => 59,
            Second => 59,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year   => 2015,
            Month  => 4,
            Day    => 30,
            Hour   => 23,
            Minute => 60,
            Second => 59,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year   => 2015,
            Month  => 4,
            Day    => 30,
            Hour   => 23,
            Minute => 59,
            Second => 60,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year     => 2015,
            Month    => 4,
            Day      => 30,
            Hour     => 23,
            Minute   => 59,
            Second   => 23,
            TimeZone => 'Europe/Berlin',
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year     => 2015,
            Month    => 4,
            Day      => 30,
            Hour     => 23,
            Minute   => 59,
            Second   => 23,
            TimeZone => 'NoValidTimeZone',
        },
        SuccessExpected => 0,
    },
);

TESTCONFIG:
for my $TestConfig (@TestConfigs) {

    # Create DateTime object
    $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{Params},
    );

    $Self->Is(
        ref $DateTimeObject eq 'Kernel::System::DateTime' ? 1 : 0,
        $TestConfig->{SuccessExpected},
        'Creation of DateTime object must ' . ( $TestConfig->{SuccessExpected} ? '' : 'not ' ) . 'succeed.',
    );

    next TESTCONFIG if !$DateTimeObject;

    # Check values of created DateTime object
    my $Values      = $DateTimeObject->Get();
    my $ValuesMatch = 1;

    VALUENAME:
    for my $ValueName (qw ( Year Month Day Hour Minute Second TimeZone )) {

        my $ExpectedValue = $TestConfig->{Params}->{$ValueName} || 0;
        if ( !$ExpectedValue && $ValueName eq 'TimeZone' ) {
            $ExpectedValue = $DateTimeObject->OTRSTimeZoneGet();
        }

        if ( !defined $Values->{$ValueName} || $Values->{$ValueName} ne $ExpectedValue ) {
            $ValuesMatch = 0;
            last VALUENAME;
        }
    }

    $Self->True(
        $ValuesMatch,
        'DateTime values must match those of creation.'
    );
}

#
# Tests for creating and setting DateTime object via string
#
@TestConfigs = (
    {
        Data => {
            String => '2016-02-28 14:59:00',
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 28,
            DayOfWeek => 7,
            DayAbbr   => 'Sun',
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            TimeZone  => $OTRSTimeZone,
        },
    },
    {
        Data => {
            String => '2014-01-01 00:07:45',
        },
        ExpectedResult => {
            Year      => 2014,
            Month     => 1,
            MonthAbbr => 'Jan',
            Day       => 1,
            DayOfWeek => 3,
            DayAbbr   => 'Wed',
            Hour      => 0,
            Minute    => 7,
            Second    => 45,
            TimeZone  => $OTRSTimeZone,
        },
    },
    {
        Data => {
            String   => '2016-02-28 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 28,
            DayOfWeek => 7,
            DayAbbr   => 'Sun',
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        Data => {
            String   => '2014-01-01 00:07:45',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Year      => 2014,
            Month     => 1,
            MonthAbbr => 'Jan',
            Day       => 1,
            DayOfWeek => 3,
            DayAbbr   => 'Wed',
            Hour      => 0,
            Minute    => 7,
            Second    => 45,
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        Data => {
            String   => '2014-01-INVALID01 00:07:45',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => undef,
    },
);

for my $TestConfig (@TestConfigs) {
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{Data},
    );

    if ($DateTimeObject) {
        my $DateTimeValues = $DateTimeObject->Get();

        $Self->IsDeeply(
            $DateTimeObject->Get(),
            $TestConfig->{ExpectedResult},
            'Creation of DateTime object via string must have expected result.',
        );
    }
    else {
        $Self->Is(
            $DateTimeObject,
            $TestConfig->{ExpectedResult},
            'Creation of DateTime object via string must have expected result.',
        );
    }

    $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    if ( defined $TestConfig->{Data}->{TimeZone} ) {
        $DateTimeObject->ToTimeZone( TimeZone => $TestConfig->{Data}->{TimeZone} );
    }

    my $Result = $DateTimeObject->Set( String => $TestConfig->{Data}->{String} );

    if ( ref $TestConfig->{ExpectedResult} ) {
        $Self->IsDeeply(
            $DateTimeObject->Get(),
            $TestConfig->{ExpectedResult},
            'Setting values of DateTimeObject via string must have expected result.'
        );
    }
    else {
        $Self->Is(
            $Result,
            $TestConfig->{ExpectedResult},
            'Setting values of DateTimeObject via string must have expected result.'
        );
    }
}

#
# Tests for SystemTimeZoneGet()
#
my $ExpectedSystemTimeZone = 'Europe/Berlin';
local $ENV{TZ} = $ExpectedSystemTimeZone;
my $SystemTimeZone = Kernel::System::DateTime->SystemTimeZoneGet();

$Self->Is(
    $SystemTimeZone,
    $ExpectedSystemTimeZone,
    'System time zone must match expected one.'
);

1;
