#!/usr/bin/perl -w
# --
# UnlockTickets.pl - to unlock tickets
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: UnlockTickets.pl,v 1.16 2004-04-05 17:14:11 martin Exp $
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
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin)."/Kernel/cpan-lib";

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.16 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

use Date::Pcalc qw(Delta_Days Add_Delta_Days Day_of_Week Day_of_Week_Abbreviation);
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::Ticket;
use Kernel::System::User;
use Kernel::System::State;
use Kernel::System::Lock;

my $Debug = 0;

# --
# common objects
# --
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-UnlockTickets',
    %CommonObject,
);
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);
$CommonObject{UserObject} = Kernel::System::User->new(%CommonObject);  
$CommonObject{StateObject} = Kernel::System::State->new(%CommonObject);  
$CommonObject{LockObject} = Kernel::System::Lock->new(%CommonObject);  

my @UnlockStateIDs = $CommonObject{StateObject}->StateGetStatesByType(
    Type => 'Unlock',
    Result => 'ID',
); 
my @ViewableLockIDs = $CommonObject{LockObject}->LockViewableLock(Type => 'ID');

# --
# check args
# --
my $Command = shift || '--help';
print "UnlockTickets.pl <Revision $VERSION> - unlock tickets\n";
print "Copyright (c) 2001-2004 Martin Edenhofer <martin\@otrs.org>\n";
# --
# unlock all tickets
# --
if ($Command eq '--all') {
    print " Unlock all tickets:\n";
    my @Tickets = ();
    my $SQL = "SELECT st.tn, st.ticket_answered, st.id, st.user_id FROM " .
    " ticket as st, queue as sq " .
    " WHERE " .
    " st.queue_id = sq.id " .
    " AND " .
    " st.ticket_lock_id NOT IN ( ${\(join ', ', @ViewableLockIDs)} ) ";
    $CommonObject{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $CommonObject{DBObject}->FetchrowArray()) {
        push (@Tickets, \@RowTmp);
    }
    foreach (@Tickets) {
        my @Row = @{$_};
        print " Unlocking ticket id $Row[0] ...";
        if ($CommonObject{TicketObject}->LockSet(
            TicketID => $Row[2],
            Lock => 'unlock',
            UserID => 1,
        ) ) { 
            print " done.\n";
        }
        else {
            print " failed.\n";
        }
    }
    exit (0);
}
# --
# unlock old tickets
# --
elsif ($Command eq '--timeout') {
    print " Unlock old tickets:\n";
    my @Tickets = ();
    my $SQL = "SELECT st.tn, st.ticket_answered, st.id, st.timeout, ".
    " sq.unlock_timeout, user_id ".
    " FROM " .
    " ticket as st, queue as sq " .
    " WHERE " .
    " st.queue_id = sq.id " .
    " AND " .
    " st.ticket_answered != 1 ".
    " AND " .
    " sq.unlock_timeout != 0 " .
    " AND " .
    " st.ticket_state_id IN ( ${\(join ', ', @UnlockStateIDs)} ) " .
    " AND " .
    " st.ticket_lock_id NOT IN ( ${\(join ', ', @ViewableLockIDs)} ) ";
    $CommonObject{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $CommonObject{DBObject}->FetchrowArray()) {
        # get lock date
#        my ($s,$m,$h, $D,$M,$Y, $wd,$yd,$dst) = localtime($RowTmp[3]-(60*60*24*1.5));
        my ($s,$m,$h, $D,$M,$Y, $wd,$yd,$dst) = localtime($RowTmp[3]);
        $Y = $Y+1900;
        $M++;
        my $LockDay = "$Y-$M-$D";
        # get current date
        my ($Ns,$Nm,$Nh, $ND,$NM,$NY, $Nwd,$Nyd,$Ndst) = localtime(time());
        $NY = $NY+1900;
        $NM++;
        my $ToDay = "$NY-$NM-$ND";
        # get delta days
        my $Dd = Delta_Days($Y,$M,$D, $NY,$NM,$ND);
        if ($Debug) {
            print STDERR "Delta_Days: $Dd\n";
        }
        # get not counted time (hours)
        my $UncountedUnlockTime = 0; 
        foreach (0..$Dd) {
            my ($year,$month,$day) = Add_Delta_Days($Y,$M,$D, $_);
            my $Dow = Day_of_Week($year,$month,$day);
            $Dow = Day_of_Week_Abbreviation($Dow);
            if ($Debug) {
                print STDERR "$Dow: $year,$month,$day .($Ns,$Nm,$Nh).\n";
            }
            # get not counted time
            my $CountDay = "$year-$month-$day";
            if ($CommonObject{ConfigObject}->Get('UncountedUnlockTime')->{$Dow}) {
                foreach (@{$CommonObject{ConfigObject}->Get('UncountedUnlockTime')->{$Dow}}) {
                    if ($CountDay ne $ToDay && $CountDay ne $LockDay) {
                        $UncountedUnlockTime = $UncountedUnlockTime+(60*60);
                        if ($Debug) {
                            print STDERR "InTime 1 h.\n";
                        } 
                    }
                    elsif ($CountDay eq $LockDay && $CountDay ne $ToDay && $h <= $_) {
                        $UncountedUnlockTime = $UncountedUnlockTime+(60*60);
                        if ($Debug) {
                            print STDERR "LockDay 1 h ($h <= $_).\n";
                        }
                    }
                    elsif ($CountDay eq $ToDay && $Nh >= $_) {
                        $UncountedUnlockTime = $UncountedUnlockTime+(60*60);
                        if ($Debug) {
                            print STDERR "EndToday 1 h ($Nh <= $_)\n";
                        }
                    }
                    if ($Debug) {
                        print STDERR "UncountedUnlockTime($CountDay/$_): $UncountedUnlockTime - $CountDay - $ToDay - $LockDay\n";
                    }
                }
            }
        }
#print STDERR "not counted time: $UncountedUnlockTime \n";
        if (($RowTmp[3] + ($RowTmp[4]*60) + $UncountedUnlockTime) <= time()) {
            push (@Tickets, \@RowTmp);
        }
    }
    foreach (@Tickets) {
        my @Row = @{$_};
        print " Unlocking ticket id $Row[0] ...";
        if ($CommonObject{TicketObject}->LockSet(
            TicketID => $Row[2],
            Lock => 'unlock',
            UserID => 1,
        ) ) { 
            print " done.\n";
        }
        else {
            print " failed.\n";
        }
    }
    exit (0);
}
# --
# show usage 
# --
else {
    print "usage: $0 [options] \n";
    print "  Options are as follows:\n";
    print "  --help        display this option help\n";
    print "  --timeout     unlock old tickets\n";
    print "  --all         unlock all ticksts (force)\n";
    exit (1);
}
# --

