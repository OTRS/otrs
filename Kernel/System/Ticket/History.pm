# --
# History.pm - the sub module of the global Ticket.pm handle
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: History.pm,v 1.1 2001-12-21 17:54:40 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::System::Ticket::History;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub HistoryTypeLookup {
    my $Self = shift;
    my %Param = @_;
    my $Type = $Param{Type};

    # check if we ask the same request?
    if (exists $Self->{"Ticket::History::HistoryTypeLookup::$Type"}) {
        return $Self->{"Ticket::History::HistoryTypeLookup::$Type"};
    }
    # get data
    my $SQL = "SELECT id " .
    " FROM " .
    " ticket_history_type " .
    " WHERE " .
    " name = '$Type'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
    # store result
        $Self->{"Ticket::History::HistoryTypeLookup::$Type"} = $RowTmp[0];
    }
    # check if data exists
    if (!exists $Self->{"Ticket::History::HistoryTypeLookup::$Type"}) {
        print STDERR "Ticket->HistoryTypeLookup(!\$TypeID|$Type) \n";
        return;
    }

    return $Self->{"Ticket::History::HistoryTypeLookup::$Type"};
}
# --
sub AddHistoryRow {
    my $Self = shift;
    my %Param = @_;
    my $Name = $Param{Name};
    my $TicketID = $Param{TicketID};
    my $ArticleID = $Param{ArticleID} || 0;
    my $ValidID = $Param{ValidID};
    my $CreateUserID = $Param{CreateUserID};
    my $HistoryTypeID = $Param{HistoryTypeID};
    my $HistoryType = $Param{HistoryType};

    # db quoting
    $Name = $Self->{DBObject}->Quote($Name);

    # lookup!
    if ((!$HistoryTypeID) && ($HistoryType)) {
        $HistoryTypeID = $Self->HistoryTypeLookup(Type => $HistoryType);
    }
    if ((!$HistoryTypeID) && (!$HistoryType)) {
        print STDERR "DB->AddHistoryRow(No HistoryTypeID and no HistoryType)\n";
        return;
    }
    # get ValidID!
    if (!$ValidID) {
    $ValidID = $Self->{DBObject}->GetValidIDs();
    }
    my $SQL = "INSERT INTO ticket_history " .
    " (name, history_type_id, ticket_id, article_id, valid_id, " .
    " create_time, create_by, change_time, change_by) " .
        "VALUES " .
    "('$Name', $HistoryTypeID, $TicketID, $ArticleID, $ValidID, " .
    " current_timestamp, $CreateUserID, current_timestamp, $CreateUserID)";
    $Self->{DBObject}->Do(SQL => $SQL);
    return 1;
}
# --

1; 
