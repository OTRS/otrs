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
# Tests for comparing DateTime objects via operators
#
my @TestConfigs = (
    {
        DateTime1 => {
            String   => '2016-02-18 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        DateTime2 => {
            String   => '2018-02-14 14:54:10',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResults => {
            '>'  => 0,
            '<'  => 1,
            '>=' => 0,
            '<=' => 1,
            '==' => 0,
            '!=' => 1,
        },
    },
    {
        DateTime1 => {
            String   => '2016-02-18 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        DateTime2 => {
            String   => '2016-02-18 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResults => {
            '>'  => 0,
            '<'  => 0,
            '>=' => 1,
            '<=' => 1,
            '==' => 1,
            '!=' => 0,
        },
    },
    {
        DateTime1 => {
            String   => '2018-02-14 14:54:10',
            TimeZone => 'Europe/Berlin',
        },
        DateTime2 => {
            String   => '2016-02-18 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResults => {
            '>'  => 1,
            '<'  => 0,
            '>=' => 1,
            '<=' => 0,
            '==' => 0,
            '!=' => 1,
        },
    },
);

TESTCONFIG:
for my $TestConfig (@TestConfigs) {

    my $DateTimeObject1 = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{DateTime1},
    );
    my $DateTimeObject2 = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{DateTime2},
    );

    for my $Operator ( sort keys %{ $TestConfig->{ExpectedResults} } ) {
        $Self->Is(
            eval( '$DateTimeObject1 ' . $Operator . ' $DateTimeObject2' ),    ## no critic
            $TestConfig->{ExpectedResults}->{$Operator},
            $DateTimeObject1->Format( Format => '%Y-%m-%d %H:%M:%S %{time_zone_long_name}' )
                . " $Operator "
                . $DateTimeObject2->Format( Format => '%Y-%m-%d %H:%M:%S %{time_zone_long_name}' )
                . ' must have expected result.',
        );
    }
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

for my $Operator ( '>', '<', '>=', '<=', '==', '!=' ) {

    $Self->False(
        eval( '$DateTimeObject ' . $Operator . ' 2' ),    ## no critic
        'Comparison via ' . $Operator . ' with integer instead of DateTime object must fail',
    );

    $Self->False(
        eval( '$DateTimeObject ' . $Operator . ' undef' ),    ## no critic
        'Comparison via ' . $Operator . ' with undef instead of DateTime object must fail',
    );

    ## nofilter(TidyAll::Plugin::OTRS::Migrations::OTRS6::TimeObject)
    $Self->False(
        eval( '$DateTimeObject ' . $Operator . ' $Kernel::OM->Create("Kernel::System::Time")' ),    ## no critic
        'Comparison via ' . $Operator . ' with Time object instead of DateTime object must fail',
    );
}

1;
