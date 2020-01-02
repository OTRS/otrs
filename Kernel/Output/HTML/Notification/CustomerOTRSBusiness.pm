# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Notification::CustomerOTRSBusiness;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;
use utf8;

our @ObjectDependencies = (
    'Kernel::System::OTRSBusiness',
    'Kernel::Output::HTML::Layout',
);

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    # get OTRS business object
    my $OTRSBusinessObject = $Kernel::OM->Get('Kernel::System::OTRSBusiness');

    return '' if !$OTRSBusinessObject->OTRSBusinessIsInstalled();

    #
    # check entitlement status
    #
    my $EntitlementStatus = $OTRSBusinessObject->OTRSBusinessEntitlementStatus(
        CallCloudService => 0,
    );

    if ( $EntitlementStatus eq 'warning-error' || $EntitlementStatus eq 'forbidden' ) {

        my $OTRSBusinessLabel;
        if ( $OTRSBusinessObject->OTRSSTORMIsInstalled() ) {
            $OTRSBusinessLabel = '<b>STORM powered by OTRS</b>™';
        }
        elsif ( $OTRSBusinessObject->OTRSCONTROLIsInstalled() ) {
            $OTRSBusinessLabel = '<b>CONTROL powered by OTRS</b>™';
        }
        else {
            $OTRSBusinessLabel = '<b>OTRS Business Solution</b>™';
        }

        # get layout object
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

        my $Text = $LayoutObject->{LanguageObject}->Translate(
            'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!',
            $OTRSBusinessLabel,
            'sales@otrs.com',    # no mailto link as these are currently not displayed in the CI
        );
        $Output .= $LayoutObject->Notify(
            Data     => $Text,
            Priority => 'Error',
        );
    }

    return $Output;
}

1;
