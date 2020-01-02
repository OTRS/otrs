# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::DB::oracle;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DateTime',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub LoadPreferences {
    my ( $Self, %Param ) = @_;

    # db settings
    $Self->{'DB::Limit'}                       = 0;
    $Self->{'DB::DirectBlob'}                  = 0;
    $Self->{'DB::QuoteSingle'}                 = '\'';
    $Self->{'DB::QuoteBack'}                   = 0;
    $Self->{'DB::QuoteSemicolon'}              = '';
    $Self->{'DB::QuoteUnderscoreStart'}        = '\\';
    $Self->{'DB::QuoteUnderscoreEnd'}          = '';
    $Self->{'DB::CaseSensitive'}               = 1;
    $Self->{'DB::LikeEscapeString'}            = q{ESCAPE '\\'};
    $Self->{'DB::MaxParamCountForInCondition'} = 1000;

    # how to determine server version
    $Self->{'DB::Version'}
        = "SELECT CONCAT('Oracle ', version) FROM product_component_version WHERE product LIKE 'Oracle Database%'";

    $Self->{'DB::ListTables'} = 'SELECT table_name FROM user_tables ORDER BY table_name';

    # dbi attributes
    $Self->{'DB::Attribute'} = {
        LongTruncOk => 1,
        LongReadLen => 40 * 1024 * 1024,
    };

    # set current time stamp if different to "current_timestamp"
    $Self->{'DB::CurrentTimestamp'} = '';

    # set encoding of selected data to utf8
    $Self->{'DB::Encode'} = 0;

    # shell setting
    $Self->{'DB::Comment'}      = '-- ';
    $Self->{'DB::ShellCommit'}  = ';';
    $Self->{'DB::ShellConnect'} = "SET DEFINE OFF;\nSET SQLBLANKLINES ON";    # must be on separate lines!

    # init sql setting on db connect
    $Self->{'DB::Connect'} = "ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS'";

    return 1;
}

sub Quote {
    my ( $Self, $Text, $Type ) = @_;

    if ( defined ${$Text} ) {
        if ( $Self->{'DB::QuoteBack'} ) {
            ${$Text} =~ s/\\/$Self->{'DB::QuoteBack'}\\/g;
        }
        if ( $Self->{'DB::QuoteSingle'} ) {
            ${$Text} =~ s/'/$Self->{'DB::QuoteSingle'}'/g;
        }
        if ( $Self->{'DB::QuoteSemicolon'} ) {
            ${$Text} =~ s/;/$Self->{'DB::QuoteSemicolon'};/g;
        }
        if ( $Type && $Type eq 'Like' ) {
            if ( $Self->{'DB::QuoteUnderscoreStart'} || $Self->{'DB::QuoteUnderscoreEnd'} ) {
                ${$Text}
                    =~ s/_/$Self->{'DB::QuoteUnderscoreStart'}_$Self->{'DB::QuoteUnderscoreEnd'}/g;
            }
        }
    }
    return $Text;
}

sub DatabaseCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name!'
        );
        return;
    }

    # return SQL
    return ("CREATE DATABASE $Param{Name}");
}

sub DatabaseDrop {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name!'
        );
        return;
    }

    # return SQL
    return ("DROP DATABASE $Param{Name}");
}

