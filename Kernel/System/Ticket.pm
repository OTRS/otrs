# --
# Kernel/System/Ticket.pm - the global ticket handle
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Ticket.pm,v 1.25 2002-10-20 21:57:46 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket;

use strict;
use Kernel::System::Ticket::Article;
use Kernel::System::Ticket::State;
use Kernel::System::Ticket::History;
use Kernel::System::Ticket::Lock;
use Kernel::System::Ticket::Priority;
use Kernel::System::Ticket::Owner;
use Kernel::System::Ticket::TimeAccounting;
use Kernel::System::Queue;
use Kernel::System::User;
use Kernel::System::AutoResponse;
use Kernel::System::SendAutoResponse;
use Kernel::System::SendNotification;
use Kernel::System::PostMaster::LoopProtection;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.25 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

@ISA = (
    'Kernel::System::Ticket::Article',
    'Kernel::System::Ticket::State',
    'Kernel::System::Ticket::History',
    'Kernel::System::Ticket::Lock',
    'Kernel::System::Ticket::Priority',
    'Kernel::System::Ticket::Owner',
    'Kernel::System::Ticket::TimeAccounting',
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
    # --
    # create common needed module objects
    # --
    $Param{QueueObject} = Kernel::System::Queue->new(%Param);
    $Param{UserObject} = Kernel::System::User->new(%Param);
    $Param{SendAutoResponse} = Kernel::System::SendAutoResponse->new(%Param, TicketObject => $Self);
    $Param{SendNotification} = Kernel::System::SendNotification->new(%Param, TicketObject => $Self);
    $Param{AutoResponse} = Kernel::System::AutoResponse->new(%Param);
    $Param{LoopProtectionObject} = Kernel::System::PostMaster::LoopProtection->new(%Param);
    # --
    # get needed objects
    # --
    foreach (qw(ConfigObject LogObject DBObject UserObject QueueObject SendAutoResponse 
      SendNotification AutoResponse LoopProtectionObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    # --
    # load ticket number generator 
    # --
    my $GeneratorModule = $Self->{ConfigObject}->Get('TicketNumberGenerator') 
      || 'Kernel::System::Ticket::Number::AutoIncrement';
    eval "require $GeneratorModule";
    push(@ISA, $GeneratorModule); 
    # --
    # load ticket index generator 
    # --
    my $GeneratorIndexModule = $Self->{ConfigObject}->Get('TicketIndexModule')
      || 'Kernel::System::Ticket::IndexAccelerator::RuntimeDB';
    eval "require $GeneratorIndexModule";
    push(@ISA, $GeneratorIndexModule);
    # --
    # ArticleDataDir
    # --
    $Self->{ArticleDataDir} = $Self->{ConfigObject}->Get('ArticleDir')
       || die "Got no ArticleDir!";
    # --
    # get time
    # --
    my ($Sec, $Min, $Hour, $Day, $Month, $Year) = localtime(time);
    $Self->{Year} = $Year+1900;
    $Self->{Month} = $Month+1;
    $Self->{Month}  = "0$Self->{Month}" if ($Self->{Month} <10);
    $Self->{Day} = $Day;
    $Self->{ArticleContentPath} = $Self->{Year}.'/'.$Self->{Month}.'/'. $Self->{Day};

    return $Self;
}
# --
sub CheckTicketNr {
    my $Self = shift;
    my %Param = @_;
    my $Id = '';
    # --
    # check needed stuff
    # --
    if (!$Param{Tn}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need TN!");
      return;
    }
    # --
    # db query
    # --
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM ticket " .
          " WHERE " .
          " tn = '$Param{Tn}' ",
    );
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Id = $RowTmp[0];
    }
    return $Id;
}
# --
sub CreateTicketDB {
    my $Self = shift;
    my %Param = @_;
    my $GroupID = $Param{GroupID};
    my $Answered = $Param{Answered} || 0;
    my $ValidID = $Param{ValidID} || 1;
    my $Age = time();
    # --
    # check needed stuff
    # --
    foreach (qw(TN QueueID UserID CreateUserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # StateID lookup!
    # --
    if (!$Param{StateID}) {
        $Param{StateID} = $Self->StateLookup(State => $Param{State});
    }
    if (!$Param{StateID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No StateID!!!");
        return;
    }
    # --
    # LockID lookup!
    # --
    if ((!$Param{LockID}) && ($Param{Lock})) {
        $Param{LockID} = $Self->LockLookup(Type => $Param{Lock});
    }
    if ((!$Param{LockID}) && (!$Param{Lock})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No LockID and no LockType!!!");
        return;
    }
    # --
    # PriorityID lookup!
    # --
    if ((!$Param{PriorityID}) && ($Param{Priority})) {
        $Param{PriorityID} = $Self->PriorityLookup(Type => $Param{Priority});
    }
    if ((!$Param{PriorityID}) && (!$Param{Priority})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No PriorityID and no PriorityType!!!");
        return;
    }

    # --
    # create db record
    # --
    my $SQL = "INSERT INTO ticket (tn, create_time_unix, queue_id, ticket_lock_id, ".
    " user_id, group_id, ticket_priority_id, ticket_state_id, ticket_answered, ".
    " valid_id, create_time, create_by, change_time, change_by) " .
    " VALUES ('$Param{TN}', $Age, $Param{QueueID}, $Param{LockID}, $Param{UserID}, ".
    " $GroupID, $Param{PriorityID}, $Param{StateID}, ".
    " $Answered, $ValidID, " .
    " current_timestamp, $Param{CreateUserID}, current_timestamp, $Param{CreateUserID})";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # --
        # get ticket id
        # --
        my $TicketID = $Self->GetIdOfTN(TN => $Param{TN}, Age => $Age);
        # --
        # update ticket viewi index
        # --
        $Self->TicketAcceleratorAdd(TicketID => $TicketID);
        # -- 
        # return ticket id
        # --
        return $TicketID;
    }
    else {
        $Self->{LogObject}->Log(Priority => 'error', Message => "create db record failed!!!");
        return;
    } 
}
# --
sub GetIdOfTN {
    my $Self = shift;
    my %Param = @_;
    my $Id;
    # --
    # check needed stuff
    # --
    if (!$Param{TN}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need TN!");
      return;
    }
    # --
    # db query
    # --
    my $SQL = "SELECT id FROM ticket " .
    " WHERE " .
    " tn = '$Param{TN}' ";
    if ($Param{Age}) {
        $SQL .= " AND create_time_unix = $Param{Age}";
    }
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
    my $Tn = '';
    # --
    # check needed stuff
    # --
    if (!$Param{ID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ID!");
      return;
    }
    # --
    # db query
    # --
    my $SQL = "SELECT tn FROM ticket WHERE id = $Param{ID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Tn = $RowTmp[0];
    }
    return $Tn;
}
# --
sub GetTicket {
    my $Self = shift;
    my %Param = @_;
    my %Ticket = ();
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
    my $SQL = "SELECT st.id, st.queue_id, sq.name, tsd.id, tsd.name, slt.id, slt.name, ".
        " sp.id, sp.name, st.create_time_unix, st.create_time, sq.group_id, st.tn, ".
        " st.customer_id, st.user_id ".
        " FROM ".
        " ticket st, ticket_state tsd, ticket_lock_type slt, ticket_priority sp, ".
        " queue sq ".
        " WHERE ".
        " tsd.id = st.ticket_state_id ".
        " AND ".
        " slt.id = st.ticket_lock_id ".
        " AND ".
        " sp.id = st.ticket_priority_id ".
        " AND ".
        " sq.id = st.queue_id ".
        " AND ".
        " st.id = $Param{TicketID} ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Ticket{TicketID} = $Row[0];
        $Ticket{QueueID} = $Row[1];
        $Ticket{Queue} = $Row[2];
        $Ticket{StateID} = $Row[3];
        $Ticket{State} = $Row[4];
        $Ticket{LockID} = $Row[5];
        $Ticket{Lock} = $Row[6];
        $Ticket{PriotityID} = $Row[7];
        $Ticket{Priotity} = $Row[8];
        $Ticket{Age} = time() - $Row[9];
        $Ticket{CreateTimeUnix} = $Row[9];
        $Ticket{Created} = $Row[10];
        $Ticket{GroupID} = $Row[11];
        $Ticket{TicketNumber} = $Row[12];
        $Ticket{CustomerID} = $Row[13];
        $Ticket{UserID} = $Row[14];
    }
    return %Ticket;
}
# --
sub GetQueueIDOfTicketID {
    my $Self = shift;
    my %Param = @_;
    my $Id;
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
    my $SQL = "SELECT queue_id FROM ticket WHERE id = $Param{TicketID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Id = $RowTmp[0];
    }
    return $Id;
}
# --
sub MoveByTicketID {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID QueueID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # move needed?
    # --
    if ($Param{QueueID} == $Self->GetQueueIDOfTicketID(TicketID => $Param{TicketID})) {
      # update not needed
      return 1;
    }
    # --
    # db update
    # --
    my $SQL = "UPDATE ticket SET queue_id = $Param{QueueID} where id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL) ) {
        # queue lookup
        my $Queue = $Self->{QueueObject}->QueueLookup(QueueID => $Param{QueueID}); 
        # -- 
        # update ticket view index
        # --
        $Self->TicketAcceleratorUpdate(TicketID => $Param{TicketID});
        # --
        # history insert
        # --
        $Self->AddHistoryRow(
            TicketID => $Param{TicketID},
            HistoryType => 'Move',
            Name => "Ticket moved to Queue '$Queue'.",
            CreateUserID => $Param{UserID},
        );
        # --
        # send move notify to queue subscriber 
        # --
        my $To = '';
        foreach ($Self->{QueueObject}->GetAllUserIDsByQueueID(QueueID => $Param{QueueID})) {
            my %UserData = $Self->{UserObject}->GetUserData(UserID => $_);
            if ($UserData{UserEmail} && $UserData{UserSendNewTicketNotification}) {
                $To .= "$UserData{UserEmail}, ";
            }
        }
        # --
        # send notification
        # --
        $Self->{SendNotification}->Send(
            Type => 'Move',
            To => $To,
            CustomerMessageParams => { Queue => $Queue },
            TicketNumber => $Self->GetTNOfId(ID => $Param{TicketID}),
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
sub SetCustomerNo {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID UserID No)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # db update
    # --
    $Param{No} = $Self->{DBObject}->Quote(lc($Param{No}));
    my $SQL = "UPDATE ticket SET customer_id = '$Param{No}', " .
    " change_time = current_timestamp, change_by = $Param{UserID} " .
    " WHERE id = $Param{TicketID} ";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # history insert
        $Self->AddHistoryRow(
            TicketID => $Param{TicketID},
            HistoryType => 'CustomerUpdate',
            Name => "CustomerID updated to '$Param{No}'.",
            CreateUserID => $Param{UserID},
        );
        return 1;
    }
    else {
        return;
    }
}
# --
sub GetCustomerNo {
    my $Self = shift;
    my %Param = @_;
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
    my $SQL = "SELECT customer_id FROM ticket WHERE id = $Param{TicketID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    $Param{CustomerID} = '';
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Param{CustomerID} = $RowTmp[0];
    }
    return $Param{CustomerID};
}
# --
sub SetTicketFreeText {
    my $Self = shift;
    my %Param = @_;
    my $Value = $Param{Value} || '';
    my $Key = $Param{Key} || '';
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID UserID Counter)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # db quote
    # --
    $Value = $Self->{DBObject}->Quote($Value);
    $Key = $Self->{DBObject}->Quote($Key);
    # --
    # db update
    # --
    my $SQL = "UPDATE ticket SET freekey$Param{Counter} = '$Key', " .
    " freetext$Param{Counter} = '$Value', " .
    " change_time = current_timestamp, change_by = $Param{UserID} " .
    " WHERE id = $Param{TicketID}";
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
    my $Answered = $Param{Answered} || 0;
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # db update
    # --
    my $SQL = "UPDATE ticket SET ticket_answered = $Answered, " .
    " change_time = current_timestamp, change_by = $Param{UserID} " .
    " WHERE id = $Param{TicketID} ";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}
