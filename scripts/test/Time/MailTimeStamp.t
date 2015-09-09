# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use Time::Local;

use vars (qw($Self));

my @Tests = (

    {
        Name         => 'UTC',
        TimeStampUTC => '2014-01-10 11:12:13',
        ServerTZ     => 'UTC',
        Result       => 'Fri, 10 Jan 2014 11:12:13 +0000',
    },
    {
        Name         => 'Europe/Berlin',
        TimeStampUTC => '2014-01-10 11:12:13',
        ServerTZ     => 'Europe/Berlin',
        Result       => 'Fri, 10 Jan 2014 12:12:13 +0100',
    },
    {
        Name         => 'America/Los_Angeles',
        TimeStampUTC => '2014-01-10 11:12:13',
        ServerTZ     => 'America/Los_Angeles',
        Result       => 'Fri, 10 Jan 2014 03:12:13 -0800',
    },
    {
        Name         => 'Australia/Sydney',
        TimeStampUTC => '2014-01-10 11:12:13',
        ServerTZ     => 'Australia/Sydney',
        Result       => 'Fri, 10 Jan 2014 22:12:13 +1100',
    },
    {
        Name         => 'Europe/London',
        TimeStampUTC => '2014-01-10 11:12:13',
        ServerTZ     => 'Europe/London',
        Result       => 'Fri, 10 Jan 2014 11:12:13 +0000',
    },
    {
        Name         => 'Europe/Berlin',
        TimeStampUTC => '2014-08-03 02:03:04',
        ServerTZ     => 'Europe/Berlin',
        Result       => 'Sun, 3 Aug 2014 04:03:04 +0200',
    },
    {

        Name         => 'America/Los_Angeles',
        TimeStampUTC => '2014-08-03 02:03:04',
        ServerTZ     => 'America/Los_Angeles',
        Result       => 'Sat, 2 Aug 2014 19:03:04 -0700',
    },
    {
        Name         => 'Australia/Sydney',
        TimeStampUTC => '2014-08-03 02:03:04',
        ServerTZ     => 'Australia/Sydney',
        Result       => 'Sun, 3 Aug 2014 12:03:04 +1000',
    },
    {
        Name         => 'Europe/London DST',
        TimeStampUTC => '2014-08-03 02:03:04',
        ServerTZ     => 'Europe/London',
        Result       => 'Sun, 3 Aug 2014 03:03:04 +0100',
    },
    {
        Name         => 'Europe/Berlin DST',
        TimeStampUTC => '2014-08-03 02:03:04',
        ServerTZ     => 'Europe/Berlin',
        Result       => 'Sun, 3 Aug 2014 04:03:04 +0200',
    },
    {
        Name         => 'Asia/Kathmandu, offset with minutes',
        TimeStampUTC => '2014-08-03 02:03:04',
        ServerTZ     => 'Asia/Kathmandu',
        Result       => 'Sun, 3 Aug 2014 07:48:04 +0545',
    },
);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

for my $Test (@Tests) {

    # set the server time zone
    local $ENV{TZ} = $Test->{ServerTZ};

    # Convert UTC timestamp to system time and set it.
    $Test->{TimeStampUTC} =~ m/(\d{4})-(\d{1,2})-(\d{1,2})\s(\d{1,2}):(\d{1,2}):(\d{1,2})/;
    my $FixedTime = Time::Local::timegm(
        $6, $5, $4, $3, ( $2 - 1 ), $1
    );
    $HelperObject->FixedTimeSet(
        $FixedTime,
    );

    # Set OTRS time zone to arbitrary value to make sure it is ignored.
    $ConfigObject->Set(
        Key   => 'TimeZone',
        Value => int rand 20 - 10,
    );

    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::System::Time'],
    );

    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    my $MailTimeStamp = $TimeObject->MailTimeStamp();

    $Self->Is(
        $MailTimeStamp,
        $Test->{Result},
        "$Test->{Name} ($Test->{ServerTZ}) Timestamp $Test->{TimeStamp}:",
    );
}

1;
