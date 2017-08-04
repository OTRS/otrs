# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::CreateFormDraftTables;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Package',
);

=head1 NAME

scripts::DBUpdateTo6::CreateFormDraftTables - Create form fraft tables.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $DBObject      = $Kernel::OM->Get('Kernel::System::DB');
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
    my $Verbose       = $Param{CommandlineOptions}->{Verbose} || 0;

    # Define the XML data for the form draft table.
    my @XMLStrings = (
        '
            <TableCreate Name="form_draft">
                <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER" />
                <Column Name="object_type" Required="true" Size="200" Type="VARCHAR" />
                <Column Name="object_id" Required="true" Type="INTEGER" />
                <Column Name="action" Required="true" Size="200" Type="VARCHAR" />
                <Column Name="title" Required="false" Size="255" Type="VARCHAR" />
                <Column Name="content" Required="true" Type="LONGBLOB" />
                <Column Name="create_time" Required="true" Type="DATE" />
                <Column Name="create_by" Required="true" Type="INTEGER" />
                <Column Name="change_time" Required="true" Type="DATE" />
                <Column Name="change_by" Required="true" Type="INTEGER" />
                <Index Name="form_draft_object_type_object_id_action">
                    <IndexColumn Name="object_type" />
                    <IndexColumn Name="object_id" />
                    <IndexColumn Name="action" />
                </Index>
                <ForeignKey ForeignTable="users">
                    <Reference Local="create_by" Foreign="id" />
                    <Reference Local="change_by" Foreign="id" />
                </ForeignKey>
            </TableCreate>
        ',
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
