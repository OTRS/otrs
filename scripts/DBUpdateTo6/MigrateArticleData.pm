# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::MigrateArticleData;    ## no critic

use strict;
use warnings;

use IO::Interactive qw(is_interactive);

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo6::MigrateArticleData -  Create entries in new article table for OmniChannel base infrastructure.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $Verbose  = $Param{CommandlineOptions}->{Verbose} || 0;

    my $MigrationStatus = $Self->_CheckMigrationIsDone();

    return 1 if $MigrationStatus->{MigrationDone};

    # Check if article_type table exists.
    my $TableExists = $Self->TableExists(
        Table => 'article_type',
    );

    # Skip execution if article_type table is missing.
    if ( !$TableExists ) {
        print "        - Article types table missing, skipping...\n" if $Verbose;
        return 1;
    }

    my $TaskConfig = $Self->GetTaskConfig( Module => 'MigrateArticleData' );

    my %ArticleTypeMapping = %{ $TaskConfig->{ArticleTypeMapping} };

    my %TablesData = %{ $MigrationStatus->{TablesData} };

    # Collect data for further calculation of IsVisibleForCustomer.
    return if !$DBObject->Prepare(
        SQL => 'SELECT id, name FROM article_type',
    );

    my %ArticleTypes;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ArticleTypes{ $Row[0] } = $Row[1];
    }

    return if !$DBObject->Prepare(
        SQL => 'SELECT id, name FROM communication_channel',
    );

    my %CommunicationChannels;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $CommunicationChannels{ $Row[1] } = $Row[0];
    }

    my $MaxVerboseOutputs    = 20;
    my $ArticlesForMigration = $TablesData{article_data_mime}->{Count} - $TablesData{article}->{Count};
    my $VerboseRange         = $ArticlesForMigration / $MaxVerboseOutputs;

    if ($Verbose) {

        print
            "\n        - $ArticlesForMigration articles will be migrated\n";
    }
    my $AlreadyMigratedArticles = 0;
    my $VerboseLoop             = 1;

    # TODO:OCBI: This number might be changed or even configurable
    my $RowsPerLoop = $Param{RowsPerLoop} || 1000;

    my $StartInEntry = $TablesData{article}->{MaxID};

    while ( $StartInEntry < $TablesData{article_data_mime}->{MaxID} ) {

        # Get the complete set of Article entries.
        my $EndInEntry = $StartInEntry + 1 + $RowsPerLoop;

        return if !$DBObject->Prepare(
            SQL => '
                SELECT id, ticket_id, article_sender_type_id, article_type_id,
                    create_by,create_time, change_by, change_time
                FROM article_data_mime
                WHERE id > ' . $StartInEntry . ' AND id < ' . $EndInEntry . '
                ORDER BY id ASC',
        );

        # NOTE: Remaining fields in re-named 'article_data_mime'
        # table will stay there, except for 'ticket_id' and 'valid_id'
        # now they are part of the MIME communication channel data

        my @Data;
        while ( my @Row = $DBObject->FetchrowArray() ) {

            # Map Visible for Customer
            my $IsVisibleForCustomer = $ArticleTypeMapping{ $ArticleTypes{ $Row[3] } }->{Visible};

            # Map Communication Channel.
            my $CommunicationChannel   = $ArticleTypeMapping{ $ArticleTypes{ $Row[3] } }->{Channel};
            my $CommunicationChannelID = $CommunicationChannels{$CommunicationChannel};

            my %CurrentRow = (
                ID                     => $Row[0],
                TicketID               => $Row[1],
                ArticleSenderTypeID    => $Row[2],
                CommunicationChannelID => $CommunicationChannelID,
                IsVisibleForCustomer   => $IsVisibleForCustomer,
                CreateBy               => $Row[4],
                CreateTime             => $Row[5],
                ChangeBy               => $Row[6],
                ChangeTime             => $Row[7],
            );
            push @Data, \%CurrentRow;
        }

        if (@Data) {

            my $MigrationResult = $Self->_MigrateData(
                Data              => \@Data,
                LastArticleDataID => $Data[-1]->{ID},
            );

            if ( !$MigrationResult ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "An error occurs during article data migration!",
                );
                print "\n    An error occurs during article data migration!\n";
                return;
            }

            $AlreadyMigratedArticles += scalar @Data;

            # Add some meaningful information
            if ( $Verbose && ( $AlreadyMigratedArticles > $VerboseLoop * $VerboseRange ) ) {

                print
                    "        - $AlreadyMigratedArticles of $ArticlesForMigration articles migrated. \n";
                $VerboseLoop++;
            }
        }

        $StartInEntry += $RowsPerLoop;
    }

    print "\n" if $Verbose;

    return 1;
}

