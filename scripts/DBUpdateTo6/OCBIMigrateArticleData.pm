# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::OCBIMigrateArticleData;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::XML',
);

=head1 NAME

scripts::DBUpdateTo6::OCBIMigrateArticleData -  Create entries in new article table for OmniChannel base infrastructure.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $DBObject  = $Kernel::OM->Get('Kernel::System::DB');
    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

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
        print STDERR
            "\n Something got wrong, there are more entries in 'article' table than in 'article_data_mime'.\n";
        return;
    }

    # Have to be the same amount of records in both tables.
    # tables with the sale ids
    elsif (
        $TablesData{article_data_mime}->{MaxID} == $TablesData{article}->{MaxID}
        && $TablesData{article_data_mime}->{Count} == $TablesData{article}->{Count}
        )
    {

        print STDERR
            "\n Article data migration already executed \n";
        return 1;
    }

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

    # TODO:OCBI: This number might be changed or even configurable
    my $RowsPerLoop = 1000;

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
            my $IsVisibleForCustomer = 0;
            if ( $ArticleTypes{ $Row[3] } =~ /(-ext|phone|fax|sms|webrequest)/i ) {
                $IsVisibleForCustomer = 1;
            }

            # Map Communication Channel.
            my $CommunicationChannel;
            if ( $ArticleTypes{ $Row[3] } =~ /email-/i ) {
                $CommunicationChannel = 'Email';
            }
            elsif ( $ArticleTypes{ $Row[3] } =~ /phone/i ) {
                $CommunicationChannel = 'Phone';
            }
            elsif ( $ArticleTypes{ $Row[3] } =~ /chat-/i ) {
                $CommunicationChannel = 'Chat';
            }
            else {
                $CommunicationChannel = 'Internal';
            }
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

        if ( !@Data ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "No entries found in 'article_data_mime'!",
            );
            return;
        }

        my $DataSize = @Data;

        my $MigrationResult = $Self->_MigrateData(
            Data              => \@Data,
            LastArticleDataID => $Data[ $DataSize - 1 ]->{ID},
        );

        if ( !$MigrationResult ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "An error occurs during article data migration!",
            );
            return;
        }

        $StartInEntry += $RowsPerLoop;
    }

    $Self->_ResetAutoIncrementField();

    $Self->_UpdateArticleDataMimeTable();

    $Self->_UpdateArticleDataMimePlainTable();

    $Self->_UpdateArticleDataMimeAttachmentTable();

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

    if ( !grep( /$DBType/, @SupportMultipleInserts ) ) {
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

            # Insert multiple history entries.
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

=head2 _ResetAutoIncrementField()

Reset the auto increment for article table. Returns 1 on success

    my $Result = $DBUpdateTo6Object->_ResetAutoIncrementField();

=cut

sub _ResetAutoIncrementField {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Get the database type.
    my $DBType = $DBObject->GetDatabaseFunction('Type');

    # Decide if reset is needed.
    my @ResetNeeded = qw(oracle postgresql);

    if ( !grep( /$DBType/, @ResetNeeded ) ) {
        return 1;
    }

    return if !$DBObject->Prepare(
        SQL => "
            SELECT id
            FROM article
            ORDER BY id DESC",
        Limit => 1,
    );

    my $LastID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $LastID = $Row[0];
    }

    # add one more to the last ID
    $LastID++;

    if ( $DBType eq 'oracle' ) {

        my $SEName = 'SE_ARTICLE';

        # we assume the sequence have a minimum value (0)
        # we will to increase it till the last entry on
        # if field we have

        # verify if the sequence exists
        return if !$DBObject->Prepare(
            SQL => "
                SELECT COUNT(*)
                FROM user_sequences
                WHERE sequence_name = ?",
            Limit => 1,
            Bind  => [
                \$SEName,
            ],
        );

        my $SequenceCount;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $SequenceCount = $Row[0];
        }

        if ($SequenceCount) {

            # set increment as last number on the id field, plus one
            my $SQL = "ALTER SEQUENCE $SEName INCREMENT BY $LastID";

            return if !$DBObject->Do(
                SQL => $SQL,
            );

            # get next value for sequence
            $SQL = "SELECT $SEName.nextval FROM dual";

            return if !$DBObject->Prepare(
                SQL => $SQL,
            );

            my $ResultNextVal;
            while ( my @Row = $DBObject->FetchrowArray() ) {
                $ResultNextVal = $Row[0];
            }

            # reset sequence to increment by 1 to 1
            $SQL = "ALTER SEQUENCE $SEName INCREMENT BY 1";

            return if !$DBObject->Do(
                SQL => $SQL,
            );
        }

        return 1;
    }
    elsif ( $DBType eq 'postgresql' ) {

        # check if sequence exists
        return if !$DBObject->Prepare(
            SQL => "
            SELECT
                1
            FROM pg_class c
            WHERE
                c.relkind = 'S' AND
                c.relname = 'article_id_seq'",
            Limit => 1,
        );

        my $SequenceExists = 0;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $SequenceExists = $Row[0];
        }

        return 1 if !$SequenceExists;

        my $SQL = "
            ALTER SEQUENCE article_id_seq RESTART WITH $LastID;
        ";

        return if !$DBObject->Do(
            SQL => $SQL,
        );

        return 1;
    }

    return;
}

