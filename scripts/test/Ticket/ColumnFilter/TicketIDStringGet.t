# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get ticket object
my $ColumnFilterObject = $Kernel::OM->Get('Kernel::System::Ticket::ColumnFilter');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my @Tests = (
    {
        Name   => 'No array',
        Params => {
            ColumnName => 'ticket.id',
            TicketIDs  => 1,
        },
        Result => undef,
    },
    {
        Name   => 'Single Integer',
        Params => {
            ColumnName => 'ticket.id',
            TicketIDs  => [1],
        },
        Result => ' AND (  ticket.id IN (1)  ) ',
    },
    {
        Name   => 'Single Integer, default table',
        Params => {
            TicketIDs => [1],
        },
        Result => ' AND (  t.id IN (1)  ) ',
    },
    {
        Name   => 'Single Integer, no AND',
        Params => {
            TicketIDs  => [1],
            IncludeAdd => 0,
        },
        Result => ' t.id IN (1) ',
    },
    {
        Name   => 'Sorted values',
        Params => {
            ColumnName => 'ticket.id',
            TicketIDs  => [ 2, 1, -1, 0 ],
        },
        Result => ' AND (  ticket.id IN (-1, 0, 1, 2)  ) ',
    },
    {
        Name   => 'Invalid value',
        Params => {
            ColumnName => 'ticket.id',
            TicketIDs  => [1.1],
        },
        Result => undef,
    },
    {
        Name   => 'Mix of valid and invalid values',
        Params => {
            ColumnName => 'ticket.id',
            TicketIDs  => [ 1, 1.1 ],
        },
        Result => undef,
    },
);

for my $Test (@Tests) {
    $Self->Is(
        scalar $ColumnFilterObject->_TicketIDStringGet( %{ $Test->{Params} } ),
        $Test->{Result},
        "$Test->{Name} _TicketIDStringGet()"
    );
}

# cleanup is done by RestoreDatabase.

1;
