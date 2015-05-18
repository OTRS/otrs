# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Storable;

use strict;
use warnings;

use Storable qw();

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Storable - Storable wrapper functions

=head1 SYNOPSIS

Functions for Storable serialization / deserialization.

=over 4

=cut

=item new()

create a Storable object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item Serialize()

Dump a Perl data structure to an storable string.

    my $StoableString = $StorableObject->Serialize(
        Data => $Data,          # must be a reference,
        Sort => 1,              # optional 1 or 0, default 0
    );

=cut

sub Serialize {
    my ( $Self, %Param ) = @_;

    # check for needed data
    if ( !defined $Param{Data} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Data!',
        );
        return;
    }

    if ( !ref $Param{Data} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Data needs to be given as a reference!',
        );
        return;
    }

    local $Storable::canonical = $Param{Sort} ? 1 : 0;

    my $Result;
    eval {
        $Result = Storable::nfreeze( $Param{Data} );
    };

    # error handling
    if ($@) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Error serializing data: $@",
        );
        return;
    }

    return $Result;
}

=item Deserialize()

Load a serialized storable string to a Perl data structure.

    my $PerlStructureScalar = $StorabeObject->Deserialize(
        Data => $StorableString,
    );

=cut

sub Deserialize {
    my ( $Self, %Param ) = @_;

    # check for needed data
    return if !defined $Param{Data};

    # read data structure back from file dump, use block eval for safety reasons
    my $Result;
    eval {
        $Result = Storable::thaw( $Param{Data} );
    };

    # error handling
    if ($@) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Error deserializing data: $@",
        );
        return;
    }

    return $Result;
}

=item Clone()

Creates a deep copy a Perl data structure.

    my $StoableData = $StorableObject->Clone(
        Data => $Data,          # must be a reference
    );

=cut

sub Clone {
    my ( $Self, %Param ) = @_;

    # check for needed data
    if ( !defined $Param{Data} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Data!',
        );
        return;
    }

    if ( !ref $Param{Data} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Data needs to be a reference!',
        );
        return;
    }

    my $Result;
    eval {
        $Result = Storable::dclone( $Param{Data} );
    };

    # error handling
    if ($@) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Error cloning data: $@",
        );
        return;
    }

    return $Result;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
