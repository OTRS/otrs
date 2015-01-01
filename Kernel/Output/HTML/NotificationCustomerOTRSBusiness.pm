# --
# Kernel/Output/HTML/NotificationCustomerOTRSBusiness.pm
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NotificationCustomerOTRSBusiness;

use strict;
use warnings;
use utf8;

use Kernel::System::ObjectManager;

our @ObjectDependencies = (
    'Kernel::System::OTRSBusiness',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    $Self->{LayoutObject} = $Param{LayoutObject} || die "Got no LayoutObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    $Self->{OTRSBusinessObject} = $Kernel::OM->Get('Kernel::System::OTRSBusiness');

    return '' if !$Self->{OTRSBusinessObject}->OTRSBusinessIsInstalled();

    # ----------------------------------------
    # check entitlement status
    # ----------------------------------------
    my $EntitlementStatus = $Self->{OTRSBusinessObject}->OTRSBusinessEntitlementStatus(
        CallCloudService => 0,
    );

    if ( $EntitlementStatus eq 'forbidden' ) {

        my $OTRSBusinessLabel = '<b>OTRS Business Solution</b>™';

        my $Text = $Self->{LayoutObject}->{LanguageObject}->Translate(
            'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!',
            $OTRSBusinessLabel,
            'sales@otrs.com',    # no mailto link as these are currently not displayed in the CI
        );
        $Output .= $Self->{LayoutObject}->Notify(
            Data     => $Text,
            Priority => 'Error',
        );
    }

    return $Output;
}

1;
