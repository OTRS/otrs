# --
# Kernel/System/Ticket.pm - the global ticket handle
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Ticket.pm,v 1.178 2005-07-31 09:38:34 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket;

use strict;
use File::Path;
use Kernel::System::Main;
use Kernel::System::Ticket::Article;
use Kernel::System::State;
use Kernel::System::Priority;
use Kernel::System::Lock;
use Kernel::System::Queue;
use Kernel::System::User;
use Kernel::System::Group;
use Kernel::System::CustomerUser;
use Kernel::System::CustomerGroup;
use Kernel::System::Encode;
use Kernel::System::Email;
use Kernel::System::AutoResponse;
use Kernel::System::StdAttachment;
use Kernel::System::PostMaster::LoopProtection;
use Kernel::System::CustomerUser;
use Kernel::System::Notification;
use Kernel::System::LinkObject;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.178 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

@ISA = ('Kernel::System::Ticket::Article');

=head1 NAME

Kernel::System::Ticket - ticket lib

=head1 SYNOPSIS

All ticket functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

  use Kernel::Config;
  use Kernel::System::Time;
  use Kernel::System::Log;
  use Kernel::System::DB;
  use Kernel::System::Ticket;

  my $ConfigObject = Kernel::Config->new();
  my $TimeObject    = Kernel::System::Time->new(
      ConfigObject => $ConfigObject,
  );
  my $LogObject    = Kernel::System::Log->new(
      ConfigObject => $ConfigObject,
  );
  my $DBObject = Kernel::System::DB->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
  );
  my $TicketObject = Kernel::System::Ticket->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
      DBObject => $DBObject,
      TimeObject => $TimeObject,
  );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;

    # get needed objects
    foreach (qw(ConfigObject LogObject TimeObject DBObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create common needed module objects
    if (!$Param{EncodeObject}) {
        $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);
    }
    else {
        $Self->{EncodeObject} = $Param{EncodeObject};
    }
    if (!$Param{MainObject}) {
        $Self->{MainObject} = Kernel::System::Main->new(%Param);
    }
    else {
        $Self->{MainObject} = $Param{MainObject};
    }
    $Self->{UserObject} = Kernel::System::User->new(%Param);
    if (!$Param{GroupObject}) {
        $Self->{GroupObject} = Kernel::System::Group->new(%Param);
    }
    else {
        $Self->{GroupObject} = $Param{GroupObject};
    }
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    if (!$Param{CustomerGroupObject}) {
        $Self->{CustomerGroupObject} = Kernel::System::CustomerGroup->new(%Param);
    }
    else {
        $Self->{CustomerGroupObject} = $Param{CustomerGroupObject};
    }
    if (!$Param{QueueObject}) {
        $Self->{QueueObject} = Kernel::System::Queue->new(%Param);
    }
    else {
        $Self->{QueueObject} = $Param{QueueObject};
    }
    $Self->{SendmailObject} = Kernel::System::Email->new(%Param);
    $Self->{AutoResponse} = Kernel::System::AutoResponse->new(%Param);
    $Self->{LoopProtectionObject} = Kernel::System::PostMaster::LoopProtection->new(%Param);
    $Self->{StdAttachmentObject} = Kernel::System::StdAttachment->new(%Param);
    $Self->{PriorityObject} = Kernel::System::Priority->new(%Param);
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    $Self->{LockObject} = Kernel::System::Lock->new(%Param);
    $Self->{NotificationObject} = Kernel::System::Notification->new(%Param);

    # get config static var
    my @ViewableStates = $Self->{StateObject}->StateGetStatesByType(
        Type => 'Viewable',
        Result => 'Name',
    );
    $Self->{ViewableStates} = \@ViewableStates;
    my @ViewableStateIDs = $Self->{StateObject}->StateGetStatesByType(
        Type => 'Viewable',
        Result => 'ID',
    );
    $Self->{ViewableStateIDs} = \@ViewableStateIDs;
    my @ViewableLocks = $Self->{LockObject}->LockViewableLock(Type => 'Name');
    $Self->{ViewableLocks} = \@ViewableLocks;
    my @ViewableLockIDs = $Self->{LockObject}->LockViewableLock(Type => 'ID');
    $Self->{ViewableLockIDs} = \@ViewableLockIDs;
    # get config static var
    $Self->{Sendmail} = $Self->{ConfigObject}->Get('Sendmail');
    $Self->{SendmailBcc} = $Self->{ConfigObject}->Get('SendmailBcc');
    $Self->{FQDN} = $Self->{ConfigObject}->Get('FQDN');
    $Self->{Organization} = $Self->{ConfigObject}->Get('Organization');

    # --
    # load ticket number generator
    # --
    my $GeneratorModule = $Self->{ConfigObject}->Get('Ticket::NumberGenerator')
      || 'Kernel::System::Ticket::Number::AutoIncrement';
    if (!$Self->{MainObject}->Require($GeneratorModule)) {
        die "Can't load ticket number generator backend module $GeneratorModule! $@";
    }
    push(@ISA, $GeneratorModule);
    # --
    # load ticket index generator
    # --
    my $GeneratorIndexModule = $Self->{ConfigObject}->Get('Ticket::IndexModule')
      || 'Kernel::System::Ticket::IndexAccelerator::RuntimeDB';
    if (!$Self->{MainObject}->Require($GeneratorIndexModule)) {
        die "Can't load ticket index backend module $GeneratorIndexModule! $@";
    }
    push(@ISA, $GeneratorIndexModule);
    # --
    # load article storage module
    # --
    my $StorageModule = $Self->{ConfigObject}->Get('Ticket::StorageModule')
      || 'Kernel::System::Ticket::ArticleStorageDB';
    if (!$Self->{MainObject}->Require($StorageModule)) {
        die "Can't load ticket storage backend module $StorageModule! $@";
    }
    push(@ISA, $StorageModule);
    # --
    # load custom functions
    # --
    my $CustomModule = $Self->{ConfigObject}->Get('Ticket::CustomModule');
    if ($CustomModule) {
        if (!$Self->{MainObject}->Require($CustomModule)) {
            die "Can't load ticket custom module $CustomModule! $@";
        }
        push(@ISA, $CustomModule);
    }

    $Self->ArticleStorageInit();

    return $Self;
}

=item TicketCreateNumber()

creates a new ticket number

  my $TicketNumber = $TicketObject->TicketCreateNumber();

=cut

# just for compat
sub TicketCreateNumber {
    my $Self = shift;
    return $Self->CreateTicketNr(@_);
}

=item TicketCheckNumber()

checks if the ticket number exists, returns ticket id if exists

  my $TicketID = $TicketObject->TicketCheckNumber(Tn => '200404051004575');

=cut

# just for compat
sub CheckTicketNr {
    my $Self = shift;
    return $Self->TicketCheckNumber(@_);
}
sub TicketCheckNumber {
    my $Self = shift;
    my %Param = @_;
    my $Id = '';
    # check needed stuff
    if (!$Param{Tn}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need TN!");
      return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db query
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM ticket " .
          " WHERE " .
          " tn = '$Param{Tn}' ",
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Id = $Row[0];
    }
    # get merge main ticket if ticket is merged
    if ($Id) {
        my %Ticket = $Self->TicketGet(TicketID => $Id);
        if ($Ticket{StateType} eq 'merged') {
            my @Lines = $Self->HistoryGet(TicketID => $Ticket{TicketID}, UserID => 1);
            foreach my $Data (reverse @Lines) {
                if ($Data->{HistoryType} eq 'Merged') {
                    if ($Data->{Name} =~ /^.*\(\d+?\/(\d+?)\)$/) {
                        return $1;
                    }
                }
            }
        }
    }
    return $Id;
}

=item TicketCreate()

creates a new ticket

  my $TicketID = $TicketObject->TicketCreate(
        TN => $TicketObject->TicketCreateNumber(),
        Title => 'Some Ticket Title',
        Queue => 'Raw',                # or QueueID => 123,
        Lock => 'unlock',
        Priority => '3 normal'         # or PriorityID => 2,
        State => 'new',                # or StateID => 5,
        CustomerNo => '123465',
        CustomerUser => 'customer@example.com',
        UserID => 123, # new owner
        CreateUserID => 123,
  );

=cut

