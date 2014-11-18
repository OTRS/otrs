# --
# Kernel/Modules/AdminOTRSBusiness.pm - OTRSBusiness deployment
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminOTRSBusiness;

use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $OTRSBusinessObject = $Kernel::OM->Get('Kernel::System::OTRSBusiness');
    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $ParamObject           = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $NotificationCode      = $ParamObject->GetParam( Param => 'NotificationCode' );
    my %NotificationCode2Text = (
        InstallOk => {
            Priority => 'Success',
            Info     => 'Your system was successfully upgraded to OTRS Business Solution™.',
        },
        InstallError => {
            Priority => 'Error',
            Info     => 'There was a problem during the upgrade to OTRS Business Solution™.',
        },
        ReinstallOk => {
            Priority => 'Success',
            Info     => 'OTRS Business Solution™ was correctly reinstalled.',
        },
        ReinstallError => {
            Priority => 'Error',
            Info     => 'There was a problem reinstalling OTRS Business Solution™.',
        },
        UpdateOk => {
            Priority => 'Success',
            Info     => 'Your OTRS Business Solution™ was successfully updated.',
        },
        UpdateError => {
            Priority => 'Error',
            Info     => 'There was a problem during the upgrade of OTRS Business Solution™.',
        },
        UninstallOk => {
            Priority => 'Success',
            Info     => 'OTRS Business Solution™ was correctly uninstalled.',
        },
        UninstallError => {
            Priority => 'Error',
            Info     => 'There was a problem uninstalling OTRS Business Solution™.',
        },
    );
    my $Notification;
    if ($NotificationCode) {
        $Notification = $NotificationCode2Text{$NotificationCode};
    }

    if ( $Self->{Subaction} eq 'Uninstall' ) {
        return $Self->UninstallScreen(
            Notification => $Notification,
        );
    }
    elsif ( $Self->{Subaction} eq 'UninstallAction' ) {
        my $Result = $OTRSBusinessObject->OTRSBusinessUninstall();
        my $Notification;
        if ($Result) {
            return $LayoutObject->Redirect(
                OP => "Action=AdminOTRSBusiness;NotificationCode=UninstallOk"
            );
        }
        return $LayoutObject->Redirect(
            OP => "Action=AdminOTRSBusiness;NotificationCode=UninstallError"
        );
    }
    elsif ( $Self->{Subaction} eq 'ReinstallAction' ) {
        my $Result = $OTRSBusinessObject->OTRSBusinessReinstall();
        my $Notification;
        if ($Result) {
            return $LayoutObject->Redirect(
                OP => "Action=AdminOTRSBusiness;NotificationCode=ReinstallOk"
            );
        }
        return $LayoutObject->Redirect(
            OP => "Action=AdminOTRSBusiness;NotificationCode=ReinstallError"
        );
    }
    elsif ( $Self->{Subaction} eq 'InstallAction' ) {
        if ( $OTRSBusinessObject->OTRSBusinessInstall() ) {
            return $LayoutObject->Redirect(
                OP => "Action=AdminOTRSBusiness;NotificationCode=InstallOk"
            );
        }

        return $LayoutObject->Redirect(
            OP => "Action=AdminOTRSBusiness;NotificationCode=InstallError"
        );
    }
    elsif ( $Self->{Subaction} eq 'UpdateAction' ) {
        if ( $OTRSBusinessObject->OTRSBusinessUpdate() ) {
            return $LayoutObject->Redirect(
                OP => "Action=AdminOTRSBusiness;NotificationCode=UpdateOk"
            );
        }

        return $LayoutObject->Redirect(
            OP => "Action=AdminOTRSBusiness;NotificationCode=UpdateError"
        );
    }

    # OTRSBusiness not yet installed?
    if ( !$OTRSBusinessObject->OTRSBusinessIsInstalled() ) {
        return $Self->NotInstalledScreen(
            Notification => $Notification,
        );
    }

    # OK, installed.
    return $Self->InstalledScreen(
        Notification => $Notification,
    );

}

