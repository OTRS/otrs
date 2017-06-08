# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::CleanGroupUserPermissionValue;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::XML',
);

=head1 NAME

scripts::DBUpdateTo6::CleanGroupUserPermissionValues - Delete from table group_user all the records where permission_value is '0'.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQL    = 'SELECT * FROM group_user';
    my $Result = $DBObject->Prepare(
        SQL   => $SQL,
        Limit => 1,
    );
    if ( !$Result ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Error during execution of '$SQL'!",
        );
        return;
    }

    my %GroupUserColumns = map { ( lc $_ => 1 ) } $DBObject->GetColumnNames();
    if ( $GroupUserColumns{'permission_value'} ) {
        return if !$Self->_DeleteInvalidRecords();
        return if !$Self->_DropPermissionValueColumn();
    }

    return 1;
}

=head2 _DeleteInvalidRecords()

Remove all records where permission_value = 0.

    my $Result = $DBUpdateTo6Object->_DeleteInvalidRecords;

Returns 1 if the delete went well.

=cut

sub _DeleteInvalidRecords {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    return if !$DBObject->Do(
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

    my $DBObject  = $Kernel::OM->Get('Kernel::System::DB');
    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

    my $XMLString = <<'END_XML';
    <TableAlter Name="group_user">
        <ColumnDrop Name="permission_value"/>
    </TableAlter>
END_XML

    # create database specific SQL and PostSQL commands
    my @XMLARRAY = $XMLObject->XMLParse( String => $XMLString );

    # create database specific SQL
    my ($SQL) = $DBObject->SQLProcessor(
        Database => \@XMLARRAY,
    );

    my $Success = $DBObject->Do( SQL => $SQL );
    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Error during execution of '$SQL'!",
        );
        return;
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