sub TicketCreate {
    my $Self = shift;
    my %Param = @_;
    my $GroupID = $Param{GroupID} || 1;
    my $ValidID = $Param{ValidID} || 1;
    my $Age = $Self->{TimeObject}->SystemTime();
    my $EscalationStartTime = $Self->{TimeObject}->SystemTime();
    # check needed stuff
    foreach (qw(UserID CreateUserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # QueueID/Queue lookup!
    if (!$Param{QueueID} && $Param{Queue}) {
        $Param{QueueID} = $Self->{QueueObject}->QueueLookup(Queue => $Param{Queue});
    }
    elsif (!$Param{Queue}) {
        $Param{Queue} = $Self->{QueueObject}->QueueLookup(QueueID => $Param{QueueID});
    }
    if (!$Param{QueueID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No QueueID for '$Param{Queue}'!!!");
        return;
    }
    # StateID/State lookup!
    if (!$Param{StateID}) {
        my %State = $Self->{StateObject}->StateGet(Name => $Param{State});
        $Param{StateID} = $State{ID};
    }
    elsif (!$Param{State}) {
        my %State = $Self->{StateObject}->StateGet(ID => $Param{StateID});
        $Param{State} = $State{Name};
    }
    if (!$Param{StateID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No StateID for '$Param{State}'!!!");
        return;
    }
    # LockID lookup!
    if (!$Param{LockID} && $Param{Lock}) {
        $Param{LockID} = $Self->{LockObject}->LockLookup(Type => $Param{Lock});
    }
    if (!$Param{LockID} && !$Param{Lock}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No LockID and no LockType!!!");
        return;
    }
    # PriorityID/Priority lookup!
    if (!$Param{PriorityID} && $Param{Priority}) {
        $Param{PriorityID} = $Self->PriorityLookup(Type => $Param{Priority});
    }
    elsif ($Param{PriorityID} && !$Param{Priority}) {
        $Param{Priority} = $Self->PriorityLookup(ID => $Param{PriorityID});
    }
    if (!$Param{PriorityID} && !$Param{Priority}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No PriorityID and no PriorityType!!!");
        return;
    }
    # create ticket number if not given
    if (!$Param{TN}) {
        $Param{TN} = $Self->CreateTicketNr();
    }
    # check ticket title
    if (!$Param{Title}) {
        $Param{Title} = '';
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # create db record
    my $SQL = "INSERT INTO ticket (tn, title, create_time_unix, queue_id, ticket_lock_id, ".
    " user_id, group_id, ticket_priority_id, ticket_state_id, ticket_answered, ".
    " escalation_start_time, timeout, valid_id, create_time, create_by, change_time, change_by) " .
    " VALUES ('$Param{TN}', '$Param{Title}', $Age, $Param{QueueID}, $Param{LockID}, $Param{UserID}, ".
    " $GroupID, $Param{PriorityID}, $Param{StateID}, ".
    " 0, $EscalationStartTime, 0, $ValidID, " .
    " current_timestamp, $Param{CreateUserID}, current_timestamp, $Param{CreateUserID})";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # get ticket id
        my $TicketID = $Self->TicketIDLookup(
            TicketNumber => $Param{TN},
            UserID => $Param{UserID},
        );
        # history insert
        $Self->HistoryAdd(
            TicketID => $TicketID,
            QueueID => $Param{QueueID},
            HistoryType => 'NewTicket',
            Name => "\%\%$Param{TN}\%\%$Param{Queue}\%\%$Param{Priority}\%\%$Param{State}\%\%$TicketID",
            CreateUserID => $Param{UserID},
        );
        # set customer data if given
        if ($Param{CustomerNo} || $Param{CustomerUser}) {
            $Self->SetCustomerData(
                TicketID => $TicketID,
                No => $Param{CustomerNo} || '',
                User => $Param{CustomerUser} || '',
                UserID => $Param{UserID},
            );
        }
        # update ticket view index
        $Self->TicketAcceleratorAdd(TicketID => $TicketID);
        # log
        $Self->{LogObject}->Log(
            Priority => 'notice',
                Message => "New Ticket [$Param{TN}/".substr($Param{Title}, 0, 15)."] created (TicketID=$TicketID,Queue=$Param{Queue},Priority=$Param{Priority},State=$Param{State})",
        );
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketCreate',
            UserID => $Param{UserID},
            TicketID => $TicketID,
        );
        # return ticket id
        return $TicketID;
    }
    else {
        $Self->{LogObject}->Log(Priority => 'error', Message => "create db record failed!!!");
        return;
    }
}

=item TicketDelete()

deletes a ticket from storage

  $TicketObject->TicketDelete(
      TicketID => 123,
      UserID => 123,
  );

=cut

sub TicketDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # clear ticket cache
    $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
    # update ticket index
    $Self->TicketAcceleratorDelete(%Param);
    # delete ticket_history
    if ($Self->{DBObject}->Do(SQL => "DELETE FROM ticket_history WHERE ticket_id = $Param{TicketID}")) {
        # delete article
        if ($Self->ArticleDelete(%Param)) {
            # delete ticket
            if ($Self->{DBObject}->Do(SQL => "DELETE FROM ticket WHERE id = $Param{TicketID}")) {
                # ticket event
                $Self->TicketEventHandlerPost(
                    Event => 'TicketDelete',
                    UserID => $Param{UserID},
                    TicketID => $Param{TicketID},
                );
                return 1;
            }
        }
    }
    return;
}

=item TicketIDLookup()

ticket id lookup by ticket number

  my $TicketID = $TicketObject->TicketIDLookup(
      TicketNumber => '2004040510440485',
      UserID => 123,
  );

=cut

sub TicketIDLookup {
    my $Self = shift;
    my %Param = @_;
    my $Id;
    # check needed stuff
    if (!$Param{TicketNumber}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need TicketNumber!");
      return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db query
    my $SQL = "SELECT id FROM ticket " .
    " WHERE " .
    " tn = '$Param{TicketNumber}' ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Id = $Row[0];
    }
    return $Id;
}

=item TicketNumberLookup()

ticket number lookup by ticket id

  my $TicketNumber = $TicketObject->TicketNumberLookup(
      TicketID => 123,
      UserID => 123,
  );

=cut

sub TicketNumberLookup {
    my $Self = shift;
    my %Param = @_;
    my $Tn = '';
    # check needed stuff
    if (!$Param{TicketID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need TicketID!");
      return;
    }
    my %Ticket = $Self->TicketGet(%Param);
    if (%Ticket) {
        return $Ticket{TicketNumber};
    }
    else {
        return;
    }

}

=item TicketSubjectBuild()

rebuild a new ticket subject

  my $NewSubject = $TicketObject->TicketSubjectBuild(
      TicketNumber => '2004040510440485',
      Subject => $OldSubject,
  );

=cut

sub TicketSubjectBuild {
    my $Self = shift;
    my %Param = @_;
    my $Subject = $Param{Subject} || '';
    # check needed stuff
    foreach (qw(TicketNumber)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    $Subject = $Self->TicketSubjectClean(%Param);
    my $TicketHook = $Self->{ConfigObject}->Get('Ticket::Hook');
    my $TicketHookDivider = $Self->{ConfigObject}->Get('Ticket::HookDivider');
    my $TicketSubjectRe = $Self->{ConfigObject}->Get('Ticket::SubjectRe');
    $Subject = "$TicketSubjectRe: [$TicketHook$TicketHookDivider$Param{TicketNumber}] " . $Subject;
    return $Subject;
}

=item TicketSubjectClean()

strip/clean up a ticket subject

  my $NewSubject = $TicketObject->TicketSubjectClean(
      TicketNumber => '2004040510440485',
      Subject => $OldSubject,
  );

=cut

sub TicketSubjectClean {
    my $Self = shift;
    my %Param = @_;
    my $Subject = $Param{Subject} || '';
    # check needed stuff
    foreach (qw(TicketNumber)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # get ticket data
    my $TicketHook = $Self->{ConfigObject}->Get('Ticket::Hook');
    my $TicketHookDivider = $Self->{ConfigObject}->Get('Ticket::HookDivider');
    my $TicketSubjectSize = $Self->{ConfigObject}->Get('Ticket::SubjectSize') || 80;
    $Subject =~ s/\[$TicketHook: $Param{TicketNumber}\] //g;
    $Subject =~ s/\[$TicketHook:$Param{TicketNumber}\] //g;
    $Subject =~ s/\[$TicketHook$TicketHookDivider$Param{TicketNumber}\] //g;
    if ($Self->{ConfigObject}->Get('Ticket::SubjectCleanAllNumbers')) {
        $Subject =~ s/\[$TicketHook$TicketHookDivider\d+?\] //g;
    }
    $Subject =~ s/$TicketHook: $Param{TicketNumber} //g;
    $Subject =~ s/$TicketHook:$Param{TicketNumber} //g;
    $Subject =~ s/$TicketHook$TicketHookDivider$Param{TicketNumber} //g;
    if ($Self->{ConfigObject}->Get('Ticket::SubjectCleanAllNumbers')) {
        $Subject =~ s/$TicketHook$TicketHookDivider\d+? //g;
    }
    $Subject =~ s/^(..(\[\d+\])?: )+//;
    $Subject =~ s/^(.{$TicketSubjectSize}).*$/$1 [...]/;
    return $Subject;
}


=item TicketGet()

get ticket info (TicketNumber, State, StateID, StateType,
Priority, PriorityID, Lock, LockID, Queue, QueueID,
CustomerID, CustomerUserID, UserID, Owner, OwnerID,
Created, Changed, TicketFreeKey1-8, TicketFreeText1-8, ...)

  my %Ticket = $TicketObject->TicketGet(
      TicketID => 123,
      UserID => 123,
  );

=cut

sub TicketGet {
    my $Self = shift;
    my %Param = @_;
    my %Ticket = ();
    # check needed stuff
    if (!$Param{TicketID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need TicketID!");
        return;
    }
    # check if result is cached
    if ($Self->{'Cache::GetTicket'.$Param{TicketID}}) {
        return %{$Self->{'Cache::GetTicket'.$Param{TicketID}}};
    }
    # db query
    my $SQL = "SELECT st.id, st.queue_id, sq.name, st.ticket_state_id, st.ticket_lock_id, ".
        " sp.id, sp.name, st.create_time_unix, st.create_time, sq.group_id, st.tn, ".
        " st.customer_id, st.user_id, su.$Self->{ConfigObject}->{DatabaseUserTableUserID}, ".
        " su.$Self->{ConfigObject}->{DatabaseUserTableUser}, st.ticket_answered, st.until_time, ".
        " st.customer_user_id, st.freekey1, st.freetext1, st.freekey2, st.freetext2,".
        " st.freekey3, st.freetext3, st.freekey4, st.freetext4,".
        " st.freekey5, st.freetext5, st.freekey6, st.freetext6,".
        " st.freekey7, st.freetext7, st.freekey8, st.freetext8, ".
        " st.change_time, st.title, st.escalation_start_time, st.timeout, ".
        " st.freetime1, st.freetime2".
        " FROM ".
        " ticket st, ticket_priority sp, ".
        " queue sq, $Self->{ConfigObject}->{DatabaseUserTable} su ".
        " WHERE ".
        " sp.id = st.ticket_priority_id ".
        " AND ".
        " sq.id = st.queue_id ".
        " AND ".
        " st.user_id = su.$Self->{ConfigObject}->{DatabaseUserTableUserID} ".
        " AND ".
        " st.id = ".$Self->{DBObject}->Quote($Param{TicketID})."";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Ticket{TicketID} = $Row[0];
        $Ticket{Title} = $Row[35];
        $Ticket{QueueID} = $Row[1];
        $Ticket{Queue} = $Row[2];
        $Ticket{StateID} = $Row[3];
        $Ticket{LockID} = $Row[4];
        $Ticket{PriorityID} = $Row[5];
        $Ticket{Priority} = $Row[6];
        $Ticket{Age} = $Self->{TimeObject}->SystemTime() - $Row[7];
#        $Ticket{SLAAge} = $Self->{TimeObject}->SLATime(StartTime => $Row[7]);
        $Ticket{CreateTimeUnix} = $Row[7];
        $Ticket{Created} = $Self->{TimeObject}->SystemTime2TimeStamp(SystemTime => $Row[7]);
        $Ticket{Changed} = $Row[34];
        $Ticket{EscalationStartTime} = $Row[36];
        $Ticket{UnlockTimeout} = $Row[37];
        $Ticket{GroupID} = $Row[9];
        $Ticket{TicketNumber} = $Row[10];
        $Ticket{CustomerID} = $Row[11];
        $Ticket{CustomerUserID} = $Row[17];
        $Ticket{UserID} = $Row[12];
        $Ticket{OwnerID} = $Row[13];
        $Ticket{Owner} = $Row[14];
        $Ticket{RealTillTimeNotUsed} = $Row[16];
        $Ticket{TicketFreeKey1} = defined($Row[18]) ? $Row[18] : '';
        $Ticket{TicketFreeText1} = defined($Row[19]) ? $Row[19] : '';
        $Ticket{TicketFreeKey2} = defined($Row[20]) ? $Row[20] : '';
        $Ticket{TicketFreeText2} = defined($Row[21]) ? $Row[21] : '';
        $Ticket{TicketFreeKey3} = defined($Row[22]) ? $Row[22] : '';
        $Ticket{TicketFreeText3} = defined($Row[23]) ? $Row[23] : '';
        $Ticket{TicketFreeKey4} = defined($Row[24]) ? $Row[24] : '';
        $Ticket{TicketFreeText4} = defined($Row[25]) ? $Row[25] : '';
        $Ticket{TicketFreeKey5} = defined($Row[26]) ? $Row[26] : '';
        $Ticket{TicketFreeText5} = defined($Row[27]) ? $Row[27] : '';
        $Ticket{TicketFreeKey6} = defined($Row[28]) ? $Row[28] : '';
        $Ticket{TicketFreeText6} = defined($Row[29]) ? $Row[29] : '';
        $Ticket{TicketFreeKey7} = defined($Row[30]) ? $Row[30] : '';
        $Ticket{TicketFreeText7} = defined($Row[31]) ? $Row[31] : '';
        $Ticket{TicketFreeKey8} = defined($Row[32]) ? $Row[32] : '';
        $Ticket{TicketFreeText8} = defined($Row[33]) ? $Row[33] : '';
        $Ticket{TicketFreeTime1} = defined($Row[38]) ? $Row[38] : '';
        $Ticket{TicketFreeTime2} = defined($Row[39]) ? $Row[39] : '';
    }
    # check ticket
    if (!$Ticket{TicketID}) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "No such TicketID ($Param{TicketID})!",
        );
        return;
    }
    # get lock
    $Ticket{Lock} = $Self->{LockObject}->LockLookup(ID => $Ticket{LockID});
    # get state info
    my %StateData = $Self->{StateObject}->StateGet(ID => $Ticket{StateID}, Cache => 1);
    $Ticket{StateType} = $StateData{TypeName};
    $Ticket{State} = $StateData{Name};
    if (!$Ticket{RealTillTimeNotUsed} || $StateData{TypeName} !~ /^pending/i) {
        $Ticket{UntilTime} = 0;
    }
    else {
        $Ticket{UntilTime} = $Ticket{RealTillTimeNotUsed} - $Self->{TimeObject}->SystemTime();
    }
    # cache user result
    $Self->{'Cache::GetTicket'.$Param{TicketID}} = \%Ticket;
    # return ticket data
    return %Ticket;
}

=item TicketTitleUpdate()

update ticket title

  $TicketObject->TicketTitleUpdate(
      Title => 'Some Title',
      TicketID => 123,
  );

=cut

sub TicketTitleUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Title TicketID)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    my $SQL = "UPDATE ticket SET title = '$Param{Title}' ".
      " WHERE ".
      " id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL) ) {
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketTitleUpdate',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item TicketUnlockTimeoutUpdate()

update ticket unlock time to now

  $TicketObject->TicketUnlockTimeoutUpdate(
      UnlockTimeout => $TimeObject->SystemTime(),
      TicketID => 123,
      UserID => 143,
  );

=cut

sub TicketUnlockTimeoutUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(UnlockTimeout TicketID UserID)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # check if update is needed
    my %Ticket = $Self->TicketGet(%Param);
    if ($Ticket{UnlockTimeout} eq $Param{UnlockTimeout}) {
        return 1;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # reset unlock time
    my $SQL = "UPDATE ticket SET timeout = $Param{UnlockTimeout} ".
        " WHERE id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL) ) {
        # reset ticket cache
        $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
        # add history
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            CreateUserID => $Param{UserID},
            HistoryType => 'Misc',
            Name => "Reset of unlock time.",
        );
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketUnlockTimeoutUpdate',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item TicketEscalationStartUpdate()

update ticket escalation start time to now

  $TicketObject->TicketEscalationStartUpdate(
      EscalationStartTime => $TimeObject->SystemTime(),
      TicketID => 123,
  );

=cut

sub TicketEscalationStartUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(EscalationStartTime TicketID UserID)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    my $SQL = "UPDATE ticket SET escalation_start_time = $Param{EscalationStartTime} ".
      " WHERE ".
      " id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL) ) {
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            CreateUserID => $Param{UserID},
            HistoryType => 'Misc',
            Name => "Reset of escalation time.",
        );
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketEscalationStartUpdate',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item TicketQueueID()

get ticket queue id

  my $QueueID = $TicketObject->TicketQueueID(
      TicketID => 123,
  );

=cut

sub TicketQueueID {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{TicketID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need TicketID!");
        return;
    }
    my %Ticket = $Self->TicketGet(%Param, UserID => 1);
    if (%Ticket) {
        return $Ticket{QueueID};
    }
    else {
        return;
    }
}

=item MoveList()

to get the move queue list for a ticket (depends on workflow, if configured)

  my %Queues = $TicketObject->MoveList(
      Type => 'create',
      UserID => 123,
  );

  my %Queues = $TicketObject->MoveList(
      QueueID => 123,
      UserID => 123,
  );

  my %Queues = $TicketObject->MoveList(
      TicketID => 123,
      UserID => 123,
  );

=cut

sub MoveList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{UserID} && !$Param{CustomerUserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserID or CustomerUserID!");
        return;
    }
    # check needed stuff
    if (!$Param{QueueID} && !$Param{TicketID} && !$Param{Type}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need QueueID, TicketID or Type!");
        return;
    }
# TicketID!!!
    my %Queues = ();
    if ($Param{UserID} && $Param{UserID} eq 1) {
        %Queues = $Self->{QueueObject}->GetAllQueues();
    }
    else {
        %Queues = $Self->{QueueObject}->GetAllQueues(%Param);
    }
#delete $Queues{315};
    # workflow
    if ($Self->TicketAcl(
        %Param,
        ReturnType => 'Ticket',
        ReturnSubType => 'Queue',
        Data => \%Queues,
    )) {
        return $Self->TicketAclData();
    }
    # /workflow
    return %Queues;
}

=item MoveTicket()

