# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

my @Tests = (
    {
        Size   => 13,
        Result => '13 B',
    },
    {
        Size   => 1836,
        Result => '1 KB',
    },
    {
        Size   => 46626123,
        Result => '44 MB',
    },
    {
        Size   => 34508675518,
        Result => '32 GB',
    },
    {
        Size   => 238870572100000,
        Result => '217 TB',
    },
);

for my $Test (@Tests) {
    $Self->Is(
        $LayoutObject->HumanReadableDataSize( Size => $Test->{Size} ),
        $Test->{Result},
        'HumanReadableDataSize()',
    );
}

1;
