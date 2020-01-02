# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::DatabaseBackupCheck;    ## no critic

use strict;
use warnings;

use IO::Interactive qw(is_interactive);

use parent qw(scripts::DBUpdateTo6::Base);

use version;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
);

=head1 NAME

scripts::DBUpdateTo6::DatabaseBackupCheck - Checks if database was backed up.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head2 CheckPreviousRequirement()

Check for initial conditions for running this migration step.

Returns 1 on success:

    my $Result = $DBUpdateObject->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # This check will occur only if we are in interactive mode.
    if ( $Param{CommandlineOptions}->{NonInteractive} || !is_interactive() ) {
        return 1;
    }

    if ( $Param{CommandlineOptions}->{Verbose} ) {
        print "\n        Warning: this script can make changes to your database which are irreversible.\n"
            . "        Make sure you have properly backed up complete database before continuing.\n\n";
    }
    else {
        print "\n";
    }

    print '        Did you backup the database? [Y]es/[N]o: ';

    my $Answer = <>;

    # Remove white space from input.
    $Answer =~ s{\s}{}smx;

    # Continue only if user answers affirmatively.
    if ( $Answer =~ m{^y}i ) {
        print "\n";

        return 1;
    }

    return;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
