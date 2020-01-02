# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Admin::Group::UserLink;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Group',
    'Kernel::System::User',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Connect a user to a group.');
    $Self->AddOption(
        Name        => 'user-name',
        Description => 'Name of the user who should be linked to the given group.',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'group-name',
        Description => 'Name of the group the given user should be linked to.',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name => 'permission',
        Description =>
            'Permissions (ro|move_into|create|owner|priority|rw) the given user should have for the group he is going to be linked to.',
        Required   => 1,
        HasValue   => 1,
        ValueRegex => qr/(ro|move_into|create|owner|priority|rw)/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    $Self->{UserName}  = $Self->GetOption('user-name');
    $Self->{GroupName} = $Self->GetOption('group-name');

    # check user
    $Self->{UserID} = $Kernel::OM->Get('Kernel::System::User')->UserLookup( UserLogin => $Self->{UserName} );
    if ( !$Self->{UserID} ) {
        die "User $Self->{UserName} does not exist.\n";
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

    $Self->Print("<yellow>Trying to link user $Self->{UserName} to group $Self->{GroupName}...</yellow>\n");

    my %Permissions;
    for my $Permission (qw(ro move_into create owner priority rw)) {
        $Permissions{$Permission} = ( $Self->GetOption('permission') eq $Permission ) ? 1 : 0;
    }

    # add user 2 group
    if (
        !$Kernel::OM->Get('Kernel::System::Group')->PermissionGroupUserAdd(
            UID        => $Self->{UserID},
            GID        => $Self->{GroupID},
            Active     => 1,
            UserID     => 1,
            Permission => {
                %Permissions,
            },
        )
        )
    {
        $Self->PrintError("Can't add user to group.");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done</green>.\n");
    return $Self->ExitCodeOk();
}

1;
