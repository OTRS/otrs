# --
# Kernel/System/Queue.pm - lib for queue functions
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: Queue.pm,v 1.62 2006-11-02 12:20:53 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Queue;

use strict;
use Kernel::System::StdResponse;
use Kernel::System::Group;
use Kernel::System::CustomerGroup;

use vars qw($VERSION);
$VERSION = '$Revision: 1.62 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Queue - queue lib

=head1 SYNOPSIS

All queue functions. E. g. to add queue or other functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    $Self->{QueueID} = $Param{QueueID} || ''; #die "Got no QueueID!";

    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # lib object
    $Self->{StdResponseObject} = Kernel::System::StdResponse->new(%Param);
    if (!$Param{GroupObject}) {
        $Self->{GroupObject} = Kernel::System::Group->new(%Param);
    }
    else {
        $Self->{GroupObject} = $Param{GroupObject};
    }
    if (!$Param{CustomerGroupObject}) {
        $Self->{CustomerGroupObject} = Kernel::System::CustomerGroup->new(%Param);
    }
    else {
        $Self->{CustomerGroupObject} = $Param{CustomerGroupObject};
    }

    # --------------------------------------------------- #
    #  default queue  settings                            #
    #  these settings are used by the CLI version         #
    # --------------------------------------------------- #
    $Self->{QueueDefaults} = {
        UnlockTimeout => 0,
        EscalationTime => 0,
        FollowUpLock => 0,
        SystemAddressID => 1,
        SalutationID => 1,
        SignatureID => 1,
        FollowUpID => 1,
        FollowUpLock => 0,
        MoveNotify => 0,
        LockNotify => 0,
        StateNotify => 0,
    };

    return $Self;
}

=item GetSystemAddress()

get a queue system email address as hash (Email, RealName)

    my %Adresss = $Self->{QueueObject}->GetSystemAddress(
        QueueID => 123,
    );

=cut

sub GetSystemAddress {
    my $Self = shift;
    my %Param = @_;
    my %Address;
    my $QueueID = $Param{QueueID} || $Self->{QueueID};
    my $SQL = "SELECT sa.value0, sa.value1 FROM system_address sa, queue sq ".
        " WHERE ".
        " sq.id = ".$Self->{DBObject}->Quote($QueueID, 'Integer')." ".
        " and ".
        " sa.id = sq.system_address_id";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Address{Email} = $Row[0];
        $Address{RealName} = $Row[1];
    }
    # prepare realname quote
    if ($Address{RealName} =~ /(,|@|\(|\)|:)/ && $Address{RealName} !~ /^("|')/) {
        $Address{RealName} =~ s/"/\"/g;
        $Address{RealName} = '"'.$Address{RealName}.'"';
    }
    return %Address;
}

=item GetSalutation()

get a queue salutation

    my $Salutation = $Self->{QueueObject}->GetSalutation(QueueID => 123);

=cut