=head2 _MigrateData()

Adds multiple article entries to the article table. Returns 1 on success

    my $Result = $DBUpdateTo6Object->_MigrateData(
        Data => \@OldArticleData, # Old structure content
    );

=cut

sub _MigrateData {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !$Param{Data} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Data!",
        );
        return;
    }

    # Check needed stuff.
    if ( ref $Param{Data} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Data must be an array reference!",
        );
        return;
    }

    # Check needed stuff.
    if ( !@{ $Param{Data} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Data array must not be empty!",
        );
        return;
    }

    # Check needed stuff.
    if ( !defined $Param{LastArticleDataID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need LastArticleDataID!",
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Get the database type.
    my $DBType = $DBObject->GetDatabaseFunction('Type');

    # Decide data migration type.
    my $AllowMultiple          = 1;
    my @SupportMultipleInserts = qw(mysql oracle postgresql);

    if ( !grep {m/$DBType/} @SupportMultipleInserts ) {
        $AllowMultiple = 0;
    }

    # Define database specific SQL for the multi-line inserts.
    my %DatabaseSQL;

    if ( $DBType eq 'oracle' && $AllowMultiple ) {

        %DatabaseSQL = (
            Start     => 'INSERT ALL ',
            FirstLine => '
                INTO article (
                    id,ticket_id,article_sender_type_id,communication_channel_id,
                    is_visible_for_customer,create_by,create_time,change_by,change_time
                )
                VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ? ) ',
            NextLine => '
                INTO article (
                    id,ticket_id,article_sender_type_id,communication_channel_id,
                    is_visible_for_customer,create_by,create_time,change_by,change_time
                )
                VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ? ) ',
            End => 'SELECT * FROM DUAL',
        );
    }
    else {
        %DatabaseSQL = (
            Start => '
                INSERT INTO article (
                    id,ticket_id,article_sender_type_id,communication_channel_id,
                    is_visible_for_customer,create_by,create_time,change_by,change_time
                )',
            FirstLine => 'VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ? )',
            NextLine  => ', ( ?, ?, ?, ?, ?, ?, ?, ?, ? ) ',
            End       => '',
        );

    }

    my $SQL = '';
    my @Bind;

    ARTICLEENTRY:
    for my $ArticleEntry ( @{ $Param{Data} } ) {

        # Now the article entry is validated and can be added to sql.
        if ( !$SQL ) {
            $SQL = $DatabaseSQL{Start} . $DatabaseSQL{FirstLine};
        }
        else {
            $SQL .= $DatabaseSQL{NextLine};
        }

        push @Bind, (
            \$ArticleEntry->{ID},
            \$ArticleEntry->{TicketID},
            \$ArticleEntry->{ArticleSenderTypeID},
            \$ArticleEntry->{CommunicationChannelID},
            \$ArticleEntry->{IsVisibleForCustomer},
            \$ArticleEntry->{CreateBy},
            \$ArticleEntry->{CreateTime},
            \$ArticleEntry->{ChangeBy},
            \$ArticleEntry->{ChangeTime},
        );

        # Check the length of the SQL string
        # (some databases only accept SQL strings up to 4k,
        # so we want to stay safe here with just 3500 bytes).
        if ( length $SQL > 3500 || !$AllowMultiple || $ArticleEntry->{ID} == $Param{LastArticleDataID} ) {

            # Add the end line to sql string.
            $SQL .= $DatabaseSQL{End};

            # Insert multiple entries.
            return if !$DBObject->Do(
                SQL  => $SQL,
                Bind => \@Bind,
            );

            # Reset the SQL string and the Bind array.
            $SQL  = '';
            @Bind = ();
        }
    }

    return 1;
}

