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

# Broken on certain Perl 5.28 versions due to a Perl crash that we can't work around.
my @BlacklistPerlVersions = (
    v5.26.1,
    v5.26.3,
    v5.28.1,
    v5.28.2,
    v5.30.0,
    v5.30.1,
    v5.30.2,
);

if ( grep { $^V eq $_ } @BlacklistPerlVersions ) {
    $Self->True( 1, "Current Perl version $^V is known to be buggy for this test, skipping." );
    return 1;
}

#
# Tests for validating DateTime object values
#
my @TestConfigs = (
    {
        Params => {
            Year     => 2016,
            Month    => '01',
            Day      => 22,
            Hour     => '01',
            Minute   => '01',
            Second   => '01',
            TimeZone => 'Europe/Berlin',
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year     => 2016,
            Month    => '02',
            Day      => 29,
            Hour     => '01',
            Minute   => '01',
            Second   => '01',
            TimeZone => 'Europe/Berlin',
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year     => 2016,
            Month    => '02',
            Day      => 30,
            Hour     => '01',
            Minute   => '01',
            Second   => '01',
            TimeZone => 'Europe/Berlin',
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year     => 2015,
            Month    => '02',
            Day      => 29,
            Hour     => '01',
            Minute   => '01',
            Second   => '01',
            TimeZone => 'Europe/Berlin',
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year     => 2016,
            Month    => 12,
            Day      => 29,
            Hour     => '00',
            Minute   => '00',
            Second   => '00',
            TimeZone => 'UTC',
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year     => 2016,
            Month    => 12,
            Day      => 29,
            Hour     => '00',
            Minute   => '00',
            Second   => '00',
            TimeZone => 'NoValidTimeZone',
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year     => 2016,
            Month    => 12,
            Day      => 29,
            Hour     => 24,
            Minute   => '00',
            Second   => '00',
            TimeZone => 'UTC',
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year     => 2016,
            Month    => 12,
            Day      => 29,
            Hour     => 14,
            Minute   => 60,
            Second   => '00',
            TimeZone => 'UTC',
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year     => 2016,
            Month    => 12,
            Day      => 29,
            Hour     => 14,
            Minute   => 59,
            Second   => 60,
            TimeZone => 'UTC',
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year     => 2016,
            Month    => 12,
            Day      => 29,
            Hour     => 14,
            Minute   => 59,
            Second   => 59,
            TimeZone => 'UTC',
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year     => 'invalid',
            Month    => 12,
            Day      => 'invalid',
            Hour     => 14,
            Minute   => 590,
            Second   => 59,
            TimeZone => 'invalid',
        },
        SuccessExpected => 0,
    },
);

TESTCONFIG:
for my $TestConfig (@TestConfigs) {

    my $Params = $TestConfig->{Params};

    my $DateTimeObject      = $Kernel::OM->Create('Kernel::System::DateTime');
    my $DateTimeValuesValid = $DateTimeObject->Validate( %{$Params} );

    $Self->Is(
        $DateTimeValuesValid ? 1 : 0,
        $TestConfig->{SuccessExpected},
        "'$Params->{Year}-$Params->{Month}-$Params->{Day} $Params->{Hour}:$Params->{Minute}:$Params->{Second} $Params->{TimeZone}' must be validated as "
            . ( $TestConfig->{SuccessExpected} ? 'valid' : 'invalid ' ) . '.',
    );
}

# Tests for failing calls to Validate() due to missing or unsupported parameters
my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
@TestConfigs = (
    {
        Name   => 'without parameters',
        Params => {},
    },
    {
        Name   => 'with invalid year',
        Params => {
            Year => 'invalid',
        },
    },
    {
        Name   => 'with valid year and invalid month',
        Params => {
            Year  => 2016,
            Month => 'invalid',
        },
    },
    {
        Name   => 'with unsupported parameter',
        Params => {
            UnsupportedParameter => 2,
        },
    },
    {
        Name   => 'with unsupported parameter and valid year',
        Params => {
            UnsupportedParameter => 2,
            Year                 => 2016,
        },
    },
);

for my $TestConfig (@TestConfigs) {
    my $DateTimeObjectClone = $DateTimeObject->Clone();
    my $Result              = $DateTimeObjectClone->Validate( %{ $TestConfig->{Params} } );
    $Self->False(
        $Result,
        "Validate() $TestConfig->{Name} must fail.",
    );

    $Self->IsDeeply(
        $DateTimeObjectClone->Get(),
        $DateTimeObject->Get(),
        'DateTime object must be unchanged after failed Validate().',
    );
}

1;
