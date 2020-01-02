# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::InitializeDefaultCronjobs;    ## no critic

use strict;
use warnings;

use File::Copy ();

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::Config',
);

=head1 NAME

scripts::DBUpdateTo6::InitializeDefaultCronjobs - Creates default cron jobs if they don't exist yet.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    for my $DistFile ( glob "$Home/var/cron/*.dist" ) {
        my $TargetFile = $DistFile =~ s{.dist$}{}r;
        if ( !-e $TargetFile ) {
            print "    Copying $DistFile to $TargetFile...\n";
            my $Success = File::Copy::copy( $DistFile, $TargetFile );
            if ( !$Success ) {
                print "\n    Error: Could not copy $DistFile to $TargetFile: $!\n";
                return;
            }
            print "    done.\n";
        }
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
