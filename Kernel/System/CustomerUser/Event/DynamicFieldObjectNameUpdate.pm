# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::CustomerUser::Event::DynamicFieldObjectNameUpdate;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::DynamicField',
);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw( Data Event Config UserID )) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }
    for my $Needed (qw( UserLogin NewData OldData )) {
        if ( !$Param{Data}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in Data!"
            );
            return;
        }
    }

    # If the user login has been changed, update dynamic field object name for given name and type.
    if ( lc $Param{Data}->{OldData}->{UserLogin} ne lc $Param{Data}->{NewData}->{UserLogin} ) {

        my $Success = $Kernel::OM->Get('Kernel::System::DynamicField')->ObjectMappingNameChange(
            OldObjectName => $Param{Data}->{OldData}->{UserLogin},
            NewObjectName => $Param{Data}->{NewData}->{UserLogin},
            ObjectType    => 'CustomerUser',
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Unable to change dynamic field object mapping name from $Param{Data}->{OldData}->{UserLogin} to $Param{Data}->{NewData}->{UserLogin} for type CustomerUser!",
            );
            return;
        }
    }

    return 1;
}

1;
