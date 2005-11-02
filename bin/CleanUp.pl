#!/usr/bin/perl -w
# --
# bin/CleanUp.pl - to cleanup, remove used tmp data of ipc, database or fs
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CleanUp.pl,v 1.2 2005-11-02 14:34:30 rk Exp $
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

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::Time;
use Kernel::System::AuthSession;

# get options
my %Opts = ();
getopt('h', \%Opts);
if ($Opts{'h'}) {
    print "CleanUp.pl <Revision $VERSION> - OTRS cleanup\n";
    print "Copyright (c) 2001-2003 Martin Edenhofer <martin\@otrs.org>\n";
    print "usage: CleanUp.pl \n";
    exit 1;
}
# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-CleanUp',
    %CommonObject,
);
# create tmp storage objects
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{AuthSessionObject} = Kernel::System::AuthSession->new(%CommonObject);
# clean up tmp storage
print "Cleaning up LogCache ...";
if ($CommonObject{LogObject}->CleanUp()) {
    print " done.\n";
}
else {
    print " failed.\n";
}
print "Cleaning up SessionData...";
if ($CommonObject{AuthSessionObject}->CleanUp()) {
    print " done.\n";
}
else {
    print " failed.\n";
}

exit (0);
