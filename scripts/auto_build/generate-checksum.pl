#!/usr/bin/perl
# --
# generate-checksum.pl - a tool to generate a md5 index of all files for a release
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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
use lib dirname($RealBin) . "/../";
use lib dirname($RealBin) . "/../Kernel/cpan-lib";

use vars qw($RealBin);

use Getopt::Std;
use Digest::MD5 qw(md5_hex);

my $Start = $RealBin;
$Start =~ s{/scripts/auto_build}{/}smx;
my $Archive = '';

# get options
my %Opts;
getopt( 'hbd', \%Opts );
if ( exists $Opts{h} ) {
    print "generate-checksum.pl - OTRS check sum generator\n";
    print "Copyright (C) 2001-2014 OTRS AG, http://otrs.com/\n";
    print
        "usage: generate-checksum.pl [-b /path/to/ARCHIVE] [-d /path/to/framework]\n";
    exit 1;
}

if ( $Opts{d} ) {
    $Start = $Opts{d};
}
if ( $Opts{b} ) {
    $Archive = $Opts{b};
}
else {
    $Archive = $Start . 'ARCHIVE';
}

my $Output;

print "Writing $Archive ...";
open( $Output, '>', $Archive ) || die "ERROR: Can't write: $Archive";    ## no critic

my @Dirs;
ProcessDirectory($Start);

print " done.\n";
close $Output;

sub ProcessDirectory {
    my $In = shift;

    my @List = glob("$In/*");

    FILE:
    for my $File (@List) {

        # clean up directory name
        $File =~ s{//}{/}smxg;

        # always stay in OTRS directory
        next FILE if $File !~ m{^\Q$Start\E};

        # ignore source code directories, ARCHIVE file
        next FILE if $File =~ m{/.git|/ARCHIVE}smx;

        # if it's a directory
        if ( -d $File ) {
            ProcessDirectory($File);
            next FILE;
        }

        # ignore all non-regular files as links, pipes, sockets etc.
        next FILE if ( !-f $File );

        # if it's a file
        my $OrigFile = $File;
        $File =~ s{$Start}{}smx;
        $File =~ s{^/(.*)$}{$1}smx;

        # ignore directories
        next FILE if $File =~ m{^doc/}smx;
        next FILE if $File =~ m{^var/tmp}smx;
        next FILE if $File =~ m{^var/article}smx;
        next FILE if $File =~ m{js-cache}smx;
        next FILE if $File =~ m{css-cache}smx;

        # next if not readable
        # print "File: $File\n";
        open( my $In, '<', $OrigFile ) || die "ERROR: $!";    ## no critic

        my $DigestGenerator = Digest::MD5->new();
        $DigestGenerator->addfile($In);
        my $Digest = $DigestGenerator->hexdigest();
        close $In;

        print $Output $Digest . '::' . $File . "\n";
    }
    return 1;
}
