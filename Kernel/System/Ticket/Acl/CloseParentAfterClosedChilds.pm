# --
# Kernel/System/Ticket/Acl/CloseParentAfterClosedChilds.pm - acl module
# - allow no parent close till all clients are closed -
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Acl::CloseParentAfterClosedChilds;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Link',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);
our $ObjectManagerAware = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Config Acl)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if child tickets are not closed
    return 1 if !$Param{TicketID} || !$Param{UserID};

    # link tickets
    my $Links = $Kernel::OM->Get('Kernel::System::Link')->LinkList(
        Object => 'Ticket',
        Key    => $Param{TicketID},
        State  => 'Valid',
        Type   => 'ParentChild',
        UserID => $Param{UserID},
    );

    return 1 if !$Links;
    return 1 if ref $Links ne 'HASH';
    return 1 if !$Links->{Ticket};
    return 1 if ref $Links->{Ticket} ne 'HASH';
    return 1 if !$Links->{Ticket}->{ParentChild};
    return 1 if ref $Links->{Ticket}->{ParentChild} ne 'HASH';
    return 1 if !$Links->{Ticket}->{ParentChild}->{Target};
    return 1 if ref $Links->{Ticket}->{ParentChild}->{Target} ne 'HASH';

    my $OpenSubTickets = 0;
    TICKETID:
    for my $TicketID ( sort keys %{ $Links->{Ticket}->{ParentChild}->{Target} } ) {

        # get ticket
        my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 0,
        );

        if ( $Ticket{StateType} !~ m{ \A (close|merge|remove) }xms ) {
            $OpenSubTickets = 1;
            last TICKETID;
        }
    }

    # generate acl
    if ($OpenSubTickets) {
        $Param{Acl}->{CloseParentAfterClosedChilds} = {

            # match properties
            Properties => {

                # current ticket match properties
                Ticket => {
                    TicketID => [ $Param{TicketID} ],
                },
            },

            # return possible options (black list)
            PossibleNot => {

                # possible ticket options (black list)
                Ticket => {
                    State => $Param{Config}->{State},
                },
            },

            # return possible options (white list)
            Possible => {

                # possible action options
                Action => {
                    AgentTicketLock        => 1,
                    AgentTicketZoom        => 1,
                    AgentTicketClose       => 0,
                    AgentTicketPending     => 1,
                    AgentTicketNote        => 1,
                    AgentTicketHistory     => 1,
                    AgentTicketPriority    => 1,
                    AgentTicketFreeText    => 1,
                    AgentTicketHistory     => 1,
                    AgentTicketCompose     => 1,
                    AgentTicketBounce      => 1,
                    AgentTicketForward     => 1,
                    AgentLinkObject        => 1,
                    AgentTicketPrint       => 1,
                    AgentTicketPhone       => 1,
                    AgentTicketCustomer    => 1,
                    AgentTicketOwner       => 1,
                    AgentTicketResponsible => 1,
                },
            },
        };
    }

    return 1;
}

1;
