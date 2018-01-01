# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Config::Sync;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::SysConfig'
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Synchronize system configuration file with the latest deployment in the database.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Synchronizing system configuration...</yellow>\n");

    my $Success = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationDeploySync();

    if ( !$Success ) {
        $Self->PrintError("Could not synchronize system configuration\n");
        $Self->Print("\n<red>Fail.</red>\n");
        return $Self->ExitCodeError();
    }

    $Self->Print("\n<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
