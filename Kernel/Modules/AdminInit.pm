# --
# Kernel/Modules/AdminInit.pm - init a new setup
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminInit;

use strict;
use warnings;

use Kernel::System::SysConfig;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{SysConfigObject} = Kernel::System::SysConfig->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # return to admin screen
    if ( $Self->{Subaction} eq 'Done' ) {
        return $Self->{LayoutObject}->Redirect( OP => 'Action=Admin' );
    }

    # write default file
    if ( !$Self->{SysConfigObject}->WriteDefault() ) {
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # create config object
    $Self->{ConfigObject} = Kernel::Config->new( %{$Self} );

    # install included packages
    if ( $Self->{MainObject}->Require('Kernel::System::Package') ) {
        my $PackageObject = Kernel::System::Package->new( %{$Self} );
        if ($PackageObject) {
            $PackageObject->PackageInstallDefaultFiles();
        }
    }

    return $Self->{LayoutObject}->Redirect( OP => 'Subaction=Done' );
}

1;
