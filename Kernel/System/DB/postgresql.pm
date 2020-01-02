# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::DB::postgresql;

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
    $Self->{'DB::Limit'}       = 'limit';
    $Self->{'DB::DirectBlob'}  = 0;
    $Self->{'DB::QuoteSingle'} = '\'';

    #$Self->{'DB::QuoteBack'}            = '\\';
    $Self->{'DB::QuoteBack'} = '';

    #$Self->{'DB::QuoteSemicolon'}       = '\\';
    $Self->{'DB::QuoteSemicolon'} = '';

    #$Self->{'DB::QuoteUnderscoreStart'} = '\\\\';
    $Self->{'DB::QuoteUnderscoreStart'} = '\\';
    $Self->{'DB::QuoteUnderscoreEnd'}   = '';
    $Self->{'DB::CaseSensitive'}        = 1;
    $Self->{'DB::LikeEscapeString'}     = '';

    # how to determine server version
    # version string can contain a suffix, we only need what's on the left of it
    # example of full string: "PostgreSQL 9.2.4, compiled by Visual C++ build 1600, 64-bit"
    # another example: "PostgreSQL 9.1.9 on i686-pc-linux-gnu"
    # our results: "PostgreSQL 9.2.4", "PostgreSQL 9.1.9".
    $Self->{'DB::Version'} = "SELECT SUBSTRING(VERSION(), 'PostgreSQL [0-9\.]*')";

    $Self->{'DB::ListTables'} = <<'EOF';
SELECT
    table_name
FROM
    information_schema.tables
WHERE
    table_type = 'BASE TABLE'
    AND table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY table_name
EOF

    # dbi attributes
    $Self->{'DB::Attribute'} = {};

    # set current time stamp if different to "current_timestamp"
    $Self->{'DB::CurrentTimestamp'} = '';

    # set encoding of selected data to utf8
    $Self->{'DB::Encode'} = 0;

    # shell setting
    $Self->{'DB::Comment'}      = '-- ';
    $Self->{'DB::ShellCommit'}  = ';';
    $Self->{'DB::ShellConnect'} = 'SET standard_conforming_strings TO ON';

    # init sql setting on db connect
    $Self->{'DB::Connect'} = "SET standard_conforming_strings TO ON;\n SET datestyle TO 'iso';\n SET NAMES 'utf8';";
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

            # if $Text contains only backslashes, add a % at the end.
            # newer versions of postgres do not allow an escape character (backslash)
            # at the end of a pattern: "LIKE pattern must not end with escape character"
            ${$Text} =~ s{ \A ( \\+ ) \z }{$1%}xms;

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

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

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
        if (
            ( $Tag->{Tag} eq 'Table' || $Tag->{Tag} eq 'TableCreate' )
            && $Tag->{TagType} eq 'Start'
            )
        {
            $SQLStart .= "CREATE TABLE $Tag->{Name} (\n";
            $TableName = $Tag->{Name};
        }
        if (
            ( $Tag->{Tag} eq 'Table' || $Tag->{Tag} eq 'TableCreate' )
            && $Tag->{TagType} eq 'End'
            )
        {
            $SQLEnd .= ")";
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

        # auto increment
        if ( $Tag->{AutoIncrement} && $Tag->{AutoIncrement} =~ /^true$/i ) {
            $SQL = "    $Tag->{Name} serial";
            if ( $Tag->{Type} =~ /^bigint$/i ) {
                $SQL = "    $Tag->{Name} bigserial";
            }
        }

        # normal data type
        else {
            $SQL .= "    $Tag->{Name} $Tag->{Type}";
        }

        # handle default
        if ( defined $Tag->{Default} ) {
            if ( $Tag->{Type} =~ /int/i ) {
                $SQL .= " DEFAULT " . $Tag->{Default};
            }
            else {
                $SQL .= " DEFAULT '" . $Tag->{Default} . "'";
            }
        }

        # handle require
        if ( $Tag->{Required} && lc $Tag->{Required} eq 'true' ) {
            $SQL .= ' NOT NULL';
        }
        else {
            $SQL .= ' NULL';
        }

        # add primary key
        if ( $Tag->{PrimaryKey} && $Tag->{PrimaryKey} =~ /true/i ) {
            $PrimaryKey = "    PRIMARY KEY($Tag->{Name})";
        }
    }

    # add primary key
    if ($PrimaryKey) {
        if ($SQL) {
            $SQL .= ",\n";
        }
        $SQL .= $PrimaryKey;
    }

    # add uniq
    for my $Name ( sort keys %Uniq ) {
        if ($SQL) {
            $SQL .= ",\n";
        }
        $SQL .= "    CONSTRAINT $Name UNIQUE (";
        my @Array = @{ $Uniq{$Name} };
        for ( 0 .. $#Array ) {
            if ( $_ > 0 ) {
                $SQL .= ", ";
            }
            $SQL .= $Array[$_]->{Name};
        }
        $SQL .= ")";
    }
    $SQL .= "\n";
    push @Return, $SQLStart . $SQL . $SQLEnd;

    # add indexes
    for my $Name ( sort keys %Index ) {
        push @Return,
            $Self->IndexCreate(
            TableName => $TableName,
            Name      => $Name,
            Data      => $Index{$Name},
            );
    }

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
        $SQL .= "DROP TABLE $Tag->{Name}";
        return ($SQL);
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

    # put two literal dollar characters in a string
    # this is needed for the postgres 'do' statement
    my $DollarDollar = '$$';

    TAG:
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

                # PostgreSQL uses sequences for primary key value generation. These are global
                #   entities and not renamed when tables are renamed. Rename them also to keep
                #   them consistent with new systems.
                push @SQL, $SQLStart . "ALTER TABLE $Tag->{NameOld} RENAME TO $Tag->{NameNew}";

                my $OldSequence = $Self->_SequenceName(
                    TableName => $Tag->{NameOld},
                );

                my $NewSequence = $Self->_SequenceName(
                    TableName => $Tag->{NameNew},
                );

                # Build SQL to rename sequence (only if a sequence exists).
                my $RenameSequenceSQL = <<"EOF";
