# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::RebuildConfigCleanup;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = ();

=head1 NAME

scripts::DBUpdateTo6::RebuildConfigCleanup - Rebuilds the system configuration trying to cleanup the database.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    return $Self->RebuildConfig(
        %Param,
        CleanUpIfPossible => 1,
    );
}

1;