=head2 CheckPreviousRequirement()

Check for initial conditions for running this migration step.

Returns 1 on success:

    my $Result = $DBUpdateTo6Object->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    # Check for interactive mode.
    my $InteractiveMode = 1;
    if ( $Param{CommandlineOptions}->{NonInteractive} || !is_interactive() ) {
        $InteractiveMode = 0;
    }

    # Check for orphaned articles only if article table was not migrated yet.
    my $OrphanedArticleCheck = !$Self->TableExists(
        Table => 'article_data_mime',
    );

    if ($OrphanedArticleCheck) {

        # Define orphaned entries checks, for now all related to the article table.
        #   Check in correct order to prevent dependency issues.
        my @OrphanedEntryChecks = (
            {
                Table          => 'time_accounting',
                Field          => 'article_id',
                ReferenceTable => 'article',
                ReferenceField => 'id',
            },
            {
                Table          => 'article_attachment',
                Field          => 'article_id',
                ReferenceTable => 'article',
                ReferenceField => 'id',
            },
            {
                Table          => 'article_flag',
                Field          => 'article_id',
                ReferenceTable => 'article',
                ReferenceField => 'id',
            },
            {
                Table          => 'article_plain',
                Field          => 'article_id',
                ReferenceTable => 'article',
                ReferenceField => 'id',
            },
            {
                Table => 'ticket_history',
                CheckSQL =>
                    'SELECT COUNT(tab.article_id) '
                    . 'FROM ticket_history tab '
                    . 'LEFT JOIN article ref ON tab.article_id = ref.id '
                    . 'WHERE tab.article_id IS NOT NULL '
                    . 'AND tab.article_id != 0 '
                    . 'AND ref.id IS NULL',
                DeleteSQL => [
                    'DELETE tab FROM ticket_history tab '
                        . 'LEFT JOIN article ref ON tab.article_id = ref.id '
                        . 'WHERE tab.article_id IS NOT NULL '
                        . 'AND tab.article_id != 0 '
                        . 'AND ref.id IS NULL',
                    'UPDATE ticket_history '
                        . 'SET article_id = NULL '
                        . 'WHERE article_id = 0',
                ],
            },
            {
                Table          => 'article',
                Field          => 'ticket_id',
                ReferenceTable => 'ticket',
                ReferenceField => 'id',
                DeleteSQL      => [

                    # If articles are to be deleted, delete all dependent data from other tables first.
                    'DELETE sub FROM article tab '
                        . 'LEFT JOIN ticket ref ON tab.ticket_id = ref.id '
                        . 'LEFT JOIN article_flag sub ON tab.id = sub.article_id '
                        . 'WHERE tab.ticket_id IS NOT NULL '
                        . 'AND ref.id IS NULL',
                    'DELETE sub FROM article tab '
                        . 'LEFT JOIN ticket ref ON tab.ticket_id = ref.id '
                        . 'LEFT JOIN article_attachment sub ON tab.id = sub.article_id '
                        . 'WHERE tab.ticket_id IS NOT NULL '
                        . 'AND ref.id IS NULL',
                    'DELETE sub FROM article tab '
                        . 'LEFT JOIN ticket ref ON tab.ticket_id = ref.id '
                        . 'LEFT JOIN time_accounting sub ON tab.id = sub.article_id '
                        . 'WHERE tab.ticket_id IS NOT NULL '
                        . 'AND ref.id IS NULL',
                    'DELETE sub FROM article tab '
                        . 'LEFT JOIN ticket ref ON tab.ticket_id = ref.id '
                        . 'LEFT JOIN article_plain sub ON tab.id = sub.article_id '
                        . 'WHERE tab.ticket_id IS NOT NULL '
                        . 'AND ref.id IS NULL',
                    'DELETE sub FROM article tab '
                        . 'LEFT JOIN ticket ref ON tab.ticket_id = ref.id '
                        . 'LEFT JOIN ticket_history sub ON tab.id = sub.article_id '
                        . 'WHERE tab.ticket_id IS NOT NULL '
                        . 'AND ref.id IS NULL',
                    'DELETE tab FROM article tab '
                        . 'LEFT JOIN ticket ref ON tab.ticket_id = ref.id '
                        . 'WHERE tab.ticket_id IS NOT NULL '
                        . 'AND ref.id IS NULL',
                ],
            },
        );

        print "\n" if $Verbose;

        my $Stop;

        ORPHANEDENTRYCHECK:
        for my $Index ( 0 .. $#OrphanedEntryChecks ) {
            my $OrphanedEntryCheck = $OrphanedEntryChecks[$Index];

            print "        Check for orphaned entries in $OrphanedEntryCheck->{Table} table ...\n" if $Verbose;

            my $CheckSQL = $OrphanedEntryCheck->{CheckSQL} ||
                "SELECT COUNT(tab.$OrphanedEntryCheck->{Field}) "
                . "FROM $OrphanedEntryCheck->{Table} tab "
                . "LEFT JOIN $OrphanedEntryCheck->{ReferenceTable} ref ON tab.$OrphanedEntryCheck->{Field} = ref.$OrphanedEntryCheck->{ReferenceField} "
                . "WHERE tab.$OrphanedEntryCheck->{Field} IS NOT NULL "
                . "AND ref.$OrphanedEntryCheck->{ReferenceField} IS NULL";

            return if !$DBObject->Prepare(
                SQL => $CheckSQL,
            );

            my $Count = 0;
            while ( my @Row = $DBObject->FetchrowArray() ) {
                $Count = $Row[0];
            }

            # No orphaned entries found.
            next ORPHANEDENTRYCHECK if !$Count;

            print "\n" if !$Verbose && !$Index;

            print "        Found $Count orphaned entries in $OrphanedEntryCheck->{Table} table ...\n";

            my $DeleteSQL = $OrphanedEntryCheck->{DeleteSQL} || [
                "DELETE tab FROM $OrphanedEntryCheck->{Table} tab "
                    . "LEFT JOIN $OrphanedEntryCheck->{ReferenceTable} ref ON tab.$OrphanedEntryCheck->{Field} = ref.$OrphanedEntryCheck->{ReferenceField} "
                    . "WHERE tab.$OrphanedEntryCheck->{Field} IS NOT NULL "
                    . "AND ref.$OrphanedEntryCheck->{ReferenceField} IS NULL"
            ];

            # Only in interactive mode or if the CleanupOrphanedArticles parameter is active.
            if ( $InteractiveMode || $Param{CommandlineOptions}->{CleanupOrphanedArticles} ) {

                my $Answer = '';

                # In interactive mode we ask the user what he wants to do.
                if ( !$Param{CommandlineOptions}->{CleanupOrphanedArticles} ) {

                    # Ask the user and get the answer.
                    print '        Do you want to automatically delete the entries from the database now? [Y]es/[N]o: ';
                    $Answer = <>;

                    # Remove white space from input.
                    $Answer =~ s{\s}{}smx;
                }

                # Fix the problem automatically.
                if ( $Answer =~ m{^y}i || $Param{CommandlineOptions}->{CleanupOrphanedArticles} ) {

                    # Delete the orphaned entries.
                    for my $SQL ( @{$DeleteSQL} ) {
                        return if !$DBObject->Do(
                            SQL => $SQL,
                        );
                    }

                    # Now check if no orphaned entries are found anymore.
                    return if !$DBObject->Prepare(
                        SQL => $CheckSQL,
                    );
                    my $Count;
                    while ( my @Row = $DBObject->FetchrowArray() ) {
                        $Count = $Row[0];
                    }

                    # Everything was deleted automatically.
                    if ( !$Count ) {
                        print "        Fixing... Done.\n\n";
                        next ORPHANEDENTRYCHECK;
                    }

                    # Could not be deleted automatically.
                    print "        It was not possible to automatically delete the orphaned entries.\n";
                }

                print
                    "        Please delete them manually with the following SQL statements and then run the migration script again:\n";
                for my $SQL ( @{$DeleteSQL} ) {
                    print $SQL . ";\n";
                }
                print "\n";

                return;
            }

            # In non-interactive mode we just remember that there was a problem, and show the output
            #    and in a later step we then stop.
            else {

                # Show manual instructions and remember to stop later.
                print
                    "        Please delete them manually with the following SQL statements and then run the migration script again:\n";
                for my $SQL ( @{$DeleteSQL} ) {
                    print $SQL;
                }
                print "\n";

                $Stop = 1;
            }

        }

        print "\n" if $Verbose;

        return if $Stop;
    }

    # Check if article_type table still exist.
    my $ArticleTypeTableExists = $Self->TableExists(
        Table => 'article_type',
    );

    # Check for unknown article types.
    if ($ArticleTypeTableExists) {

        my $TaskConfig = $Self->GetTaskConfig( Module => 'MigrateArticleData' );

        my @ArticleTypes = sort keys %{ $TaskConfig->{ArticleTypeMapping} };

        my $ArticleTypesString = "'" . ${ \( join "', '", @ArticleTypes ) } . "'";

        $DBObject->Prepare(
            SQL => "
                SELECT id, name
                FROM article_type
                WHERE name NOT IN ( $ArticleTypesString )
            ",
        );

        my @UnknownArticleTypes;

        while ( my @Row = $DBObject->FetchrowArray() ) {
            push @UnknownArticleTypes, $Row[1];
        }

        # If unknown article types are encountered, do not continue with the migration.
        if (@UnknownArticleTypes) {

            print "\n    Error! Unknown article types were found: ${\(join ', ', @UnknownArticleTypes)}.\n"
                . "    Please provide additional migration matrix entries in following file:\n\n"
                . "        scripts/DBUpdateTo6/TaskConfig/MigrateArticleData.yml\n\n"
                . "    Tip: Create a copy of .dist file with the same name and edit it instead,\n"
                . "    before starting migration again.\n\n";

            return;
        }
    }

    return 1;
}

