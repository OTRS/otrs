# --
# Kernel/System/Ticket/State.pm - the sub module of the global Ticket.pm handle
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: State.pm,v 1.16 2004-01-08 11:41:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::System::Ticket::State;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.16 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub GetState {
    my $Self = shift;
    my %Param = @_;
    my $State = '';
    # --
    # check needed stuff
    # --
    if (!$Param{TicketID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need TicketID!");
      return;
    }
    my %TicketData = $Self->GetTicket(%Param);
    if ($TicketData{State}) {
        return $TicketData{State};
    }
    else {
        return;
    }
}
# --
sub SetState {
    my $Self = shift;
    my %Param = @_;
    my $ArticleID = $Param{ArticleID} || '';
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    if (!$Param{State} && !$Param{StateID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need StateID or State!");
        return;
    }
    # --
    # state id lookup
    # --
    if (!$Param{StateID}) {
        my %State = $Self->{StateObject}->StateGet(Name => $Param{State}, Cache => 1);
        $Param{StateID} = $State{ID} || return;
    }
    # --
    # state lookup
    # --
    if (!$Param{State}) {
        my %State = $Self->{StateObject}->StateGet(ID => $Param{StateID});
        $Param{State} = $State{Name} || return;
    } 
    # --
    # check if update is needed
    # --
    my $CurrentState = $Self->GetState(TicketID => $Param{TicketID});
    if ($Param{State} eq $CurrentState) {
      # update is not needed
      return 1;
    }
    # --
    # db update
    # --
    my $SQL = "UPDATE ticket SET ticket_state_id = $Param{StateID}, " .
    " change_time = current_timestamp, change_by = $Param{UserID} " .
    " WHERE id = $Param{TicketID} ";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
      # -- 
      # update ticket view index
      # --
      $Self->TicketAcceleratorUpdate(TicketID => $Param{TicketID});
      # --
      # add history
      # --
      $Self->AddHistoryRow(
          TicketID => $Param{TicketID},
          ArticleID => $ArticleID,
          HistoryType => 'StateUpdate',
          Name => "Old: '$CurrentState' New: '$Param{State}'",
          CreateUserID => $Param{UserID},
      );
      # --
      # send customer notification email
      # --
      $Self->SendCustomerNotification(
          Type => 'StateUpdate',
		  CustomerMessageParams => \%Param,
          TicketID => $Param{TicketID},
          UserID => $Param{UserID},
      );
      return 1;
    }
    else {
      return;
    }
}
# --

1;