sub TableCreate {
    my ( $Self, @Param ) = @_;

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

    my $SQLStart     = '';
    my $SQLEnd       = '';
    my $SQL          = '';
    my @Column       = ();
    my $TableName    = '';
    my $ForeignKey   = ();
    my %Foreign      = ();
    my $IndexCurrent = ();
    my %Index        = ();
    my $UniqCurrent  = ();
    my %Uniq         = ();
    my $PrimaryKey   = '';
    my @Return       = ();
    my @Return2      = ();

    for my $Tag (@Param) {

        if (
            ( $Tag->{Tag} eq 'Table' || $Tag->{Tag} eq 'TableCreate' )
            && $Tag->{TagType} eq 'Start'
            )
        {
            if ( $ConfigObject->Get('Database::ShellOutput') ) {
                $SQLStart .= $Self->{'DB::Comment'}
                    . "----------------------------------------------------------\n";
                $SQLStart .= $Self->{'DB::Comment'} . " create table $Tag->{Name}\n";
                $SQLStart .= $Self->{'DB::Comment'}
                    . "----------------------------------------------------------\n";
            }
        }
        if ( $Tag->{Tag} eq 'Table' || $Tag->{Tag} eq 'TableCreate' ) {
            if ( $Tag->{TagType} eq 'Start' ) {
                $SQLStart .= "CREATE TABLE $Tag->{Name} (\n";
                $TableName = $Tag->{Name};
            }
            elsif ( $Tag->{TagType} eq 'End' ) {
                $SQLEnd .= "\n)";
            }
        }
        elsif ( $Tag->{Tag} eq 'Column' && $Tag->{TagType} eq 'Start' ) {
            push @Column, $Tag;
        }
        elsif ( $Tag->{Tag} eq 'Index' && $Tag->{TagType} eq 'Start' ) {
            $IndexCurrent = $Tag->{Name};
        }
        elsif ( $Tag->{Tag} eq 'IndexColumn' && $Tag->{TagType} eq 'Start' ) {
            push @{ $Index{$IndexCurrent} }, $Tag;
        }
        elsif ( $Tag->{Tag} eq 'Unique' && $Tag->{TagType} eq 'Start' ) {
            $UniqCurrent = $Tag->{Name} || $TableName . '_U_' . int( rand(999) );
        }
        elsif ( $Tag->{Tag} eq 'UniqueColumn' && $Tag->{TagType} eq 'Start' ) {
            push @{ $Uniq{$UniqCurrent} }, $Tag;
        }
        elsif ( $Tag->{Tag} eq 'ForeignKey' && $Tag->{TagType} eq 'Start' ) {
            $ForeignKey = $Tag->{ForeignTable};
        }
        elsif ( $Tag->{Tag} eq 'Reference' && $Tag->{TagType} eq 'Start' ) {
            push @{ $Foreign{$ForeignKey} }, $Tag;
        }
    }
    for my $Tag (@Column) {

        # type translation
        $Tag = $Self->_TypeTranslation($Tag);

        # add new line
        if ($SQL) {
            $SQL .= ",\n";
        }

        # normal data type
        $SQL .= "    $Tag->{Name} $Tag->{Type}";

        # handle default
        my $DisableNotNull;
        if ( defined $Tag->{Default} ) {
            if ( $Tag->{Type} =~ m{ (int|number) }xmsi ) {
                $SQL .= " DEFAULT " . $Tag->{Default};
            }
            elsif ( $Tag->{Default} ) {
                $SQL .= " DEFAULT '" . $Tag->{Default} . "'";
            }
            else {
                $DisableNotNull = 1;
            }
        }

        # handle require
        if ( !$DisableNotNull && $Tag->{Required} && lc $Tag->{Required} eq 'true' ) {
            $SQL .= ' NOT NULL';
        }
        else {
            $SQL .= ' NULL';
        }

        # add primary key
        if ( $Tag->{PrimaryKey} && $Tag->{PrimaryKey} =~ /true/i ) {

            my $Constraint = $Self->_ConstraintName(
                TableName => $TableName,
            );

            push @Return2,
                "ALTER TABLE $TableName ADD CONSTRAINT $Constraint PRIMARY KEY ($Tag->{Name})";
        }

        # auto increment
        if ( $Tag->{AutoIncrement} && $Tag->{AutoIncrement} =~ /^true$/i ) {

            my $Sequence = $Self->_SequenceName(
                TableName => $TableName,
            );

            my $Trigger = $Sequence . '_t';

            my $Shell = '';
            if ( $ConfigObject->Get('Database::ShellOutput') ) {
                $Shell = "/\n--";
            }

            push @Return2, <<"EOF";
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE $Sequence';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
$Shell
EOF

            push @Return2, <<"EOF";
CREATE SEQUENCE $Sequence
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER
EOF

            push @Return2, <<"EOF";
BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER $Trigger';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
$Shell
EOF

            push @Return2, <<"EOF";
CREATE OR REPLACE TRIGGER $Trigger
BEFORE INSERT ON $TableName
FOR EACH ROW
BEGIN
    IF :new.$Tag->{Name} IS NULL THEN
        SELECT $Sequence.nextval
        INTO :new.$Tag->{Name}
        FROM DUAL;
    END IF;
END;
$Shell
EOF

        }
    }

    # add unique
    for my $Name ( sort keys %Uniq ) {

        my $Unique = $Self->_UniqueName(
            Name => $Name,
        );

        if ($SQL) {
            $SQL .= ",\n";
        }
        $SQL .= "    CONSTRAINT $Unique UNIQUE (";
        my @Array = @{ $Uniq{$Name} };
        my $Name  = '';
        for ( 0 .. $#Array ) {
            if ( $_ > 0 ) {
                $SQL .= ', ';
            }
            $SQL  .= $Array[$_]->{Name};
            $Name .= '_' . $Array[$_]->{Name};
        }
        $SQL .= ')';
    }
    push @Return, $SQLStart . $SQL . $SQLEnd, @Return2;

    # add foreign keys
    for my $ForeignKey ( sort keys %Foreign ) {
        my @Array = @{ $Foreign{$ForeignKey} };
        for ( 0 .. $#Array ) {
            push @{ $Self->{Post} },
                $Self->ForeignKeyCreate(
                LocalTableName   => $TableName,
                Local            => $Array[$_]->{Local},
                ForeignTableName => $ForeignKey,
                Foreign          => $Array[$_]->{Foreign},
                );
        }
    }

    # add indexes
    for my $Name ( sort keys %Index ) {
        push @Return,
            $Self->IndexCreate(
            TableName => $TableName,
            Name      => $Name,
            Data      => $Index{$Name},
            );
    }

    return @Return;
}

