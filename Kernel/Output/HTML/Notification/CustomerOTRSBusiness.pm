# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Notification::CustomerOTRSBusiness;

use strict;
use warnings;
use utf8;

our @ObjectDependencies = (
    'Kernel::System::OTRSBusiness',
    'Kernel::Output::HTML::Layout',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    # get OTRS business object
    my $OTRSBusinessObject = $Kernel::OM->Get('Kernel::System::OTRSBusiness');

    return '' if !$OTRSBusinessObject->OTRSBusinessIsInstalled();

    # ----------------------------------------
    # check entitlement status
    # ----------------------------------------
    my $EntitlementStatus = $OTRSBusinessObject->OTRSBusinessEntitlementStatus(
        CallCloudService => 0,
    );

    if ( $EntitlementStatus eq 'forbidden' ) {

        my $OTRSBusinessLabel = '<b>OTRS Business Solution</b>™';

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
