# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::OTRSBusiness::AvailabilityCheck;

use strict;
use warnings;
use utf8;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::OTRSBusiness',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Checks if OTRS Business Solution™ is available for current system.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $OTRSBusinessStr = "OTRS Business Solution™";

    $Self->Print("<yellow>Checking availability of $OTRSBusinessStr...</yellow>\n");

    my $OTRSBusinessObject = $Kernel::OM->Get('Kernel::System::OTRSBusiness');

    # first call the cloud service
    $OTRSBusinessObject->OTRSBusinessIsAvailable();

    # return the off-line status to be tolerant to network failures
    my $Success = $OTRSBusinessObject->OTRSBusinessIsAvailableOffline();

    if ( !$Success ) {
        $Self->Print("  $OTRSBusinessStr is not available for this system.\n");
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
