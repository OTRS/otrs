# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
