# --
# Kernel/System/Ticket/History.pm - the sub module of the global Ticket.pm handle
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: History.pm,v 1.7 2003-02-08 15:09:40 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::System::Ticket::History;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub HistoryTypeLookup {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    if (!$Param{Type}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need Type!");
      return;
    }
    # --
    # check if we ask the same request?
    # --
    if (exists $Self->{"Ticket::History::HistoryTypeLookup::$Param{Type}"}) {
        return $Self->{"Ticket::History::HistoryTypeLookup::$Param{Type}"};
    }
    # --
    # db query
    # --
    my $SQL = "SELECT id FROM ticket_history_type WHERE name = '$Param{Type}'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"Ticket::History::HistoryTypeLookup::$Param{Type}"} = $Row[0];
    }
    # --
    # check if data exists
    # --
    if (!exists $Self->{"Ticket::History::HistoryTypeLookup::$Param{Type}"}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No TypeID for $Param{Type} found!");
        return;
    }
    else {
        return $Self->{"Ticket::History::HistoryTypeLookup::$Param{Type}"};
    }
}
# --
sub AddHistoryRow {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    if (!$Param{Name}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need Name!");
      return;
    }
    # --
    # db quoting
    # --
    $Param{Name} = $Self->{DBObject}->Quote($Param{Name});
    # --
    # lookup!
    # --
    if ((!$Param{HistoryTypeID}) && ($Param{HistoryType})) {
        $Param{HistoryTypeID} = $Self->HistoryTypeLookup(Type => $Param{HistoryType});
    }
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID CreateUserID HistoryTypeID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    if (!$Param{ArticleID}) {
        $Param{ArticleID} = 0;
    }
    # --
    # get ValidID!
    # --
    if (!$Param{ValidID}) {
        $Param{ValidID} = $Self->{DBObject}->GetValidIDs();
    }
    # --
    # db insert
    # --
    my $SQL = "INSERT INTO ticket_history " .
    " (name, history_type_id, ticket_id, article_id, valid_id, " .
    " create_time, create_by, change_time, change_by) " .
        "VALUES " .
    "('$Param{Name}', $Param{HistoryTypeID}, $Param{TicketID}, ".
    " $Param{ArticleID}, $Param{ValidID}, " .
    " current_timestamp, $Param{CreateUserID}, current_timestamp, $Param{CreateUserID})";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}
# --
sub DeleteHistoryOfTicket {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # delete from db
    # --
    if ($Self->{DBObject}->Do(SQL => "DELETE FROM ticket_history WHERE ticket_id = $Param{TicketID}")) {
        return 1;
    }
    else {
        return;
    }
}
#--

1; 
