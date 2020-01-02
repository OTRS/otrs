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
        Result       => 'Fri Jan 10 11:12:13 2014',
    },
    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'Europe/Berlin',
        Result       => 'Fri Jan 10 12:12:13 2014',
    },
    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'America/Los_Angeles',
        Result       => 'Fri Jan 10 03:12:13 2014',
    },
    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'Australia/Sydney',
        Result       => 'Fri Jan 10 22:12:13 2014',
    },
    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'Europe/London',
        Result       => 'Fri Jan 10 11:12:13 2014',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Europe/Berlin',
        Result       => 'Sun Aug 3 04:03:04 2014',
    },
    {

        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'America/Los_Angeles',
        Result       => 'Sat Aug 2 19:03:04 2014',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Australia/Sydney',
        Result       => 'Sun Aug 3 12:03:04 2014',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Europe/London',
        Result       => 'Sun Aug 3 03:03:04 2014',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Europe/Berlin',
        Result       => 'Sun Aug 3 04:03:04 2014',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Asia/Kathmandu',
        Result       => 'Sun Aug 3 07:48:04 2014',
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

    my $CTimeString = $DateTimeObject->ToCTimeString();

    $Self->Is(
        $CTimeString,
        $Test->{Result},
        "$Test->{TimeStampUTC} (UTC) to $Test->{TimeZone} ctime string must match expected one.",
    );
}

1;
