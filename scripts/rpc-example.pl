#!/usr/bin/perl -w
# --
# scripts/rpc-example.pl - soap example client
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: rpc-example.pl,v 1.1 2007-08-09 04:30:34 tr Exp $
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

# config
use SOAP::Lite('autodispatch', proxy => 'http://otrs.example.com/otrs/rpc.pl');
my $User = 'some_user';
my $Pw = 'some_pass';

my $RPC = Core->new();

# create a new ticket number
print "NOTICE: TicketObject->TicketCreateNumber()\n";
my $TicketNumber = $RPC->Dispatch($User, $Pw, 'TicketObject', 'TicketCreateNumber');
print "NOTICE: New Ticket Number is: $TicketNumber\n";

# get ticket attributes
print "NOTICE: TicketObject->TicketGet(TicketID => 1)\n";
my %Ticket = $RPC->Dispatch($User, $Pw, 'TicketObject', 'TicketGet', TicketID => 1);
print "NOTICE: Ticket Number is: $Ticket{TicketNumber}\n";
print "NOTICE: Ticket State is:  $Ticket{State}\n";
print "NOTICE: Ticket Queue is:  $Ticket{Queue}\n";
