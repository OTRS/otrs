# --
# Priority.pm - the sub module of the global Ticket.pm handle
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Priority.pm,v 1.2 2002-05-26 21:29:26 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::System::Ticket::Priority;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub PriorityLookup {
    my $Self = shift;
    my %Param = @_;
    my $Type = $Param{Type};

    # check if we ask the same request?
    if (exists $Self->{"Ticket::Priority::PriorityLookup::$Type"}) {
        return $Self->{"Ticket::Priority::PriorityLookup::$Type"};
    }
    # get data
    my $SQL = "SELECT id " .
    " FROM " .
    " ticket_priority " .
    " WHERE " .
    " name = '$Type'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
    # store result
        $Self->{"Ticket::Priority::PriorityLookup::$Type"} = $RowTmp[0];
    }
    # check if data exists
    if (!exists $Self->{"Ticket::Priority::PriorityLookup::$Type"}) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            MSG => "No \$TypeID for $Type found!"
        );
        return;
    }

    return $Self->{"Ticket::Priority::PriorityLookup::$Type"};
}
# --
sub GetPriorityState {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID};
    my $State = '';
    my $Hit = 0;

    my $SQL = "SELECT sp.id " .
        " FROM " .
        " ticket st, ticket_priority sp " .
        " WHERE " .
        " st.id = $TicketID " .
        " AND " .
        " st.ticket_priority_id = sp.id ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $State = $RowTmp[0];
    }
    return $State;
}
# --
sub SetPriority {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID};
    my $Priority= $Param{Priority};
    my $PriorityID = $Param{PriorityID};
    my $UserID = $Param{UserID};

    # lookup!
    if ((!$PriorityID) && ($Priority)) {
        $PriorityID = $Self->PriorityLookup(Type => $Priority);
    }
    if ((!$PriorityID) && (!$Priority)) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            MSG => "No \$TypeID no Type given!"
        );
        return;
    }

    # db update
    my $SQL = "UPDATE ticket SET ticket_priority_id = $PriorityID, " .
        " change_time = current_timestamp, change_by = $UserID " .
        " WHERE id = $TicketID";
    $Self->{DBObject}->Do(SQL => $SQL);
    return 1;
}
# --

1;

