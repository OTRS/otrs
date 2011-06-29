#!/usr/bin/perl -w
# --
# otrs.ArticleStorageSwitch.pl - to move stored attachments from one backend to other
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: otrs.ArticleStorageSwitch.pl,v 1.14 2011-06-29 14:52:03 martin Exp $
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.14 $) [1];

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::Ticket;

# get options
my %Opts;
getopt( 'hsdcC', \%Opts );
if ( $Opts{h} ) {
    print "otrs.ArticleStorageSwitch.pl <Revision $VERSION> - to move storage content\n";
    print "Copyright (C) 2001-2011 OTRS AG, http://otrs.org/\n";
    print
        "usage: otrs.ArticleStorageSwitch.pl -s ArticleStorageDB -d ArticleStorageFS [-c <JUST_SELECT_WHERE_CLOSE_DATE_IS_BEFORE> e. g. -c '2011-06-29 14:00:00' -C <JUST_SELECT_WHERE_CLOSE_IS_OLDER_IN_DAYS] e. g. -C '5'\n";
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

# extended imput validation
my %SearchParams;
if ( $Opts{c} ) {

    # check time stamp format
    if ( !$CommonObject{TimeObject}->TimeStamp2SystemTime( String => $Opts{c} ) ) {
        print STDERR
            "ERROR: -c '$Opts{c}' is not a valid time stamp, please use 'yyyy-mm-dd hh:mm:ss'\n";
        exit 1;
    }
    %SearchParams = (
        StateType                => 'Closed',
        TicketCloseTimeOlderDate => $Opts{c},
    );
}
elsif ( $Opts{C} ) {

    # check time stamp format
    if ( $Opts{C} !~ /^\d+$/ ) {
        print STDERR
            "ERROR: -C '$Opts{C}' is not a valid integer, please use e. g. '5' for 5 days\n";
        exit 1;
    }
    $Opts{C} = $Opts{C} * 60 * 60 * 24;
    my $TimeStamp = $CommonObject{TimeObject}->SystemTime() - $Opts{C};
    $TimeStamp = $CommonObject{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $TimeStamp,
    );
    print "NOTICE: Searching for ticket which are closed before '$TimeStamp'\n";
    %SearchParams = (
        StateType                => 'Closed',
        TicketCloseTimeOlderDate => $TimeStamp,
    );
}

# get all tickets
my @TicketIDs = $CommonObject{TicketObject}->TicketSearch(

    # additional search params
    %SearchParams,

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

    print "NOTICE: $Count/$CountTotal (TicketID:$TicketID)\n";
    exit 1 if !$CommonObject{TicketObject}->TicketArticleStorageSwitch(
        TicketID    => $TicketID,
        Source      => $Opts{s},
        Destination => $Opts{d},
        UserID      => 1,
    );
}
print "NOTICE: done.\n";

exit 0;
