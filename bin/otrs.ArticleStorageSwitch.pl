#!/usr/bin/perl -w
# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::Ticket;

# get options
my %Opts = ();
getopt( 'hsdv', \%Opts );
if ( $Opts{h} ) {
    print "otrs.ArticleStorageSwitch.pl - to move storage content\n";
    print "Copyright (C) 2001-2017 OTRS AG, http://otrs.com/\n";
    print "usage: otrs.ArticleStorageSwitch.pl -s ArticleStorageDB -d ArticleStorageFS\n";
    exit 1;
}

if ( !$Opts{s} ) {
    print STDERR "ERROR: Need -s SOURCE, e. g. -s ArticleStorageDB param\n";
    exit 1;
}
if ( !$Opts{d} ) {
    print STDERR "ERROR: Need -d DESTINATION , e. g. -s ArticleStorageFS param\n";
    exit 1;
}
if ( $Opts{s} eq $Opts{d} ) {
    print STDERR
        "ERROR: Need different source and destination params, e. g. -s ArticleStorageDB -d ArticleStorageFS param\n";
    exit 1;
}

# create common objects
my %CommonObject;
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.ArticleStorageSwitch.pl',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);

# create needed objects
$CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);

# disable ticket events
$CommonObject{ConfigObject}->{'Ticket::EventModulePost'} = {};

# get all tickets
my @TicketIDs = $CommonObject{TicketObject}->TicketSearch(

    # result (required)
    Result  => 'ARRAY',
    OrderBy => 'Up',

    # result limit
    Limit      => 1_000_000_000,
    UserID     => 1,
    Permission => 'ro',
);

my $Count      = 0;
my $CountTotal = scalar @TicketIDs;
for my $TicketID (@TicketIDs) {
    $Count++;

    print "NOTICE: $Count/$CountTotal\n";
    $CommonObject{TicketObject}->TicketArticleStorageSwitch(
        TicketID    => $TicketID,
        Source      => $Opts{s},
        Destination => $Opts{d},
        UserID      => 1,
    );
}
print "NOTICE: done.\n";

exit 0;
