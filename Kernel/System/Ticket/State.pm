# --
# Kernel/System/Ticket/State.pm - the sub module of the global Ticket.pm handle
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: State.pm,v 1.18 2004-04-01 08:57:26 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::System::Ticket::State;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.18 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub StateSet {
    my $Self = shift;
    my %Param = @_;
    my $ArticleID = $Param{ArticleID} || '';
    # check needed stuff
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
    # state id lookup
    if (!$Param{StateID}) {
        my %State = $Self->{StateObject}->StateGet(Name => $Param{State}, Cache => 1);
        $Param{StateID} = $State{ID} || return;
    }
    # state lookup
    if (!$Param{State}) {
        my %State = $Self->{StateObject}->StateGet(ID => $Param{StateID});
        $Param{State} = $State{Name} || return;
    } 
    # check if update is needed
    my %Ticket = $Self->GetTicket(TicketID => $Param{TicketID});
    if ($Param{State} eq $Ticket{State}) {
      # update is not needed
      return 1;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db update
    my $SQL = "UPDATE ticket SET ticket_state_id = $Param{StateID}, " .
    " change_time = current_timestamp, change_by = $Param{UserID} " .
    " WHERE id = $Param{TicketID} ";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
      # clear ticket cache
      $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
      # update ticket view index
      $Self->TicketAcceleratorUpdate(TicketID => $Param{TicketID});
      # add history
      $Self->AddHistoryRow(
          TicketID => $Param{TicketID},
          ArticleID => $ArticleID,
          HistoryType => 'StateUpdate',
          Name => "Old: '$Ticket{State}' New: '$Param{State}'",
          CreateUserID => $Param{UserID},
      );
      # send customer notification email
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
sub StateList {
    my $Self = shift;
    my %Param = @_;
    my %States = ();
    # check needed stuff
    if (!$Param{UserID} && !$Param{CustomerUserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserID or CustomerUserID!");
        return;
    }
    # get states by type
    if ($Param{Type}) {
        %States = $Self->{StateObject}->StateGetStatesByType(
            Type => $Param{Type}, 
            Result => 'HASH',
        );
    }
# TicketID!!!
#delete $States{4}; # remove open!
    return %States;
}
# --
1;
