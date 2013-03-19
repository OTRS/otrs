#!/usr/bin/perl
# --
# bin/otrs.Cron4Win32.pl - a script to generate a full crontab file for OTRS
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
use File::Spec;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

# $CronTabFile is replaced by the Windows Installer if it is empty
my $CronTabFile = "";

my $OTRSHome = dirname($RealBin);
my $CronDir = File::Spec->catfile( $OTRSHome, 'var/cron' );

# if $CronTabFile is not set by windows installer, for instance
# with a manual installation, require an argument for the location
if ( !$CronTabFile ) {
    if ( !$ARGV[0] ) {
        print "Usage: $0 [outputfile]\n\n";
        print "Example: $0 C:\\CronW\\crontab.txt\n";
        exit 1;
    }
    else {
        $CronTabFile = $ARGV[0];
    }
}

opendir( my $DirHandle, $CronDir ) || die "ERROR: Can't open $CronDir: $!";

my @Entries = readdir($DirHandle);
closedir($DirHandle);

## no critic
open my $CronTab, '>', $CronTabFile
    || die "ERROR: Can't write to file $CronTabFile: $!";
## use critic
print "Writing to $CronTabFile...\n\n";
CRONFILE:
for my $CronData (@Entries) {
    next CRONFILE if ( !-f "$CronDir/$CronData" );
    next CRONFILE if ( $CronData eq 'postmaster.dist' );
    ## no critic
    open( my $Data, '<', "$CronDir/$CronData" )
        || die "ERROR: Can't open file $CronDir/$CronData: $!";
    ## use critic
    LINE:
    while ( my $Line = <$Data> ) {
        next LINE if ( $Line =~ m{ \A \# }xms );
        next LINE if ( $Line eq "\n" );

        # replace $HOME with path to Perl plus path to script
        $Line =~ s{\$HOME}{$^X $OTRSHome}xms;

        # there's no /dev/null on Win32, remove it:
        $Line =~ s{>>\s*/dev/null}{}xms;
        print $CronTab "$Line";
    }
    close($Data);
}
close($CronTab);

print "Done.\n";

1;