DO $DollarDollar
BEGIN
IF EXISTS (
    SELECT 1
    FROM pg_class
    WHERE relkind = 'S' and relname = '$OldSequence'
    ) THEN
    ALTER SEQUENCE $OldSequence RENAME TO $NewSequence;
    END IF;
END$DollarDollar;
EOF

                push @SQL, $SQLStart . $RenameSequenceSQL;

            }
            $SQLStart .= "ALTER TABLE $Table";
        }
        elsif ( $Tag->{Tag} eq 'ColumnAdd' && $Tag->{TagType} eq 'Start' ) {

            # Type translation
            $Tag = $Self->_TypeTranslation($Tag);

            # auto increment
            if ( $Tag->{AutoIncrement} && $Tag->{AutoIncrement} =~ /^true$/i ) {

                my $PseudoType = 'serial';
                if ( $Tag->{Type} =~ /^bigint$/i ) {
                    $PseudoType = 'bigserial';
                }
                push @SQL, $SQLStart . " ADD $Tag->{Name} $PseudoType NOT NULL";
                next TAG;
            }

            # normal data type
            push @SQL, $SQLStart . " ADD $Tag->{Name} $Tag->{Type} NULL";

            # investigate the default value
            my $Default = '';
            if ( $Tag->{Type} =~ /int/i ) {
                $Default = defined $Tag->{Default} ? $Tag->{Default} : 0;
            }
            else {
                $Default = defined $Tag->{Default} ? "'$Tag->{Default}'" : "''";
            }

            # investigate the require
            my $Required = ( $Tag->{Required} && lc $Tag->{Required} eq 'true' ) ? 1 : 0;

            # handle default and require
            if ( $Required || defined $Tag->{Default} ) {

                # fill up empty rows
                push @SQL, "UPDATE $Table SET $Tag->{Name} = $Default WHERE $Tag->{Name} IS NULL";

                # add default
                if ( defined $Tag->{Default} ) {
                    push @SQL, "ALTER TABLE $Table ALTER $Tag->{Name} SET DEFAULT $Default";
                }

                # add require
                if ($Required) {
                    push @SQL, "ALTER TABLE $Table ALTER $Tag->{Name} SET NOT NULL";
                }
            }
        }
        elsif ( $Tag->{Tag} eq 'ColumnChange' && $Tag->{TagType} eq 'Start' ) {

            # Type translation
            $Tag = $Self->_TypeTranslation($Tag);

            # normal data type
            if ( $Tag->{NameOld} ne $Tag->{NameNew} ) {
                push @SQL, $SQLStart . " RENAME $Tag->{NameOld} TO $Tag->{NameNew}";
            }
            push @SQL, $SQLStart . " ALTER $Tag->{NameNew} TYPE $Tag->{Type}";

            # if there is an AutoIncrement column no other changes are needed
            next TAG if $Tag->{AutoIncrement} && $Tag->{AutoIncrement} =~ /^true$/i;

            # set default as null
            push @SQL, "ALTER TABLE $Table ALTER $Tag->{NameNew} DROP NOT NULL";

            # investigate the default value
            my $Default = '';
            if ( $Tag->{Type} =~ /int/i ) {
                $Default = defined $Tag->{Default} ? $Tag->{Default} : 0;
            }
            else {
                $Default = defined $Tag->{Default} ? "'$Tag->{Default}'" : "''";
            }

            # investigate the require
            my $Required = ( $Tag->{Required} && lc $Tag->{Required} eq 'true' ) ? 1 : 0;

            # handle default and require
            if ( $Required || defined $Tag->{Default} ) {

                # fill up empty rows
                push @SQL,
                    "UPDATE $Table SET $Tag->{NameNew} = $Default WHERE $Tag->{NameNew} IS NULL";

                # add default
                if ( defined $Tag->{Default} ) {
                    push @SQL, "ALTER TABLE $Table ALTER $Tag->{NameNew} SET DEFAULT $Default";
                }

                # add require
                if ($Required) {
                    push @SQL, "ALTER TABLE $Table ALTER $Tag->{NameNew} SET NOT NULL";
                }
            }
        }
        elsif ( $Tag->{Tag} eq 'ColumnDrop' && $Tag->{TagType} eq 'Start' ) {
            my $SQLEnd = $SQLStart . " DROP $Tag->{Name}";
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
    my $CreateIndexSQL = "CREATE INDEX $Param{Name} ON $Param{TableName} (";
    my @Array          = @{ $Param{Data} };
    for ( 0 .. $#Array ) {
        if ( $_ > 0 ) {
            $CreateIndexSQL .= ', ';
        }
        $CreateIndexSQL .= $Array[$_]->{Name};
    }
    $CreateIndexSQL .= ')';

    # put two literal dollar characters in a string
    # this is needed for the postgres 'do' statement
    my $DollarDollar = '$$';

    # build SQL to create index within a "try/catch block"
    # to prevent errors if index exists already
    $CreateIndexSQL = <<"EOF";
DO $DollarDollar
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('$Param{Name}')
    ) THEN
    $CreateIndexSQL;
