#!/usr/bin/perl -w
# --
# otrs.RebuildFulltextIndex.pl - the global search indexer handle
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: otrs.RebuildFulltextIndex.pl,v 1.4 2009-02-16 12:26:57 tr Exp $
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
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Encode;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::Ticket;

# get options
my %Opts = ();
getopt( 'h', \%Opts );
if ( $Opts{h} ) {
    print "otrs.RebuildFulltextIndex.pl <Revision $VERSION> - rebuild fulltext index\n";
    print "Copyright (c) 2001-2008 OTRS AG, http://otrs.org/\n";
    print "usage: otrs.RebuildFulltextIndex.pl\n";
    exit 1;
}

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-RebuildFulltextIndex',
    %CommonObject,
);
$CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{TimeObject}   = Kernel::System::Time->new( %CommonObject, );

# create needed objects
$CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);

# get all tickets
my @TicketIDs = $CommonObject{TicketObject}->TicketSearch(

    # result (required)
    Result => 'ARRAY',

    # result limit
    Limit      => 100_000_000,
    UserID     => 1,
    Permission => 'ro',
);

my $Count = 0;
for my $TicketID (@TicketIDs) {

    $Count++;

    # get articles
    my @ArticleIndex = $CommonObject{TicketObject}->ArticleIndex(
        TicketID => $TicketID,
        UserID   => 1,
    );

    for my $ArticleID (@ArticleIndex) {
        $CommonObject{TicketObject}->ArticleIndexBuild(
            ArticleID => $ArticleID,
            UserID    => 1,
        );
        if ( ( $Count / 5000 ) == int( $Count / 5000 ) ) {
            my $Percent = int( $Count / ( $#TicketIDs / 100 ) );
            print "NOTICE: $Count of $#TicketIDs processed ($Percent% done).\n";
        }
    }
}
print "NOTICE: Index creation done.\n";

exit(0);
