# --
# Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm - system data collector plugin
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::mssql::Size;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

our @ObjectDependencies = (
    'Kernel::System::DB',
);
our $ObjectManagerAware = 1;

sub GetDisplayPath {
    return 'Database';
}

sub Run {
    my $Self = shift;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $DBObject->GetDatabaseFunction('Type') ne 'mssql' ) {
        return $Self->GetResults();
    }

    $DBObject->Prepare(
        SQL   => 'exec sp_spaceused',
        Limit => 1,
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {

        # $Row[0] database_name
        # $Row[1] database_size
        # $Row[2] unallocated space
        if ( $Row[1] ) {
            $Self->AddResultInformation(
                Label => 'Database Size',
                Value => $Row[1],
            );
        }
        else {
            $Self->AddResultProblem(
                Label   => 'Database Size',
                Value   => $Row[1],
                Message => 'Could not determine database size.'
            );
        }
    }

    return $Self->GetResults();
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
