# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::DropObjectLockState;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo6::DropObjectLockState - Drops object lock state table.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # check if table still exists
    my $TableExists = $Self->TableExists(
        Table => 'gi_object_lock_state',
    );

    return 1 if !$TableExists;

    # get number of remaining entries
    return if !$DBObject->Prepare(
        SQL => 'SELECT COUNT(*) FROM gi_object_lock_state',
    );

    my $Count;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Count = $Row[0];
    }

    # delete table but only if table is empty
    # if there are some entries left, these must be deleted by other modules
    # so we give them a chance to be migrated from these modules
    if ($Count) {
        print
            "\n    There are still entries in your gi_object_lock_state table, therefore it will not be deleted.\n";
        return 1;
    }

    # drop table 'gi_object_lock_state'
    my $XMLString = '<TableDrop Name="gi_object_lock_state"/>';

    return if !$Self->ExecuteXMLDBString( XMLString => $XMLString );

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
