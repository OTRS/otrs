# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::Ticket::StaticDBOrphanedRecords;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

sub GetDisplayPath {
    return 'OTRS';
}

sub Run {
    my $Self = shift;

    my $Module = $Self->{ConfigObject}->Get('Ticket::IndexModule');

    if ( $Module !~ /StaticDB/ ) {

        my ( $OrphanedTicketLockIndex, $OrphanedTicketIndex );

        $Self->{DBObject}->Prepare( SQL => 'SELECT count(*) from ticket_lock_index' );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $OrphanedTicketLockIndex = $Row[0];
        }

        if ($OrphanedTicketLockIndex) {
            $Self->AddResultWarning(
                Identifier => 'TicketLockIndex',
                Label      => 'Orphaned Records In ticket_lock_index Table',
                Value      => $OrphanedTicketLockIndex,
                Message =>
                    'Table ticket_lock_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.',
            );
        }
        else {
            $Self->AddResultOk(
                Identifier => 'TicketLockIndex',
                Label      => 'Orphaned Records In ticket_lock_index Table',
                Value      => $OrphanedTicketLockIndex || '0',
            );
        }

        $Self->{DBObject}->Prepare( SQL => 'SELECT count(*) from ticket_index' );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $OrphanedTicketIndex = $Row[0];
        }

        if ($OrphanedTicketLockIndex) {
            $Self->AddResultWarning(
                Identifier => 'TicketIndex',
                Label      => 'Orphaned Records In ticket_index Table',
                Value      => $OrphanedTicketIndex,
                Message =>
                    'Table ticket_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.',
            );
        }
        else {
            $Self->AddResultOk(
                Identifier => 'TicketIndex',
                Label      => 'Orphaned Records In ticket_index Table',
                Value      => $OrphanedTicketIndex || '0',
            );
        }
    }

    return $Self->GetResults();
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut

1;
