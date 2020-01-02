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
# Tests for formatting
#
my @TestConfigs = (
    {
        Date => {
            String   => '2016-02-28 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedStringByFormat => {
            '%Y-%m-%d %H:%M:%S'                               => '2016-02-28 14:59:00',
            '%Y-%m-%d %H:%M:%S %{time_zone_long_name}'        => '2016-02-28 14:59:00 Europe/Berlin',
            'On %Y-%m-%d at %H:%M we will have a phone call.' => 'On 2016-02-28 at 14:59 we will have a phone call.',
        },
    },
    {
        Date => {
            String   => '2014-01-01 00:07:45',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedStringByFormat => {
            '%Y-%m-%d %H:%M:%S'                               => '2014-01-01 00:07:45',
            '%Y-%m-%d %H:%M:%S %{time_zone_long_name}'        => '2014-01-01 00:07:45 Europe/Berlin',
            'On %Y-%m-%d at %H:%M we will have a phone call.' => 'On 2014-01-01 at 00:07 we will have a phone call.',
        },
    },
);

TESTCONFIG:
for my $TestConfig (@TestConfigs) {

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{Date},
    );

    for my $Format ( sort keys %{ $TestConfig->{ExpectedStringByFormat} } ) {
        $Self->Is(
            $DateTimeObject->Format( Format => $Format ),
            $TestConfig->{ExpectedStringByFormat}->{$Format},
            'Formatted string for format "'
                . $Format
                . '" and date/time '
                . $DateTimeObject->ToString()
                . ' must match expected one.',
        );
    }

    $Self->Is(
        $DateTimeObject->ToString(),
        $DateTimeObject->Format( Format => '%Y-%m-%d %H:%M:%S' ),
        'ToString for date/time ' . $DateTimeObject->ToString() . ' must result in expected string.',
    );

    $Self->Is(
        $DateTimeObject->ToEpoch(),
        $DateTimeObject->Format( Format => '%{epoch}' ),
        'ToEpoch for date/time ' . $DateTimeObject->ToString() . ' must result in expected time stamp.',
    );
}

# Test for missing Format parameter
my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

my $Result = $DateTimeObject->Format();
$Self->False(
    $Result,
    'Format() without parameter must fail.',
);

$Result = $DateTimeObject->Format( Formats => '' );
$Self->False(
    $Result,
    'Format() with wrong parameter name must fail.',
);

1;
