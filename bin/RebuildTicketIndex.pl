#!/usr/bin/perl -w
# --
# bin/RebuildTicketIndex.pl - rebuild ticket index for queue view
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: RebuildTicketIndex.pl,v 1.2 2002-08-13 15:20:35 martin Exp $
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
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::Ticket;

# --
# common objects
# --
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OpenTRS-RebuildTicketIndex.pl',
    %CommonObject,
);
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);
# --
# rebuild
# --
$CommonObject{TicketObject}->TicketAcceleratorRebuild();

