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

use vars (qw($Self));

my @Tests = (
    {
        Name      => 'Europe/Berlin',
        TimeStamp => '2014-01-10 11:12:13',
        TimeZone  => +1,
        Result    => 'Fri, 10 Jan 2014 11:12:13 +0100',
    },
    {
        Name      => 'America/Los_Angeles',
        TimeStamp => '2014-01-10 11:12:13',
        TimeZone  => -8,
        Result    => 'Fri, 10 Jan 2014 11:12:13 -0800',
    },
    {
        Name      => 'Asia/Yekaterinburg',
        TimeStamp => '2014-01-10 11:12:13',
        TimeZone  => +5,
        Result    => 'Fri, 10 Jan 2014 11:12:13 +0500',
    },
    {
        Name      => 'Europe/London',
        TimeStamp => '2014-01-10 11:12:13',
        TimeZone  => +0,
        Result    => 'Fri, 10 Jan 2014 11:12:13 +0000',
    },

    # this tests are odd the correct value should consider the  summer time or daylight time, but
    # currently it is not possible to determine it, this also happens in other parts of otrs.
    {
        Name      => 'Europe/Berlin',
        TimeStamp => '2014-08-03 02:03:04',
        TimeZone  => +1,
        Result    => 'Sun, 3 Aug 2014 02:03:04 +0100',
    },
    {

        Name      => 'America/Los_Angeles',
        TimeStamp => '2014-08-03 02:03:04',
        TimeZone  => -8,
        Result    => 'Sun, 3 Aug 2014 02:03:04 -0800',
    },
    {
        Name      => 'Asia/Yekaterinburg',
        TimeStamp => '2014-08-03 02:03:04',
        TimeZone  => +5,
        Result    => 'Sun, 3 Aug 2014 02:03:04 +0500',
    },
    {
        Name      => 'Europe/London',
        TimeStamp => '2014-08-03 02:03:04',
        TimeZone  => +0,
        Result    => 'Sun, 3 Aug 2014 02:03:04 +0000',
    },
);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

for my $Test (@Tests) {

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
