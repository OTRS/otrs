# --
# Kernel/System/ProcessManagement/TransitionAction/TicketOwnerSet.pm - A Module to set the ticket owner
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::TransitionAction::TicketOwnerSet;

use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

use base qw(Kernel::System::ProcessManagement::TransitionAction::Base);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

=head1 NAME

Kernel::System::ProcessManagement::TransitionAction::TicketOwnerSet - A module to set a new ticket owner

=head1 SYNOPSIS

All TicketOwnerSet functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TicketOwnerSetObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction::TicketOwnerSet');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item Run()

    Run Data

    my $TicketOwnerSetResult = $TicketOwnerSetActionObject->Run(
        UserID                   => 123,
        Ticket                   => \%Ticket,   # required
        ProcessEntityID          => 'P123',
        ActivityEntityID         => 'A123',
        TransitionEntityID       => 'T123',
        TransitionActionEntityID => 'TA123',
        Config                   => {
            Owner => 'root@localhost',
            # or
            OwnerID => 1,
            UserID  => 123,                     # optional, to override the UserID from the logged user
        }
    );
    Ticket contains the result of TicketGet including DynamicFields
    Config is the Config Hash stored in a Process::TransitionAction's  Config key
    Returns:

    $TicketOwnerSetResult = 1; # 0

    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # define a common message to output in case of any error
    my $CommonMessage = "Process: $Param{ProcessEntityID} Activity: $Param{ActivityEntityID}"
        . " Transition: $Param{TransitionEntityID}"
        . " TransitionAction: $Param{TransitionActionEntityID} - ";

    # check for missing or wrong params
    my $Success = $Self->_CheckParams(
        %Param,
        CommonMessage => $CommonMessage,
    );
    return if !$Success;

    # override UserID if specified as a parameter in the TA config
    $Param{UserID} = $Self->_OverrideUserID(%Param);

    # use ticket attributes if needed
    $Self->_ReplaceTicketAttributes(%Param);

    if ( !$Param{Config}->{OwnerID} && !$Param{Config}->{Owner} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage . "No Owner or OwnerID configured!",
        );
        return;
    }

    $Success = 0;

    if (
        defined $Param{Config}->{Owner}
        && $Param{Config}->{Owner} ne $Param{Ticket}->{Owner}
        )
    {
        $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketOwnerSet(
            TicketID => $Param{Ticket}->{TicketID},
            NewUser  => $Param{Config}->{Owner},
            UserID   => $Param{UserID},
        );
    }
    elsif (
        defined $Param{Config}->{OwnerID}
        && $Param{Config}->{OwnerID} ne $Param{Ticket}->{OwnerID}
        )
    {
        $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketOwnerSet(
            TicketID  => $Param{Ticket}->{TicketID},
            NewUserID => $Param{Config}->{OwnerID},
            UserID    => $Param{UserID},
        );
    }
    else {

        # data is the same as in ticket nothing to do
        $Success = 1;
    }

    if ( !$Success ) {
        my $CustomMessage;
        if ( defined $Param{Config}->{Owner} ) {
            $CustomMessage = "Owner: $Param{Config}->{Owner},";
        }
        else {
            $CustomMessage = "OwnerID: $Param{Config}->{OwnerID},";
        }
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage
                . 'Ticket owner could not be updated to '
                . $CustomMessage
                . ' for Ticket: '
                . $Param{Ticket}->{TicketID} . '!',
        );
        return;
    }
    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
