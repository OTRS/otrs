# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::UpgradeDatabaseStructure::ArticleTableChangesRename;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure::ArticleTableChangesRename - Actual renaming of article tables.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my @XMLStrings = (

        # Renaming of the tables article, article_plain and article_attachment
        '<TableAlter NameOld="article" NameNew="article_data_mime"/>',
        '<TableAlter NameOld="article_plain" NameNew="article_data_mime_plain"/>',
        '<TableAlter NameOld="article_attachment" NameNew="article_data_mime_attachment"/>',
    );

    XMLSTRING:
    for my $XMLString (@XMLStrings) {

        # extract table name from XML string
        if ( $XMLString =~ m{ <TableAlter \s+ NameOld="([^"]+)" \s+ NameNew="([^"]+)" }xms ) {

            my $OldTableName = $1;
            my $NewTableName = $2;

            next XMLSTRING if !$OldTableName;
            next XMLSTRING if !$NewTableName;

            # check if old table exists
            my $OldTableExists = $Self->TableExists(
                Table => $OldTableName,
            );

            # the old table must still exist
            next XMLSTRING if !$OldTableExists;

            # check if new table exists already
            my $NewTableExists = $Self->TableExists(
                Table => $NewTableName,
            );

            # the new table must not yet exist
            next XMLSTRING if $NewTableExists;
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
