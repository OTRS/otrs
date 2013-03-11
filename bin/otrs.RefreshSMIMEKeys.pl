#!/usr/bin/perl
# --
# bin/otrs.RefreshSMIMEKeys.pl - normalize SMIME private secrets and rename all certificates to the correct hash
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
use utf8;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use vars qw($VERSION);

use Getopt::Std;

use Kernel::Config;
use Kernel::System::DB;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Crypt;

# get options
my %Opts = ();
getopt( 'hdf', \%Opts );

if ( $Opts{h} ) {
    print "otrs.RefreshSMIMEKeys.pl <Revision $VERSION> - fix SMIME certificates private keys and"
        . " secrets filenames\n";
    print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n";
    print "usage: otrs.RefreshSMIMEKeys.pl -d <DETAILS> (short|long) [-f (force to execute even"
        . " if SMIME is not enabled in SysConfig)]  \n";
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

# check for force option to activate SMIME support in SysConfig during the execution of this script
if ( exists $Opts{f} ) {
    $CommonObject{ConfigObject}->Set(
        Key   => 'SMIME',
        Value => 1,
    );
}

$CommonObject{CryptObject} = Kernel::System::Crypt->new(
    %CommonObject,
    CryptType => 'SMIME',
);

if ( !$CommonObject{CryptObject} ) {
    print "NOTICE: No SMIME support!\n";

    my $SMIMEActivated = $CommonObject{ConfigObject}->Get('SMIME');
    my $CertPath       = $CommonObject{ConfigObject}->Get('SMIME::CertPath');
    my $PrivatePath    = $CommonObject{ConfigObject}->Get('SMIME::PrivatePath');
    my $OpenSSLBin     = $CommonObject{ConfigObject}->Get('SMIME::Bin');

    if ( !$SMIMEActivated ) {
        print "SMIME is not activated in SysConfig!\n";
    }
    elsif ( !-e $OpenSSLBin ) {
        print "No such $OpenSSLBin!\n";
    }
    elsif ( !-x $OpenSSLBin ) {
        print "$OpenSSLBin not executable!\n";
    }
    elsif ( !-e $CertPath ) {
        print "No such $CertPath!\n";
    }
    elsif ( !-d $CertPath ) {
        print "No such $CertPath directory!\n";
    }
    elsif ( !-w $CertPath ) {
        print "$CertPath not writable!\n";
    }
    elsif ( !-e $PrivatePath ) {
        print "No such $PrivatePath!\n";
    }
    elsif ( !-d $PrivatePath ) {
        print "No such $PrivatePath directory!\n";
    }
    elsif ( !-w $PrivatePath ) {
        print "$PrivatePath not writable!\n";
    }
    exit 1;
}

my $CheckCertPathResult = $CommonObject{CryptObject}->CheckCertPath();
print $CheckCertPathResult->{ $Options{Details} };

exit !$CheckCertPathResult->{Success};
