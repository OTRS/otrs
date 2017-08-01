# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::MigrateArticleData;    ## no critic

use strict;
use warnings;

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
    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my $CheckPreviousRequirement = $Self->_CheckMigrationIsDone();

    return 1 if $CheckPreviousRequirement->{MigrationDone};

    # check if article_type table exists
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

    my %TablesData = %{ $CheckPreviousRequirement->{TablesData} };

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

    print "\n";

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

check for initial conditions for running this migration step.

Returns 1 on success

    my $Result = $DBUpdateTo6Object->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    my ( $Self, %Param ) = @_;

    # Check for orphaned articles by default.
    my $OrphanedArticleCheck = 1;

    # Check if article table schema has been migrated already.
    my $ArticleTable         = 'article';
    my $ArticleTableMigrated = $Self->TableExists(
        Table => 'article_data_mime',
    );
    if ($ArticleTableMigrated) {
        $ArticleTable = 'article_data_mime';

        # Do not check for orphaned articles, if ticket ID column has already been dropped.
        $OrphanedArticleCheck = $Self->ColumnExists(
            Table  => 'article_data_mime',
            Column => 'ticket_id',
        );
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Count articles that have a corresponding ticket:
    #   - if article table has already been migrated and ticket_id column still exists
    #   - if article table has not been migrated yet
    if ($OrphanedArticleCheck) {

        if ($ArticleTableMigrated) {
            return if !$DBObject->Prepare(
                SQL => "
                    SELECT COUNT(tck.id)
                    FROM article_data_mime adm, ticket tck
                    WHERE adm.ticket_id=tck.id
                ",
            );
        }
        else {
            return if !$DBObject->Prepare(
                SQL => "
                    SELECT COUNT(tck.id)
                    FROM article art, ticket tck
                    WHERE art.ticket_id=tck.id
                ",
            );
        }

        my $GeneralCount;
        my $EffectiveCount;

        EFFECTIVE:
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $EffectiveCount = $Row[0];
            last EFFECTIVE;
        }

        # Count all articles in table.
        return if !$DBObject->Prepare(
            SQL => "
                SELECT COUNT(id)
                FROM $ArticleTable
            ",
        );

        GENERAL:
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $GeneralCount = $Row[0];
            last GENERAL;
        }

        # If effective count is less that general count, that means we have some orphaned articles and it's not
        #   possible to continue with the migration.
        if ( $EffectiveCount < $GeneralCount ) {
            my $OrphanedArticlesCount = $GeneralCount - $EffectiveCount;

            print "\n    Error:\n"
                . "    $OrphanedArticlesCount orphaned article(s) found! \n"
                . "    Please make sure that all articles have a corresponding ticket. \n"
                . "    If you are sure these are leftover from prior removal, \n"
                . "    please delete them manually before starting migration again. \n\n";

            return;
        }
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

            print "    \nError.\n"
                . "    There are some unknown article types: ${\(join ', ', @UnknownArticleTypes)}. \n"
                . "    Please provide additional migration matrix entries in following file: \n\n"
                . "    scripts/DBUpdateTo6/TaskConfig/MigrateArticleData.yml \n\n"
                . "    Tip: Create a copy of .dist file with the same name and edit it instead, \n"
                . "    before starting migration again. \n\n";

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

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