=head2 _UpdateArticleDataMimeTable()

updates the table article_data_mime:

    - adding an article_id column
    - copying id values into article_id column
    - recreating indexes and foreign keys
    - dropping no longer used columns

Returns 1 on success

    my $Result = $DBUpdateTo6Object->_UpdateArticleDataMimeTable();

=cut

sub _UpdateArticleDataMimeTable {
    my ( $Self, %Param ) = @_;

    # add article_id column
    my $XMLString = '
        <TableAlter Name="article_data_mime">
            <ColumnAdd Name="article_id" Required="true" Type="BIGINT"/>
        </TableAlter>
    ';

    return if !$Self->ExecuteXMLDBString( XMLString => $XMLString );

    # copy values from id column to article_id column
    # so they are the same as the id in article table.
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            UPDATE article_data_mime
            SET article_id = id',
    );

# recreate indexes and foreign keys, and drop no longer used columns
# TODO: Maybe check if there are custom article types in the system and delay the dropping of article_type_id and sender_type_id
    $XMLString = '
        <TableAlter Name="article_data_mime">
            <IndexCreate Name="article_data_mime_message_id_md5">
                <IndexColumn Name="a_message_id_md5"/>
            </IndexCreate>
            <ForeignKeyCreate ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKeyCreate>
            <ForeignKey ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKey>
            <ColumnDrop Name="ticket_id"/>
            <ColumnDrop Name="valid_id"/>
            <ColumnDrop Name="article_type_id"/>
            <ColumnDrop Name="article_sender_type_id"/>
        </TableAlter>
    ';

    return if !$Self->ExecuteXMLDBString( XMLString => $XMLString );

    return 1;
}

=head2 _UpdateArticleDataMimePlainTable()

updates the table article_data_mime_plain:

    - recreating indexes and foreign keys

Returns 1 on success

    my $Result = $DBUpdateTo6Object->_UpdateArticleDataMimePlainTable();

=cut

sub _UpdateArticleDataMimePlainTable {
    my ( $Self, %Param ) = @_;

    # recreate indexes and foreign keys
    my $XMLString = '
        <TableAlter Name="article_data_mime_plain">
            <IndexCreate Name="article_data_mime_plain_article_id">
                <IndexColumn Name="article_id"/>
            </IndexCreate>
            <ForeignKeyCreate ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKeyCreate>
            <ForeignKey ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKey>
        </TableAlter>
    ';

    return if !$Self->ExecuteXMLDBString( XMLString => $XMLString );

    return 1;
}

=head2 _UpdateArticleDataMimeAttachmentTable()

updates the table article_data_mime_attachment:

    - recreating indexes and foreign keys

Returns 1 on success

    my $Result = $DBUpdateTo6Object->_UpdateArticleDataMimeAttachmentTable();

=cut

sub _UpdateArticleDataMimeAttachmentTable {
    my ( $Self, %Param ) = @_;

    # recreate indexes and foreign keys
    my $XMLString = '
        <TableAlter Name="article_data_mime_attachment">
            <IndexCreate Name="article_data_mime_attachment_article_id">
                <IndexColumn Name="article_id"/>
            </IndexCreate>
            <ForeignKeyCreate ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKeyCreate>
            <ForeignKey ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKey>
        </TableAlter>
    ';

    return if !$Self->ExecuteXMLDBString( XMLString => $XMLString );

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
