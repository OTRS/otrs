# --
# State.pm - the sub module of the global Ticket.pm handle
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: State.pm,v 1.2 2001-12-26 20:11:50 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::System::Ticket::State;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub GetState {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID};
    my $State = '';

    my $SQL = "SELECT ts.name " .
    " FROM " .
    " ticket st, ticket_state ts " .
    " WHERE " .
    " ts.id = st.ticket_state_id " .
    " AND " .
    " st.id = $TicketID ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $State = $RowTmp[0];
    }
    return $State;
}
# --
sub StateLookup {
    my $Self = shift;
    my %Param = @_;
    my $State = $Param{State};

    # check if we ask the same request?
    if (exists $Self->{"Ticket::State::StateLookup::$State"}) {
        return $Self->{"Ticket::State::StateLookup::$State"};
    }
    # get data
    my $SQL = "SELECT id " .
    " FROM " .
    " ticket_state " .
    " WHERE " .
    " name = '$State'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"Ticket::State::StateLookup::$State"} = $RowTmp[0];
    }
    # check if data exists
    if (!exists $Self->{"Ticket::State::StateLookup::$State"}) {
        print STDERR "Ticket->StateLookup(!\$StateID|$State)\n";
    return;
    }

    return $Self->{"Ticket::State::StateLookup::$State"};
}
# --
sub StateIDLookup {
    my $Self = shift;
    my %Param = @_;
    my $StateID = $Param{StateID} || '???';

    # check if we ask the same request?
    if (exists $Self->{"Ticket::State::StateLookupID::$StateID"}) {
        return $Self->{"Ticket::State::StateLookupID::$StateID"};
    }
    # get data
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
    # check if data exists
    if (!exists $Self->{"Ticket::State::StateLookupID::$StateID"}) {
        print STDERR "Ticket->StateIDLookup(!\$State|$StateID)\n";
        return;
    }

    return $Self->{"Ticket::State::StateLookupID::$StateID"};
}
# --
sub SetState {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID};
    my $UserID = $Param{UserID};
    my $StateID = $Param{StateID};
    my $State = $Param{State};
    my $ArticleID = $Param{ArticleID} || '';

    if ((!$StateID) && ($State)) {
        $StateID = $Self->StateLookup(State => $State);
        if ($Self->{Debug} > 0) {
            print STDERR "Ticket->SetState(!StateID) ->StateLookup($State=$StateID)\n";
        }
    }

    if (!$StateID) {
        print STDERR 'Ticket->SetState(!$StateID )';
        return;
    }

    my $SQL = "UPDATE ticket SET ticket_state_id = $StateID, " .
    " change_time = current_timestamp, " .
    " change_by = $UserID " .
    " WHERE id = $TicketID";

    $Self->{DBObject}->Do(SQL => $SQL);

    my $HistoryType = '';
    if ($State eq 'closed+') {
        $HistoryType = 'Close+';
    }
    elsif ($State eq 'closed-') {
        $HistoryType = 'Close-';
    }
    elsif ($State eq 'open') {
        $HistoryType = 'Open';
    }

    if ($HistoryType) {
        $Self->AddHistoryRow(
            TicketID => $TicketID,
            ArticleID => $ArticleID,
            HistoryType => $HistoryType,
            Name => "Ticket $State.",
            CreateUserID => $UserID,
        );
    }

    return 1;
}
# --

1;

