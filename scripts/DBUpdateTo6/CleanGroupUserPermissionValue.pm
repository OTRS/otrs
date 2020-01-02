# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::CleanGroupUserPermissionValue;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo6::CleanGroupUserPermissionValue - Delete from table group_user all the records where
permission_value is '0'.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $ColumnExists = $Self->ColumnExists(
        Table  => 'group_user',
        Column => 'permission_value',
    );

    # If column has already been dropped, no migration is needed.
    return 1 if !$ColumnExists;

    return if !$Self->_DeleteInvalidRecords();
    return if !$Self->_DropPermissionValueColumn();

    return 1;
}

=head2 _DeleteInvalidRecords()

Remove all records where permission_value = 0.

    my $Result = $DBUpdateTo6Object->_DeleteInvalidRecords;

Returns 1 if the delete went well.

=cut

sub _DeleteInvalidRecords {
    my ( $Self, %Param ) = @_;

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => 'DELETE FROM group_user WHERE permission_value = 0',
    );

    return 1;
}

=head2 _DeleteInvalidRecords()

Drop the column 'permission_value'.

    my $Result = $DBUpdateTo6Object->_DropPermissionValueColumn;

Returns 1 if the drop went well.

=cut

sub _DropPermissionValueColumn {
    my ( $Self, %Param ) = @_;

    my @XMLStrings = (
        '
        <TableAlter Name="group_user">
            <ColumnDrop Name="permission_value"/>
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
