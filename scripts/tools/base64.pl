#!/usr/bin/perl
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
my @InArray = <STDIN>;    ## no critic
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
