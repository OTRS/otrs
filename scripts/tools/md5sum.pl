#!/usr/bin/perl
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

use Digest::MD5;
use Pod::Usage;

if ( !$ARGV[0] ) {
    pod2usage();
}
my $Filename = $ARGV[0];

if ( open my $FH, '<', $Filename ) {    ## no critic
    binmode $FH;
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
