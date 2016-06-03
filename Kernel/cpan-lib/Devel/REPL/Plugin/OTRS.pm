# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Devel::REPL::Plugin::OTRS;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use Devel::REPL::Plugin;
use Data::Printer use_prototypes => 0;

=head1 NAME

Devel::REPL::Plugin::OTRS - Devel::Repl plugin to improve formatting of hashes and lists

=head1 SYNOPSIS

This plugin checks if the returned data could be a hash or a list, and turns it
into a hash or list reference for improved output formatting. This may lead to false
positives for hash detection, but you can avoid this by using references in the REPL directly.

=cut

around 'format_result' => sub {
    my $Original = shift;
    my $Self = shift;
    my @ToDump = @_;

    if (@ToDump <= 1) {
        return $Self->DataDump(@ToDump);
    }

    # Guess if the list could be actually a hash:
    #   tt must have an even size and no non-unique keys.
    if (scalar @ToDump % 2 == 0) {
        my %Hash = @ToDump;
        if ( ( scalar keys %Hash ) * 2 == scalar @ToDump) {
            return $Self->DataDump( { @ToDump } );
        }
    }

    # Otherwise, treat it as a list.
    return $Self->DataDump( [ @ToDump ] );
};

sub DataDump {
    my ($Self, @ToDump) = @_;
    my $Result;
    for my $Element (@ToDump) {
        my $Buf;
        p(\$Element,
          output        => \$Buf,
          colored       => $Self->{ColoredOutput} // 1,
          caller_info   => 0 );
        $Result .= $Buf;
    }
    return $Result;
}

sub ColoredOutput {
    my ($Self, $ColoredOutput) = @_;
    $Self->{ColoredOutput} = $ColoredOutput;
}

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
