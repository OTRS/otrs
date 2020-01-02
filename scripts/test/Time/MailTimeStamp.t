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
        Name         => 'UTC',
        TimeStampUTC => '2014-01-10 11:12:13',
        OTRSTimeZone => 'UTC',
        Result       => 'Fri, 10 Jan 2014 11:12:13 +0000',
    },
    {
        Name         => 'Europe/Berlin',
        TimeStampUTC => '2014-01-10 11:12:13',
        OTRSTimeZone => 'Europe/Berlin',
        Result       => 'Fri, 10 Jan 2014 12:12:13 +0100',
    },
    {
        Name         => 'America/Los_Angeles',
        TimeStampUTC => '2014-01-10 11:12:13',
        OTRSTimeZone => 'America/Los_Angeles',
        Result       => 'Fri, 10 Jan 2014 03:12:13 -0800',
    },
    {
        Name         => 'Australia/Sydney',
        TimeStampUTC => '2014-01-10 11:12:13',
        OTRSTimeZone => 'Australia/Sydney',
        Result       => 'Fri, 10 Jan 2014 22:12:13 +1100',
    },
    {
        Name         => 'Europe/London',
        TimeStampUTC => '2014-01-10 11:12:13',
        OTRSTimeZone => 'Europe/London',
        Result       => 'Fri, 10 Jan 2014 11:12:13 +0000',
    },
    {
        Name         => 'Europe/Berlin',
        TimeStampUTC => '2014-08-03 02:03:04',
        OTRSTimeZone => 'Europe/Berlin',
        Result       => 'Sun, 3 Aug 2014 04:03:04 +0200',
    },
    {

        Name         => 'America/Los_Angeles',
        TimeStampUTC => '2014-08-03 02:03:04',
        OTRSTimeZone => 'America/Los_Angeles',
        Result       => 'Sat, 2 Aug 2014 19:03:04 -0700',
    },
    {
        Name         => 'Australia/Sydney',
        TimeStampUTC => '2014-08-03 02:03:04',
        OTRSTimeZone => 'Australia/Sydney',
        Result       => 'Sun, 3 Aug 2014 12:03:04 +1000',
    },
    {
        Name         => 'Europe/London DST',
        TimeStampUTC => '2014-08-03 02:03:04',
        OTRSTimeZone => 'Europe/London',
        Result       => 'Sun, 3 Aug 2014 03:03:04 +0100',
    },
    {
        Name         => 'Europe/Berlin DST',
        TimeStampUTC => '2014-08-03 02:03:04',
        OTRSTimeZone => 'Europe/Berlin',
        Result       => 'Sun, 3 Aug 2014 04:03:04 +0200',
    },
    {
        Name         => 'Asia/Kathmandu, offset with minutes',
        TimeStampUTC => '2014-08-03 02:03:04',
        OTRSTimeZone => 'Asia/Kathmandu',
        Result       => 'Sun, 3 Aug 2014 07:48:04 +0545',
    },
);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

for my $Test (@Tests) {

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String   => $Test->{TimeStampUTC},
            TimeZone => 'UTC',
        },
    );

    # Set OTRS time zone to matching one.
    $ConfigObject->Set(
        Key   => 'OTRSTimeZone',
        Value => $Test->{OTRSTimeZone},
    );

    $HelperObject->FixedTimeSet($DateTimeObject);

    # Discard time object because of changed time zone
    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::System::Time', ],
    );
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    $DateTimeObject->ToTimeZone( TimeZone => $Test->{OTRSTimeZone} );

    my $MailTimeStamp = $TimeObject->MailTimeStamp();

    $Self->Is(
        $MailTimeStamp,
        $Test->{Result},
        "$Test->{Name} ($Test->{OTRSTimeZone}) Timestamp $Test->{TimeStampUTC}:",
    );

    $HelperObject->FixedTimeUnset();
}

1;