sub GetSalutation {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{QueueID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need QueueID!");
        return;
    }
    # db quote
    foreach (qw(QueueID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $String = '';
    my $SQL = "SELECT text FROM salutation sa, queue sq ".
        " WHERE ".
        " sq.id = $Param{QueueID} ".
        " and ".
        " sq.salutation_id = sa.id";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $String = $Row[0];
    }
    return $String;
}

=item GetSignature()

get a queue signature

    my $Signature = $Self->{QueueObject}->GetSignature(QueueID => 123);

=cut

sub GetSignature {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{QueueID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need QueueID!");
        return;
    }
    # db quote
    foreach (qw(QueueID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $String = '';
    my $SQL = "SELECT text FROM signature si, queue sq ".
        " WHERE ".
        " sq.id = $Param{QueueID} ".
        " and ".
        " sq.signature_id = si.id";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $String = $Row[0];
    }
    return $String;
}

=item GetStdResponse()

get std response of a queue

    my $String = $Self->{QueueObject}->GetStdResponse(ID => 123);

=cut

sub GetStdResponse {
    my $Self = shift;
    my %Param = @_;
    my $String = '';
    # check needed stuff
    if (!$Param{ID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ID!");
        return;
    }
    # db quote
    foreach (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "SELECT text FROM standard_response".
        " WHERE ".
        " id = $Param{ID} ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $String = $Row[0];
    }
    return $String;
}

# for comapt!
sub SetQueueStdResponse {
    my $Self = shift;
    my %Param = @_;
    unless  ($Param{ResponseID} && $Param{QueueID} && $Param{UserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ResponseID, QueueID and UserID!");
        return;
    }
    if ($Self->QueueHasStdResponse(%Param)){
        return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # sql
    my $SQL = sprintf(qq|INSERT INTO queue_standard_response (queue_id, standard_response_id, create_time, create_by, change_time, change_by)
    VALUES ( %s, %s, current_timestamp, %s, current_timestamp, %s)| , $Param{QueueID}, $Param{ResponseID}, $Param{UserID}, $Param{UserID});
   # print "SQL was\n$SQL\n\n";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return 0;
    }
}

# for comapt!
sub QueueHasStdResponse {
    my $Self = shift;
    my %Param = @_;
    unless  ($Param{ResponseID} && $Param{QueueID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ResponseID and QueueID!");
        return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # sql
    my $SQL = sprintf("select count(*) from  queue_standard_response  where queue_id=%s and standard_response_id=%s" ,  $Param{QueueID}, $Param{ResponseID});
    #print "SQL was\n$SQL\n\n";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    my $Count;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Count = $Row[0];
    }
    return $Count;
}

=item GetStdResponses()

get std responses of a queue

    my %Responses = $Self->{QueueObject}->GetStdResponses(QueueID => 123);

=cut

sub GetStdResponses {
    my $Self = shift;
    my %Param = @_;
    my %StdResponses;
    # check needed stuff
    if (!$Param{QueueID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need QueueID!");
        return;
    }
    # check if this result is present
    if ($Self->{"StdResponses::$Param{QueueID}"}) {
        %StdResponses = %{$Self->{"StdResponses::$Param{QueueID}"}};
        return %StdResponses;
    }
    # get std. responses
    my $SQL = "SELECT sr.id, sr.name ".
        " FROM ".
        " standard_response sr, queue_standard_response qsr".
        " WHERE ".
        " qsr.queue_id IN (".$Self->{DBObject}->Quote($Param{QueueID}, 'Integer').")".
        " AND ".
        " qsr.standard_response_id = sr.id".
        " AND ".
        " sr.valid_id IN ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} )".
        " ORDER BY sr.name";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $StdResponses{$Row[0]} = $Row[1];
    }
    # store std responses
    $Self->{"StdResponses::$Param{QueueID}"} = \%StdResponses;
    # return responses
    return %StdResponses;
}

=item GetAllQueues()

get all system queues

    my %Queues = $Self->{QueueObject}->GetAllQueues();

get all system queues of a user with permission type (e. g. ro, move_into, rw, ...)

    my %Queues = $Self->{QueueObject}->GetAllQueues(UserID => 123, Type => 'ro');

=cut

sub GetAllQueues {
    my $Self = shift;
    my %Param = @_;
    my $UserID = $Param{UserID} || '';
    my $Type = $Param{Type} || 'ro';
    # fetch all queues
    my %MoveQueues;
    if ($Param{UserID}) {
        my @GroupIDs = $Self->{GroupObject}->GroupMemberList(
            UserID => $Param{UserID},
            Type => $Type,
            Result => 'ID',
            Cached => 1,
        );
        if (@GroupIDs) {
            my $SQL = "SELECT id, name FROM queue".
                " WHERE ".
                " group_id IN ( ${\(join ', ', @GroupIDs)} )".
                " AND ".
                " valid_id IN ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} )";
            $Self->{DBObject}->Prepare(SQL => $SQL);
        }
        else {
            return;
        }
    }
    elsif ($Param{CustomerUserID}) {
        my @GroupIDs = $Self->{CustomerGroupObject}->GroupMemberList(
            UserID => $Param{CustomerUserID},
            Type => $Type,
            Result => 'ID',
            Cached => 1,
        );
        if (@GroupIDs) {
            my $SQL = "SELECT id, name FROM queue".
                " WHERE ".
                " group_id IN ( ${\(join ', ', @GroupIDs)} )".
                " AND ".
                " valid_id IN ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} )";
            $Self->{DBObject}->Prepare(SQL => $SQL);
        }
        else {
            return;
        }
    }
    else {
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id, name FROM queue WHERE valid_id IN ".
                "( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} )",
            );
    }
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $MoveQueues{$Row[0]} = $Row[1];
    }
    return %MoveQueues;
}

=item GetAllCustomQueues()

get all custom queues of one user

    my %Queues = $Self->{QueueObject}->GetAllCustomQueues(UserID => 123);

=cut

sub GetAllCustomQueues {
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
    # fetch all queues
    my @QueueIDs;
    my $SQL = "SELECT queue_id FROM personal_queues WHERE user_id = $Param{UserID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push(@QueueIDs, $Row[0]);
    }
    return @QueueIDs;
}

=item QueueLookup()

get id or name for queue

    my $Queue = $QueueObject->QueueLookup(QueueID => $QueueID);

    my $QueueID = $QueueObject->QueueLookup(Queue => $Queue);

=cut

sub QueueLookup {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Queue} && !$Param{QueueID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Got no Queue or QueueID!");
        return;
    }
    # check if we ask the same request (cache)?
    if ($Param{QueueID} && $Self->{"QL::Queue$Param{QueueID}"}) {
        return $Self->{"QL::Queue$Param{QueueID}"};
    }
    if ($Param{Queue} && $Self->{"QL::QueueID$Param{Queue}"}) {
        return $Self->{"QL::QueueID$Param{Queue}"};
    }
    # get data
    my $SQL = '';
    my $Suffix = '';
    if ($Param{Queue}) {
        $Param{What} = $Param{Queue};
        $Suffix = 'QueueID';
        $SQL = "SELECT id FROM queue WHERE name = '".$Self->{DBObject}->Quote($Param{Queue})."'";
    }
    else {
        $Param{What} = $Param{QueueID};
        $Suffix = 'Queue';
        $SQL = "SELECT name FROM queue WHERE id = ".$Self->{DBObject}->Quote($Param{QueueID}, 'Integer')."";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"QL::$Suffix$Param{What}"} = $Row[0];
    }
    # check if data exists
    if (!exists $Self->{"QL::$Suffix$Param{What}"}) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Found no \$$Suffix for $Param{What}!",
        );
        return;
    }
    # return result
    return $Self->{"QL::$Suffix$Param{What}"};
}

