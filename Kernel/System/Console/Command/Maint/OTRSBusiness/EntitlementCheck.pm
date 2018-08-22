# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::OTRSBusiness::EntitlementCheck;

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

    $Self->Description('Check the OTRS Business Solution™ is entitled for this system.');

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

    $Self->Print("<yellow>Checking the $OTRSBusinessStr entitlement status...</yellow>\n");

    my $Force = $Self->GetOption('force') || 0;

    # get OTRS Business object
    my $OTRSBusinessObject = $Kernel::OM->Get('Kernel::System::OTRSBusiness');

    my $OTRSBusinessInstalled = $OTRSBusinessObject->OTRSBusinessIsInstalled();

    if ( !$Force && !$OTRSBusinessInstalled ) {

        $Self->Print("$OTRSBusinessStr is not installed in this system, skipping...\n");
        $Self->Print("<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    my $SystemDataObject = $Kernel::OM->Get('Kernel::System::SystemData');

    my $AvailabilityCheckNextUpdateTime = $SystemDataObject->SystemDataGet(
        Key => 'OTRSBusiness::EntitlementCheck::NextUpdateTime',
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

    # do not update registration info before the next update (unless is forced)
    if ( !$Force && $SystemTime < $NextUpdateSystemTime ) {
        $Self->Print("No need to execute the availability check at this moment, skipping...\n");
        $Self->Print("<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    my $Result = $OTRSBusinessObject->OTRSBusinessEntitlementStatus(
        CallCloudService => 1,
    );

    my $IsInstalled = $OTRSBusinessObject->OTRSBusinessIsInstalled();

    # set the next update time
    $OTRSBusinessObject->OTRSBusinessCommandNextUpdateTimeSet(
        Command => 'EntitlementCheck',
    );

    if ( lc $Result eq 'forbidden' && $IsInstalled ) {
        $Self->PrintError("$OTRSBusinessStr is not entitled for this system.");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
