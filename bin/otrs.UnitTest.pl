#!/usr/bin/perl
# --
# bin/otrs.UnitTest.pl - the global test handle
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
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::UnitTest;
use Kernel::System::Main;

# get options
my %Opts;
getopt( 'hdnop', \%Opts );
if ( $Opts{h} ) {
    print "otrs.UnitTest.pl - OTRS test handle\n";
    print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n";
    print
        "usage: otrs.UnitTest.pl [-n Name e.g. Ticket or Queue, or both Ticket:Queue] [-d Directory] [-o ASCII|HTML|XML] [-p PRODUCT]\n";
    exit 1;
}

# create common objects
my %CommonObject;
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.UnitTest',
    %CommonObject,
);
$CommonObject{MainObject}     = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject}     = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}       = Kernel::System::DB->new(%CommonObject);
$CommonObject{UnitTestObject} = Kernel::System::UnitTest->new(
    %CommonObject,
    Output => $Opts{o} || '',
);

$CommonObject{UnitTestObject}->Run(
    Name      => $Opts{n} || '',
    Directory => $Opts{d} || '',
    Product   => $Opts{p} || '',
);

exit 0;
