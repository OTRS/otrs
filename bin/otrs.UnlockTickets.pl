#!/usr/bin/perl
# --
# bin/otrs.UnlockTickets.pl - to unlock tickets
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Kernel::System::ObjectManager;

my $Debug = 0;

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.UnlockTickets.pl',
    },
);

my @UnlockStateIDs = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
    Type   => 'Unlock',
    Result => 'ID',
);
my @ViewableLockIDs = $Kernel::OM->Get('Kernel::System::Lock')->LockViewableLock( Type => 'ID' );

# check args
my $Command = shift || '--help';
print "otrs.UnlockTickets.pl - unlock tickets\n";
print "Copyright (C) 2001-2014 OTRS AG, http://otrs.com/\n";

# unlock all tickets
if ( $Command eq '--all' ) {
    print " Unlock all tickets:\n";
    my @Tickets;
    exit 1 if !$Kernel::OM->Get('Kernel::System::DB')->Prepare(
        SQL => "
            SELECT st.tn, st.id
            FROM ticket st
            WHERE st.ticket_lock_id NOT IN ( ${\(join ', ', @ViewableLockIDs)} ) ",
    );

    while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
        push @Tickets, \@Row;
    }
    for (@Tickets) {
        my @Row = @{$_};
        print " Unlocking ticket id $Row[0] ...";
        my $Unlock = $Kernel::OM->Get('Kernel::System::Ticket')->LockSet(
            TicketID => $Row[1],
            Lock     => 'unlock',
            UserID   => 1,
        );
        if ($Unlock) {
            print " done.\n";
        }
        else {
            print " failed.\n";
        }
    }
    exit 0;
}

# unlock old tickets
elsif ( $Command eq '--timeout' ) {
    print " Unlock old tickets:\n";
    my @Tickets;
    exit 1 if !$Kernel::OM->Get('Kernel::System::DB')->Prepare(
        SQL => "
            SELECT st.tn, st.id, st.timeout, sq.unlock_timeout, st.sla_id, st.queue_id
            FROM ticket st, queue sq
            WHERE st.queue_id = sq.id
                AND sq.unlock_timeout != 0
                AND st.ticket_state_id IN ( ${\(join ', ', @UnlockStateIDs)} )
                AND st.ticket_lock_id NOT IN ( ${\(join ', ', @ViewableLockIDs)} ) ",
    );

    while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
        push @Tickets, \@Row;
    }

    TICKET:
    for (@Tickets) {
        my @Row = @{$_};

        # get used calendar
        my $Calendar = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCalendarGet(
            QueueID => $Row[5],
            SLAID   => $Row[4],
        );

        my $CountedTime = $Kernel::OM->Get('Kernel::System::Time')->WorkingTime(
            StartTime => $Row[2],
            StopTime  => $Kernel::OM->Get('Kernel::System::Time')->SystemTime(),
            Calendar  => $Calendar,
        );
        next TICKET if $CountedTime < $Row[3] * 60;

        print " Unlocking ticket id $Row[0] ...";
        my $Unlock = $Kernel::OM->Get('Kernel::System::Ticket')->LockSet(
            TicketID => $Row[1],
            Lock     => 'unlock',
            UserID   => 1,
        );
        if ($Unlock) {
            print " done.\n";
        }
        else {
            print " failed.\n";
        }
    }
    exit 0;
}

# unlock ticket by ID
elsif ( $Command eq '--ticket' ) {
    my $TicketID = shift || '';
    if ( $TicketID eq '' ) {
        print " No TicketID given!\n";
        exit 0;
    }
    print " Unlocking ticket: $TicketID...";
    my $Unlock = $Kernel::OM->Get('Kernel::System::Ticket')->LockSet(
        TicketID => $TicketID,
        Lock     => 'unlock',
        UserID   => 1,
    );
    if ($Unlock) {
        print " done.\n";
    }
    else {
        print " failed.\n";
    }
    exit 0;
}

# show usage
else {
    print "usage: $0 [options] \n";
    print "  Options are as follows:\n";
    print "  --help        display this option help\n";
    print "  --timeout     unlock old tickets\n";
    print "  --all         unlock all tickets (force)\n";
    print "  --ticket id   unlock ticket with specified id (force)\n";
    exit 1;
}
