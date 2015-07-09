# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::ObjectManager;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Stats' => {
        UserID => 1,
    },
);

my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');

my $Stats = $StatsObject->StatsListGet();

$Self->True(
    scalar keys %{$Stats},
    ( scalar keys %{$Stats} ) . " Stats found",
);

STATID:
for my $StatID ( sort { $a <=> $b } keys %{$Stats} ) {
    my $Stat = $StatsObject->StatsGet( StatID => $StatID );

    next STATID if ( $Stat->{StatType} eq 'static' );

    my $ResultLive = $StatsObject->StatsRun(
        StatID   => $StatID,
        GetParam => $Stat,
    );

    $Self->True(
        ref $ResultLive eq 'ARRAY',
        "StatsRun live mode (StatID $StatID)",
    );

    my $ResultPreview = $StatsObject->StatsRun(
        StatID   => $StatID,
        GetParam => $Stat,
        Preview  => 1,
    );

    $Self->True(
        ref $ResultPreview eq 'ARRAY',
        "StatsRun preview mode (StatID $StatID) $Stat->{Object}",
    ) || next STATID;

    $Self->True(
        ref $ResultPreview->[1] eq 'ARRAY',
        "StatsRun preview mode headline (StatID $StatID) $Stat->{Object}",
    ) || next STATID;

    $Self->Is(
        scalar @{ $ResultPreview->[1] },
        scalar @{ $ResultLive->[1] },
        "StatsRun preview result has same number of columns in Row 1 as live result (StatID $StatID) $Stat->{Object}",
    );

    # Ticketlist stats make a ticket search and that could return identical results in preview and live
    #   if there are not enough tickets in the system (for example just one).
    if ($Stat->{Object} ne 'TicketList') {
        $Self->IsNotDeeply(
            $ResultLive,
            $ResultPreview,
            "StatsRun differs between live and preview (StatID $StatID)",
        );
    }
}

1;
