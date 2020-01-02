# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminInit;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Return to admin screen.
    if ( $Self->{Subaction} eq 'Done' ) {
        return $LayoutObject->Redirect( OP => 'Action=Admin' );
    }

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # Load all XML settings into the DB.
    if (
        !$SysConfigObject->ConfigurationXML2DB(
            UserID  => 1,
            Force   => 1,
            CleanUp => 1,
        )
        )
    {
        return $LayoutObject->ErrorScreen();
    }

    # Create initial deployment (write ZZZAAuto file).
    my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
        Comments    => "Deployed by AdminInit",
        AllSettings => 1,
        UserID      => 1,
        Force       => 1,
    );

    if ( !$DeploymentResult{Success} ) {
        return $LayoutObject->ErrorScreen();
    }

    # Install included packages.
    if ( $Kernel::OM->Get('Kernel::System::Main')->Require('Kernel::System::Package') ) {
        my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
        if ($PackageObject) {
            $PackageObject->PackageInstallDefaultFiles();
        }
    }

    return $LayoutObject->Redirect( OP => 'Action=AdminInit;Subaction=Done' );
}

1;
