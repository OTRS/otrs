# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::DBUpdateTo6::PostArticleTableStructureChanges;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo6::PostArticleTableStructureChanges -  Create entries in new article table for OmniChannel base
infrastructure.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    # Check if article_type table exists.
    my $TableExists = $Self->TableExists(
        Table => 'article_type',
    );

    # Skip execution if article_type table is missing.
    if ( !$TableExists ) {
        print "\n        - Article types table missing, skipping...\n\n" if $Verbose;
        return 1;
    }

    if ($Verbose) {
        print "\n        - Reseting auto-incremental if needed for article table.\n";
    }
    return if !$Self->_ResetAutoIncrementField();

    if ($Verbose) {
        print "        - Performing needed actions on article_data_mime table.\n";
    }
    return if !$Self->_UpdateArticleDataMimeTable();

    if ($Verbose) {
        print "        - Performing needed actions on article_data_mime_plain table.\n";
    }
    return if !$Self->_UpdateArticleDataMimePlainTable();

    if ($Verbose) {
        print "        - Performing needed actions on article_data_mime_attachment table.\n";
    }
    return if !$Self->_UpdateArticleDataMimeAttachmentTable();

    if ($Verbose) {
        print "        - Re-create foreign keys pointing to the old article table.\n";
    }
    return if !$Self->_RecreateForeignKeysPointingToArticleTable();

    if ($Verbose) {
        print "        - Dropping no longer needed article_type table.\n\n";
    }
    return if !$Self->_DropArticleTypeTable();

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

    if ( !grep {m/$DBType/} @ResetNeeded ) {
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

    # Copy values from id column to article_id column
    #   so they are the same as the id in article table.
    my $SQL = 'UPDATE article_data_mime
                SET article_id = id
                WHERE id IS NOT NULL
                AND article_id = 0
                OR article_id IS NULL';

    # For mysql type DB, set limit on update, see bug#13971.
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    if ( $DBObject->GetDatabaseFunction('Type') eq 'mysql' ) {
        $SQL .= " LIMIT 250000";
        while ( $Self->_CountRows() > 0 ) {
            return if !$DBObject->Do(
                SQL => $SQL,
            );
        }
    }
    else {
        return if !$DBObject->Do(
            SQL => $SQL,
        );
    }

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
        </TableAlter>',
        '<TableAlter Name="article_data_mime">
            <ForeignKeyCreate ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKeyCreate>
        </TableAlter>',
        '<TableAlter Name="article_data_mime">
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

    return if !$Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

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
    my @XMLStrings = (
        '<TableAlter Name="article_data_mime_plain">
            <IndexCreate Name="article_data_mime_plain_article_id">
                <IndexColumn Name="article_id"/>
            </IndexCreate>
        </TableAlter>',
        '<TableAlter Name="article_data_mime_plain">
            <ForeignKeyCreate ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKeyCreate>
        </TableAlter>',
        '<TableAlter Name="article_data_mime_plain">
            <ForeignKeyCreate ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
            </ForeignKeyCreate>
        </TableAlter>',
        '<TableAlter Name="article_data_mime_plain">
            <ForeignKeyCreate ForeignTable="users">
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKeyCreate>
        </TableAlter>',
    );

    return if !$Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

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

    # Recreate indexes and foreign keys.
    my @XMLStrings = (
        '<TableAlter Name="article_data_mime_attachment">
            <IndexCreate Name="article_data_mime_attachment_article_id">
                <IndexColumn Name="article_id"/>
            </IndexCreate>
        </TableAlter>',
        '<TableAlter Name="article_data_mime_attachment">
            <ForeignKeyCreate ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKeyCreate>
        </TableAlter>',
        '<TableAlter Name="article_data_mime_attachment">
            <ForeignKeyCreate ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
            </ForeignKeyCreate>
        </TableAlter>',
        '<TableAlter Name="article_data_mime_attachment">
            <ForeignKeyCreate ForeignTable="users">
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKeyCreate>
        </TableAlter>',
    );

    return if !$Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

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

    return if !$Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

    return 1;
}

sub _DropArticleTypeTable {
    my ( $Self, %Param ) = @_;

    my @XMLStrings = (
        '<TableDrop Name="article_type"/>',
    );

    return if !$Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

    return 1;
}

sub _CountRows {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    $DBObject->Prepare(
        SQL => '
            SELECT count(*) FROM article_data_mime
            WHERE id IS NOT NULL
            AND article_id = 0
            OR article_id IS NULL',
        Limit => 1,
    );

    my $CountRow;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $CountRow = $Row[0];
    }

    return $CountRow;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
