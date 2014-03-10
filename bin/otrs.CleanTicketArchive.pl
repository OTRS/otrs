#!/usr/bin/perl
# --
# otrs.CleanTicketArchive.pl - Clean the ticket archive flag
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

# create common objects
local $Kernel::OM = Kernel::System::ObjectManager->new(
    LogObject => {
        LogPrefix => 'OTRS-otrs.CleanTicketArchive.pl',
    },
);
my %CommonObject = $Kernel::OM->ObjectHash(
    Objects =>
        [qw(ConfigObject EncodeObject LogObject MainObject TimeObject DBObject TicketObject)],
);

# print header
print STDOUT "otrs.CleanTicketArchive.pl - clean ticket archive flag\n";
print STDOUT "Copyright (C) 2001-2014 OTRS AG, http://otrs.com/\n";

# check if archive system is activated
if ( !$CommonObject{ConfigObject}->Get('Ticket::ArchiveSystem') ) {

    print STDOUT "\nNo action required. The archive system is disabled at the moment!\n";

    exit 0;
}

# get all tickets with an archive flag and an open statetype
my @TicketIDs = $CommonObject{TicketObject}->TicketSearch(
    StateType => [ 'new', 'open', 'pending reminder', 'pending auto' ],
    ArchiveFlags => ['y'],
    Result       => 'ARRAY',
    Limit        => 100_000_000,
    UserID       => 1,
    Permission   => 'ro',
);

my $TicketNumber = scalar @TicketIDs;
my $Count        = 1;
for my $TicketID (@TicketIDs) {

    # restore ticket from archive
    $CommonObject{TicketObject}->TicketArchiveFlagSet(
        TicketID    => $TicketID,
        UserID      => 1,
        ArchiveFlag => 'n',
    );

    # output state
    if ( $Count % 2000 == 0 ) {
        my $Percent = int( $Count / ( $TicketNumber / 100 ) );
        print STDOUT "NOTICE: $Count of $TicketNumber processed ($Percent% done).\n";
    }
}
continue {
    $Count++;
}

print STDOUT "\nNOTICE: Archive cleanup done. $TicketNumber Tickets processed.\n";

exit 0;
