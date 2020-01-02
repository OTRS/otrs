# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Database::Check;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Check OTRS database connectivity.');
    $Self->AddOption(
        Name        => 'repair',
        Description => 'Repairs invalid database schema (like deleting invalid default values for datetime fields).',
        Required    => 0,
        HasValue    => 0,
    );
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Param{Options}->{Repair} = $Self->GetOption('repair');

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # print database information
    my $DatabaseDSN  = $DBObject->{DSN};
    my $DatabaseUser = $DBObject->{USER};

    $Self->Print("<yellow>Trying to connect to database '$DatabaseDSN' with user '$DatabaseUser'...</yellow>\n");

    # Check for database state error.
    if ( !$DBObject ) {
        $Self->PrintError('Connection failed.');
        return $Self->ExitCodeError();
    }

    # Try to get some data from the database.
    $DBObject->Prepare( SQL => "SELECT * FROM valid" );
    my $Check = 0;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Check++;
    }
    if ( !$Check ) {
        $Self->PrintError("Connection was successful, but database content is missing.");
        return $Self->ExitCodeError();
    }
    $Self->Print("<green>Connection successful.</green>\n");

    if ( $DBObject->{'DB::Type'} eq 'mysql' ) {
        $Self->_CheckMySQLDefaultStorageEngine(%Param);
        $Self->_CheckMySQLInvalidDefaultValues(%Param);
    }
    elsif ( $DBObject->{'DB::Type'} eq 'postgresql' ) {
        $Self->_CheckPostgresPrimaryKeySequences(%Param);
    }
    elsif ( $DBObject->{'DB::Type'} eq 'oracle' ) {
        $Self->_CheckOraclePrimaryKeySequencesAndTrigers(%Param);
    }

    return $Self->ExitCodeOk();
}

sub _CheckMySQLDefaultStorageEngine {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Only for MySQL.
    return 1 if $DBObject->{'DB::Type'} ne 'mysql';

    # Check for common MySQL issue where default storage engine is different
    #   from initial OTRS table; this can happen when MySQL is upgraded from
    #   5.1 > 5.5.
    # Default storage engine variable has changed its name in MySQL 5.5.3, we need to support both of them for now.
    #   <= 5.5.2 storage_engine
    #   >= 5.5.3 default_storage_engine
    my $StorageEngine;
    $DBObject->Prepare(
        SQL => "SHOW VARIABLES WHERE variable_name = 'storage_engine'",
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $StorageEngine = $Row[1];
    }

    if ( !$StorageEngine ) {
        $DBObject->Prepare(
            SQL => "SHOW VARIABLES WHERE variable_name = 'default_storage_engine'",
        );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $StorageEngine = $Row[1];
        }
    }

    $DBObject->Prepare(
        SQL  => "SHOW TABLE STATUS WHERE engine != ?",
        Bind => [ \$StorageEngine ],
    );
    my @Tables;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @Tables, $Row[0];
    }
    if (@Tables) {
        my $Error = "Your storage engine is $StorageEngine.\n";
        $Error .= "These tables use a different storage engine:\n\n";
        $Error .= join( "\n", sort @Tables );
        $Error .= "\n\n *** Please correct these problems! *** \n\n";

        $Self->PrintError($Error);
        return $Self->ExitCodeError();
    }

    return 1;
}

sub _CheckMySQLInvalidDefaultValues {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Only for MySQL.
    return 1 if $DBObject->{'DB::Type'} ne 'mysql';

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
    my %TablesWithWrongDefaultColumns;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my $Table   = $Row[0];
        my $Column  = $Row[1];
        my $Default = $Row[2];
        $TablesWithWrongDefaultColumns{$Table}->{$Column} = $Default;
    }

    # Everything was ok.
    return 1 if !%TablesWithWrongDefaultColumns;

    # Only if something wrong was found.
    my $Error = "Your database contains tables with some wrong default values.";

    # Show different error message depending on repair mode.
    if ( $Param{Options}->{Repair} ) {
        $Error .= "\nRepairing now ...\n";
    }
    else {
        $Error
            .= "\n\n *** Please correct these problems manually with the following SQL statements or use 'otrs.Console.pl $Self->{Name} --repair'. *** \n\n";
    }

    my @SQLRepairStatements;

    TABLE:
    for my $Table ( sort keys %TablesWithWrongDefaultColumns ) {

        my @AlterColumnsSQL;

        for my $Column ( sort keys %{ $TablesWithWrongDefaultColumns{$Table} } ) {

            my $Default = $TablesWithWrongDefaultColumns{$Table}->{$Column};

            push @AlterColumnsSQL, "ALTER COLUMN $Column DROP DEFAULT";
        }

        next TABLE if !@AlterColumnsSQL;

        my $SQL = "ALTER TABLE $Table ";
        $SQL .= join ', ', @AlterColumnsSQL;
        push @SQLRepairStatements, $SQL;
    }

    # Show the SQL statements to the user for manually repair.
    if ( !$Param{Options}->{Repair} ) {
        $Error .= join ";\n", @SQLRepairStatements;
        $Error .= ";\n\n";
    }

    if ( $Param{Options}->{Repair} ) {
        $Error = "<yellow>$Error</yellow>\n";
        $Self->Print($Error);
    }
    else {
        $Self->PrintError($Error);
    }

    # Repair the default values.
    if ( $Param{Options}->{Repair} ) {
        for my $SQL (@SQLRepairStatements) {
            return if !$DBObject->Do( SQL => $SQL );
        }

        # Clean up the support data collector cache.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'SupportDataCollector',
        );

        $Self->Print("<green>Done.</green>\n");
    }

    return 1;
}

