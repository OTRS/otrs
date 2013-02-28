#!/usr/bin/perl
# --
# bin/otrs.AddUser2Role.pl - Assign users to Roles from CLI
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::Log;
use Kernel::System::Queue;
use Kernel::System::Group;
use Kernel::System::Main;
use Kernel::System::User;

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new(%CommonObject);
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.AddUser2Role.pl',
    %CommonObject,
);
$CommonObject{MainObject}  = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}    = Kernel::System::DB->new(%CommonObject);
$CommonObject{TimeObject}  = Kernel::System::Time->new(%CommonObject);
$CommonObject{GroupObject} = Kernel::System::Group->new(%CommonObject);
$CommonObject{UserObject}  = Kernel::System::User->new(%CommonObject);

# get options
my %Opts;
getopt( 'ur', \%Opts );
if ( !$Opts{r} || !$Opts{u} ) {
    print "$0 <Revision $VERSION> - assign Users to Roles\n";
    print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n";
    print "usage: $FindBin::Script -u <USER> -r <ROLE> \n";
    exit 1;
}

# check user
my $UserID = $CommonObject{UserObject}->UserLookup( UserLogin => $Opts{u} );
if ( !$UserID ) {
    print STDERR "ERROR: User $Opts{u} does not exist.\n";
    exit 1;
}
my $RoleID = $CommonObject{GroupObject}->RoleLookup( Role => $Opts{r} );
if ( !$RoleID ) {
    print STDERR "ERROR: Role $Opts{r} does not exist.\n";
    exit 1;
}

# add user 2 role
if (
    !$CommonObject{GroupObject}->GroupUserRoleMemberAdd(
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
