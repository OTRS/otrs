#!/usr/bin/perl -w
# --
# scripts/tools/charset-convert.pl - converts a text file from one to an other one charset
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: charset-convert.pl,v 1.3 2006-10-03 14:34:47 mh Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# --

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

use strict;
use Encode;
use Getopt::Std;

my %Opts = ();
getopt('hsdf', \%Opts);

# usage
if ($Opts{'h'}) {
    print "charset-convert.pl <Revision $VERSION> - convert a charset of a file\n";
    print "Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/\n";
    print "usage: charset-convert.pl -s <SOURCE_CHARSET> -d <DEST_CHARSET> -f <FILE>\n";
    print "       charset-convert.pl -s <SOURCE_CHARSET> -d <DEST_CHARSET> < file\n";
    exit 1;
}

# get charsts
if (!$Opts{'s'}){
    print STDERR "ERROR: Need -s <SOURCE_CHARSET>\n";
    exit 1;
}
if (!$Opts{'d'}) {
    print STDERR "ERROR: Need -d <DEST_CHARSET>\n";
    exit 1;
}

# check stdin
my $In = '';
my @STD = ();

if (!$Opts{'f'}) {
    @STD = <STDIN>;
    foreach (@STD) {
        $In .= $_;
    }
}

# check file
elsif (! -f $Opts{'f'}) {
    print STDERR "ERROR: Invalid -f <FILE>: no such file!\n";
    exit 1;
}

# read file
else {
    open (IN, "< $Opts{'f'}") || die "Can't open $Opts{'f'}: $!\n";
    while (<IN>) {
        $In .= $_;
    }
    close (IN);
}

# convert
Encode::from_to($In, $Opts{'s'}, $Opts{'d'});

# print
if (@STD) {
    print $In;
}

# write
else {
    open (OUT, "> $Opts{'f'}") || die "Can't write $Opts{'f'}: $!\n";
    print OUT $In;
    close (OUT);
}
