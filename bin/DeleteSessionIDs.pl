#!/usr/bin/perl -w
# --
# DeleteSessionIDs.pl - to delete all existing or expired session ids
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: DeleteSessionIDs.pl,v 1.3 2002-06-08 17:40:32 martin Exp $
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
use FindBin qw($Bin);
use lib "$Bin/../";

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::AuthSession;

# --
# common objects
# --
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OpenTRS-DeleteSessionIDs',
);
$CommonObject{DBObject} = Kernel::System::DB->new(
    %CommonObject,
);
$CommonObject{SessionObject} = Kernel::System::AuthSession->new(
    %CommonObject, 
);

# --
# check args
# --
my $Command = shift || '--help';
print "DeleteSessionIDs.pl <Revision $VERSION> - delete all existing or expired session ids\n";
print "Copyright (c) 2002 Martin Edenhofer <martin\@otrs.org>\n";
# --
# deleta all session ids
# -
if ($Command eq '--all') {
    print " Delele all session ids:\n";
    my @List = $CommonObject{SessionObject}->GetAllSessionIDs();
    foreach my $SessionID (@List) {
        if ($CommonObject{SessionObject}->RemoveSessionID(SessionID => $SessionID)) {
            print " SessionID $SessionID deleted.\n";
        }
        else {
            print " Warning: Can't delete SessionID $SessionID!\n";
        }
    }
    exit (0);
}
# --
# delete all expired session ids 
# --
elsif ($Command eq '--expired') {
    print " Delele all expired session ids:\n";
    my @List = $CommonObject{SessionObject}->GetAllSessionIDs();
    foreach my $SessionID (@List) {
        my %SessionData = $CommonObject{SessionObject}->GetSessionIDData(SessionID => $SessionID);
        my $MaxSessionTime = $CommonObject{ConfigObject}->Get('SessionMaxTime');
        my $ValidTime = ($SessionData{UserSessionStart} + $MaxSessionTime) - time();
        if ($ValidTime >= 0) {
            print " SessionID $SessionID valid (till ". int(($ValidTime/60)) ." minutes).\n";
        }
        else {
            if ($CommonObject{SessionObject}->RemoveSessionID(SessionID => $SessionID)) {
                print " SessionID $SessionID deleted.\n";
            }
            else {
                print " Warning: Can't delete SessionID $SessionID!\n";
            }
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
    print "  --help        display this option help\n";
    print "  --expired     delete all expired session ids\n";
    print "  --all         delete all session ids\n";
    exit (1);
}
# --

