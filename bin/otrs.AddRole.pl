#!/usr/bin/perl -w
# --
# bin/otrs.AddRole.pl - add new system roles
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: otrs.AddRole.pl,v 1.4 2011-11-03 21:00:04 mb Exp $
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

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::Group;
use Kernel::System::Main;

my %Param;
my %CommonObject;
my %opts;

use Getopt::Std;
getopts( 'c:n:h', \%opts );

if ( $opts{h} ) {
    print STDERR "Usage: $0 [-c <comment>] -n <rolename>\n";
    exit;
}

if ( !$opts{n} ) {
    print STDERR "ERROR: Need -n <rolename>\n";
    exit 1;
}

# create common objects
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.AddRole.pl',
    %CommonObject,
);
$CommonObject{MainObject}  = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}    = Kernel::System::DB->new(%CommonObject);
$CommonObject{GroupObject} = Kernel::System::Group->new(%CommonObject);

# user id of the person adding the record
$Param{UserID} = '1';

# Validrecord
$Param{ValidID} = '1';
$Param{Comment} = $opts{c} || '';
$Param{Name}    = $opts{n} || '';

if ( my $RID = $CommonObject{GroupObject}->RoleAdd(%Param) ) {
    print "Role '$opts{n}' added. Role id is '$RID'\n";
}
else {
    print STDERR "ERROR: Can't add role\n";
}

exit(0);
