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
# Tests for IsTimeZoneValid()
#
my @TestConfigs = (
    {
        TimeZone       => 'Europe/Berlin',
        ExpectedResult => 1,
    },
    {
        TimeZone       => 'Europe/BerTYPOlin',
        ExpectedResult => 0,
    },
    {
        TimeZone       => '+2',
        ExpectedResult => 0,
    },
    {
        TimeZone       => '-5',
        ExpectedResult => 0,
    },
    {
        TimeZone       => 0,
        ExpectedResult => 0,
    },
    {
        TimeZone       => 'UTC',
        ExpectedResult => 1,
    },
    {
        TimeZone       => 'Europe/New_York',
        ExpectedResult => 0,
    },
    {
        TimeZone       => 'America/Paris',
        ExpectedResult => 0,
    },
);

my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

TESTCONFIG:
for my $TestConfig (@TestConfigs) {

    $Self->Is(
        $DateTimeObject->IsTimeZoneValid( TimeZone => $TestConfig->{TimeZone} ),
        $TestConfig->{ExpectedResult},
        'Time zone '
            . $TestConfig->{TimeZone}
            . ' has to be recognized as '
            . ( $TestConfig->{ExpectedResult} ? '' : 'not ' )
            . 'valid.',
    );
}

1;
