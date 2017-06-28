# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my $ScriptPath = "$Home/bin/otrs.CheckModules.pl";

    print "\n  Executing $ScriptPath to check for missing required modules. \n\n";

    my $ExitCode = system($ScriptPath);

    if ( $ExitCode != 0 ) {
        die
            "Error: not all required Perl modules are installed. Please follow the recommendations to install them, and then run the upgrade script again.\n";
    }

    return 1;
}

=head2 CheckPreviousRequirement()

check for initial conditions for running this migration step.

Returns 1 on success

    my $Result = $DBUpdateTo6Object->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    my ( $Self, %Param ) = @_;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my $ScriptPath = "$Home/bin/otrs.CheckModules.pl";

    # verify check modules script exist
    if ( -e !$ScriptPath ) {
        print "Error: $ScriptPath script does not exist!";
        return;
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
