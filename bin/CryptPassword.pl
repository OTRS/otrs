#!/usr/bin/perl -w
# --
# bin/CryptPassword.pl - to crypt database password for Kernel/Config.pm
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: CryptPassword.pl,v 1.3 2006-11-02 12:20:59 tr Exp $
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

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# check args
my $Password = shift;
print "bin/CryptPassword.pl <Revision $VERSION> - to crypt database password for Kernel/Config.pm\n";
print "Copyright (c) 2001-2006 OTRS GmbH, http://otrs.org/\n";

if (!$Password) {
    print STDERR "Usage: bin/CryptPassword.pl NEWPW\n";
}
else {
    my $Length = length($Password)*8;
    chomp $Password;
    # get bit code
    my $T = unpack("B$Length", $Password);
    # crypt bit code
    $T =~ s/1/A/g;
    $T =~ s/0/1/g;
    $T =~ s/A/0/g;
    # get ascii code
    $T = pack("B$Length", $T);
    # get hex code
    my $H = unpack("h$Length", $T);
    print "Crypted password: {$H}\n";
}
