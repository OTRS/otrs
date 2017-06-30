# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::PostArticleTableStructureChanges;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::XML',
);

=head1 NAME

scripts::DBUpdateTo6::PostArticleTableStructureChanges -  Create entries in new article table for OmniChannel base infrastructure.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    if ($Verbose) {
        print "\n Reseting auto-incremental if needed for article table. \n";
    }
    return if !$Self->_ResetAutoIncrementField();

    if ($Verbose) {
        print "\n Performing needed actions on article_data_mime table. \n";
    }
    return if !$Self->_UpdateArticleDataMimeTable();

    if ($Verbose) {
        print "\n Performing needed actions on article_data_mime_plain table. \n";
    }
    return if !$Self->_UpdateArticleDataMimePlainTable();

    if ($Verbose) {
        print "\n Performing needed actions on article_data_mime_attachment table. \n";
    }
    return if !$Self->_UpdateArticleDataMimeAttachmentTable();

    if ($Verbose) {
        print "\n Re-create foreign keys pointing to the old article table. \n";
    }
    return if !$Self->_RecreateForeignKeysPointingToArticleTable();

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

    # copy values from id column to article_id column
    # so they are the same as the id in article table.
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            UPDATE article_data_mime
            SET article_id = id
            WHERE id IS NOT NULL',
    );

    # recreate indexes and foreign keys, and drop no longer used columns
    # split each unique drop / column drop into separate statements
    # so we are able to skip some of them if neccessary
    #
    # TODO: Maybe check if there are custom article types in the system and delay
    # the dropping of article_type_id and sender_type_id
    my @XMLStrings = (
        '<TableAlter Name="article_data_mime">
            <IndexCreate Name="article_data_mime_message_id_md5">
                <IndexColumn Name="a_message_id_md5"/>
            </IndexCreate>
            <ForeignKeyCreate ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKeyCreate>
            <ForeignKeyCreate ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKeyCreate>
        </TableAlter>',

        '<TableAlter Name="article_data_mime">
            <ColumnDrop Name="ticket_id"/>
        </TableAlter>',

        '<TableAlter Name="article_data_mime">
            <ColumnDrop Name="valid_id"/>
        </TableAlter>',

        '<TableAlter Name="article_data_mime">
            <ColumnDrop Name="article_type_id"/>
        </TableAlter>',

        '<TableAlter Name="article_data_mime">
            <ColumnDrop Name="article_sender_type_id"/>
        </TableAlter>',
    );

    XMLSTRING:
    for my $XMLString (@XMLStrings) {

        # extract table name from XML string
        if ( $XMLString =~ m{ <TableAlter \s+ Name="([^"]+)" }xms ) {
            my $TableName = $1;

            next XMLSTRING if !$TableName;

            # extract columns that should be dropped from XML string
            if ( $XMLString =~ m{ <ColumnDrop \s+ Name="([^"]+)" }xms ) {
                my $ColumnName = $1;

                next XMLSTRING if !$ColumnName;

                my $ColumnExists = $Self->ColumnExists(
                    Table  => $TableName,
                    Column => $ColumnName,
                );

                # skip dropping the column if the column does not exist
                next XMLSTRING if !$ColumnExists;
            }
        }

        return if !$Self->ExecuteXMLDBString( XMLString => $XMLString );
    }

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
            <ForeignKeyCreate ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKeyCreate>
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
            <ForeignKeyCreate ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKeyCreate>
        </TableAlter>
    ';

    return if !$Self->ExecuteXMLDBString( XMLString => $XMLString );

    return 1;
}

=head2 _RecreateForeignKeysPointingToArticleTable()

re-create foreign keys pointing to the current article table,
due in some cases these are automatically redirected to the renamed table.

Returns 1 on success

    my $Result = $DBUpdateTo6Object->_RecreateForeignKeysPointingToArticleTable();

=cut

sub _RecreateForeignKeysPointingToArticleTable {
    my ( $Self, %Param ) = @_;

    # Re-create foreign keys pointing to the current article table,
    # due in some cases these are automatically redirected to the renamed table.
    my @XMLStrings = (
        '<TableAlter Name="ticket_history">
            <ForeignKeyCreate ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKeyCreate>
        </TableAlter>',
        '<TableAlter Name="article_flag">
            <ForeignKeyCreate ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKeyCreate>
        </TableAlter>',
        '<TableAlter Name="time_accounting">
            <ForeignKeyCreate ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKeyCreate>
        </TableAlter>',
    );

    XMLSTRING:
    for my $XMLString (@XMLStrings) {

        # extract table name from XML string
        if ( $XMLString =~ m{ <TableAlter \s+ Name="([^"]+)" }xms ) {
            my $TableName = $1;

            next XMLSTRING if !$TableName;

            # extract columns that should be dropped from XML string
            if ( $XMLString =~ m{ <ColumnDrop \s+ Name="([^"]+)" }xms ) {
                my $ColumnName = $1;

                next XMLSTRING if !$ColumnName;

                my $ColumnExists = $Self->ColumnExists(
                    Table  => $TableName,
                    Column => $ColumnName,
                );

                # skip dropping the column if the column does not exist
                next XMLSTRING if !$ColumnExists;
            }
        }

        return if !$Self->ExecuteXMLDBString( XMLString => $XMLString );
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
