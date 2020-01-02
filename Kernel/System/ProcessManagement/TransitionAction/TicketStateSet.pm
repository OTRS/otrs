# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::ProcessManagement::TransitionAction::TicketStateSet;

use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::ProcessManagement::TransitionAction::Base);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::State',
    'Kernel::System::Ticket',
    'Kernel::System::DateTime',
);

=head1 NAME

Kernel::System::ProcessManagement::TransitionAction::TicketStateSet - A module to set the ticket state

=head1 DESCRIPTION

All TicketStateSet functions.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $TicketStateSetObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction::TicketStateSet');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 Run()

    Run Data

    my $TicketStateSetResult = $TicketStateSetActionObject->Run(
        UserID                   => 123,
        Ticket                   => \%Ticket,   # required
        ProcessEntityID          => 'P123',
        ActivityEntityID         => 'A123',
        TransitionEntityID       => 'T123',
        TransitionActionEntityID => 'TA123',
        Config                   => {
            State   => 'open',
            # or
            StateID => 3,

            PendingTimeDiff => 123,             # optional, used for pending states, difference in seconds from
                                                #   current time to desired pending time (e.g. a value of 3600 means
                                                #   that the pending time will be 1 hr after the Transition Action is
                                                #   executed)
            UserID  => 123,                     # optional, to override the UserID from the logged user
        }
    );
    Ticket contains the result of TicketGet including DynamicFields
    Config is the Config Hash stored in a Process::TransitionAction's  Config key
    Returns:

    $TicketStateSetResult = 1; # 0

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
    $Self->_ReplaceAdditionalAttributes(%Param);

    if ( !$Param{Config}->{StateID} && !$Param{Config}->{State} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage . "No State or StateID configured!",
        );
        return;
    }

    $Success = 0;
    my %StateData;

    if ( defined $Param{Config}->{StateID} ) {

        %StateData = $Kernel::OM->Get('Kernel::System::State')->StateGet(
            ID => $Param{Config}->{StateID},
        );

        if ( $Param{Config}->{StateID} ne $Param{Ticket}->{StateID} ) {

            $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketStateSet(
                TicketID => $Param{Ticket}->{TicketID},
                StateID  => $Param{Config}->{StateID},
                UserID   => $Param{UserID},
            );

            if ( !$Success ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => $CommonMessage
                        . 'Ticket StateID '
                        . $Param{Config}->{StateID}
                        . ' could not be updated for Ticket: '
                        . $Param{Ticket}->{TicketID} . '!',
                );
            }
        }
        else {

            # Data is the same as in ticket nothing to do.
            $Success = 1;
        }

    }
    elsif ( $Param{Config}->{State} ) {

        %StateData = $Kernel::OM->Get('Kernel::System::State')->StateGet(
            Name => $Param{Config}->{State},
        );
        if ( $Param{Config}->{State} ne $Param{Ticket}->{State} ) {

            $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketStateSet(
                TicketID => $Param{Ticket}->{TicketID},
                State    => $Param{Config}->{State},
                UserID   => $Param{UserID},
            );

            if ( !$Success ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => $CommonMessage
                        . 'Ticket State '
                        . $Param{Config}->{State}
                        . ' could not be updated for Ticket: '
                        . $Param{Ticket}->{TicketID} . '!',
                );
            }
        }
        else {

            # Data is the same as in ticket nothing to do.
            $Success = 1;
        }

    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage
                . "Couldn't update Ticket State - can't find valid State parameter!",
        );
        return;
    }

    # set pending time
    if (
        IsHashRefWithData( \%StateData )
        && $StateData{TypeName} =~ m{\A pending}msxi
        && IsNumber( $Param{Config}->{PendingTimeDiff} )
        )
    {

        # get datetime object
        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        $DateTimeObject->Add( Seconds => $Param{Config}->{PendingTimeDiff} );

        # set pending time
        $Kernel::OM->Get('Kernel::System::Ticket')->TicketPendingTimeSet(
            UserID   => $Param{UserID},
            TicketID => $Param{Ticket}->{TicketID},
            String   => $DateTimeObject->ToString(),
        );
    }

    return $Success;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
