# --
# Kernel/Modules/AgentTicketLock.pm - to set or unset a lock for tickets
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketLock;

use strict;
use warnings;
use Kernel::System::VariableCheck qw(:all);

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
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'Can\'t lock Ticket, no TicketID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{TicketObject}->TicketPermission(
        Type     => 'lock',
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # get ACL restrictions
    $Self->{TicketObject}->TicketAcl(
        Data          => '-',
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = $Self->{TicketObject}->TicketAclActionData();

    # check if ACL restrictions exist
    if ( IsHashRefWithData( \%AclAction ) ) {

        # show error screen if ACL prohibits this action
        if ( defined $AclAction{ $Self->{Action} } && $AclAction{ $Self->{Action} } eq '0' ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }
    }

    # start with actions
    if ( $Self->{Subaction} eq 'Unlock' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # check if I'm the owner
        my ( $OwnerID, $OwnerLogin ) = $Self->{TicketObject}->OwnerCheck(
            TicketID => $Self->{TicketID},
        );
        if ( $OwnerID != $Self->{UserID} ) {
            my $Output = $Self->{LayoutObject}->Header(
                Title => 'Error',
                Type  => 'Small',
            );
            $Output .= $Self->{LayoutObject}->Warning(
                Message => "Sorry, the current owner is $OwnerLogin!",
                Comment => 'Please become the owner first.',
            );
            $Output .= $Self->{LayoutObject}->Footer(
                Type => 'Small',
            );
            return $Output;
        }

        # set unlock
        my $Lock = $Self->{TicketObject}->TicketLockSet(
            TicketID => $Self->{TicketID},
            Lock     => 'unlock',
            UserID   => $Self->{UserID},
        );

        if ( !$Lock ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    else {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # check if the agent is able to lock the ticket
        if ( $Self->{TicketObject}->TicketLockGet( TicketID => $Self->{TicketID} ) ) {
            my ( $OwnerID, $OwnerLogin ) = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Self->{TicketID},
            );
            my $Output = $Self->{LayoutObject}->Header(
                Title => 'Error',
                Type  => 'Small',
            );
            $Output .= $Self->{LayoutObject}->Warning(
                Message => "Ticket (ID=$Self->{TicketID}) is locked by $OwnerLogin!",
                Comment => "Change the owner!",
            );
            $Output .= $Self->{LayoutObject}->Footer(
                Type => 'Small',
            );
            return $Output;
        }

        # set lock
        if (
            !$Self->{TicketObject}->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID},
            )
            ||

            # set user id
            !$Self->{TicketObject}->TicketOwnerSet(
                TicketID  => $Self->{TicketID},
                UserID    => $Self->{UserID},
                NewUserID => $Self->{UserID},
            )
            )
        {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # redirect
    if ( $Self->{QueueID} ) {
        return $Self->{LayoutObject}->Redirect( OP => ";QueueID=$Self->{QueueID}" );
    }
    return $Self->{LayoutObject}->Redirect(
        OP => "Action=AgentTicketZoom;TicketID=$Self->{TicketID}",
    );
}

1;
