# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Ticket::QueueIndexRebuild;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Ticket',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Rebuild the ticket index for AgentTicketQueue.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Rebuilding ticket index...</yellow>\n");

    if ( $Kernel::OM->Get('Kernel::System::Ticket')->TicketAcceleratorRebuild() ) {
        $Self->Print("<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }
    return $Self->ExitCodeError();
}

1;
