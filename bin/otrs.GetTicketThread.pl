#!/usr/bin/perl -w
# --
# bin/otrs.GetTicketThread.pl - to print the whole ticket thread to STDOUT
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: otrs.GetTicketThread.pl,v 1.4 2010-08-06 17:49:20 cr Exp $
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

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::Ticket;
use Kernel::System::User;

# common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.GetTicketThread.pl',
    %CommonObject,
);
$CommonObject{TimeObject}   = Kernel::System::Time->new(%CommonObject);
$CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);
$CommonObject{UserObject}   = Kernel::System::User->new(%CommonObject);

if ( !$ARGV[0] ) {
    print "$0 <Revision $VERSION>\n";
    print "Prints out a ticket with all its articles.\n";
    print "Usage: $0 <TicketID>\n";
    print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n";
    exit 1;
}

my $TicketID = shift;
my %Ticket = $CommonObject{TicketObject}->TicketGet( TicketID => $TicketID );
if ( !%Ticket ) {
    exit 1;
}
print "=====================================================================\n";
for (qw(TicketNumber TicketID Created Queue State Priority Lock CustomerID CustomerUserID)) {
    print "$_: $Ticket{$_}\n" if ( $Ticket{$_} );
}
print "---------------------------------------------------------------------\n";

my @Index = $CommonObject{TicketObject}->ArticleIndex( TicketID => $TicketID );
for (@Index) {
    my %Article = $CommonObject{TicketObject}->ArticleGet( ArticleID => $_ );
    for (qw(ArticleID From To Cc Subject ReplyTo InReplyTo Created SenderType)) {
        print "$_: $Article{$_}\n" if ( $Article{$_} );
    }
    print "Body:\n";
    print "$Article{Body}\n";
    print "---------------------------------------------------------------------\n";
}

1;
