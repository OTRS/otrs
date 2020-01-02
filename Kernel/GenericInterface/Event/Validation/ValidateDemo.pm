# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Event::Validation::ValidateDemo;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::GenericInterface::Event::Validation::ValidateDemo - Demo for condition validation module

=head1 DESCRIPTION

All ValidateDemo functions.

=head1 PUBLIC INTERFACE

=cut

=head2 new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ValidateDemoObject = $Kernel::OM->Get('Kernel::GenericInterface::Event::Validation::ValidateDemo');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 Validate()

    Validate Data

    my $ValidateResult = $ValidateModuleObject->Validate(
        Data       => {
            Queue => 'Postmaster',
            # ...
        },
    );

    Returns:

    $ValidateResult = 1;        # or undef, only returns 1 if Queue is 'Postmaster'

    );

=cut

sub Validate {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Data)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # Check if we have Data to check against conditions
    if ( !IsHashRefWithData( $Param{Data} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Data has no values!",
        );
        return;
    }

    # Check object data (e.g. ticket queue)
    if ( $Param{Data}->{Queue} && $Param{Data}->{Queue} eq 'Postmaster' ) {
        return 1;
    }

    return;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
