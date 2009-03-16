# --
# Kernel/Modules/AgentTicketLock.pm - to set or unset a lock for tickets
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketLock.pm,v 1.10 2009-03-16 08:24:17 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketLock;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Self->{TicketID} ) {

        # error page
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'Can\'t lock Ticket, no TicketID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{TicketObject}->Permission(
        Type     => 'lock',
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # start with actions
    if ( $Self->{Subaction} eq 'Unlock' ) {

        # check if I'm the owner
        my ( $OwnerID, $OwnerLogin ) = $Self->{TicketObject}->OwnerCheck(
            TicketID => $Self->{TicketID},
        );
        if ( $OwnerID != $Self->{UserID} ) {
            my $Output = $Self->{LayoutObject}->Header( Title => 'Error' );
            $Output .= $Self->{LayoutObject}->Warning(
                Message => "Sorry, the current owner is $OwnerLogin!",
                Comment => 'Please change the owner first.',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # set unlock
        my $Lock = $Self->{TicketObject}->LockSet(
            TicketID => $Self->{TicketID},
            Lock     => 'unlock',
            UserID   => $Self->{UserID},
        );

        if ( !$Lock ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # redirekt
        if ( $Self->{QueueID} ) {
            return $Self->{LayoutObject}->Redirect( OP => "QueueID=$Self->{QueueID}" );
        }
        else {
            return $Self->{LayoutObject}->Redirect( OP => $Self->{LastScreenView} );
        }
    }
    else {

        # check if the agent is ablee to lock
        if ( $Self->{TicketObject}->LockIsTicketLocked( TicketID => $Self->{TicketID} ) ) {
            my ( $OwnerID, $OwnerLogin ) = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Self->{TicketID},
            );
            my $Output = $Self->{LayoutObject}->Header( Title => 'Error' );
            $Output .= $Self->{LayoutObject}->Warning(
                Message => "Ticket (ID=$Self->{TicketID}) is locked for $OwnerLogin!",
                Comment => "Change the owner!",
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # set lock
        if (
            !$Self->{TicketObject}->LockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID},
            )
            ||

            # set user id
            !$Self->{TicketObject}->OwnerSet(
                TicketID  => $Self->{TicketID},
                UserID    => $Self->{UserID},
                NewUserID => $Self->{UserID},
            )
            )
        {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # redirekt
        if ( $Self->{QueueID} ) {
            return $Self->{LayoutObject}->Redirect( OP => "&QueueID=$Self->{QueueID}" );
        }
        else {
            return $Self->{LayoutObject}->Redirect( OP => $Self->{LastScreenView} );
        }
    }
}

1;
