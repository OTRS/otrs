# --
# Config.pm - Config file for OpenTRS kernel
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Queue.pm,v 1.4 2002-05-26 10:12:31 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Queue;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);

    $Self->{OueueID} = $Param{QueueID} || ''; #die "Got no QueueID!";
    $Self->{DBObject} = $Param{DBObject} || die "Got no DBObject!";
    return $Self;
}
# --
sub GetSystemAddress {
    my $Self = shift;
    my %Param = @_;
    my %Adresss;
    my $SQL = "SELECT sa.value0, sa.value1 FROM system_address as sa, queue as sq " .
	" WHERE " .
	" sq.id = $Self->{OueueID} " .
	" and " .
	" sa.id = sq.system_address_id";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Adresss{Email} = $RowTmp[0];
	$Adresss{RealName} = $RowTmp[1];
    }
    return %Adresss;
}
# --
sub GetSalutation {
    my $Self = shift;
    my %Param = @_;
    my $String = '';
    my $SQL = "SELECT text FROM salutation as sa, queue as sq " .
        " WHERE " .
        " sq.id = $Self->{OueueID} " .
        " and " .
        " sq.salutation_id = sa.id";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $String = $RowTmp[0];
    }
    return $String;
}
# --
sub GetSignature {
    my $Self = shift;
    my %Param = @_;
    my $String = '';
    my $SQL = "SELECT text FROM signature as si, queue as sq " .
        " WHERE " .
        " sq.id = $Self->{OueueID} " .
        " and " .
        " sq.signature_id = si.id";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $String = $RowTmp[0];
    }
    return $String;
}
# --
sub GetStdResponse {
    my $Self = shift;
    my %Param = @_;
    my $String = '';
    my $ID = $Param{ID};
    my $SQL = "SELECT text FROM standard_response" .
        " WHERE " .
        " id = $ID ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $String = $RowTmp[0];
    }
    return $String;
}
# --
sub GetStdResponses {
    my $Self = shift;
    my %Param = @_;
    my $QueueID = $Param{QueueID} || return;
    my %StdResponses;
    # --
    # check if this result is present
    # --
    if ($Self->{"StdResponses::$QueueID"}) {
        my $StdResponsesTmp = $Self->{"StdResponses::$QueueID"};
        %StdResponses = %$StdResponsesTmp;
        return %StdResponses;
    }
    # --
    # get std. responses
    # --
    my $SQL = "SELECT sr.id, sr.name " .
        " FROM " .
        " standard_response as sr, queue_standard_response as qsr" .
        " WHERE " .
        " qsr.queue_id in ($QueueID)" .
        " AND " .
        " qsr.standard_response_id = sr.id" .
        " AND " .
        " sr.valid_id in ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} )" .
        " ORDER BY sr.name";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $StdResponses{$RowTmp[0]} = $RowTmp[1];
    }
    # --
    # store std responses
    # --
    $Self->{"StdResponses::$QueueID"} = \%StdResponses;
    # --
    # return responses
    # --
    return %StdResponses;
}
# --
sub GetAllQueues {
    my $Self = shift;
    my %Param = @_;
    my $UserID = $Param{UserID} || '';
    # fetch all queues
    my %MoveQueues;
    if ($UserID) {
        my $SQL = "SELECT sq.id, sq.name FROM queue as sq, group_user sug, groups as sg " .
        " WHERE " .
        " sug.user_id = $UserID" .
        " AND " .
        " sug.group_id = sg.id" .
        " AND " .
        " sq.group_id = sg.id" .
        " AND " .
        " sq.valid_id in ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} )";
        $Self->{DBObject}->Prepare(SQL => $SQL);
    }
    else {
        $Self->{DBObject}->Prepare(SQL => "SELECT id, name FROM queue WHERE valid_id in " .
	"( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} )");
    }
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $MoveQueues{$RowTmp[0]} = $RowTmp[1];
    }
    return %MoveQueues;
}
# --
sub GetAllCustomQueues {
    my $Self = shift;
    my %Param = @_;
    my $UserID = $Param{UserID} || '';
    # fetch all queues
    my @QueueIDs;
    my $SQL = "SELECT queue_id FROM personal_queues WHERE user_id = $UserID";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        push(@QueueIDs, $RowTmp[0]);
    }
    return @QueueIDs;
}
# --
sub QueueLookup {
    my $Self = shift;
    my %Param = @_;
    my $Queue = $Param{Queue} || '';
    my $QueueID = $Param{QueueID} || '';

    # check if we ask the same request?
    if (exists $Self->{"QueueLookup$QueueID"}) {
        return $Self->{"QueueLookup$QueueID"};
    }
    if (exists $Self->{"QueueLookup$Queue"}) {
        return $Self->{"QueueLookup$Queue"};
    }

    # get data
    my $SQL = '';
    my $Suffix = '';
    if ($Queue) {
        $Suffix = 'QueueID';
        $SQL = "SELECT id FROM queue WHERE name = '$Queue'";
    }
    else {
        $Suffix = 'Queue';
        $SQL = "SELECT name FROM queue WHERE id = $QueueID";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"QueueLookup$Suffix"} = $RowTmp[0];
    }
    # check if data exists
    if (!exists $Self->{"QueueLookup$Suffix"}) {
        print STDERR "Queue->QueueLookup(!\$$Suffix|) \n";
        return;
    }

    return $Self->{"QueueLookup$Suffix"};
}
# --
sub GetFollowUpOption {
    my $Self = shift;
    my %Param = @_;
    my $QueueID = $Param{QueueID} || '';
    # fetch queues data
    my $Return = '';
    my $SQL = "SELECT sf.name " .
		" FROM " .
		" follow_up_possible sf, queue sq " .
		" WHERE " .
		" sq.follow_up_id = sf.id " .
		" AND " .
		" sq.id = $QueueID";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
		$Return = $RowTmp[0];
    }
    return $Return;
}
# --
sub GetFollowUpLockOption {
    my $Self = shift;
    my %Param = @_;
    my $QueueID = $Param{QueueID} || '';
    # fetch queues data
    my $Return = 0;
    my $SQL = "SELECT sq.follow_up_lock " .
        " FROM " .
        " queue sq " .
        " WHERE " .
        " sq.id = $QueueID";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Return = $RowTmp[0];
    }
    return $Return;
}
# --
sub GetQueueGroupID {
    my $Self = shift;
    my %Param = @_;
    my $QueueID = $Param{QueueID} || return;
    my $GID = '';
        my $SQL = "SELECT group_id " .
        " FROM " .
        " queue " .
        " WHERE " .
        " id = $QueueID";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $GID = $RowTmp[0];
    }
    return $GID;
}
# --

1;
