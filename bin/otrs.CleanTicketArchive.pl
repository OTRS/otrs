#!/usr/bin/perl
# --
# bin/otrs.CleanTicketArchive.pl - clean the ticket archive flag
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

use Getopt::Std;
use Time::HiRes qw(usleep);

use Kernel::System::ObjectManager;

# get options
my %Opts;
getopt( 'b', \%Opts );
if ( $Opts{h} ) {
    print "otrs.CleanTicketArchive.pl - clean the ticket archive flag\n";
    print "Copyright (C) 2001-2014 OTRS AG, http://otrs.com/\n";
    print "usage: otrs.CleanTicketArchive.pl [-b sleeptime per ticket in microseconds]\n";
    exit 1;
}

if ( $Opts{b} && $Opts{b} !~ m{ \A \d+ \z }xms ) {
    print STDERR "ERROR: sleeptime needs to be a numeric value! e.g. 1000\n";
    exit 1;
}

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.CleanTicketArchive.pl',
    },
);

# disable cache
$Kernel::OM->Get('Kernel::System::Cache')->Configure(
    CacheInMemory  => 0,
    CacheInBackend => 1,
);

# disable ticket events
$Kernel::OM->Get('Kernel::Config')->{'Ticket::EventModulePost'} = {};

# check if archive system is activated
if ( !$Kernel::OM->Get('Kernel::Config')->Get('Ticket::ArchiveSystem') ) {
    print STDOUT "\nNo action required. The archive system is disabled at the moment!\n";
    exit 0;
}

# get ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# get all tickets with an archive flag and an open statetype
my @TicketIDs = $TicketObject->TicketSearch(
    StateType => [ 'new', 'open', 'pending reminder', 'pending auto' ],
    ArchiveFlags => ['y'],
    Result       => 'ARRAY',
    Limit        => 100_000_000,
    UserID       => 1,
    Permission   => 'ro',
);

my $TicketNumber = scalar @TicketIDs;
my $Count        = 1;
TICKETID:
for my $TicketID (@TicketIDs) {

    # restore ticket from archive
    $TicketObject->TicketArchiveFlagSet(
        TicketID    => $TicketID,
        UserID      => 1,
        ArchiveFlag => 'n',
    );

    # output state
    if ( $Count % 2000 == 0 ) {
        my $Percent = int( $Count / ( $TicketNumber / 100 ) );
        print STDOUT "NOTICE: $Count of $TicketNumber processed ($Percent% done).\n";
    }

    $Count++;

    next TICKETID if !$Opts{b};

    Time::HiRes::usleep( $Opts{b} );
}

print STDOUT "\nNOTICE: Archive cleanup done. $TicketNumber Tickets processed.\n";

exit 0;
