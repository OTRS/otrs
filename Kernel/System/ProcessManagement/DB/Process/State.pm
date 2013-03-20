# --
# Kernel/System/ProcessManagement/Process/State.pm - Process Management DB State backend
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::DB::Process::State;

use strict;
use warnings;

=head1 NAME

Kernel::System::ProcessManagement::DB::Process::State.pm

=head1 SYNOPSIS

Process Management DB State backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a State object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::ProcessManagement::DB::Process::State;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $StateObject = Kernel::System::ProcessManagement::DB::Process::State->new(
        ConfigObject        => $ConfigObject,
        EncodeObject        => $EncodeObject,
        LogObject           => $LogObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject EncodeObject LogObject)) {
        die "Got no $Needed!" if !$Param{$Needed};

        $Self->{$Needed} = $Param{$Needed};
    }

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
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!"
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
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!"
        );
        return;
    }

    if ( !$Param{EntityID} && !$Param{Name} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "EntityID or Name is required!"
        );
        return;
    }

    my $Result;

    # return state name
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
