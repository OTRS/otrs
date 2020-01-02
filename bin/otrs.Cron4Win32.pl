#!/usr/bin/perl -w
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);

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
