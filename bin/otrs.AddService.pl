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

my %Param;

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.AddService',
    },
);

my $NoOptions = $ARGV[0] ? 0 : 1;

# get options
my %Opts;
getopts( 'hn:p:c:', \%Opts );

if ( $Opts{h} || $NoOptions ) {
    print STDERR "Usage: $FindBin::Script -n <Name> -p <Parent> -c <Comment>\n";
    exit;
}

if ( !$Opts{n} ) {
    print STDERR "ERROR: Need -n <Name>\n";
    exit 1;
}

my $ServiceName;

# lookup parent service if given
if ( $Opts{p} ) {
    $Param{ParentID} = $Kernel::OM->Get('Kernel::System::Service')->ServiceLookup(
        Name   => $Opts{p},
        UserID => 1,
    );
    if ( !$Param{ParentID} ) {
        print STDERR "ERROR: Can't add Service: Parent '$Opts{p}' does not exist!\n";
        exit 1;
    }
    $ServiceName = $Opts{p} . '::';
}

$ServiceName .= $Opts{n};

# check if service already exists
my %ServiceList = $Kernel::OM->Get('Kernel::System::Service')->ServiceList(
    Valid  => 0,
    UserID => 1,
);
my %Reverse = reverse %ServiceList;
if ( $Reverse{$ServiceName} ) {
    print STDERR "ERROR: Can't add Service: Service '$ServiceName' already exists!\n";
    exit 1;
}

# user id of the person adding the record
$Param{UserID} = '1';

# Validrecord
$Param{ValidID} = '1';
$Param{Name}    = $Opts{n} || '';
$Param{Comment} = $Opts{c};

if ( my $ID = $Kernel::OM->Get('Kernel::System::Service')->ServiceAdd(%Param) ) {
    print "Service '$ServiceName' added. ID is '$ID'\n";
}
else {
    print STDERR "ERROR: Can't add Service\n";
    exit 1;
}

exit(0);
