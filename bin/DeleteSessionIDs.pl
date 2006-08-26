#!/usr/bin/perl -w
# --
# bin/DeleteSessionIDs.pl - to delete all existing, idle or expired session ids
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: DeleteSessionIDs.pl,v 1.16 2006-08-26 17:26:11 martin Exp $
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

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin)."/Kernel/cpan-lib";

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.16 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::AuthSession;

# --
# common objects
# --
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-DeleteSessionIDs',
    %CommonObject,
);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{SessionObject} = Kernel::System::AuthSession->new(
    %CommonObject,
    CMD => 1,
);

# --
# check args
# --
my $Command = shift || '--help';
print "DeleteSessionIDs.pl <Revision $VERSION> - delete all existing or expired session ids\n";
print "Copyright (c) 2001-2006 OTRS GmbH, http://otrs.org/\n";
# --
# show/delete all session ids
# -
if (($Command eq '--all') || ($Command eq '--showall')) {
    print " Working on all session ids:\n";
    my @List = $CommonObject{SessionObject}->GetAllSessionIDs();
    foreach my $SessionID (@List) {
        if ($Command eq '--showall') {
            print " SessionID $SessionID!\n";
        }
        elsif ($CommonObject{SessionObject}->RemoveSessionID(SessionID => $SessionID)) {
            print " SessionID $SessionID deleted.\n";
        }
        else {
            print " Warning: Can't delete SessionID $SessionID!\n";
        }
    }
    exit (0);
}
# --
# show/delete all expired session ids
# --
elsif (($Command eq '--expired') || ($Command eq '--showexpired')) {
    print " Working on expired session ids:\n";
    # get expired session ids
    my @Expired = $CommonObject{SessionObject}->GetExpiredSessionIDs();
    # expired session
    foreach my $SessionID (@{$Expired[0]}) {
        if ($Command eq '--showexpired') {
            print " SessionID $SessionID expired!\n";
        }
        elsif ($CommonObject{SessionObject}->RemoveSessionID(SessionID => $SessionID)) {
            print " SessionID $SessionID deleted (too old).\n";
        }
        else {
            print " Warning: Can't delete SessionID $SessionID!\n";
        }
    }
    # idle session
    foreach my $SessionID (@{$Expired[1]}) {
        if ($Command eq '--showexpired') {
            print " SessionID $SessionID idle timeout!\n";
        }
        elsif ($CommonObject{SessionObject}->RemoveSessionID(SessionID => $SessionID)) {
            print " SessionID $SessionID deleted (idle timeout).\n";
        }
        else {
            print " Warning: Can't delete SessionID $SessionID!\n";
        }
    }
    exit (0);
}
# --
# show usage
# --
else {
    print "usage: $0 [options] \n";
    print "  Options are as follows:\n";
    print "  --help          display this option help\n";
    print "  --showexpired   show all expired session ids\n";
    print "  --expired       delete all expired session ids\n";
    print "  --showall       show all session ids\n";
    print "  --all           delete all session ids\n";
    exit (1);
}
# --

