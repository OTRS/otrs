#!/usr/bin/perl
# --
# bin/otrs.AddUser.pl - Add User from CLI
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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

use Getopt::Long;

use Kernel::System::ObjectManager;

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.AddUser',
    },
);

my %Options;
GetOptions(
    \%Options,
    'f=s',
    'l=s',
    'p=s',
    'g=s@',
    'e=s',
    'h=s',
);

if ( !$ARGV[0] || $Options{h} ) {
    print
        "$FindBin::Script [-f firstname] [-l lastname] [-p password] [-g groupname]... [-e email] username\n";
    print "\tif you define -g with a valid group name then the user will be added that group\n";
    print "\tyou can define multiple groups line this: \"-g admin -g users\"\n";
    print "\n";
    exit;
}

my %Param;

#user id of the person adding the record
$Param{UserID} = '1';

#Validrecord
$Param{ValidID} = '1';

$Param{UserFirstname} = $Options{f};
$Param{UserLastname}  = $Options{l};
$Param{UserPw}        = $Options{p};
$Param{UserLogin}     = $ARGV[0];
$Param{UserEmail}     = $Options{e};

my %Groups;
if ( $Options{g} ) {
    my %GroupList = reverse $Kernel::OM->Get('Kernel::System::Group')->GroupList();

    GROUP:
    for my $Group ( @{ $Options{g} } ) {

        if ( !$GroupList{$Group} ) {
            die "Group '$Group' does not exist.\n";
        }
        $Groups{ $GroupList{$Group} } = $Group;
    }
}

if ( $Param{UID} = $Kernel::OM->Get('Kernel::System::User')->UserAdd( %Param, ChangeUserID => 1 ) )
{
    print "User $Param{UserLogin} added. User id is $Param{UID}.\n";
}
else {
    die "User not added!\n";
}

for my $GroupID ( sort keys %Groups ) {

    my $Success = $Kernel::OM->Get('Kernel::System::Group')->PermissionGroupUserAdd(
        UID        => $Param{UID},
        GID        => $GroupID,
        Permission => { 'rw' => 1 },
        UserID     => $Param{UserID},
    );
    if ($Success) {
        print "User added to group '$Groups{$GroupID}'\n";
    }
    else {
        die "Failed to add user to group '$Groups{$GroupID}'.\n";
    }
}

exit 0;
