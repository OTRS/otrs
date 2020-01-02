# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::ProcessManagement::DB::Process::State;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::ProcessManagement::DB::Process::State

=head1 DESCRIPTION

Process Management DB State backend

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $ProcessStateObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process::State');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # create States list
    $Self->{StateList} = {
        'S1' => Translatable('Active'),
        'S2' => Translatable('Inactive'),
        'S3' => Translatable('FadeAway'),
    };

    return $Self;
}

=head2 StateList()

get a State list

    my $List = $StateObject->StateList(
        UserID => 123,
    );

    Returns:

    $List = {
        'S1' => 'Active',
        'S2' => 'Inactive',
        'S3' => 'FadeAway',
    }

=cut

sub StateList {
    my ( $Self, %Param ) = @_;

    # check needed
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    return $Self->{StateList};
}

=head2 StateLookup()

get State name or State EntityID

    my $Name = $StateObject->StateLookup(
        EntityID => 'S1',
        UserID   => 123,
    );

    Returns:
    $Name = 'Active';

    my $EntityID = $StateObject->StateLookup(
        Name     => 'Active',
        UserID   => 123,
    );

    Returns:
    $EntityID = 'S1';

=cut

sub StateLookup {
    my ( $Self, %Param ) = @_;

    # check needed
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    if ( !$Param{EntityID} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "EntityID or Name is required!",
        );
        return;
    }

    # return state name
    my $Result;
    if ( $Param{EntityID} ) {
        $Result = $Self->{StateList}->{ $Param{EntityID} };
    }

    # return state entity ID
    else {
        my %ReversedStateList = reverse %{ $Self->{StateList} };
        $Result = $ReversedStateList{ $Param{Name} };
    }

    return $Result;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
