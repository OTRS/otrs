# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Session::DeleteExpired;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::AuthSession',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Delete expired sessions.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my @Expired = $Kernel::OM->Get('Kernel::System::AuthSession')->GetExpiredSessionIDs();

    $Self->Print("<yellow>Deleting expired sessions...</yellow>\n");

    for my $SessionID ( @{ $Expired[0] } ) {
        my $Success = $Kernel::OM->Get('Kernel::System::AuthSession')->RemoveSessionID(
            SessionID => $SessionID,
        );

        if ( !$Success ) {
            $Self->PrintError("Session $SessionID could not be deleted.");
            return $Self->ExitCodeError();
        }

        $Self->Print("  $SessionID\n");
    }

    $Self->Print("<yellow>Deleting idle sessions...</yellow>\n");

    for my $SessionID ( @{ $Expired[1] } ) {
        my $Success = $Kernel::OM->Get('Kernel::System::AuthSession')->RemoveSessionID(
            SessionID => $SessionID,
        );

        if ( !$Success ) {
            $Self->PrintError("Session $SessionID could not be deleted.");
            return $Self->ExitCodeError();
        }

        $Self->Print("  $SessionID\n");
    }

    $Self->Print("<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;
