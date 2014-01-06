#!/usr/bin/perl -w
# --
# bin/otrs.RebuildConfig.pl - rebuild config
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: otrs.RebuildConfig.pl,v 1.14 2010-08-06 17:49:20 cr Exp $
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

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.14 $) [1];

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::SysConfig;

# ---
# common objects
# ---
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.RebuildConfig.pl',
    %CommonObject,
);
$CommonObject{TimeObject}      = Kernel::System::Time->new(%CommonObject);
$CommonObject{MainObject}      = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}        = Kernel::System::DB->new(%CommonObject);
$CommonObject{SysConfigObject} = Kernel::System::SysConfig->new(%CommonObject);

# ---
# rebuild
# ---
print "otrs.RebuildConfig.pl <Revision $VERSION> - OTRS rebuild default config\n";
print "Copyright (C) 2001-2014 OTRS AG, http://otrs.com/\n";
if ( $CommonObject{SysConfigObject}->WriteDefault() ) {
    print "Done.\n";
    exit;
}
else {
    $CommonObject{LogObject}->Log( Priority => 'error' );
    exit 1;
}
