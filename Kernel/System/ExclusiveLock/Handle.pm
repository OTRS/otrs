# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ExclusiveLock::Handle;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::ExclusiveLock',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::ExclusiveLock::Handle - scope guard for exclusive locks

=head1 DESCRIPTION

This object's purpose is to make sure that exclusive locks are released
whenever the object goes out of scope.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, instead obtain a lock via L<Kernel::System::ExclusiveLock::ExclusiveLockGet()>.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    if ( !$Param{LockUID} || !$Param{LockKey} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need LockUID and LockKey!",
        );
        return;
    }

    $Self->{LockUID} = $Param{LockUID};
    $Self->{LockKey} = $Param{LockKey};

    return $Self;
}

=head2 LockUIDGet()

Retrieves the internal UID that was generated for this lock.

    my $LockUID = $LockHandle->LockUIDGet();

=cut

sub LockUIDGet {
    my ($Self) = @_;

    return $Self->{LockUID};
}

=head2 DESTROY()

Destructor. Will release this lock on the database, so that the LockHandle can actually be used as a scope guard.

=cut

sub DESTROY {
    my ($Self) = @_;

    $Kernel::OM->Get('Kernel::System::ExclusiveLock')->ExclusiveLockRelease(
        LockUID => $Self->{LockUID},
        LockKey => $Self->{LockKey},
    );

    return;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
