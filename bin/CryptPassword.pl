#!/usr/bin/perl -w
# --
# bin/CryptPassword.pl - to crypt database password for Kernel/Config.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: CryptPassword.pl,v 1.10 2009-02-26 11:01:01 tr Exp $
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
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

# check args
my $Password = shift;
print
    "bin/CryptPassword.pl <Revision $VERSION> - to crypt database password for Kernel/Config.pm\n";
print "Copyright (c) 2001-2009 OTRS AG, http://otrs.org/\n";

if ( !$Password ) {
    print STDERR "Usage: bin/CryptPassword.pl NEWPW\n";
}
else {
    my $Length = length($Password) * 8;
    chomp $Password;

    # get bit code
    my $T = unpack( "B$Length", $Password );

    # crypt bit code
    $T =~ s/1/A/g;
    $T =~ s/0/1/g;
    $T =~ s/A/0/g;

    # get ascii code
    $T = pack( "B$Length", $T );

    # get hex code
    my $H = unpack( "h$Length", $T );
    print "Crypted password: {$H}\n";
}
