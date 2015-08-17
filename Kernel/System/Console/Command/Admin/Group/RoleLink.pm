# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Admin::Group::RoleLink;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Group',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Connect a role to a group.');
    $Self->AddOption(
        Name        => 'role-name',
        Description => 'Name of the role which should be linked to the given group.',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'group-name',
        Description => 'Group name of the group the given role should be linked to.',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name => 'permission',
        Description =>
            'Permissions (ro|move_into|create|note|owner|priority|rw) the role should have for the group which it is going to be linked to.',
        Required   => 1,
        HasValue   => 1,
        Multiple   => 1,
        ValueRegex => qr/(ro|move_into|create|note|owner|priority|rw)/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    $Self->{RoleName}  = $Self->GetOption('role-name');
    $Self->{GroupName} = $Self->GetOption('group-name');

    # check role
    $Self->{RoleID} = $Kernel::OM->Get('Kernel::System::Group')->RoleLookup( Role => $Self->{RoleName} );
    if ( !$Self->{RoleID} ) {
        die "Role $Self->{RoleName} does not exist.\n";
    }

    # check group
    $Self->{GroupID} = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup( Group => $Self->{GroupName} );
    if ( !$Self->{GroupID} ) {
        die "Group $Self->{GroupName} does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Trying to link role $Self->{RoleName} to group $Self->{GroupName}...</yellow>\n");

    my %Permissions;
    for my $Permission (qw(ro move_into create note owner priority rw)) {
        $Permissions{$Permission} = ( grep { $_ eq $Permission } @{ $Self->GetOption('permission') // [] } ) ? 1 : 0;
    }

    # add user 2 group
    if (
        !$Kernel::OM->Get('Kernel::System::Group')->PermissionGroupRoleAdd(
            RID        => $Self->{RoleID},
            GID        => $Self->{GroupID},
            UserID     => 1,
            Permission => {
                %Permissions,
            },
        )
        )
    {
        $Self->PrintError("Can't add role to group.");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
