#!/usr/bin/perl -w
# --
# bin/otrs.AddCustomerUser.pl - Add User from CLI
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
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

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

use vars qw (%opts);
use Getopt::Std;
getopt( 'flpgec', \%opts );
unless ( $ARGV[0] ) {
    print
        "$FindBin::Script [-f firstname] [-l lastname] [-p password] [-g groupname] [-e email] [-c CustomerID] username\n";
    print "\tif you define -g with a valid group name then the user will be added that group\n";
    print "\n";
    exit;
}

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::CustomerUser;

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new(%CommonObject);
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}
    = Kernel::System::Log->new( %CommonObject, LogPrefix => 'OTRS-otrs.AddCustomerUser.pl' );
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);
$CommonObject{UserObject} = Kernel::System::CustomerUser->new(%CommonObject);

my %Param;
undef %Param;

#user id of the person adding the record
$Param{UserID} = '1';

#Validrecord
$Param{ValidID} = '1';

$Param{Source}         = 'CustomerUser';
$Param{UserFirstname}  = $opts{f};
$Param{UserLastname}   = $opts{l};
$Param{UserCustomerID} = defined $opts{c} ? $opts{c} : $ARGV[0];
$Param{UserLogin}      = $ARGV[0];
$Param{UserPassword}   = $opts{p};
$Param{UserEmail}      = $opts{e};

if ( $Param{UID} = $CommonObject{UserObject}->CustomerUserAdd( %Param, ChangeUserID => 1 ) ) {
    print "Customer user added. Username is $Param{UID}\n";
}

exit(0);
