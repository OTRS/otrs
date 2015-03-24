# --
# Kernel/System/Console/Command/Maint/Ticket/UnlockTicket.pm - console command
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Ticket::UnlockTicket;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Ticket',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Unlock a single ticket by force.');
    $Self->AddArgument(
        Name        => 'ticket-id',
        Description => "Ticket to be unlocked by force.",
        Required    => 1,
        ValueRegex  => qr/\d+/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $TicketID = $Self->GetArgument('ticket-id');

    $Self->Print("<yellow>Unlocking ticket $TicketID...</yellow>\n");

    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID => $TicketID,
        Silent   => 1,
    );

    if ( !%Ticket ) {
        $Self->PrintError("Could not find ticket $TicketID.");
        return $Self->ExitCodeError();
    }

    my $Unlock = $Kernel::OM->Get('Kernel::System::Ticket')->LockSet(
        TicketID => $TicketID,
        Lock     => 'unlock',
        UserID   => 1,
    );
    if ( !$Unlock ) {
        $Self->PrintError('Failed.');
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
