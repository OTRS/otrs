# --
# Ticket.pm - the global ticket handle
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Ticket.pm,v 1.9 2002-05-26 10:13:50 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket;

use strict;
use Kernel::System::Ticket::State;
use Kernel::System::Ticket::History;
use Kernel::System::Ticket::Lock;
use Kernel::System::Ticket::Priority;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.9 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

@ISA = (
    'Kernel::System::Ticket::State',
    'Kernel::System::Ticket::History',
    'Kernel::System::Ticket::Lock',
    'Kernel::System::Ticket::Priority',
);

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # 0=off; 1=on;
    $Self->{Debug} = 0;

    # get needed opbjects
    foreach ('ConfigObject', 'LogObject', 'DBObject') {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{CounterLog} = $Self->{ConfigObject}->Get('CounterLog');
    $Self->{SystemID} = $Self->{ConfigObject}->Get('SystemID');

    return $Self;
}
# --
sub CreateTicketNr {
    my $Self = shift;
    my $JumpCounter = shift || 0;
    # read count
    open (COUNTER, "< $Self->{CounterLog}") || die "Can't open $Self->{CounterLog}";
    my $Count = <COUNTER>;
    close (COUNTER);
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
          Priority => 'debug',
          MSG => "Read counter: $Count",
        );
    }
    # count++
    $Count++;
    $Count = $Count + $JumpCounter;
    # write new count
    open (COUNTER, "> $Self->{CounterLog}"); 
    flock (COUNTER, 2) || warn "Can't set file lock ($Self->{CounterLog}): $!";
    print COUNTER $Count . "\n";
    close (COUNTER);
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
          Priority => 'debug',
          MSG => "Write counter: $Count",
        );
    }

    my $Tn = $Self->{SystemID} . $Count;

    # check ticket number if exists generate new one! 
    if ($Self->CheckTicketNr(Tn=>$Tn)) {  
        $Self->{LoopProtectionCounter}++; 
        if ($Self->{LoopProtectionCounter} >= 1000) {
          $Self->{LogObject}->Log(
            Priority => 'error',
            MSG => "CounterLoopProtection is now $Self->{LoopProtectionCounter}! Stoped CreateTicketNr()!",
          );
          return;
        } 
        $Self->{LogObject}->Log(
          Priority => 'error',
          MSG => "Tn ($Tn) exists! Creating new one.",
        );
        $Tn = $Self->CreateTicketNr($Self->{LoopProtectionCounter});
    }
    return $Tn; 
}
# --
sub CheckTicketNr {
    my $Self = shift;
    my %Param = @_;
    my $Tn = $Param{Tn};
    my $Id = '';
    my $SQL = "SELECT id FROM ticket " .
    " WHERE " .
    " tn = '$Tn' ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Id = $RowTmp[0];
    }
    return $Id;
}
# --
sub CreateTicketDB {
    my $Self = shift;
    my %Param = @_;
    my $TN = $Param{TN};
    my $QueueID = $Param{QueueID};
    my $LockID = $Param{LockID};
    my $Lock = $Param{Lock};
    my $UserID = $Param{UserID};
    my $GroupID = $Param{GroupID};
    my $PriorityID = $Param{PriorityID};
    my $Priority = $Param{Priority};
    my $StateID = $Param{StateID};
    my $State = $Param{State};
    my $Answered = $Param{Answered} || 0;
    my $ValidID = $Param{ValidID} || 1;
    my $CreateUserID = $Param{CreateUserID};
    my $Age = time();

    # --
    # StateID lookup!
    # --
    if (!$StateID) {
        $StateID = $Self->StateLookup(State => $State);
        if ($Self->{Debug} > 0) {
           $Self->{LogObject}->Log(
              Priority => 'debug',
              MSG => "DB->CreateTicketDB-> (!\$StateID) ->StateLookup($State=$StateID)",
           );
        }
    }
    if (!$StateID) {
        $Self->{LogObject}->Log(
          Priority => 'error',
          MSG => "DB->CreateTicketDB-> No \$StateID!!!",
        );
        return;
    }

    # --
    # LockID lookup!
    # --
    if ((!$LockID) && ($Lock)) {
        $LockID = $Self->LockLookup(Type => $Lock);
    }
    if ((!$LockID) && (!$Lock)) {
        $Self->{LogObject}->Log(
          Priority => 'error',
          MSG => "DB->CreateTicketDB-> No LockID and no LockType!!!",
        );
        return;
    }
    # --
    # PriorityID lookup!
    # --
    if ((!$PriorityID) && ($Priority)) {
        $PriorityID = $Self->PriorityLookup(Type => $Priority);
    }
    if ((!$PriorityID) && (!$Priority)) {
        $Self->{LogObject}->Log(
          Priority => 'error',
          MSG => "DB->CreateTicketDB-> No PriorityID and no PriorityType!!!",
        );
        return;
    }

    # --
    # create db record
    # --
    my $SQL = "INSERT INTO ticket (tn, create_time_unix, queue_id, ticket_lock_id, ".
    " user_id, group_id, ticket_priority_id, ticket_state_id, ticket_answered, ".
    " valid_id, create_time, create_by, change_time, change_by) " .
    " VALUES ('$TN', $Age, $QueueID, $LockID, $UserID, $GroupID, $PriorityID, $StateID, ".
    " $Answered, $ValidID, " .
    " current_timestamp, $CreateUserID, current_timestamp, $CreateUserID)";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return $Self->GetIdOfTN(TN => $TN, Age => $Age);
    }
    else {
        $Self->{LogObject}->Log(
          Priority => 'error',
          MSG => "DB->CreateTicketDB-> create db record failed!!!",
        );
        return;
    } 
}
# --
sub GetIdOfTN {
    my $Self = shift;
    my %Param = @_;
    my $TN = $Param{TN};
    my $Age = $Param{Age} || '';
    my $Id;
    my $SQL = "SELECT id FROM ticket " .
    " WHERE " .
    " tn = '$TN' ";
    if ($Age) {
        $SQL .= " AND create_time_unix = $Age";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Id = $RowTmp[0];
    }
    return $Id;
}
# --
sub GetQueueIDOfTicketID {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID};
    my $Id;
    my $SQL = "SELECT queue_id FROM ticket WHERE id = $TicketID";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Id = $RowTmp[0];
    }
    return $Id;
}
# --
sub GetTNOfId {
    my $Self = shift;
    my %Param = @_;
    my $Tn;
    my $Id = $Param{ID} || return;
    my $SQL = "SELECT tn FROM ticket WHERE id = $Id";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Tn = $RowTmp[0];
    }
    return $Tn;
}
# --
sub GetLastCustomerArticle {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID};
    my %Data;
    my $SenderType = 'customer';
    my $SQL = "SELECT at.a_from, at.a_reply_to, at.a_to, at.a_cc, " .
    " at.a_subject, at.a_message_id, at.a_body, at.ticket_id, at.create_time" .
    " FROM " .
    " article at, article_sender_type st" .
    " WHERE " .
    " at.ticket_id = $TicketID " .
    " AND " .
    " at.article_sender_type_id = st.id " .
    " AND " .
    " st.name = '$SenderType' " .
    " ORDER BY at.incoming_time";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Data{From} = $RowTmp[0];
        $Data{ReplyTo} = $RowTmp[1],
        $Data{To} = $RowTmp[2];
        $Data{Cc} = $RowTmp[3];
        $Data{Subject} = $RowTmp[4];
        $Data{InReplyTo} = $RowTmp[5];
        $Data{Body} = $RowTmp[6];
        $Data{TicketID} = $RowTmp[7];
        $Data{Date} = $RowTmp[8];
    }

    return %Data;
}
# --
sub CheckOwner {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID};
    my $UserID = $Param{UserID};
    my $SQL = '';
    if ($UserID) {
        $SQL = "SELECT user_id " .
        " FROM " .
        " ticket " .
        " WHERE " .
        " id = $TicketID " .
        " AND " .
        " user_id = $UserID";
    }
    else {
        $SQL = "SELECT st.user_id, su.$Self->{ConfigObject}->{DatabaseUserTableUser} " .
        " FROM " .
        " ticket st, $Self->{ConfigObject}->{DatabaseUserTable} su " .
        " WHERE " .
        " st.id = $TicketID " .
        " AND " .
        " st.user_id = su.$Self->{ConfigObject}->{DatabaseUserTableUserID}";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        return $RowTmp[0], $RowTmp[1];
    }
    return;
}
# --
sub SetOwner {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID};
    my $UserID = $Param{UserID};
    my $NewUserID = $Param{NewUserID};
    my $UserLogin = $Param{UserLogin};

    if (!$NewUserID) {
        $NewUserID = $UserID;
    }

    # lookup!
    # db update
    my $SQL = "UPDATE ticket SET user_id = $NewUserID, " .
    " change_time = current_timestamp, change_by = $UserID " .
    " WHERE id = $TicketID";
    $Self->{DBObject}->Do(SQL => $SQL);

    $Self->AddHistoryRow(
        TicketID => $TicketID,
        CreateUserID => $UserID,
        HistoryType => 'OwnerUpdate',
        Name => "New Owner is '$UserLogin' (ID=$NewUserID).",
    );

    return 1;
}
# --
sub SetCustomerNo {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID};
    my $UserID = $Param{UserID};
    my $No = $Param{No};
    $No = $Self->{DBObject}->Quote($No);
    # db update
    my $SQL = "UPDATE ticket SET customer_id = '$No', " .
    " change_time = current_timestamp, change_by = $UserID " .
    " WHERE id = $TicketID";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}
# --
sub SetFreeText {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID};
    my $UserID = $Param{UserID};
    my $Value = $Param{Value};
    my $Key = $Param{Key};
    my $Counter = $Param{Counter};
    $Value = $Self->{DBObject}->Quote($Value);
    $Key = $Self->{DBObject}->Quote($Key);
    # db update
    my $SQL = "UPDATE ticket SET freekey$Counter = '$Key', " .
    " freetext$Counter = '$Value', " .
    " change_time = current_timestamp, change_by = $UserID " .
    " WHERE id = $TicketID";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}
# --
sub SetAnswered {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID};
    my $UserID = $Param{UserID};
    my $Answered = $Param{Answered} || 0;
    # db update
    my $SQL = "UPDATE ticket SET ticket_answered = $Answered, " .
    " change_time = current_timestamp, change_by = $UserID " .
    " WHERE id = $TicketID";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}
# --

1;


