#!/usr/bin/perl -w
# --
# UnitTest.pl - the global test handle
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: UnitTest.pl,v 1.17 2009-02-26 11:01:01 tr Exp $
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
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

use vars qw($VERSION);
$VERSION = qw($Revision: 1.17 $) [1];

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Encode;
use Kernel::System::DB;
use Kernel::System::UnitTest;
use Kernel::System::Main;

# get options
my %Opts = ();
getopt( 'hqtdnop', \%Opts );
if ( $Opts{h} ) {
    print "UnitTest.pl <Revision $VERSION> - OTRS test handle\n";
    print "Copyright (c) 2001-2009 OTRS AG, http://otrs.org/\n";
    print
        "usage: UnitTest.pl [-n Name e.g. Ticket or Queue, or both Ticket:Queue] [-o ASCII|HTML|XML] [-p PRODUCT]\n";
    exit 1;
}

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-Test',
    %CommonObject,
);
$CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{TimeObject}   = Kernel::System::Time->new( %CommonObject, );

# create needed objects
$CommonObject{DBObject}       = Kernel::System::DB->new(%CommonObject);
$CommonObject{UnitTestObject} = Kernel::System::UnitTest->new(
    %CommonObject,
    Output => $Opts{o} || '',
);

$CommonObject{UnitTestObject}->Run(
    Name    => $Opts{n} || '',
    Product => $Opts{p} || '',
);

exit(0);
