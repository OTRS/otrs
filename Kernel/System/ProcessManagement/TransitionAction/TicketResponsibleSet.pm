# --
# Kernel/System/ProcessManagement/TransitionAction/TicketResponsibleSet.pm - A Module to set the ticket responsible
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ProcessManagement::TransitionAction::TicketResponsibleSet;

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

Kernel::System::ProcessManagement::TransitionAction::TicketResponsibleSet - A module to set a new ticket
responsible

=head1 SYNOPSIS

All TicketResponsibleSet functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TicketResponsibleSetObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction::TicketResponsibleSet');

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

    my $TicketResponsibleSetResult = $TicketResponsibleSetActionObject->Run(
        UserID                   => 123,
        Ticket                   => \%Ticket,   # required
        ProcessEntityID          => 'P123',
        ActivityEntityID         => 'A123',
        TransitionEntityID       => 'T123',
        TransitionActionEntityID => 'TA123',
        Config                   => {
            Responsible => 'root@localhost',
            # or
            ResponsibleID => 1,
            UserID        => 123,               # optional, to override the UserID from the logged user
        }
    );
    Ticket contains the result of TicketGet including DynamicFields
    Config is the Config Hash stored in a Process::TransitionAction's  Config key
    Returns:

    $TicketResponsibleSetResult = 1; # 0

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

    if ( !$Param{Config}->{ResponsibleID} && !$Param{Config}->{Responsible} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage . "No Responsible or ResponsibleID configured!",
        );
        return;
    }

    $Success = 0;

    if (
        defined $Param{Config}->{Responsible}
        && $Param{Config}->{Responsible} ne $Param{Ticket}->{Responsible}
        )
    {
        $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketResponsibleSet(
            TicketID => $Param{Ticket}->{TicketID},
            NewUser  => $Param{Config}->{Responsible},
            UserID   => $Param{UserID},
        );
    }
    elsif (
        defined $Param{Config}->{ResponsibleID}
        && $Param{Config}->{ResponsibleID} ne $Param{Ticket}->{ResponsibleID}
        )
    {
        $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketResponsibleSet(
            TicketID  => $Param{Ticket}->{TicketID},
            NewUserID => $Param{Config}->{ResponsibleID},
            UserID    => $Param{UserID},
        );
    }
    else {

        # data is the same as in ticket nothing to do
        $Success = 1;
    }

    if ( !$Success ) {
        my $CustomMessage;
        if ( defined $Param{Config}->{Responsible} ) {
            $CustomMessage = "Responsible: $Param{Config}->{Responsible},";
        }
        else {
            $CustomMessage = "ResponsibleID: $Param{Config}->{ResponsibleID},";
        }
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage
                . 'Ticket responsible could not be updated to '
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
