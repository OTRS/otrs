# --
# Kernel/System/Ticket/State.pm - the sub module of the global Ticket.pm handle
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: State.pm,v 1.9 2002-12-15 00:58:21 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::System::Ticket::State;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.9 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

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
sub StateLookup {
    my $Self = shift;
    my %Param = @_;
    my $State = $Param{State};
    # --
    # check needed stuff
    # --
    if (!$Param{State}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need State!");
      return;
    }
    # --
    # check if we ask the same request?
    # --
    if (exists $Self->{"Ticket::State::StateLookup::$State"}) {
        return $Self->{"Ticket::State::StateLookup::$State"};
    }
    # --
    # get data
    # --
    my $SQL = "SELECT id " .
    " FROM " .
    " ticket_state " .
    " WHERE " .
    " name = '$State'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"Ticket::State::StateLookup::$State"} = $Row[0];
    }
    # --
    # check if data exists
    # --
    if (!exists $Self->{"Ticket::State::StateLookup::$State"}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No StateID for $State found!");
        return;
    }

    return $Self->{"Ticket::State::StateLookup::$State"};
}
# --
sub StateIDLookup {
    my $Self = shift;
    my %Param = @_;
    my $StateID = $Param{StateID} || '';
    # --
    # check needed stuff
    # --
    if (!$Param{StateID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need StateID!");
      return;
    }
    # --
    # check if we ask the same request?
    # --
    if (exists $Self->{"Ticket::State::StateLookupID::$StateID"}) {
        return $Self->{"Ticket::State::StateLookupID::$StateID"};
    }
    # --
    # get data 
    # --
    my $SQL = "SELECT name " .
    " FROM " .
    " ticket_state " .
    " WHERE " .
    " id = $StateID";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"Ticket::State::StateLookupID::$StateID"} = $RowTmp[0];
    }
    # --
    # check if data exists
    # --
    if (!exists $Self->{"Ticket::State::StateLookupID::$StateID"}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No State for $StateID found!");
        return;
    }

    return $Self->{"Ticket::State::StateLookupID::$StateID"};
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
      $Param{StateID} = $Self->StateLookup(State => $Param{State}) || return;
    }
    # --
    # state lookup
    # --
    if (!$Param{State}) {
      $Param{State} = $Self->StateIDLookup(StateID => $Param{StateID}) || return;
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
      my $HistoryType = '';
      if ($Param{State} =~ /closed successful/i) {
        $HistoryType = 'Close successful';
      }
      elsif ($Param{State} =~ /closed unsuccessful/i) {
        $HistoryType = 'Close unsuccessful';
      }
      elsif ($Param{State} =~ /open/i) {
        $HistoryType = 'Open';
      }
      elsif ($Param{State} =~ /new/i) {
        $HistoryType = 'NewTicket';
      }
      else {
        $HistoryType = 'Misc';
      }

      if ($HistoryType) {
        $Self->AddHistoryRow(
            TicketID => $Param{TicketID},
            ArticleID => $ArticleID,
            HistoryType => $HistoryType,
            Name => "Chaned Ticket State from '$CurrentState' to '$Param{State}'.",
            CreateUserID => $Param{UserID},
        );
      }
      return 1;
    }
    else {
      return;
    }
}
# --

1;

