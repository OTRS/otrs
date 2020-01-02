# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Admin::Group::Add;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Group'
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Create a new group.');
    $Self->AddOption(
        Name        => 'name',
        Description => "Name of the new group.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'comment',
        Description => "Comment for the new group.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Creating a new group...</yellow>\n");

    my $Success = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
        UserID  => 1,
        ValidID => 1,
        Comment => $Self->GetOption('comment'),
        Name    => $Self->GetOption('name'),
    );

    # error handling
    if ( !$Success ) {
        $Self->PrintError("Can't create group.\n");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;
