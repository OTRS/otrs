# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::ProcessManagement::TransitionValidation::ValidateDemo;

use strict;
use warnings;
use Kernel::System::VariableCheck qw(:all);

=head1 NAME

Kernel::System::ProcessManagement::TransitionValidation::ValidateDemo - Demo for Transition Validation Module

=head1 SYNOPSIS

All ValidateDemo functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::ProcessManagement::TransitionValidation::ValidateDemo;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $ValidateModuleObject = Kernel::System::ProcessManagement::TransitionValidation::ValidateDemo->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject LogObject)) {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

    return $Self;
}

=item Validate()

    Validate Data

    my $ValidateResult = $ValidateModuleObject->Validate(
        Data       => {
            Queue => 'Raw',
            # ...
        },
    );

    Returns:

    $ValidateResult = 1;        # or undef, only returns 1 if Queue is 'Raw'

    );

=cut

sub Validate {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Data)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # Check if we have Data to check against transitions conditions
    if ( !IsHashRefWithData( $Param{Data} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Data has no values!",
        );
        return;
    }

    if ( $Param{Data}{Queue} && $Param{Data}{Queue} eq 'Raw' ) {
        return 1;
    }
    return;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
