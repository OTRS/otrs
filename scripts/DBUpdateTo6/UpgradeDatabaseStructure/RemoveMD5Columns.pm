# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::UpgradeDatabaseStructure::RemoveMD5Columns;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = ();

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure::RemoveMD5Columns - remove no longer needed MD5 columns from some tables

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    # split each unique drop / column drop into separate statements
    # so we are able to skip some of them if neccessary
    my @XMLStrings = (
        '<TableAlter Name="gi_webservice_config">
            <UniqueDrop Name="gi_webservice_config_config_md5"/>
        </TableAlter>',

        '<TableAlter Name="gi_webservice_config">
            <ColumnDrop Name="config_md5"/>
        </TableAlter>',

        '<TableAlter Name="cloud_service_config">
            <UniqueDrop Name="cloud_service_config_config_md5"/>
        </TableAlter>',

        '<TableAlter Name="cloud_service_config">
            <ColumnDrop Name="config_md5"/>
        </TableAlter>',
    );

    XMLSTRING:
    for my $XMLString (@XMLStrings) {

        # extract table name from XML string
        if ( $XMLString =~ m{ <TableAlter \s+ Name="([^"]+)" }xms ) {
            my $TableName = $1;

            next XMLSTRING if !$TableName;

            # extract columns that should be dropped from XML string
            if ( $XMLString =~ m{ <ColumnDrop \s+ Name="([^"]+)" }xms ) {
                my $ColumnName = $1;

                next XMLSTRING if !$ColumnName;

                my $ColumnExists = $Self->ColumnExists(
                    Table  => $TableName,
                    Column => $ColumnName,
                );

                # skip dropping the column if the column does not exist
                next XMLSTRING if !$ColumnExists;
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
