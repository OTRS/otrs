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

use vars (qw($Self %Param));

my @Tests = (
    {
        Name           => 'Default format',
        DateFormatName => 'DateFormatLong',
        DateFormat     => '%T - %D.%M.%Y',
        Short          => 0,
        Time           => '2014-01-10 11:12:13',
        Result         => '11:12:13 - 10.01.2014',
    },
    {
        Name           => 'Default format, short',
        DateFormatName => 'DateFormatLong',
        DateFormat     => '%T - %D.%M.%Y',
        Short          => 1,
        Time           => '2014-01-10 11:12:13',
        Result         => '11:12 - 10.01.2014',
    },
    {
        Name           => 'Default format, only date passed',
        DateFormatName => 'DateFormatLong',
        DateFormat     => '%T - %D.%M.%Y',
        Short          => 0,
        Time           => '2014-01-10',
        Result         => '2014-01-10',
    },
    {
        Name           => 'Default format, only time passed',
        DateFormatName => 'DateFormatLong',
        DateFormat     => '%T - %D.%M.%Y',
        Short          => 0,
        Time           => '22:12:06',
        Result         => '22:12:06',
    },
    {
        Name           => 'Default format, malformed date/time',
        DateFormatName => 'DateFormatLong',
        DateFormat     => '%T - %D.%M.%Y',
        Short          => 0,
        Time           => 'INVALID',
        Result         => 'INVALID',
    },
    {
        Name           => 'Time zone on day border',
        UserTimeZone   => 'Europe/Berlin',
        DateFormatName => 'DateFormatLong',
        DateFormat     => '%T - %D.%M.%Y',
        Short          => 0,
        Time           => '2014-01-09 23:34:05',
        Result         => '00:34:05 - 10.01.2014 (Europe/Berlin)',
    },
    {
        Name           => 'Time zone on day border for DateFormatShort (TimeZone not applied)',
        UserTimeZone   => 'Europe/Berlin',
        DateFormatName => 'DateFormatShort',
        DateFormat     => '%T - %D.%M.%Y',
        Short          => 0,
        Time           => '2014-01-10 00:00:00',
        Result         => '00:00:00 - 10.01.2014',
    },
    {
        Name           => 'All tags test',
        DateFormatName => 'DateFormatLong',
        DateFormat     => '%A %B %T - %D.%M.%Y',
        Short          => 0,
        Time           => '2014-01-10 11:12:13',
        Result         => 'Fr Jan 11:12:13 - 10.01.2014',
    },
    {
        Name           => 'All tags test, with timezone',
        UserTimeZone   => 'Europe/Berlin',
        DateFormatName => 'DateFormatLong',
        DateFormat     => '%A %B %T - %D.%M.%Y',
        Short          => 0,
        Time           => '2014-01-10 11:12:13',
        Result         => 'Fr Jan 12:12:13 - 10.01.2014 (Europe/Berlin)',
    },
);

for my $Test (@Tests) {

    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => 'OTRSTimeZone',
        Value => 'UTC',
    );

    # discard language object
    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::Language'],
    );

    # get language object
    $Kernel::OM->ObjectParamAdd(
        'Kernel::Language' => {
            UserTimeZone => $Test->{UserTimeZone},
            UserLanguage => 'de',
        },
    );

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    $LanguageObject->{ $Test->{DateFormatName} } = $Test->{DateFormat};

    my $Result = $LanguageObject->FormatTimeString(
        $Test->{Time},
        $Test->{DateFormatName},
        $Test->{Short}
    );

    $Self->Is(
        $Result,
        $Test->{Result},
        "$Test->{Name} - return",
    );
}

1;
