#!/usr/bin/perl
# --
# bin/otrs.UnitTest.pl - the global test handle
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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
my %Opts;
getopt( 'dnops', \%Opts );
if ( $Opts{h} ) {
    print "otrs.UnitTest.pl - Run OTRS unit tests\n";
    print "Copyright (C) 2001-2015 OTRS AG, http://otrs.com/\n";
    print <<EOF;
Usage: otrs.UnitTest.pl
    [-n Name]           # Single Tests to run, e.g. 'Ticket', 'Queue', or 'Ticket:Queue'
    [-d Directory]      # Test directory to process
    [-o ASCII|HTML|XML]
    [-p PRODUCT]
    [-s URL]            # Submit test results to unit test server
EOF
    exit 1;
}

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.UnitTest',
    },
    'Kernel::System::UnitTest' => {
        Output => $Opts{o} || '',
    },
);

$Kernel::OM->Get('Kernel::System::UnitTest')->Run(
    Name      => $Opts{n} || '',
    Directory => $Opts{d} || '',
    Product   => $Opts{p} || '',
    SubmitURL => $Opts{s} || '',
);

exit 0;