END IF;
END$DollarDollar;
EOF

    # return SQL
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
    my $DropIndexSQL = 'DROP INDEX ' . $Param{Name};

    # put two literal dollar characters in a string
    # this is needed for the postgres 'do' statement
    my $DollarDollar = '$$';

    # build SQL to drop index within a "try/catch block"
    # to prevent errors if index does not exist
    $DropIndexSQL = <<"EOF";
DO $DollarDollar
BEGIN
IF EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('$Param{Name}')
    ) THEN
    $DropIndexSQL;
END IF;
END$DollarDollar;
EOF

    # return SQL
    return ($DropIndexSQL);

}

sub ForeignKeyCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(LocalTableName Local ForeignTableName Foreign)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # create foreign key name
    my $ForeignKey = "FK_$Param{LocalTableName}_$Param{Local}_$Param{Foreign}";
    if ( length($ForeignKey) > 60 ) {
        my $MD5 = $Kernel::OM->Get('Kernel::System::Main')->MD5sum(
            String => $ForeignKey,
        );
        $ForeignKey = substr $ForeignKey, 0, 58;
        $ForeignKey .= substr $MD5, 0,  1;
        $ForeignKey .= substr $MD5, 31, 1;
    }

    # add foreign key
    my $CreateForeignKeySQL = "ALTER TABLE $Param{LocalTableName} ADD CONSTRAINT $ForeignKey FOREIGN KEY "
        . "($Param{Local}) REFERENCES $Param{ForeignTableName} ($Param{Foreign})";

    # put two literal dollar characters in a string
    # this is needed for the postgres 'do' statement
    my $DollarDollar = '$$';

    # build SQL to create foreign key within a "try/catch block"
    # to prevent errors if foreign key exists already
    $CreateForeignKeySQL = <<"EOF";
