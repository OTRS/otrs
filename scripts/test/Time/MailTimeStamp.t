# --
# MailTimeStamp.t - Time tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $TimeObject   = $Kernel::OM->Get('Kernel::System::Time');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# this test only works in *nix
if ( $^O eq 'MSWin32' ) {

    $Self->True(
        1,
        'Can not specify local time zone via env on Win32, skipping tests.',
    );
    return 1;
}

my @Tests = (
    {
        TimeStamp => '2014-01-10 11:12:13',
        TimeZone  => 'Europe/Berlin',
        Result    => 'Fri, 10 Jan 2014 11:12:13 +0100',
    },
    {
        TimeStamp => '2014-01-10 11:12:13',
        TimeZone  => 'America/Los_Angeles',
        Result    => 'Fri, 10 Jan 2014 11:12:13 -0800',
    },
    {
        TimeStamp => '2014-01-10 11:12:13',
        TimeZone  => 'Asia/Katmandu',
        Result    => 'Fri, 10 Jan 2014 11:12:13 +0545',
    },
    {
        TimeStamp => '2014-01-10 11:12:13',
        TimeZone  => 'Europe/London',
        Result    => 'Fri, 10 Jan 2014 11:12:13 +0000',
    },
    {
        TimeStamp => '2014-08-03 02:03:04',
        TimeZone  => 'Europe/Berlin',
        Result    => 'Sun, 3 Aug 2014 02:03:04 +0200',
    },
    {
        TimeStamp => '2014-08-03 02:03:04',
        TimeZone  => 'America/Los_Angeles',
        Result    => 'Sun, 3 Aug 2014 02:03:04 -0700',
    },
    {
        TimeStamp => '2014-08-03 02:03:04',
        TimeZone  => 'Asia/Katmandu',
        Result    => 'Sun, 3 Aug 2014 02:03:04 +0545',
    },
    {
        TimeStamp => '2014-08-03 02:03:04',
        TimeZone  => 'Europe/London',
        Result    => 'Sun, 3 Aug 2014 02:03:04 +0100',
    },
);

for my $Test (@Tests) {

    local $ENV{TZ} = $Test->{TimeZone};

    $HelperObject->FixedTimeSet(
        $TimeObject->TimeStamp2SystemTime( String => $Test->{TimeStamp} ),
    );

    my $MailTimeStamp = $TimeObject->MailTimeStamp();

    $Self->Is(
        $MailTimeStamp,
        $Test->{Result},
        "Timestamp $Test->{TimeStamp} for time zone $Test->{TimeZone}",
    );
}

1;