to move a ticket (send notification to agents of selected my queues, it ticket isn't closed)

  $TicketObject->MoveTicket(
      QueueID => 123,
      TicketID => 123,
      UserID => 123,
  );

  $TicketObject->MoveTicket(
      Queue => 'Some Queue Name',
      TicketID => 123,
      UserID => 123,
  );

=cut

sub MoveTicket {
    my $Self = shift;
    my %Param = @_;
    # queue lookup
    if ($Param{Queue} && !$Param{QueueID}) {
        $Param{QueueID} = $Self->{QueueObject}->QueueLookup(Queue => $Param{Queue});
    }
    # check needed stuff
    foreach (qw(TicketID QueueID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # get current ticket
    my %Ticket = $Self->TicketGet(%Param);
    # move needed?
    if ($Param{QueueID} == $Ticket{QueueID}) {
        # update not needed
        return 1;
    }
    # permission check
    my %MoveList = $Self->MoveList(%Param, Type => 'move_into');
    if (!$MoveList{$Param{QueueID}}) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Permission denied on TicketID: $Param{TicketID}!",
        );
        return;
    }
    # db update
    my $SQL = "UPDATE ticket SET ".
      " queue_id = ".$Self->{DBObject}->Quote($Param{QueueID}).
      "  where id = ".$Self->{DBObject}->Quote($Param{TicketID})."";
    if ($Self->{DBObject}->Do(SQL => $SQL) ) {
        # queue lookup
        my $Queue = $Self->{QueueObject}->QueueLookup(QueueID => $Param{QueueID});
        # clear ticket cache
        $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
        # update ticket view index
        $Self->TicketAcceleratorUpdate(TicketID => $Param{TicketID});
        # history insert
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            QueueID => $Ticket{QueueID},
            HistoryType => 'Move',
            Name => "\%\%$Queue\%\%$Param{QueueID}\%\%$Ticket{Queue}\%\%$Ticket{QueueID}",
            CreateUserID => $Param{UserID},
        );
        # send move notify to queue subscriber
        if ($Ticket{StateType} ne 'closed') {
            foreach ($Self->GetSubscribedUserIDsByQueueID(QueueID => $Param{QueueID})) {
                my %UserData = $Self->{UserObject}->GetUserData(
                    UserID => $_,
                    Cached => 1,
                    Valid => 1,
                );
                if ($UserData{UserSendMoveNotification}) {
                    # send agent notification
                    $Self->SendAgentNotification(
                        Type => 'Move',
                        UserData => \%UserData,
                        CustomerMessageParams => { Queue => $Queue },
                        TicketID => $Param{TicketID},
                        UserID => $Param{UserID},
                    );
                }
            }
            # send customer notification email
            my %Preferences = $Self->{UserObject}->GetUserData(UserID => $Param{UserID});
            $Self->SendCustomerNotification(
                Type => 'QueueUpdate',
                CustomerMessageParams => { %Preferences, Queue => $Queue },
                TicketID => $Param{TicketID},
                UserID => $Param{UserID},
            );
        }
        # should I unlock a ticket after move?
        if ($Self->{ConfigObject}->Get('Ticket::ForceUnlockAfterMove')) {
            $Self->LockSet(
                TicketID => $Param{TicketID},
                Lock => 'unlock',
                UserID => $Param{UserID},
            );
        }
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'MoveTicket',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}
# --
sub MoveQueueList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db query
    my @Queue = ();
    my $SQL = "SELECT sh.name, ht.name, sh.create_by ".
        " FROM ".
        " ticket_history sh, ticket_history_type ht ".
        " WHERE ".
        " sh.ticket_id = $Param{TicketID} ".
        " AND ".
        " ht.name IN ('Move', 'NewTicket')  ".
        " AND ".
        " ht.id = sh.history_type_id".
        " ORDER BY sh.id";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        if ($Row[1] eq 'NewTicket') {
            if ($Row[2] ne '1') {
#                push (@Queue, $Row[2]);
            }
        }
        elsif ($Row[1] eq 'Move') {
            if ($Row[0] =~ /^Ticket moved to Queue '.+?' \(ID=(.+?)\)/) {
                push (@Queue, $1);
            }
        }
    }
    my @QueueInfo = ();
    foreach (@Queue) {
        # queue lookup
        my $Queue = $Self->{QueueObject}->QueueLookup(QueueID => $_, Cache => 1);
        push (@QueueInfo, $Queue);
    }
    return @Queue;
}

=item SetCustomerData()

Set customer data of ticket.

  $TicketObject->SetCustomerData(
      No => 'client123',
      User => 'client-user-123',
      TicketID => 123,
      UserID => 23,
  );

=cut

