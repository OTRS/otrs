# --
# Lock.pm - the sub module of the global Ticket.pm handle
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Lock.pm,v 1.2 2001-12-23 13:29:40 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Lock;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub GetLockState {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID};
    my $LockState = 'lock';
    my $Hit = 0;

    my $SQL = "SELECT st.id " .
        " FROM " .
        " ticket st, ticket_lock_type slt " .
        " WHERE " .
        " st.id = $TicketID " .
        " AND " .
        " slt.name = '$LockState' " .
        " AND " .
        " st.ticket_lock_id = slt.id ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Hit = 1;
    }
    if ($Hit) {
        return 1;
    }
    else {
        return;
    }
}
# --
sub LockLookup {
    my $Self = shift;
    my %Param = @_;
    my $Type = $Param{Type} || return;

    # check if we ask the same request?
    if (exists $Self->{"Ticket::Lock::Lookup::$Type"}) {
        return $Self->{"Ticket::Lock::Lookup::$Type"};
    }
    # get data
    my $SQL = "SELECT id " .
    " FROM " .
    " ticket_lock_type " .
    " WHERE " .
    " name = '$Type'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"Ticket::Lock::Lookup::$Type"} = $RowTmp[0];
    }
    # check if data exists
    if (!exists $Self->{"Ticket::Lock::Lookup::$Type"}) {
        print STDERR "Ticket->LockLookup(!\$LockID|$Type)\n";
    return;
    }

    return $Self->{"Ticket::Lock::Lookup::$Type"};
}
# --
sub SetLock {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID};
    my $Lock = $Param{Lock};
    my $LockID = $Param{LockID};
    my $UserID = $Param{UserID};

    # lookup!
    if ((!$LockID) && ($Lock)) {
        $LockID = $Self->LockLookup(Type => $Lock);
    }
    if ((!$LockID) && (!$Lock)) {
        print STDERR "DB->AddHistoryRow(No HistoryTypeID and no HistoryType)\n";
        return;
    }

    # db update
    my $SQL = "UPDATE ticket SET ticket_lock_id = $LockID, " .
    " change_time = current_timestamp, change_by = $UserID " .
        " WHERE id = $TicketID";
    $Self->{DBObject}->Do(SQL => $SQL);

    my $HistoryType = '';
    if ($Lock eq 'unlock') {
        $HistoryType = 'Unlock';
    }
    elsif ($Lock eq 'lock') {
        $HistoryType = 'Lock';
    }

    if ($HistoryType) {
    $Self->AddHistoryRow(
        TicketID => $TicketID,
        CreateUserID => $UserID,
        HistoryType => $HistoryType,
        Name => "Ticket $HistoryType.",
    );
    }

    return 1;
}
# --

1;

