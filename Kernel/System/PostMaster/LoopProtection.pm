# --
# Kernel/System/PostMaster/LoopProtection.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::LoopProtection;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub SendEmail {
    my ( $Self, %Param ) = @_;

    # get configured backend module
    my $BackendModule = $Kernel::OM->Get('Kernel::Config')->Get('LoopProtectionModule')
        || 'Kernel::System::PostMaster::LoopProtection::DB';

    # get backend object
    my $BackendObject = $Kernel::OM->Get($BackendModule);

    if ( !$BackendObject ) {

        # get main object
        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

        $MainObject->Die("Can't load loop protection backend module $BackendModule!");
    }

    return $BackendObject->SendEmail(%Param);
}

sub Check {
    my ( $Self, %Param ) = @_;

    # get configured backend module
    my $BackendModule = $Kernel::OM->Get('Kernel::Config')->Get('LoopProtectionModule')
        || 'Kernel::System::PostMaster::LoopProtection::DB';

    # get backend object
    my $BackendObject = $Kernel::OM->Get($BackendModule);

    if ( !$BackendObject ) {

        # get main object
        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

        $MainObject->Die("Can't load loop protection backend module $BackendModule!");
    }

    return $BackendObject->Check(%Param);
}

1;