sub SetCustomerData {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    if (!defined($Param{No}) && !defined($Param{User})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need User or No for update!");
        return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db customer id update
    if (defined($Param{No})) {
        $Param{No} = $Self->{DBObject}->Quote(lc($Param{No}));
        my $SQL = "UPDATE ticket SET customer_id = '$Param{No}', " .
          " change_time = current_timestamp, change_by = $Param{UserID} " .
          " WHERE id = $Param{TicketID} ";
        if ($Self->{DBObject}->Do(SQL => $SQL)) {
            $Param{History} = "CustomerID=$Param{No};";
        }
    }
    # db customer user update
    if (defined($Param{User})) {
        $Param{User} = $Self->{DBObject}->Quote(lc($Param{User}));
        my $SQL = "UPDATE ticket SET customer_user_id = '$Param{User}', " .
          " change_time = current_timestamp, change_by = $Param{UserID} " .
          " WHERE id = $Param{TicketID} ";
        if ($Self->{DBObject}->Do(SQL => $SQL)) {
            $Param{History} .= "CustomerUser=$Param{User};";
        }
    }
    if ($Param{History}) {
        # history insert
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            HistoryType => 'CustomerUpdate',
            Name => "\%\%".$Param{History},
            CreateUserID => $Param{UserID},
        );
        # clear ticket cache
        $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'SetCustomerData',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item TicketFreeTextGet()

get _possible_ ticket free text options

Note: the current value is accessible over TicketGet()

  my $HashRef = $TicketObject->TicketFreeTextGet(
     Type => 'TicketFreeText3',
     TicketID => 123,
     UserID => 123, # or CustomerUserID
  );

  my $HashRef = $TicketObject->TicketFreeTextGet(
     Type => 'TicketFreeText3',
     UserID => 123, # or CustomerUserID
  );

=cut

sub TicketFreeTextGet {
    my $Self = shift;
    my %Param = @_;
    my $Value = $Param{Value} || '';
    my $Key = $Param{Key} || '';
    # check needed stuff
    foreach (qw(Type)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
   if (!$Param{UserID} && !$Param{CustomerUserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserID or CustomerUserID!");
        return;
    }
    my %Data = ();
    if (ref($Self->{ConfigObject}->Get($Param{Type})) eq 'HASH') {
        %Data = %{$Self->{ConfigObject}->Get($Param{Type})};
    }
    # workflow
    if ($Self->TicketAcl(
        %Param,
        ReturnType => 'Ticket',
        ReturnSubType => $Param{Type},
        Data => \%Data,
    )) {
        my %Hash = $Self->TicketAclData();
        return \%Hash;
    }
    # /workflow
    return $Self->{ConfigObject}->Get($Param{Type});
}

=item TicketFreeTextSet()

Set ticket free text.

  $TicketObject->TicketFreeTextSet(
      Counter => 1,
      Key => 'Planet',
      Value => 'Sun',
      TicketID => 123,
      UserID => 23,
  );

=cut

sub TicketFreeTextSet {
    my $Self = shift;
    my %Param = @_;
    my $Value = defined($Param{Value}) ? $Param{Value} : '';
    my $Key = defined($Param{Key}) ? $Param{Key} : '';
    # check needed stuff
    foreach (qw(TicketID UserID Counter)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # check if update is needed
    my %Ticket = $Self->TicketGet(TicketID => $Param{TicketID});
    if ($Value eq $Ticket{"TicketFreeText$Param{Counter}"} &&
        $Key eq $Ticket{"TicketFreeKey$Param{Counter}"}) {
        return 1;
    }
    # db quote
    my $DBValue = $Self->{DBObject}->Quote($Value);
    my $DBKey = $Self->{DBObject}->Quote($Key);
    # db update
    my $SQL = "UPDATE ticket SET freekey$Param{Counter} = '$DBKey', " .
    " freetext$Param{Counter} = '$DBValue', " .
    " change_time = current_timestamp, change_by = $Param{UserID} " .
    " WHERE id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # history insert
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            QueueID => $Ticket{QueueID},
            HistoryType => 'TicketFreeTextUpdate',
            Name => "\%\%FreeKey$Param{Counter}\%\%$Key\%\%FreeText$Param{Counter}\%\%$Value",
            CreateUserID => $Param{UserID},
        );
        # clear ticket cache
        $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketFreeTextSet',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item TicketFreeTimeSet()

Set ticket free text.

  $TicketObject->TicketFreeTimeSet(
      Counter => 1,
      Prefix => '',
      Year => 1900,
      Month => 12,
      Day => 24,
      Hour => 22,
      Minute => 01,
      TicketID => 123,
      UserID => 23,
  );

=cut

sub TicketFreeTimeSet {
    my $Self = shift;
    my %Param = @_;
    my $Prefix = $Param{'Prefix'} || 'TicketFreeTime';
    # check needed stuff
    foreach (qw(TicketID UserID Counter)) {
      if (!defined($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    foreach (qw(Year Month Day Hour Minute)) {
      if (!defined($Param{$Prefix.$Param{Counter}.$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $Prefix".$Param{Counter}."$_!");
        return;
      }
    }
    my $TimeStamp = sprintf("%04d-%02d-%02d %02d:%02d:00",
        $Param{$Prefix.$Param{Counter}.'Year'},
        $Param{$Prefix.$Param{Counter}.'Month'},
        $Param{$Prefix.$Param{Counter}.'Day'},
        $Param{$Prefix.$Param{Counter}.'Hour'},
        $Param{$Prefix.$Param{Counter}.'Minute'},
    );
    # check if update is needed
    my %Ticket = $Self->TicketGet(TicketID => $Param{TicketID});
    if ($TimeStamp eq $Ticket{"TicketFreeTime$Param{Counter}"}) {
        return 1;
    }
    # db update
    my $SQL = "UPDATE ticket SET freetime$Param{Counter} = '$TimeStamp', " .
    " change_time = current_timestamp, change_by = $Param{UserID} " .
    " WHERE id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # history insert
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            QueueID => $Ticket{QueueID},
            HistoryType => 'TicketFreeTextUpdate',
            Name => "\%\%FreeTime$Param{Counter}\%\%$TimeStamp",
            CreateUserID => $Param{UserID},
        );
        # clear ticket cache
        $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketFreeTimeSet',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
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
    # check needed stuff
    foreach (qw(Type TicketID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my $AccessOk = 0;
    # run all TicketPermission modules
    if (ref($Self->{ConfigObject}->Get('Ticket::Permission')) eq 'HASH') {
        my %Modules = %{$Self->{ConfigObject}->Get('Ticket::Permission')};
        foreach my $Module (sort keys %Modules) {
            # log try of load module
            if ($Self->{Debug} > 1) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "Try to load module: $Modules{$Module}->{Module}!",
                );
            }
            # load module
            if ($Self->{MainObject}->Require($Modules{$Module}->{Module})) {
                # create object
                my $ModuleObject = $Modules{$Module}->{Module}->new(
                    ConfigObject => $Self->{ConfigObject},
                    LogObject => $Self->{LogObject},
                    DBObject => $Self->{DBObject},
                    TicketObject => $Self,
                    QueueObject => $Self->{QueueObject},
                    UserObject => $Self->{UserObject},
                    GroupObject => $Self->{GroupObject},
                    Debug => $Self->{Debug},
                );
                # execute Run()
                if ($ModuleObject->Run(%Param)) {
                    if ($Self->{Debug} > 0) {
                      $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message => "Got '$Param{Type}' true for TicketID '$Param{TicketID}' ".
                            "through $Modules{$Module}->{Module}!",
                      );
                    }
                    # set access ok
                    $AccessOk = 1;
                    # check granted option (should I say ok)
                    if ($Modules{$Module}->{Granted}) {
                        if ($Self->{Debug} > 0) {
                          $Self->{LogObject}->Log(
                            Priority => 'debug',
                            Message => "Granted access '$Param{Type}' true for TicketID '$Param{TicketID}' ".
                                "through $Modules{$Module}->{Module} (no more checks)!",
                          );
                        }
                        # access ok
                        return 1;
                    }
                }
                else {
                    # return because true is required
                    if ($Modules{$Module}->{Required}) {
                        $Self->{LogObject}->Log(
                            Priority => 'notice',
                            Message => "Permission denied because module ".
                             "($Modules{$Module}->{Module}) is required ".
                             "(UserID: $Param{UserID} '$Param{Type}' on ".
                             "TicketID: $Param{TicketID})!",
                        );
                        return;
                    }
                }
            }
        }
    }
    # grant access to the ticket
    if ($AccessOk) {
        return 1;
    }
    # don't grant access to the ticket
    else {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Permission denied (UserID: $Param{UserID} '$Param{Type}' on TicketID: $Param{TicketID})!",
        );
        return;
    }
}
# --
sub CustomerPermission {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Type TicketID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # run all CustomerTicketPermission modules
    my $AccessOk = 0;
    if (ref($Self->{ConfigObject}->Get('CustomerTicket::Permission')) eq 'HASH') {
        my %Modules = %{$Self->{ConfigObject}->Get('CustomerTicket::Permission')};
        foreach my $Module (sort keys %Modules) {
            # log try of load module
            if ($Self->{Debug} > 1) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "Try to load module: $Modules{$Module}->{Module}!",
                );
            }
            # load module
            if ($Self->{MainObject}->Require($Modules{$Module}->{Module})) {
                # create object
                my $ModuleObject = $Modules{$Module}->{Module}->new(
                    ConfigObject => $Self->{ConfigObject},
                    LogObject => $Self->{LogObject},
                    DBObject => $Self->{DBObject},
                    TicketObject => $Self,
                    QueueObject => $Self->{QueueObject},
                    CustomerUserObject => $Self->{CustomerUserObject},
                    CustomerGroupObject => $Self->{CustomerGroupObject},
                    Debug => $Self->{Debug},
                );
                # execute Run()
                if ($ModuleObject->Run(%Param)) {
                    if ($Self->{Debug} > 0) {
                      $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message => "Got '$Param{Type}' true for TicketID '$Param{TicketID}' ".
                            "through $Modules{$Module}->{Module}!",
                      );
                    }
                    # set access ok
                    $AccessOk = 1;
                    # check granted option (should I say ok)
                    if ($Modules{$Module}->{Granted}) {
                        if ($Self->{Debug} > 0) {
                          $Self->{LogObject}->Log(
                            Priority => 'debug',
                            Message => "Granted access '$Param{Type}' true for TicketID '$Param{TicketID}' ".
                                "through $Modules{$Module}->{Module} (no more checks)!",
                          );
                        }
                        # access ok
                        return 1;
                    }
                }
                else {
                    # return because true is required
                    if ($Modules{$Module}->{Required}) {
                        $Self->{LogObject}->Log(
                            Priority => 'notice',
                            Message => "Permission denied because module ".
                             "($Modules{$Module}->{Module}) is required ".
                             "(UserID: $Param{UserID} '$Param{Type}' on ".
                             "TicketID: $Param{TicketID})!",
                        );
                        return;
                    }
                }
            }
        }
    }
    # grant access to the ticket
    if ($AccessOk) {
        return 1;
    }
    # don't grant access to the ticket
    else {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Permission denied (UserID: $Param{UserID} '$Param{Type}' on TicketID: $Param{TicketID})!",
        );
        return;
    }
}

=item GetLockedTicketIDs()

Get locked ticket ids for an agent.

  my @TicketIDs = $TicketObject->GetLockedTicketIDs(UserID => 23);

=cut

sub GetLockedTicketIDs {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{UserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserID!");
        return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    my @ViewableTickets;
    my @ViewableLocks = @{$Self->{ConfigObject}->Get('Ticket::ViewableLocks')};
    my $SQL = "SELECT ti.id " .
      " FROM " .
      " ticket ti, ticket_lock_type slt, queue sq" .
      " WHERE " .
      " ti.user_id = $Param{UserID} " .
      " AND ".
      " slt.id = ti.ticket_lock_id " .
      " AND ".
      " sq.id = ti.queue_id".
      " AND ".
      " slt.name not in ( ${\(join ', ', @ViewableLocks)} ) ORDER BY ";
    # sort by
    if (!$Param{SortBy} || $Param{SortBy} =~ /^CreateTime$/i) {
        $SQL .= "ti.create_time";
    }
    elsif ($Param{SortBy} =~ /^Queue$/i) {
        $SQL .= " sq.name";
    }
    elsif ($Param{SortBy} =~ /^CustomerID$/i) {
        $SQL .= " ti.customer_id";
    }
    elsif ($Param{SortBy} =~ /^Priority$/i) {
        $SQL .= " ti.ticket_priority_id";
    }
    else {
        $SQL .= "ti.create_time";
    }
    # order
    if ($Param{OrderBy} && $Param{OrderBy} eq 'Down') {
        $SQL .= " DESC";
    }
    else {
        $SQL .= " ASC";
    }

    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        push (@ViewableTickets, $RowTmp[0]);
    }
    return @ViewableTickets;
}

=item GetSubscribedUserIDsByQueueID()

returns a array of user ids which selected the given queue id as
custom queue.

    my @UserIDs = $TicketObject->GetSubscribedUserIDsByQueueID(
        QueueID => 1234,
    );

=cut

sub GetSubscribedUserIDsByQueueID {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{QueueID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need QueueID!");
        return;
    }
    # get group of queue
    my %Queue = $Self->{QueueObject}->QueueGet(ID => $Param{QueueID});
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # fetch all queues
    my @UserIDs = ();
    $Self->{DBObject}->Prepare(
        SQL => "SELECT user_id FROM personal_queues ".
            " WHERE ".
            " queue_id = $Param{QueueID} ",
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push (@UserIDs, $Row[0]);
    }
    # check if user is valid and check permissions
    my @CleanUserIDs = ();
    foreach (@UserIDs) {
        my %User = $Self->{UserObject}->GetUserData(UserID => $_, Valid => 1);
        if (%User) {
            # just send emails to permitted agents
            my %GroupMember = $Self->{GroupObject}->GroupMemberList(
                UserID => $_,
                Type => 'ro',
                Result => 'HASH',
            );
            if ($GroupMember{$Queue{GroupID}}) {
                push (@CleanUserIDs, $_);
            }
        }
    }
    return @CleanUserIDs;
}

=item TicketPendingTimeSet()

set ticket pending time

  $TicketObject->TicketPendingTimeSet(
      Year => 2003,
      Month => 08,
      Day => 14,
      Hour => 22,
      Minute => 05,
      TicketID => 123,
      UserID => 23,
  );

=cut

sub TicketPendingTimeSet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Year Month Day Hour Minute TicketID UserID)) {
      if (!defined($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # get system time from string
    my $Time = $Self->{TimeObject}->TimeStamp2SystemTime(
        String => "$Param{Year}-$Param{Month}-$Param{Day} $Param{Hour}:$Param{Minute}:00",
    );
    # return if no convert is possible
    if (!$Time) {
        return;
    }

    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db update
    my $SQL = "UPDATE ticket SET until_time = $Time, " .
    " change_time = current_timestamp, change_by = $Param{UserID} " .
    " WHERE id = $Param{TicketID} ";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # history insert
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            HistoryType => 'SetPendingTime',
            Name => '%%'.sprintf("%02d", $Param{Year}).
              '-'.sprintf("%02d", $Param{Month}).'-'.sprintf("%02d", $Param{Day}).' '.
              sprintf("%02d", $Param{Hour}).':'.sprintf("%02d", $Param{Minute}).'',
            CreateUserID => $Param{UserID},
        );
        # clear ticket cache
        $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketPendingTimeSet',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item TicketSearch()

To find tickets in your system.

  my @TicketIDs = $TicketObject->TicketSearch(
      # result (required)
      Result => 'ARRAY' || 'HASH',
      # result limit
      Limit => 100,

      # ticket properties (optional)
      TicketNumber => '%123546%',
      Title => '%SomeText%',
      Queues => ['system queue', 'other queue'],
      QueueIDs => [1, 42, 512],
      States => ['new', 'open'],
      StateIDs => [3, 4],
      StateType => 'Open', # Open|Closed tickets or other types
      Priorities => ['1 very low', '2 low', '3 normal'],
      PriorityIDs => [1, 2, 3],
      Locks => ['unlock'],
      UserIDs => [1, 12, 455, 32]
      Owner => '123',
      # CustomerID as STRING or more as ARRAYREF
      CustomerID => '123',
      CustomerID => ['123', 'ABC'],
      # CustomerUserLogin as STRING
      CustomerUserLogin => 'uid123',

      # create ticket properties (optional)
      CreatedUserIDs => [1, 12, 455, 32]
      CreatedPriorities => ['1 very low', '2 low', '3 normal'],
      CreatedPriorityIDs => [1, 2, 3],
      CreatedStates => ['new', 'open'],
      CreatedStateIDs => [3, 4],
      CreatedQueues => ['system queue', 'other queue'],
      CreatedQueueIDs => [1, 42, 512],

      # 1..8 (optional)
      TicketFreeKey1 => 'Product',
      TicketFreeText1 => 'adasd',
      # or with multi options as array ref or string possible
      TicketFreeKey2 => ['Product', 'Product2'],
      TicketFreeText2 => ['Browser', 'Sound', 'Mouse'],

      # 1..2 (optional)
      # tickets with free time after ... (optional)
      TicketFreeTime1NewerDate => '2004-01-09 00:00:01',
      # tickets with free time before then .... (optional)
      TicketFreeTime1OlderDate => '2004-01-19 23:59:59',

      # article stuff (optional)
      From => '%spam@example.com%',
      To => '%support@example.com%',
      Cc => '%client@example.com%',
      Subject => '%VIRUS 32%',
      Body => '%VIRUS 32%',
      # content search (AND or OR) (optional)
      ContentSearch => 'AND',

      # tickets after 60 minutes (optional)
      TicketCreateTimeOlderMinutes => 60,
      # tickets before 120 minutes (optional)
      TicketCreateTimeNewerMinutes => 120,

      # tickets with create time after ... (optional)
      TicketCreateTimeNewerDate => '2004-01-09 00:00:01',
      # tickets with create time before then .... (optional)
      TicketCreateTimeOlderDate => '2004-01-19 23:59:59',

      # OrderBy and SortBy (optional)
      OrderBy => 'Down',       # Down|Up
      SortBy => 'Age',         # Owner|CustomerID|State|Ticket|Queue|Priority|Age|
                               # TicketFreeTime1-2|TicketFreeKey1-8|TicketFreeText1-8

      # user search (UserID or CustomerUserID is required)
      UserID => 123,
      Permission => 'ro' || 'rw',

      # customer search (UserID or CustomerUserID is required)
      CustomerUserID => 123,
      Permission => 'ro' || 'rw',
  );

=cut

sub TicketSearch {
    my $Self = shift;
    my %Param = @_;
    my $Result = $Param{Result} || 'HASH';
    my $OrderBy = $Param{OrderBy} || 'Down';
    my $SortBy = $Param{SortBy} || 'Age';
    my $Limit = $Param{Limit} || 10000;
    my $ContentSearch = $Param{ContentSearch} || 'AND';
    my %SortOptions = (
        Owner => 'st.user_id',
        CustomerID => 'st.customer_id',
        State => 'st.ticket_state_id',
        Ticket => 'st.tn',
        Title => 'st.title',
        Queue => 'sq.name',
        Priority => 'st.ticket_priority_id',
        Age => 'st.create_time_unix',
        TicketFreeTime1 => 'st.freetime1',
        TicketFreeTime2 => 'st.freetime2',
        TicketFreeKey1 => 'st.freekey1',
        TicketFreeText1 => 'st.freetext1',
        TicketFreeKey2 => 'st.freekey2',
        TicketFreeText2 => 'st.freetext2',
        TicketFreeKey3 => 'st.freekey3',
        TicketFreeText3 => 'st.freetext3',
        TicketFreeKey4 => 'st.freekey4',
        TicketFreeText4 => 'st.freetext4',
        TicketFreeKey5 => 'st.freekey5',
        TicketFreeText5 => 'st.freetext5',
        TicketFreeKey6 => 'st.freekey6',
        TicketFreeText6 => 'st.freetext6',
        TicketFreeKey7 => 'st.freekey7',
        TicketFreeText7 => 'st.freetext7',
        TicketFreeKey8 => 'st.freekey8',
        TicketFreeText8 => 'st.freetext8',
    );
    # check options
    if (!$SortOptions{$SortBy}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need valid SortBy ($SortBy)!");
        return;
    }
    if ($OrderBy ne 'Down' && $OrderBy ne 'Up') {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need valid OrderBy ($OrderBy)!");
        return;
    }
    # sql
    my $SQLExt = '';
    my $SQL = "SELECT DISTINCT st.id, st.tn, $SortOptions{$SortBy} FROM ".
    " ticket st, queue sq ";
    # use also article table if required
    foreach (qw(From To Cc Subject Body)) {
        if ($Param{$_}) {
            $SQL .= ", article at ";
            $SQLExt .= " AND st.id = at.ticket_id";
            last;
        }
    }
    # use also history table if required
    foreach (keys %Param) {
        if ($_ =~ /^Created/) {
            $SQL .= ", ticket_history th ";
            $SQLExt .= " AND st.id = th.ticket_id";
            last;
        }
    }
    $SQLExt = " WHERE sq.id = st.queue_id".$SQLExt;

    # current ticket states
    if ($Param{States}) {
        foreach (@{$Param{States}}) {
            my %State = $Self->{StateObject}->StateGet(Name => $_, Cache => 1);
            if ($State{ID}) {
                push (@{$Param{StateIDs}}, $State{ID});
            }
            else {
                return;
            }
        }
    }
    if ($Param{StateIDs}) {
        $SQLExt .= " AND st.ticket_state_id IN (${\(join ', ' , @{$Param{StateIDs}})})";
    }
    # created ticket states
    if ($Param{CreatedStates}) {
        foreach (@{$Param{CreatedStates}}) {
            my %State = $Self->{StateObject}->StateGet(Name => $_, Cache => 1);
            if ($State{ID}) {
                push (@{$Param{StateIDs}}, $State{ID});
            }
            else {
                return;
            }
        }
    }
    if ($Param{CreatedStateIDs}) {
        my $ID = $Self->HistoryTypeLookup(Type => 'NewTicket');
        if ($ID) {
            $SQLExt .= " AND th.state_id IN (${\(join ', ' , @{$Param{CreatedStateIDs}})})";
            $SQLExt .= " AND th.history_type_id = $ID ";
        }
    }
    # current ticket state type
    if ($Param{StateType} && $Param{StateType} eq 'Open') {
        my @ViewableStateIDs = $Self->{StateObject}->StateGetStatesByType(
            Type => 'Viewable',
            Result => 'ID',
        );
        $SQLExt .= " AND ";
        $SQLExt .= " st.ticket_state_id IN ( ${\(join ', ', @ViewableStateIDs)} ) ";
    }
    elsif ($Param{StateType} && $Param{StateType} eq 'Closed') {
        my @ViewableStateIDs = $Self->{StateObject}->StateGetStatesByType(
            Type => 'Viewable',
            Result => 'ID',
        );
        $SQLExt .= " AND ";
        $SQLExt .= " st.ticket_state_id NOT IN ( ${\(join ', ', @ViewableStateIDs)} ) ";
    }
    elsif ($Param{StateType}) {
        my @StateIDs = $Self->{StateObject}->StateGetStatesByType(
            Type => $Param{StateType},
            Result => 'ID',
        );
        $SQLExt .= " AND ";
        $SQLExt .= " st.ticket_state_id IN ( ${\(join ', ', @StateIDs)} ) ";
    }
    # current ticket locks
    if ($Param{Locks}) {
        foreach (@{$Param{Locks}}) {
            if ($Self->{LockObject}->LockLookup(Type => $_)) {
                push (@{$Param{LockIDs}}, $Self->{LockObject}->LockLookup(Type => $_));
            }
            else {
                return;
            }
        }
    }
    # add lock ids
    if ($Param{LockIDs}) {
        $SQLExt .= " AND st.ticket_lock_id IN (${\(join ', ' , @{$Param{LockIDs}})})";
    }
    # current owners user ids
    if ($Param{UserIDs}) {
        $SQLExt .= " AND st.user_id IN (${\(join ', ' , @{$Param{UserIDs}})})";
    }
    # created owner user ids
    if ($Param{CreatedUserIDs}) {
        my $ID = $Self->HistoryTypeLookup(Type => 'NewTicket');
        if ($ID) {
            $SQLExt .= " AND th.create_by IN (${\(join ', ' , @{$Param{CreatedUserIDs}})})";
            $SQLExt .= " AND th.history_type_id = $ID ";
        }
    }
    # current ticket queues
    if ($Param{Queues}) {
        foreach (@{$Param{Queues}}) {
            if ($Self->{QueueObject}->QueueLookup(Queue => $_)) {
                push (@{$Param{QueueIDs}}, $Self->{QueueObject}->QueueLookup(Queue => $_));
            }
            else {
                return;
            }
        }
    }
    if ($Param{QueueIDs}) {
        $SQLExt .= " AND st.queue_id IN (${\(join ', ' , @{$Param{QueueIDs}})})";
    }
    # created in ticket queues
    if ($Param{CreatedQueues}) {
        foreach (@{$Param{CreatedQueues}}) {
            if ($Self->{QueueObject}->QueueLookup(Queue => $_)) {
                push (@{$Param{CreatedQueueIDs}}, $Self->{QueueObject}->QueueLookup(Queue => $_));
            }
            else {
                return;
            }
        }
    }
    if ($Param{CreatedQueueIDs}) {
        my $ID = $Self->HistoryTypeLookup(Type => 'NewTicket');
        if ($ID) {
            $SQLExt .= " AND th.queue_id IN (${\(join ', ' , @{$Param{CreatedQueueIDs}})})";
            $SQLExt .= " AND th.history_type_id = $ID ";
        }
    }
    # user groups
    my @GroupIDs = ();
    if ($Param{UserID}) {
        # get users groups
        @GroupIDs = $Self->{GroupObject}->GroupMemberList(
            UserID => $Param{UserID},
            Type => $Param{Permission} || 'ro',
            Result => 'ID',
            Cached => 1,
        );
    }
    # customer groups
    if ($Param{CustomerUserID}) {
        @GroupIDs = $Self->{CustomerGroupObject}->GroupMemberList(
            UserID => $Param{CustomerUserID},
            Type => $Param{Permission} || 'ro',
            Result => 'ID',
            Cached => 1,
        );
        # get secondary customer ids
        my @CustomerIDs = $Self->{CustomerUserObject}->CustomerIDs(User => $Param{CustomerUserID});
        # add own customer id
        my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $Param{CustomerUserID});
        if ($CustomerData{UserCustomerID}) {
            push (@CustomerIDs, $CustomerData{UserCustomerID});
        }
        $SQLExt .= " AND (st.customer_id IN ('${\(join '\', \'', @CustomerIDs)}') ".
          " OR ".
          " st.customer_user_id = '$Param{CustomerUserID}') ";
    }
    if ($Param{UserID} && $Param{UserID} == 1) {
#        $Self->{LogObject}->Log(Priority => 'info', Message => "It's a admin search, no groups are used!");
    }
    elsif (@GroupIDs) {
        $SQLExt .= " AND sq.group_id IN (${\(join ', ' , @GroupIDs)}) ";
    }
    else {
        return;
    }
    # current ticket priorities
    if ($Param{Priorities}) {
        foreach (@{$Param{Priorities}}) {
            my $ID = $Self->PriorityLookup(Type => $_);
            if ($ID) {
                push (@{$Param{PriorityIDs}}, $ID);
            }
            else {
                return;
            }
        }
    }
    # created ticket priorities
    if ($Param{CreatedPriorities}) {
        foreach (@{$Param{CreatedPriorities}}) {
            my $ID = $Self->PriorityLookup(Type => $_);
            if ($ID) {
                push (@{$Param{CreatedPriorityIDs}}, $ID);
            }
            else {
                return;
            }
        }
    }
    if ($Param{CreatedPriorityIDs}) {
        my $ID = $Self->HistoryTypeLookup(Type => 'NewTicket');
        if ($ID) {
            $SQLExt .= " AND th.priority_id IN (${\(join ', ' , @{$Param{CreatedPriorityIDs}})})";
            $SQLExt .= " AND th.history_type_id = $ID ";
        }
    }
    # ticket number
    if ($Param{TicketNumber}) {
        my $TicketNumber = $Param{TicketNumber};
        $TicketNumber =~ s/\*/%/gi;
        $SQLExt .= " AND st.tn LIKE '".$Self->{DBObject}->Quote($TicketNumber)."'";
    }
    # other ticket stuff
    my %FieldSQLMap = (
        Title => 'st.title',
        CustomerUserLogin => 'st.customer_user_id',
    );
    foreach my $Key (keys %FieldSQLMap) {
        if ($Param{$Key}) {
            $Param{$Key} =~ s/\*/%/gi;
                $SQLExt .= " AND LOWER($FieldSQLMap{$Key}) LIKE LOWER('".$Self->{DBObject}->Quote($Param{$Key})."')";
        }
    }
    # customer id
    if ($Param{CustomerID}) {
        if (ref($Param{CustomerID}) eq 'ARRAY') {
            $SQLExt .= " AND LOWER(st.customer_id) IN (";
            my $Exists = 0;
            foreach (@{$Param{CustomerID}}) {
                if ($Exists) {
                    $SQLExt .= ", ";
                }
                else {
                    $Exists = 1;
                }
                $SQLExt .= "LOWER('".$Self->{DBObject}->Quote($_)."')";
            }
            $SQLExt .= " )";
        }
        else {
            $SQLExt .= " AND LOWER(st.customer_id) LIKE LOWER('".$Self->{DBObject}->Quote($Param{CustomerID})."')";
        }
    }
    # article stuff
    my %FieldSQLMapFullText = (
        From => 'at.a_from',
        To => 'at.a_to',
        Cc => 'at.a_cc',
        Subject => 'at.a_subject',
        Body => 'at.a_body',
    );
    my $FullTextSQL = '';
    foreach my $Key (keys %FieldSQLMapFullText) {
        if ($Param{$Key}) {
            $Param{$Key} =~ s/\*/%/gi;
            if ($FullTextSQL) {
                $FullTextSQL .= " $ContentSearch ";
            }
            $FullTextSQL .= " LOWER($FieldSQLMapFullText{$Key}) LIKE LOWER('".$Self->{DBObject}->Quote($Param{$Key})."')";
        }
    }
    if ($FullTextSQL) {
        $SQLExt .= ' AND ('.$FullTextSQL.')';
    }
    # ticket free text
    foreach (1..8) {
        if ($Param{"TicketFreeKey$_"} && ref($Param{"TicketFreeKey$_"}) eq '') {
            $Param{"TicketFreeKey$_"} =~ s/\*/%/gi;
            $SQLExt .= " AND LOWER(st.freekey$_) LIKE LOWER('".$Self->{DBObject}->Quote($Param{"TicketFreeKey$_"})."')";
        }
        elsif ($Param{"TicketFreeKey$_"} && ref($Param{"TicketFreeKey$_"}) eq 'ARRAY') {
            my $SQLExtSub = ' AND (';
            my $Counter = 0;
            foreach my $Key (@{$Param{"TicketFreeKey$_"}}) {
                if (defined($Key ) && $Key ne '') {
                    $Key =~ s/\*/%/gi;
                    $SQLExtSub .= ' OR ' if ($Counter);
                    $SQLExtSub .= " LOWER(st.freekey$_) LIKE LOWER('".$Self->{DBObject}->Quote($Key)."')";
                    $Counter++;
                }
            }
            $SQLExtSub .= ')';
            if ($Counter) {
                $SQLExt .= $SQLExtSub;
            }
        }
    }
    foreach (1..8) {
        if ($Param{"TicketFreeText$_"} && ref($Param{"TicketFreeText$_"}) eq '') {
            $Param{"TicketFreeText$_"} =~ s/\*/%/gi;
            $SQLExt .= " AND LOWER(st.freetext$_) LIKE LOWER('".$Self->{DBObject}->Quote($Param{"TicketFreeText$_"})."')";
        }
        elsif ($Param{"TicketFreeText$_"} && ref($Param{"TicketFreeText$_"}) eq 'ARRAY') {
            my $SQLExtSub = ' AND (';
            my $Counter = 0;
            foreach my $Text (@{$Param{"TicketFreeText$_"}}) {
                if (defined($Text) && $Text ne '') {
                    $Text =~ s/\*/%/gi;
                    $SQLExtSub .= ' OR ' if ($Counter);
                    $SQLExtSub .= " LOWER(st.freetext$_) LIKE LOWER('".$Self->{DBObject}->Quote($Text)."')";
                    $Counter++;
                }
            }
            $SQLExtSub .= ')';
            if ($Counter) {
                $SQLExt .= $SQLExtSub;
            }
        }
    }
    foreach (1..2) {
        # get tickets older then xxxx-xx-xx xx:xx date
        if ($Param{'TicketFreeTime'.$_.'OlderDate'}) {
            # check time format
            if ($Param{'TicketFreeTime'.$_.'OlderDate'} !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "No valid time format '".$Param{'TicketFreeTime'.$_.'OlderDate'}."'!",
                );
                return;
            }
            else {
                $SQLExt .= " AND st.freetime$_ <= '".$Self->{DBObject}->Quote($Param{'TicketFreeTime'.$_.'OlderDate'})."'";
            }
        }
        # get tickets newer then xxxx-xx-xx xx:xx date
        if ($Param{'TicketFreeTime'.$_.'NewerDate'}) {
            if ($Param{'TicketFreeTime'.$_.'NewerDate'} !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "No valid time format '".$Param{'TicketFreeTime'.$_.'NewerDate'}."'!",
                );
                return;
            }
            else {
                $SQLExt .= " AND st.freetime$_ >= '".$Self->{DBObject}->Quote($Param{'TicketFreeTime'.$_.'NewerDate'})."'";
            }
        }
    }
    # get tickets older then x minutes
    if ($Param{TicketCreateTimeOlderMinutes}) {
        my $Time = $Self->{TimeObject}->SystemTime()-($Param{TicketCreateTimeOlderMinutes}*60);
        $SQLExt .= " AND st.create_time_unix <= ".$Self->{DBObject}->Quote($Time);
    }
    # get tickets newer then x minutes
    if ($Param{TicketCreateTimeNewerMinutes}) {
        my $Time = $Self->{TimeObject}->SystemTime()-($Param{TicketCreateTimeNewerMinutes}*60);
        $SQLExt .= " AND st.create_time_unix >= ".$Self->{DBObject}->Quote($Time);
    }
    # get tickets older then xxxx-xx-xx xx:xx date
    if ($Param{TicketCreateTimeOlderDate}) {
        # check time format
        if ($Param{TicketCreateTimeOlderDate} !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "No valid time format '$Param{TicketCreateTimeOlderDate}'!",
            );
            return;
        }
        else {
            $SQLExt .= " AND st.create_time <= '".$Self->{DBObject}->Quote($Param{TicketCreateTimeOlderDate})."'";
        }
    }
    # get tickets newer then xxxx-xx-xx xx:xx date
    if ($Param{TicketCreateTimeNewerDate}) {
        if ($Param{TicketCreateTimeNewerDate} !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "No valid time format '$Param{TicketCreateTimeNewerDate}'!",
            );
            return;
        }
        else {
            $SQLExt .= " AND st.create_time >= '".$Self->{DBObject}->Quote($Param{TicketCreateTimeNewerDate})."'";
        }
    }
    # database query
    $SQLExt .= " ORDER BY $SortOptions{$SortBy}";
    if ($OrderBy eq 'Up') {
        $SQLExt .= ' ASC';
    }
    else {
        $SQLExt .= ' DESC';
    }
    my %Tickets = ();
    my @TicketIDs = ();
    $Self->{DBObject}->Prepare(SQL => $SQL.$SQLExt, Limit => $Limit);
