#!/usr/bin/perl -w
# --
# bin/otrs.AddTicketType.pl - add new Ticket Types
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: otrs.AddTicketType.pl,v 1.3 2011-03-25 13:53:58 ep Exp $
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
use lib dirname($RealBin) . "/Kernel/cpan-lib";

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::Type;
use Kernel::System::Main;

my %Param;
my %CommonObject;
my %opts;

use Getopt::Std;
getopts( 'n:h', \%opts );

if ( $opts{h} ) {
    print STDERR "Usage: $FindBin::Script -n <Type>\n";
    exit;
}

if ( !$opts{n} ) {
    print STDERR "ERROR: Need -n <Type>\n";
    exit 1;
}

# create common objects
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}
    = Kernel::System::Log->new( %CommonObject, LogPrefix => 'OTRS-otrs.TicketType' );
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);
$CommonObject{TypeObject} = Kernel::System::Type->new(%CommonObject);

# user id of the person adding the record
$Param{UserID} = '1';

# Validrecord
$Param{ValidID} = '1';
$Param{Name} = $opts{n} || '';

if ( my $RID = $CommonObject{TypeObject}->TypeAdd(%Param) ) {
    print "Ticket type '$opts{n}' added. Type id is '$RID'\n";
}
else {
    print STDERR "ERROR: Can't add type\n";
}

exit(0);
