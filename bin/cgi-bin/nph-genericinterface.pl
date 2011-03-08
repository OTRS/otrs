#!/usr/bin/perl -w
# --
# bin/cgi-bin/nph-genericinterface.pl - the global generic interface handle file
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: nph-genericinterface.pl,v 1.3 2011-03-08 14:11:25 mb Exp $
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

# use ../../ as lib location
use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";
use lib "$Bin/../../Custom";

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

# load agent web interface
use Kernel::GenericInterface::Provider;

# create new object
my $Provider = Kernel::GenericInterface::Provider->new();

# execute object
$Provider->Run();
