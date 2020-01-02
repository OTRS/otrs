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
# Tests for setting/changing date and time values of existing DateTime object
#
my %OriginalDateTimeValues = (
    Year     => 2016,
    Month    => 2,
    Day      => 29,
    Hour     => 14,
    Minute   => 46,
    Second   => 34,
    TimeZone => 'Europe/Berlin',
);

my @TestConfigs = (
    {
        Name   => '2017-02-28',
        Params => {
            Year      => 2017,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 28,
            DayOfWeek => 2,
            DayAbbr   => 'Tue',
        },
        SuccessExpected => 1,
    },
    {
        Name   => '2013-12-28 12:59:04',
        Params => {
            Year      => 2013,
            Month     => 12,
            MonthAbbr => 'Dec',
            Day       => 28,
            Hour      => 12,
            Minute    => 59,
            Second    => 4,
            DayOfWeek => 6,
            DayAbbr   => 'Sat',
        },
        SuccessExpected => 1,
    },
    {
        Name   => 'Invalid date 2017-02-29 12:59:04',
        Params => {
            Year   => 2017,
            Month  => 2,
            Day    => 29,
            Hour   => 12,
            Minute => 59,
            Second => 4,
        },
        SuccessExpected => 0,
    },
    {
        Name   => 'No parameters',
        Params => {
        },
        SuccessExpected => 0,
    },
);

TESTCONFIG:
for my $TestConfig (@TestConfigs) {

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => \%OriginalDateTimeValues,
    );

    # Update date and time values
    my $DateTimeSet = $DateTimeObject->Set( %{ $TestConfig->{Params} } );

    $Self->Is(
        $DateTimeSet ? 1 : 0,
        $TestConfig->{SuccessExpected},
        $TestConfig->{Name} . ': Setting date and time of DateTime object must '
            . ( $TestConfig->{SuccessExpected} ? '' : 'not ' )
            . 'succeed.',
    );

    next TESTCONFIG if !$DateTimeSet;

    # Compare date and time with expected ones
    my $DateTimeValues        = $DateTimeObject->Get();
    my $DateTimeValuesCorrect = 1;

    KEY:
    for my $Key ( sort keys %{$DateTimeValues} ) {
        my $ExpectedValue;
        if ( exists $TestConfig->{Params}->{$Key} ) {
            $ExpectedValue = $TestConfig->{Params}->{$Key};
        }
        else {
            $ExpectedValue = $OriginalDateTimeValues{$Key};
        }

        next KEY if $DateTimeValues->{$Key} eq $ExpectedValue;

        $DateTimeValuesCorrect = 0;
        last KEY;
    }

    $Self->Is(
        $DateTimeValuesCorrect ? 1 : 0,
        $TestConfig->{SuccessExpected},
        $TestConfig->{Name}
            . ': Set date and time must '
            . ( $TestConfig->{SuccessExpected} ? '' : 'not ' )
            . 'match expected ones.',
    );
}

1;
