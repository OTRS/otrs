# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::OCBIMigrateTicketHistory;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Valid',
    'Kernel::System::XML',
);

=head1 NAME

scripts::DBUpdateTo6::OCBIMigrateTicketHistory - Migrate the ticket history for the OmniChannel base infrastructure.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $DBObject  = $Kernel::OM->Get('Kernel::System::DB');
    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

    # get the history type id of the new history type ArticleCreate
    $DBObject->Prepare(
        SQL => "SELECT id
            FROM ticket_history_type
            WHERE name = 'ArticleCreate'
        ",
    );

    my $ArticleCreateHistoryTypeID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ArticleCreateHistoryTypeID = $Row[0];
    }

    # list of history types that will be mapped to new history type ArticleCreate
    my @MappedTicketHistoryTypes = (
        qw(
            EmailAgent
            EmailCustomer
            PhoneCallAgent
            PhoneCallCustomer
            WebRequestCustomer
            SendAnswer
            FollowUp
            AddNote
            SendAutoReject
            SendAutoReply
            SendAutoFollowUp
            Forward
            Bounce
            SystemRequest
            )
    );

    my $HistoryTypeInString = join ', ', map {"'$_'"} @MappedTicketHistoryTypes;

    my $SQL = "
        SELECT id, name
        FROM ticket_history_type
        WHERE name in ($HistoryTypeInString)
    ";

    # get the history type id of needed history types
    return if !$DBObject->Prepare(
        SQL => $SQL,
    );

    my @TicketHistoryTypeIDs;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @TicketHistoryTypeIDs, $Row[0];
    }

    # check if to be mapped history types still exist
    # maybe they have been already deleted because the migration has been executed before
    if (@TicketHistoryTypeIDs) {

        # build history type id In-String
        my $HistoryTypeIDInString = join ', ', sort { $a <=> $b } @TicketHistoryTypeIDs;

        # update the ticket history table, change to be mapped history types to ArticleCreate
        $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => "
                UPDATE ticket_history
                SET history_type_id = ?
                WHERE history_type_id IN ($HistoryTypeIDInString)
            ",
            Bind => [ \$ArticleCreateHistoryTypeID ],
        );

        # check that there are no longer needed history types in the ticket history table
        $DBObject->Prepare(
            SQL => "
                SELECT COUNT(*)
                FROM ticket_history
                WHERE history_type_id IN ($HistoryTypeIDInString)
            ",
        );

        my $Count;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Count = $Row[0];
        }

        # count must be zero, these ticket history types are no longer used
        if ( !$Count ) {

            # delete the no longer used history ticket types
            $DBObject->Do(
                SQL => "
                    DELETE
                    FROM ticket_history_type
                    WHERE name in ($HistoryTypeInString)
                ",
            );
        }

        # log error
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Some of the following ticket history types are still"
                    . " used in the ticket history table: $HistoryTypeInString",
            );
        }
    }

    # copy a_sender_type_id, a_communication_channel_id, a_is_visible_for_customer
    # from article table to ticket_history table
    return if !$DBObject->Do(
        SQL => "
            UPDATE ticket_history
            SET a_sender_type_id = (
                SELECT article.article_sender_type_id
                FROM article
                WHERE article.id = article_id

            ),
            a_communication_channel_id = (
                SELECT article.communication_channel_id
                FROM article
                WHERE article.id = article_id

            ),
            a_is_visible_for_customer = (
                SELECT article.is_visible_for_customer
                FROM article
                WHERE article.id = article_id

            )
            WHERE article_id IS NOT NULL
        ",
    );

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
