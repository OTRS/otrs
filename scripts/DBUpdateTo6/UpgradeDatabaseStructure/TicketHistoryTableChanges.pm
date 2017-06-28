# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

    XMLSTRING:
    for my $XMLString (@XMLStrings) {

        # extract table name from XML string (for adding columns)
        if ( $XMLString =~ m{ <TableAlter \s+ Name="([^"]+)" }xms ) {
            my $TableName = $1;

            next XMLSTRING if !$TableName;

            # extract columns that should be dropped from XML string
            if ( $XMLString =~ m{ <ColumnAdd \s+ Name="([^"]+)" }xms ) {
                my $ColumnName = $1;

                next XMLSTRING if !$ColumnName;

                my $ColumnExists = $Self->ColumnExists(
                    Table  => $TableName,
                    Column => $ColumnName,
                );

                # skip creating the column if the column exists already
                next XMLSTRING if $ColumnExists;
            }
        }

        # extract table name from XML string (for insert statements)
        elsif ( $XMLString =~ m{ <Insert \s+ Table="([^"]+)" }xms ) {

            my $TableName = $1;

            next XMLSTRING if !$TableName;

            # extract name column and value for name field
            if ( $XMLString =~ m{ <Data \s+ Key="name" \s+ Type="Quote"> ([^<>]+) }xms ) {

                my $ColumnName  = 'name';
                my $ColumnValue = $1;

                next XMLSTRING if !$ColumnName;
                next XMLSTRING if !$ColumnValue;

                my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

                # check if value exists already
                return if !$DBObject->Prepare(
                    SQL   => "SELECT $ColumnName FROM $TableName WHERE $ColumnName = ?",
                    Bind  => [ \$ColumnValue ],
                    Limit => 1,
                );

                my $Exists;
                while ( my @Row = $DBObject->FetchrowArray() ) {
                    $Exists = $Row[0];
                }

                # skip this entry if it exists already
                next XMLSTRING if $Exists;
            }
        }

        return if !$Self->ExecuteXMLDBString( XMLString => $XMLString );
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
