# --
# Kernel/System/Ticket/TimeAccouning.pm - the sub module of the global Ticket.pm handle
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: TimeAccounting.pm,v 1.9 2004-04-05 17:10:54 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::TimeAccounting;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.9 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub GetAccountedTime {
    my $Self = shift;
    my %Param = @_;
    my $AccountedTime = 0;
    # check needed stuff
    if (!$Param{TicketID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need TicketID!");
      return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db query
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
    # check needed stuff
    foreach (qw(TicketID ArticleID TimeUnit UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # check some wrong formats
    my $TimeUnit = $Param{TimeUnit};
    $TimeUnit =~ s/,/\./g;
    $TimeUnit = int($TimeUnit);
    # clear ticket cache
    $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db update
    my $SQL = "INSERT INTO time_accounting ".
      " (ticket_id, article_id, time_unit, create_time, create_by, change_time, change_by) ".
      " VALUES ".
      " ($Param{TicketID}, $Param{ArticleID}, $TimeUnit, ".
      " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID}) ";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
      # add history
      my $AccountedTime = $Self->GetAccountedTime(TicketID => $Param{TicketID});
      my $HistoryComment = "$Param{TimeUnit} time unit(s) accounted."; 
      if ($TimeUnit ne $Param{TimeUnit}) {
          $HistoryComment = "$TimeUnit time unit(s) accounted ($Param{TimeUnit} is invalid).";
      }
      $HistoryComment .= " Now total $AccountedTime time unit(s).";
      $Self->HistoryTicketAdd(
          TicketID => $Param{TicketID},
          ArticleID => $Param{ArticleID},
          CreateUserID => $Param{UserID},
          HistoryType => 'TimeAccounting',
          Name => $HistoryComment, 
      );
      return 1;
    }
    else {
      return;
    }
}
# --

1;
