#!/usr/bin/perl -w
# --
# CheckDB.pl - to check the db access
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: CheckDB.pl,v 1.14 2006-08-26 17:22:05 martin Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# --

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin)."/Kernel/cpan-lib";

use strict;
use Getopt::Std;

use vars qw($VERSION);
$VERSION = '$Revision: 1.14 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::DB;

# create common objects
my $ConfigObject = Kernel::Config->new();
my $LogObject = Kernel::System::Log->new(
    LogPrefix => 'OTRS-CheckDB',
    ConfigObject => $ConfigObject,
);
my $DBObject = Kernel::System::DB->new(
    LogObject => $LogObject,
    ConfigObject => $ConfigObject,
);

# get options
my %Opts = ();
getopt('s',  \%Opts);
my $End = "\n";
if ($Opts{'s'}) {
    $End = '';
}

# chech database state
if ($DBObject) {
    $DBObject->Prepare(SQL => "SELECT * FROM valid");
    my $Check = 0;
    while (my @RowTmp = $DBObject->FetchrowArray()) {
        $Check++;
    }
    if (!$Check) {
        print "No initial inserts found!$End";
        exit (1);
    }
    else {
        print "It looks Ok!$End";
        exit (0);
    }
}
else {
    print "No database connect!$End";
    exit (1);
}
