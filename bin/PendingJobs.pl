#!/usr/bin/perl -w
# --
# PendingJobs.pl - check pending tickets
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: PendingJobs.pl,v 1.2 2003-01-04 03:39:40 martin Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# --

# use ../ as lib location
use FindBin qw($Bin);
use lib "$Bin/../";
use lib "$Bin/../Kernel/cpan-lib";

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::Ticket;
use Kernel::System::User;

# --
# common objects
# --
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-PendingJobs',
    %CommonObject,
);
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);
$CommonObject{UserObject} = Kernel::System::User->new(%CommonObject);  

# --
# check args
# --
my $Command = shift || '--help';
print "PendingJobs.pl <Revision $VERSION> - check pending tickets\n";
print "Copyright (c) 2002 Martin Edenhofer <martin\@otrs.org>\n";
# --
# get states
# --
my @AutoStates = ();
my %States = $CommonObject{DBObject}->GetTableData(
    Table => 'ticket_state',
    Valid => 1,
    What => 'id, name'
);
foreach (keys %States) {
    if ($States{$_} !~ /^pending auto/i) {
        delete $States{$_};
    }
    else {
        push(@AutoStates, $_);
    }
}
# --
# do ticket jobs
# --
my @TicketIDs = ();
my $SQL = "SELECT st.tn, slt.name, st.ticket_answered, st.id, st.user_id FROM " .
    " ticket as st, queue as sq, ticket_state tsd, ticket_lock_type slt " .
    " WHERE " .
    " st.ticket_state_id = tsd.id " .
    " AND " .
    " st.queue_id = sq.id " .
    " AND " .
    " st.ticket_lock_id = slt.id ".
    " AND " .
    " tsd.id IN ( ${\(join ', ', @AutoStates)} ) ";
    $CommonObject{DBObject}->Prepare(SQL => $SQL);
while (my @RowTmp = $CommonObject{DBObject}->FetchrowArray()) {
    push (@TicketIDs, $RowTmp[3]);
}
foreach (@TicketIDs) {
    my %Ticket = $CommonObject{TicketObject}->GetTicket(TicketID => $_);
    if ($Ticket{UntilTime} < 1) {
        my %States = %{$CommonObject{ConfigObject}->Get('StateAfterPending')};
        if ($States{$Ticket{State}}) {
            print " Update ticket state for ticket $Ticket{TicketNumber} ($_) to '$States{$Ticket{State}}'...";
            if ($CommonObject{TicketObject}->SetState(TicketID => $_, State => $States{$Ticket{State}}, UserID => 1,)) {
              if ($States{$Ticket{State}} =~ /^close/i) {
                $CommonObject{TicketObject}->SetLock(
                    TicketID => $_,
                    Lock => 'unlock',
                    UserID => 1,
                );
              }
                print " done.\n";
            }
            else {
                print " failed.\n";
            }
        }
        else {
            print STDERR "ERROR: No StateAfterPending fount for $Ticket{State} in Kernel/Config.pm!\n";
        }
    }
}
exit (0);

