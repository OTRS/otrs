#!/usr/bin/perl -w
# --
# scripts/test/CreateTickerNumber.pl - test script to generate a ticket number
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CreateTickerNumber.pl,v 1.2 2004-12-06 22:22:12 martin Exp $
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
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::Time;
use Kernel::System::Ticket;

# --
# common objects
# --
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-test-CreateTickerNumber.pl',
    %CommonObject,
);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);

print "OTRS::TicketNumberGenerator::Test ($VERSION)\n";
print "=================================\n";
print "\n";
my $Hook = $CommonObject{ConfigObject}->Get('TicketHook');
my $Tn = $CommonObject{TicketObject}->CreateTicketNr();
print "Current TicketHook: $Hook\n";
print "\n";
print "CreateTicketNr():\n";
print "-----------------\n";
print "TicketNumber: $Tn\n";
print "\n";
print "Match test with current settings - GetTNByString():\n";
print "---------------------------------------------------\n";
my $String = "Re: ".$CommonObject{TicketObject}->TicketSubjectBuild(
    TicketNumber => $Tn,
    Subject => 'Some Test',
);
if ($CommonObject{TicketObject}->GetTNByString($String)) {
    print "OK ($String).\n";
}
else {
    print "FAILED ($String)!\n";
}
print "\n";
print "Match test with default settings - GetTNByString():\n";
print "---------------------------------------------------\n";
$String = 'Ticket#: 200206231010138';
if ($CommonObject{TicketObject}->GetTNByString($String)) {
    print "OK ($String).\n";
}
else {
    print "FAILED ($String)!\n";
}