=item GetFollowUpOption()

...

    ...

=cut

sub GetFollowUpOption {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{QueueID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need QueueID!");
        return;
    }
    # db quote
    foreach (qw(QueueID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # fetch queues data
    my $Return = '';
    my $SQL = "SELECT sf.name ".
        " FROM ".
        " follow_up_possible sf, queue sq ".
        " WHERE ".
        " sq.follow_up_id = sf.id ".
        " AND ".
        " sq.id = $Param{QueueID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Return = $Row[0];
    }
    return $Return;
}

=item GetFollowUpLockOption()

...

    ...

=cut

sub GetFollowUpLockOption {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{QueueID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need QueueID!");
        return;
    }
    # db quote
    foreach (qw(QueueID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # fetch queues data
    my $Return = 0;
    my $SQL = "SELECT sq.follow_up_lock ".
        " FROM ".
        " queue sq ".
        " WHERE ".
        " sq.id = $Param{QueueID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Return = $Row[0];
    }
    return $Return;
}

=item GetQueueGroupID()

...

    ...

=cut

sub GetQueueGroupID {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{QueueID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need QueueID!");
        return;
    }
    # db quote
    foreach (qw(QueueID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $GID = '';
    my $SQL = "SELECT group_id ".
        " FROM ".
        " queue ".
        " WHERE ".
        " id = $Param{QueueID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $GID = $Row[0];
    }
    return $GID;
}

=item QueueAdd()

add queue with attributes

    $QueueObject->QueueAdd(
        Name            => 'Some::Queue',
        ValidID         => 1,
        GroupID         => 1,
        SystemAddressID => 1,
        SalutationID    => 1,
        SignatureID     => 1,
        UserID          => 123,
        MoveNotify      => 0,
        StateNotify     => 0,
        LockNotify      => 0,
        OwnerNotify     => 0,
    );

=cut

sub QueueAdd {
    my $Self=shift;
    my %Param = @_;
    # Add Queue to the Database

    # Requires
    # Params{GroupID}   : ID of the group responsible for this quese
    # Param{QueueName}  : Duh! Name of the Queue
    # Param{ValidID}    : Is the queue invalid, valid, suspended etc
    # Param{UserID}     : ID of the person creating the Queue

    # Returns
    # new Queue ID on success
    # null/false on failure

    # ' and , are for modems. Line noise
    # A less noisy way to defining @Params is
    my @Params = qw(
        Name
        GroupID
        UnlockTimeout
        SystemAddressID
        Calendar
        DefaultSignKey
        SalutationID
        SignatureID
        FollowUpID
        FollowUpLock
        EscalationTime
        MoveNotify
        StateNotify
        Comment
        ValidID
    );

    for (qw(UnlockTimeout EscalationTime FollowUpLock SystemAddressID SalutationID SignatureID FollowUpID FollowUpLock MoveNotify StateNotify LockNotify OwnerNotify DefaultSignKey Calendar)) {
        # these are coming from Config.pm
        # I added default values in the Load Routine
        $Param{$_} = $Self->{QueueDefaults}{$_} || 0  unless ($Param{$_});
    };

    # check needed stuff
    foreach (qw(Name GroupID SystemAddressID SalutationID SignatureID MoveNotify StateNotify LockNotify OwnerNotify ValidID UserID)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    foreach (qw(Name GroupID SystemAddressID SalutationID SignatureID ValidID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # check queue name
    if ($Param{Name} =~ /::$/i) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Invalid Queue name '$Param{Name}'!",
        );
        return;
    }
    # quote db
    foreach (qw(Name DefaultSignKey Calendar Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    };
    foreach (qw(GroupID UnlockTimeout SystemAddressID SalutationID SignatureID FollowUpID FollowUpLock EscalationTime MoveNotify StateNotify ValidID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "INSERT INTO queue ".
        "(name, ".
        " group_id, ".
        " unlock_timeout, ".
        " system_address_id, ".
        " calendar_name, ".
        " default_sign_key, ".
        " salutation_id, ".
        " signature_id, ".
        " escalation_time, ".
        " follow_up_id, ".
        " follow_up_lock, ".
        " state_notify, ".
        " move_notify, ".
        " lock_notify, ".
        " owner_notify, ".
        " valid_id, ".
        " comments, ".
        " create_time, ".
        " create_by, ".
        " change_time, ".
        " change_by)".
        " VALUES ".
        " ('$Param{Name}', ".
        " $Param{GroupID}, ".
        " $Param{UnlockTimeout}, ".
        " $Param{SystemAddressID}, ".
        " '$Param{Calendar}', ".
        " '$Param{DefaultSignKey}', ".
        " $Param{SalutationID}, ".
        " $Param{SignatureID}, ".
        " $Param{EscalationTime}, ".
        " $Param{FollowUpID}, ".
        " $Param{FollowUpLock}, ".
        " $Param{StateNotify}, ".
        " $Param{MoveNotify}, ".
        " $Param{LockNotify}, ".
        " $Param{OwnerNotify}, ".
        " $Param{ValidID}, ".
        " '$Param{Comment}', ".
        " current_timestamp, ".
        " $Param{UserID}, ".
        " current_timestamp, ".
        " $Param{UserID})";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # get new queue id
        $SQL = "SELECT id ".
            " FROM ".
            " queue ".
            " WHERE ".
            " name = '$Param{Name}'";
        my $QueueID = '';
        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $QueueID = $Row[0];
        }
        # add default responses (if needed), add response by name
        if ($Self->{ConfigObject}->Get('StdResponse2QueueByCreating')) {
            foreach (@{$Self->{ConfigObject}->{StdResponse2QueueByCreating}}) {
                my $StdResponseID = $Self->{StdResponseObject}->StdResponseLookup(StdResponse => $_);
                if ($StdResponseID) {
                    $Self->SetQueueStdResponse(
                        QueueID => $QueueID,
                        ResponseID => $StdResponseID,
                        UserID => $Param{UserID},
                    );
                }
            }
        }
        # add response by id
        if ($Self->{ConfigObject}->Get('StdResponseID2QueueByCreating')) {
            foreach (@{$Self->{ConfigObject}->{StdResponseID2QueueByCreating}}) {
                $Self->SetQueueStdResponse(
                    QueueID => $QueueID,
                    ResponseID => $_,
                    UserID => $Param{UserID},
                );
            }
        }
        return $QueueID;
   }
   else {
        return;
   }
}

=item QueueGet()

get queue attributes

    my %Queue = $QueueObject->QueueGet(
        ID => 123,
    );

    my %Queue = $QueueObject->QueueGet(
        Name => 'Some::Queue',
    );

=cut

sub QueueGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{ID} && !$Param{Name}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ID or Name!");
        return;
    }
    # check if we ask the same request (cache)?
    if ($Param{Cache} && $Param{ID} && $Self->{"QG::ID$Param{ID}"}) {
        return %{$Self->{"QG::ID$Param{ID}"}};
    }
    if ($Param{Cache} && $Param{Queue} && $Self->{"QL::Name$Param{Name}"}) {
        return %{$Self->{"QG::Name$Param{Name}"}};
    }
    # sql
    my $SQL = "SELECT q.name, q.group_id, q.unlock_timeout, ".
        " q.system_address_id, q.salutation_id, q.signature_id, q.comments, q.valid_id, ".
        " q.escalation_time, q.follow_up_id, q.follow_up_lock, sa.value0, sa.value1, q.id, ".
        " q.move_notify, q.state_notify, q.lock_notify, q.owner_notify, q.default_sign_key, ".
        " q.calendar_name ".
        " FROM ".
        " queue q, system_address sa".
        " WHERE ".
        " q.system_address_id = sa.id ".
        " AND ";
    my $Suffix = '';
    if ($Param{ID}) {
        $Param{What} = $Param{ID};
        $Suffix = 'ID';
        $SQL .= " q.id = ".$Self->{DBObject}->Quote($Param{ID}, 'Integer')."";
    }
    else {
        $Param{What} = $Param{Name};
        $Suffix = 'Name';
        $SQL .= " q.name = '".$Self->{DBObject}->Quote($Param{Name})."'";
    }
    my %QueueData = ();
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Data = $Self->{DBObject}->FetchrowArray()) {
        %QueueData = (
            QueueID => $Data[13],
            Name => $Data[0],
            GroupID => $Data[1],
            UnlockTimeout => $Data[2],
            EscalationTime => $Data[8],
            FollowUpID => $Data[9],
            FollowUpLock => $Data[10],
            SystemAddressID => $Data[3],
            SalutationID => $Data[4],
            SignatureID => $Data[5],
            Comment => $Data[6],
            ValidID => $Data[7],
            Email => $Data[11],
            RealName => $Data[12],
            StateNotify => $Data[15],
            MoveNotify => $Data[14],
            LockNotify => $Data[16],
            OwnerNotify => $Data[17],
            DefaultSignKey => $Data[18],
            Calendar => $Data[19],
        );
        $Self->{"QG::$Suffix$Param{What}"} = \%QueueData;
    }
    # check if data exists
    if (!exists $Self->{"QG::$Suffix$Param{What}"}) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Found no \$$Suffix for $Param{What}!",
        );
        return;
    }
    # return result
    return %{$Self->{"QG::$Suffix$Param{What}"}};
}

