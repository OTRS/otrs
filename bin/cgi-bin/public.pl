#!/usr/bin/perl -w
# --
# bin/cgi-bin/public.pl - the global CGI handle file for OTRS
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: public.pl,v 1.3 2006-11-02 12:20:59 tr Exp $
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

# use ../../ as lib location
use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";

use strict;

use vars qw($VERSION @INC);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# 0=off;1=on;
my $Debug = 0;

# check @INC for mod_perl (add lib path for "require module"!)
push (@INC, "$Bin/../..", "$Bin/../../Kernel/cpan-lib");

# load agent web interface
use Kernel::System::Web::InterfacePublic();

# create new object
my $Interface = Kernel::System::Web::InterfacePublic->new(Debug => $Debug);

# execute object
$Interface->Run();
