#!/usr/bin/perl
# --
# bin/otrs.CreateAUTHORS.pl - generate contributors list from git history
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

use Cwd        ();
use File::Spec ();
use File::Basename;
use IO::File;

chdir Cwd::abs_path( File::Spec->catdir( '..', dirname __FILE__ ) );

my @Lines = qx{git log --format="%aN <%aE>"};
my %Seen;
map { $Seen{$_}++ } @Lines;

my $FileHandle = IO::File->new( 'AUTHORS.md', 'w' );
$FileHandle->print("The following persons contributed to OTRS:\n\n");

AUTHOR:
foreach my $Author ( sort keys %Seen ) {
    chomp $Author;
    if ( $Author =~ m/^[^<>]+ \s <>\s?$/smx ) {
        print STDERR "Could not find Author $Author, skipping.\n";
        next AUTHOR;
    }
    $FileHandle->print("* $Author\n")
}

$FileHandle->close();
