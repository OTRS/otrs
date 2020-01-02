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

# get layout object
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my @Tests = (
    {
        Age                     => 20 * 60,
        Space                   => ' ',
        CustomerAgeShort        => '20 m',
        CustomerAgeLong         => '20 minute(s)',
        CustomerAgeInHoursShort => '20 m',
        CustomerAgeInHoursLong  => '20 minute(s)',
        Name                    => "20 minutes",
    },
    {
        Age                     => 60 * 60 + 60,
        Space                   => ' ',
        CustomerAgeShort        => '1 h 1 m',
        CustomerAgeLong         => '1 hour(s) 1 minute(s)',
        CustomerAgeInHoursShort => '1 h 1 m',
        CustomerAgeInHoursLong  => '1 hour(s) 1 minute(s)',
        Name                    => "1 hour 1 minute",
    },
    {
        Age                     => 2 * 60 * 60 + 2 * 60,
        Space                   => ' ',
        CustomerAgeShort        => '2 h 2 m',
        CustomerAgeLong         => '2 hour(s) 2 minute(s)',
        CustomerAgeInHoursShort => '2 h 2 m',
        CustomerAgeInHoursLong  => '2 hour(s) 2 minute(s)',
        Name                    => "2 hours 2 minutes",
    },
    {
        Age                     => 3 * 24 * 60 * 60 + 3 * 60 * 60 + 3 * 60,
        Space                   => ' ',
        CustomerAgeShort        => '3 d 3 h ',
        CustomerAgeLong         => '3 day(s) 3 hour(s) ',
        CustomerAgeInHoursShort => '75 h 3 m',
        CustomerAgeInHoursLong  => '75 hour(s) 3 minute(s)',
        Name                    => "3 days 3 hours",
    },
    {
        Age                     => 3 * 24 * 60 * 60 + 3 * 60 * 60 + 3 * 60,
        Space                   => ' ',
        CustomerAgeShort        => '3 d 3 h 3 m',
        CustomerAgeLong         => '3 day(s) 3 hour(s) 3 minute(s)',
        TimeShowAlwaysLong      => 1,
        CustomerAgeInHoursShort => '75 h 3 m',
        CustomerAgeInHoursLong  => '75 hour(s) 3 minute(s)',
        Name                    => "3 days 3 hours with AlwaysLong",
    },
);

for my $Test (@Tests) {
    $ConfigObject->Set(
        Key   => 'TimeShowCompleteDescription',
        Value => 0,
    );
    $ConfigObject->Set(
        Key   => 'TimeShowAlwaysLong',
        Value => $Test->{TimeShowAlwaysLong} // 0,
    );
    $Self->Is(
        $LayoutObject->CustomerAge(
            Age   => $Test->{Age},
            Space => $Test->{Space},
        ),
        $Test->{CustomerAgeShort},
        "$Test->{Name} - CustomerAge - short",
    );
    $Self->Is(
        $LayoutObject->CustomerAgeInHours(
            Age   => $Test->{Age},
            Space => $Test->{Space},
        ),
        $Test->{CustomerAgeInHoursShort},
        "$Test->{Name} - CustomerAgeInHours - short",
    );
    $ConfigObject->Set(
        Key   => 'TimeShowCompleteDescription',
        Value => 1,
    );
    $Self->Is(
        $LayoutObject->CustomerAge(
            Age   => $Test->{Age},
            Space => $Test->{Space},
        ),
        $Test->{CustomerAgeLong},
        "$Test->{Name} - long",
    );
    $Self->Is(
        $LayoutObject->CustomerAgeInHours(
            Age   => $Test->{Age},
            Space => $Test->{Space},
        ),
        $Test->{CustomerAgeInHoursLong},
        "$Test->{Name} - CustomerAgeInHours - short",
    );
}

1;