=head2 _CheckMigrationIsDone()

updates the table article_data_mime:

    - adding an article_id column
    - copying id values into article_id column
    - recreating indexes and foreign keys
    - dropping no longer used columns

Returns 1 on success

    my $Result = $DBUpdateTo6Object->_CheckMigrationIsDone();

=cut

sub _CheckMigrationIsDone {
    my ( $Self, %Param ) = @_;

    my $MigrationDone = 0;
    my $Message;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my %TablesData = (
        'article' => {
            MaxID => 0,
            Count => 0,
        },
        'article_data_mime' => {
            MaxID => 0,
            Count => 0,
        },
    );

    for my $TableName ( sort keys %TablesData ) {

        # Get last id.
        return if !$DBObject->Prepare(
            SQL => "SELECT MAX(id) FROM $TableName",
        );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $TablesData{$TableName}->{MaxID} = $Row[0] || 0;
        }

        # Get amount of entries
        return if !$DBObject->Prepare(
            SQL => "SELECT COUNT(*) FROM $TableName",
        );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $TablesData{$TableName}->{Count} = $Row[0] || 0;
        }
    }

    # This should never happen.
    if (
        $TablesData{article_data_mime}->{MaxID} < $TablesData{article}->{MaxID}
        || $TablesData{article_data_mime}->{Count} < $TablesData{article}->{Count}
        )
    {
        $Message =
            "Something got wrong, there are more entries in 'article' table than in 'article_data_mime'.";
        $MigrationDone = 0;
    }

    # Have to be the same amount of records in both tables.
    # tables with the sale ids
    elsif (
        $TablesData{article_data_mime}->{MaxID} == $TablesData{article}->{MaxID}
        && $TablesData{article_data_mime}->{Count} == $TablesData{article}->{Count}
        )
    {

        $Message =
            "Article data migration already executed.";
        $MigrationDone = 1;
    }

    return {
        MigrationDone => $MigrationDone,
        Message       => $Message,
        TablesData    => \%TablesData,
    };
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
