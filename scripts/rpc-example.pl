#!/usr/bin/perl -w
# --
# scripts/rpc-example.pl - soap example client
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: rpc-example.pl,v 1.7.4.1 2011-10-24 09:22:20 mg Exp $
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

use SOAP::Lite;

my $User = 'some_user';
my $Pw   = 'some_pass';
my $RPC = new SOAP::Lite( proxy => 'http://127.0.0.1/otrs/rpc.pl', uri => 'http://localhost/Core' );

# create a new ticket number
print "NOTICE: TicketObject->TicketCreateNumber()\n";
my $som = $RPC->Dispatch( $User, $Pw, 'TicketObject', 'TicketCreateNumber' );
die $som->fault->{faultstring} if $som->fault;
my $TicketNumber = $som->result;
print "NOTICE: New Ticket Number is: $TicketNumber\n";

# get ticket attributes
print "NOTICE: TicketObject->TicketGet(TicketID => 1)\n";
$som = $RPC->Dispatch( $User, $Pw, 'TicketObject', 'TicketGet', TicketID => 1 );
die $som->fault->{faultstring} if $som->fault;
my %Ticket = $som->result;
print "NOTICE: Ticket Number is: $Ticket{TicketNumber}\n";
print "NOTICE: Ticket State is:  $Ticket{State}\n";
print "NOTICE: Ticket Queue is:  $Ticket{Queue}\n";

# create a ticket
my %TicketData = (
    Title        => 'rpc-example.pl test ticket',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => 'www.otrs.com',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

print "NOTICE: TicketObject->TicketCreate(%TicketData)\n";
$som = $RPC->Dispatch( $User, $Pw, 'TicketObject', 'TicketCreate', %TicketData );
die $som->fault->{faultstring} if $som->fault;
my $TicketID = $som->result;
print "NOTICE: TicketID is $TicketID\n";

# delete the ticket
print "NOTICE: TicketObject->TicketDelete(TicketID => $TicketID)\n";
$som = $RPC->Dispatch(
    $User, $Pw, 'TicketObject', 'TicketDelete',
    TicketID => $TicketID,
    UserID   => 1
);
die $som->fault->{faultstring} if $som->fault;
my $Feedback = $som->result;
my $Message = $Feedback ? 'was successful' : 'was not successful';
print "NOTICE: Delete Ticket with ID $TicketID $Message\n";

# check if the customer exits
print "NOTICE: CustomerUserObject->CustomerName(UserLogin => 'test-user')\n";
$som = $RPC->Dispatch( $User, $Pw, 'CustomerUserObject', 'CustomerName', UserLogin => 'test-user' );
die $som->fault->{faultstring} if $som->fault;
my $Name = $som->result;
$Message = $Name ? 'exists' : 'does not exist';
print "NOTICE: The customer with the login 'test-user' $Message\n";

exit 0;
