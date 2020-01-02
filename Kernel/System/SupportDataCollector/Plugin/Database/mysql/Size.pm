# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::Size;

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
                Label => Translatable('Database Size'),
                Value => "$Row[0] GB",
            );
        }
        else {
            $Self->AddResultProblem(
                Label   => Translatable('Database Size'),
                Value   => $Row[0],
                Message => Translatable('Could not determine database size.')
            );
        }
    }

    return $Self->GetResults();
}

1;
