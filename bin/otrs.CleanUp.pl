#!/usr/bin/perl
# --
# bin/otrs.CleanUp.pl - to cleanup, remove used tmp data of ipc, database or fs
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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
use Kernel::System::ObjectManager;

# get options
my %Opts = ();
getopt( 'h', \%Opts );
if ( $Opts{'h'} ) {
    print "otrs.CleanUp.pl - OTRS cleanup\n";
    print "Copyright (C) 2001-2014 OTRS AG, http://otrs.com/\n";
    print "usage: otrs.CleanUp.pl \n";
    exit 1;
}

# create common objects
local $Kernel::OM = Kernel::System::ObjectManager->new(
    LogObject => {
        LogPrefix => 'OTRS-otrs.CleanUp.pl',
    },
);
my %CommonObject = $Kernel::OM->ObjectHash(
    Objects => [qw(LogObject SessionObject)],
);

# create tmp storage objects

# clean up tmp storage
print "Cleaning up LogCache ...";
if ( $CommonObject{LogObject}->CleanUp() ) {
    print " done.\n";
}
else {
    print " failed.\n";
}
print "Cleaning up SessionData...";
if ( $CommonObject{SessionObject}->CleanUp() ) {
    print " done.\n";
}
else {
    print " failed.\n";
}

exit 0;