sub TableDrop {
    my ( $Self, @Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $SQL = '';
    for my $Tag (@Param) {
        if ( $Tag->{Tag} eq 'Table' && $Tag->{TagType} eq 'Start' ) {
            if ( $ConfigObject->Get('Database::ShellOutput') ) {
                $SQL .= $Self->{'DB::Comment'}
                    . "----------------------------------------------------------\n";
                $SQL .= $Self->{'DB::Comment'} . " drop table $Tag->{Name}\n";
                $SQL .= $Self->{'DB::Comment'}
                    . "----------------------------------------------------------\n";
            }
        }

        $SQL .= "DROP TABLE $Tag->{Name} CASCADE CONSTRAINTS";

        # get sequence name
        my $Sequence = $Self->_SequenceName(
            TableName => $Tag->{Name},
        );
        my $Shell = '';
        if ( $ConfigObject->Get('Database::ShellOutput') ) {
            $Shell = "/\n--";
        }

        # build sql to drop sequence
        my $DropSequenceSQL = <<"EOF";
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE $Sequence';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
$Shell
EOF

        return ( $SQL, $DropSequenceSQL );
    }
    return ();
}

sub TableAlter {
    my ( $Self, @Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $SQLStart      = '';
    my @SQL           = ();
    my @Index         = ();
    my $IndexName     = ();
    my $ForeignTable  = '';
    my $ReferenceName = '';
    my @Reference     = ();
    my $Table         = '';

    for my $Tag (@Param) {

        if ( $Tag->{Tag} eq 'TableAlter' && $Tag->{TagType} eq 'Start' ) {
            $Table = $Tag->{Name} || $Tag->{NameNew};
            if ( $ConfigObject->Get('Database::ShellOutput') ) {
                $SQLStart .= $Self->{'DB::Comment'}
                    . "----------------------------------------------------------\n";
                $SQLStart .= $Self->{'DB::Comment'} . " alter table $Table\n";
                $SQLStart .= $Self->{'DB::Comment'}
                    . "----------------------------------------------------------\n";
            }

            # rename table
            if ( $Tag->{NameOld} && $Tag->{NameNew} ) {
                push @SQL, $SQLStart . "ALTER TABLE $Tag->{NameOld} RENAME TO $Tag->{NameNew}";

                my $Shell = '';
                if ( $ConfigObject->Get('Database::ShellOutput') ) {
                    $Shell = "/\n--";
                }

                # get old primary key name constraint
                my $OldConstraint = $Self->_ConstraintName(
                    TableName => $Tag->{NameOld},
                );

                # get new primary key name constraint
                my $NewConstraint = $Self->_ConstraintName(
                    TableName => $Tag->{NameNew},
                );

                # build SQL to rename primary key constraint
                my $RenameConstraintSQL = <<"EOF";
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE $Tag->{NameNew} RENAME CONSTRAINT $OldConstraint TO $NewConstraint';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
$Shell
EOF

                push @SQL, $SQLStart . $RenameConstraintSQL;

                # build SQL to rename index of primary key
                my $RenameIndexSQL = <<"EOF";
BEGIN
    EXECUTE IMMEDIATE 'ALTER INDEX $OldConstraint RENAME TO $NewConstraint';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
$Shell
EOF

                push @SQL, $SQLStart . $RenameIndexSQL;

                # get old sequence name
                my $OldSequence = $Self->_SequenceName(
                    TableName => $Tag->{NameOld},
                );

                # get new sequence name
                my $NewSequence = $Self->_SequenceName(
                    TableName => $Tag->{NameNew},
                );

                # define old and new trigger names
                my $OldTrigger = $OldSequence . '_t';
                my $NewTrigger = $NewSequence . '_t';

                # build SQL to rename sequence (only if a sequence exists)
                my $RenameSequenceSQL = <<"EOF";
DECLARE
    sequence_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO sequence_count
    FROM user_sequences
    WHERE UPPER(sequence_name) = UPPER('$OldSequence');

    IF sequence_count > 0 THEN
        EXECUTE IMMEDIATE 'RENAME $OldSequence TO $NewSequence';
    END IF;

EXCEPTION
    WHEN OTHERS THEN NULL;
END;
$Shell
EOF

                push @SQL, $SQLStart . $RenameSequenceSQL;

                # build SQL to drop old trigger (only if a trigger exists)
                # and to create a new trigger
                # (the name of the autoincrement column needed for the trigger is investigated automatically)
                my $DropOldAndCreateNewTriggerSQL = <<"EOF";
DECLARE
    trigger_count NUMBER;
    pk_column_name VARCHAR(50);
BEGIN
    SELECT COUNT(*)
    INTO trigger_count
    FROM user_triggers
    WHERE UPPER(trigger_name) = UPPER('$OldTrigger');

    SELECT column_name
    INTO pk_column_name
    FROM user_ind_columns
    WHERE UPPER(table_name) = UPPER('$Tag->{NameNew}')
    AND UPPER(index_name) = UPPER('$NewConstraint');

    IF trigger_count > 0 THEN
        EXECUTE IMMEDIATE 'DROP TRIGGER $OldTrigger';

        EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER $NewTrigger
            BEFORE INSERT ON $Tag->{NameNew}
            FOR EACH ROW
            BEGIN
                IF :new.' || pk_column_name || ' IS NULL THEN
                    SELECT $NewSequence.nextval
                    INTO :new.' || pk_column_name || '
                    FROM DUAL;
                END IF;
            END;';
    END IF;

EXCEPTION
    WHEN OTHERS THEN NULL;
END;
$Shell
EOF

                push @SQL, $SQLStart . $DropOldAndCreateNewTriggerSQL;
            }
            $SQLStart .= "ALTER TABLE $Table";
        }
        elsif ( $Tag->{Tag} eq 'ColumnAdd' && $Tag->{TagType} eq 'Start' ) {

            # Type translation
            $Tag = $Self->_TypeTranslation($Tag);

            # normal data type
            push @SQL, $SQLStart . " ADD $Tag->{Name} $Tag->{Type} NULL";

            # investigate the require
            my $Required = ( $Tag->{Required} && lc $Tag->{Required} eq 'true' ) ? 1 : 0;

            # investigate the default value
            my $Default = '';
            if ( $Tag->{Type} =~ m{ (int|number) }xmsi ) {
                $Default = defined $Tag->{Default} ? $Tag->{Default} : 0;
            }
            else {
                $Default = defined $Tag->{Default} ? "'$Tag->{Default}'" : "''";
            }

            # handle default and require
            if ( $Default ne "''" && ( $Required || defined $Tag->{Default} ) ) {

                # fill up empty rows
                push @SQL, "UPDATE $Table SET $Tag->{Name} = $Default WHERE $Tag->{Name} IS NULL";

                my $SQLAlter = "ALTER TABLE $Table MODIFY $Tag->{Name} $Tag->{Type}";

                # add default
                if ( defined $Tag->{Default} ) {
                    $SQLAlter .= " DEFAULT $Default";
                }

                # add require
                if ($Required) {
                    $SQLAlter .= ' NOT NULL';
                }

                push @SQL, $SQLAlter;
            }
        }
        elsif ( $Tag->{Tag} eq 'ColumnChange' && $Tag->{TagType} eq 'Start' ) {

            # Type translation
            $Tag = $Self->_TypeTranslation($Tag);

            # rename oldname to newname
            if ( $Tag->{NameOld} ne $Tag->{NameNew} ) {
                push @SQL, $SQLStart . " RENAME COLUMN $Tag->{NameOld} TO $Tag->{NameNew}";
            }

            # alter table name modify
            if ( !$Tag->{Name} && $Tag->{NameNew} ) {
                $Tag->{Name} = $Tag->{NameNew};
            }
            if ( !$Tag->{Name} && $Tag->{NameOld} ) {
                $Tag->{Name} = $Tag->{NameOld};
            }

            # investigate the require
            my $Required = ( $Tag->{Required} && lc $Tag->{Required} eq 'true' ) ? 1 : 0;

            # investigate the default value
            my $Default = '';
            if ( $Tag->{Type} =~ m{ (int|number) }xmsi ) {
                $Default = defined $Tag->{Default} ? $Tag->{Default} : 0;
            }
            else {
                $Default = defined $Tag->{Default} ? "'$Tag->{Default}'" : "''";
            }

            # if the column is a CLOB we create a temporary column with the CLOB type,
            # then copy the data from the old column to the temporary column
            # and then remove the temporary column
            # Fix/Workaround for ORA-22858: invalid alteration of datatype
            if ( $Tag->{Type} eq 'CLOB' ) {

                # create temp column name
                my $ColumnTemp = $Tag->{Name} . '_TEMP';

                # create temp column
                push @SQL, "ALTER TABLE $Table ADD $ColumnTemp $Tag->{Type} NULL";

                # copy data from old column into temp column
                push @SQL, "UPDATE $Table SET $ColumnTemp = $Tag->{Name}";

                # delete old column
                push @SQL, "ALTER TABLE $Table DROP COLUMN $Tag->{Name}";

                # rename temp column to old column name
                push @SQL, "ALTER TABLE $Table RENAME COLUMN $ColumnTemp TO $Tag->{Name}";
            }

            # the column type is no CLOB
            else {
                my $SQLEnd = "ALTER TABLE $Table MODIFY $Tag->{Name} $Tag->{Type} DEFAULT NULL";
                push @SQL, $SQLEnd;
            }

            # handle default and require
            if ( $Default ne "''" && ( $Required || defined $Tag->{Default} ) ) {

                # fill up empty rows
                push @SQL, "UPDATE $Table SET $Tag->{Name} = $Default WHERE $Tag->{Name} IS NULL";

                my $SQLAlter = "ALTER TABLE $Table MODIFY $Tag->{Name} $Tag->{Type}";

                # add default
                if ( defined $Tag->{Default} ) {
                    $SQLAlter .= " DEFAULT $Default";
                }

                # add require
                if ($Required) {
                    $SQLAlter .= ' NOT NULL';
                }

                push @SQL, $SQLAlter;
            }
        }
        elsif ( $Tag->{Tag} eq 'ColumnDrop' && $Tag->{TagType} eq 'Start' ) {
            my $SQLEnd = $SQLStart . " DROP COLUMN $Tag->{Name}";
            push @SQL, $SQLEnd;
        }
        elsif ( $Tag->{Tag} =~ /^((Index|Unique)(Create|Drop))/ ) {
            my $Method = $Tag->{Tag};
            if ( $Tag->{Name} ) {
                $IndexName = $Tag->{Name};
            }
            if ( $Tag->{TagType} eq 'End' ) {
                push @SQL, $Self->$Method(
                    TableName => $Table,
                    Name      => $IndexName,
                    Data      => \@Index,
                );
                $IndexName = '';
                @Index     = ();
            }
        }
        elsif ( $Tag->{Tag} =~ /^(IndexColumn|UniqueColumn)/ && $Tag->{TagType} eq 'Start' ) {
            push @Index, $Tag;
        }
        elsif ( $Tag->{Tag} =~ /^((ForeignKey)(Create|Drop))/ ) {
            my $Method = $Tag->{Tag};
            if ( $Tag->{ForeignTable} ) {
                $ForeignTable = $Tag->{ForeignTable};
            }
            if ( $Tag->{TagType} eq 'End' ) {
                for my $Reference (@Reference) {
                    push @SQL, $Self->$Method(
                        LocalTableName   => $Table,
                        Local            => $Reference->{Local},
                        ForeignTableName => $ForeignTable,
                        Foreign          => $Reference->{Foreign},
                    );
                }
                $ReferenceName = '';
                @Reference     = ();
            }
        }
        elsif ( $Tag->{Tag} =~ /^(Reference)/ && $Tag->{TagType} eq 'Start' ) {
            push @Reference, $Tag;
        }
    }

    return @SQL;
}

sub IndexCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TableName Name Data)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    my $Index = $Self->_IndexName(
        Name => $Param{Name},
    );
    my $CreateIndexSQL = "CREATE INDEX $Index ON $Param{TableName} (";
    my @Array          = @{ $Param{Data} };
    for ( 0 .. $#Array ) {
        if ( $_ > 0 ) {
            $CreateIndexSQL .= ', ';
        }
        $CreateIndexSQL .= $Array[$_]->{Name};
    }
    $CreateIndexSQL .= ')';

    my $Shell = '';
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Database::ShellOutput') ) {
        $Shell = "/\n--";
    }

    # build sql to create index within a "try/catch block"
    # to prevent errors if index exists already
    $CreateIndexSQL = <<"EOF";
