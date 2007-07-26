# --
# Kernel/System/Ticket.pm - the global ticket handle
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Ticket.pm,v 1.267 2007-07-26 16:41:47 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket;

use strict;
use File::Path;
use Kernel::System::Ticket::Article;
use Kernel::System::Type;
use Kernel::System::State;
use Kernel::System::Priority;
use Kernel::System::Service;
use Kernel::System::SLA;
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
use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.267 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Ticket;

    my $ConfigObject = Kernel::Config->new();
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        LogObject => $LogObject,
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        MainObject => $MainObject,
        LogObject => $LogObject,
    );
    my $TicketObject = Kernel::System::Ticket->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
        MainObject => $MainObject,
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

    # set @ISA
    @ISA = ('Kernel::System::Ticket::Article');

    # get needed objects
    foreach (qw(ConfigObject LogObject TimeObject DBObject MainObject)) {
        if ($Param{$_}) {
            $Self->{$_} = $Param{$_};
        }
        else {
            die "Got no $_!";
        }
    }

    # create common needed module objects
    if (!$Param{EncodeObject}) {
        $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);
    }
    else {
        $Self->{EncodeObject} = $Param{EncodeObject};
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
    $Self->{TypeObject} = Kernel::System::Type->new(%Param);
    $Self->{PriorityObject} = Kernel::System::Priority->new(%Param);
    $Self->{ServiceObject} = Kernel::System::Service->new(%Param);
    $Self->{SLAObject} = Kernel::System::SLA->new(%Param);
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    $Self->{LockObject} = Kernel::System::Lock->new(%Param);
    $Self->{NotificationObject} = Kernel::System::Notification->new(%Param);
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

use Kernel::System::Cache;
        $Self->{CacheObject} = Kernel::System::Cache->new(%Param);

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

    # load ticket number generator
    my $GeneratorModule = $Self->{ConfigObject}->Get('Ticket::NumberGenerator')
        || 'Kernel::System::Ticket::Number::AutoIncrement';
    if (!$Self->{MainObject}->Require($GeneratorModule)) {
        die "Can't load ticket number generator backend module $GeneratorModule! $@";
    }
    push(@ISA, $GeneratorModule);

    # load ticket index generator
    my $GeneratorIndexModule = $Self->{ConfigObject}->Get('Ticket::IndexModule')
        || 'Kernel::System::Ticket::IndexAccelerator::RuntimeDB';
    if (!$Self->{MainObject}->Require($GeneratorIndexModule)) {
        die "Can't load ticket index backend module $GeneratorIndexModule! $@";
    }
    push(@ISA, $GeneratorIndexModule);

    # load article storage module
    my $StorageModule = $Self->{ConfigObject}->Get('Ticket::StorageModule')
        || 'Kernel::System::Ticket::ArticleStorageDB';
    if (!$Self->{MainObject}->Require($StorageModule)) {
        die "Can't load ticket storage backend module $StorageModule! $@";
    }
    push(@ISA, $StorageModule);

    # load custom functions
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

# use it from Kernel/System/Ticket/Number/*.pm

=item TicketCheckNumber()

checks if the ticket number exists, returns ticket id if exists

    my $TicketID = $TicketObject->TicketCheckNumber(Tn => '200404051004575');

=cut

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
    foreach (qw(Tn)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db query
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM ticket WHERE tn = '$Param{Tn}' ",
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
        Title => 'Some Ticket Title',
        Queue => 'Raw',                 # or QueueID => 123,
        Lock => 'unlock',
        Priority => '3 normal',         # or PriorityID => 2,
        State => 'new',                 # or StateID => 5,
        CustomerID => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID => 123,
        UserID => 123,
    );

    or

    my $TicketID = $TicketObject->TicketCreate(
        TN => $TicketObject->TicketCreateNumber(), # optional
        Title => 'Some Ticket Title',
        Queue => 'Raw',                 # or QueueID => 123,
        Lock => 'unlock',
        Priority => '3 normal',         # or PriorityID => 2,
        State => 'new',                 # or StateID => 5,
        Type => 'normal',               # or TypeID => 1, not required
        Service => 'Service A',         # or ServiceID => 1, not required
        SLA => 'SLA A',                 # or SALID => 1, not required
        CustomerID => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID => 123,
        ResponsibleID => 123, # not required
        UserID => 123,
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
    foreach (qw(OwnerID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    if (!$Param{ResponsibleID}) {
        $Param{ResponsibleID} = 1;
    }
    if (!$Param{TypeID} && !$Param{Type}) {
        $Param{TypeID} = 1;
    }

    # TypeID/Type lookup!
    if (!$Param{TypeID} && $Param{Type}) {
        $Param{TypeID} = $Self->{TypeObject}->TypeLookup(Type => $Param{Type});
    }
    elsif ($Param{TypeID} && !$Param{Type}) {
        $Param{Type} = $Self->{TypeObject}->TypeLookup(TypeID => $Param{TypeID});
    }
    if (!$Param{TypeID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No TypeID for '$Param{Type}'!");
        return;
    }

    # QueueID/Queue lookup!
    if (!$Param{QueueID} && $Param{Queue}) {
        $Param{QueueID} = $Self->{QueueObject}->QueueLookup(Queue => $Param{Queue});
    }
    elsif (!$Param{Queue}) {
        $Param{Queue} = $Self->{QueueObject}->QueueLookup(QueueID => $Param{QueueID});
    }
    if (!$Param{QueueID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No QueueID for '$Param{Queue}'!");
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
        $Self->{LogObject}->Log(Priority => 'error', Message => "No StateID for '$Param{State}'!");
        return;
    }

    # LockID lookup!
    if (!$Param{LockID} && $Param{Lock}) {
        $Param{LockID} = $Self->{LockObject}->LockLookup(Lock => $Param{Lock});
    }
    if (!$Param{LockID} && !$Param{Lock}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No LockID and no LockType!");
        return;
    }

    # PriorityID/Priority lookup!
    if (!$Param{PriorityID} && $Param{Priority}) {
        $Param{PriorityID} = $Self->{PriorityObject}->PriorityLookup(Priority => $Param{Priority});
    }
    elsif ($Param{PriorityID} && !$Param{Priority}) {
        $Param{Priority} = $Self->{PriorityObject}->PriorityLookup(PriorityID => $Param{PriorityID});
    }
    if (!$Param{PriorityID} && !$Param{Priority}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No PriorityID and no Priority!");
        return;
    }

    # ServiceID/Service lookup!
    if (!$Param{ServiceID} && $Param{Service}) {
        $Param{ServiceID} = $Self->{ServiceObject}->ServiceLookup(Name => $Param{Service});
    }
    elsif ($Param{ServiceID} && !$Param{Service}) {
        $Param{Service} = $Self->{ServiceObject}->ServiceLookup(ServiceID => $Param{ServiceID});
    }

    # SLAID/SLA lookup!
    if (!$Param{SLAID} && $Param{SLA}) {
        $Param{SLAID} = $Self->{SLAObject}->SLALookup(Name => $Param{SLA});
    }
    elsif ($Param{SLAID} && !$Param{SLA}) {
        $Param{SLA} = $Self->{SLAObject}->SLALookup(SLAID => $Param{SLAID});
    }

    # create ticket number if not given
    if (!$Param{TN}) {
        $Param{TN} = $Self->TicketCreateNumber();
    }

    # check ticket title
    if (!defined($Param{Title})) {
        $Param{Title} = '';
    }

    # db quote
    foreach (qw(TN Title)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(QueueID TypeID LockID OwnerID ResponsibleID PriorityID StateID ServiceID SLAID UserID)) {
        if ($Param{$_}) {
            $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
        }
        else {
            $Param{$_} = 'NULL';
        }
    }
    # create db record
    my $SQL = "INSERT INTO ticket (tn, title, create_time_unix, type_id, queue_id, ticket_lock_id, ".
        " user_id, responsible_user_id, group_id, ticket_priority_id, ticket_state_id, ticket_answered, ".
        " escalation_start_time, escalation_response_time, escalation_solution_time, timeout, service_id, sla_id, ".
        " valid_id, create_time, create_by, change_time, change_by) " .
        " VALUES ('$Param{TN}', '$Param{Title}', $Age, $Param{TypeID}, $Param{QueueID}, $Param{LockID}, ".
        " $Param{OwnerID}, $Param{ResponsibleID}, ".
        " $GroupID, $Param{PriorityID}, $Param{StateID}, ".
        " 0, $EscalationStartTime, 0, 0, 0, $Param{ServiceID}, $Param{SLAID}, $ValidID, " .
        " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";

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
        if ($Param{CustomerNo} || $Param{CustomerID} || $Param{CustomerUser}) {
            $Self->SetCustomerData(
                TicketID => $TicketID,
                No => $Param{CustomerNo} || $Param{CustomerID} || '',
                User => $Param{CustomerUser} || '',
                UserID => $Param{UserID},
            );
        }
        # update ticket view index
        $Self->TicketAcceleratorAdd(TicketID => $TicketID);
        # log
        $Self->{LogObject}->Log(
            Priority => 'notice',
                Message => "New Ticket [$Param{TN}/".substr($Param{Title}, 0, 15)."] created ".
                    "(TicketID=$TicketID,Queue=$Param{Queue},Priority=$Param{Priority},State=$Param{State})",
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
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
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
    foreach (qw(TicketNumber)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db query
    my $SQL = "SELECT id FROM ticket " .
        " WHERE " .
        " tn = '$Param{TicketNumber}'";
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

    a new subject like "RE: [Ticket# 2004040510440485] Some subject" will
    be generated

    my $NewSubject = $TicketObject->TicketSubjectBuild(
        TicketNumber => '2004040510440485',
        Subject => $OldSubject,
        Type => 'New',
    );

    a new subject like "[Ticket# 2004040510440485] Some subject" (without RE: )
    will be generated

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
    if ($Param{Type} && $Param{Type} eq 'New') {
        $Subject = "[$TicketHook$TicketHookDivider$Param{TicketNumber}] " . $Subject;
    }
    else {
        $Subject = "$TicketSubjectRe: [$TicketHook$TicketHookDivider$Param{TicketNumber}] " . $Subject;
    }
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
    my $TicketSubjectSize = $Self->{ConfigObject}->Get('Ticket::SubjectSize') || 120;
    my $TicketSubjectRe = $Self->{ConfigObject}->Get('Ticket::SubjectRe');
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
    $Subject =~ s/^($TicketSubjectRe(\[\d+\])?: )+//;
    $Subject =~ s/^(.{$TicketSubjectSize}).*$/$1 [...]/;
    return $Subject;
}

=item TicketGet()

get ticket info (TicketNumber, TicketID, State, StateID, StateType,
Priority, PriorityID, Lock, LockID, Queue, QueueID,
CustomerID, CustomerUserID, Owner, OwnerID, Type, TypeID,
SLA, SLAID, Service, ServiceID, Responsible, ResponsibleID, Created, Changed,
TicketFreeKey1-16, TicketFreeText1-16, ...)

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
    # db quote
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # db query
    my $SQL = "SELECT st.id, st.queue_id, sq.name, st.ticket_state_id, st.ticket_lock_id, ".
        " sp.id, sp.name, st.create_time_unix, st.create_time, sq.group_id, st.tn, ".
        " st.customer_id, st.customer_user_id, st.user_id, st.responsible_user_id, st.until_time, ".
        " st.freekey1, st.freetext1, st.freekey2, st.freetext2,".
        " st.freekey3, st.freetext3, st.freekey4, st.freetext4,".
        " st.freekey5, st.freetext5, st.freekey6, st.freetext6,".
        " st.freekey7, st.freetext7, st.freekey8, st.freetext8, ".
        " st.freekey9, st.freetext9, st.freekey10, st.freetext10, ".
        " st.freekey11, st.freetext11, st.freekey12, st.freetext12,".
        " st.freekey13, st.freetext13, st.freekey14, st.freetext14, ".
        " st.freekey15, st.freetext15, st.freekey16, st.freetext16, ".
        " st.freetime1, st.freetime2, st.freetime3, st.freetime4, ".
        " st.freetime5, st.freetime6, ".
        " st.change_time, st.title, st.escalation_start_time, st.timeout, ".
        " st.type_id, st.service_id, st.sla_id, st.escalation_response_time, st.escalation_solution_time ".
        " FROM ".
        " ticket st, ticket_priority sp, queue sq ".
        " WHERE ".
        " sp.id = st.ticket_priority_id ".
        " AND ".
        " sq.id = st.queue_id ".
        " AND ".
        " st.id = $Param{TicketID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);

    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Ticket{TicketID} = $Row[0];
        $Ticket{Title} = $Row[55];
        $Ticket{QueueID} = $Row[1];
        $Ticket{Queue} = $Row[2];
        $Ticket{StateID} = $Row[3];
        $Ticket{LockID} = $Row[4];
        $Ticket{PriorityID} = $Row[5];
        $Ticket{Priority} = $Row[6];
        $Ticket{Age} = $Self->{TimeObject}->SystemTime() - $Row[7];
        $Ticket{CreateTimeUnix} = $Row[7];
        $Ticket{Created} = $Self->{TimeObject}->SystemTime2TimeStamp(SystemTime => $Row[7]);
        $Ticket{EscalationStartTime} = $Row[56];
        $Ticket{EscalationResponseTime} = $Row[61];
        $Ticket{EscalationSolutionTime} = $Row[62];
        $Ticket{UnlockTimeout} = $Row[57];
        $Ticket{GroupID} = $Row[9];
        $Ticket{TicketNumber} = $Row[10];
        $Ticket{CustomerID} = $Row[11];
        $Ticket{CustomerUserID} = $Row[12];
        $Ticket{OwnerID} = $Row[13];
        $Ticket{ResponsibleID} = $Row[14];
        $Ticket{RealTillTimeNotUsed} = $Row[15];
        $Ticket{TypeID} = $Row[58] || 1;
        $Ticket{ServiceID} = $Row[59] || '';
        $Ticket{SLAID} = $Row[60] || '';
        $Ticket{TicketFreeKey1} = defined($Row[16]) ? $Row[16] : '';
        $Ticket{TicketFreeText1} = defined($Row[17]) ? $Row[17] : '';
        $Ticket{TicketFreeKey2} = defined($Row[18]) ? $Row[18] : '';
        $Ticket{TicketFreeText2} = defined($Row[19]) ? $Row[19] : '';
        $Ticket{TicketFreeKey3} = defined($Row[20]) ? $Row[20] : '';
        $Ticket{TicketFreeText3} = defined($Row[21]) ? $Row[21] : '';
        $Ticket{TicketFreeKey4} = defined($Row[22]) ? $Row[22] : '';
        $Ticket{TicketFreeText4} = defined($Row[23]) ? $Row[23] : '';
        $Ticket{TicketFreeKey5} = defined($Row[24]) ? $Row[24] : '';
        $Ticket{TicketFreeText5} = defined($Row[25]) ? $Row[25] : '';
        $Ticket{TicketFreeKey6} = defined($Row[26]) ? $Row[26] : '';
        $Ticket{TicketFreeText6} = defined($Row[27]) ? $Row[27] : '';
        $Ticket{TicketFreeKey7} = defined($Row[28]) ? $Row[28] : '';
        $Ticket{TicketFreeText7} = defined($Row[29]) ? $Row[29] : '';
        $Ticket{TicketFreeKey8} = defined($Row[30]) ? $Row[30] : '';
        $Ticket{TicketFreeText8} = defined($Row[31]) ? $Row[31] : '';
        $Ticket{TicketFreeKey9} = defined($Row[32]) ? $Row[32] : '';
        $Ticket{TicketFreeText9} = defined($Row[33]) ? $Row[33] : '';
        $Ticket{TicketFreeKey10} = defined($Row[34]) ? $Row[34] : '';
        $Ticket{TicketFreeText10} = defined($Row[35]) ? $Row[35] : '';
        $Ticket{TicketFreeKey11} = defined($Row[36]) ? $Row[36] : '';
        $Ticket{TicketFreeText11} = defined($Row[37]) ? $Row[37] : '';
        $Ticket{TicketFreeKey12} = defined($Row[38]) ? $Row[38] : '';
        $Ticket{TicketFreeText12} = defined($Row[39]) ? $Row[39] : '';
        $Ticket{TicketFreeKey13} = defined($Row[40]) ? $Row[40] : '';
        $Ticket{TicketFreeText13} = defined($Row[41]) ? $Row[41] : '';
        $Ticket{TicketFreeKey14} = defined($Row[42]) ? $Row[42] : '';
        $Ticket{TicketFreeText14} = defined($Row[43]) ? $Row[43] : '';
        $Ticket{TicketFreeKey15} = defined($Row[44]) ? $Row[44] : '';
        $Ticket{TicketFreeText15} = defined($Row[45]) ? $Row[45] : '';
        $Ticket{TicketFreeKey16} = defined($Row[46]) ? $Row[46] : '';
        $Ticket{TicketFreeText16} = defined($Row[47]) ? $Row[47] : '';
        $Ticket{TicketFreeTime1} = defined($Row[48]) ? $Row[48] : '';
        $Ticket{TicketFreeTime2} = defined($Row[49]) ? $Row[49] : '';
        $Ticket{TicketFreeTime3} = defined($Row[50]) ? $Row[50] : '';
        $Ticket{TicketFreeTime4} = defined($Row[51]) ? $Row[51] : '';
        $Ticket{TicketFreeTime5} = defined($Row[52]) ? $Row[52] : '';
        $Ticket{TicketFreeTime6} = defined($Row[53]) ? $Row[53] : '';
    }
    # check ticket
    if (!$Ticket{TicketID}) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "No such TicketID ($Param{TicketID})!",
        );
        return;
    }
    # get owner
    $Ticket{Owner} = $Self->{UserObject}->UserLookup(UserID => $Ticket{OwnerID});
    # get responsible
    $Ticket{Responsible} = $Self->{UserObject}->UserLookup(UserID => $Ticket{ResponsibleID} || 1);
    # get lock
    $Ticket{Lock} = $Self->{LockObject}->LockLookup(LockID => $Ticket{LockID});
    # get service
    $Ticket{Type} = $Self->{TypeObject}->TypeLookup(TypeID => $Ticket{TypeID});
    # get service
    if ($Ticket{ServiceID}) {
        $Ticket{Service} = $Self->{ServiceObject}->ServiceLookup(ServiceID => $Ticket{ServiceID});
    }
    # get sla
    if ($Ticket{SLAID}) {
        $Ticket{SLA} = $Self->{SLAObject}->SLALookup(SLAID => $Ticket{SLAID});
    }
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
    # get escalation attributes
    my %Escalation = $Self->TicketEscalationState(Ticket => \%Ticket, UserID => $Param{UserID} || 1);
    %Ticket = (%Escalation, %Ticket);
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
        UserID => 1,
    );

=cut

sub TicketTitleUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Title TicketID UserID)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # check if update is needed
    my %Ticket = $Self->TicketGet(%Param);
    if (defined($Ticket{Title}) &&
        $Ticket{Title} eq $Param{Title}) {
        return 1;
    }
    # db quote
    foreach (qw(Title)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "UPDATE ticket SET title = '$Param{Title}' ".
        " WHERE ".
        " id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL) ) {
        # clear ticket cache
        $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
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
    foreach (qw(TicketID UnlockTimeout)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
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
        UserID => 1,
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
    foreach (qw(TicketID EscalationStartTime)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "UPDATE ticket SET escalation_start_time = $Param{EscalationStartTime} ".
        " WHERE ".
        " id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL) ) {
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            CreateUserID => $Param{UserID},
            HistoryType => 'Misc',
            Name => "Reset of escalation update time.",
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

=item TicketEscalationResponseTimeUpdate()

update ticket response time

    $TicketObject->TicketEscalationResponseTimeUpdate(
        EscalationRseponseTime => $TimeObject->SystemTime(),
        TicketID => 123,
        UserID => 1,
    );

=cut

sub TicketEscalationResponseTimeUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(EscalationResponseTime TicketID UserID)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # check if we have to to something
    my $EscalationResponseTime = 0;
    my $SQL = "SELECT escalation_response_time ".
        " FROM ".
        " ticket ".
        " WHERE ".
        " id = $Param{TicketID} ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $EscalationResponseTime = $Row[0];
    }
    if ($EscalationResponseTime) {
        return;
    }
    # db quote
    foreach (qw(TicketID EscalationResponseTime)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    $SQL = "UPDATE ticket SET escalation_response_time = $Param{EscalationResponseTime} ".
        " WHERE ".
        " id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL) ) {
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            CreateUserID => $Param{UserID},
            HistoryType => 'Misc',
            Name => "Reset of escalation response time.",
        );
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketEscalationResponseTimeUpdate',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item TicketEscalationSolutionTimeUpdate()

update ticket solution time

    $TicketObject->TicketEscalationSolutionTimeUpdate(
        EscalationSolutionTime => $TimeObject->SystemTime(),
        TicketID => 123,
        UserID => 1,
    );

=cut

sub TicketEscalationSolutionTimeUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(EscalationSolutionTime TicketID UserID)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # check if we have to to something
    my $EscalationSolutionTime = 0;
    my $SQL = "SELECT escalation_solution_time ".
        " FROM ".
        " ticket ".
        " WHERE ".
        " id = $Param{TicketID} ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $EscalationSolutionTime = $Row[0];
    }
    if ($EscalationSolutionTime) {
        return;
    }
    # db quote
    foreach (qw(TicketID EscalationSolutionTime)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    $SQL = "UPDATE ticket SET escalation_solution_time = $Param{EscalationSolutionTime} ".
        " WHERE ".
        " id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL) ) {
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            CreateUserID => $Param{UserID},
            HistoryType => 'Misc',
            Name => "Reset of escalation solution time.",
        );
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketEscalationSolutionTimeUpdate',
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
    my %Queues = ();
    if ($Param{UserID} && $Param{UserID} eq 1) {
        %Queues = $Self->{QueueObject}->GetAllQueues();
    }
    else {
        %Queues = $Self->{QueueObject}->GetAllQueues(%Param);
    }
    # workflow
    if ($Self->TicketAcl(
        %Param,
        ReturnType => 'Ticket',
        ReturnSubType => 'Queue',
        Data => \%Queues,
    )) {
        return $Self->TicketAclData();
    }
    return %Queues;
}

=item MoveTicket()

to move a ticket (send notification to agents of selected my queues, it ticket isn't closed)

    $TicketObject->MoveTicket(
        QueueID => 123,
        TicketID => 123,
        SendNoNotification => 0, # optional 1|0 (send no agent and customer notification)
        UserID => 123,
    );

    $TicketObject->MoveTicket(
        Queue => 'Some Queue Name',
        TicketID => 123,
        SendNoNotification => 0, # optional 1|0 (send no agent and customer notification)
        UserID => 123,
    );

    $TicketObject->MoveTicket(
        Queue => 'Some Queue Name',
        TicketID => 123,
        Comment => 'some comment', # optional
        ForceNotificationToUserID => [1,43,56], # if you want to force somebody
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
    if ($Param{QueueID} == $Ticket{QueueID} && !$Param{Comment}) {
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
    # db quote
    foreach (qw(TicketID QueueID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "UPDATE ticket SET queue_id = $Param{QueueID} ".
        " WHERE id = $Param{TicketID}";
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
        if (!$Param{SendNoNotification} & $Ticket{StateType} ne 'closed') {
            my %Used = ();
            my @UserIDs = $Self->GetSubscribedUserIDsByQueueID(QueueID => $Param{QueueID});
            if ($Param{ForceNotificationToUserID}) {
                push (@UserIDs, @{$Param{ForceNotificationToUserID}});
            }
            foreach my $UserID (@UserIDs) {
                if (!$Used{$UserID} && $UserID ne $Param{UserID}) {
                    $Used{$UserID} = 1;
                    my %UserData = $Self->{UserObject}->GetUserData(
                        UserID => $UserID,
                        Cached => 1,
                        Valid => 1,
                    );
                    if ($UserData{UserSendMoveNotification}) {
                        # send agent notification
                        $Self->SendAgentNotification(
                            Type => 'Move',
                            UserData => \%UserData,
                            CustomerMessageParams => {
                                Queue => $Queue,
                                Body => $Param{Comment} || '',
                            },
                            TicketID => $Param{TicketID},
                            UserID => $Param{UserID},
                        );
                    }
                }
            }
            # send customer notification email
            my %Preferences = $Self->{UserObject}->GetUserData(UserID => $Param{UserID});
            $Self->SendCustomerNotification(
                Type => 'QueueUpdate',
                CustomerMessageParams => {
                    %Preferences,
                    Queue => $Queue,
                },
                TicketID => $Param{TicketID},
                UserID => $Param{UserID},
            );

        }
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketQueueUpdate',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item MoveQueueList()

returns a list of used queue ids / names

    my @QueueIDList = $TicketObject->MoveQueueList(
        TicketID => 123,
        Type => 'ID',
    );

    my @QueueList = $TicketObject->MoveQueueList(
        TicketID => 123,
        Type => 'Name',
    );

=cut

sub MoveQueueList {
    my $Self = shift;
    my %Param = @_;
    my @QueueID = ();
    # check needed stuff
    foreach (qw(TicketID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # db quote
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # db query
    my $SQL = "SELECT sh.name, ht.name, sh.create_by, sh.queue_id ".
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
            if ($Row[3]) {
                push (@QueueID, $Row[3]);
            }
        }
        elsif ($Row[1] eq 'Move') {
            if ($Row[0] =~ /^\%\%(.+?)\%\%(.+?)\%\%(.+?)\%\%(.+?)/) {
                push (@QueueID, $2);
            }
            elsif ($Row[0] =~ /^Ticket moved to Queue '.+?' \(ID=(.+?)\)/) {
                push (@QueueID, $1);
            }
        }
    }
    my @QueueName = ();
    foreach (@QueueID) {
        # queue lookup
        my $Queue = $Self->{QueueObject}->QueueLookup(QueueID => $_, Cache => 1);
        push (@QueueName, $Queue);
    }
    if ($Param{Type} && $Param{Type} eq 'Name') {
        return @QueueName;
    }
    else {
        return @QueueID;
    }
}

=item TicketTypeList()

to get all possible types for a ticket (depends on workflow, if configured)

    my %Types = $TicketObject->TicketTypeList(
        UserID => 123,
    );

    my %Types = $TicketObject->TicketTypeList(
        QueueID => 123,
        UserID => 123,
    );

    my %Types = $TicketObject->TicketTypeList(
        TicketID => 123,
        UserID => 123,
    );

=cut

sub TicketTypeList {
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
    my %Types = $Self->{TypeObject}->TypeList(Valid => 1);
    # workflow
    if ($Self->TicketAcl(
        %Param,
        ReturnType => 'Ticket',
        ReturnSubType => 'Type',
        Data => \%Types,
    )) {
        return $Self->TicketAclData();
    }
    return %Types;
}

=item TicketTypeSet()

to set a ticket type

    $TicketObject->TicketTypeSet(
        TypeID => 123,
        TicketID => 123,
        UserID => 123,
    );

    $TicketObject->TicketTypeSet(
        Type => 'normal',
        TicketID => 123,
        UserID => 123,
    );

=cut

sub TicketTypeSet {
    my $Self = shift;
    my %Param = @_;
    # queue lookup
    if ($Param{Type} && !$Param{TypeID}) {
        $Param{TypeID} = $Self->{TypeObject}->TypeLookup(Type => $Param{Type});
    }
    # check needed stuff
    foreach (qw(TicketID TypeID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # get current ticket
    my %Ticket = $Self->TicketGet(%Param);
    # move needed?
    if ($Param{TypeID} == $Ticket{TypeID}) {
        # update not needed
        return 1;
    }
    # permission check
    my %TypeList = $Self->TicketTypeList(%Param);
    if (!$TypeList{$Param{TypeID}}) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Permission denied on TicketID: $Param{TicketID}!",
        );
        return;
    }
    # db quote
    foreach (qw(TicketID TypeID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "UPDATE ticket SET type_id = $Param{TypeID} ".
        " WHERE id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL) ) {
        my %TicketNew = $Self->TicketGet(%Param);
        # clear ticket cache
        $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
        # history insert
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            HistoryType => 'TypeUpdate',
            Name => "\%\%$TicketNew{Type}\%\%$Param{TypeID}\%\%$Ticket{Type}\%\%$Ticket{TypeID}",
            CreateUserID => $Param{UserID},
        );
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketTypeUpdate',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item TicketServiceList()

to get all possible services for a ticket (depends on workflow, if configured)

    my %Services = $TicketObject->TicketServiceList(
        CustomerUserID => 123,
        UserID => 123,
    );

    my %Services = $TicketObject->TicketServiceList(
        CustomerUserID => 123,
        QueueID => 123,
        UserID => 123,
    );

    my %Services = $TicketObject->TicketServiceList(
        CustomerUserID => 123,
        TicketID => 123,
        UserID => 123,
    );

=cut

sub TicketServiceList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{UserID} || !$Param{CustomerUserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserID and CustomerUserID!");
        return;
    }
    # check needed stuff
    if (!$Param{QueueID} && !$Param{TicketID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need QueueID or TicketID!");
        return;
    }
    my %Services = ();
    if (0) {
        %Services = $Self->{ServiceObject}->ServiceList(
            UserID => 1,
        );
    }
    else {
        %Services = $Self->{ServiceObject}->CustomerUserServiceMemberList(
            Result => 'HASH',
            CustomerUserLogin => $Param{CustomerUserID},
            UserID => 1,
        );
    }
    # workflow
    if ($Self->TicketAcl(
        %Param,
        ReturnType => 'Ticket',
        ReturnSubType => 'Service',
        Data => \%Services,
    )) {
        return $Self->TicketAclData();
    }
    return %Services;
}

=item TicketServiceSet()

to set a ticket service

    $TicketObject->TicketServiceSet(
        ServiceID => 123,
        TicketID => 123,
        UserID => 123,
    );

    $TicketObject->TicketServiceSet(
        Service => 'Service A',
        TicketID => 123,
        UserID => 123,
    );

=cut

sub TicketServiceSet {
    my $Self = shift;
    my %Param = @_;
    # queue lookup
    if ($Param{Service} && !$Param{ServiceID}) {
        $Param{ServiceID} = $Self->{ServiceObject}->ServiceLookup(Service => $Param{Service});
    }
    # check needed stuff
    foreach (qw(TicketID ServiceID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # get current ticket
    my %Ticket = $Self->TicketGet(%Param);
    # move needed?
    if ($Param{ServiceID} eq $Ticket{ServiceID}) {
        # update not needed
        return 1;
    }
    # permission check
    my %ServiceList = $Self->TicketServiceList(%Param);
    if ($Param{ServiceID} ne '' && !$ServiceList{$Param{ServiceID}}) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Permission denied on TicketID: $Param{TicketID}!",
        );
        return;
    }
    # db quote
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    if (defined($Param{ServiceID})) {
        if ($Param{ServiceID}) {
            $Param{ServiceID} = $Self->{DBObject}->Quote($Param{ServiceID}, 'Integer');
        }
        else {
            $Param{ServiceID} = 'NULL';
        }
    }
    my $SQL = "UPDATE ticket SET service_id = $Param{ServiceID} ".
        " WHERE id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL) ) {
        my %TicketNew = $Self->TicketGet(%Param);
        # clear ticket cache
        $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
        # history insert
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            HistoryService => 'ServiceUpdate',
            Name => "\%\%$TicketNew{Service}\%\%$Param{ServiceID}\%\%$Ticket{Service}\%\%$Ticket{ServiceID}",
            CreateUserID => $Param{UserID},
        );
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketServiceUpdate',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

sub TicketEscalationState {
    my $Self = shift;
    my %Param = @_;
    my %Data = ();
    # check needed stuff
    foreach (qw(Ticket UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # get ticket
    my %Ticket = %{$Param{Ticket}};
    # check requred ticket params
    foreach (qw(TicketID StateType QueueID Created Lock)) {
        if (!$Ticket{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # do no escalations it a ticket is closed
    if ($Ticket{StateType} =~ /^close/i) {
        return ();
    }
    my %Escalation = ();
    if ($Self->{ConfigObject}->Get('Ticket::Service') && $Ticket{SLAID}) {
        %Escalation = $Self->{SLAObject}->SLAGet(
            SLAID => $Ticket{SLAID},
            UserID => $Param{UserID},
            Cache => 1,
        );
    }
    else {
        %Escalation = $Self->{QueueObject}->QueueGet(
            ID => $Ticket{QueueID},
            UserID => $Param{UserID},
            Cache => 1,
        );
    }
    # check response time
    if ($Escalation{FirstResponseTime}) {
        # check if first response is already done
        if (!defined($Ticket{EscalationResponseTime})) {
            $Ticket{EscalationResponseTime} = 0;
            # find first response time
            my $SQL = "SELECT a.create_time,a.id FROM ".
                " article a, article_sender_type ast, article_type at ".
                " WHERE ".
                " a.article_sender_type_id = ast.id ".
                " AND ".
                " a.article_type_id = at.id ".
                " AND ".
                " a.ticket_id = $Ticket{TicketID} ".
                " AND ".
                " ast.name = 'agent' AND (at.name LIKE 'email-ext%' OR at.name = 'phone' OR at.name = 'fax') ".
                " ORDER BY a.create_time";
            $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 1);
            while (my @Row = $Self->{DBObject}->FetchrowArray()) {
                $Ticket{EscalationResponseTime} = $Self->{TimeObject}->TimeStamp2SystemTime(
                    String => $Row[0],
                );
            }
            $Self->TicketEscalationResponseTimeUpdate(
                EscalationResponseTime => $Ticket{EscalationResponseTime},
                TicketID => $Ticket{TicketID},
                UserID => 1,
            );
        }
        # do escalation stuff
        if (!$Ticket{EscalationResponseTime}) {
            my $DestinationTime = $Self->{TimeObject}->DestinationTime(
                StartTime => $Self->{TimeObject}->TimeStamp2SystemTime(String => $Ticket{Created}),
                Time => $Escalation{FirstResponseTime}*60,
                Calendar => $Escalation{Calendar},
            );

            my $Time = 0;
#            if ($FirstResponse) {
#                $Time = $DestinationTime-$Self->{TimeObject}->TimeStamp2SystemTime(String => $FirstResponse);
#            }
#            else {
                $Time = $DestinationTime-$Self->{TimeObject}->SystemTime();
#            }
            my $WorkingTime = 0;
            if ($Time > 0) {
                $WorkingTime = $Self->{TimeObject}->WorkingTime(
                    StartTime => $Time,
                    StopTime => $DestinationTime,
                    Calendar => $Escalation{Calendar},
                );
                # set notification
                if (60*60*2.2 > $WorkingTime) {
                    $Data{"FirstResponseTimeNotification"} = 1;
                }
            }
            else {
                $WorkingTime = $Self->{TimeObject}->WorkingTime(
                    StartTime => $DestinationTime,
                    StopTime => $Time,
                    Calendar => $Escalation{Calendar},
                );
                $WorkingTime = "-$WorkingTime";
                # set escalation
#                if (!$FirstResponse) {
                    $Data{"FirstResponseTimeEscalation"} = 1;
#                }
            }
            my $DestinationDate = $Self->{TimeObject}->SystemTime2TimeStamp(SystemTime => $DestinationTime);
            $Data{"FirstResponseTimeDestinationTime"} = $DestinationTime;
            $Data{"FirstResponseTimeDestinationDate"} = $DestinationDate;
            $Data{"FirstResponseTimeWorkingTime"} = $WorkingTime;
            $Data{"FirstResponseTime"} = $Time;
        }
    }
    # check update time
    if ($Escalation{UpdateTime}) {
        my $DestinationTime = $Self->{TimeObject}->DestinationTime(
            StartTime => $Ticket{EscalationStartTime},
            Time => $Escalation{UpdateTime}*60,
            Calendar => $Escalation{Calendar},
        );
        my $Time = $DestinationTime-$Self->{TimeObject}->SystemTime();
        my $WorkingTime = 0;
        if ($Time > 0) {
            $WorkingTime = $Self->{TimeObject}->WorkingTime(
                StartTime => $Self->{TimeObject}->SystemTime(),
                StopTime => $DestinationTime,
                Calendar => $Escalation{Calendar},
            );
            # set notification
            if ($Ticket{StateType} =~ /^(new|open)$/i && $Ticket{Lock} ne 'lock' && 60*60*2.2 > $WorkingTime) {
                $Data{"UpdateTimeNotification"} = 1;
            }
        }
        else {
            $WorkingTime = $Self->{TimeObject}->WorkingTime(
                StartTime => $DestinationTime,
                StopTime => $Self->{TimeObject}->SystemTime(),
                Calendar => $Escalation{Calendar},
            );
            $WorkingTime = "-$WorkingTime";
            # set escalation
            if ($Ticket{StateType} =~ /^(new|open)$/i && $Ticket{Lock} ne 'lock') {
                $Data{"UpdateTimeEscalation"} = 1;
            }
        }
        my $DestinationDate = $Self->{TimeObject}->SystemTime2TimeStamp(SystemTime => $DestinationTime);
        $Data{"UpdateTimeDestinationTime"} = $DestinationTime;
        $Data{"UpdateTimeDestinationDate"} = $DestinationDate;
        $Data{"UpdateTimeWorkingTime"} = $WorkingTime;
        $Data{"UpdateTime"} = $Time;
    }
    # check solution time
    if ($Escalation{SolutionTime}) {
        # get first close date, if not already set
        if (!defined($Ticket{EscalationSolutionTime})) {
            $Ticket{EscalationSolutionTime} = 0;
            # find first close time
            my @StateIDs = $Self->{StateObject}->StateGetStatesByType(
                StateType => ['closed'],
                Result => 'ID',
            );
            my $SQL = "SELECT create_time FROM ".
                " ticket_history ".
                " WHERE ".
                " ticket_id = $Ticket{TicketID} ".
                " AND ".
                " state_id IN (${\(join ', ', @StateIDs)}) ".
                " ORDER BY create_time";
            $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 1);
            while (my @Row = $Self->{DBObject}->FetchrowArray()) {
                $Ticket{EscalationSolutionTime} = $Self->{TimeObject}->TimeStamp2SystemTime(
                    String => $Row[0],
                );
            }
            $Self->TicketEscalationSolutionTimeUpdate(
                EscalationSolutionTime => $Ticket{EscalationSolutionTime},
                TicketID => $Ticket{TicketID},
                UserID => 1,
            );
        }
        # do escalation stuff
        if (!$Ticket{EscalationSolutionTime}) {
            my $DestinationTime = $Self->{TimeObject}->DestinationTime(
                StartTime => $Self->{TimeObject}->TimeStamp2SystemTime(String => $Ticket{Created}),
                Time => $Escalation{SolutionTime}*60,
                Calendar => $Escalation{Calendar},
            );
            my $Time = $DestinationTime-$Self->{TimeObject}->SystemTime();
            my $WorkingTime = 0;
            if ($Time > 0) {
                $WorkingTime = $Self->{TimeObject}->WorkingTime(
                    StartTime => $Self->{TimeObject}->SystemTime(),
                    StopTime => $DestinationTime,
                    Calendar => $Escalation{Calendar},
                );
                # set notification
                if ($Ticket{StateType} !~ /^close/i && 60*60*2.2 > $WorkingTime) {
                    $Data{"SolutionTimeNotification"} = 1;
                }
            }
            else {
                $WorkingTime = $Self->{TimeObject}->WorkingTime(
                    StartTime => $DestinationTime,
                    StopTime => $Self->{TimeObject}->SystemTime(),
                    Calendar => $Escalation{Calendar},
                );
                $WorkingTime = "-$WorkingTime";
                # set escalation
                if ($Ticket{StateType} !~ /^close/i) {
                    $Data{"SolutionTimeEscalation"} = 1;
                }
            }
            my $DestinationDate = $Self->{TimeObject}->SystemTime2TimeStamp(SystemTime => $DestinationTime);
            $Data{"SolutionTimeDestinationTime"} = $DestinationTime;
            $Data{"SolutionTimeDestinationDate"} = $DestinationDate;
            $Data{"SolutionTimeWorkingTime"} = $WorkingTime;
            $Data{"SolutionTime"} = $Time;
        }
    }
    return %Data;
}

=item TicketSLAList()

to get all possible SLAs for a ticket (depends on workflow, if configured)

    my %SLAs = $TicketObject->TicketSLAList(
        ServiceID => 1,
        UserID => 123,
    );

    my %SLAs = $TicketObject->TicketSLAList(
        QueueID => 123,
        ServiceID => 1,
        UserID => 123,
    );

    my %SLAs = $TicketObject->TicketSLAList(
        TicketID => 123,
        ServiceID => 1,
        UserID => 123,
    );

=cut

sub TicketSLAList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{UserID} && !$Param{CustomerUserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserID or CustomerUserID!");
        return;
    }
    # check needed stuff
    if (!$Param{QueueID} && !$Param{TicketID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need QueueID or TicketID!");
        return;
    }
    # check needed stuff
    foreach (qw(ServiceID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # db quote
    foreach (qw(ServiceID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get sla list
    my %SLAs = $Self->{SLAObject}->SLAList(
        ServiceID => $Param{ServiceID},
        UserID => 1,
    );
    # workflow
    if ($Self->TicketAcl(
        %Param,
        ReturnType => 'Ticket',
        ReturnSubType => 'SLA',
        Data => \%SLAs,
    )) {
        return $Self->TicketAclData();
    }
    return %SLAs;
}

=item TicketSLASet()

to set a ticket service

    $TicketObject->TicketSLASet(
        SLAID => 123,
        TicketID => 123,
        UserID => 123,
    );

    $TicketObject->TicketSLASet(
        SLA => 'SLA A',
        TicketID => 123,
        UserID => 123,
    );

=cut

sub TicketSLASet {
    my $Self = shift;
    my %Param = @_;
    # queue lookup
    if ($Param{SLA} && !$Param{SLAID}) {
        $Param{SLAID} = $Self->{SLAObject}->SLALookup(SLA => $Param{SLA});
    }
    # check needed stuff
    foreach (qw(TicketID SLAID UserID)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # get current ticket
    my %Ticket = $Self->TicketGet(%Param);
    # move needed?
    if ($Param{SLAID} eq $Ticket{SLAID}) {
        # update not needed
        return 1;
    }
    # permission check
    my %SLAList = $Self->TicketSLAList(%Param, ServiceID => $Ticket{ServiceID});
    if ($Param{SLAID} ne '' && !$SLAList{$Param{SLAID}}) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Permission denied on TicketID: $Param{TicketID}!",
        );
        return;
    }
    # db quote
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    if (defined($Param{SLAID})) {
        if ($Param{SLAID}) {
            $Param{SLAID} = $Self->{DBObject}->Quote($Param{SLAID}, 'Integer');
        }
        else {
            $Param{SLAID} = 'NULL';
        }
    }
    my $SQL = "UPDATE ticket SET sla_id = $Param{SLAID} ".
        " WHERE id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL) ) {
        my %TicketNew = $Self->TicketGet(%Param);
        # clear ticket cache
        $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
        # history insert
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            HistorySLA => 'SLAUpdate',
            Name => "\%\%$TicketNew{SLA}\%\%$Param{SLAID}\%\%$Ticket{SLA}\%\%$Ticket{SLAID}",
            CreateUserID => $Param{UserID},
        );
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketSLAUpdate',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
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
    foreach (qw(No User)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(TicketID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # db customer id update
    if (defined($Param{No})) {
        my $SQL = "UPDATE ticket SET customer_id = '$Param{No}', " .
            " change_time = current_timestamp, change_by = $Param{UserID} " .
            " WHERE id = $Param{TicketID} ";
        if ($Self->{DBObject}->Do(SQL => $SQL)) {
            $Param{History} = "CustomerID=$Param{No};";
        }
    }
    # db customer user update
    if (defined($Param{User})) {
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
            Event => 'TicketCustomerUpdate',
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

    # fill up with existing values
    my $HashRef = $TicketObject->TicketFreeTextGet(
        Type => 'TicketFreeText3',
        FillUp => 1,
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
    # get config
    my %Data = ();
    if (ref($Self->{ConfigObject}->Get($Param{Type})) eq 'HASH') {
        %Data = %{$Self->{ConfigObject}->Get($Param{Type})};
    }
    # check existing
    if ($Param{FillUp}) {
        my $Counter = $Param{Type};
        $Counter =~ s/^.+?(\d+?)$/$1/;
        if (%Data && $Param{Type} =~ /text/i) {
            $Self->{DBObject}->Prepare(SQL => "SELECT distinct(freetext$Counter) FROM ticket");
            while (my @Row = $Self->{DBObject}->FetchrowArray()) {
                if ($Row[0] && !$Data{$Row[0]}) {
                    $Data{$Row[0]} = $Row[0];
                }
            }
        }
        elsif (%Data) {
            $Self->{DBObject}->Prepare(SQL => "SELECT distinct(freekey$Counter) FROM ticket");
            while (my @Row = $Self->{DBObject}->FetchrowArray()) {
                if ($Row[0] && !$Data{$Row[0]}) {
                    $Data{$Row[0]} = $Row[0];
                }
            }
        }
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
    if (%Data) {
        return \%Data;
    }
    else {
        return;
    }
}

=item TicketFreeTextSet()

Set ticket free text.

    $TicketObject->TicketFreeTextSet(
        Counter => 1,
        Key => 'Planet', # optional
        Value => 'Sun',  # optional
        TicketID => 123,
        UserID => 23,
    );

=cut

sub TicketFreeTextSet {
    my $Self = shift;
    my %Param = @_;
    my $Value = '';
    my $Key = '';
    # check needed stuff
    foreach (qw(TicketID UserID Counter)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # check if update is needed
    my %Ticket = $Self->TicketGet(TicketID => $Param{TicketID});

    if (defined($Param{Value})) {
        $Value = $Param{Value};
    }
    else {
        $Value = $Ticket{"TicketFreeText" . $Param{Counter}};
    }

    if (defined($Param{Key})) {
        $Key = $Param{Key};
    }
    else {
        $Key = $Ticket{"TicketFreeKey" . $Param{Counter}};
    }

    if ($Value eq $Ticket{"TicketFreeText$Param{Counter}"} &&
        $Key eq $Ticket{"TicketFreeKey$Param{Counter}"}) {
        return 1;
    }
    # db quote
    my $DBValue = $Self->{DBObject}->Quote($Value);
    my $DBKey = $Self->{DBObject}->Quote($Key);
    foreach (qw(TicketID UserID Counter)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
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
            Event => 'TicketFreeTextUpdate',
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
    foreach (qw(TicketID UserID Counter)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $InsertTime = 'NULL';
    if ($TimeStamp eq '0000-00-00 00:00:00') {
        $TimeStamp = 'NULL';
    }
    else {
        $TimeStamp = $Self->{DBObject}->Quote($TimeStamp);
        $InsertTime = "'".$TimeStamp."'";
    }
    my $SQL = "UPDATE ticket SET ".
        " freetime$Param{Counter} = $InsertTime, " .
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
            Event => 'TicketFreeTimeUpdate',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item Permission()

returns if the agent has permissions or no

    my $Access = $TicketObject->Permission(
        Type => 'ro',
        TicketID => 123,
        UserID => 123,
    );

or without logging, for example for to check if a link/action should be shown

    my $Access = $TicketObject->Permission(
        Type => 'ro',
        TicketID => 123,
        LogNo => 1,
        UserID => 123,
    );

=cut

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
                        if (!$Param{LogNo}) {
                            $Self->{LogObject}->Log(
                                Priority => 'notice',
                                Message => "Permission denied because module ".
                                    "($Modules{$Module}->{Module}) is required ".
                                    "(UserID: $Param{UserID} '$Param{Type}' on ".
                                    "TicketID: $Param{TicketID})!",
                            );
                        }
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
        if (!$Param{LogNo}) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "Permission denied (UserID: $Param{UserID} '$Param{Type}' ".
                    "on TicketID: $Param{TicketID})!",
            );
        }
        return;
    }
}

=item CustomerPermission()

returns if the agent has permissions or no

    my $Access = $TicketObject->CustomerPermission(
        Type => 'ro',
        TicketID => 123,
        UserID => 123,
    );

or without logging, for example for to check if a link/action should be shown

    my $Access = $TicketObject->CustomerPermission(
        Type => 'ro',
        TicketID => 123,
        LogNo => 1,
        UserID => 123,
    );

=cut

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
    foreach (qw(UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
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
        " slt.name not IN ( ${\(join ', ', @ViewableLocks)} ) ORDER BY ";
    # sort by
    if ($Param{SortBy} =~ /^Queue$/i) {
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
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push (@ViewableTickets, $Row[0]);
    }
    return @ViewableTickets;
}

=item GetSubscribedUserIDsByQueueID()

returns a array of user ids which selected the given queue id as
custom queue.

    my @UserIDs = $TicketObject->GetSubscribedUserIDsByQueueID(
        QueueID => 123,
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
    foreach (qw(QueueID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
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

or use a time stamp

    $TicketObject->TicketPendingTimeSet(
        String => '2003-08-14 22:05:00',
        TicketID => 123,
        UserID => 23,
    );

=cut

sub TicketPendingTimeSet {
    my $Self = shift;
    my %Param = @_;
    my $Time;
    # check needed stuff
    if (!$Param{String}) {
        foreach (qw(Year Month Day Hour Minute TicketID UserID)) {
            if (!defined($Param{$_})) {
                $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
                return;
            }
        }
    }
    # get system time from string/params
    if ($Param{String}) {
        $Time = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Param{String},
        );
        ($Param{Sec}, $Param{Minute}, $Param{Hour}, $Param{Day}, $Param{Month}, $Param{Year}) =
        $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Time,
        );
    }
    else {
        $Time = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => "$Param{Year}-$Param{Month}-$Param{Day} $Param{Hour}:$Param{Minute}:00",
        );
    }
    # return if no convert is possible
    if (!$Time) {
        return;
    }

    # db quote
    foreach (qw(TicketID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
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
            Event => 'TicketPendingTimeUpdate',
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

        # ticket number (optional) as STRING or as ARRAYREF
        TicketNumber => '%123546%',
        TicketNumber => ['%123546%', '%123666%'],
        # ticket title (optional) as STRING or as ARRAYREF
        Title => '%SomeText%',
        Title => ['%SomeTest1%', '%SomeTest2%'],

        Queues => ['system queue', 'other queue'],
        QueueIDs => [1, 42, 512],
        # use also sub queues of Queue|Queues in search
        UseSubQueues => 0,

        # You can use types like normal, ...
        Types => ['normal', 'change', 'incident'],
        TypeIDs => [3, 4],

        # You can use states like new, open, pending reminder, ...
        States => ['new', 'open'],
        StateIDs => [3, 4],

        # (Open|Closed) tickets for all closed or open tickets.
        StateType => 'Open',

        # You also can use real state types like new, open, closed,
        # pending reminder, pending auto, removed and merged.
        StateType => ['open', 'new'],
        StateTypeIDs => [1, 2, 3],

        Priorities => ['1 very low', '2 low', '3 normal'],
        PriorityIDs => [1, 2, 3],

        Services => ['Service A', 'Service B'],
        ServiceIDs => [1, 2, 3],

        SLAs => ['SLA A', 'SLA B'],
        SLAIDs => [1, 2, 3],

        Locks => ['unlock'],
        LockIDs => [1, 2, 3],

        OwnerIDs => [1, 12, 455, 32]

        ResponsibleIDs => [1, 12, 455, 32]

        WatchUserIDs => [1, 12, 455, 32]

        # CustomerID (optional) as STRING or as ARRAYREF
        CustomerID => '123',
        CustomerID => ['123', 'ABC'],
        # CustomerUserLogin (optional) as STRING as ARRAYREF
        CustomerUserLogin => 'uid123',
        CustomerUserLogin => ['uid123', 'uid777'],

        # create ticket properties (optional)
        CreatedUserIDs => [1, 12, 455, 32]
        CreatedTypes => ['normal', 'change', 'incident'],
        CreatedTypeIDs => [1, 2, 3],
        CreatedPriorities => ['1 very low', '2 low', '3 normal'],
        CreatedPriorityIDs => [1, 2, 3],
        CreatedStates => ['new', 'open'],
        CreatedStateIDs => [3, 4],
        CreatedQueues => ['system queue', 'other queue'],
        CreatedQueueIDs => [1, 42, 512],

        # 1..16 (optional)
        TicketFreeKey1 => 'Product',
        TicketFreeText1 => 'adasd',
        # or with multi options as array ref or string possible
        TicketFreeKey2 => ['Product', 'Product2'],
        TicketFreeText2 => ['Browser', 'Sound', 'Mouse'],

        # 1..6 (optional)
        # tickets with free time after ... (optional)
        TicketFreeTime1NewerDate => '2006-01-09 00:00:01',
        # tickets with free time before then .... (optional)
        TicketFreeTime1OlderDate => '2006-01-19 23:59:59',

        # article stuff (optional)
        From => '%spam@example.com%',
        To => '%support@example.com%',
        Cc => '%client@example.com%',
        Subject => '%VIRUS 32%',
        Body => '%VIRUS 32%',
        # content search (AND or OR) (optional)
        ContentSearch => 'AND',

        # tickets created after 60 minutes (optional)
        TicketCreateTimeOlderMinutes => 60,
        # tickets created before 120 minutes (optional)
        TicketCreateTimeNewerMinutes => 120,

        # tickets with created time after ... (optional)
        TicketCreateTimeNewerDate => '2006-01-09 00:00:01',
        # tickets with created time before then .... (optional)
        TicketCreateTimeOlderDate => '2006-01-19 23:59:59',

        # tickets with closed time after ... (optional)
        TicketCloseTimeNewerDate => '2006-01-09 00:00:01',
        # tickets with closed time before then .... (optional)
        TicketCloseTimeOlderDate => '2006-01-19 23:59:59',

        # tickets pending after 60 minutes (optional)
        TicketPendingTimeOlderMinutes => 60,
        # tickets pending before 120 minutes (optional)
        TicketPendingTimeNewerMinutes => 120,

        # tickets with pending time after ... (optional)
        TicketPendingTimeNewerDate => '2006-01-09 00:00:01',
        # tickets with pending time before then .... (optional)
        TicketPendingTimeOlderDate => '2006-01-19 23:59:59',

        # OrderBy and SortBy (optional)
        OrderBy => 'Down',      # Down|Up
        SortBy => 'Age',        # Owner|CustomerID|State|Ticket|Queue|Priority|Age|Type|Lock|Service|SLA
                                # TicketFreeTime1-2|TicketFreeKey1-16|TicketFreeText1-16

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
        Responsible => 'st.responsible_user_id',
        CustomerID => 'st.customer_id',
        State => 'st.ticket_state_id',
        Lock => 'st.ticket_lock_id',
        Ticket => 'st.tn',
        Title => 'st.title',
        Queue => 'sq.name',
        Type => 'st.type_id',
        Priority => 'st.ticket_priority_id',
        Age => 'st.create_time_unix',
        Service => 'st.service_id',
        SLA => 'st.sla_id',
        TicketFreeTime1 => 'st.freetime1',
        TicketFreeTime2 => 'st.freetime2',
        TicketFreeTime3 => 'st.freetime3',
        TicketFreeTime4 => 'st.freetime4',
        TicketFreeTime5 => 'st.freetime5',
        TicketFreeTime6 => 'st.freetime6',
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
        TicketFreeKey9 => 'st.freekey9',
        TicketFreeText9 => 'st.freetext9',
        TicketFreeKey10 => 'st.freekey10',
        TicketFreeText10 => 'st.freetext10',
        TicketFreeKey11 => 'st.freekey11',
        TicketFreeText11 => 'st.freetext11',
        TicketFreeKey12 => 'st.freekey12',
        TicketFreeText12 => 'st.freetext12',
        TicketFreeKey13 => 'st.freekey13',
        TicketFreeText13 => 'st.freetext13',
        TicketFreeKey14 => 'st.freekey14',
        TicketFreeText14 => 'st.freetext14',
        TicketFreeKey15 => 'st.freekey15',
        TicketFreeText15 => 'st.freetext15',
        TicketFreeKey16 => 'st.freekey16',
        TicketFreeText16 => 'st.freetext16',
    );
    # check required params
    if (!$Param{UserID} && !$Param{CustomerUserID}) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Need UserID or CustomerUserID params for permission check!",
        );
        return;
    }
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
        if ($_ =~ /^(Ticket(Create|Close)|Created)/) {
            $SQL .= ", ticket_history th ";
            $SQLExt .= " AND st.id = th.ticket_id";
            last;
        }
    }
    if ($Param{WatchUserIDs}) {
        $SQL .= ", ticket_watcher tw ";
        $SQLExt .= " AND st.id = tw.ticket_id";
    }
    $SQLExt = " WHERE sq.id = st.queue_id".$SQLExt;

    # current type lookup
    if ($Param{Types} && ref($Param{Types}) eq 'ARRAY') {
        foreach (@{$Param{Types}}) {
            if ($Self->{TypeObject}->TypeLookup(Type => $_)) {
                push (@{$Param{TypeIDs}}, $Self->{TypeObject}->TypeLookup(Type => $_));
            }
            else {
                return;
            }
        }
    }
    # type ids
    if ($Param{TypeIDs} && ref($Param{TypeIDs}) eq 'ARRAY') {
        $SQLExt .= " AND st.type_id IN (";
        my $Exists = 0;
        foreach (@{$Param{TypeIDs}}) {
            if ($Exists) {
                $SQLExt .= ",";
            }
            $SQLExt .= $Self->{DBObject}->Quote($_);
            $Exists = 1;
        }
        $SQLExt .= ")";
    }
    # created types lookup
    if ($Param{CreatedTypes} && ref($Param{CreatedTypes}) eq 'ARRAY') {
        foreach (@{$Param{CreatedTypes}}) {
            if ($Self->{TypeObject}->TypeLookup(Type => $_)) {
                push (@{$Param{CreatedTypeIDs}}, $Self->{TypeObject}->TypeLookup(Type => $_));
            }
            else {
                return;
            }
        }
    }
    # create types id
    if ($Param{CreatedTypeIDs} && ref($Param{CreatedTypeIDs}) eq 'ARRAY') {
        my $ID = $Self->HistoryTypeLookup(Type => 'NewTicket');
        if ($ID) {
            $SQLExt .= " AND th.type_id IN (";
            my $Exists = 0;
            foreach (@{$Param{CreatedTypeIDs}}) {
                if ($Exists) {
                    $SQLExt .= ",";
                }
                $SQLExt .= $Self->{DBObject}->Quote($_);
                $Exists = 1;
            }
            $SQLExt .= ") AND th.history_type_id = $ID ";
        }
    }
    # current state lookup
    if ($Param{States} && ref($Param{States}) eq 'ARRAY') {
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
    # state ids
    if ($Param{StateIDs} && ref($Param{StateIDs}) eq 'ARRAY') {
        $SQLExt .= " AND st.ticket_state_id IN (";
        my $Exists = 0;
        foreach (@{$Param{StateIDs}}) {
            if ($Exists) {
                $SQLExt .= ",";
            }
            $SQLExt .= $Self->{DBObject}->Quote($_);
            $Exists = 1;
        }
        $SQLExt .= ")";
    }
    # created states lookup
    if ($Param{CreatedStates} && ref($Param{CreatedStates}) eq 'ARRAY') {
        foreach (@{$Param{CreatedStates}}) {
            my %State = $Self->{StateObject}->StateGet(Name => $_, Cache => 1);
            if ($State{ID}) {
                push (@{$Param{CreatedStateIDs}}, $State{ID});
            }
            else {
                return;
            }
        }
    }
    # create states id
    if ($Param{CreatedStateIDs} && ref($Param{CreatedStateIDs}) eq 'ARRAY') {
        my $ID = $Self->HistoryTypeLookup(Type => 'NewTicket');
        if ($ID) {
            $SQLExt .= " AND th.state_id IN (";
            my $Exists = 0;
            foreach (@{$Param{CreatedStateIDs}}) {
                if ($Exists) {
                    $SQLExt .= ",";
                }
                $SQLExt .= $Self->{DBObject}->Quote($_);
                $Exists = 1;
            }
            $SQLExt .= ") AND th.history_type_id = $ID ";
        }
    }
    # current ticket state type
    if ($Param{StateType} && $Param{StateType} eq 'Open') {
        my @ViewableStateIDs = $Self->{StateObject}->StateGetStatesByType(
            Type => 'Viewable',
            Result => 'ID',
        );
        push (@{$Param{StateTypeIDs}}, @ViewableStateIDs);
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
            StateType => $Param{StateType},
            Result => 'ID',
        );
        push (@{$Param{StateTypeIDs}}, @StateIDs);
    }
    if ($Param{StateTypeIDs} && ref($Param{StateTypeIDs}) eq 'ARRAY') {
        $SQLExt .= " AND st.ticket_state_id IN (";
        my $Exists = 0;
        foreach (@{$Param{StateTypeIDs}}) {
            if ($Exists) {
                $SQLExt .= ",";
            }
            $SQLExt .= $Self->{DBObject}->Quote($_);
            $Exists = 1;
        }
        $SQLExt .= ")";
    }
    # current lock lookup
    if ($Param{Locks} && ref($Param{Locks}) eq 'ARRAY') {
        foreach (@{$Param{Locks}}) {
            if ($Self->{LockObject}->LockLookup(Lock => $_)) {
                push (@{$Param{LockIDs}}, $Self->{LockObject}->LockLookup(Lock => $_));
            }
            else {
                return;
            }
        }
    }
    # lock ids
    if ($Param{LockIDs} && ref($Param{LockIDs}) eq 'ARRAY') {
        $SQLExt .= " AND st.ticket_lock_id IN (";
        my $Exists = 0;
        foreach (@{$Param{LockIDs}}) {
            if ($Exists) {
                $SQLExt .= ",";
            }
            $SQLExt .= $Self->{DBObject}->Quote($_);
            $Exists = 1;
        }
        $SQLExt .= ")";
    }
    # current owners user ids
    if ($Param{OwnerIDs} && ref($Param{OwnerIDs}) eq 'ARRAY') {
        $SQLExt .= " AND st.user_id IN (";
        my $Exists = 0;
        foreach (@{$Param{OwnerIDs}}) {
            if ($Exists) {
                $SQLExt .= ",";
            }
            $SQLExt .= $Self->{DBObject}->Quote($_);
            $Exists = 1;
        }
        $SQLExt .= ")";
    }
    # current owners user ids
    if ($Param{ResponsibleIDs} && ref($Param{ResponsibleIDs}) eq 'ARRAY') {
        $SQLExt .= " AND st.responsible_user_id IN (";
        my $Exists = 0;
        foreach (@{$Param{ResponsibleIDs}}) {
            if ($Exists) {
                $SQLExt .= ",";
            }
            $SQLExt .= $Self->{DBObject}->Quote($_);
            $Exists = 1;
        }
        $SQLExt .= ")";
    }
    # created owner user ids
    if ($Param{CreatedUserIDs} && ref($Param{CreatedUserIDs}) eq 'ARRAY') {
        my $ID = $Self->HistoryTypeLookup(Type => 'NewTicket');
        if ($ID) {
            $SQLExt .= " AND th.create_by IN (";
            my $Exists = 0;
            foreach (@{$Param{CreatedUserIDs}}) {
                if ($Exists) {
                    $SQLExt .= ",";
                }
                $SQLExt .= $Self->{DBObject}->Quote($_);
                $Exists = 1;
            }
            $SQLExt .= ") AND th.history_type_id = $ID ";
        }
    }
    # current queue lookup
    if ($Param{Queues} && ref($Param{Queues}) eq 'ARRAY') {
        foreach (@{$Param{Queues}}) {
            if ($Self->{QueueObject}->QueueLookup(Queue => $_)) {
                push (@{$Param{QueueIDs}}, $Self->{QueueObject}->QueueLookup(Queue => $_));
            }
            else {
                return;
            }
        }
    }
    # current sub queue ids
    if ($Param{UseSubQueues} && $Param{QueueIDs} && ref($Param{QueueIDs}) eq 'ARRAY') {
        my @SubQueueIDs = ();
        my %Queues = $Self->{QueueObject}->GetAllQueues();
        foreach my $QueueID (@{$Param{QueueIDs}}) {
            my $Queue = $Self->{QueueObject}->QueueLookup(QueueID => $QueueID);
            foreach my $QueuesID (keys %Queues) {
                if ($Queues{$QueuesID} =~ /^\Q$Queue\E::/i) {
                    push (@SubQueueIDs, $QueuesID);
                }
            }
        }
        push (@{$Param{QueueIDs}}, @SubQueueIDs);
    }
    # current queue ids
    if ($Param{QueueIDs} && ref($Param{QueueIDs}) eq 'ARRAY') {
        $SQLExt .= " AND st.queue_id IN (";
        my $Exists = 0;
        foreach (@{$Param{QueueIDs}}) {
            if ($Exists) {
                $SQLExt .= ",";
            }
            $SQLExt .= $Self->{DBObject}->Quote($_);
            $Exists = 1;
        }
        $SQLExt .= ")";
    }
    # created queue lookup
    if ($Param{CreatedQueues} && ref($Param{CreatedQueues}) eq 'ARRAY') {
        foreach (@{$Param{CreatedQueues}}) {
            if ($Self->{QueueObject}->QueueLookup(Queue => $_)) {
                push (@{$Param{CreatedQueueIDs}}, $Self->{QueueObject}->QueueLookup(Queue => $_));
            }
            else {
                return;
            }
        }
    }
    # create queue ids
    if ($Param{CreatedQueueIDs} && ref($Param{CreatedQueueIDs}) eq 'ARRAY') {
        my $ID = $Self->HistoryTypeLookup(Type => 'NewTicket');
        if ($ID) {
            $SQLExt .= " AND th.queue_id IN (";
            my $Exists = 0;
            foreach (@{$Param{CreatedQueueIDs}}) {
                if ($Exists) {
                    $SQLExt .= ",";
                }
                $SQLExt .= $Self->{DBObject}->Quote($_);
                $Exists = 1;
            }
            $SQLExt .= ") AND th.history_type_id = $ID ";
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
        $SQLExt .= " AND (LOWER(st.customer_id) IN (";
        my $Exists = 0;
        foreach (@CustomerIDs) {
            if ($Exists) {
                $SQLExt .= ", ";
            }
            else {
                $Exists = 1;
            }
            $SQLExt .= "LOWER('".$Self->{DBObject}->Quote($_)."')";
        }
        $SQLExt .= ") ".
            " OR ".
            " st.customer_user_id = '".$Self->{DBObject}->Quote($Param{CustomerUserID})."') ";

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
    # current priority lookup
    if ($Param{Priorities} && ref($Param{Priorities}) eq 'ARRAY') {
        foreach (@{$Param{Priorities}}) {
            my $ID = $Self->{PriorityObject}->PriorityLookup(Priority => $_);
            if ($ID) {
                push (@{$Param{PriorityIDs}}, $ID);
            }
            else {
                return;
            }
        }
    }
    # priority ids
    if ($Param{PriorityIDs} && ref($Param{PriorityIDs}) eq 'ARRAY') {
        $SQLExt .= " AND st.ticket_priority_id IN (";
        my $Exists = 0;
        foreach (@{$Param{PriorityIDs}}) {
            if ($Exists) {
                $SQLExt .= ",";
            }
            $SQLExt .= $Self->{DBObject}->Quote($_);
            $Exists = 1;
        }
        $SQLExt .= ")";
    }
    # created priority lookup
    if ($Param{CreatedPriorities} && ref($Param{CreatedPriorities}) eq 'ARRAY') {
        foreach (@{$Param{CreatedPriorities}}) {
            my $ID = $Self->{PriorityObject}->PriorityLookup(Priority => $_);
            if ($ID) {
                push (@{$Param{CreatedPriorityIDs}}, $ID);
            }
            else {
                return;
            }
        }
    }
    # created priority ids
    if ($Param{CreatedPriorityIDs} && ref($Param{CreatedPriorityIDs}) eq 'ARRAY') {
        my $ID = $Self->HistoryTypeLookup(Type => 'NewTicket');
        if ($ID) {
            $SQLExt .= " AND th.priority_id IN (";
            my $Exists = 0;
            foreach (@{$Param{CreatedPriorityIDs}}) {
                if ($Exists) {
                    $SQLExt .= ",";
                }
                $SQLExt .= $Self->{DBObject}->Quote($_);
                $Exists = 1;
            }
            $SQLExt .= ") AND th.history_type_id = $ID ";
        }
    }
    # current service lookup
    if ($Param{Services} && ref($Param{Services}) eq 'ARRAY') {
        foreach (@{$Param{Services}}) {
            my $ID = $Self->{ServiceObject}->ServiceLookup(Service => $_);
            if ($ID) {
                push (@{$Param{ServiceIDs}}, $ID);
            }
            else {
                return;
            }
        }
    }
    # service ids
    if ($Param{ServiceIDs} && ref($Param{ServiceIDs}) eq 'ARRAY') {
        $SQLExt .= " AND st.service_id IN (";
        my $Exists = 0;
        foreach (@{$Param{ServiceIDs}}) {
            if ($Exists) {
                $SQLExt .= ",";
            }
            $SQLExt .= $Self->{DBObject}->Quote($_);
            $Exists = 1;
        }
        $SQLExt .= ")";
    }
    # current sla lookup
    if ($Param{SLAs} && ref($Param{SLAs}) eq 'ARRAY') {
        foreach (@{$Param{SLAs}}) {
            my $ID = $Self->{SLAObject}->SLALookup(SLA => $_);
            if ($ID) {
                push (@{$Param{SLAIDs}}, $ID);
            }
            else {
                return;
            }
        }
    }
    # sla ids
    if ($Param{SLAIDs} && ref($Param{SLAIDs}) eq 'ARRAY') {
        $SQLExt .= " AND st.sla_id IN (";
        my $Exists = 0;
        foreach (@{$Param{SLAIDs}}) {
            if ($Exists) {
                $SQLExt .= ",";
            }
            $SQLExt .= $Self->{DBObject}->Quote($_);
            $Exists = 1;
        }
        $SQLExt .= ")";
    }
    # watch user ids
    if ($Param{WatchUserIDs} && ref($Param{WatchUserIDs}) eq 'ARRAY') {
        $SQLExt .= " AND tw.user_id IN (";
        my $Exists = 0;
        foreach (@{$Param{WatchUserIDs}}) {
            if ($Exists) {
                $SQLExt .= ",";
            }
            $SQLExt .= $Self->{DBObject}->Quote($_);
            $Exists = 1;
        }
        $SQLExt .= ")";
    }
    # other ticket stuff
    my %FieldSQLMap = (
        TicketNumber => 'st.tn',
        Title => 'st.title',
        CustomerID => 'st.customer_id',
        CustomerUserLogin => 'st.customer_user_id',
    );
    foreach my $Key (sort keys %FieldSQLMap) {
        if (ref($Param{$Key}) eq 'ARRAY') {
            $SQLExt .= " AND LOWER($FieldSQLMap{$Key}) IN (";
            my $Exists = 0;
            foreach my $Key (@{$Param{$Key}}) {
                $Key =~ s/\*/%/gi;
                if ($Exists) {
                    $SQLExt .= ", ";
                }
                else {
                    $Exists = 1;
                }
                $SQLExt .= "LOWER('".$Self->{DBObject}->Quote($Key)."')";
            }
            $SQLExt .= " )";
        }
        elsif ($Param{$Key}) {
            $Param{$Key} =~ s/\*/%/gi;
            $SQLExt .= " AND LOWER($FieldSQLMap{$Key}) LIKE LOWER('".$Self->{DBObject}->Quote($Param{$Key})."')";
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
    foreach (1..16) {
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
    foreach (1..16) {
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
    foreach (1..6) {
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
    # get tickets created older then x minutes
    if ($Param{TicketCreateTimeOlderMinutes}) {
        my $Time = $Self->{TimeObject}->SystemTime()-($Param{TicketCreateTimeOlderMinutes}*60);
        $SQLExt .= " AND st.create_time_unix <= ".$Self->{DBObject}->Quote($Time);
    }
    # get tickets created newer then x minutes
    if ($Param{TicketCreateTimeNewerMinutes}) {
        my $Time = $Self->{TimeObject}->SystemTime()-($Param{TicketCreateTimeNewerMinutes}*60);
        $SQLExt .= " AND st.create_time_unix >= ".$Self->{DBObject}->Quote($Time);
    }
    # get tickets created older then xxxx-xx-xx xx:xx date
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
    # get tickets created newer then xxxx-xx-xx xx:xx date
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
    # get tickets closed older then xxxx-xx-xx xx:xx date
    if ($Param{TicketCloseTimeOlderDate}) {
        # check time format
        if ($Param{TicketCloseTimeOlderDate} !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "No valid time format '$Param{TicketCloseTimeOlderDate}'!",
            );
            return;
        }
        else {
            # get close state ids
            my @List = $Self->{StateObject}->StateGetStatesByType(
                StateType => ['closed'],
                Result => 'ID',
            );
            my $ID = $Self->HistoryTypeLookup(Type => 'StateUpdate');
            if ($ID) {
                $SQLExt .= " AND th.history_type_id = $ID AND ".
                    " th.state_id IN (${\(join ', ', @List)}) AND ".
                    "th.change_time <= '".$Self->{DBObject}->Quote($Param{TicketCloseTimeOlderDate})."'";
            }
        }
    }
    # get tickets closed newer then xxxx-xx-xx xx:xx date
    if ($Param{TicketCloseTimeNewerDate}) {
        if ($Param{TicketCloseTimeNewerDate} !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "No valid time format '$Param{TicketCloseTimeNewerDate}'!",
            );
            return;
        }
        else {
            # get close state ids
            my @List = $Self->{StateObject}->StateGetStatesByType(
                StateType => ['closed'],
                Result => 'ID',
            );
            my $ID = $Self->HistoryTypeLookup(Type => 'StateUpdate');
            if ($ID) {
                $SQLExt .= " AND th.history_type_id = $ID AND ".
                    " th.state_id IN (${\(join ', ', @List)}) AND ".
                    " th.change_time >= '".$Self->{DBObject}->Quote($Param{TicketCloseTimeNewerDate})."'";
            }
        }
    }
    # check if only pending states are used
    if ($Param{TicketPendingTimeOlderMinutes} || $Param{TicketPendingTimeNewerMinutes} ||
        $Param{TicketPendingTimeOlderDate} || $Param{TicketPendingTimeNewerDate}) {
        # get close state ids
        my @List = $Self->{StateObject}->StateGetStatesByType(
            StateType => ['pending reminder', 'pending auto'],
            Result => 'ID',
        );
        if (@List) {
            $SQLExt .= " AND st.ticket_state_id IN (${\(join ', ', @List)}) ";
        }
    }
    # get tickets pending older then x minutes
    if ($Param{TicketPendingTimeOlderMinutes}) {
        my $Time = $Self->{TimeObject}->SystemTime()-($Param{TicketPendingTimeOlderMinutes}*60);
        $SQLExt .= " AND st.until_time <= ".$Self->{DBObject}->Quote($Time);
    }
    # get tickets pending newer then x minutes
    if ($Param{TicketPendingTimeNewerMinutes}) {
        my $Time = $Self->{TimeObject}->SystemTime()-($Param{TicketPendingTimeNewerMinutes}*60);
        $SQLExt .= " AND st.until_time >= ".$Self->{DBObject}->Quote($Time);
    }
    # get pending tickets older then xxxx-xx-xx xx:xx date
    if ($Param{TicketPendingTimeOlderDate}) {
        # check time format
        if ($Param{TicketPendingTimeOlderDate} !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "No valid time format '$Param{TicketPendingTimeOlderDate}'!",
            );
            return;
        }
        else {
            $Param{TicketPendingTimeOlderDate} = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $Param{TicketPendingTimeOlderDate},
            );
            $SQLExt .= " AND st.until_time <= '".$Self->{DBObject}->Quote($Param{TicketPendingTimeOlderDate})."'";
        }
    }
    # get pending tickets newer then xxxx-xx-xx xx:xx date
    if ($Param{TicketPendingTimeNewerDate}) {
        if ($Param{TicketPendingTimeNewerDate} !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "No valid time format '$Param{TicketPendingTimeNewerDate}'!",
            );
            return;
        }
        else {
            $Param{TicketPendingTimeNewerDate} = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $Param{TicketPendingTimeNewerDate},
            );
            $SQLExt .= " AND st.until_time >= '".$Self->{DBObject}->Quote($Param{TicketPendingTimeNewerDate})."'";
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

    my %Ticket = $Self->TicketGet(%Param);
    # check lock state
    if ($Ticket{Lock} =~ /^lock$/i) {
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
        SendNoNotification => 0, # optional 1|0 (send no agent and customer notification)
        UserID => 123,
    );

    $TicketObject->LockSet(
        LockID => 1,
        TicketID => 123,
        SendNoNotification => 0, # optional 1|0 (send no agent and customer notification)
        UserID => 123,
    );

=cut

sub LockSet {
    my $Self = shift;
    my %Param = @_;
    # lookup!
    if ((!$Param{LockID}) && ($Param{Lock})) {
        $Param{LockID} = $Self->{LockObject}->LockLookup(Lock => $Param{Lock});
    }
    if (($Param{LockID}) && (!$Param{Lock})) {
        $Param{Lock} = $Self->{LockObject}->LockLookup(LockID => $Param{LockID});
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
    foreach (qw(TicketID LockID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
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
            my %Ticket = $Self->TicketGet(%Param);
            # check if the current user is the current owner, if not send a notify
            my $To = '';
            my $Notification = defined $Param{Notification} ? $Param{Notification} : 1;
            if (!$Param{SendNoNotification} && $Ticket{OwnerID} ne $Param{UserID} && $Notification) {
                # get user data of owner
                my %Preferences = $Self->{UserObject}->GetUserData(
                    UserID => $Ticket{OwnerID},
                    Valid => 1,
                );
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
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketLockUpdate',
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

    $TicketObject->StateSet(
        State => 'open',
        TicketID => 123,
        SendNoNotification => 0, # optional 1|0 (send no agent and customer notification)
        UserID => 123,
    );

    $TicketObject->StateSet(
        StateID => 3,
        TicketID => 123,
        SendNoNotification => 0, # optional 1|0 (send no agent and customer notification)
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
    foreach (qw(TicketID ID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
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
        if ($State{TypeName} ne 'closed' && $Ticket{StateType} eq 'closed') {
            $Self->TicketEscalationStartUpdate(
                EscalationStartTime => $Self->{TimeObject}->SystemTime(),
                TicketID => $Param{TicketID},
                UserID => $Param{UserID},
            );
        }
        # set close time it ticket gets closed the first time
        if ($State{TypeName} eq 'closed') {
            # check if it's already set
            my $SolutionTime = 0;
            my $SQL = "SELECT escalation_solution_time FROM ticket " .
                " WHERE id = $Param{TicketID}";
            $Self->{DBObject}->Prepare(SQL => $SQL);
            while (my @Row = $Self->{DBObject}->FetchrowArray()) {
                $SolutionTime = $Row[0];
            }
            # set it
            if (!$SolutionTime) {
                $Self->TicketEscalationSolutionTimeUpdate(
                    EscalationSolutionTime => $Self->{TimeObject}->SystemTime(),
                    TicketID => $Param{TicketID},
                    UserID => $Param{UserID},
                );
            }
        }
        # send customer notification email
        if (!$Param{SendNoNotification}) {
            $Self->SendCustomerNotification(
                Type => 'StateUpdate',
                CustomerMessageParams => \%Param,
                TicketID => $Param{TicketID},
                UserID => $Param{UserID},
            );
        }
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketStateUpdate',
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
    elsif ($Param{Action}) {
        if (ref($Self->{ConfigObject}->Get("Ticket::Frontend::$Param{Action}")->{StateType}) ne 'ARRAY') {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need config for Ticket::Frontend::$Param{Action}->StateType!");
            return;
        }
        my @StateType = @{$Self->{ConfigObject}->Get("Ticket::Frontend::$Param{Action}")->{StateType}};
        %States = $Self->{StateObject}->StateGetStatesByType(
            StateType => \@StateType,
            Result => 'HASH',
        );
    }
    # get whole states list
    else {
        %States = $Self->{StateObject}->StateList(
            UserID => $Param{UserID},
        );
    }
    # workflow
    if ($Self->TicketAcl(
        %Param,
        ReturnType => 'Ticket',
        ReturnSubType => 'State',
        Data => \%States,
    )) {
        return $Self->TicketAclData();
    }
    return %States;
}

=item OwnerCheck()

to get the ticket owner

    my ($OwnerID, $Owner) = $TicketObject->OwnerCheck(
        TicketID => 123,
    );

or for access control

    my $AccessOk = $TicketObject->OwnerCheck(
        TicketID => 123,
        OwnerID => 321,
    );

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
    foreach (qw(TicketID OwnerID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # db query
    if ($Param{OwnerID}) {
        # check cache
        if (defined($Self->{OwnerCheck}->{$Param{OwnerID}})) {
            return $Self->{OwnerCheck}->{$Param{OwnerID}};
        }
        $SQL = "SELECT user_id " .
        " FROM " .
        " ticket " .
        " WHERE " .
        " id = $Param{TicketID} " .
        " AND " .
        " (user_id = $Param{OwnerID} OR responsible_user_id = $Param{OwnerID})";
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
    if ($Param{OwnerID}) {
        if ($Param{SearchUserID}) {
            # fill cache
            $Self->{OwnerCheck}->{$Param{OwnerID}} = 1;
            return 1;
        }
        else {
            # fill cache
            $Self->{OwnerCheck}->{$Param{OwnerID}} = 0;
            return;
        }
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
        SendNoNotification => 0, # optional 1|0 (send no agent and customer notification)
        UserID => 123,
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
        $Param{NewUserID} = $Self->{UserObject}->UserLookup(UserLogin => $Param{NewUser});
    }
    # lookup if no NewUser is given
    if (!$Param{NewUser}) {
        $Param{NewUser} = $Self->{UserObject}->UserLookup(UserID => $Param{NewUserID});
    }
    # check if update is needed!
    my ($OwnerID, $Owner) = $Self->OwnerCheck(TicketID => $Param{TicketID});
    if ($OwnerID eq $Param{NewUserID}) {
        # update is "not" needed!
        return 1;
    }
    # db quote
    foreach (qw(TicketID NewUserID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
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
        if (!$Param{SendNoNotification}) {
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
        }
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketOwnerUpdate',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        # set responsible if first change
        if ($Self->{ConfigObject}->Get('Ticket::Responsible') &&
            $Self->{ConfigObject}->Get('Ticket::ResponsibleAutoSet')) {
            my %Ticket = $Self->TicketGet(
                TicketID => $Param{TicketID},
                UserID => $Param{UserID},
            );
            if ($Ticket{ResponsibleID} == 1 && $Param{NewUserID} != 1) {
                # check responible update
                $Self->ResponsibleSet(
                    TicketID => $Param{TicketID},
                    NewUserID => $Param{NewUserID},
                    SendNoNotification => 1,
                    UserID => $Param{UserID},
                );
            }
        }
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
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
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
                if ($2 ne 1) {
                    $LastOwner = $2;
                    push (@User, $2);
                }
            }
        }
    }
    my @UserInfo = ();
    foreach (@User) {
        my %User = $Self->{UserObject}->GetUserData(UserID => $_, Cache => 1, Valid => 1);
        if (%User) {
            push (@UserInfo, \%User);
        }
    }
    return @UserInfo;
}

=item ResponsibleSet()

to set the ticket responsible (notification to the new responsible will be sent)

    $TicketObject->ResponsibleSet(
        TicketID => 123,
        NewUserID => 555,
        SendNoNotification => 0, # optional 1|0 (send no agent and customer notification)
        UserID => 213,
    );

=cut

sub ResponsibleSet {
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
        $Param{NewUserID} = $Self->{UserObject}->UserLookup(UserLogin => $Param{NewUser})||return;
    }
    # lookup if no NewUser is given
    if (!$Param{NewUser}) {
        $Param{NewUser} = $Self->{UserObject}->UserLookup(UserID => $Param{NewUserID})||return;
    }
    # check if update is needed!
    my %Ticket = $Self->TicketGet(TicketID => $Param{TicketID}, UserID => $Param{NewUserID});
    if ($Ticket{ResponsibleID} eq $Param{NewUserID}) {
        # update is "not" needed!
#        return 1;
    }
    # db quote
    foreach (qw(TicketID NewUserID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # db update
    my $SQL = "UPDATE ticket SET responsible_user_id = $Param{NewUserID}, " .
    " change_time = current_timestamp, change_by = $Param{UserID} " .
    " WHERE id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # add history
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            CreateUserID => $Param{UserID},
            HistoryType => 'ResponsibleUpdate',
            Name => "\%\%$Param{NewUser}\%\%$Param{NewUserID}",
        );
        # clear ticket cache
        $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
        # send agent notify
        if (!$Param{SendNoNotification}) {
            if ($Param{UserID} ne $Param{NewUserID} &&
                $Param{NewUserID} ne $Self->{ConfigObject}->Get('PostmasterUserID')) {
                if (!$Param{Comment}) {
                    $Param{Comment} = '';
                }
                # get user data
                my %Preferences = $Self->{UserObject}->GetUserData(UserID => $Param{NewUserID});
                # send agent notification
                $Self->SendAgentNotification(
                    Type => 'ResponsibleUpdate',
                    UserData => \%Preferences,
                    CustomerMessageParams => \%Param,
                    TicketID => $Param{TicketID},
                    UserID => $Param{UserID},
                );
            }
#            # send customer notification email
#            my %Preferences = $Self->{UserObject}->GetUserData(UserID => $Param{NewUserID});
#            $Self->SendCustomerNotification(
#                Type => 'ResponsibleUpdate',
#                CustomerMessageParams => \%Preferences,
#                TicketID => $Param{TicketID},
#                UserID => $Param{UserID},
#            );
        }
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketResponsibleUpdate',
            UserID => $Param{UserID},
            TicketID => $Param{TicketID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item ResponsibleList()

returns the responsible in the past as array with hash ref of the owner data
(name, email, ...)

    my @Responsible = $TicketObject->ResponsibleList(
        TicketID => 123,
    );

=cut

sub ResponsibleList {
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
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # db query
    my @User = ();
    my $LastResponsible = 1;
    my $SQL = "SELECT sh.name, ht.name, sh.create_by ".
        " FROM ".
        " ticket_history sh, ticket_history_type ht ".
        " WHERE ".
        " sh.ticket_id = $Param{TicketID} ".
        " AND ".
        " ht.name IN ('ResponsibleUpdate', 'NewTicket')  ".
        " AND ".
        " ht.id = sh.history_type_id".
        " ORDER BY sh.id";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        if ($Row[1] eq 'NewTicket' && $Row[2] ne '1' && $LastResponsible ne $Row[2]) {
            $LastResponsible = $Row[2];
            push (@User, $Row[2]);
        }
        elsif ($Row[1] eq 'ResponsibleUpdate') {
            if ($Row[0] =~ /^New Responsible is '(.+?)' \(ID=(.+?)\)/ || $Row[0] =~ /^\%\%(.+?)\%\%(.+?)$/) {
                $LastResponsible = $2;
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
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
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
        my %User = $Self->{UserObject}->GetUserData(
            UserID => $_,
            Valid => 1,
            Cache => 1,
        );
        if (%User) {
            push (@UserInfo, \%User);
        }
    }
    return @UserInfo;
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
        $Param{PriorityID} = $Self->{PriorityObject}->PriorityLookup(Priority => $Param{Priority});
    }
    if ($Param{PriorityID} && !$Param{Priority}) {
        $Param{Priority} = $Self->{PriorityObject}->PriorityLookup(PriorityID => $Param{PriorityID});
    }
    # check needed stuff
    foreach (qw(TicketID UserID PriorityID Priority)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my %Ticket = $Self->TicketGet(%Param);
    # check if update is needed
    if ($Ticket{Priority} eq $Param{Priority}) {
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
    foreach (qw(TicketID PriorityID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # db update
    my $SQL = "UPDATE ticket SET ticket_priority_id = $Param{PriorityID}, " .
        " change_time = current_timestamp, change_by = $Param{UserID} " .
        " WHERE id = $Param{TicketID} ";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # add history
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            QueueID => $Ticket{QueueID},
            CreateUserID => $Param{UserID},
            HistoryType => 'PriorityUpdate',
            Name => "\%\%$Ticket{Priority}\%\%$Ticket{PriorityID}".
                "\%\%$Param{Priority}\%\%$Param{PriorityID}",
        );
        # clear ticket cache
        $Self->{'Cache::GetTicket'.$Param{TicketID}} = 0;
        # ticket event
        $Self->TicketEventHandlerPost(
            Event => 'TicketPriorityUpdate',
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
    # workflow
    if ($Self->TicketAcl(
        %Param,
        ReturnType => 'Ticket',
        ReturnSubType => 'Priority',
        Data => \%Data,
    )) {
        return $Self->TicketAclData();
    }
    return %Data;
}

=item HistoryTicketStatusGet()

to get the priority list for a ticket (depends on workflow, if configured)

    my %Tickets = $TicketObject->HistoryTicketStatusGet(
        StartDay => 12,
        StartMonth => 1,
        StartYear => 2006,
        StopDay => 18,
        StopMonth => 1,
        StopYear => 2006,
        Force => 0,
    );

=cut

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
    foreach (qw(StopYear StopMonth StopDay StartYear StartMonth StartDay)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQLExt = '';
    foreach (qw(NewTicket FollowUp OwnerUpdate PriorityUpdate CustomerUpdate StateUpdate
        TicketFreeTextUpdate PhoneCallCustomer Forward Bounce SendAnswer EmailCustomer
        PhoneCallAgent WebRequestCustomer)) {
        my $ID = $Self->HistoryTypeLookup(Type => $_);
        if (!$SQLExt) {
            $SQLExt = "AND history_type_id IN ($ID";
        }
        else {
            $SQLExt .= ",$ID";
        }
    }
    if ($SQLExt) {
        $SQLExt .= ')';
    }
    my $SQL = "SELECT DISTINCT(th.ticket_id), th.create_time FROM ".
        "ticket_history th ".
        "WHERE ".
        "th.create_time <= '$Param{StopYear}-$Param{StopMonth}-$Param{StopDay} 23:59:59' ".
        "AND ".
        "th.create_time >= '$Param{StartYear}-$Param{StartMonth}-$Param{StartDay} 00:00:01' ".
        "$SQLExt ".
        "ORDER BY th.create_time DESC";
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 150000);
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
        Force => 0,
    );

returns

    TicketNumber
    TicketID
    Type
    TypeID
    Queue
    QueueID
    Priority
    PriorityID
    State
    StateID
    Owner
    OwnerID
    CreateUserID
    CreateTime (timestamp)
    CreateOwnerID
    CreatePriority
    CreatePriorityID
    CreateState
    CreateStateID
    CreateQueue
    CreateQueueID
    LockFirst (timestamp)
    LockLast (timestamp)
    UnlockFirst (timestamp)
    UnlockLast (timestamp)

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
    my $Path = $Self->{ConfigObject}->Get('Home')."/var/tmp/TicketHistoryCache/$Param{StopYear}/$Param{StopMonth}/";
    my $File = $Self->{MainObject}->FilenameCleanUp(
        Filename => "TicketHistoryCache-$Param{TicketID}-$Param{StopYear}-$Param{StopMonth}-$Param{StopDay}.cache",
        Type => 'local',
    );
    # write cache
    if (!$Param{Force} && -f "$Path/$File") {
        if (open (DATA, "< $Path/$File")) {
            while (<DATA>) {
                if ($_ =~ /^(.+?):(.+?)$/) {
                    $Ticket{$1} = $2;
                }
            }
            close (DATA);
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
    foreach (qw(TicketID StopYear StopMonth StopDay)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "SELECT th.name, tht.name, th.create_time, th.create_by, th.ticket_id, ".
        "th.article_id, th.queue_id, th.state_id, th.priority_id, th.owner_id, th.type_id ".
        " FROM ".
        "ticket_history th, ticket_history_type tht ".
        "WHERE ".
        "th.history_type_id = tht.id ".
        "AND ".
        "th.ticket_id = $Param{TicketID} ".
        "AND ".
        "th.create_time <= '$Param{StopYear}-$Param{StopMonth}-$Param{StopDay} 23:59:59' ".
        "ORDER BY th.create_time, th.id ASC";
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 3000);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        if ($Row[1] eq 'NewTicket') {
            if ($Row[0] =~ /^\%\%(.+?)\%\%(.+?)\%\%(.+?)\%\%(.+?)\%\%(.+?)$/ ||
                $Row[0] =~ /Ticket=\[(.+?)\],.+?Q\=(.+?);P\=(.+?);S\=(.+?)/) {
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
                # COMPAT: compat to 1.1
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
        # COMPAT: compat to 1.1
        elsif ($Row[1] eq 'PhoneCallCustomer') {
            $Ticket{TicketVersion} = '1.1';
            $Ticket{TicketID} = $Row[4];
            $Ticket{CreateUserID} = $Row[3];
            $Ticket{CreateTime} = $Row[2];
        }
        elsif ($Row[1] eq 'Move') {
            if ($Row[0] =~ /^\%\%(.+?)\%\%(.+?)\%\%(.+?)\%\%(.+?)/ ||
                $Row[0] =~ /^Ticket moved to Queue '(.+?)'/) {
                $Ticket{Queue} = $1;
            }
        }
        elsif ($Row[1] eq 'StateUpdate' ||
            $Row[1] eq 'Close successful' ||
            $Row[1] eq 'Close unsuccessful' ||
            $Row[1] eq 'Open' ||
            $Row[1] eq 'Misc') {
            if ($Row[0] =~ /^\%\%(.+?)\%\%(.+?)(\%\%|)$/ ||
                $Row[0] =~ /^Old: '(.+?)' New: '(.+?)'/ ||
                $Row[0] =~ /^Changed Ticket State from '(.+?)' to '(.+?)'/) {
                $Ticket{State} = $2;
                $Ticket{StateTime} = $Row[2];
            }
        }
        elsif ($Row[1] eq 'TicketFreeTextUpdate') {
            if ($Row[0] =~ /^\%\%(.+?)\%\%(.+?)\%\%(.+?)\%\%(.+?)$/) {
                $Ticket{'Ticket'.$1} = $2;
                $Ticket{'Ticket'.$3} = $4;
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
        elsif ($Row[1] eq 'Lock') {
            if (!$Ticket{LockFirst}) {
                $Ticket{LockFirst} = $Row[2];
            }
            $Ticket{LockLast} = $Row[2];
        }
        elsif ($Row[1] eq 'Unlock') {
            if (!$Ticket{UnlockFirst}) {
                $Ticket{UnlockFirst} = $Row[2];
            }
            $Ticket{UnlockLast} = $Row[2];
        }
        # get default options
        $Ticket{TypeID} = $Row[10] || '';
        $Ticket{OwnerID} = $Row[9] || '';
        $Ticket{PriorityID} = $Row[8] || '';
        $Ticket{StateID} = $Row[7] || '';
        $Ticket{QueueID} = $Row[6] || '';
    }
    if (!%Ticket) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "No such TicketID in ticket history till ".
                "'$Param{StopYear}-$Param{StopMonth}-$Param{StopDay} 23:59:59' ($Param{TicketID})!",
        );
        return;
    }
    else {
        # update old ticket info
        my %CurrentTicketData = $Self->TicketGet(TicketID => $Ticket{TicketID});
        foreach (qw(State Priority Queue TicketNumber)) {
            if (!$Ticket{$_}) {
                $Ticket{$_} = $CurrentTicketData{$_};
            }
            if (!$Ticket{"Create$_"}) {
                $Ticket{"Create$_"} = $CurrentTicketData{$_};
            }
        }
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
    foreach (qw(Type)) {
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
        TypeID => 123, # not required!
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
    # get ValidID!
    if (!$Param{ValidID}) {
        $Param{ValidID} = $Self->{ValidObject}->ValidIDsGet();
    }
    # get QueueID
    if (!$Param{QueueID}) {
        $Param{QueueID} = $Self->TicketQueueID(TicketID => $Param{TicketID});
    }
    # get type
    if (!$Param{TypeID}) {
        my %Ticket = $Self->TicketGet(%Param);
        $Param{TypeID} = $Ticket{TypeID};
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
    foreach (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(TicketID HistoryTypeID QueueID OwnerID PriorityID StateID ValidID CreateUserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    if (!$Param{ArticleID}) {
        $Param{ArticleID} = 'NULL';
    }
    else {
        $Param{ArticleID} = $Self->{DBObject}->Quote($Param{ArticleID}, 'Integer');
    }
    # db insert
    my $SQL = "INSERT INTO ticket_history " .
        " (name, history_type_id, ticket_id, article_id, queue_id, owner_id, ".
        " priority_id, state_id, type_id, valid_id, " .
        " create_time, create_by, change_time, change_by) " .
        "VALUES " .
        "('$Param{Name}', $Param{HistoryTypeID}, $Param{TicketID}, ".
        " $Param{ArticleID}, $Param{QueueID}, $Param{OwnerID}, $Param{PriorityID}, ".
        " $Param{StateID}, $Param{TypeID}, $Param{ValidID}, " .
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
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
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
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
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
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
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
        $Row[0] =~ s/,/./g;
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
    foreach (qw(TicketID ArticleID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    foreach (qw(TimeUnit)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Number');
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
    foreach (qw(MainTicketID MergeTicketID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # change ticket id of merge ticket to main ticket
    if ($Self->{DBObject}->Do(SQL => "UPDATE article SET ticket_id = $Param{MainTicketID} WHERE ticket_id = $Param{MergeTicketID}")) {
        my %MainTicket = $Self->TicketGet(TicketID => $Param{MainTicketID});
        my %MergeTicket = $Self->TicketGet(TicketID => $Param{MergeTicketID});
        # add merge article to merge ticket
        $Self->ArticleCreate(
            TicketID => $Param{MergeTicketID},
            SenderType => 'agent',
            ArticleType => 'note-external',
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
        $Self->LockSet(
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

=item TicketWatchGet()

to get all additional attributes of an watched ticket

    my %Watch = $TicketObject->TicketWatchGet(
        TicketID => 111,
        UserID => 123
    );

=cut

sub TicketWatchGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID UserID)) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # quote
    foreach (qw(TicketID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get all attributes of an watched ticket
    my $SQL = "SELECT create_time, create_by, change_time, change_by".
        " FROM ticket_watcher WHERE ticket_id = $Param{TicketID} AND user_id = $Param{UserID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    # fetch the result
    my %Data = ();
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{CreateTime} = $Row[0];
        $Data{CreateBy} = $Row[1];
        $Data{ChangeTime} = $Row[2];
        $Data{ChangeBy} = $Row[3];
    }
    return %Data;
}

=item TicketWatchSubscribe()

to subscribe a ticket to watch it

    $TicketObject->TicketWatchSubscribe(
        TicketID => 111,
        UserID => 123,
    );

=cut

sub TicketWatchSubscribe {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID UserID)) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    foreach (qw(TicketID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "DELETE FROM ticket_watcher " .
        " WHERE " .
        " ticket_id = $Param{TicketID} AND ".
        " user_id = $Param{UserID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        my $SQL = "INSERT INTO ticket_watcher (ticket_id, user_id, create_time, create_by, change_time, change_by) ".
            " VALUES ".
            " ($Param{TicketID}, ".
            " $Param{UserID}, ".
            " current_timestamp, ".
            " $Param{UserID}, ".
            " current_timestamp, ".
            " $Param{UserID}) ";
        if ($Self->{DBObject}->Do(SQL => $SQL)) {
            # add history
            $Self->HistoryAdd(
                TicketID => $Param{TicketID},
                CreateUserID => $Param{UserID},
                HistoryType => 'Subscribe',
                Name => "Subscribe the ticket to watch it.",
            );
            return 1;
        }
        else {
            return;
        }
    }
    else {
        return;
    }
}

=item TicketWatchUnsubscribe()

to remove a subscribtion of a ticket

    $TicketObject->TicketWatchUnsubscribe(
        TicketID => 111,
        UserID => 123,
    );

=cut

sub TicketWatchUnsubscribe {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID UserID)) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    foreach (qw(TicketID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "DELETE FROM ticket_watcher " .
        " WHERE " .
        " ticket_id = $Param{TicketID} AND ".
        " user_id = $Param{UserID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # add history
        $Self->HistoryAdd(
            TicketID => $Param{TicketID},
            CreateUserID => $Param{UserID},
            HistoryType => 'Unsubscribe',
            Name => "Unsubscribe the ticket to watch it no longer.",
        );
        return 1;
    }
    else {
        return;
    }
}

=item TicketAcl()

prepare ACL execution of current state

    $TicketObject->TicketAcl(
        Data => '-',
        Action => 'AgentTicketZoom',
        TicketID => 123,
        ReturnType => 'Action',
        ReturnSubType => '-',
        UserID => 123,
    );

    or

    $TicketObject->TicketAcl(
        Data => {
            1 => 'new',
            2 => 'open',
            # ...
        },
        ReturnType => 'Ticket',
        ReturnSubType => 'State',
    )

=cut

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
    if ((!$Self->{ConfigObject}->Get('TicketAcl') && !$Self->{ConfigObject}->Get('Ticket::EventModulePost')) || ($Param{UserID} && $Param{UserID} == 1)) {
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
    # check acl config
    my %Acls = ();
    if ($Self->{ConfigObject}->Get('TicketAcl')) {
        %Acls = %{$Self->{ConfigObject}->Get('TicketAcl')};
    }
    # check acl module
    my $Modules = $Self->{ConfigObject}->Get('Ticket::Acl::Module');
    if ($Modules) {
        foreach my $Module (sort keys %{$Modules}) {
            if ($Self->{MainObject}->Require($Modules->{$Module}->{Module})) {
                my $Generic = $Modules->{$Module}->{Module}->new(
                    %{$Self},
                    TicketObject => $Self,
                );
                $Generic->Run(
                    %Param,
                    Acl => \%Acls,
                    Config => $Modules->{$Module},
                );
            }
        }
    }

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
        foreach my $Key (keys %{$Step{Properties}}) {
            foreach my $Data (keys %{$Step{Properties}->{$Key}}) {
                my $Match2 = 0;
                foreach (@{$Step{Properties}->{$Key}->{$Data}}) {
                    if (ref($Checks{$Key}->{$Data}) eq 'ARRAY') {
                        foreach my $Array (@{$Checks{$Key}->{$Data}}) {
                            if ($_ eq $Array) {
                                $Match2 = 1;
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
                    elsif (defined($Checks{$Key}->{$Data})) {
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
        # check force option
        if ($ForceMatch) {
            $Match = 1;
            $Match3 = 1;
        }
        # debug log
        my %NewTmpData = ();
        if ($Match && $Match3) {
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

=item TicketAclData()

return the current ACL data hash after TicketAcl()

    my %Acl = $TicketObject->TicketAclData();

=cut

sub TicketAclData {
    my $Self = shift;
    my %Param = @_;
    return %{$Self->{TicketAclData}};
}

=item TicketAclActionData()

return the current ACL action data hash after TicketAcl()

    my %AclAction = $TicketObject->TicketAclActionData();

=cut

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

=item TicketEventHandlerPost()

call ticket event post handler, returns true if it's executed successfully

    $TicketObject->TicketEventHandlerPost(
        TicketID => 123,
        Event => 'TicketStateUpdate',
        UserID => 123,
    );

events available:

TicketCreate, TicketDelete, TicketTitleUpdate, TicketUnlockTimeoutUpdate,
TicketEscalationStartUpdate, TicketQueueUpdate, TicketTypeUpdate, TicketServiceUpdate,
TicketSLAUpdate, TicketCustomerUpdate, TicketFreeTextUpdate, TicketFreeTimeUpdate,
TicketPendingTimeUpdate, TicketLockUpdate, TicketStateUpdate, TicketOwnerUpdate,
TicketResponsibleUpdate, TicketPriorityUpdate, HistoryAdd, HistoryDelete,
TicketAccountTime, TicketMerge, ArticleCreate, ArticleFreeTextUpdate,
ArticleUpdate, ArticleSend, ArticleBounce, ArticleAgentNotification,
ArticleCustomerNotification, ArticleAutoResponse, ArticleFlagSet;

=cut

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
            if (!$Modules->{$Module}->{Event} || $Param{Event} =~ /$Modules->{$Module}->{Event}/i) {
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
        # COMPAT: compat to 2.0
        if (1 && !$Param{CompatOff}) {
            my $Hit = 0;
            if ($Param{Event} eq 'TicketStateUpdate') {
                $Hit = 1;
                $Param{Event} = 'StateSet';
            }
            elsif ($Param{Event} eq 'TicketPriorityUpdate') {
                $Hit = 1;
                $Param{Event} = 'PrioritySet';
            }
            elsif ($Param{Event} eq 'TicketLockUpdate') {
                $Hit = 1;
                $Param{Event} = 'LockSet';
            }
            elsif ($Param{Event} eq 'TicketOwnerUpdate') {
                $Hit = 1;
                $Param{Event} = 'OwnerSet';
            }
            elsif ($Param{Event} eq 'TicketQueueUpdate') {
                $Hit = 1;
                $Param{Event} = 'MoveTicket';
            }
            elsif ($Param{Event} eq 'TicketCustomerUpdate') {
                $Hit = 1;
                $Param{Event} = 'SetCustomerData';
            }
            elsif ($Param{Event} eq 'TicketFreeTextUpdate') {
                $Hit = 1;
                $Param{Event} = 'TicketFreeTextSet';
            }
            elsif ($Param{Event} eq 'TicketFreeTimeUpdate') {
                $Hit = 1;
                $Param{Event} = 'TicketFreeTimeSet';
            }
            elsif ($Param{Event} eq 'TicketPendingTimeUpdate') {
                $Hit = 1;
                $Param{Event} = 'TicketPendingTimeSet';
            }
            elsif ($Param{Event} eq 'ArticleFreeTextUpdate') {
                $Hit = 1;
                $Param{Event} = 'ArticleFreeTextSet';
            }
            elsif ($Param{Event} eq 'ArticleAgentNotification') {
                $Hit = 1;
                $Param{Event} = 'SendAgentNotification';
            }
            elsif ($Param{Event} eq 'ArticleCustomerNotification') {
                $Hit = 1;
                $Param{Event} = 'SendCustomerNotification';
            }
            elsif ($Param{Event} eq 'ArticleAutoResponse') {
                $Hit = 1;
                $Param{Event} = 'SendAutoResponse';
            }
            if ($Hit) {
                return $Self->TicketEventHandlerPost(%Param, CompatOff => 1);
            }
        }
    }
    return 1;
}
1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=head1 VERSION

$Revision: 1.267 $ $Date: 2007-07-26 16:41:47 $

=cut
