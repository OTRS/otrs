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
# Tests for converting date/time string to hash
#
# NOTE: _StringToHash does not test if a date has valid values.
# This happens later when the values will be used to e. g. create
# a DateTime object.
#
# So only the format of the date string is being tested here.
#
my @TestConfigs = (
    {
        String         => '2016-02-28 14:59:00',
        ExpectedResult => {
            Year   => 2016,
            Month  => 2,
            Day    => 28,
            Hour   => 14,
            Minute => 59,
            Second => 0,
        },
    },
    {
        String         => '2014-01-01 00:07:45',
        ExpectedResult => {
            Year   => 2014,
            Month  => 1,
            Day    => 1,
            Hour   => 0,
            Minute => 7,
            Second => 45,
        },
    },
    {
        String         => '2014-12-23',
        ExpectedResult => {
            Year   => 2014,
            Month  => 12,
            Day    => 23,
            Hour   => 0,
            Minute => 0,
            Second => 0,
        },
    },
    {
        String         => '2014-12-23 03:56',
        ExpectedResult => {
            Year   => 2014,
            Month  => 12,
            Day    => 23,
            Hour   => 3,
            Minute => 56,
            Second => 0,
        },
    },
    {
        String         => '2014-12-23 15',
        ExpectedResult => undef,
    },
    {
        String         => '2014-1-2 15:4:25',
        ExpectedResult => {
            Year   => 2014,
            Month  => 1,
            Day    => 2,
            Hour   => 15,
            Minute => 4,
            Second => 25,
        },
    },
    {
        String         => '2014-INVALID-01-01 00:07:45',
        ExpectedResult => undef,
    },
    {
        String         => '2017-05-09T07:00:09+00:00',
        ExpectedResult => {
            Year   => 2017,
            Month  => 5,
            Day    => 9,
            Hour   => 7,
            Minute => 0,
            Second => 9,
        },
    },
    {
        String         => '2017-05-09T07:00:09+01:00',
        ExpectedResult => {
            Year   => 2017,
            Month  => 5,
            Day    => 9,
            Hour   => 6,
            Minute => 0,
            Second => 9,
        },
    },
    {
        String         => '2017-05-09T07:00:09+0100',
        ExpectedResult => {
            Year   => 2017,
            Month  => 5,
            Day    => 9,
            Hour   => 6,
            Minute => 0,
            Second => 9,
        },
    },
    {
        String         => '2017-05-09T07:00:09 GMT',
        ExpectedResult => {
            Year     => 2017,
            Month    => 5,
            Day      => 9,
            Hour     => 7,
            Minute   => 0,
            Second   => 9,
            TimeZone => 'UTC',
        },
    },
    {
        String         => '2017-05-09T07:00:09Europe/Berlin',
        ExpectedResult => {
            Year     => 2017,
            Month    => 5,
            Day      => 9,
            Hour     => 7,
            Minute   => 0,
            Second   => 9,
            TimeZone => 'Europe/Berlin',
        },
    },
    {
        String         => '2017-05-09T07:00:09Z',
        ExpectedResult => {
            Year     => 2017,
            Month    => 5,
            Day      => 9,
            Hour     => 7,
            Minute   => 0,
            Second   => 9,
            TimeZone => 'UTC',
        },
    },
);

TESTCONFIG:
for my $TestConfig (@TestConfigs) {
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    my $Result = $DateTimeObject->_StringToHash( String => $TestConfig->{String} );

    if ( ref $TestConfig->{ExpectedResult} ) {
        $Self->IsDeeply(
            $Result,
            $TestConfig->{ExpectedResult},
            '_StringToHash() for ' . $TestConfig->{String} . ' must have expected result.',
        );
    }
    else {
        $Self->Is(
            $Result,
            $TestConfig->{ExpectedResult},
            '_StringToHash() for ' . $TestConfig->{String} . ' must have expected result.',
        );
    }
}

1;
