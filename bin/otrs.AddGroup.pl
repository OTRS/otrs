#!/usr/bin/perl
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

use Kernel::System::ObjectManager;

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.AddGroup.pl',
    },
);

my %Options;

use Getopt::Std;
getopts( 'c:n:h', \%Options );

if ( $Options{h} ) {
    print STDERR "Usage: $0 [-c <comment>] -n <groupname>\n";
    exit;
}

if ( !$Options{n} ) {
    print STDERR "ERROR: Need -n groupname\n";
    exit 1;
}

# user id of the person adding the record
my %Param;
$Param{UserID} = '1';

# Validrecord
$Param{ValidID} = '1';
$Param{Comment} = $Options{c} || '';
$Param{Name}    = $Options{n} || '';

if ( my $GID = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(%Param) ) {
    print "Group '$Options{n}' added. Group id is '$GID'\n";
}
else {
    print STDERR "ERROR: Can't add group\n";
}

exit(0);
