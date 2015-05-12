# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Notification::AgentOTRSBusiness;

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

    # get config options
    my $Group             = $Param{Config}->{Group} || 'admin';
    my $IsInstalled       = $OTRSBusinessObject->OTRSBusinessIsInstalled();
    my $OTRSBusinessLabel = '<b>OTRS Business Solution</b>™';

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # ----------------------------------------
    # check if OTRS Business Solution™ is available, but not installed
    # ----------------------------------------
    if (
        $Param{Type} eq 'Admin'
        && !$IsInstalled
        && $OTRSBusinessObject->OTRSBusinessIsAvailableOffline()
        )
    {
        my $Text = $LayoutObject->{LanguageObject}->Translate(
            '%s Upgrade to %s now! %s',
            '<a href="'
                . $LayoutObject->{Baselink}
                . 'Action=AdminOTRSBusiness'
                . '" class="Button"><i class="fa fa-angle-double-up"></i>',
            $OTRSBusinessLabel,
            '</a>',
        );

        return $LayoutObject->Notify(
            Data     => $Text,
            Priority => 'Info',
        );
    }

    # all following checks require OTRS Business Solution™ to be installed
    return '' if !$IsInstalled;

    # ----------------------------------------
    # check entitlement status
    # ----------------------------------------
    my $EntitlementStatus = $OTRSBusinessObject->OTRSBusinessEntitlementStatus(
        CallCloudService => 0,
    );

    if ( $EntitlementStatus eq 'forbidden' ) {

        my $Text = $LayoutObject->{LanguageObject}->Translate(
            'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!',
            $OTRSBusinessLabel,
            'sales@otrs.com',
        );
        return $LayoutObject->Notify(
            Data     => $Text,
            Priority => 'Error',
        );
    }
    elsif ( $EntitlementStatus eq 'warning' ) {

        $Output .= $LayoutObject->Notify(
            Info =>
                "Connection to cloud.otrs.com via HTTPS couldn't be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.",
            Priority => 'Error',
        );
    }

    # all following notifications should only be visible for admins
    if (
        !defined $LayoutObject->{"UserIsGroup[$Group]"}
        || $LayoutObject->{"UserIsGroup[$Group]"} ne 'Yes'
        )
    {
        return '';
    }

    # ----------------------------------------
    # check contract expiry
    # ----------------------------------------
    my $ExpiryDate = $OTRSBusinessObject->OTRSBusinessContractExpiryDateCheck();

    if ($ExpiryDate) {

        my $Text = $LayoutObject->{LanguageObject}->Translate(
            'The license for your %s is about to expire. Please make contact with %s to renew your contract!',
            $OTRSBusinessLabel,
            'sales@otrs.com',
        );
        $Output .= $LayoutObject->Notify(
            Data     => $Text,
            Priority => 'Warning',
        );
    }

    # ----------------------------------------
    # check for available updates
    # ----------------------------------------
    my %UpdatesAvailable = $OTRSBusinessObject->OTRSBusinessVersionCheckOffline();

    if ( $UpdatesAvailable{OTRSBusinessUpdateAvailable} ) {

        my $Text = $LayoutObject->{LanguageObject}->Translate(
            'An update for your %s is available! Please update at your earliest!',
            $OTRSBusinessLabel
        );
        $Output .= $LayoutObject->Notify(
            Data     => $Text,
            Priority => 'Warning',
        );
    }

    if ( $UpdatesAvailable{FrameworkUpdateAvailable} ) {

        my $Text = $LayoutObject->{LanguageObject}->Translate(
            'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!',
            $OTRSBusinessLabel
        );
        $Output .= $LayoutObject->Notify(
            Data     => $Text,
            Priority => 'Warning',
        );
    }

    return $Output;
}

1;
