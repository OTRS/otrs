#!/usr/bin/perl -w -d:DProf
#!/usr/bin/perl -w

#!/usr/bin/perl -w -d:SmallProf
# --
# bin/cgi-bin/index.pl - the global CGI handle file (incl. auth) for OTRS
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: index.pl,v 1.82 2007-09-18 14:49:13 tr Exp $
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
$VERSION = '$Revision: 1.82 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# check @INC for mod_perl (add lib path for "require module"!)
push (@INC, "$Bin/../..", "$Bin/../../Kernel/cpan-lib");

# 0=off;1=on;
my $Debug = 0;

# load agent web interface
use Kernel::System::Web::InterfaceAgent();

# create new object
my $Interface = Kernel::System::Web::InterfaceAgent->new(Debug => $Debug);

# execute object
$Interface->Run();
