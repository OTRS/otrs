# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
