# --
# Kernel/System/Ticket/Event/TicketProcessTransitions.pm - a event module to chage from one activity to another based on the transition
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

=cut

This event handler will fire on ticket events and check if a transition of
a process ticket needs to be made.

It is registered in transaction mode, so it will operate after all other regular ticket
changes have been made. A small cache in $Self->{TicketObject} makes sure that for each
ticket, the check is only done once.

=cut

package Kernel::System::Ticket::Event::TicketProcessTransitions;
use strict;
use warnings;

use Kernel::System::ProcessManagement::Activity;
use Kernel::System::ProcessManagement::ActivityDialog;
use Kernel::System::ProcessManagement::Process;
use Kernel::System::ProcessManagement::Transition;
use Kernel::System::ProcessManagement::TransitionAction;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (
        qw(ConfigObject EncodeObject TimeObject DBObject MainObject TicketObject LogObject)
        )
    {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Data Event Config UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # listen to all kinds of events
    if ( !$Param{Data}->{TicketID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need TicketID in Data!",
        );
        return;
    }

    my $CacheKey = '_TicketProcessTransitions::AlreadyProcessed';

    # Only execute this handler once for each ticket, as multiple events may be fired,
    #   for example TicketTitleUpdate and TicketPriorityUpdate.
    return if ( $Self->{TicketObject}->{$CacheKey}->{ $Param{Data}->{TicketID} } );

    # Get ticket data in silent mode, it could be that the ticket was deleted
    #   in the meantime.
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        DynamicFields => 1,
        Silent        => 1,
    );

    if ( !%Ticket ) {

        # Remember that the event was executed for this TicketID to avoid multiple executions.
        #   Store the information on the ticketobject
        $Self->{TicketObject}->{$CacheKey}->{ $Param{Data}->{TicketID} } = 1;

        return;
    }

    my $ProcessIDField
        = $Self->{ConfigObject}->Get("Process::DynamicFieldProcessManagementProcessID");
    my $ProcessEntityID = $Ticket{"DynamicField_$ProcessIDField"};

    my $ActivityIDField
        = $Self->{ConfigObject}->Get("Process::DynamicFieldProcessManagementActivityID");
    my $ActivityEntityID = $Ticket{"DynamicField_$ActivityIDField"};

    # Ticket can be ignored if it is no process ticket. Don't set the cache key in this case as
    #   later events might make a transition check neccessary.
    return if ( !$ProcessEntityID || !$ActivityEntityID );

    # Ok, now we know that we need to call the transition logic for this ticket.

    # Create the needed objects only now to save performance.
    my $ActivityObject = Kernel::System::ProcessManagement::Activity->new( %{$Self} );
    my $ActivityDialogObject
        = Kernel::System::ProcessManagement::ActivityDialog->new( %{$Self} );
    my $TransitionObject = Kernel::System::ProcessManagement::Transition->new( %{$Self} );
    my $TransitionActionObject
        = Kernel::System::ProcessManagement::TransitionAction->new( %{$Self} );
    my $ProcessObject = Kernel::System::ProcessManagement::Process->new(
        %{$Self},
        ActivityObject         => $ActivityObject,
        ActivityDialogObject   => $ActivityDialogObject,
        TransitionObject       => $TransitionObject,
        TransitionActionObject => $TransitionActionObject,
    );

    my $TransitionApplied = $ProcessObject->ProcessTransition(
        ProcessEntityID  => $ProcessEntityID,
        ActivityEntityID => $ActivityEntityID,
        TicketID         => $Param{Data}->{TicketID},
        UserID           => $Param{UserID},
    );

    if ( $Self->{Debug} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Transition for to TicketID: $Param{Data}->{TicketID}"
                . "  ProcessEntityID: $ProcessEntityID OldActivityEntityID: $ActivityEntityID "
                . ( $TransitionApplied ? "was applied." : "was not applied." ),
        );
    }

    # Remember that the event was executed for this ticket to avoid multiple executions.
    #   Store the information on the ticketobject
    $Self->{TicketObject}->{$CacheKey}->{ $Param{Data}->{TicketID} } = 1;

    return 1;
}

1;
