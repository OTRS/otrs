# --
# Kernel/System/Ticket/IndexAccelerator/FS.pm - filesystem queue ticket index module
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FS.pm,v 1.3 2002-12-01 14:13:17 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::IndexAccelerator::FS;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

sub TicketAcceleratorUpdate {
    my $Self = shift;
    my %Param = @_;
    my @ViewableLocks = @{$Self->{ConfigObject}{ViewableLocks}};
    my @ViewableStats = @{$Self->{ConfigObject}{ViewableStats}};
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my %IndexTicketData = ();
    my $FullINDEX = '';
    # --
    # get index 
    # --
    my $IndexFile = $Self->{ConfigObject}->Get('TicketIndexModule::IndexFile') 
      || die "Go no IndexFile in Condig.pm!";
    open (INDEX, "< $IndexFile") || die $!;
    while (<INDEX>) {
        chomp;
        # --
        # split data
        # --
        my @Data = split(/:/, $_);
        if ($Data[0] eq $Param{TicketID}) {
            $IndexTicketData{QueueID} = $Data[1];
            $IndexTicketData{Queue} = $Data[2];
            $IndexTicketData{GroupID} = $Data[3];
            $IndexTicketData{Lock} = $Data[4];
            $IndexTicketData{State} = $Data[5];
            $IndexTicketData{CreateTimeUnix} = $Data[6];
        }
        else {
            $FullINDEX .= $_."\n";
        }
    }
    # --
    # check if ticket is shown or not
    # --
    my $IndexUpdateNeeded = 0;
    my $IndexSelcected = 0;
    my %TicketData = $Self->GetTicket(%Param);
    if (!%IndexTicketData) {
        $IndexUpdateNeeded = 1;
    }
    else {
        # --
        # chekc if we need to update
        # --
        if ($TicketData{Lock} ne $IndexTicketData{Lock}) {
          $IndexUpdateNeeded = 1;
        }
        elsif ($TicketData{State} ne $IndexTicketData{State}) {
          $IndexUpdateNeeded = 1;
        }
        elsif ($TicketData{QueueID} ne $IndexTicketData{QueueID}) {
          $IndexUpdateNeeded = 1;
        }
    }
    # --
    # check if this ticket ist still viewable
    # --
    my $ViewableStatsHit = 0;
    foreach (@ViewableStats) {
        if ($_ =~ /^'$TicketData{State}'$/i) {
            $ViewableStatsHit = 1;
        }
    }
    my $ViewableLocksHit = 0;
    foreach (@ViewableLocks) {
        if ($_ =~ /^'$TicketData{Lock}'$/i) {
            $ViewableLocksHit = 1;
        }
    }
    if ($ViewableStatsHit && $ViewableLocksHit) {
        $IndexSelcected = 1;
    }
    # --
    # write index back
    # --
    if ($IndexUpdateNeeded) {
      my $IndexFile = $Self->{ConfigObject}->Get('TicketIndexModule::IndexFile') 
        || die "Go no IndexFile in Condig.pm!";
      open (INDEX, "> $IndexFile") || die $!;
      print INDEX $FullINDEX;
      if ($IndexSelcected) {
          print INDEX "$Param{TicketID}:$TicketData{QueueID}:$TicketData{Queue}:$TicketData{GroupID}:$TicketData{Lock}:$TicketData{State}:$TicketData{CreateTimeUnix}:\n";
      }
      close (INDEX); 
    }
    return 1;
}
# --
sub TicketAcceleratorDelete {
    my $Self = shift;
    my %Param = @_;
    return 1;
}
# --
sub TicketAcceleratorAdd {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # get ticket data
    # --
    my %TicketData = $Self->GetTicket(%Param);
    # --
    # write/append index 
    # --
    my $IndexFile = $Self->{ConfigObject}->Get('TicketIndexModule::IndexFile')
       || die "Go no IndexFile in Condig.pm!";
    open (INDEX, ">> $IndexFile") || die $!;
    print INDEX "$Param{TicketID}:$TicketData{QueueID}:$TicketData{Queue}:$TicketData{GroupID}:$TicketData{Lock}:$TicketData{State}:$TicketData{CreateTimeUnix}:\n";
    close (INDEX); 
    return 1;
}
# --
sub TicketAcceleratorIndex {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(UserID QueueID)) {
      if (!exists($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # -- 
    # get user groups
    # --
    my %Groups = $Self->{UserObject}->GetGroups(%Param);
    my @CustomQueuesTmp = $Self->{QueueObject}->GetAllCustomQueues(%Param);
    my %CustomQueues = ();
    foreach (@CustomQueuesTmp) {
        $CustomQueues{$_} = 1;
    }
    # --
    # get index 
    # --
    my %Queues = ();
    my %CustomQueue = ();
    $CustomQueue{Queue} = $Self->{ConfigObject}->Get('CustomQueue') || '???';
    $CustomQueue{QueueID} = 0;
    $CustomQueue{MaxAge} = 0;
    $Queues{MaxAge} = 0;
    $Queues{TicketsShown} = 0;
    $Queues{TicketsAvail} = 0;
    my %INDEX = ();
    my $IndexFile = $Self->{ConfigObject}->Get('TicketIndexModule::IndexFile')
       || die "Go no IndexFile in Condig.pm!";
    open (INDEX, "< $IndexFile") || die $!;
    while (<INDEX>) {
        chomp;
        # --
        # split data
        # --
        my @Data = split(/:/, $_);
        if ($Groups{$Data[3]}) {
          # --
          # count all queue tickets
          # --
          if ($Param{QueueID} eq $Data[1]) {
              $Queues{AllTickets}++;
          }
          # --
          # count each queue
          # --
          $INDEX{$Data[2]}->{Count}++; 
          $INDEX{$Data[2]}->{Queue} = $Data[2];
          $INDEX{$Data[2]}->{QueueID} = $Data[1];
          # --
          # get the oldes queue id
          # --
          if (!$INDEX{$Data[2]}->{MaxAge}) {
              $INDEX{$Data[2]}->{MaxAge} = 0;
          }
          if ($INDEX{$Data[2]}->{MaxAge} > $Data[6]) {
              $INDEX{$Data[2]}->{MaxAge} = $Data[6];
              if ($INDEX{$Data[2]}->{MaxAge} > $Queues{MaxAge}) {
                  $Queues{QueueIDOfMaxAge} = $Data[1];
                  $Queues{MaxAge} = $INDEX{$Data[2]}->{MaxAge};
              }
          }
          # --
          # custom queue
          # --
          if ($CustomQueues{$Data[1]}) {
              $CustomQueue{Count}++; 
              # --
              # count all custom queue tickets
              # --
              if ($Param{QueueID} eq $Data[1]) {
                $Queues{AllTickets}++;
              }
          }
        }
    }
    # --
    # 
    # --
    push (@{$Queues{Queues}}, \%CustomQueue);
    if ($Param{QueueID} == 0) {
        $Queues{TicketsShown} = $CustomQueue{Count};
        $Queues{TicketsAvail} = $CustomQueue{Count};
    }
    # --
    # 
    # --
    foreach my $Queue (sort keys %INDEX) {
        my %Data = ();
        if ($Param{QueueID} eq $INDEX{$Queue}->{QueueID}) {
            $Queues{TicketsShown} = $INDEX{$Queue}->{Count};
            $Queues{TicketsAvail} = $INDEX{$Queue}->{Count};
        }
        $Data{QueueID} = $INDEX{$Queue}->{QueueID};
        $Data{Queue} = $INDEX{$Queue}->{Queue};
        $Data{MaxAge} =  time() - $INDEX{$Queue}->{MaxAge};
        $Data{Count} = $INDEX{$Queue}->{Count};
        push (@{$Queues{Queues}}, \%Data);
    }
    return %Queues;
}
# --
sub TicketAcceleratorRebuild {
    my $Self = shift;
    my %Param = @_;
    my @ViewableLocks = @{$Self->{ConfigObject}{ViewableLocks}};
    my @ViewableStats = @{$Self->{ConfigObject}{ViewableStats}};
    # --
    # the "oldest" valiables
    # --
    my $QueueIDOfMaxAge = '';
    my $MaxAge = 0;
    
    # prepar the tickets in Queue bar (all data only with my/your Permission)
    my $SQL = "SELECT st.id, st.queue_id, sq.name, sq.group_id, slt.name, ".
    " tsd.name, st.create_time_unix ".
    " FROM " .
    " ticket as st, queue as sq, ticket_state tsd, " .
    " ticket_lock_type slt " .
    " WHERE " .
    " st.ticket_state_id = tsd.id " .
    " AND " .
    " st.queue_id = sq.id " .
    " AND " .
    " st.ticket_lock_id = slt.id " .
    " AND " .
    " tsd.name in ( ${\(join ', ', @ViewableStats)} ) " .
    " AND " .
    " slt.name in ( ${\(join ', ', @ViewableLocks)} ) " .
    " ";

    $Self->{DBObject}->Prepare(SQL => $SQL);
    # --
    # write index 
    # --
    my $IndexFile = $Self->{ConfigObject}->Get('TicketIndexModule::IndexFile')
       || die "Go no IndexFile in Condig.pm!";
    open (INDEX, "> $IndexFile") || die $!;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        print INDEX "$Row[0]:$Row[1]:$Row[2]:$Row[3]:$Row[4]:$Row[5]:$Row[6]:\n";
    }
    close (INDEX); 
    return 1;

}
# --


1;


