# --
# Kernel/System/SupportDataCollector/Plugin/Database/mysql/Size.pm - system data collector plugin
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::Size;

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

    if ( $DBObject->GetDatabaseFunction('Type') ne 'mysql' ) {
        return $Self->GetResults();
    }

    my $DBName;

    $DBObject->Prepare(
        SQL   => "SELECT DATABASE()",
        Limit => 1,
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] ) {
            $DBName = $Row[0];
        }
    }

    $DBObject->Prepare(
        SQL => "SELECT ROUND((SUM(data_length + index_length) / 1024 / 1024 / 1024),3) "
            . "FROM information_schema.TABLES WHERE table_schema = ? GROUP BY table_schema",
        Bind  => [ \$DBName ],
        Limit => 1,
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( $Row[0] ) {
            $Self->AddResultInformation(
                Label => 'Database Size',
                Value => "$Row[0] GB",
            );
        }
        else {
            $Self->AddResultProblem(
                Label   => 'Database Size',
                Value   => $Row[0],
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
