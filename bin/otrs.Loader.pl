#!/usr/bin/perl -w
# --
# bin/otrs.Loader.pl - the global test handle
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: otrs.Loader.pl,v 1.2 2010-07-27 05:09:20 cg Exp $
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

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

use Getopt::Std;
use Kernel::System::Loader;
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;

# get options
my %Opts = ();
getopt( 'ho', \%Opts );
if ( $Opts{h} ) {
    print "Loader.pl <Revision $VERSION> - OTRS test handle\n";
    print "Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
    print
        "usage: Loader.pl [-o delete|buil]\n";
    exit 1;
}

# create common objects
my %CommonObject = ();

$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-Test',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);

# create needed objects
$CommonObject{LoaderObject} = Kernel::System::Loader->new(%CommonObject);

if (
    $Opts{o}
    &&
    ( lc( $Opts{o} ) eq 'del' || lc( $Opts{o} ) eq 'delete' )
    )
{
    my $Result = $CommonObject{LoaderObject}->DeleteLoaderCache();
    print $Result;
    exit 1;
}
else {
    print "Invalid option.\n"
}

exit(0);
