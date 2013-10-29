#!/usr/bin/perl
# --
# scripts/tools/md5sum.pl - generage md5sums of files
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

use Digest::MD5;
use Pod::Usage;

if ( !$ARGV[0] ) {
    pod2usage();
}
my $Filename = $ARGV[0];

if ( open my $FH, '<', $Filename ) {    ## no critic
    my $MD5 = Digest::MD5->new();
    $MD5->addfile($FH);
    printf "%-32s %s\n", $MD5->hexdigest(), $Filename;
    close $FH;
}
else {
    die "Cannot open $Filename: $!\n";
}

exit;

__END__

=head1 NAME

md5sum.pl - output the md5sum of a file.

=head1 SYNOPSIS

perl md5sum.pl [filename]

=head1 DESCRIPTION

This program will generate an MD5sum of a file and display it.
Although this trivial task is generally performed by the B<md5sum>
builtin on many systems, not all platforms (Windows!) have this.
In that case using this script is a nice alternative.

=cut

=end
