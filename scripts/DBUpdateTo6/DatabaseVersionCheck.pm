# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::DatabaseVersionCheck;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

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

    my %MinimumDatabaseVersion = (
        MySQL      => '5',
        MariaDB    => '5',
        PostgreSQL => '9.2',
        Oracle     => '10',
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
        print "\n\nError: Not able to detect database version!";
        return;
    }

    if ($Verbose) {
        print "\n    Installed database version: $VersionString. Minimum required database version: $MinimumDatabaseVersion{ $DatabaseType }.";
    }

    # prepend 'v' to the comparison to make it easier to compare version numbers
    if ( 'v' . $DatabaseVersion lt 'v' . $MinimumDatabaseVersion{ $DatabaseType } ) {
        print "\n\nError: You have the wrong database version installed ($VersionString). You need at least $MinimumDatabaseVersion{ $DatabaseType }!";
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
