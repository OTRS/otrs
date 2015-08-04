# --
# MailTimeStamp.t - Time tests
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

use vars (qw($Self));

# this test only works in *nix
if ( $^O eq 'MSWin32' ) {

    $Self->True(
        1,
        'Can not specify local time zone via env on Win32, skipping tests.',
    );
    return 1;
}

my @Tests = (

    # UTC server tests
    {
        Name      => 'Europe/Berlin',
        TimeStamp => '2014-01-10 11:12:13',
        ServerTZ  => 'UTC',
        TimeZone  => +1,
        Result    => 'Fri, 10 Jan 2014 11:12:13 +0100',
    },
    {
        Name      => 'America/Los_Angeles',
        TimeStamp => '2014-01-10 11:12:13',
        TimeZone  => -8,
        ServerTZ  => 'UTC',
        Result    => 'Fri, 10 Jan 2014 11:12:13 -0800',
    },
    {
        Name      => 'Asia/Yekaterinburg',
        TimeStamp => '2014-01-10 11:12:13',
        TimeZone  => +6,
        ServerTZ  => 'UTC',
        Result    => 'Fri, 10 Jan 2014 11:12:13 +0600',
    },
    {
        Name      => 'Europe/London',
        TimeStamp => '2014-01-10 11:12:13',
        TimeZone  => +0,
        ServerTZ  => 'UTC',
        Result    => 'Fri, 10 Jan 2014 11:12:13 +0000',
    },

    # this tests are odd the correct value should consider the  summer time or daylight time, but
    # currently it is not possible to determine it, this also happens in other parts of otrs.
    {
        Name      => 'Europe/Berlin',
        TimeStamp => '2014-08-03 02:03:04',
        TimeZone  => +1,
        ServerTZ  => 'UTC',
        Result    => 'Sun, 3 Aug 2014 02:03:04 +0100',
    },
    {

        Name      => 'America/Los_Angeles',
        TimeStamp => '2014-08-03 02:03:04',
        TimeZone  => -8,
        ServerTZ  => 'UTC',
        Result    => 'Sun, 3 Aug 2014 02:03:04 -0800',
    },
    {
        Name      => 'Asia/Yekaterinburg',
        TimeStamp => '2014-08-03 02:03:04',
        TimeZone  => +5,
        ServerTZ  => 'UTC',
        Result    => 'Sun, 3 Aug 2014 02:03:04 +0500',
    },
    {
        Name      => 'Europe/London',
        TimeStamp => '2014-08-03 02:03:04',
        TimeZone  => +0,
        ServerTZ  => 'UTC',
        Result    => 'Sun, 3 Aug 2014 02:03:04 +0000',
    },

    # none UTC server tests
    {
        Name      => 'Europe/Berlin',
        TimeStamp => '2014-01-10 11:12:13',
        TimeZone  => 0,
        ServerTZ  => 'Europe/Berlin',
        Result    => 'Fri, 10 Jan 2014 11:12:13 +0100',
    },
    {
        Name      => 'America/Los_Angeles',
        TimeStamp => '2014-01-10 11:12:13',
        TimeZone  => -8,
        ServerTZ  => 'America/Los_Angeles',
        Result    => 'Fri, 10 Jan 2014 11:12:13 -0800',
    },
    {
        Name      => 'Asia/Yekaterinburg',
        TimeStamp => '2014-01-10 11:12:13',
        TimeZone  => 0,
        ServerTZ  => 'Asia/Yekaterinburg',
        Result    => 'Fri, 10 Jan 2014 11:12:13 +0600',
    },
    {
        Name      => 'Europe/London',
        TimeStamp => '2014-01-10 11:12:13',
        TimeZone  => 0,
        ServerTZ  => 'Europe/London',
        Result    => 'Fri, 10 Jan 2014 11:12:13 +0000',
    },
    {
        Name      => 'Europe/Berlin',
        TimeStamp => '2014-08-03 02:03:04',
        TimeZone  => 0,
        ServerTZ  => 'Europe/Berlin',
        Result    => 'Sun, 3 Aug 2014 02:03:04 +0200',
    },
    {

        Name      => 'America/Los_Angeles',
        TimeStamp => '2014-08-03 02:03:04',
        TimeZone  => 0,
        ServerTZ  => 'America/Los_Angeles',
        Result    => 'Sun, 3 Aug 2014 02:03:04 -0700',
    },
    {
        Name      => 'Asia/Yekaterinburg',
        TimeStamp => '2014-08-03 02:03:04',
        TimeZone  => 0,
        ServerTZ  => 'Asia/Yekaterinburg',
        Result    => 'Sun, 3 Aug 2014 02:03:04 +0600',
    },
    {
        Name      => 'Europe/London',
        TimeStamp => '2014-08-03 02:03:04',
        TimeZone  => 0,
        ServerTZ  => 'Europe/London',
        Result    => 'Sun, 3 Aug 2014 02:03:04 +0100',
    },
);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

for my $Test (@Tests) {

    # set the server time zone
    local $ENV{TZ} = $Test->{ServerTZ};

    # set OTRS time zone setting
    $ConfigObject->Set(
        Key   => 'TimeZone',
        Value => $Test->{TimeZone},
    );

    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::System::Time'],
    );

    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    $HelperObject->FixedTimeSet(
        $TimeObject->TimeStamp2SystemTime( String => $Test->{TimeStamp} ),
    );

    my $MailTimeStamp = $TimeObject->MailTimeStamp();

    $Self->Is(
        $MailTimeStamp,
        $Test->{Result},
        "$Test->{Name} Timestamp $Test->{TimeStamp}:",
    );
}

1;
