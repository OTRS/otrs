#!/usr/bin/perl
# --
# bin/otrs.AddUser.pl - Add User from CLI
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

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::User;
use Kernel::System::Group;

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new(%CommonObject);
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.AddUser',
    %CommonObject,
);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);
$CommonObject{UserObject} = Kernel::System::User->new(%CommonObject);

my %Options;
use Getopt::Std;
getopt( 'flpge', \%Options );
unless ( $ARGV[0] ) {
    print
        "$FindBin::Script [-f firstname] [-l lastname] [-p password] [-g groupname] [-e email] username\n";
    print "\tif you define -g with a valid group name then the user will be added that group\n";
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

if ( $Param{UID} = $CommonObject{UserObject}->UserAdd( %Param, ChangeUserID => 1 ) ) {
    print "User added. user  id is $Param{UID}\n";
}

if ( $Options{g} ) {

    $CommonObject{GroupObject} = Kernel::System::Group->new(%CommonObject);

    $Param{Group} = $Options{g};

    if ( $Param{GID} = $CommonObject{GroupObject}->GroupLookup(%Param) ) {
        print "Found Group.. GID is $Param{GID}", "\n";
    }
    else {
        print "Failed to get Group ID. Perhaps non-existent group..\n";
    }
    if ( $CommonObject{GroupObject}->GroupMemberAdd( %Param, Permission => { 'rw' => 1 } ) ) {
        print "User added to group\n";
    }
    else {
        print "Failed to add user to group\n";
    }
}

exit(0);
