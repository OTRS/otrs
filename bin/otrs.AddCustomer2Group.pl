#!/usr/bin/perl
# --
# bin/otrs.AddCustomer2Group.pl - add customer to a group
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

use Getopt::Std;

use Kernel::System::ObjectManager;

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.AddCustomer2Group',
    },
);

# get options
my %Opts;
getopt( 'gup', \%Opts );

if ( $Opts{h} || !$Opts{g} || !$Opts{u} || !$Opts{p} ) {
    print "otrs.AddCustomer2Group.pl - add customer to a group\n";
    print "Copyright (C) 2001-2014 OTRS AG, http://otrs.com/\n";
    print "usage: otrs.AddCustomer2Group.pl -u customerlogin -g groupname -p ro|rw\n";
    exit 1;
}

my %Param = (
    UserID     => '1',
    ValidID    => '1',
    UID        => $Opts{u},
    Group      => $Opts{g},
    Permission => {
        $Opts{p} => 1,
    },
);

my $CustomerName = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerName(
    UserLogin => $Param{UID},
);
if ( !$CustomerName ) {
    print STDERR "ERROR: Failed to get Customer data. The login '$Opts{u}' does not exist.\n";
    exit 1;
}

$Param{GID} = $Kernel::OM->Get('Kernel::System::CustomerGroup')->GroupLookup(%Param);

if ( !$Param{GID} ) {
    print STDERR
        "ERROR: Failed to get Group ID. The group '$Param{Group}' does not exist.\n";
    exit;
}

print "GID: $Param{Group}/$Param{GID} \n";
print "Customer: $Param{UID} - '$CustomerName' \n";
print "Permission: $Opts{p} \n";

if ( !$Kernel::OM->Get('Kernel::System::CustomerGroup')->GroupMemberAdd(%Param) ) {
    print STDERR "ERROR: Can't add Customer to group\n";
    exit 1;
}

exit 0;
