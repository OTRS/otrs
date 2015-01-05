#!/usr/bin/perl -w
# --
# bin/otrs.AddSystemAddress.pl - add new system addresses
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: otrs.AddSystemAddress.pl,v 1.2 2011-11-03 21:00:04 mb Exp $
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

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::Group;
use Kernel::System::Main;
use Kernel::System::Queue;
use Kernel::System::SystemAddress;

my %Param;
my %CommonObject;
my %opts;

use Getopt::Std;
getopts( 'c:d:e:q:h', \%opts );

if ( $opts{h} ) {
    print STDERR "Usage: $0 [-c <comment>] -d <display name> \n";
    print STDERR "    -e <email address> -q <queue name>\n";
    exit;
}

if ( !$opts{d} ) {
    print STDERR "ERROR: Need -d <display name>\n";
    exit 1;
}
if ( !$opts{e} ) {
    print STDERR "ERROR: Need -e <email address>\n";
    exit 1;
}
if ( !$opts{q} ) {
    print STDERR "ERROR: Need -q <queue name>\n";
    exit 1;
}

# create common objects
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.AddSystemAddress.pl',
    %CommonObject,
);
$CommonObject{MainObject}          = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}            = Kernel::System::DB->new(%CommonObject);
$CommonObject{GroupObject}         = Kernel::System::Group->new(%CommonObject);
$CommonObject{QueueObject}         = Kernel::System::Queue->new(%CommonObject);
$CommonObject{SystemAddressObject} = Kernel::System::SystemAddress->new(%CommonObject);

# user id of the person adding the record
$Param{UserID} = '1';

# validrecord
$Param{ValidID}  = '1';
$Param{Comment}  = $opts{c} || '';
$Param{Realname} = $opts{d} || '';
$Param{Queue}    = $opts{q};
$Param{Name}     = $opts{e};

# check if queue exists
$Param{QueueID} = $CommonObject{QueueObject}->QueueLookup(
    Queue => $Param{Queue},
);
if ( !$Param{QueueID} ) {
    print STDERR "ERROR: Queue $Param{Queue} not found\n";
    exit 1;
}

# check if system address already exists
my $SystemExists = $CommonObject{SystemAddressObject}->SystemAddressIsLocalAddress(
    Address => $Param{Name},
);
if ($SystemExists) {
    print STDERR "ERROR: SystemAddress $Param{Name} already exists\n";
    exit 1;
}

if ( my $ID = $CommonObject{SystemAddressObject}->SystemAddressAdd(%Param) ) {
    print "System Address '$opts{e}' added. Id is '$ID'\n";
}
else {
    print STDERR "ERROR: Can't add System Address\n";
}

exit(0);
