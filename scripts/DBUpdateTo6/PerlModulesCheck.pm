# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::PerlModulesCheck;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::Config',
);

=head1 NAME

scripts::DBUpdateTo6::PerlModulesCheck - Checks required Perl modules before update.

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
    my $Home    = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my $PerlBinary = $^X;
    my $ScriptPath = "$Home/bin/otrs.CheckModules.pl";

    # verify check modules script exist
    if ( !-e $ScriptPath ) {
        print "\n    Error: $ScriptPath script does not exist!\n\n";
        return;
    }

    print "\n" if $Verbose;

    print "    Executing $ScriptPath to check for missing required modules. \n\n" if $Verbose;

    if ( !$Verbose ) {
        $ScriptPath .= ' >/dev/null';
    }

    my $ExitCode = system("$PerlBinary $ScriptPath");

    if ( $ExitCode != 0 ) {
        print
            "\n    Error: not all required Perl modules are installed. Please follow the recommendations to install them, and then run the upgrade script again.\n\n";
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
