# --
# Kernel/System/Ticket/TimeAccouning.pm - the sub module of the global Ticket.pm handle
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: TimeAccounting.pm,v 1.2 2002-12-08 20:49:19 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::TimeAccounting;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub GetAccountedTime {
    my $Self = shift;
    my %Param = @_;
    my $AccountedTime = 0;
    # --
    # check needed stuff
    # --
    if (!$Param{TicketID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need TicketID!");
      return;
    }
    # --
    # db query
    # --
    my $SQL = "SELECT time_unit " .
        " FROM " .
        " time_accounting " .
        " WHERE " .
        " ticket_id = $Param{TicketID} " .
        "  ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $AccountedTime = $AccountedTime + $Row[0];
    }
    return $AccountedTime;
}
# --
sub AccountTime {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID ArticleID TimeUnit UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # db update
    # --
    my $SQL = "INSERT INTO time_accounting ".
      " (ticket_id, article_id, time_unit, create_time, create_by, change_time, change_by) ".
      " VALUES ".
      " ($Param{TicketID}, $Param{ArticleID}, $Param{TimeUnit}, ".
      " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID}) ";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
      # --
      # add history
      # --
      my $AccountedTime = $Self->GetAccountedTime(TicketID => $Param{TicketID});
      $Self->AddHistoryRow(
          TicketID => $Param{TicketID},
          ArticleID => $Param{ArticleID},
          CreateUserID => $Param{UserID},
          HistoryType => 'TimeAccounting',
          Name => "$Param{TimeUnit} time unit(s) accounted. Now total $AccountedTime time unit(s).",
      );
      return 1;
    }
    else {
      return;
    }
}
# --

1;