#print STDERR "SQL: $SQL$SQLExt\n";
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Tickets{$Row[0]} = $Row[1];
        push (@TicketIDs, $Row[0]);
    }
    if ($Result eq 'HASH') {
        return %Tickets;
    }
    else {
        return @TicketIDs;
    }
}

=item LockIsTicketLocked()

check if a ticket is locked or not

  if ($TicketObject->LockIsTicketLocked(TicketID => 123)) {
      print "Ticket not locked!\n";
  }
  else {
      print "Ticket is not locked!\n";
  }

=cut

sub LockIsTicketLocked {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{TicketID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need TicketID!");
      return;
    }
    my %TicketData = $Self->TicketGet(%Param);
    # check lock state
    if ($TicketData{Lock} =~ /^lock$/i) {
        return 1;
    }
    else {
        return;
    }
}

=item LockSet()

to set a ticket lock or unlock

  $TicketObject->LockSet(
      Lock => 'lock',
      TicketID => 123,
      UserID => 123,
  );

=cut

sub LockSet {
    my $Self = shift;
    my %Param = @_;
    # lookup!
    if ((!$Param{LockID}) && ($Param{Lock})) {
        $Param{LockID} = $Self->{LockObject}->LockLookup(Type => $Param{Lock});
    }
    if (($Param{LockID}) && (!$Param{Lock})) {
        $Param{Lock} = $Self->{LockObject}->LockLookup(ID => $Param{LockID});
    }
    # check needed stuff
    foreach (qw(TicketID UserID LockID Lock)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    if (!$Param{Lock} && !$Param{LockID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need LockID or Lock!");
        return;
    }
    # check if update is needed
    if (($Self->LockIsTicketLocked(TicketID => $Param{TicketID}) && $Param{Lock} eq 'lock') ||
        (!$Self->LockIsTicketLocked(TicketID => $Param{TicketID}) && $Param{Lock} eq 'unlock')) {
        # update not needed
        return 1;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db update
    my $SQL = "UPDATE ticket SET ticket_lock_id = $Param{LockID}, " .
        " change_time = current_timestamp, change_by = $Param{UserID} " .
        " WHERE id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # clear ticket cache
        $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
        # update ticket view index
        $Self->TicketAcceleratorUpdate(TicketID => $Param{TicketID});
        # add history
        my $HistoryType = '';
        if ($Param{Lock} =~ /^unlock$/i) {
            $HistoryType = 'Unlock';
        }
        elsif ($Param{Lock} =~ /^lock$/i) {
            $HistoryType = 'Lock';
        }
        else {
            $HistoryType = 'Misc';
        }
        if ($HistoryType) {
            $Self->HistoryAdd(
                TicketID => $Param{TicketID},
                CreateUserID => $Param{UserID},
                HistoryType => $HistoryType,
                Name => "\%\%$Param{Lock}",
            );
        }
        # set unlock time it event is 'lock'
        if ($Param{Lock} eq 'lock') {
            $Self->TicketUnlockTimeoutUpdate(
                UnlockTimeout => $Self->{TimeObject}->SystemTime(),
                TicketID => $Param{TicketID},
                UserID => $Param{UserID},
            );
        }

        # send unlock notify
        if ($Param{Lock} =~ /^unlock$/i) {
            my %TicketData = $Self->TicketGet(%Param);
            # check if the current user is the current owner, if not send a notify
            my $To = '';
            my $Notification = defined $Param{Notification} ? $Param{Notification} : 1;
            if ($TicketData{UserID} ne $Param{UserID} && $Notification) {
              # get user data of owner
              my %Preferences = $Self->{UserObject}->GetUserData(UserID => $TicketData{UserID});
              if ($Preferences{UserSendLockTimeoutNotification}) {
                  # send
                  $Self->SendAgentNotification(
                      Type => 'LockTimeout',
                      UserData => \%Preferences,
                      CustomerMessageParams => {},
                      TicketID => $Param{TicketID},
                      UserID => $Param{UserID},
                  );
              }
            }
        }
        # should I unlock a ticket after move?
        if ($Param{Lock} =~ /^lock$/i) {
          if ($Self->{ConfigObject}->Get('Ticket::ForceNewStateAfterLock')) {
            my %States = %{$Self->{ConfigObject}->Get('Ticket::ForceNewStateAfterLock')};
            my %Ticket = $Self->TicketGet(%Param);
            foreach (keys %States) {
              if ($_ eq $Ticket{State} && $States{$_}) {
                  $Self->StateSet(%Param, State => $States{$_});
              }
            }
          }
        }
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'LockSet',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item StateSet()

to set a ticket state

  $TicketObject->SateSet(
      State => 'open',
      TicketID => 123,
      UserID => 123,
  );

  $TicketObject->SateSet(
      StateID => 3,
      TicketID => 123,
      UserID => 123,
  );

=cut

sub StateSet {
    my $Self = shift;
    my %Param = @_;
    my %State = ();
    my $ArticleID = $Param{ArticleID} || '';
    # check needed stuff
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
    # state id lookup
    if (!$Param{StateID}) {
        %State = $Self->{StateObject}->StateGet(Name => $Param{State}, Cache => 1);
    }
    # state lookup
    if (!$Param{State}) {
        %State = $Self->{StateObject}->StateGet(ID => $Param{StateID}, Cache => 1);
    }
    if (!%State) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need StateID or State!");
        return;
    }
    # check if update is needed
    my %Ticket = $Self->TicketGet(TicketID => $Param{TicketID});
    if ($State{Name} eq $Ticket{State}) {
        # update is not needed
        return 1;
    }
    # permission check
    my %StateList = $Self->StateList(%Param);
    if (!$StateList{$State{ID}}) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Permission denied on TicketID: $Param{TicketID} / StateID: $State{ID}!",
        );
        return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db update
    my $SQL = "UPDATE ticket SET ticket_state_id = $State{ID}, " .
    " change_time = current_timestamp, change_by = $Param{UserID} " .
    " WHERE id = $Param{TicketID} ";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # clear ticket cache
        $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
        # update ticket view index
        $Self->TicketAcceleratorUpdate(TicketID => $Param{TicketID});
        # add history
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            ArticleID => $ArticleID,
            QueueID => $Ticket{QueueID},
            Name => "\%\%$Ticket{State}\%\%$State{Name}\%\%",
            HistoryType => 'StateUpdate',
            CreateUserID => $Param{UserID},
        );
        # reset escalation time if ticket will be reopend
#        if ($State{TypeName} ne 'closed' && $Ticket{StateType} eq 'closed'){
#            $Self->TicketEscalationStartUpdate(
#                EscalationStartTime => $Self->{TimeObject}->SystemTime(),
#                TicketID => $Param{TicketID},
#                UserID => $Param{UserID},
#            );
#        }
        # send customer notification email
        $Self->SendCustomerNotification(
            Type => 'StateUpdate',
  	        CustomerMessageParams => \%Param,
            TicketID => $Param{TicketID},
            UserID => $Param{UserID},
        );
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'StateSet',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item StateList()

to get the state list for a ticket (depends on workflow, if configured)

  my %States = $TicketObject->StateList(
      TicketID => 123,
      UserID => 123,
  );

  my %States = $TicketObject->StateList(
      QueueID => 123,
      UserID => 123,
  );

  my %States = $TicketObject->StateList(
      TicketID => 123,
      Type => 'open',
      UserID => 123,
  );

=cut

sub StateList {
    my $Self = shift;
    my %Param = @_;
    my %States = ();
    # check needed stuff
    if (!$Param{UserID} && !$Param{CustomerUserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserID or CustomerUserID!");
        return;
    }
    # check needed stuff
    if (!$Param{QueueID} && !$Param{TicketID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need QueueID, TicketID!");
        return;
    }
    # get states by type
    if ($Param{Type}) {
        %States = $Self->{StateObject}->StateGetStatesByType(
            Type => $Param{Type},
            Result => 'HASH',
        );
    }
    # get whole states list
    else {
        %States = $Self->{StateObject}->StateList(
            UserID => $Param{UserID},
        );
    }
#delete $States{4}; # remove open!
    # workflow
    if ($Self->TicketAcl(
        %Param,
        ReturnType => 'Ticket',
        ReturnSubType => 'State',
        Data => \%States,
    )) {
        return $Self->TicketAclData();
    }
    # /workflow
    return %States;
}

=item OwnerCheck()

to get the ticket owner

  my ($OwnerID, $Owner) = $TicketObject->OwnerCheck(TicketID => 123);

=cut

sub OwnerCheck {
    my $Self = shift;
    my %Param = @_;
    my $SQL = '';
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
    if ($Param{UserID}) {
        $SQL = "SELECT user_id, user_id " .
        " FROM " .
        " ticket " .
        " WHERE " .
        " id = $Param{TicketID} " .
        " AND " .
        " user_id = $Param{UserID}";
    }
    else {
        $SQL = "SELECT st.user_id, su.$Self->{ConfigObject}->{DatabaseUserTableUser} " .
        " FROM " .
        " ticket st, $Self->{ConfigObject}->{DatabaseUserTable} su " .
        " WHERE " .
        " st.id = $Param{TicketID} " .
        " AND " .
        " st.user_id = su.$Self->{ConfigObject}->{DatabaseUserTableUserID}";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Param{SearchUserID} = $Row[0];
        $Param{SearchUser} = $Row[1];
    }
    if ($Param{SearchUserID}) {
      return $Param{SearchUserID}, $Param{SearchUser};
    }
    else {
      return;
    }
}

=item OwnerSet()

to set the ticket owner (notification to the new owner will be sent)

  $TicketObject->OwnerSet(
      TicketID => 123,
      NewUserID => 555,
      UserID => 213,
  );

=cut

sub OwnerSet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    if (!$Param{NewUserID} && !$Param{NewUser}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need NewUserID or NewUser!");
        return;
    }
    # lookup if no NewUserID is given
    if (!$Param{NewUserID}) {
      $Param{NewUserID} = $Self->{UserObject}->GetUserIdByName(User => $Param{NewUser})||return;
    }
    # lookup if no NewUser is given
    if (!$Param{NewUser}) {
      $Param{NewUser} = $Self->{UserObject}->GetUserByID(UserID => $Param{NewUserID})||return;
    }
    # check if update is needed!
    if ($Self->OwnerCheck(TicketID => $Param{TicketID}, UserID => $Param{NewUserID})) {
        # update is "not" needed!
        return 1;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db update
    my $SQL = "UPDATE ticket SET user_id = $Param{NewUserID}, " .
    " change_time = current_timestamp, change_by = $Param{UserID} " .
    " WHERE id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
      # add history
      $Self->HistoryAdd(
          TicketID => $Param{TicketID},
          CreateUserID => $Param{UserID},
          HistoryType => 'OwnerUpdate',
          Name => "\%\%$Param{NewUser}\%\%$Param{NewUserID}",
      );
      # clear ticket cache
      $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
      # send agent notify
      if ($Param{UserID} ne $Param{NewUserID} &&
           $Param{NewUserID} ne $Self->{ConfigObject}->Get('PostmasterUserID')) {
        if (!$Param{Comment}) {
            $Param{Comment} = '';
        }
        # get user data
        my %Preferences = $Self->{UserObject}->GetUserData(UserID => $Param{NewUserID});
        # send agent notification
        $Self->SendAgentNotification(
            Type => 'OwnerUpdate',
            UserData => \%Preferences,
            CustomerMessageParams => \%Param,
            TicketID => $Param{TicketID},
            UserID => $Param{UserID},
        );
      }
      # send customer notification email
      my %Preferences = $Self->{UserObject}->GetUserData(UserID => $Param{NewUserID});
      $Self->SendCustomerNotification(
          Type => 'OwnerUpdate',
          CustomerMessageParams => \%Preferences,
          TicketID => $Param{TicketID},
          UserID => $Param{UserID},
      );
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'OwnerSet',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item OwnerList()

returns the owner in the past as array with hash ref of the owner data
(name, email, ...)

  my @Owner = $TicketObject->OwnerList(
      TicketID => 123,
  );

=cut

sub OwnerList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db query
    my @User = ();
    my $LastOwner = 1;
    my $SQL = "SELECT sh.name, ht.name, sh.create_by ".
        " FROM ".
        " ticket_history sh, ticket_history_type ht ".
        " WHERE ".
        " sh.ticket_id = $Param{TicketID} ".
        " AND ".
        " ht.name IN ('OwnerUpdate', 'NewTicket')  ".
        " AND ".
        " ht.id = sh.history_type_id".
        " ORDER BY sh.id";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        if ($Row[1] eq 'NewTicket' && $Row[2] ne '1' && $LastOwner ne $Row[2]) {
            $LastOwner = $Row[2];
            push (@User, $Row[2]);
        }
        elsif ($Row[1] eq 'OwnerUpdate') {
            if ($Row[0] =~ /^New Owner is '(.+?)' \(ID=(.+?)\)/ || $Row[0] =~ /^\%\%(.+?)\%\%(.+?)$/) {
                $LastOwner = $2;
                push (@User, $2);
            }
        }
    }
    my @UserInfo = ();
    foreach (@User) {
        my %User = $Self->{UserObject}->GetUserData(UserID => $_, Cache => 1);
        push (@UserInfo, \%User);
    }
    return @UserInfo;
}

=item InvolvedAgents()

returns array with hash ref of involved agents of a ticket

  my @InvolvedAgents = $TicketObject->InvolvedAgents(
      TicketID => 123,
  );

=cut

sub InvolvedAgents {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db query
    my @User = ();
    my %UsedOwner = ();
    my $SQL = "SELECT sh.name, sh.create_by ".
        " FROM ".
        " ticket_history sh, ticket_history_type ht ".
        " WHERE ".
        " sh.ticket_id = $Param{TicketID} ".
        " AND ".
        " ht.id = sh.history_type_id".
        " ORDER BY sh.id";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        if ($Row[1] ne 1 && !$UsedOwner{$Row[1]}) {
            $UsedOwner{$Row[1]} = $Row[1];
            push (@User, $Row[1]);
        }
    }
    my @UserInfo = ();
    foreach (@User) {
        my %User = $Self->{UserObject}->GetUserData(UserID => $_, Cache => 1);
        push (@UserInfo, \%User);
    }
    return @UserInfo;
}
# --
sub PriorityLookup {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Type} && !$Param{ID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need Type or ID!");
      return;
    }
    # check if we ask the same request?
    if ($Param{Type}) {
        if (exists $Self->{"Ticket::Priority::PriorityLookup::$Param{Type}"}) {
            return $Self->{"Ticket::Priority::PriorityLookup::$Param{Type}"};
        }
    }
    else {
        if (exists $Self->{"Ticket::Priority::PriorityIDLookup::$Param{ID}"}) {
            return $Self->{"Ticket::Priority::PriorityIDLookup::$Param{ID}"};
        }
    }
    # db query
    my $SQL = '';
    if ($Param{Type}) {
        $SQL = "SELECT id FROM ticket_priority WHERE name = '".$Self->{DBObject}->Quote($Param{Type})."'";
    }
    else {
        $SQL = "SELECT name FROM ticket_priority WHERE id = ".$Self->{DBObject}->Quote($Param{ID})."";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        if ($Param{Type}) {
            $Self->{"Ticket::Priority::PriorityLookup::$Param{Type}"} = $Row[0];
        }
        else {
            $Self->{"Ticket::Priority::PriorityIDLookup::$Param{ID}"} = $Row[0];
        }
    }
    # check if data exists
    if ($Param{Type}) {
        if (!exists $Self->{"Ticket::Priority::PriorityLookup::$Param{Type}"}) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "No TypeID for $Param{Type} found!",
            );
            return;
        }
        else {
            return $Self->{"Ticket::Priority::PriorityLookup::$Param{Type}"};
        }
    }
    else {
        if (!exists $Self->{"Ticket::Priority::PriorityIDLookup::$Param{ID}"}) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "No ID for $Param{ID} found!",
            );
            return;
        }
        else {
            return $Self->{"Ticket::Priority::PriorityIDLookup::$Param{ID}"};
        }
    }
}

