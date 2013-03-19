#!/usr/bin/perl
# --
# bin/otrs.AddQueue.pl - Add Queue from CLI
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::Log;
use Kernel::System::Queue;
use Kernel::System::Group;
use Kernel::System::SystemAddress;
use Kernel::System::Main;

# create common objects
my %CommonObject;
$CommonObject{ConfigObject} = Kernel::Config->new(%CommonObject);
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.AddQueue.pl',
    %CommonObject,
);
$CommonObject{MainObject}          = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}            = Kernel::System::DB->new(%CommonObject);
$CommonObject{QueueObject}         = Kernel::System::Queue->new(%CommonObject);
$CommonObject{GroupObject}         = Kernel::System::Group->new(%CommonObject);
$CommonObject{SystemAddressObject} = Kernel::System::SystemAddress->new(%CommonObject);

# get options
my %Opts;
getopts( 'hg:n:s:S:c:r:u:l:C:', \%Opts );

if ( $Opts{h} ) {
    print STDOUT "otrs.AddQueue.pl - add new queue\n";
    print STDOUT "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n";
    print STDOUT "usage: otrs.AddQueue.pl -n <NAME> -g <GROUP> [-s <SYSTEMADDRESSID> -S \n";
    print STDOUT
        "<SYSTEMADDRESS> -c <COMMENT> -r <FirstResponseTime> -u <UpdateTime> \n";
    print STDOUT "-l <SolutionTime> -C <CalendarID>]\n";
    exit 1;
}

if ( !$Opts{n} ) {
    print STDERR "ERROR: Need -n <NAME>\n";
    exit 1;
}
if ( !$Opts{g} ) {
    print STDERR "ERROR: Need -g <GROUP>\n";
    exit 1;
}

# check group
my $GroupID = $CommonObject{GroupObject}->GroupLookup( Group => $Opts{g} );
if ( !$GroupID ) {
    print STDERR "ERROR: Found no GroupID for $Opts{g}\n";
    exit 1;
}

my $SystemAddressID;

# check System Address
if ( $Opts{S} ) {
    my %SystemAddressList = $CommonObject{SystemAddressObject}->SystemAddressList(
        Valid => 1
    );
    ADDRESS:
    for my $ID ( sort keys %SystemAddressList ) {
        my %SystemAddressInfo = $CommonObject{SystemAddressObject}->SystemAddressGet(
            ID => $ID
        );
        if ( $SystemAddressInfo{Name} eq $Opts{S} ) {
            $SystemAddressID = $ID;
            last ADDRESS;
        }
    }
    if ( !$SystemAddressID ) {
        print STDERR "ERROR: Address $Opts{S} not found\n";
        exit 1;
    }
}

# add queue
my $Success = $CommonObject{QueueObject}->QueueAdd(
    Name            => $Opts{n},
    GroupID         => $GroupID,
    SystemAddressID => $SystemAddressID || $Opts{s} || undef,
    Comment           => $Opts{c} || undef,
    FirstResponseTime => $Opts{r} || undef,
    UpdateTime        => $Opts{u} || undef,
    SolutionTime      => $Opts{l} || undef,
    Calendar          => $Opts{C} || undef,
    ValidID           => 1,
    UserID            => 1,
);

# error handling
if ( !$Success ) {
    print STDERR "ERROR: Can't create queue!\n";
    exit 1;
}

print STDOUT "Queue '$Opts{n}' created.\n";
exit 0;
