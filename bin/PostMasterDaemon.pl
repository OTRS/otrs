#!/usr/bin/perl -w
# --
# PostMasterDaemon.pl - the daemon for the PostMasterClient.pl client 
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: PostMasterDaemon.pl,v 1.1 2002-01-02 00:41:42 martin Exp $
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

my $PreForkedServer = 6;
my $MaxConnects = 2;

$SIG{CHLD} = \&StopChild;

#unlink "/tmp/Postmaster.sock";

#y $Server = IO::Socket::UNIX->new(
#    Local => "/tmp/Postmaster.sock",
#    Peer => "/tmp/Postmaster.sock",
#   Type => SOCK_DGRAM,
#    Listen => 50,
#    Timeout => 10,
# || die $@;

my $Children = 0;
my %Children = ();

my $Server = IO::Socket::INET->new(
    LocalPort => 5555,
    Type => SOCK_STREAM,
    Reuse => 1,
    Listen => 10,
) || die $@;
# --
for (1..$PreForkedServer) {
    MakeNewChild();
}

# --
while (1) {
    sleep;
    for (my $i = $Children; $i < $PreForkedServer; $i++) {
        MakeNewChild();
    }
}

# --
sub MakeNewChild {
    $Children++;
    if (my $PID = fork ()) {
      # parrent
      print STDERR "($$)Started new child ($PID)\n";
      $Children{$PID} = 1;
    }
    else {
      # child
      my $MaxConnectsCount = 0;
      while (my $Client = $Server->accept()) {
          $MaxConnectsCount ++;
          print $Client "lala ($PID/$$)\n";
          my $Input = <$Client>;
          print $Input."\n";
          if ($MaxConnects <= $MaxConnectsCount) {
              exit;
          }
      }
    }
}

# --

sub StopChild {
    my $PID = wait;
    print STDERR "($$)StopChild ($PID) (Current Children $Children)\n";
    $Children --;
    delete $Children{$$};
}

# --