# --
sub Permission {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # check if the user is in the same group as the ticket
    # --
    my $QueueID = $Self->GetQueueIDOfTicketID(TicketID => $Param{TicketID});
    my $GID = $Self->{QueueObject}->GetQueueGroupID(QueueID => $QueueID);
    my %Groups = $Self->{UserObject}->GetGroups(UserID => $Param{UserID});
    foreach (keys %Groups) {
        if ($_ eq $GID) {
            return 1;
        }
    }
    return;
}
# --
sub GetLockedTicketIDs {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    if (!$Param{UserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserID!");
        return;
    }
    my @ViewableTickets;
    my @ViewableLockIDs = (2);
    my $SQL = "SELECT id " .
      " FROM " .
      " ticket " .
      " WHERE " .
      " user_id = $Param{UserID} " .
      " AND ".
      " ticket_lock_id in ( ${\(join ', ', @ViewableLockIDs)} ) " .
      " ORDER BY create_time";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        push (@ViewableTickets, $RowTmp[0]);
    }
    return @ViewableTickets;
}
# --
sub GetLockedCount {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    if (!$Param{UserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserID!");
        return;
    }
    my @LockIDs = (2);
    my %Data;

    $Self->{DBObject}->Prepare(
       SQL => "SELECT ar.id as ca, st.name, ti.id, ar.create_by" .
              " FROM " .
              " ticket ti, article ar, article_sender_type st" .
              " WHERE " .
              " ti.user_id = $Param{UserID} " .
              " AND " .
              " ti.ticket_lock_id in ( ${\(join ', ', @LockIDs)} )" .
              " AND " .
              " ar.ticket_id = ti.id " .
              " AND " .
              " st.id = ar.article_sender_type_id " .
              " ORDER BY ar.create_time DESC",
    );

    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        if (!$Data{"ID$RowTmp[2]"}) {
          $Data{'Count'}++;
          if ($RowTmp[3] ne $Param{UserID}) {
            $Data{'ToDo'}++;
          }
        }
        $Data{"ID$RowTmp[2]"} = 1;
    }
    return %Data;
}
# --

1;

