# --
# Kernel/Modules/AgentMove.pm - move tickets to queues 
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentMove.pm,v 1.11 2003-03-14 08:25:31 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentMove;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.11 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # make all Params to local 
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject)) { 
        die "Got no $_" if (!$Self->{$_});
    }
    $Self->{StateObject} = Kernel::System::State->new(%Param);

    # get DestQueueID 
    $Self->{DestQueueID} = $Self->{ParamObject}->GetParam(Param => 'DestQueueID');

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;

    # --
    # check needed stuff
    # --
    foreach (qw(TicketID)) {
      if (!$Self->{$_}) {
        # --
        # error page
        # --
        $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
          Message => "Need $_!",
          Comment => 'Please contact the admin.',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
      }
    }
    # --
    # check permissions
    # --
    if (!$Self->{TicketObject}->Permission(
        Type => 'rw',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # --
        # error screen, don't show ticket
        # --
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    # --	
    # move queue
    # --
    if (!$Self->{DestQueueID}) {
        # --
        # fetch all queues
        # --
        my %MoveQueues = ();
        if ($Self->{ConfigObject}->Get('MoveInToAllQueues')) {
            %MoveQueues = $Self->{QueueObject}->GetAllQueues();
        }
        else {
            %MoveQueues = $Self->{QueueObject}->GetAllQueues(UserID => $Self->{UserID});
        }
        # --
        # build header
        # --
        my %Ticket = $Self->{TicketObject}->GetTicket(TicketID => $Self->{TicketID});
        $Output .= $Self->{LayoutObject}->Header(Title => 'Move Ticket');
        my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
        # --
        # get next states
        # --
        my %NextStates = $Self->{StateObject}->StateGetStatesByType(
            Type => 'DefaultNextMove',
            Result => 'HASH',
        );
        $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
        $Output .= $Self->{LayoutObject}->AgentMove(
            MoveQueues => \%MoveQueues,
            TicketID => $Self->{TicketID},
            NextStates => \%NextStates,
            %Ticket,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    elsif ($Self->{TicketObject}->MoveByTicketID(
          QueueID => $Self->{DestQueueID},
          UserID => $Self->{UserID},
          TicketID => $Self->{TicketID},
      ) ) {
        # --
        # set state
        # --
        my $NewStateID = $Self->{ParamObject}->GetParam(Param => 'NewStateID') || '';
        if ($Self->{ConfigObject}->{MoveSetState} && $NewStateID) {
            $Self->{TicketObject}->SetState(
                TicketID => $Self->{TicketID},
                StateID => $NewStateID,
                UserID => $Self->{UserID},
            );
        } 
        # --
        # redirect 
        # --
        if ($Self->{QueueID}) {
             return $Self->{LayoutObject}->Redirect(OP => "QueueID=$Self->{QueueID}");
        }
        else {
             return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreen});
        }
    }
    else {
        # error?!
        $Output = $Self->{LayoutObject}->Header(Title => "Error");
	    $Output .= $Self->{LayoutObject}->Error(
          Message => "Can't move TicketID '$Self->{TicketID}'!",
          Comment => 'Please contact your admin',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;
