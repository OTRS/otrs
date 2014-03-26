# --
# Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm - system data collector plugin
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::Performance;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

sub GetDisplayPath {
    return 'Database';
}

sub Run {
    my $Self = shift;

    if ( $Self->{DBObject}->GetDatabaseFunction('Type') ne 'mysql' ) {
        return $Self->GetResults();
    }

    $Self->{DBObject}->Prepare( SQL => "show variables like 'query_cache_size'" );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        if (
            !$Row[1]
            || $Row[1] < 1024 * 1024 * 10
            || $Row[1] > 1024 * 1024 * 600
            )
        {
            $Self->AddResultProblem(
                Identifier => 'QueryCacheSize',
                Label      => 'Query Cache Size',
                Value      => $Row[1],
                Message =>
                    "The setting 'query_cache_size' should be used (higher than 10 MB but not more than 512 MB).",
            );
        }
        else {
            $Self->AddResultOk(
                Identifier => 'QueryCacheSize',
                Label      => 'Query Cache Size',
                Value      => $Row[1],
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
