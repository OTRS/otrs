#!/usr/bin/perl -w
# --
# bin/otrs.RefreshSMIMEKeys.pl - normalize SMIME passwords and rename all certificates to the correct hash
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: otrs.RefreshSMIMEKeys.pl,v 1.1.2.2 2012-05-18 23:10:31 cr Exp $
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1.2.2 $) [1];

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Getopt::Std;
use Kernel::Config;
use Kernel::System::DB;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;

#use Kernel::System::Time;

use Kernel::System::Crypt;

# get options
my %Opts = ();
getopt( 'hd', \%Opts );

if ( $Opts{h} ) {
    print "otrs.DeleteCache.pl <Revision $VERSION> - delete OTRS cache\n";
    print "Copyright (C) 2001-2012 OTRS AG, http://otrs.org/\n";
    print "usage: otrs.DeleteCache.pl -d <DETAILS> (short|long) \n";
    exit 1;
}
my %Options;

$Options{Details} = 'Details';
if ( $Opts{d} && lc $Opts{d} eq 'short' ) {
    $Options{Details} = 'ShortDetails';
}

# ---
# common objects
# ---
my %CommonObject;
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.RefreshSMIMEKeys.pl',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);

$CommonObject{CryptObject} = Kernel::System::Crypt->new(
    %CommonObject,
    CryptType => 'SMIME',
);
if ( !$CommonObject{CryptObject} ) {
    print "NOTICE: No SMIME support!\n";
    return;
}

my $CheckCertPathResult = $CommonObject{CryptObject}->CheckCertParth();
print $CheckCertPathResult->{ $Options{Details} };

exit !$CheckCertPathResult->{Success};
