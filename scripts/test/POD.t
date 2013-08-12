# --
# POD.t - POD tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars (qw($Self));

use Pod::Simple;

# read all perl module files
my @Files = $Self->{MainObject}->DirectoryRead(
    Directory => $Self->{ConfigObject}->Get('Home'),
    Filter    => '*.pm',
    Recursive => 1,
);

FILE:
for my $File (@Files) {

    # skip all files in Kernel/cpan-lib and Kernel/Modules
    next FILE if $File =~ m{ Kernel . ( cpan-lib | Modules ) }xms;

    my $Checker = Pod::Simple->new();

    # ignore any output
    $Checker->output_string( \my $Trash );

    $Checker->parse_file($File);

    my $Name = "POD test for $File";

    if ( !$Checker->content_seen() ) {
        $Name .= ' (no pod)';
    }

    my $Result = !$Checker->any_errata_seen();
    for my $Error ( sort keys %{ $Checker->{errata} } ) {
        $Result .= "Line $Error: " . join( ", ", @{ $Checker->{errata}->{$Error} } ) . '. ';
    }

    $Self->Is(
        $Result,
        1,
        $Name,
    );
}

1;
