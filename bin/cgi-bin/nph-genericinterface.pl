#!/usr/bin/perl -w
# --
# bin/cgi-bin/nph-genericinterface.pl - the global generic interface handle file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: nph-genericinterface.pl,v 1.4 2011-12-27 14:36:38 mb Exp $
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
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../../ as lib location
use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";
use lib "$Bin/../../Custom";

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

# load generic interface
use Kernel::GenericInterface::Provider;

# create new object
my $Provider = Kernel::GenericInterface::Provider->new();

# execute object
$Provider->Run();
