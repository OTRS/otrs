#!/usr/bin/perl
# --
# bin/otrs.AddService.pl - add new Services
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
$VERSION = qw($Revision: 1.7 $) [1];

use Getopt::Std;

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::Service;

my %Param;
my %CommonObject;

# create common objects
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}
    = Kernel::System::Log->new( %CommonObject, LogPrefix => 'OTRS-otrs.AddService' );
$CommonObject{MainObject}    = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}      = Kernel::System::DB->new(%CommonObject);
$CommonObject{ServiceObject} = Kernel::System::Service->new(%CommonObject);

my $NoOptions = $ARGV[0] ? 0 : 1;

# get options
my %Opts;
getopts( 'hn:p:c:', \%Opts );

if ( $Opts{h} || $NoOptions ) {
    print STDERR "Usage: $FindBin::Script -n <Name> -p <Parent> -c <Comment>\n";
    exit;
}

if ( !$Opts{n} ) {
    print STDERR "ERROR: Need -n <Name>\n";
    exit 1;
}

my $ServiceName;

# lookup parent service if given
if ( $Opts{p} ) {
    $Param{ParentID} = $CommonObject{ServiceObject}->ServiceLookup(
        Name   => $Opts{p},
        UserID => 1,
    );
    if ( !$Param{ParentID} ) {
        print STDERR "ERROR: Can't add Service: Parent '$Opts{p}' does not exist!\n";
        exit 1;
    }
    $ServiceName = $Opts{p} . '::';
}

$ServiceName .= $Opts{n};

# check if service already exists
my %ServiceList = $CommonObject{ServiceObject}->ServiceList(
    Valid  => 0,
    UserID => 1,
);
my %Reverse = reverse %ServiceList;
if ( $Reverse{$ServiceName} ) {
    print STDERR "ERROR: Can't add Service: Service '$ServiceName' already exists!\n";
    exit 1;
}

# user id of the person adding the record
$Param{UserID} = '1';

# Validrecord
$Param{ValidID} = '1';
$Param{Name}    = $Opts{n} || '';
$Param{Comment} = $Opts{c};

if ( my $ID = $CommonObject{ServiceObject}->ServiceAdd(%Param) ) {
    print "Service '$ServiceName' added. ID is '$ID'\n";
}
else {
    print STDERR "ERROR: Can't add Service\n";
    exit 1;
}

exit(0);
