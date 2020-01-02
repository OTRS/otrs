# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::Performance;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('Database');
}

sub Run {
    my $Self = shift;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $DBObject->GetDatabaseFunction('Type') ne 'mysql' ) {
        return $Self->GetResults();
    }

    $DBObject->Prepare( SQL => "show variables like 'query_cache_size'" );
    while ( my @Row = $DBObject->FetchrowArray() ) {

        if (
            !$Row[1]
            || $Row[1] < 1024 * 1024 * 10
            || $Row[1] > 1024 * 1024 * 600
            )
        {
            $Self->AddResultWarning(
                Identifier => 'QueryCacheSize',
                Label      => Translatable('Query Cache Size'),
                Value      => $Row[1],
                Message =>
                    Translatable(
                    "The setting 'query_cache_size' should be used (higher than 10 MB but not more than 512 MB)."
                    ),
            );
        }
        else {
            $Self->AddResultOk(
                Identifier => 'QueryCacheSize',
                Label      => Translatable('Query Cache Size'),
                Value      => $Row[1],
            );
        }
    }

    return $Self->GetResults();
}

1;