=item PrioritySet()

to set the ticket priority

  $TicketObject->PrioritySet(
      TicketID => 123,
      Priority => 'low',
      UserID => 213,
  );

  $TicketObject->PrioritySet(
      TicketID => 123,
      PriorityID => 2,
      UserID => 213,
  );

=cut

sub PrioritySet {
    my $Self = shift;
    my %Param = @_;
    # lookup!
    if (!$Param{PriorityID} && $Param{Priority}) {
        $Param{PriorityID} = $Self->PriorityLookup(Type => $Param{Priority});
    }
    if ($Param{PriorityID} && !$Param{Priority}) {
        $Param{Priority} = $Self->PriorityLookup(ID => $Param{PriorityID});
    }
    # check needed stuff
    foreach (qw(TicketID UserID PriorityID Priority)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my %TicketData = $Self->TicketGet(%Param);
    # check if update is needed
    if ($TicketData{Priority} eq $Param{Priority}) {
       # update not needed
       return 1;
    }
    # permission check
    my %PriorityList = $Self->PriorityList(%Param);
    if (!$PriorityList{$Param{PriorityID}}) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Permission denied on TicketID: $Param{TicketID}!",
        );
        return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db update
    my $SQL = "UPDATE ticket SET ticket_priority_id = $Param{PriorityID}, " .
        " change_time = current_timestamp, change_by = $Param{UserID} " .
        " WHERE id = $Param{TicketID} ";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # add history
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            QueueID => $TicketData{QueueID},
            CreateUserID => $Param{UserID},
            HistoryType => 'PriorityUpdate',
            Name => "\%\%$TicketData{Priority}\%\%$TicketData{PriorityID}".
              "\%\%$Param{Priority}\%\%$Param{PriorityID}",
        );
        # clear ticket cache
        $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'PrioritySet',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item PriorityList()

