# --
# Kernel/System/Console/Command/Admin/User/Add.pm - console command
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Admin::User::Add;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Group',
    'Kernel::System::User',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Add a user.');
    $Self->AddOption(
        Name        => 'user-name',
        Description => "User name for the new user.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'first-name',
        Description => "First name of the new user.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'last-name',
        Description => "Last name of the new user.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'email-address',
        Description => "Email address of the new user.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'password',
        Description => "Password for the new user. If left empty, a password will be created automatically.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'group',
        Description => "Name of the group to which the new user should be added (with rw permissions!).",
        Required    => 0,
        HasValue    => 1,
        Multiple    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # check if all groups exist
    my @Groups = @{ $Self->GetOption('group') // [] };
    my %GroupList = reverse $Kernel::OM->Get('Kernel::System::Group')->GroupList();

    GROUP:
    for my $Group (@Groups) {
        if ( !$GroupList{$Group} ) {
            die "Group '$Group' does not exist.\n";
        }
        $Self->{Groups}->{ $GroupList{$Group} } = $Group;
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Adding a new user...</yellow>\n");

    # add user
    my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserAdd(
        UserLogin     => $Self->GetOption('user-name'),
        UserFirstname => $Self->GetOption('first-name'),
        UserLastname  => $Self->GetOption('last-name'),
        UserPw        => $Self->GetOption('password'),
        UserEmail     => $Self->GetOption('email-address'),
        ChangeUserID  => 1,
        UserID        => 1,
        ValidID       => 1,
    );

    if ( !$UserID ) {
        $Self->PrintError("Can't add user.");
        return $Self->ExitCodeError();
    }

    for my $GroupID ( sort keys %{ $Self->{Groups} } ) {

        my $Success = $Kernel::OM->Get('Kernel::System::Group')->PermissionGroupUserAdd(
            UID        => $UserID,
            GID        => $GroupID,
            Permission => { 'rw' => 1 },
            UserID     => 1,
        );
        if ($Success) {
            $Self->Print( "<green>User added to group '" . $Self->{Groups}->{$GroupID} . "'</green>\n" );
        }
        else {
            $Self->PrintError( "Failed to add user to group '" . $Self->{Groups}->{$GroupID} . "'." );
        }
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
