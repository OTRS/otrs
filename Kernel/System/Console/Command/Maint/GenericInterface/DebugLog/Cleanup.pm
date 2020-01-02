# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::GenericInterface::DebugLog::Cleanup;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::GenericInterface::DebugLog',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Delete Generic Interface debug log entries.');

    $Self->AddOption(
        Name        => 'created-before-days',
        Description => "Remove debug log entries created more than ... days ago.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    if ( $Self->GetOption('created-before-days') eq '0' ) {
        die "created-before-days must be greater than 0\n";
    }
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Deleting Generic Interface debug log entries...</yellow>\n");

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    my $Success = $DateTimeObject->Subtract(
        Days => $Self->GetOption('created-before-days'),
    );

    $Success = $Kernel::OM->Get('Kernel::System::GenericInterface::DebugLog')->LogCleanup(
        CreatedAtOrBefore => $DateTimeObject->ToString(),
    );

    if ( !$Success ) {
        $Self->Print("<green>Fail.</green>\n");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
