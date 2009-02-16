#!/usr/bin/perl -w
# --
# syncuser_csv2otrs.pl - sync csv user list or otrs
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: syncuser_csv2otrs.pl,v 1.11 2009-02-16 12:50:17 tr Exp $
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

# example of csv file (0;1;2;...)
# [...]
# me1;me1@example.com;Nils;Example;somepass;Mr.;
# [...]

# config options / csv file - column 0-...
my %Fields = ();
$Fields{UserLogin}      = 0;
$Fields{UserEmail}      = 1;
$Fields{UserSalutation} = 5;
$Fields{UserFirstname}  = 2;
$Fields{UserLastname}   = 3;
$Fields{UserPw}         = 4;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";
use strict;
use warnings;

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::User;

# common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-syncuser_csv2otrs.pl',
    %CommonObject
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);
$CommonObject{UserObject} = Kernel::System::User->new(%CommonObject);

# get options
my %Opts = ();
getopt( 's', \%Opts );
my $End = "\n";
if ( !$Opts{s} ) {
    die "Need -s <CSV_FILE>\n";
}

# read csv file
open my $In, '<', $Opts{s} or die "Can't read $Opts{s}: $!";
while (<$In>) {
    my @Line = split( /;/, $_ );

    # check if user extsis
    my %UserData = $CommonObject{UserObject}->GetUserData( User => $Line[ $Fields{UserLogin} ] );

    # if there is no pw in the csv list, gererate one
    if ( !$Line[ $Fields{UserPw} ] ) {
        $Line[ $Fields{UserPw} ] = $CommonObject{UserObject}->GenerateRandomPassword();
    }

    # update user
    if (%UserData) {
        print "Update user '$Line[$Fields{UserLogin}]'\n";
        $CommonObject{UserObject}->UserUpdate(
            UserID         => $UserData{UserID},
            UserSalutation => $Line[ $Fields{UserSalutation} ],
            UserFirstname  => $Line[ $Fields{UserFirstname} ],
            UserLastname   => $Line[ $Fields{UserLastname} ],
            UserLogin      => $Line[ $Fields{UserLogin} ],
            UserPw         => $Line[ $Fields{UserPw} ],
            UserEmail      => $Line[ $Fields{UserEmail} ],
            UserType       => 'User',
            ValidID        => 1,
            ChangeUserID   => 1,
        );
    }

    # add user
    else {
        print "Add user '$Line[$Fields{UserLogin}]'\n";
        $CommonObject{UserObject}->UserAdd(
            UserSalutation => $Line[ $Fields{UserSalutation} ],
            UserFirstname  => $Line[ $Fields{UserFirstname} ],
            UserLastname   => $Line[ $Fields{UserLastname} ],
            UserLogin      => $Line[ $Fields{UserLogin} ],
            UserPw         => $Line[ $Fields{UserPw} ],
            UserEmail      => $Line[ $Fields{UserEmail} ],
            UserType       => 'User',
            ValidID        => 1,
            ChangeUserID   => 1,
        );
    }
}
close $In;
