#!/usr/bin/perl -w
# --
# scripts/test/TicketHistoryState.pl - test script of user auth
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: TicketHistoryState.pl,v 1.3 2007-01-30 17:33:25 tr Exp $
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
use lib dirname($RealBin).'/..';
use lib dirname($RealBin).'/../Kernel/cpan-lib';

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::Ticket;

# common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-test-TicketHistoryState.pl',
    %CommonObject,
);
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);

my $TicketID = shift || die "Need TicketID as argument!\n";
my $TimeStamp = shift || die "Need TimeStamp (e. g. 2004-06-07) as argument!\n";

print "OTRS::TicketHistoryState::Test ($VERSION)\n";
print "==============================\n";
print "TicketID: '$TicketID'\n";
print "State at: '$TimeStamp'\n";
print "\n";
print "HistoryTicketGet()\n";
print "------\n";

my %Ticket = $CommonObject{TicketObject}->HistoryTicketGet(TicketID => $TicketID, TimeStamp => $TimeStamp);

foreach (sort keys %Ticket) {
    print "$_: $Ticket{$_}\n";
}
