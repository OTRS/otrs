#!/usr/bin/perl -w
# --
# scripts/tools/base64.pl - mime base 64 encode/decode
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: base64.pl,v 1.4 2008-04-24 17:32:15 tr Exp $
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

use strict;
use warnings;

use MIME::Base64;

# get type
my $Type = shift;

if ( !$Type ) {
    print STDERR "ERROR: Need ARG 1 - (encode|decode)\n";
    exit 1;
}
elsif ( $Type !~ /^encode|decode$/ ) {
    print STDERR "ERROR: ARG 1 - (encode|decode)\n";
    exit 1;
}

# get source text
my @InArray = <STDIN>;
my $In      = '';
for (@InArray) {
    $In .= $_;
}

if ( $Type eq 'decode' ) {
    $In = decode_base64($In);
}
else {
    $In = encode_base64($In);
}
print $In. "\n";
