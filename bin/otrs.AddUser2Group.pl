#!/usr/bin/perl
# --
# bin/otrs.AddUser2Group.pl - Add User to a Group
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
        LogPrefix => 'OTRS-otrs.AddUser2Group',
    },
);
my %CommonObject = $Kernel::OM->ObjectHash(
    Objects => [
        qw(ConfigObject EncodeObject LogObject TimeObject MainObject DBObject UserObject GroupObject)
    ],
);

my %Param;
my %Opts;

use Getopt::Std;
getopt( 'guph', \%Opts );

if ( $Opts{h} || !$Opts{g} || !$Opts{u} || !$Opts{p} ) {
    print STDERR
        "Usage: $0 -g groupname -u username -p ro|rw\n";
    exit;
}

# user id
$Param{UserID} = '1';

# valid id
$Param{ValidID} = '1';

$Param{Permission}->{ $Opts{p} } = 1;
$Param{UserLogin}                = $Opts{u};
$Param{Group}                    = $Opts{g};

$Param{UID} = $CommonObject{UserObject}->UserLookup( UserLogin => $Param{UserLogin} );
if ( !$Param{UID} )
{
    print STDERR "ERROR: Failed to get User ID. Perhaps non-existent user..\n";
    exit 1;
}

$Param{GID} = $CommonObject{GroupObject}->GroupLookup(%Param);

if ( !$Param{GID} ) {
    print STDERR "ERROR: Failed to get Group ID. Perhaps non-existent group..\n";
    exit;
}

print "GID: $Param{Group}/$Param{GID} \n";
print "UID: $Param{UserLogin}/$Param{UID} \n";
print "Permission: $Opts{p} \n";

if ( !$CommonObject{GroupObject}->GroupMemberAdd(%Param) ) {
    print STDERR "ERROR: Can't add user to group\n";
    exit 1;
}
else {
    exit(0);
}
