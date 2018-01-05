# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdateTo6::Base;    ## no critic

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

=head1 NAME

scripts::DBUpdateTo6::Base - Base class for migrations.

=head1 PUBLIC INTERFACE

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 RebuildConfig()

Refreshes the configuration to make sure that a ZZZAAuto.pm is present after the upgrade.

    $DBUpdateTo6Object->RebuildConfig(
        UnitTestMode => 1,      # (optional) Prevent discarding all objects at the end
    );

=cut

sub RebuildConfig {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    # Convert XML files to entries in the database
    if (
        !$SysConfigObject->ConfigurationXML2DB(
            CleanUp => 1,
            Force   => 1,
            UserID  => 1,
        )
        )
    {
        print "\n\n    Error:There was a problem writing XML to DB.\n";
        return;
    }

    # Rebuild ZZZAAuto.pm with current values
    if (
        !$SysConfigObject->ConfigurationDeploy(
            Comments => $Param{Comments} || "Configuration Rebuild",
            AllSettings  => 1,
            Force        => 1,
            NoValidation => 1,
            UserID       => 1,
        )
        )
    {
        print "\n\n    Error:There was a problem writing ZZZAAuto.pm.\n";
        return;
    }

    # Force a reload of ZZZAuto.pm and ZZZAAuto.pm to get the new values
    for my $Module ( sort keys %INC ) {
        if ( $Module =~ m/ZZZAA?uto\.pm$/ ) {
            delete $INC{$Module};
        }
    }

    if ($Verbose) {
        print "\n    If you see warnings about 'Subroutine Load redefined', that's fine, no need to worry!\n";
    }

    # create common objects with new default config
    $Kernel::OM->ObjectsDiscard();

    return 1;
}

=head2 CacheCleanup()

Clean up the cache.

    $DBUpdateTo6Object->CacheCleanup();

=cut

sub CacheCleanup {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

    return 1;
}

=head2 ExecuteXMLDBArray()

Parse and execute an XML array.

    $DBUpdateTo6Object->ExecuteXMLDBArray(
        XMLArray          => \@XMLArray,
        Old2NewTableNames => {                                        # optional
            'article'            => 'article_data_mime',
            'article_plain'      => 'article_data_mime_plain',
            'article_attachment' => 'article_data_mime_attachment',
        },
    );

=cut

sub ExecuteXMLDBArray {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !IsArrayRefWithData( $Param{XMLArray} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need XMLArray!",
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    XMLSTRING:
    for my $XMLString ( @{ $Param{XMLArray} } ) {

        # new table
        if ( $XMLString =~ m{ <(?:Table|TableCreate) \s+ Name="([^"]+)" }xms ) {

            my $TableName = $1;
            return if !$TableName;

            # check if table exists already
            my $TableExists = $Self->TableExists(
                Table => $TableName,
            );

            next XMLSTRING if $TableExists;
        }

        # alter table (without renaming the table!)
        elsif ( $XMLString =~ m{ <TableAlter \s+ Name="([^"]+)" }xms ) {

            my $TableName = $1;
            return if !$TableName;

            # check if table exists
            my $TableExists = $Self->TableExists(
                Table => $TableName,
            );

            # the table must still exist
            next XMLSTRING if !$TableExists;

            # check if there is a table mapping hash
            if ( IsHashRefWithData( $Param{Old2NewTableNames} ) ) {

                # check if there is a new table name in the mapping
                my $NewTableName = $Param{Old2NewTableNames}->{$TableName} || '';
                if ($NewTableName) {

                    # check if new table exists already
                    my $NewTableExists = $Self->TableExists(
                        Table => $NewTableName,
                    );

                    # the new table must not yet exist
                    next XMLSTRING if $NewTableExists;
                }
            }

            # extract columns that should be added
            if ( $XMLString =~ m{ <ColumnAdd \s+ Name="([^"]+)" }xms ) {

                my $ColumnName = $1;
                return if !$ColumnName;

                my $ColumnExists = $Self->ColumnExists(
                    Table  => $TableName,
                    Column => $ColumnName,
                );

                # skip creating the column if the column exists already
                next XMLSTRING if $ColumnExists;
            }

            # extract columns that should be dropped
            if ( $XMLString =~ m{ <ColumnDrop \s+ Name="([^"]+)" }xms ) {

                my $ColumnName = $1;
                return if !$ColumnName;

                my $ColumnExists = $Self->ColumnExists(
                    Table  => $TableName,
                    Column => $ColumnName,
                );

                # skip dropping the column if the column does not exist
                next XMLSTRING if !$ColumnExists;
            }

            # extract indexes that should be added
            if ( $XMLString =~ m{<IndexCreate \s+ Name="([^"]+)" }xms ) {

                my $IndexName = $1;
                return if !$IndexName;

                my $IndexExists = $Self->IndexExists(
                    Table => $TableName,
                    Index => $IndexName,
                );

                # skip the index creation if it already exits
                next XMLSTRING if $IndexExists;
            }
        }

        # rename table
        elsif ( $XMLString =~ m{ <TableAlter \s+ NameOld="([^"]+)" \s+ NameNew="([^"]+)" }xms ) {

            my $OldTableName = $1;
            my $NewTableName = $2;

            return if !$OldTableName;
            return if !$NewTableName;

            # check if old table exists
            my $OldTableExists = $Self->TableExists(
                Table => $OldTableName,
            );

            # the old table must still exist
            next XMLSTRING if !$OldTableExists;

            # check if new table exists already
            my $NewTableExists = $Self->TableExists(
                Table => $NewTableName,
            );

            # the new table must not yet exist
            next XMLSTRING if $NewTableExists;
        }

        # drop table
        elsif ( $XMLString =~ m{ <TableDrop \s+ Name="([^"]+)" }xms ) {

            my $TableName = $1;
            return if !$TableName;

            # check if table still exists
            my $TableExists = $Self->TableExists(
                Table => $TableName,
            );

            # skip if table has already been deleted
            next XMLSTRING if !$TableExists;
        }

        # insert data
        elsif ( $XMLString =~ m{ <Insert \s+ Table="([^"]+)" }xms ) {

            my $TableName = $1;
            return if !$TableName;

            # extract id column and value for auto increment fields
            if ( $XMLString =~ m{ <Data \s+ Key="([^"]+)" \s+ Type="AutoIncrement"> (\d+) }xms ) {

                my $ColumnName  = $1;
                my $ColumnValue = $2;

                return if !$ColumnName;
                return if !$ColumnValue;

                # check if value exists already
                return if !$DBObject->Prepare(
                    SQL   => "SELECT $ColumnName FROM $TableName WHERE $ColumnName = ?",
                    Bind  => [ \$ColumnValue ],
                    Limit => 1,
                );

                my $Exists;
                while ( my @Row = $DBObject->FetchrowArray() ) {
                    $Exists = $Row[0];
                }

                # skip this entry if it exists already
                next XMLSTRING if $Exists;
            }
        }

        # TODO: Add more special handling for other operations as needed!

        # execute the XML string
        return if !$Self->ExecuteXMLDBString( XMLString => $XMLString );
    }

    return 1;
}

