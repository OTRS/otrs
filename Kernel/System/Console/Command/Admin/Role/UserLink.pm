# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Admin::Role::UserLink;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::User',
    'Kernel::System::Group',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Connect a user to a role.');
    $Self->AddOption(
        Name        => 'user-name',
        Description => 'Name of the user who should be linked to the given role.',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'role-name',
        Description => 'Name of the role the given user should be linked to.',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {

    my ( $Self, %Param ) = @_;

    $Self->{UserName} = $Self->GetOption('user-name');
    $Self->{RoleName} = $Self->GetOption('role-name');

    # check user
    $Self->{UserID} = $Kernel::OM->Get('Kernel::System::User')->UserLookup( UserLogin => $Self->{UserName} );
    if ( !$Self->{UserID} ) {
        die "User $Self->{UserName} does not exist.\n";
    }

    # check role
    $Self->{RoleID} = $Kernel::OM->Get('Kernel::System::Group')->RoleLookup( Role => $Self->{RoleName} );
    if ( !$Self->{RoleID} ) {
        die "Role $Self->{RoleName} does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Trying to link user $Self->{UserName} to role $Self->{RoleName}...</yellow>\n");

    # add user 2 role
    if (
        !$Kernel::OM->Get('Kernel::System::Group')->PermissionRoleUserAdd(
            UID    => $Self->{UserID},
            RID    => $Self->{RoleID},
            Active => 1,
            UserID => 1,
        )
        )
    {
        $Self->PrintError("Can't add user to role.");
        return $Self->ExitCodeError();
    }

    $Self->Print("Done.\n");
    return $Self->ExitCodeOk();
}

1;
