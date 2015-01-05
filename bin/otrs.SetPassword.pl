#!/usr/bin/perl -w
# --
# bin/otrs.SetPassword.pl - Changes or Sets password for a user
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: otrs.SetPassword.pl,v 1.4 2011-11-03 21:00:04 mb Exp $
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

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::User;
use Kernel::System::Main;
use Kernel::System::Time;

my $VERSION = qw($Revision: 1.4 $) [1];

my %Opts = ();
getopt( 'h', \%Opts );
if ( $Opts{h} ) {
    print "$0 <Revision $VERSION> - set a new agent password\n";
    print "Copyright (C) 2001-2015 OTRS AG, http://otrs.com/\n";
    print "usage: otrs.SetPassword user password\n";
    exit 1;
}

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new(%CommonObject);
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    %CommonObject,
    LogPrefix => 'OTRS-otrs.SetPassword.pl',
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);
$CommonObject{UserObject} = Kernel::System::User->new(%CommonObject);

my $User = shift;
my $Pw   = shift;

if ( !$User ) {
    print STDERR "ERROR: need user ARG[1]\n";
    exit 1;
}
if ( !$Pw ) {
    print STDERR "ERROR: need password ARG[1]\n";
    exit 1;
}

# user id of the person Changing the record
$CommonObject{UserObject}->SetPassword(
    UserLogin => $User,
    PW        => $Pw,
);

exit 0;
