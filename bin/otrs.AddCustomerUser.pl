#!/usr/bin/perl
# --
# bin/otrs.AddCustomerUser.pl - Add User from CLI
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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

use Kernel::System::ObjectManager;

# create common objects
local $Kernel::OM = Kernel::System::ObjectManager->new(
    LogObject => {
        LogPrefix => 'OTRS-otrs.AddCustomerUser.pl',
    },
);
my %CommonObject = $Kernel::OM->ObjectHash(
    Objects => [
        qw(ConfigObject EncodeObject LogObject TimeObject
            MainObject DBObject CustomerUserObject)
    ],
);

my %Options;
use Getopt::Std;
getopt( 'flpgec', \%Options );
if ( !$ARGV[0] ) {
    print
        "$FindBin::Script [-f firstname] [-l lastname] [-p password] [-g groupname] [-e email] [-c CustomerID] username\n";
    print "\tif you define -g with a valid group name then the user will be added that group\n";
    print "\n";
    exit;
}

my %Param;

#user id of the person adding the record
$Param{UserID} = '1';

#Validrecord
$Param{ValidID} = '1';

$Param{Source}         = 'CustomerUser';
$Param{UserFirstname}  = $Options{f};
$Param{UserLastname}   = $Options{l};
$Param{UserCustomerID} = defined $Options{c} ? $Options{c} : $ARGV[0];
$Param{UserLogin}      = $ARGV[0];
$Param{UserPassword}   = $Options{p};
$Param{UserEmail}      = $Options{e};

if ( $Param{UID} = $CommonObject{CustomerUserObject}->CustomerUserAdd( %Param, ChangeUserID => 1 ) )
{
    print "Customer user added. Username is $Param{UID}\n";
}

exit(0);