=item QueueUpdate()

update queue attributes

    $QueueObject->QueueUpdate(
        QueueID         => 123,
        Name            => 'Some::Queue',
        ValidID         => 1,
        GroupID         => 1,
        SystemAddressID => 1,
        SalutationID    => 1,
        SignatureID     => 1,
        UserID          => 123,
        MoveNotify      => 0,
        StateNotify     => 0,
        LockNotify      => 0,
        OwnerNotify     => 0,
    );

=cut

sub QueueUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(QueueID Name ValidID GroupID SystemAddressID SalutationID SignatureID FollowUpID UserID MoveNotify StateNotify LockNotify OwnerNotify)) {
        if (!defined ($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    foreach (qw(QueueID Name ValidID GroupID SystemAddressID SalutationID SignatureID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # db quote
    my %DB = ();
    # check !!!
    foreach (qw(UnlockTimeout EscalationTime FollowUpLock MoveNotify StateNotify LockNotify OwnerNotify FollowUpID FollowUpLock DefaultSignKey Calendar)) {
        $Param{$_} = 0 if (!$Param{$_});
    }
    foreach (qw(Name DefaultSignKey Calendar Comment)) {
        $DB{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    };
    foreach (qw(QueueID GroupID UnlockTimeout SystemAddressID SalutationID SignatureID FollowUpID FollowUpLock EscalationTime StateNotify LockNotify OwnerNotify MoveNotify StateNotify ValidID UserID)) {
        $DB{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # check queue name
    if ($Param{Name} =~ /::$/i) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Invalid Queue name '$Param{Name}'!",
        );
        return;
    }
    # check if queue name exists
    my %AllQueue = $Self->{DBObject}->GetTableData(
        Table => 'queue',
        What => 'id, name',
    );
    my %OldQueue = $Self->QueueGet(ID => $Param{QueueID});
    foreach (keys %AllQueue) {
        if ($AllQueue{$_} =~ /^$Param{Name}$/i && $_ != $Param{QueueID}) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Queue '$Param{Name}' exists! Can't updated queue '$OldQueue{Name}'.",
            );
            return;
        }
    }
    # sql
    my $SQL = "UPDATE queue SET name = '$DB{Name}', " .
        " comments = '$DB{Comment}', " .
        " group_id = $DB{GroupID}, " .
        " unlock_timeout = $DB{UnlockTimeout}, " .
        " escalation_time = $DB{EscalationTime}, " .
        " follow_up_id = $DB{FollowUpID}, " .
        " follow_up_lock = $DB{FollowUpLock}, " .
        " system_address_id = $DB{SystemAddressID}, " .
        " calendar_name = '$DB{Calendar}', " .
        " default_sign_key = '$DB{DefaultSignKey}', " .
        " salutation_id = $DB{SalutationID}, " .
        " signature_id = $DB{SignatureID}, " .
        " move_notify = $DB{MoveNotify}, " .
        " state_notify = $DB{StateNotify}, " .
        " lock_notify = $DB{LockNotify}, " .
        " owner_notify = $DB{OwnerNotify}, " .
        " valid_id = $DB{ValidID}, " .
        " change_time = current_timestamp, " .
        " change_by = $DB{UserID} " .
        " WHERE id = $DB{QueueID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # updated all sub queue names
        my @ParentQueue = split(/::/, $OldQueue{Name});
        my %AllQueue = $Self->{DBObject}->GetTableData(
            Table => 'queue',
            What => 'id, name',
        );
        foreach (keys %AllQueue) {
            my @SubQueue = split(/::/, $AllQueue{$_});
            if ($#SubQueue > $#ParentQueue) {
                if ($AllQueue{$_} =~ /^\Q$OldQueue{Name}::\E/i) {
                    my $NewQueueName = $AllQueue{$_};
                    $NewQueueName =~ s/\Q$OldQueue{Name}\E/$Param{Name}/;
                    $NewQueueName = $Self->{DBObject}->Quote($NewQueueName);
                    my $SQL = "UPDATE queue SET ".
                        " name = '$NewQueueName', ".
                        " change_time = current_timestamp, " .
                        " change_by = $DB{UserID} " .
                        " WHERE id = $_";
                    $Self->{DBObject}->Do(SQL => $SQL);
                }
            }
        }
        return 1;
    }
    else {
        return;
    }
}
1;

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.62 $ $Date: 2006-11-02 12:20:53 $

=cut
