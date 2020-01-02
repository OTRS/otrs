# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my @Tests = (

    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'UTC',
        Result       => '2014-01-10 11:12:13',
    },
    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'Europe/Berlin',
        Result       => '2014-01-10 12:12:13',
    },
    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'America/Los_Angeles',
        Result       => '2014-01-10 03:12:13',
    },
    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'Australia/Sydney',
        Result       => '2014-01-10 22:12:13',
    },
    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'Europe/London',
        Result       => '2014-01-10 11:12:13',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Europe/Berlin',
        Result       => '2014-08-03 04:03:04',
    },
    {

        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'America/Los_Angeles',
        Result       => '2014-08-02 19:03:04',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Australia/Sydney',
        Result       => '2014-08-03 12:03:04',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Europe/London',
        Result       => '2014-08-03 03:03:04',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Europe/Berlin',
        Result       => '2014-08-03 04:03:04',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Asia/Kathmandu',
        Result       => '2014-08-03 07:48:04',
    },
);

for my $Test (@Tests) {

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String   => $Test->{TimeStampUTC},
            TimeZone => 'UTC',
        },
    );

    $DateTimeObject->ToTimeZone( TimeZone => $Test->{TimeZone} );

    my $String = $DateTimeObject->ToString();

    $Self->Is(
        $String,
        $Test->{Result},
        "$Test->{TimeStampUTC} (UTC) to $Test->{TimeZone} string must match expected one.",
    );
}

1;
