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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

#
# Vacation day tests
#

# Remove certain vacation days from calendar 2
my $TimeVacationDays2 = $ConfigObject->Get('TimeVacationDays::Calendar2');
$TimeVacationDays2->{1}->{1} = undef;

my $TimeVacationDaysOneTime2 = $ConfigObject->Get('TimeVacationDaysOneTime::Calendar2');
$TimeVacationDaysOneTime2->{2004}->{1}->{1} = undef;

my @TestConfigs = (
    {
        Params => {
            Year  => 2005,
            Month => 1,
            Day   => 1,
        },
        ExpectedResult => 'New Year\'s Day',
    },
    {
        Params => {
            Year  => 2005,
            Month => '01',
            Day   => '01',
        },
        ExpectedResult => 'New Year\'s Day',
    },
    {
        Params => {
            Year  => 2005,
            Month => 12,
            Day   => 31,
        },
        ExpectedResult => 'New Year\'s Eve',
    },
    {
        Params => {
            Year  => 2005,
            Month => 2,
            Day   => 14,
        },
        ExpectedResult => 0,
    },
    {
        Params => {
            Year     => 2005,
            Month    => 1,
            Day      => 1,
            Calendar => 1,
        },
        ExpectedResult => 'New Year\'s Day',
    },
    {
        Params => {
            Year     => 2005,
            Month    => 1,
            Day      => 1,
            Calendar => 2,
        },
        ExpectedResult => 0,
    },
    {
        Params => {
            Year     => 2004,
            Month    => 1,
            Day      => 1,
            Calendar => 2,
        },
        ExpectedResult => 0,
    },
);

for my $TestConfig (@TestConfigs) {
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{Params},
    );

    my $CalendarStr = $TestConfig->{Params}->{Calendar} ? " Calendar: $TestConfig->{Params}->{Calendar}" : '';
    my $TestName
        = "$TestConfig->{Params}->{Year}-$TestConfig->{Params}->{Month}-$TestConfig->{Params}->{Day}" . $CalendarStr;

    $Self->Is(
        $DateTimeObject->IsVacationDay(
            Calendar => $TestConfig->{Params}->{Calendar},
        ),
        $TestConfig->{ExpectedResult},
        "$TestName - Vacation day must match expected one.",
    );
}

1;
