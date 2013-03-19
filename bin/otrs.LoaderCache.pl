#!/usr/bin/perl
# --
# bin/otrs.LoaderCache.pl - the global test handle
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
use Kernel::System::Loader;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;

sub PrintHelp {
    print <<"EOF";
otrs.LoaderCache.pl - Commandline interface to the
     cache of the CSS/JavaScript loading mechanism of OTRS

Usage: otrs.LoaderCache.pl -o delete

Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
EOF
}

# get options
my %Opts = ();
getopt( 'ho', \%Opts );
if ( $Opts{h} ) {
    PrintHelp();
    exit 1;
}

# create common objects
my %CommonObject = ();

$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.Test',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);

# create needed objects
$CommonObject{LoaderObject} = Kernel::System::Loader->new(%CommonObject);

if ( $Opts{o} && lc( $Opts{o} ) eq 'delete' ) {
    print "Deleting all Loader cache files...\n";
    my @DeletedFiles = $CommonObject{LoaderObject}->CacheDelete();
    if (@DeletedFiles) {
        print "The following files were deleted:\n\t";
        print join "\n\t", @DeletedFiles;
        print "\n";
    }
    else {
        print "No file was deleted.\n";
    }
    exit 0;
}
else {
    PrintHelp();
}

exit 1;
