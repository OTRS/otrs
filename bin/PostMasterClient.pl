#!/usr/bin/perl -w
# --
# bin/PostMasterClient.pl - the PostMasterDaemon.pl client
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: PostMasterClient.pl,v 1.4 2006-01-07 15:13:29 martin Exp $
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

use IO::Socket;

my $Client = IO::Socket::INET->new(
   PeerHost => 'localhost',
   PeerPort => '5555',
) || die $@;
# get email
my @Email = <STDIN>;
# check handshake
my $Line = <$Client>;
if ($Line !~ /^\* --OK--/i) {
    print "Got no OK from daemon! Exiting!\n";
    close ($Client);
    exit 1;
}
print "handshake ok!\n";
# send email
print $Client "* --SEND EMAIL--\n";
print $Client @Email;
print $Client "* --END EMAIL--\n";
# return
my $Answer = <$Client>;
if ($Answer =~ /^\* --DONE--/) {
    print "email processed!\n";
    close ($Client);
    exit;
}
else {
    print "email not processed\n";
    close ($Client);
    exit 1;
}