BEGIN
    EXECUTE IMMEDIATE '$CreateIndexSQL';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
$Shell
EOF

    return ($CreateIndexSQL);
}

sub IndexDrop {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TableName Name)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    my $Index = $Self->_IndexName(
        Name => $Param{Name},
    );

    my $DropIndexSQL = 'DROP INDEX ' . $Index;

    my $Shell = '';
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Database::ShellOutput') ) {
        $Shell = "/\n--";
    }

    # build sql to drop index within a "try/catch block"
    # to prevent errors if index does not exist
    $DropIndexSQL = <<"EOF";
BEGIN
    EXECUTE IMMEDIATE '$DropIndexSQL';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
$Shell
EOF

    return ($DropIndexSQL);
}

sub ForeignKeyCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(LocalTableName Local ForeignTableName Foreign)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # create foreign key name
    my $ForeignKey = $Self->_ForeignKeyName(
        Name => "FK_$Param{LocalTableName}_$Param{Local}_$Param{Foreign}",
    );

    # add foreign key
    my $CreateForeignKeySQL = "ALTER TABLE $Param{LocalTableName} ADD CONSTRAINT $ForeignKey FOREIGN KEY "
        . "($Param{Local}) REFERENCES $Param{ForeignTableName} ($Param{Foreign})";

    my $Shell = '';
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Database::ShellOutput') ) {
        $Shell = "/\n--";
    }

    # build sql to create foreign key within a "try/catch block"
    # to prevent errors if foreign key exists already
    $CreateForeignKeySQL = <<"EOF";
