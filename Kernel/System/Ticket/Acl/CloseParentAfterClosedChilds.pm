# --
# Kernel/System/Ticket/Acl/CloseParentAfterClosedChilds.pm - acl module
# - allow no parent close till all clients are closed -
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: CloseParentAfterClosedChilds.pm,v 1.10 2008-08-01 06:53:12 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Ticket::Acl::CloseParentAfterClosedChilds;

use strict;
use warnings;

use Kernel::System::LinkObject;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(ConfigObject DBObject TicketObject LogObject UserObject CustomerUserObject MainObject TimeObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Config Acl)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if child tickets are not closed
    if ( $Param{TicketID} && $Param{UserID} ) {

        # get ticket
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID => $Param{TicketID},
        );

        # create new instance of the link object
        if ( !$Self->{LinkObject} ) {
            $Self->{LinkObject} = Kernel::System::LinkObject->new(
                %{$Self},
                %Param,
            );
        }

        # link tickets
        my $Links = $Self->{LinkObject}->LinkList(
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
        return 1 if ref $Links->{Ticket}->{ParentChild}->{Target} ne 'ARRAY';

        my $OpenSubTickets = 0;
        for my $TicketID ( sort @{ $Links->{Ticket}->{ParentChild}->{Target} } ) {

            # get ticket
            my %Ticket = $Self->{TicketObject}->TicketGet(
                TicketID => $TicketID,
            );

            if ( $Ticket{StateType} !~ /^(close|merge|remove)/ ) {
                $OpenSubTickets = 1;
                last;
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
    }
    return 1;
}

1;
