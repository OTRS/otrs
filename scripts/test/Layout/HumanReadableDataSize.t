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

my @Tests = (
    {
        Size   => 'abc',
        Result => undef,
    },
    {
        Result => undef,
    },
    {
        Size   => 0,
        Result => '0 B',
    },
    {
        Size   => 13,
        Result => '13 B',
    },
    {
        Size   => 1024,
        Result => '1 KB',
    },
    {
        Size   => 2500,
        Result => '2.4 KB',
    },
    {
        Size     => 2500,
        Result   => '2,4 KB',
        Language => 'sr_Latn',
    },
    {
        Size     => 2500,
        Result   => '2.4 KB',
        Language => 'ar_SA',    # empty decimal separator
    },
    {
        Size   => 46137344,
        Result => '44 MB',
    },
    {
        Size   => 58626123,
        Result => '55.9 MB',
    },
    {
        Size     => 58626123,
        Result   => '55,9 MB',
        Language => 'sr_Latn',
    },
    {
        Size     => 58626123,
        Result   => '55.9 MB',
        Language => 'ar_SA',     # empty decimal separator
    },
    {
        Size   => 34359738368,
        Result => '32 GB',
    },
    {
        Size   => 64508675518,
        Result => '60.1 GB',
    },
    {
        Size     => 64508675518,
        Result   => '60,1 GB',
        Language => 'sr_Latn',
    },
    {
        Size     => 64508675518,
        Result   => '60.1 GB',
        Language => 'ar_SA',       # empty decimal separator
    },
    {
        Size   => 238594023227392,
        Result => '217 TB',
    },
    {
        Size   => 498870572100000,
        Result => '453.7 TB',
    },
    {
        Size     => 498870572100000,
        Result   => '453,7 TB',
        Language => 'sr_Latn',
    },
    {
        Size     => 498870572100000,
        Result   => '453.7 TB',
        Language => 'ar_SA',           # empty decimal separator
    },
);

for my $Test (@Tests) {
    if ( !$Test->{Language} ) {
        $Test->{Language} = 'en';
    }
    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::Output::HTML::Layout',
            'Kernel::Language',
        ],
    );
    $Kernel::OM->ObjectParamAdd(
        'Kernel::Output::HTML::Layout' => {
            Lang => $Test->{Language},
        },
    );

    my $Result = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->HumanReadableDataSize(
        Size => $Test->{Size},
    );

    $Test->{Size} //= 'undef';
    $Self->Is(
        $Result,
        $Test->{Result},
        "HumanReadableDataSize( Size => $Test->{Size})",
    );
}

1;
