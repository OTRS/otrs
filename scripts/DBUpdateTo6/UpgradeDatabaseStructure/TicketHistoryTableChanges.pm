# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::UpgradeDatabaseStructure::TicketHistoryTableChanges;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure::TicketHistoryTableChanges - add new index to ticket_history table.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my @XMLStrings = (

        # Speed up deleting of ticket_history entries for articles, see bug#12374
        '<TableAlter Name="ticket_history">
            <IndexCreate Name="ticket_history_article_id">
                <IndexColumn Name="article_id"/>
            </IndexCreate>
        </TableAlter>',

    );

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Add new EmailResend ticket history type, but only if it hasn't been added already.
    #   This check is done via 'name' column of the 'ticket_history_type' table, since it has unique index and common
    #   check for auto-incremented ID might fail in certain cases.
    $DBObject->Prepare(
        SQL   => "SELECT COUNT(id) FROM ticket_history_type WHERE name = ?",
        Bind  => [ \'EmailResend' ],
        Limit => 1,
    );

    my $Exists;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Exists = $Row[0];
    }

    if ( !$Exists ) {
        push @XMLStrings,
            '<Insert Table="ticket_history_type">
                <Data Key="id" Type="AutoIncrement">51</Data>
                <Data Key="name" Type="Quote">EmailResend</Data>
                <Data Key="valid_id">1</Data>
                <Data Key="create_by">1</Data>
                <Data Key="create_time">current_timestamp</Data>
                <Data Key="change_by">1</Data>
                <Data Key="change_time">current_timestamp</Data>
            </Insert>';
    }

    return if !$Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
