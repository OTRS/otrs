#!/usr/bin/perl -w
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);

use Getopt::Std;

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix    => 'OTRS-otrs.CheckDB.pl',
    ConfigObject => $CommonObject{ConfigObject},
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);

# get options
my %Opts = ();
getopt( 's', \%Opts );
my $End = "\n";
if ( $Opts{'s'} ) {
    $End = '';
}

# print database information
my $DatabaseDSN  = $CommonObject{ConfigObject}->{DatabaseDSN};
my $DatabaseUser = $CommonObject{ConfigObject}->{DatabaseUser};
print "Trying to connect to database\n";
print "DSN: $DatabaseDSN\n";
print "DatabaseUser: $DatabaseUser\n\n";

# check database state
if ( $CommonObject{DBObject} ) {
    $CommonObject{DBObject}->Prepare( SQL => "SELECT * FROM valid" );
    my $Check = 0;
    while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {
        $Check++;
    }
    if ( !$Check ) {
        print "No initial inserts found!$End";
        exit(1);
    }
    else {
        print "It looks Ok!$End";
        exit(0);
    }
}
else {
    print "No database connect!$End";
    exit(1);
}
