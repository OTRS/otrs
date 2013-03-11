#!/usr/bin/perl
# --
# replace_revision.pl - script to update the revision of OTRS source files
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
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

=head1 NAME

repace_revision.pl - script to remove $Ids used for CVS

=head1 SYNOPSIS

repace_revision.pl -p <Framework-Path> -r <VERSION>

=head1 SUBROUTINES

=over 4

=cut

use strict;
use warnings;

use Getopt::Std;
use File::Find;

use File::Temp qw( tempfile );

use vars qw($VERSION);
$VERSION = qw($Revision: 3.2.3 $) [1];

# get options
my %Opts = ();
getopt('phr', \%Opts);

# set default
if (!$Opts{'p'} || !$Opts{r}) {
    $Opts{'h'} = 1;
}

# show the help screen
if ( $Opts{'h'} ) {
    print <<EOF;
Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
usage: repace_revision.pl -p <Framework-Path> -r <VERSION>
EOF
    exit 1;
}

# get the path
my $Path = $Opts{'p'} . '/';

# remove multiple slashes at the end
$Path =~ s{ /+ \z }{/}xms;

print "\n";

# recursively check and clean every file
find( \&ReplaceRevision, ($Path) );

1;

=item ReplaceRevision

Takes a filename from File::Find, and updates the Revision markers.

=cut

sub ReplaceRevision {

    # get current filename and directory from File::Find
    my $File = $File::Find::name;
    my $Dir  = $File::Find::dir;

    # skip directories
    return if -d $File;
    # skip linked files
    return if -l $File;
    # Only treat plain files
    return if !-f $File;

    # skip special directories:
    # CVS, git, cpan-lib, images, etc...
    return if $Dir =~ m{ / CVS | \.git | cpan-lib | thirdparty | images | img | icons | fonts | cache /? }xms;

    # exclude some files:
    # images, fonts, .gitignore, .cvsignore, and others
    return if $File =~ m{ [.] ( png | psd | jpg | jpeg | gif | tiff | ttf | gitignore | cvsignore | odg | mwb | screen | story | pdf) \s* \z }ixms;

    # return if file can not be opened
    my $FH;
    if ( !open $FH, '<', $File ) {
       print "Can't open '$File': $!\n";
       exit;
    }

    # read file as string and close filehandle
    my $Content = do { local $/; <$FH> };
    close $FH;

    # remember the original content for later comparison
    my $OriginalContent = $Content;

    $Content =~ s{ (?<=\$ Revision): [^\$]+ \$ }{: $Opts{r} \$}xmsg;

    # if nothing was changed, check the next file
    return 1 if $Content eq $OriginalContent;

    # try to open the file for writing
    if ( !open $FH, '>', $File ) {
       print "Can't write '$File': $!\n";
       exit;
    }

    # write the content and close file
    print $FH $Content;
    close $FH;

    # print name of changed file
    print "File: $File\n";

    return 1;
}

exit 0;

