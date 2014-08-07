#!/usr/bin/perl
# --
# bin/otrs.AddUser2Role.pl - Assign users to Roles from CLI
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

local $Kernel::OM = Kernel::System::ObjectManager->new(
    LogObject => {
        LogPrefix => 'OTRS-otrs.AddUser2Role.pl',
    },
);

# get options
my %Opts;
getopt( 'ur', \%Opts );
if ( !$Opts{r} || !$Opts{u} ) {
    print "$0 - assign Users to Roles\n";
    print "Copyright (C) 2001-2014 OTRS AG, http://otrs.com/\n";
    print "usage: $FindBin::Script -u <USER> -r <ROLE> \n";
    exit 1;
}

# check user
my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup( UserLogin => $Opts{u} );
if ( !$UserID ) {
    print STDERR "ERROR: User $Opts{u} does not exist.\n";
    exit 1;
}
my $RoleID = $Kernel::OM->Get('Kernel::System::Group')->RoleLookup( Role => $Opts{r} );
if ( !$RoleID ) {
    print STDERR "ERROR: Role $Opts{r} does not exist.\n";
    exit 1;
}

# add user 2 role
if (
    !$Kernel::OM->Get('Kernel::System::Group')->GroupUserRoleMemberAdd(
        UID    => $UserID,
        RID    => $RoleID,
        Active => 1,
        UserID => 1,
    )
    )
{
    print STDERR "ERROR: Can't set permissions!\n";
    exit 1;
}
else {
    print "Role '$Opts{r}' added to user '$Opts{u}'\n";
    exit(0);
}
