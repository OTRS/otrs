# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::InnoDBLogFileSize;

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

    # Default storage engine variable has changed its name in MySQL 5.5.3, we need to support both of them for now.
    #   <= 5.5.2 storage_engine
    #   >= 5.5.3 default_storage_engine
    my $DefaultStorageEngine = '';
    $DBObject->Prepare( SQL => "show variables like 'storage_engine'" );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $DefaultStorageEngine = $Row[1];
    }

    if ( !$DefaultStorageEngine ) {
        $DBObject->Prepare( SQL => "show variables like 'default_storage_engine'" );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $DefaultStorageEngine = $Row[1];
        }
    }

    if ( lc $DefaultStorageEngine ne 'innodb' ) {
        return $Self->GetResults();
    }

    $DBObject->Prepare( SQL => "show variables like 'innodb_log_file_size'" );
    while ( my @Row = $DBObject->FetchrowArray() ) {

        if (
            !$Row[1]
            || $Row[1] < 1024 * 1024 * 256
            )
        {
            $Self->AddResultProblem(
                Label => Translatable('InnoDB Log File Size'),
                Value => $Row[1] / 1024 / 1024 . ' MB',
                Message =>
                    Translatable("The setting innodb_log_file_size must be at least 256 MB."),
            );
        }
        else {
            $Self->AddResultOk(
                Label => Translatable('InnoDB Log File Size'),
                Value => $Row[1] / 1024 / 1024 . ' MB',
            );
        }
    }

    return $Self->GetResults();
}

1;