sub _CheckPostgresPrimaryKeySequences {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Only for Postgres.
    return 1 if $DBObject->{'DB::Type'} ne 'postgresql';

    # Get all table names
    my @Tables = $DBObject->ListTables();

    my %SequenceNameFromTableName;
    for my $TableName (@Tables) {

        my $Sequence = $DBObject->{Backend}->_SequenceName(
            TableName => $TableName,
        );

        # Special handling for a table with no id column but with a object_id column.
        if ( $TableName eq 'dynamic_field_obj_id_name' ) {
            $Sequence = 'dynamic_field_obj_id_name_object_id_seq';
        }

        # Convert to lower case.
        $Sequence = lc $Sequence;

        $SequenceNameFromTableName{$Sequence} = 1;
    }

    # Get all sequence names.
    $DBObject->Prepare(
        SQL => "SELECT relname FROM pg_class WHERE relkind = 'S'",
    );

    my @SequenceNames;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @SequenceNames, lc $Row[0];
    }

    my @WrongSequenceNames;
    SEQUENCE:
    for my $SequenceName (@SequenceNames) {

        next SEQUENCE if $SequenceNameFromTableName{$SequenceName};

        # Remember wrong sequence name.
        push @WrongSequenceNames, $SequenceName;
    }

    # Show error message.
    if (@WrongSequenceNames) {
        my $Error = "The following sequences with possible wrong names have been found. Please rename them manually.\n"
            . join "\n", @WrongSequenceNames;
        $Self->PrintError($Error);
    }

    return 1;
}

sub _CheckOraclePrimaryKeySequencesAndTrigers {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Only for Oracle.
    return 1 if $DBObject->{'DB::Type'} ne 'oracle';

    # Get all table names.
    my @Tables = $DBObject->ListTables();

    my %SequenceNameFromTableName;
    for my $TableName (@Tables) {

        my $Sequence = $DBObject->{Backend}->_SequenceName(
            TableName => $TableName,
        );

        # Convert to lower case.
        $Sequence = lc $Sequence;

        $SequenceNameFromTableName{$Sequence} = 1;
    }

    # Get all sequence names.
    $DBObject->Prepare(
        SQL => 'SELECT sequence_name FROM user_sequences',
    );

    my @SequenceNames;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # Convert to lower case.
        push @SequenceNames, lc $Row[0];
    }

    my @WrongSequenceNames;
    SEQUENCE:
    for my $SequenceName (@SequenceNames) {

        next SEQUENCE if $SequenceNameFromTableName{$SequenceName};

        # Remember wrong sequence name.
        push @WrongSequenceNames, $SequenceName;
    }

    # Get all trigger names.
    $DBObject->Prepare(
        SQL => 'SELECT trigger_name FROM user_triggers',
    );

    my @TriggerNames;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # Convert to lower case.
        push @TriggerNames, lc $Row[0];
    }

    my @WrongTriggerNames;
    TRIGGER:
    for my $TriggerName (@TriggerNames) {

        my $SequenceName = $TriggerName;

        # Remove the last part of the sequence name.
        $SequenceName =~ s{ _t \z }{}xms;

        next TRIGGER if $SequenceNameFromTableName{$SequenceName};

        # Remember wrong trigger name.
        push @WrongTriggerNames, $TriggerName;
    }

    # Show error messages.
    my $Error;
    if (@WrongSequenceNames) {
        $Error = "The following sequences with possible wrong names have been found. Please rename them manually.\n"
            . join "\n", @WrongSequenceNames;
        $Self->PrintError($Error);
    }
    if (@WrongTriggerNames) {
        $Error = "The following triggers with possible wrong names have been found. Please rename them manually.\n"
            . join "\n", @WrongTriggerNames;
        $Self->PrintError($Error);
    }

    return 1;
}

1;
