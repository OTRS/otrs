#!/usr/bin/perl
# --
# bin/otrs.CheckSum.pl - a tool to compare changes in an installation
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

use vars qw($VERSION $RealBin);

use Getopt::Std;
use Digest::MD5 qw(md5_hex);

my $Start = $RealBin;
$Start =~ s{/bin}{/}smx;
my $Archive = '';
my $Action  = 'compare';
my %Compare;

# get options
my %Opts;
getopt( 'habd', \%Opts );
if ( exists $Opts{h} || !keys %Opts ) {
    print "otrs.CheckSum.pl <Revision $VERSION> - OTRS check sum\n";
    print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n";
    print
        "usage: otrs.CheckSum.pl -a create|compare [-b /path/to/ARCHIVE] [-d /path/to/framework]\n";
    exit 1;
}

if ( $Opts{a} && $Opts{a} eq 'create' ) {
    $Action = $Opts{a};
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

if ( $Action eq 'create' ) {
    print "Writing $Archive ...";
    open( $Output, '>', $Archive ) || die "ERROR: Can't open: $Archive";    ## no critic
}
else {
    open( my $In, '<', $Archive ) || die "ERROR: Can't open: $Archive";     ## no critic
    while (<$In>) {
        my @Row = split( /::/, $_ );
        chomp $Row[1];
        $Compare{ $Row[1] } = $Row[0];
    }
    close $In;
}

my @Dirs;
R($Start);
for my $File ( sort keys %Compare ) {

    #print "Notice: Removed $Compare{$File}\n";
    print "Notice: Removed $File\n";
}
if ( $Action eq 'create' ) {
    print " done.\n";
    close $Output;
}

sub R {
    my $In = shift;

    my @List = glob("$In/*");

    FILE:
    for my $File (@List) {

        # clean up directory name
        $File =~ s/\/\//\//g;

        # always stay in OTRS directory
        next FILE if $File !~ /^\Q$Start\E/;

        # ignore source code directories, ARCHIVE file
        next if $File =~ /Entries|Repository|Root|CVS|.git|ARCHIVE/;

        # if it's a directory
        if ( -d $File ) {
            R($File);
            next FILE;

            # print "Directory: $File\n";
        }

        # ignore all non-regular files as links, pipes, sockets etc.
        next FILE if ( !-f $File );

        # if it's a file
        my $OrigFile = $File;
        $File =~ s/$Start//;
        $File =~ s/^\/(.*)$/$1/;

        # ignore directories
        next      if $File =~ /^doc\//;
        next FILE if $File =~ /^var\/tmp/;
        next FILE if $File =~ /^var\/article/;
        next FILE if $File =~ /js-cache/;
        next FILE if $File =~ /css-cache/;

        # next if not readable
        # print "File: $File\n";
        open( my $In, '<', $OrigFile ) || die "ERROR: $!";    ## no critic
        my $DigestGenerator = Digest::MD5->new();
        $DigestGenerator->addfile($In);
        my $Digest = $DigestGenerator->hexdigest();
        close $In;
        if ( $Action eq 'create' ) {
            print $Output $Digest . '::' . $File . "\n";
        }
        else {
            if ( !$Compare{$File} ) {
                print "Notice: New $File\n";
            }
            elsif ( $Compare{$File} ne $Digest ) {
                print "Notice: Dif $File\n";
            }
            if ( defined $Compare{$File} ) {
                delete $Compare{$File};
            }
        }
    }
    return 1;
}
