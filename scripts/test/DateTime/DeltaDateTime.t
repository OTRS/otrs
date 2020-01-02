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
# Tests for calculating delta between two DateTime objects
#
my @TestConfigs = (
    {
        Date1 => {
            String   => '2013-02-28 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        Date2 => {
            String   => '2015-02-15 14:54:10',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Years           => 1,
            Months          => 11,
            Weeks           => 2,
            Days            => 0,
            Hours           => 23,
            Minutes         => 55,
            Seconds         => 10,
            AbsoluteSeconds => 61948510,
        },
    },
    {
        Date1 => {
            String   => '2013-02-28 14:59:00',
            TimeZone => 'UTC',
        },
        Date2 => {
            String   => '2015-02-15 14:54:10',
            TimeZone => 'America/New_York',
        },
        ExpectedResult => {
            Years           => 1,
            Months          => 11,
            Weeks           => 2,
            Days            => 1,
            Hours           => 4,
            Minutes         => 55,
            Seconds         => 10,
            AbsoluteSeconds => 61966510,
        },
    },
    {
        Date1 => {
            String   => '2016-02-28 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        Date2 => {
            String   => '2016-02-28 13:54:10',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 1,
            Minutes         => 4,
            Seconds         => 50,
            AbsoluteSeconds => 3890,
        },
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

    my $Delta = $DateTimeObject1->Delta( DateTimeObject => $DateTimeObject2 );

    $Self->IsDeeply(
        $Delta,
        $TestConfig->{ExpectedResult},
        'Delta of two dates ('
            . $DateTimeObject1->Format( Format => '%Y-%m-%d %H:%M:%S %{time_zone_long_name}' ) . ' and '
            . $DateTimeObject2->Format( Format => '%Y-%m-%d %H:%M:%S %{time_zone_long_name}' )
            . ') must match expected one.',
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

my $Delta = $DateTimeObject->Delta( DateTimeObject => 'No DateTime object but a string' );
$Self->False(
    $Delta,
    'Delta calculation with invalid DateTime object must fail.',
);

## nofilter(TidyAll::Plugin::OTRS::Migrations::OTRS6::TimeObject)
$Delta = $DateTimeObject->Delta( DateTimeObject => $Kernel::OM->Get('Kernel::System::Time') );
$Self->False(
    $Delta,
    'Delta calculation with invalid DateTime object must fail.',
);

1;
