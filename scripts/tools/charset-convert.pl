#!/usr/bin/perl -w
# --
# scripts/tools/charset-convert.pl - converts a text file from one to an other one charset
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: charset-convert.pl,v 1.1 2004-01-31 14:45:52 martin Exp $
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

use Encode;

# get charsts
my $From = shift;
my $To = shift;

if (!$From) {
    print STDERR "ERROR: Need ARG 1 - source charset\n";
    exit 1;
}

if (!$To) {
    print STDERR "ERROR: Need ARG 2 - target charset\n";
    exit 1;
}

# get source text
my @InArray = <STDIN>;
my $In = '';
foreach (@InArray) {
    $In .= $_;
}

# convert
Encode::from_to($In, $From, $To);

# show 
print $In;
