#!/usr/bin/perl
# --
# bin/otrs.ReprocessMails.pl - to (re)process mails from spool directory
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

use File::Spec;
use Getopt::Std;

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;

# get options
my %Opts;
getopt( 'h', \%Opts );
if ( $Opts{'h'} ) {
    print "otrs.ReprocessMails.pl - reprocess mails from spool directory\n";
    print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n";
    print "usage: otrs.ReprocessMails.pl \n";
    exit 1;
}

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.ReprocessMails.pl',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);

my $HomeDir    = $CommonObject{ConfigObject}->Get('Home');
my $SpoolDir   = File::Spec->catfile( $HomeDir, 'var/spool' );
my $PostMaster = File::Spec->catfile( $HomeDir, 'bin/otrs.PostMaster.pl' );

if ( !-d $SpoolDir ) {
    die "No spooldir found: $SpoolDir does not exist!\n";
}

print "Processing mails in $SpoolDir\n";

my @Files = $CommonObject{MainObject}->DirectoryRead(
    Directory => $SpoolDir,
    Filter    => '*',
);

for my $File (@Files) {
    print "Processing $File... ";
    my $Result = system("\"$^X\" \"$PostMaster\" <  $File ");

    if ( !$Result ) {
        $CommonObject{LogObject}->Log(
            Priority => 'info',
            Message  => "Successfully reprocessed email $File.",
        );
        unlink $File;
        print "Ok.\n\n"
    }
    else {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "Could not re-process email $File.",
        );
        print "Fail.\n\n"
    }
}

print "Done.\n";

exit 0;
