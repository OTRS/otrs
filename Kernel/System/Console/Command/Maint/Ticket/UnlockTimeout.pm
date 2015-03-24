# --
# Kernel/System/Console/Command/Maint/Ticket/UnlockTimeout.pm - console command
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Ticket::UnlockTimeout;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Lock',
    'Kernel::System::State',
    'Kernel::System::Ticket',
    'Kernel::System::Time',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Unlock tickets that are past their unlock timeout.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Unlocking tickets that are past their unlock timeout...</yellow>\n");

    my @UnlockStateIDs = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
        Type   => 'Unlock',
        Result => 'ID',
    );
    my @ViewableLockIDs = $Kernel::OM->Get('Kernel::System::Lock')->LockViewableLock( Type => 'ID' );

    my @Tickets;

    $Kernel::OM->Get('Kernel::System::DB')->Prepare(
        SQL => "
            SELECT st.tn, st.id, st.timeout, sq.unlock_timeout, st.sla_id, st.queue_id
            FROM ticket st, queue sq
            WHERE st.queue_id = sq.id
                AND sq.unlock_timeout != 0
                AND st.ticket_state_id IN ( ${\(join ', ', @UnlockStateIDs)} )
                AND st.ticket_lock_id NOT IN ( ${\(join ', ', @ViewableLockIDs)} ) ",
    );

    while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
        push @Tickets, \@Row;
    }

    TICKET:
    for (@Tickets) {
        my @Row = @{$_};

        # get used calendar
        my $Calendar = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCalendarGet(
            QueueID => $Row[5],
            SLAID   => $Row[4],
        );

        my $CountedTime = $Kernel::OM->Get('Kernel::System::Time')->WorkingTime(
            StartTime => $Row[2],
            StopTime  => $Kernel::OM->Get('Kernel::System::Time')->SystemTime(),
            Calendar  => $Calendar,
        );
        next TICKET if $CountedTime < $Row[3] * 60;

        $Self->Print(" Unlocking ticket id $Row[0]... ");
        my $Unlock = $Kernel::OM->Get('Kernel::System::Ticket')->LockSet(
            TicketID => $Row[1],
            Lock     => 'unlock',
            UserID   => 1,
        );
        if ($Unlock) {
            $Self->Print("<green>done.</green>\n");
        }
        else {
            $Self->Print("<red>failed.</red>\n");
        }
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
