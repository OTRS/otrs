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

# get DB object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# ------------------------------------------------------------ #
# Statement size checks (test 11)
# ------------------------------------------------------------ #
for my $QuerySize (
    100, 500, 1_000, 1_050, 2_000, 2_100, 3_000, 3_200,
    4_000, 4_400, 5_000, 10_000, 100_000, 1_000_000
    )
{
    my $SQL = 'SELECT' . ( ' ' x ( $QuerySize - 31 ) ) . '1 FROM valid WHERE id = 1';

    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#11 QuerySize check for size $QuerySize",
    );
}

my @Tests = (
    {
        Name   => 'empty',
        Data   => '',
        Result => '',
    },
    {
        Name   => 'string',
        Data   => '123 ( (( )) ) & && | ||',
        Result => '123 \( \(\( \)\) \) \& \&\& \| \|\|',
    },
);

for my $Test (@Tests) {
    my $Result = $DBObject->QueryStringEscape(
        QueryString => $Test->{Data}
    );

    $Self->Is(
        $Result,
        $Test->{Result},
        'QueryStringEscape - ' . $Test->{Name}
    );
}

1;
