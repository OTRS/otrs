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
    'Kernel::System::SystemData',
    'Kernel::System::Time',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Checks if OTRS Business Solution™ is available for the current system.');

    $Self->AddOption(
        Name        => 'force',
        Description => "Force to execute even if next update time has not been reached yet.",
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $OTRSBusinessStr = "OTRS Business Solution™";

    $Self->Print("<yellow>Checking availability of $OTRSBusinessStr...</yellow>\n");

    my $SystemDataObject = $Kernel::OM->Get('Kernel::System::SystemData');

    my $AvailabilityCheckNextUpdateTime = $SystemDataObject->SystemDataGet(
        Key => 'OTRSBusiness::AvailabilityCheck::NextUpdateTime',
    );

    my $NextUpdateSystemTime = 0;

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # if there is a defined NextUpdeTime convert it system time
    if ($AvailabilityCheckNextUpdateTime) {
        $NextUpdateSystemTime = $TimeObject->TimeStamp2SystemTime(
            String => $AvailabilityCheckNextUpdateTime,
        );
    }

    my $SystemTime = $TimeObject->SystemTime();

    my $Force = $Self->GetOption('force') || 0;

    # do not update registration info before the next update (unless is forced)
    if ( !$Force && $SystemTime < $NextUpdateSystemTime ) {
        $Self->Print("No need to execute the availability check at this moment, skipping...\n");
        $Self->Print("<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    my $OTRSBusinessObject = $Kernel::OM->Get('Kernel::System::OTRSBusiness');

    # first call the cloud service
    $OTRSBusinessObject->OTRSBusinessIsAvailable();

    # return the off-line status to be tolerant to network failures
    my $Success = $OTRSBusinessObject->OTRSBusinessIsAvailableOffline();

    if ( !$Success ) {
        $Self->Print("  $OTRSBusinessStr is not available for this system.\n");
    }

    # set the next update time
    $OTRSBusinessObject->OTRSBusinessCommandNextUpdateTimeSet(
        Command => 'AvailabilityCheck',
    );

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
