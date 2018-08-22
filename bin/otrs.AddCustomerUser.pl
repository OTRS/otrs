#!/usr/bin/perl
# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Getopt::Std;

use Kernel::System::ObjectManager;

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.AddCustomerUser.pl',
    },
);

my %Options;
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

if (
    $Param{UID} = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd( %Param, ChangeUserID => 1 )
    )
{
    print "Customer user added. Username is $Param{UID}\n";
}

exit(0);
