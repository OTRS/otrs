# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::OTRSBusiness::EntitlementCheck;

use strict;
use warnings;
use utf8;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::OTRSBusiness',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Check the OTRS Business Solution™ is entitled for this system.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $OTRSBusinessStr = "OTRS Business Solution™";

    $Self->Print("<yellow>Checking the $OTRSBusinessStr entitlement status...</yellow>\n");

    # get OTRS Business object
    my $OTRSBusinessObject = $Kernel::OM->Get('Kernel::System::OTRSBusiness');

    my $OTRSBusinessInstalled = $OTRSBusinessObject->OTRSBusinessIsInstalled();

    if ( !$OTRSBusinessInstalled ) {

        $Self->Print("$OTRSBusinessStr is not installed in this system, skipping...\n");
        $Self->Print("<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    my $Result = $OTRSBusinessObject->OTRSBusinessEntitlementStatus(
        CallCloudService => 1,
    );

    my $IsInstalled = $OTRSBusinessObject->OTRSBusinessIsInstalled();

    if ( lc $Result eq 'forbidden' && $IsInstalled ) {
        $Self->PrintError("$OTRSBusinessStr is not entitled for this system.");
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
