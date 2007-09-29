#!/usr/bin/perl -w
# --
# scripts/test/TicketHistoryState.pl - test script of user auth
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: TicketHistoryState.pl,v 1.5 2007-09-29 11:09:57 mh Exp $
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
use lib dirname($RealBin) . '/..';
use lib dirname($RealBin) . '/../Kernel/cpan-lib';

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::Ticket;

# common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-test-TicketHistoryState.pl',
    %CommonObject,
);
$CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject}   = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);

my $TicketID = shift || die "Need TicketID as argument!\n";
my $Year     = shift || die "Need Year (e. g. 2004) as argument!\n";
my $Month    = shift || die "Need Month (e. g. 2) as argument!\n";
my $Day      = shift || die "Need Day (e. g. 2) as argument!\n";

print "OTRS::TicketHistoryState::Test ($VERSION)\n";
print "==============================\n";
print "TicketID: '$TicketID'\n";
print "State at: '$Year-$Month-$Day'\n";
print "\n";
print "HistoryTicketGet()\n";
print "------\n";

my %Ticket = $CommonObject{TicketObject}->HistoryTicketGet(
    TicketID  => $TicketID,
    StopYear  => $Year,
    StopMonth => $Month,
    StopDay   => $Day,
);
for ( sort keys %Ticket ) {
    print "$_: $Ticket{$_}\n";
}
