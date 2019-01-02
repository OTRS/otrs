#!/usr/bin/perl
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
use strict;
use warnings;

use Cwd        ();
use File::Spec ();
use File::Basename;
use IO::File;

chdir Cwd::abs_path( File::Spec->catdir( '..', dirname __FILE__ ) );

my @Lines = qx{git log --all --format="%aN <%aE>"};
my %Seen;
map { $Seen{$_}++ } @Lines;

my $FileHandle = IO::File->new( 'AUTHORS.md', 'w' );
$FileHandle->print("The following persons contributed to OTRS:\n\n");

AUTHOR:
foreach my $Author ( sort keys %Seen ) {
    chomp $Author;
    next AUTHOR if $Author eq 'cvs2svn <admin@example.com>';
    if ( $Author =~ m/^[^<>]+ \s <>\s?$/smx ) {
        print STDERR "Could not find Author $Author, skipping.\n";
        next AUTHOR;
    }
    $FileHandle->print("* $Author\n");
}

$FileHandle->close();