BEGIN
    EXECUTE IMMEDIATE '$CreateForeignKeySQL';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
$Shell
EOF

    # build index name
    my $IndexName = $Self->_IndexName(
        Name => 'FK_' . $Param{LocalTableName} . '_' . $Param{Local},
    );

    # generate forced index for every FK to do row locking (not table locking)
    my @CreateIndexSQL = $Self->IndexCreate(
        TableName => $Param{LocalTableName},
        Name      => $IndexName,
        Data      => [ { Name => $Param{Local} } ],
    );

    return ( $CreateForeignKeySQL, @CreateIndexSQL );
}

sub ForeignKeyDrop {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(LocalTableName Local ForeignTableName Foreign)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # create foreign key name
    my $ForeignKey = $Self->_ForeignKeyName(
        Name => "FK_$Param{LocalTableName}_$Param{Local}_$Param{Foreign}",
    );

    my $Shell = '';
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Database::ShellOutput') ) {
        $Shell = "/\n--";
    }

    # drop foreign key
    my $DropForeignKeySQL = <<"EOF";
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE $Param{LocalTableName} DROP CONSTRAINT $ForeignKey';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
$Shell
EOF

    # build index name
    my $IndexName = $Self->_IndexName(
        Name => 'FK_' . $Param{LocalTableName} . '_' . $Param{Local},
    );

    # build sql to drop index
    my $DropIndexSQL = <<"EOF";
BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX $IndexName';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
$Shell
EOF

    return ( $DropForeignKeySQL, $DropIndexSQL );
}

sub UniqueCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TableName Name Data)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my $Unique = $Self->_UniqueName(
        Name => $Param{Name},
    );

    my $CreateUniqueSQL = "ALTER TABLE $Param{TableName} ADD CONSTRAINT $Unique UNIQUE (";
    my @Array           = @{ $Param{Data} };
    my $Name            = '';
    for ( 0 .. $#Array ) {
        if ( $_ > 0 ) {
            $CreateUniqueSQL .= ', ';
        }
        $CreateUniqueSQL .= $Array[$_]->{Name};
        $Name            .= '_' . $Array[$_]->{Name};
    }
    $CreateUniqueSQL .= ')';

    my $Shell = '';
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Database::ShellOutput') ) {
        $Shell = "/\n--";
    }

    # build SQL to create unique constraint within a "try/catch block"
    # to prevent errors if unique constraint does already exist
    $CreateUniqueSQL = <<"EOF";
BEGIN
    EXECUTE IMMEDIATE '$CreateUniqueSQL';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
$Shell
EOF

    return ($CreateUniqueSQL);
}

sub UniqueDrop {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TableName Name)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my $Unique = $Self->_UniqueName(
        Name => $Param{Name},
    );

    my $DropUniqueSQL = "ALTER TABLE $Param{TableName} DROP CONSTRAINT $Unique";

    my $Shell = '';
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Database::ShellOutput') ) {
        $Shell = "/\n--";
    }

    # build SQL to drop unique constraint within a "try/catch block"
    # to prevent errors if unique constraint does not exist
    $DropUniqueSQL = <<"EOF";
