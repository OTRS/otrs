# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::InvalidDefaultValues;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('Database');
}

sub Run {
    my $Self = shift;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $DBObject->GetDatabaseFunction('Type') ne 'mysql' ) {
        return $Self->GetResults();
    }

    my $DatabaseName = $Kernel::OM->Get('Kernel::Config')->Get('Database');

    # Check for datetime fields with invalid default values
    #    (default values with a date of "0000-00-00 00:00:00").
    $DBObject->Prepare(
        SQL => '
            SELECT TABLE_NAME, COLUMN_NAME, COLUMN_DEFAULT
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE table_schema = ?
            AND DATA_TYPE = "datetime"
            AND COLUMN_DEFAULT = "0000-00-00 00:00:00"
        ',
        Bind => [ \$DatabaseName ],
    );

    # Collect all tables, their columns and default values like described above.
    my $ErrorMessage;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my $Table   = $Row[0];
        my $Column  = $Row[1];
        my $Default = $Row[2];
        $ErrorMessage .= "$Table ($Column) '$Default'\n";
    }

    if ($ErrorMessage) {

        $Self->AddResultProblem(
            Identifier => 'TablesWithInvalidDefaultValues',
            Label      => Translatable('Invalid Default Values'),
            Value      => $ErrorMessage,
            Message    => Translatable(
                'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otrs.Console.pl Maint::Database::Check --repair'
            ),
        );
    }
    else {
        $Self->AddResultOk(
            Identifier => 'TablesWithInvalidDefaultValues',
            Label      => Translatable('Invalid Default Values'),
            Value      => '',
        );
    }

    return $Self->GetResults();
}

1;
