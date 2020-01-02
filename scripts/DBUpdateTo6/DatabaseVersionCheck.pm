# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::DatabaseVersionCheck;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

use version;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
);

=head1 NAME

scripts::DBUpdateTo6::DatabaseVersionCheck - Checks required database version.

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
    my %MinimumDatabaseVersion = (
        MySQL      => '5.0.0',
        MariaDB    => '5.0.0',
        PostgreSQL => '9.2.0',
        Oracle     => '10.0.0',
    );

    # get version string from database
    my $VersionString = $Kernel::OM->Get('Kernel::System::DB')->Version();

    my $DatabaseType;
    my $DatabaseVersion;
    if ( $VersionString =~ m{ \A (MySQL|MariaDB|Oracle|PostgreSQL) \s+ ([0-9.]+) \z }xms ) {
        $DatabaseType    = $1;
        $DatabaseVersion = $2;
    }

    if ( !$DatabaseType || !$DatabaseVersion ) {
        print "\n    Error: Not able to detect database version!\n\n";
        return;
    }

    if ($Verbose) {
        print "    Installed database version: $VersionString. "
            . "Minimum required database version: $MinimumDatabaseVersion{ $DatabaseType }.\n";
    }

    if ( version->parse($DatabaseVersion) < version->parse( $MinimumDatabaseVersion{$DatabaseType} ) ) {
        print "\n    Error: You have the wrong database version installed ($VersionString). "
            . "You need at least $MinimumDatabaseVersion{ $DatabaseType }!\n";
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
