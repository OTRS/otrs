#!/usr/bin/perl -w
# --
# bin/otrs.CryptPassword.pl - to crypt database password for Kernel/Config.pm
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: otrs.CryptPassword.pl,v 1.3 2010-02-09 00:22:43 martin Exp $
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
$VERSION = qw($Revision: 1.3 $) [1];

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
    LogPrefix    => 'OTRS-CheckDB',
    ConfigObject => $CommonObject{ConfigObject},
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject} = Kernel::System::DB->new( %CommonObject, AutoConnectNo => 1 );

# check args
my $Password = shift;
print
    "bin/otrs.CryptPassword.pl <Revision $VERSION> - to crypt database password for Kernel/Config.pm\n";
print "Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";

if ( !$Password ) {
    print STDERR "Usage: bin/otrs.CryptPassword.pl NEWPW\n";
}
else {
    chomp $Password;
    my $H = $CommonObject{DBObject}->_Encrypt($Password);
    print "Crypted password: {$H}\n";
}
