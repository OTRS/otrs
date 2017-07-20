# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::MigrateTicketMergedHistory;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateTicketMergedHistory - Migrate the ticket merged history name values.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Get the history type id of the type Merged.
    $DBObject->Prepare(
        SQL => "SELECT id
            FROM ticket_history_type
            WHERE name = 'Merged'
        ",
    );

    my $TicketMergedHistoryTypeID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $TicketMergedHistoryTypeID = $Row[0];
    }

    # Prepare ticket history merged IDs and names.
    $DBObject->Prepare(
        SQL => "SELECT id, name
            FROM ticket_history
            WHERE history_type_id = ?",
        Bind => [ \$TicketMergedHistoryTypeID ],
    );

    my @TicketMergedHistories;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @TicketMergedHistories, {
            HistoryID   => $Row[0],
            HistoryName => $Row[1],
        };
    }

    if (@TicketMergedHistories) {
        for my $HistoryMergedData (@TicketMergedHistories) {

            # Migrate merged history name from
            #   "Merged Ticket (MergeTicketNumber/MergeTicketID) to (MainTicketNumber/MainTicketID)"
            #   into "%%MergeTicketNumber%%MergeTicketID%%MainTicketNumber%%MainTicketID".
            if ( $HistoryMergedData->{HistoryName} =~ m{Merged Ticket \((\w+)/(\w+)\) to \((\w+)/(\w+)\)} ) {
                $DBObject->Do(
                    SQL => "UPDATE ticket_history
                        SET name = '%%$1%%$2%%$3%%$4'
                        WHERE id = ?",
                    Bind => [ \$HistoryMergedData->{HistoryID} ],
                );
            }
        }
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
