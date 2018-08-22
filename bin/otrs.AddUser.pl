#!/usr/bin/perl -w
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

use vars qw (%opts);
use Getopt::Std;
getopt( 'flpge', \%opts );
unless ( $ARGV[0] ) {
    print
        "$FindBin::Script [-f firstname] [-l lastname] [-p password] [-g groupname] [-e email] username\n";
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
use Kernel::System::User;

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

my %Param;
undef %Param;

#user id of the person adding the record
$Param{UserID} = '1';

#Validrecord
$Param{ValidID} = '1';

$Param{UserFirstname} = $opts{f};
$Param{UserLastname}  = $opts{l};
$Param{UserPw}        = $opts{p};
$Param{UserLogin}     = $ARGV[0];
$Param{UserEmail}     = $opts{e};

if ( $Param{UID} = $CommonObject{UserObject}->UserAdd( %Param, ChangeUserID => 1 ) ) {
    print "User added. user  id is $Param{UID}\n";
}

if ( $opts{g} ) {

    # bring in the groups module
    require Kernel::System::Group;
    import Kernel::System::Group;
    $CommonObject{GroupObject} = Kernel::System::Group->new(%CommonObject);

    $Param{Group} = $opts{g};

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
