# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::UpgradeDatabaseStructure;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::XML',
);

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure - Upgrades the database structure to OTRS 6.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my $DatabaseXMLUpgradeFile = "$Home/scripts/database/update/otrs-upgrade-to-6.xml";

    my $XML = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $DatabaseXMLUpgradeFile,
    );
    if ( !$XML ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not load '$DatabaseXMLUpgradeFile'!",
        );
        return;
    }
    $XML = ${$XML};

    my @XMLArray = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => $XML );
    if ( !@XMLArray ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not parse XML!',
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my @SQLPre = $DBObject->SQLProcessor(
        Database => \@XMLArray,
    );
    if ( !@SQLPre ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not generate SQL!',
        );
        return;
    }

    my @SQLPost = $DBObject->SQLProcessorPost();

    if ($Verbose) {
        print STDERR "\n Executing SQL statements:\n\n";
    }

    for my $SQL ( @SQLPre, @SQLPost ) {

        if ($Verbose) {
            print STDERR "$SQL\n";
        }

        my $Success = $DBObject->Do( SQL => $SQL );
        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Database action failed: ' . $DBObject->Error(),
            );
            return;
        }
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
