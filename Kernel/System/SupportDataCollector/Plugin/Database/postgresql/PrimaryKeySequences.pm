# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::postgresql::PrimaryKeySequences;

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

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $DBObject->GetDatabaseFunction('Type') !~ m{^postgresql} ) {
        return $Self->GetResults();
    }

    # Get all table names.
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

    if (@WrongSequenceNames) {

        my $Error = join "\n", @WrongSequenceNames;
        $Error .= "\n";

        $Self->AddResultProblem(
            Identifier => 'PrimaryKeySequences',
            Label      => Translatable('Primary Key Sequences'),
            Value      => $Error,
            Message    => Translatable(
                'The following sequences with possible wrong names have been found. Please rename them manually.'
            ),
        );
    }
    else {
        $Self->AddResultOk(
            Identifier => 'PrimaryKeySequences',
            Label      => Translatable('Primary Key Sequences'),
            Value      => '',
        );
    }

    return $Self->GetResults();
}

1;
