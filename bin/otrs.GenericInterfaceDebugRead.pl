#!/usr/bin/perl
# --
# bin/otrs.GenericInterfaceDebugRead.pl - the global test handle
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

use vars qw($VERSION);

use Getopt::Std;

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::GenericInterface::DebugLog;

sub PrintHelp {
    print <<"EOF";
otrs.GenericInterfaceDebugRead.pl <Revision $VERSION> - Commandline interface to
     search for debugger entries.

Usage: otrs.GenericInterfaceDebugRead.pl
Options:
    -c        CommunicationID   => '6f1ed002ab5595859014ebf0951522d9',  # optional
    -t        CommunicationType => 'Requester',                         # optional, 'Provider' or 'Requester'
    -a        CreatedAtOrAfter  => '2011-01-01 00:00:00',               # optional
    -b        CreatedAtOrBefore => '2011-12-31 23:59:59',               # optional
    -i        RemoteIP          => '192.168.0.1',                       # optional, must be valid IPv4 or IPv6 address
    -w        WebserviceID      => 1,                                   # optional
    -d        WithData          => 1,                                   # optional
Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
EOF
}

# get options
my %Opts = ();
getopt( 'hctabiwd:', \%Opts );
if ( $Opts{h} ) {
    PrintHelp();
    exit 1;
}

# create common objects
my %CommonObject;
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.GenericInterfaceDebugRead.pl',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);

# create needed objects
my $DebugLogObject = Kernel::System::GenericInterface::DebugLog->new(%CommonObject);
print "Searching for DebugLog entries...\n\n";

# LogSearch
my $LogData = $DebugLogObject->LogSearch(
    CommunicationID   => $Opts{c},
    CommunicationType => $Opts{t},
    CreatedAtOrAfter  => $Opts{a},
    CreatedAtOrBefore => $Opts{b},
    RemoteIP          => $Opts{i},
    WebserviceID      => $Opts{w},
    WithData          => $Opts{d},
);

#    print $CommonObject{MainObject}->Dump(\%Opts);
if ( ref $LogData eq 'ARRAY' ) {
    my $Counter = 0;
    for my $Item ( @{$LogData} ) {
        for my $Key (qw( LogID CommunicationID CommunicationType WebserviceID RemoteIP Created)) {
            print "$Key: $Item->{$Key}, ";
        }
        print "\n";
        if ( $Opts{d} ) {

            # print Data
            for my $DataItem ( @{ $Item->{Data} } ) {
                print "   - ";
                for my $Key (qw( DebugLevel Summary Data Created)) {
                    print "$Key: $DataItem->{$Key}, ";
                }
                print "\n";
            }
        }
        print "\n";
        $Counter++;
    }
    print "\n Log entries found: $Counter \n";
    exit 1;
}
else {
    print "No DebugLog entries were found.\n";
}

exit(0);
