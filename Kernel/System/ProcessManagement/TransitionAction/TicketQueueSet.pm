# --
# Kernel/System/ProcessManagement/TransitionAction/TicketQueueSet.pm - A Module to move a Ticket from to a new queue
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet;

use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

use base qw(Kernel::System::ProcessManagement::TransitionAction::Base);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);
our $ObjectManagerAware = 1;

=head1 NAME

Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet - A Module to move a Ticket from to a new queue

=head1 SYNOPSIS

All TicketQueueSet functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TicketQueueSetObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction::TicketQueueSet');

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

    my $TicketQueueSetResult = $TicketQueueSetActionObject->Run(
        UserID                   => 123,
        Ticket                   => \%Ticket,   # required
        ProcessEntityID          => 'P123',
        ActivityEntityID         => 'A123',
        TransitionEntityID       => 'T123',
        TransitionActionEntityID => 'TA123',
        Config                   => {
            Queue => 'Misc',
            # or
            QueueID => 1,
            UserID  => 123,                     # optional, to override the UserID from the logged user
        }
    );
    Ticket contains the result of TicketGet including DynamicFields
    Config is the Config Hash stored in a Process::TransitionAction's  Config key
    Returns:

    $TicketQueueSetResult = 1; # 0

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

    if ( !$Param{Config}->{QueueID} && !$Param{Config}->{Queue} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage . "No Queue or QueueID configured!",
        );
        return;
    }

    $Success = 0;

    if (
        defined $Param{Config}->{Queue}
        && $Param{Config}->{Queue} ne $Param{Ticket}->{Queue}
        )
    {
        $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketQueueSet(
            Queue    => $Param{Config}->{Queue},
            TicketID => $Param{Ticket}->{TicketID},
            UserID   => $Param{UserID},
        );
    }
    elsif (
        defined $Param{Config}->{QueueID}
        && $Param{Config}->{QueueID} ne $Param{Ticket}->{QueueID}
        )
    {
        $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketQueueSet(
            QueueID  => $Param{Config}->{QueueID},
            TicketID => $Param{Ticket}->{TicketID},
            UserID   => $Param{UserID},
        );
    }
    else {

        # data is the same as in ticket nothing to do
        $Success = 1;
    }

    if ( !$Success ) {
        my $CustomMessage;
        if ( defined $Param{Config}->{Queue} ) {
            $CustomMessage = "Queue: $Param{Config}->{Queue},";
        }
        else {
            $CustomMessage = "QueueID: $Param{Config}->{QueueID},";
        }
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage
                . 'Ticket queue could not be updated to '
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