to get the priority list for a ticket (depends on workflow, if configured)

  my %Priorities = $TicketObject->PriorityList(
      TicketID => 123,
      UserID => 123,
  );

  my %Priorities = $TicketObject->PriorityList(
      QueueID => 123,
      UserID => 123,
  );

=cut

sub PriorityList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{UserID} && !$Param{CustomerUserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserID or CustomerUserID!");
        return;
    }
    # check needed stuff
#    if (!$Param{QueueID} && !$Param{TicketID}) {
#        $Self->{LogObject}->Log(Priority => 'error', Message => "Need QueueID or TicketID!");
#        return;
#    }
    # sql
    my %Data = $Self->{PriorityObject}->PriorityList(%Param);
#delete $Data{2};
    # workflow
    if ($Self->TicketAcl(
        %Param,
        ReturnType => 'Ticket',
        ReturnSubType => 'Priority',
        Data => \%Data,
    )) {
        return $Self->TicketAclData();
    }
    # /workflow
    return %Data;
}
# --
sub HistoryTicketStatusGet {
    my $Self = shift;
    my %Param = @_;
    my %Ticket = ();
    # check needed stuff
    foreach (qw(StopYear StopMonth StopDay StartYear StartMonth StartDay)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # format month and day params
    foreach (qw(StopMonth StopDay StartMonth StartDay)) {
        $Param{$_} = sprintf("%02d", $Param{$_});
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    my $SQL = "SELECT DISTINCT(th.ticket_id), th.create_time FROM ".
        "ticket_history th ".
        "WHERE ".
        "th.create_time <= '$Param{StopYear}-$Param{StopMonth}-$Param{StopDay} 23:59:59' ".
        "AND ".
        "th.create_time >= '$Param{StartYear}-$Param{StartMonth}-$Param{StartDay} 00:00:01' ".
        "ORDER BY th.create_time DESC";
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 50000);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Ticket{$Row[0]} = 1;
    }
    foreach my $TicketID (keys %Ticket) {
        my %TicketData = $Self->HistoryTicketGet(
            TicketID => $TicketID,
            StopYear => $Param{StopYear},
            StopMonth => $Param{StopMonth},
            StopDay => $Param{StopDay},
            Force => $Param{Force} || 0,
        );
        if (%TicketData) {
            $Ticket{$TicketID} = \%TicketData;
        }
        else {
            $Ticket{$TicketID} = {};
        }
    }
    return %Ticket;
}

=item HistoryTicketGet()

returns a hash of the ticket history info at this time.

  my %HistoryData = $TicketObject->HistoryTicketGet(
      StopYear => 2003,
      StopMonth => 12,
      StopDay => 24,
      TicketID => 123,
  );

=cut

sub HistoryTicketGet {
    my $Self = shift;
    my %Param = @_;
    my %Ticket = ();
    # check needed stuff
    foreach (qw(TicketID StopYear StopMonth StopDay)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # format month and day params
    foreach (qw(StopMonth StopDay)) {
        $Param{$_} = sprintf("%02d", $Param{$_});
    }
    # check cache
    my $Path = $Self->{ConfigObject}->Get('TempDir')."/TicketHistoryCache/$Param{StopYear}/$Param{StopMonth}";
    my $File = "TicketHistoryCache_$Param{TicketID}_$Param{StopYear}-$Param{StopMonth}-$Param{StopDay}";
    $File =~ s/ //g;
    $File = quotemeta($File);
    # write cache
    if (!$Param{Force} && -f "$Path/$File") {
        if (open (DATA, "< $Path/$File")) {
            while (<DATA>) {
                if ($_ =~ /^(.+?):(.+?)$/) {
                    $Ticket{$1} = $2;
                }
            }
            close (DATA);
#print STDERR "return cache ($Ticket{TicketID}/$Path/$File)!!!\n";
            return %Ticket;
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Can't open: $Path/$File: $!",
            );
        }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    my $SQL = "SELECT th.name, tht.name, th.create_time, th.create_by, th.ticket_id, th.article_id, th.queue_id, th.state_id, th.priority_id, th.owner_id FROM ".
        "ticket_history th, ticket_history_type tht ".
        "WHERE ".
        "th.history_type_id = tht.id ".
        "AND ".
        "th.ticket_id = $Param{TicketID} ".
        "AND ".
        "th.create_time <= '$Param{StopYear}-$Param{StopMonth}-$Param{StopDay} 23:59:59' ".
        "ORDER BY th.create_time ASC";
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 600);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        if ($Row[1] eq 'NewTicket') {
            if ($Row[0] =~ /^\%\%(.+?)\%\%(.+?)\%\%(.+?)\%\%(.+?)\%\%(.+?)/ || $Row[0] =~ /Ticket=\[(.+?)\],.+?Q\=(.+?);P\=(.+?);S\=(.+?)/) {
                $Ticket{TicketNumber} = $1;
                $Ticket{Queue} = $2;
                $Ticket{CreateQueue} = $2;
                $Ticket{Priority} = $3;
                $Ticket{CreatePriority} = $3;
                $Ticket{State} = $4;
                $Ticket{CreateState} = $4;
                $Ticket{TicketID} = $Row[4];
                $Ticket{Owner} = 'root';
                $Ticket{CreateUserID} = $Row[3];
                $Ticket{CreateTime} = $Row[2];
            }
            else {
                # compat to otrs 1.1
                # NewTicket
                $Ticket{TicketVersion} = '1.1';
                $Ticket{TicketID} = $Row[4];
                $Ticket{CreateUserID} = $Row[3];
                $Ticket{CreateTime} = $Row[2];
            }
            $Ticket{CreateOwnerID} = $Row[9] || '';
            $Ticket{CreatePriorityID} = $Row[8] || '';
            $Ticket{CreateStateID} = $Row[7] || '';
            $Ticket{CreateQueueID} = $Row[6] || '';
        }
        # compat to otrs 1.1
        elsif ($Row[1] eq 'PhoneCallCustomer') {
            $Ticket{TicketVersion} = '1.1';
            $Ticket{TicketID} = $Row[4];
            $Ticket{CreateUserID} = $Row[3];
            $Ticket{CreateTime} = $Row[2];
        }
        elsif ($Row[1] eq 'Move') {
            if ($Row[0] =~ /^\%\%(.+?)\%\%(.+?)\%\%(.+?)\%\%(.+?)/ || $Row[0] =~ /^Ticket moved to Queue '(.+?)'/) {
                $Ticket{Queue} = $1;
            }
        }
        elsif ($Row[1] eq 'StateUpdate' || $Row[1] eq 'Close successful' || $Row[1] eq 'Close unsuccessful' || $Row[1] eq 'Open' || $Row[1] eq 'Misc') {
            if ($Row[0] =~ /^\%\%(.+?)\%\%(.+?)$/ || $Row[0] =~ /^Old: '(.+?)' New: '(.+?)'/ || $Row[0] =~ /^Changed Ticket State from '(.+?)' to '(.+?)'/) {
                $Ticket{State} = $2;
                $Ticket{StateTime} = $Row[2];
            }
        }
        elsif ($Row[1] eq 'TicketFreeTextUpdate') {
            if ($Row[0] =~ /^\%\%(.+?)\%\%(.+?)\%\%(.+?)\%\%(.+?)$/) {
                $Ticket{$1} = $2;
                $Ticket{$3} = $4;
            }
        }
        elsif ($Row[1] eq 'PriorityUpdate') {
            if ($Row[0] =~ /^\%\%(.+?)\%\%(.+?)\%\%(.+?)\%\%(.+?)/) {
                $Ticket{Priority} = $3;
            }
        }
        elsif ($Row[1] eq 'OwnerUpdate') {
            if ($Row[0] =~ /^\%\%(.+?)\%\%(.+?)/ || $Row[0] =~ /^New Owner is '(.+?)'/) {
                $Ticket{Owner} = $1;
            }
        }
#        elsif ($Row[1] eq '') {
#
#        }
        # get default options
        $Ticket{OwnerID} = $Row[9] || '';
        $Ticket{PriorityID} = $Row[8] || '';
        $Ticket{StateID} = $Row[7] || '';
        $Ticket{QueueID} = $Row[6] || '';
    }
    if (!%Ticket) {
        $Self->{LogObject}->Log(Priority => 'notice', Message => "No such TicketID in Ticket Hisorry till '$Param{StopYear}-$Param{StopMonth}-$Param{StopDay} 23:59:59' ($Param{TicketID})!");
        return;
    }
    else {
        # update old ticket info
#        if ($Ticket{TicketVersion} eq '1.1') {
            my %CurrentTicketData = $Self->TicketGet(TicketID => $Ticket{TicketID});
            foreach (qw(State Priority Queue TicketNumber)) {
                if (!$Ticket{$_}) {
                    $Ticket{$_} = $CurrentTicketData{$_};
                }
                if (!$Ticket{"Create$_"}) {
                    $Ticket{"Create$_"} = $CurrentTicketData{$_};
                }
            }
            if (!$Self->{QueueObject}->QueueLookup(Queue => $Ticket{Queue})) {
                $Ticket{Queue} = $CurrentTicketData{Queue};
            }
            if (!$Self->{StateObject}->StateGet(Name => $Ticket{State}, Cache => 1)) {
                $Ticket{State} = $CurrentTicketData{State};
            }
#        }
        # check if we should cache this ticket data
        my ($Sec, $Min, $Hour, $Day, $Month, $Year, $WDay) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
        );
        # if the request is for the last month or older, cache it
        if ($Year <= $Param{StopYear} && $Month > $Param{StopMonth}) {
            # create sub directory if needed
            if (! -e $Path && !File::Path::mkpath([$Path], 0, 0775)) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Can't create directory: $Path: $!",
                );
            }
            # write cache file
            if (open (DATA, "> $Path/$File")) {
                foreach (keys %Ticket) {
                    print DATA "$_:$Ticket{$_}\n";
                }
                close (DATA);
            }
            else {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "Can't write: $Path/$File: $!",
                );
            }
        }
        # return ticket data
        return %Ticket;
    }
}

=item HistoryTypeLookup()

returns the id of the requested history type.

  my $ID = $TicketObject->HistoryTypeLookup(Type => 'Move');

=cut

sub HistoryTypeLookup {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Type}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need Type!");
      return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # check if we ask the same request?
    if (exists $Self->{"Ticket::History::HistoryTypeLookup::$Param{Type}"}) {
        return $Self->{"Ticket::History::HistoryTypeLookup::$Param{Type}"};
    }
    # db query
    my $SQL = "SELECT id FROM ticket_history_type WHERE name = '$Param{Type}'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"Ticket::History::HistoryTypeLookup::$Param{Type}"} = $Row[0];
    }
    # check if data exists
    if (!exists $Self->{"Ticket::History::HistoryTypeLookup::$Param{Type}"}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No TypeID for $Param{Type} found!");
        return;
    }
    else {
        return $Self->{"Ticket::History::HistoryTypeLookup::$Param{Type}"};
    }
}

=item HistoryAdd()

add a history entry to an ticket

  $TicketObject->HistoryAdd(
      Name => 'Some Comment',
      HistoryType => 'Move', # see system tables
      TicketID => 123,
      ArticleID => 1234, # not required!
      QueueID => 123, # not required!
      UserID => 123,
      CreateUserID => 123,
  );

=cut

