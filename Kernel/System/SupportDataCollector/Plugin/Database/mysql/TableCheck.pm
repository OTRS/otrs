# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::mysql::TableCheck;

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

    # Get all table names.
    my @Tables = $DBObject->ListTables();

    my $ErrorMessage;
    for my $Table (@Tables) {

        # Check each table.
        $DBObject->Prepare(
            SQL => "CHECK TABLE $Table",
        );

        ROW:
        while ( my @Row = $DBObject->FetchrowArray() ) {
            my $TableName = $Row[0];
            my $Status    = $Row[3];

            # Collect only tables with problems or errors.
            next ROW if $Status eq 'OK';

            # Remove the database name from the beginning of the table name.
            $TableName =~ s{ ( \A .+ \. ) }{}xms;

            # Remember only tables with problems.
            $ErrorMessage .= "$TableName ($Status)\n";
        }
    }

    if ($ErrorMessage) {

        $Self->AddResultProblem(
            Identifier => 'TableCheck',
            Label      => Translatable('Table Check'),
            Value      => $ErrorMessage,
            Message    => Translatable('Table check found some problems.'),
        );
    }
    else {
        $Self->AddResultOk(
            Identifier => 'TableCheck',
            Label      => Translatable('Table Check'),
            Value      => '',
        );
    }

    return $Self->GetResults();
}

1;
