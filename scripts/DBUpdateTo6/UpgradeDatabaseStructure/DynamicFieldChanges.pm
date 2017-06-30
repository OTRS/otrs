# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::UpgradeDatabaseStructure::DynamicFieldChanges;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = ();

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure::DynamicFieldChanges - Adds a table for dyanmic field object names and creation of an index

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my @XMLStrings = (
        '<Table Name="dynamic_field_obj_id_name">
            <Column Name="object_id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER"/>
            <Column Name="object_name" Required="true" Size="200" Type="VARCHAR"/>
            <Column Name="object_type" Required="true" Size="200" Type="VARCHAR"/>
            <Unique Name="dynamic_field_object_name">
                <UniqueColumn Name="object_name"/>
                <UniqueColumn Name="object_type"/>
            </Unique>
        </Table>',

        '<TableAlter Name="dynamic_field_value">
            <IndexCreate Name="dynamic_field_value_search_text">
                <IndexColumn Name="field_id"/>
                <IndexColumn Name="value_text" Size="150"/>
            </IndexCreate>
        </TableAlter>',
    );

    return if !$Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
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