=head2 ExecuteXMLDBString()

Parse and execute an XML string.

    $DBUpdateTo6Object->ExecuteXMLDBString(
        XMLString => '
            <TableAlter Name="gi_webservice_config">
                <ColumnDrop Name="config_md5"/>
            </TableAlter>
        ',
    );

=cut

sub ExecuteXMLDBString {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !$Param{XMLString} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need XMLString!",
        );
        return;
    }

    my $XMLString = $Param{XMLString};

    # Create database specific SQL and PostSQL commands out of XML.
    my @SQL;
    my @SQLPost;
    my $DBObject  = $Kernel::OM->Get('Kernel::System::DB');
    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

    my @XMLARRAY = $XMLObject->XMLParse( String => $XMLString );

    # Create database specific SQL.
    push @SQL, $DBObject->SQLProcessor(
        Database => \@XMLARRAY,
    );

    # Create database specific PostSQL.
    push @SQLPost, $DBObject->SQLProcessorPost();

    # Execute SQL.
    for my $SQL ( @SQL, @SQLPost ) {
        my $Success = $DBObject->Do( SQL => $SQL );
        if ( !$Success ) {
            print "\n";
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Error during execution of '$SQL'!",
            );
            return;
        }
    }

    return 1;
}

=head2 TableExists()

Checks if the given table exists in the database.

    my $Result = $DBUpdateTo6Object->TableExists(
        Table => 'ticket',
    );

Returns true if the table exists, otherwise false.

=cut

sub TableExists {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Table} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Table!",
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my %TableNames = map { lc $_ => 1 } $DBObject->ListTables();

    return if !$TableNames{ lc $Param{Table} };

    return 1;
}

=head2 ColumnExists()

Checks if the given column exists in the given table.

    my $Result = $DBUpdateTo6Object->ColumnExists(
        Table  => 'ticket',
        Column =>  'id',
    );

Returns true if the column exists, otherwise false.

=cut

sub ColumnExists {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Table Column)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    $DBObject->Prepare(
        SQL   => "SELECT * FROM $Param{Table}",
        Limit => 1,
    );

    my %ColumnNames = map { lc $_ => 1 } $DBObject->GetColumnNames();

    return if !$ColumnNames{ lc $Param{Column} };

    return 1;
}

=head2 IndexExists()

Checks if the given index exists in the given table.

    my $Result = $DBUpdateTo6Object->IndexExists(
        Table => 'ticket',
        Index =>  'id',
    );

Returns true if the index exists, otherwise false.

=cut

sub IndexExists {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(Table Index)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $DBType = $Kernel::OM->Get('Kernel::System::DB')->GetDatabaseFunction('Type');

    my ( $SQL, @Bind );

    if ( $DBType eq 'mysql' ) {
        $SQL = '
            SELECT COUNT(*)
            FROM information_schema.statistics
            WHERE table_schema = DATABASE() AND table_name = ? AND index_name = ?
        ';
        push @Bind, \$Param{Table}, \$Param{Index};
    }
    elsif ( $DBType eq 'postgresql' ) {
        $SQL = '
            SELECT COUNT(*)
            FROM pg_indexes
            WHERE indexname = ?
        ';
        push @Bind, \$Param{Index};
    }
    elsif ( $DBType eq 'oracle' ) {
        $SQL = '
            SELECT COUNT(*)
            FROM user_indexes
            WHERE index_name = ?
        ';
        push @Bind, \$Param{Index};
    }
    else {
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Bind  => \@Bind,
        Limit => 1,
    );

    my @Result = $DBObject->FetchrowArray();

    return if !$Result[0];

    return 1;
}

=head2 GetTaskConfig()

Clean up the cache.

    $DBUpdateTo6Object->GetTaskConfig( Module => "TaskModuleName");

=cut

sub GetTaskConfig {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !$Param{Module} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Module!',
        );
        return;
    }

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $File = $Home . '/scripts/DBUpdateTo6/TaskConfig/' . $Param{Module} . '.yml';

    if ( !-e $File ) {
        $File .= '.dist';

        if ( !-e $File ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Couldn't find $File!",
            );
            return;
        }
    }

    my $FileRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $File,
    );

    # Convert configuration to Perl data structure for easier handling.
    my $ConfigData = $Kernel::OM->Get('Kernel::System::YAML')->Load( Data => ${$FileRef} );

    return $ConfigData;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
