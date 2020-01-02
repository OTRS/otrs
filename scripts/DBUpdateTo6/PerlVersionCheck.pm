# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::PerlVersionCheck;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

use version;

our @ObjectDependencies = (
    'Kernel::Config',
);

=head1 NAME

scripts::DBUpdateTo6::PerlVersionCheck - Checks required Perl version.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head2 CheckPreviousRequirement()

check for initial conditions for running this migration step.

Returns 1 on success

    my $Result = $DBUpdateTo6Object->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    # Use dotted-decimal version formats, since version->parse() might not work as you expect it to.
    #
    #   $Version   version->parse($Version)
    #   ---------   -----------------------
    #   1.23        v1.230.0
    #   "1.23"      v1.230.0
    #   v1.23       v1.23.0
    #   "v1.23"     v1.23.0
    #   "1.2.3"     v1.2.3
    #   "v1.2.3"    v1.2.3
    my $RequiredPerlVersion  = 'v5.16.0';
    my $InstalledPerlVersion = $^V;

    if ($Verbose) {
        print "    Installed Perl version: $InstalledPerlVersion. "
            . "Minimum required Perl version: $RequiredPerlVersion.\n";
    }

    if ( version->parse($InstalledPerlVersion) < version->parse($RequiredPerlVersion) ) {
        print "\n    Error: You have the wrong Perl version installed ($InstalledPerlVersion). "
            . "You need at least $RequiredPerlVersion!\n\n";
        return;
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