BEGIN
    EXECUTE IMMEDIATE '$DropUniqueSQL';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
$Shell
EOF

    return ($DropUniqueSQL);
}

sub Insert {
    my ( $Self, @Param ) = @_;

    # get needed objects
    my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    my $SQL    = '';
    my @Keys   = ();
    my @Values = ();
    TAG:
    for my $Tag (@Param) {
        if ( $Tag->{Tag} eq 'Insert' && $Tag->{TagType} eq 'Start' ) {
            if ( $ConfigObject->Get('Database::ShellOutput') ) {
                $SQL .= $Self->{'DB::Comment'}
                    . "----------------------------------------------------------\n";
                $SQL .= $Self->{'DB::Comment'} . " insert into table $Tag->{Table}\n";
                $SQL .= $Self->{'DB::Comment'}
                    . "----------------------------------------------------------\n";
            }
            $SQL .= "INSERT INTO $Tag->{Table} ";
        }
        if ( $Tag->{Tag} eq 'Data' && $Tag->{TagType} eq 'Start' ) {

            # do not use auto increment values
            next TAG if $Tag->{Type} && $Tag->{Type} =~ m{ ^AutoIncrement$ }xmsi;

            $Tag->{Key} = ${ $Self->Quote( \$Tag->{Key} ) };
            push @Keys, $Tag->{Key};
            my $Value;
            if ( defined $Tag->{Value} ) {
                $Value = $Tag->{Value};
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => 'The content for inserts is not longer appreciated '
                        . 'attribut Value, use Content from now on! Reason: You can\'t '
                        . 'use new lines in attributes.',
                );
            }
            elsif ( defined $Tag->{Content} ) {
                $Value = $Tag->{Content};
            }
            else {
                $Value = '';
            }
            if ( $Tag->{Type} && $Tag->{Type} eq 'Quote' ) {
                $Value = "'" . ${ $Self->Quote( \$Value ) } . "'";
            }
            else {
                $Value = ${ $Self->Quote( \$Value ) };
            }
            push @Values, $Value;
        }
    }
    my $Key = '';
    for (@Keys) {
        if ( $Key ne '' ) {
            $Key .= ', ';
        }
        $Key .= $_;
    }
    my $Value = '';
    for my $Tmp (@Values) {
        if ( $Value ne '' ) {
            $Value .= ', ';
        }
        if ( $Tmp eq 'current_timestamp' ) {
            if ( $ConfigObject->Get('Database::ShellOutput') ) {
                $Value .= $Tmp;
            }
            else {
                my $Timestamp = $DateTimeObject->ToString();
                $Value .= '\'' . $Timestamp . '\'';
            }
        }
        else {
            $Value .= $Tmp;
        }
    }
    $SQL .= "($Key)\n    VALUES\n    ($Value)";
    return ($SQL);
}