DO $DollarDollar
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('$ForeignKey')
    ) THEN
    $CreateForeignKeySQL;
END IF;
END$DollarDollar;
EOF

    # return SQL
    return ($CreateForeignKeySQL);
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
    my $ForeignKey = "FK_$Param{LocalTableName}_$Param{Local}_$Param{Foreign}";
    if ( length($ForeignKey) > 60 ) {
        my $MD5 = $Kernel::OM->Get('Kernel::System::Main')->MD5sum(
            String => $ForeignKey,
        );
        $ForeignKey = substr $ForeignKey, 0, 58;
        $ForeignKey .= substr $MD5, 0,  1;
        $ForeignKey .= substr $MD5, 31, 1;
    }

    # drop foreign key
    my $DropForeignKeySQL = "ALTER TABLE $Param{LocalTableName} DROP CONSTRAINT $ForeignKey";

    # put two literal dollar characters in a string
    # this is needed for the postgres 'do' statement
    my $DollarDollar = '$$';

    # build SQL to drop foreign key within a "try/catch block"
    # to prevent errors if foreign key does not exist
    $DropForeignKeySQL = <<"EOF";
DO $DollarDollar
BEGIN
IF EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('$ForeignKey')
    ) THEN
    $DropForeignKeySQL;
END IF;
END$DollarDollar;
EOF

    # return SQL
    return ($DropForeignKeySQL);
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
    my $CreateUniqueSQL = "ALTER TABLE $Param{TableName} ADD CONSTRAINT $Param{Name} UNIQUE (";
    my @Array           = @{ $Param{Data} };
    for ( 0 .. $#Array ) {
        if ( $_ > 0 ) {
            $CreateUniqueSQL .= ', ';
        }
        $CreateUniqueSQL .= $Array[$_]->{Name};
    }
    $CreateUniqueSQL .= ')';

    # put two literal dollar characters in a string
    # this is needed for the postgres 'do' statement
    my $DollarDollar = '$$';

    # build SQL to create unique constraint within a "try/catch block"
    # to prevent errors if unique constraint does already exist
    $CreateUniqueSQL = <<"EOF";
DO $DollarDollar
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('$Param{Name}')
    ) THEN
    $CreateUniqueSQL;
END IF;
END$DollarDollar;
EOF

    # return SQL
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
    my $DropUniqueSQL = "ALTER TABLE $Param{TableName} DROP CONSTRAINT $Param{Name}";

    # put two literal dollar characters in a string
    # this is needed for the postgres 'do' statement
    my $DollarDollar = '$$';

    # build SQL to drop unique constraint within a "try/catch block"
    # to prevent errors if unique constraint does not exist
    $DropUniqueSQL = <<"EOF";
DO $DollarDollar
BEGIN
IF EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('$Param{Name}')
    ) THEN
    $DropUniqueSQL;
END IF;
END$DollarDollar;
EOF

    # return SQL
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

            # do not use auto increment values, in other cases use something like
            # SELECT setval('table_id_seq', (SELECT max(id) FROM table));
            if ( $Tag->{Type} && $Tag->{Type} =~ /^AutoIncrement$/i ) {
                next TAG;
            }
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

    # type translation
    if ( $Tag->{Type} =~ /^DATE$/i ) {
        $Tag->{Type} = 'timestamp(0)';
    }

    # performance option
    elsif ( $Tag->{Type} =~ /^longblob$/i ) {
        $Tag->{Type} = 'TEXT';
    }
    elsif ( $Tag->{Type} =~ /^VARCHAR$/i ) {
        $Tag->{Type} = 'VARCHAR (' . $Tag->{Size} . ')';
        if ( $Tag->{Size} >= 10000 ) {
            $Tag->{Type} = 'VARCHAR';
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

    my $Sequence = $Param{TableName} . '_id_seq';

    return $Sequence;
}

1;
