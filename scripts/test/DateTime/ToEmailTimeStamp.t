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
        Result       => 'Fri, 10 Jan 2014 11:12:13 +0000',
    },
    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'Europe/Berlin',
        Result       => 'Fri, 10 Jan 2014 12:12:13 +0100',
    },
    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'America/Los_Angeles',
        Result       => 'Fri, 10 Jan 2014 03:12:13 -0800',
    },
    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'Australia/Sydney',
        Result       => 'Fri, 10 Jan 2014 22:12:13 +1100',
    },
    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'Europe/London',
        Result       => 'Fri, 10 Jan 2014 11:12:13 +0000',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Europe/Berlin',
        Result       => 'Sun, 3 Aug 2014 04:03:04 +0200',
    },
    {

        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'America/Los_Angeles',
        Result       => 'Sat, 2 Aug 2014 19:03:04 -0700',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Australia/Sydney',
        Result       => 'Sun, 3 Aug 2014 12:03:04 +1000',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Europe/London',
        Result       => 'Sun, 3 Aug 2014 03:03:04 +0100',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Europe/Berlin',
        Result       => 'Sun, 3 Aug 2014 04:03:04 +0200',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Asia/Kathmandu',
        Result       => 'Sun, 3 Aug 2014 07:48:04 +0545',
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

    my $EmailTimeStamp = $DateTimeObject->ToEmailTimeStamp();

    $Self->Is(
        $EmailTimeStamp,
        $Test->{Result},
        "$Test->{TimeStampUTC} (UTC) to $Test->{TimeZone} email time stamp must match expected one.",
    );
}

1;