sub HistoryAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Name}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Name!");
        return;
    }
    # lookup!
    if ((!$Param{HistoryTypeID}) && ($Param{HistoryType})) {
        $Param{HistoryTypeID} = $Self->HistoryTypeLookup(Type => $Param{HistoryType});
    }
    # check needed stuff
    foreach (qw(TicketID CreateUserID HistoryTypeID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Param{ArticleID}) {
        $Param{ArticleID} = 'NULL';
    }
    # get ValidID!
    if (!$Param{ValidID}) {
        $Param{ValidID} = $Self->{DBObject}->GetValidIDs();
    }
    # get QueueID
    if (!$Param{QueueID}) {
        $Param{QueueID} = $Self->TicketQueueID(TicketID => $Param{TicketID});
    }
    # get owner
    if (!$Param{OwnerID}) {
        my %Ticket = $Self->TicketGet(%Param);
        $Param{OwnerID} = $Ticket{OwnerID};
    }
    # get priority
    if (!$Param{PriorityID}) {
        my %Ticket = $Self->TicketGet(%Param);
        $Param{PriorityID} = $Ticket{PriorityID};
    }
    # get state
    if (!$Param{StateID}) {
        my %Ticket = $Self->TicketGet(%Param);
        $Param{StateID} = $Ticket{StateID};
    }
    # limit name to 200 chars
    if ($Param{Name}) {
        $Param{Name} = substr($Param{Name}, 0, 200);
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db insert
    my $SQL = "INSERT INTO ticket_history " .
    " (name, history_type_id, ticket_id, article_id, queue_id, owner_id, ".
    " priority_id, state_id, valid_id, " .
    " create_time, create_by, change_time, change_by) " .
        "VALUES " .
    "('$Param{Name}', $Param{HistoryTypeID}, $Param{TicketID}, ".
    " $Param{ArticleID}, $Param{QueueID}, $Param{OwnerID}, $Param{PriorityID}, ".
    " $Param{StateID}, $Param{ValidID}, " .
    " current_timestamp, $Param{CreateUserID}, current_timestamp, $Param{CreateUserID})";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'HistoryAdd',
            UserID => $Param{CreateUserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item HistoryGet()

get ticket history as array with hashes
(TicketID, ArticleID, Name, CreateBy, CreateTime and HistoryType)

  my @HistoryLines = $TicketObject->HistoryGet(
      TicketID => 123,
      UserID => 123,
  );

=cut

sub HistoryGet {
    my $Self = shift;
    my %Param = @_;
    my @Lines;
    # check needed stuff
    foreach (qw(TicketID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    my $SQL = "SELECT sh.name, sh.article_id, sh.create_time, sh.create_by, ".
        " ht.name ".
        " FROM ".
        " ticket_history sh, ticket_history_type ht ".
        " WHERE ".
        " sh.ticket_id = $Param{TicketID} ".
        " AND ".
        " ht.id = sh.history_type_id".
        " ORDER BY sh.create_time, sh.id";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray() ) {
          my %Data;
          $Data{TicketID} = $Param{TicketID};
          $Data{ArticleID} = $Row[1] || 0;
          $Data{Name} = $Row[0];
          $Data{CreateBy} = $Row[3];
          $Data{CreateTime} = $Row[2];
          $Data{HistoryType} = $Row[4];
          push (@Lines, \%Data);
    }
    # get user data
    foreach my $Data (@Lines) {
        my %UserInfo = $Self->{UserObject}->GetUserData(
            UserID => $Data->{CreateBy},
            Cached => 1
        );
        %{$Data} = (%{$Data}, %UserInfo);
    }
    return @Lines;
}

=item HistoryDelete()

delete a ticket history (from storage)

  $TicketObject->HistoryDelete(
      TicketID => 123,
      UserID => 123,
  );

=cut

sub HistoryDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # delete from db
    if ($Self->{DBObject}->Do(SQL => "DELETE FROM ticket_history WHERE ticket_id = $Param{TicketID}")) {
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'HistoryDelete',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item TicketAccountedTimeGet()

returns the accounted time of a ticket.

  my $AccountedTime = $TicketObject->TicketAccountedTimeGet(TicketID => 1234);

=cut

sub TicketAccountedTimeGet {
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

=item TicketAccountTime()

account time to a ticket.

  $TicketObject->TicketAccountTime(
      TicketID => 1234,
      ArticleID => 23542,
      TimeUnit => '4.5',
      UserID => 1,
  );

=cut

sub TicketAccountTime {
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
    $Param{TimeUnit} =~ s/,/\./g;
    $Param{TimeUnit} =~ s/ //g;
    $Param{TimeUnit} =~ s/^(\d{1,10}\.\d\d).+?$/$1/g;
    chomp $Param{TimeUnit};
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db update
    my $SQL = "INSERT INTO time_accounting ".
      " (ticket_id, article_id, time_unit, create_time, create_by, change_time, change_by) ".
      " VALUES ".
      " ($Param{TicketID}, $Param{ArticleID}, $Param{TimeUnit}, ".
      " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID}) ";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # add history
        my $AccountedTime = $Self->TicketAccountedTimeGet(TicketID => $Param{TicketID});
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
             ArticleID => $Param{ArticleID},
            CreateUserID => $Param{UserID},
            HistoryType => 'TimeAccounting',
            Name => "\%\%$Param{TimeUnit}\%\%$AccountedTime",
        );
        # clear ticket cache
        $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketAccountTime',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item TicketMerge()

merge two tickets

  $TicketObject->TicketMerge(
      MainTicketID => 412,
      MergeTicketID => 123,
      UserID => 123,
  );

=cut

sub TicketMerge {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(MainTicketID MergeTicketID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # change ticket id of merge ticket to main ticket
    if ($Self->{DBObject}->Do(SQL => "UPDATE article SET ticket_id = $Param{MainTicketID} WHERE ticket_id = $Param{MergeTicketID}")) {
        my %MainTicket = $Self->TicketGet(TicketID => $Param{MainTicketID});
        my %MergeTicket = $Self->TicketGet(TicketID => $Param{MergeTicketID});
        # add merge article to merge ticket
        $Self->ArticleCreate(
            TicketID => $Param{MergeTicketID},
            SenderType => 'agent',
            ArticleType => 'note-internal',
            ContentType => "text/plain; charset=ascii",
            UserID => $Param{UserID},
            HistoryType => 'AddNote',
            HistoryComment => '%%Note',
            Subject => 'Ticket Merged',
            Body => "Merged Ticket $MergeTicket{TicketNumber} to $MainTicket{TicketNumber}.",
            NoAgentNotify => 1,
        );
        # add merge history to merge ticket
        $Self->HistoryAdd(
            TicketID => $Param{MergeTicketID},
            HistoryType => 'Merged',
            Name => "Merged Ticket ($MergeTicket{TicketNumber}/$Param{MergeTicketID}) to ($MainTicket{TicketNumber}/$Param{MainTicketID})",
            CreateUserID => $Param{UserID},
        );
        # add merge history to main ticket
        $Self->HistoryAdd(
            TicketID => $Param{MainTicketID},
            HistoryType => 'Merged',
            Name => "Merged Ticket ($MergeTicket{TicketNumber}/$Param{MergeTicketID}) to ($MainTicket{TicketNumber}/$Param{MainTicketID})",
            CreateUserID => $Param{UserID},
        );
        # link tickets
        $Self->{LinkObject} = Kernel::System::LinkObject->new(%Param, %{$Self}, TicketObject => $Self);
        $Self->{LinkObject}->LoadBackend(Module => 'Ticket');
        $Self->{LinkObject}->LinkObject(
            LinkType => 'Parent',
            LinkID1 => $Param{MainTicketID},
            LinkObject1 => 'Ticket',
            LinkID2 => $Param{MergeTicketID},
            LinkObject2 => 'Ticket',
            UserID => $Param{UserID},
        );
        # set new state of merge ticket
        $Self->StateSet(
            State => 'merged',
            TicketID => $Param{MergeTicketID},
            UserID => $Param{UserID},
        );
        # unlock ticket
        $Self->{TicketObject}->LockSet(
            Lock => 'unlock',
            TicketID => $Param{MergeTicketID},
            UserID => $Param{UserID},
        );
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketMerge',
            TicketID => $Param{MergeTicketID},
            UserID => $Param{UserID},
        );
        return 1;
    }
    else {
        return;
    }
}

sub TicketAcl {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{UserID} && !$Param{CustomerUserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserID or CustomerUserID!");
        return;
    }
    # check needed stuff
    foreach (qw(ReturnSubType ReturnType Data)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # check if workflows are configured, if not, just return
    if (!$Self->{ConfigObject}->Get('TicketAcl') || ($Param{UserID} && $Param{UserID} == 1)) {
        return;
    }
    # get used data
    my %Data = ();
    if (ref($Param{Data})) {
        undef $Self->{TicketAclActionData};
        %Data = %{$Param{Data}};
    }
    my %Checks = ();
    # match also frontend options
    if ($Param{Action}) {
        undef $Self->{TicketAclActionData};
        $Checks{Frontend} = {Action => $Param{Action},};
    }
    # use ticket data if ticket id is given
    if ($Param{TicketID}) {
        my %Ticket = $Self->TicketGet(%Param);
        $Checks{Ticket} = \%Ticket;
    }
    # use user data
    if ($Param{UserID}) {
        my %User = $Self->{UserObject}->GetUserData(UserID => $Param{UserID}, Cached => 1);
        foreach my $Type (@{$Self->{ConfigObject}->Get('System::Permission')}) {
            my @Groups = $Self->{GroupObject}->GroupMemberList(
                UserID => $Param{UserID},
                Result => 'Name',
                Type => $Type,
                Cached => 1,
            );
            $User{"Group_$Type"} = \@Groups;
        }
        $Checks{User} = \%User;
    }
    # use queue data (if given)
    if ($Param{QueueID}) {
        my %Queue = $Self->{QueueObject}->QueueGet(ID => $Param{QueueID}, Cache => 1);
        $Checks{Queue} = \%Queue;
    }
    elsif ($Param{Queue}) {
        my %Queue = $Self->{QueueObject}->QueueGet(Name => $Param{Queue}, Cache => 1);
        $Checks{Queue} = \%Queue;
    }
    # check workflow config
    my %Acls = %{$Self->{ConfigObject}->Get('TicketAcl')};
    my %NewData = ();
    my $UseNewMasterParams = 0;
    foreach my $Acl (sort keys %Acls) {
        my %Step = %{$Acls{$Acl}};
        # check force match
        my $ForceMatch = 1;
        foreach (keys %{$Step{Properties}}) {
            $ForceMatch = 0;
        }
        # set match params
        my $Match = 1;
        my $Match3 = 0;
        my $UseNewParams = 0;
#        foreach my $Key (keys %Checks) {
        foreach my $Key (keys %{$Step{Properties}}) {
#print STDERR "($Acl)Key: $Key\n";
          foreach my $Data (keys %{$Step{Properties}->{$Key}}) {
            my $Match2 = 0;
            foreach (@{$Step{Properties}->{$Key}->{$Data}}) {
                if (ref($Checks{$Key}->{$Data}) eq 'ARRAY') {
                    foreach my $Array (@{$Checks{$Key}->{$Data}}) {
                        if ($_ eq $Array) {
                            $Match2 = 1;
#print STDERR "Workflow '$Acl/$Key/$Data' MatchedARRAY ($_ eq $Array)\n";
                            # debug log
                            if ($Self->{Debug} > 4) {
                                $Self->{LogObject}->Log(
                                    Priority => 'debug',
                                    Message => "Workflow '$Acl/$Key/$Data' MatchedARRAY ($_ eq $Array)",
                                );
                            }
                        }
                    }
                }
                elsif ($Checks{$Key}->{$Data}) {
                    if ($_ eq $Checks{$Key}->{$Data}) {
                        $Match2 = 1;
                        # debug
                        if ($Self->{Debug} > 4) {
                            $Self->{LogObject}->Log(
                                    Priority => 'debug',
                                    Message => "Workflow '$Acl/$Key/$Data' Matched ($_ eq $Checks{$Key}->{$Data})",
                            );
                        }
                    }
                }
            }
            if (!$Match2) {
                $Match = 0;
            }
            $Match3 = 1;
          }
        }
#print STDERR "Match:   $Match '$Acl'->ReturnType:'$Param{ReturnType}'->ReturnSubType:'$Param{ReturnSubType}'\n";
        # check force option
        if ($ForceMatch) {
#print STDERR "Matched FWorkflow '$Acl'\n";
            $Match = 1;
            $Match3 = 1;
        }
        # debug log
        my %NewTmpData = ();
        if ($Match && $Match3) {
#print STDERR "Matched: $Match '$Acl'->ReturnType:'$Param{ReturnType}'->ReturnSubType:'$Param{ReturnSubType}'\n";
            if ($Self->{Debug} > 2) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "Matched Workflow '$Acl'->'$Param{ReturnSubType}'",
                );
            }
        }
        # build new action data hash
        if (%Checks && $Match && $Match3 && $Param{ReturnType} eq 'Action' && $Step{Possible}->{$Param{ReturnType}}) {
            $Self->{TicketAclActionData} = {
                %{$Self->{ConfigObject}->Get('TicketACL::Default::Action')},
                %{$Step{Possible}->{$Param{ReturnType}}},
            };
        }
        # build new ticket data hash
        if (%Checks && $Match && $Match3 && $Step{Possible}->{Ticket}->{$Param{ReturnSubType}}) {
            $UseNewParams = 1;
            # debug log
            if ($Self->{Debug} > 3) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "Workflow '$Acl' used with Possible:'$Param{ReturnType}:$Param{ReturnSubType}'",
                );
            }
            # possible list
            foreach my $ID (keys %Data) {
                foreach my $New (@{$Step{Possible}->{Ticket}->{$Param{ReturnSubType}}}) {
                    if ($Data{$ID} eq $New) {
                        $NewTmpData{$ID} = $Data{$ID};
                        if ($Self->{Debug} > 4) {
                            $Self->{LogObject}->Log(
                                Priority => 'debug',
                                Message => "Workflow '$Acl' param '$Data{$ID}' used with Possible:'$Param{ReturnType}:$Param{ReturnSubType}'",
                            );
                        }
                    }
                }
            }
        }
        if (%Checks && $Match && $Match3 && $Step{PossibleNot}->{Ticket}->{$Param{ReturnSubType}}) {
            $UseNewParams = 1;
            # debug log
            if ($Self->{Debug} > 3) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message => "Workflow '$Acl' used with PossibleNot:'$Param{ReturnType}:$Param{ReturnSubType}'",
                );
            }
            # not possible list
            foreach my $ID (keys %Data) {
                my $Match = 1;
                foreach my $New (@{$Step{PossibleNot}->{Ticket}->{$Param{ReturnSubType}}}) {
                    if ($Data{$ID} eq $New) {
                        $Match = 0;
                    }
                }
                if ($Match) {
                    $NewTmpData{$ID} = $Data{$ID};
                    if ($Self->{Debug} > 4) {
                        $Self->{LogObject}->Log(
                            Priority => 'debug',
                            Message => "Workflow '$Acl' param '$Data{$ID}' in not used with PossibleNot:'$Param{ReturnType}:$Param{ReturnSubType}'",
                        );
                    }
                }
            }
        }
        # remember to new params if given
        if ($UseNewParams) {
#print STDERR "$Acl -- \n";
            %NewData = %NewTmpData;
            $UseNewMasterParams = 1;
        }
        # return new params if stop after this step
        if ($UseNewParams && $Step{StopAfterMatch}) {
            $Self->{TicketAclData} = \%NewData;
            return 1;
        }
    }
    if ($UseNewMasterParams) {
        $Self->{TicketAclData} = \%NewData;
        return 1;
    }
    return;
}
# --
sub TicketAclData {
    my $Self = shift;
    my %Param = @_;
    return %{$Self->{TicketAclData}};
}
# --
sub TicketAclActionData {
    my $Self = shift;
    my %Param = @_;
    if ($Self->{TicketAclActionData}) {
        return %{$Self->{TicketAclActionData}};
    }
    else {
        return %{$Self->{ConfigObject}->Get('TicketACL::Default::Action')};
    }
}
# --
sub TicketEventHandlerPost {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID Event UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # load ticket event module
    my $Modules = $Self->{ConfigObject}->Get('Ticket::EventModulePost');
    if ($Modules) {
        foreach my $Module (sort keys %{$Modules}) {
            if ($Self->{MainObject}->Require($Modules->{$Module}->{Module})) {
                my $Generic = $Modules->{$Module}->{Module}->new(
                    %{$Self},
                    TicketObject => $Self,
                );
                $Generic->Run(
                    %Param,
                    Config => $Modules->{$Module},
                );
            }
        }
    }
    return 1;
}
# --
1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=head1 VERSION

$Revision: 1.178 $ $Date: 2005-07-31 09:38:34 $

=cut