sub _TypeTranslation {
    my ( $Self, $Tag ) = @_;

    # Type translation
    if ( $Tag->{Type} =~ /^DATE$/i ) {
        $Tag->{Type} = 'DATE';
    }
    elsif ( $Tag->{Type} =~ /^smallint$/i ) {
        $Tag->{Type} = 'NUMBER (5, 0)';
    }
    elsif ( $Tag->{Type} =~ /^integer$/i ) {
        $Tag->{Type} = 'NUMBER (12, 0)';
    }
    elsif ( $Tag->{Type} =~ /^bigint$/i ) {
        $Tag->{Type} = 'NUMBER (20, 0)';
    }
    elsif ( $Tag->{Type} =~ /^longblob$/i ) {
        $Tag->{Type} = 'CLOB';
    }
    elsif ( $Tag->{Type} =~ /^VARCHAR$/i ) {
        $Tag->{Type} = 'VARCHAR2 (' . $Tag->{Size} . ')';
        if ( $Tag->{Size} > 4000 ) {
            $Tag->{Type} = 'CLOB';
        }
    }
    elsif ( $Tag->{Type} =~ /^DECIMAL$/i ) {
        $Tag->{Type} = 'DECIMAL (' . $Tag->{Size} . ')';
    }
    return $Tag;
}

sub _SequenceName {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TableName} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TableName!",
        );
        return;
    }

    my $Sequence = 'SE_' . $Param{TableName};
    if ( length $Sequence > 28 ) {
        my $MD5 = $Kernel::OM->Get('Kernel::System::Main')->MD5sum(
            String => $Sequence,
        );
        $Sequence = substr $Sequence, 0, 26;
        $Sequence .= substr $MD5, 0,  1;
        $Sequence .= substr $MD5, 31, 1;
    }

    return $Sequence;
}

sub _ConstraintName {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TableName} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TableName!",
        );
        return;
    }

    my $Constraint = 'PK_' . $Param{TableName};
    if ( length $Constraint > 30 ) {
        my $MD5 = $Kernel::OM->Get('Kernel::System::Main')->MD5sum(
            String => $Constraint,
        );
        $Constraint = substr $Constraint, 0, 28;
        $Constraint .= substr $MD5, 0,  1;
        $Constraint .= substr $MD5, 31, 1;
    }

    return $Constraint;
}

sub _UniqueName {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Name!",
        );
        return;
    }

    my $Unique = $Param{Name};
    if ( length $Unique > 30 ) {
        my $MD5 = $Kernel::OM->Get('Kernel::System::Main')->MD5sum(
            String => $Unique,
        );
        $Unique = substr $Unique, 0, 28;
        $Unique .= substr $MD5, 0,  1;
        $Unique .= substr $MD5, 31, 1;
    }

    return $Unique;
}

sub _IndexName {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Name!",
        );
        return;
    }

    my $Index = $Param{Name};
    if ( length $Index > 30 ) {
        my $MD5 = $Kernel::OM->Get('Kernel::System::Main')->MD5sum(
            String => $Index,
        );
        $Index = substr $Index, 0, 28;
        $Index .= substr $MD5, 0,  1;
        $Index .= substr $MD5, 31, 1;
    }

    return $Index;
}

sub _ForeignKeyName {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Name!",
        );
        return;
    }

    my $ForeignKey = $Param{Name};
    if ( length($ForeignKey) > 30 ) {
        my $MD5 = $Kernel::OM->Get('Kernel::System::Main')->MD5sum(
            String => $ForeignKey,
        );
        $ForeignKey = substr $ForeignKey, 0, 28;
        $ForeignKey .= substr $MD5, 0,  1;
        $ForeignKey .= substr $MD5, 31, 1;
    }

    return $ForeignKey;
}

1;
