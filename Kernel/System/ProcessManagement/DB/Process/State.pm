# --
# Kernel/System/ProcessManagement/Process/State.pm - Process Management DB State backend
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::DB::Process::State;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
);
our $ObjectManagerAware = 1;

=head1 NAME

Kernel::System::ProcessManagement::DB::Process::State.pm

=head1 SYNOPSIS

Process Management DB State backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ProcessStateObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process::State');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # create States list
    $Self->{StateList} = {
        'S1' => 'Active',
        'S2' => 'Inactive',
        'S3' => 'FadeAway',
    };

    return $Self;
}

=item StateList()

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

=item StateLookup()

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
        $Result = $ReversedStateList{ $Param{Name} }
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
