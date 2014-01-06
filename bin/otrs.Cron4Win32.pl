#!/usr/bin/perl -w
# --
# bin/otrs.Cron4Win32.pl - a script to generate a full crontab file for OTRS
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: otrs.Cron4Win32.pl,v 1.7 2011-06-11 19:03:46 mb Exp $
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
$VERSION = qw($Revision: 1.7 $) [1];

my $PerlExe     = "";
my $Directory   = "";
my $CronTabFile = "";
my $OTRSHome    = "";

opendir( my $DirHandle, $Directory ) or die "ERROR: Can't open $Directory: $!";

my @Entries = readdir($DirHandle);
closedir($DirHandle);
open my $CronTab, '>', $CronTabFile
    or die "ERROR: Can't write to file $CronTabFile: $!";
CRONFILE:
for my $CronData (@Entries) {
    next CRONFILE if ( !-f "$Directory/$CronData" );
    next CRONFILE if ( $CronData eq 'postmaster.dist' );
    open( my $Data, '<', "$Directory/$CronData" )
        or die "ERROR: Can't open file $Directory/$CronData: $!";
    LINE:
    while ( my $Line = <$Data> ) {
        next LINE if ( $Line =~ m{ \A \# }xms );
        next LINE if ( $Line eq "\n" );

        # replace $HOME with path to Perl plus path to script
        $Line =~ s{\$HOME}{$PerlExe $OTRSHome}xms;

        # there's no /dev/null on Win32, remove it:
        $Line =~ s{>>\s*/dev/null}{}xms;
        print $CronTab "$Line";
    }
    close($Data);
}
close($CronTab);

1;
