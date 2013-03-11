#!/usr/bin/perl
# --
# bin/otrs.DeleteCache.pl - delete all caches
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

use Getopt::Long;

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::Cache;

# get options
Getopt::Long::Configure('no_ignore_case');
my %Opts = ();
GetOptions(
    'expired|e' => \$Opts{e},
    'all|a'     => \$Opts{a},
    'help|h'    => \$Opts{h},
    'type|t=s'  => \$Opts{t},
);

print "otrs.DeleteCache.pl <Revision $VERSION> - delete OTRS cache\n";
print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n\n";

if ( $Opts{h} ) {
    print "usage: otrs.DeleteCache.pl [--expired] [--type TYPE]\n";
    exit 1;
}

print "Deleting cache... ";

my %Options;
if ( $Opts{e} ) {
    $Options{Expired} = 1;
}
if ( $Opts{t} ) {
    $Options{Type} = $Opts{t};
}

# ---
# common objects
# ---
my %CommonObject;
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.DeleteCache.pl',
    %CommonObject,
);
$CommonObject{TimeObject}  = Kernel::System::Time->new(%CommonObject);
$CommonObject{MainObject}  = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}    = Kernel::System::DB->new(%CommonObject);
$CommonObject{CacheObject} = Kernel::System::Cache->new(%CommonObject);

# ---
# cleanup
# ---
if ( !$CommonObject{CacheObject}->CleanUp(%Options) ) {
    exit 1;
}

print "Done.\n";
exit;