sub NotInstalledScreen {
    my ( $Self, %Param ) = @_;

    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $OTRSBusinessObject = $Kernel::OM->Get('Kernel::System::OTRSBusiness');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    if ( $Param{Notification} ) {
        $Output .= $LayoutObject->Notify( %{ $Param{Notification} } );
    }

    my $RegistrationObject = $Kernel::OM->Get('Kernel::System::Registration');
    my %RegistrationData   = $RegistrationObject->RegistrationDataGet();

    if ( !$OTRSBusinessObject->OTRSBusinessIsAvailable() ) {
        $LayoutObject->Block(
            Name => 'NotAvailable',
        );
    }
    elsif ( !%RegistrationData || $RegistrationData{State} ne 'registered' ) {
        $LayoutObject->Block(
            Name => 'NotRegistered',
        );
    }
    elsif ( $OTRSBusinessObject->OTRSBusinessEntitlementStatus( CallCloudService => 1 ) eq 'forbidden' ) {
        $LayoutObject->Block(
            Name => 'NotEntitled',
        );
    }
    elsif ( $OTRSBusinessObject->OTRSBusinessEntitlementStatus( CallCloudService => 1 ) ne 'entitled' ) {
        $LayoutObject->Block(
            Name => 'EntitlementStatusUnclear',
        );
    }
    else {
        $LayoutObject->Block(
            Name => 'Install',
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminOTRSBusinessNotInstalled',
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub InstalledScreen {
    my ( $Self, %Param ) = @_;

    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $OTRSBusinessObject = $Kernel::OM->Get('Kernel::System::OTRSBusiness');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    if ( $Param{Notification} ) {
        $Output .= $LayoutObject->Notify( %{ $Param{Notification} } );
    }

    my $RegistrationObject = $Kernel::OM->Get('Kernel::System::Registration');
    my %RegistrationData   = $RegistrationObject->RegistrationDataGet();

    if (
        !%RegistrationData
        || $RegistrationData{State} ne 'registered'
        || $OTRSBusinessObject->OTRSBusinessEntitlementStatus( CallCloudService => 1 ) eq 'forbidden'
        )
    {
        $LayoutObject->Block(
            Name => 'NotEntitled',
        );
    }
    else {
        if ( !$OTRSBusinessObject->OTRSBusinessIsCorrectlyDeployed() ) {
            if ( $OTRSBusinessObject->OTRSBusinessIsUpdateable() ) {
                $LayoutObject->Block(
                    Name => 'NeedsReinstallAndUpdate',
                );
            }
            elsif ( $OTRSBusinessObject->OTRSBusinessIsReinstallable() ) {
                $LayoutObject->Block(
                    Name => 'NeedsReinstall',
                );
            }
            else {
                $LayoutObject->Block(
                    Name => 'ReinstallImpossible',
                );
            }
        }
        elsif ( $OTRSBusinessObject->OTRSBusinessIsUpdateable() ) {
            $LayoutObject->Block(
                Name => 'NeedsUpdate',
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'EverythingOk',
            );
        }
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminOTRSBusinessInstalled',
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub UninstallScreen {
    my ( $Self, %Param ) = @_;

    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $OTRSBusinessObject = $Kernel::OM->Get('Kernel::System::OTRSBusiness');

    if ( !$OTRSBusinessObject->OTRSBusinessIsInstalled() ) {
        return $LayoutObject->Redirect(
            OP => "Action=AdminOTRSBusiness"
        );
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    if ( $Param{Notification} ) {
        $Output .= $LayoutObject->Notify( %{ $Param{Notification} } );
    }

    # check for dependencies. If there are any, downgrade is not allowed.
    my $Dependencies = $OTRSBusinessObject->OTRSBusinessGetDependencies();
    if ( IsArrayRefWithData($Dependencies) ) {
        $LayoutObject->Block(
            Name => 'DowngradeNotPossible',
            Data => {
                Packages => $Dependencies,
                }
        );
    }
    else {
        $LayoutObject->Block(
            Name => 'DowngradePossible',
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminOTRSBusinessUninstall',
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

1;
