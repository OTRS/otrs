# --
# Kernel/Modules/AdminInit.pm - init a new setup
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

    # return to admin screen
    if ( $Self->{Subaction} eq 'Done' ) {
        return $LayoutObject->Redirect( OP => 'Action=Admin' );
    }

    # write default file
    if ( !$Kernel::OM->Get('Kernel::System::SysConfig')->WriteDefault() ) {
        return $LayoutObject->ErrorScreen();
    }

    # install included packages
    if ( $Kernel::OM->Get('Kernel::System::Main')->Require('Kernel::System::Package') ) {
        my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
        if ($PackageObject) {
            $PackageObject->PackageInstallDefaultFiles();
        }
    }

    return $LayoutObject->Redirect( OP => 'Subaction=Done' );
}

1;
