# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SysConfig::ValueType::Directory;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::SysConfig::BaseValueType);

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::SysConfig::ValueType::Directory - System configuration directory value type backed.

=head1 PUBLIC INTERFACE

=head2 new()

Create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ValueTypeObject = $Kernel::OM->Get('Kernel::System::SysConfig::ValueType::Directory');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 SettingEffectiveValueCheck()

Check if provided EffectiveValue matches structure defined in XMLContentParsed.

    my %Result = $ValueTypeObject->SettingEffectiveValueCheck(
        XMLContentParsed => {
            Value => [
                {
                    'Item' => [
                        {
                            'Content'       => '/etc',
                            'ValueType'     => 'Directory',
                        },
                    ],
                },
            ],
        },
        EffectiveValue => '/etc',
    );

Result:
    %Result = (
        EffectiveValue => '/etc',    # Note for Directory ValueTypes EffectiveValue is not changed.
        Success => 1,
        Error   => undef,
    );

=cut

sub SettingEffectiveValueCheck {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(XMLContentParsed)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );

            return;
        }
    }

    my %Result = (
        Success => 0,
    );

    my $Value = $Param{XMLContentParsed}->{Value};

    for my $Parameter ( sort keys %{ $Param{Parameters} } ) {
        if ( !defined $Value->[0]->{Item}->[0]->{$Parameter} ) {
            $Value->[0]->{Item}->[0]->{$Parameter} = $Param{Parameters}->{$Parameter};
        }
    }

    # Data should be scalar.
    if ( ref $Param{EffectiveValue} ) {
        $Result{Error} = 'EffectiveValue for Directory must be a scalar!';
        return %Result;
    }

    if ( !-e $Param{EffectiveValue} ) {
        $Result{Error} = "$Param{EffectiveValue} not exists!";
        return %Result;
    }

    my $IsDirectory = -d $Param{EffectiveValue};

    if ( !$IsDirectory ) {
        $Result{Error} = "$Param{EffectiveValue} is not directory!";
        return %Result;
    }

    $Result{Success}        = 1;
    $Result{EffectiveValue} = $Param{EffectiveValue};

    return %Result;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
