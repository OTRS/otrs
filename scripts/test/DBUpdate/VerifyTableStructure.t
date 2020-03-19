# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));
use Kernel::System::VariableCheck qw(:all);

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# Initialize test database based on fresh OTRS 6 schema.
my $Success = $Helper->ProvideTestDatabase(
    DatabaseXMLFiles => [
        "$Home/scripts/database/otrs-schema.xml",
        "$Home/scripts/database/otrs-initial_insert.xml",
    ],
);
if ( !$Success ) {
    $Self->False(
        0,
        'Test database could not be provided, skipping test',
    );
    return 1;
}
$Self->True(
    $Success,
    'ProvideTestDatabase - Load and execute OTRS 6 XML files',
);

# Retrieve table structure and store it in a lookup structure for easier comparison.
my $TableStructureGet = sub {
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my @Tables   = $DBObject->ListTables();

    my %TableStructure;

    for my $Table ( sort @Tables ) {

        # MySQL supports a nifty feature for getting table creation statement.
        #   We just dissect it and store it for later.
        if ( $DBObject->{'DB::Type'} eq 'mysql' ) {
            $DBObject->Prepare(
                SQL => "SHOW CREATE TABLE $Table",
            );
            while ( my @Row = $DBObject->FetchrowArray() ) {
                my $CreateTable = $Row[1];

                # Extract field and key information.
                $CreateTable =~ s/^.*?\((.*)\).*?$/$1/ms;

                # Split lines by comma and new line.
                my @Lines = split ",\n", $CreateTable;

                for my $Line (@Lines) {

                    # Remove leading and trailing spaces.
                    $Line =~ s/^\s+//;
                    $Line =~ s/\s+$//;

                    my @Field = split ' ', $Line;

                    # PRIMARY KEY
                    if ( $Field[0] eq 'PRIMARY' && $Field[1] eq 'KEY' ) {
                        $TableStructure{$Table}->{PrimaryKey} = $Line;
                    }

                    # UNIQUE KEY
                    elsif ( $Field[0] eq 'UNIQUE' && $Field[1] eq 'KEY' ) {
                        $Field[2] =~ s/`//g;
                        $TableStructure{$Table}->{UniqueKeys}->{ $Field[2] } = $Line;
                    }

                    # KEY
                    elsif ( $Field[0] eq 'KEY' ) {
                        $Field[1] =~ s/`//g;
                        $TableStructure{$Table}->{Keys}->{ $Field[1] } = $Line;
                    }

                    # CONSTRAINT
                    elsif ( $Field[0] eq 'CONSTRAINT' ) {
                        $Field[1] =~ s/`//g;
                        $TableStructure{$Table}->{Constraints}->{ $Field[1] } = $Line;
                    }

                    # Field
                    else {
                        $Field[0] =~ s/`//g;
                        $TableStructure{$Table}->{Fields}->{ $Field[0] } = $Line;
                    }
                }
            }
        }

        # PostgreSQL does not have direct command for table structure,
        #   so we are instead querying table of internal storage driver.
        #   Taken from here: https://stackoverflow.com/a/118245
        elsif ( $DBObject->{'DB::Type'} eq 'postgresql' ) {
            $DBObject->Prepare(
                SQL => "
                    SELECT
                        f.attnum AS number,
                        f.attname AS name,
                        f.attnum,
                        f.attnotnull AS notnull,
                        pg_catalog.format_type(f.atttypid,f.atttypmod) AS type,
                        CASE
                            WHEN p.contype = 'p' THEN 't'
                            ELSE 'f'
                        END AS primarykey,
                        CASE
                            WHEN p.contype = 'u' THEN 't'
                            ELSE 'f'
                        END AS uniquekey,
                        CASE
                            WHEN p.contype = 'f' THEN g.relname
                        END AS foreignkey,
                        CASE
                            WHEN p.contype = 'f' THEN p.confkey
                        END AS foreignkey_fieldnum,
                        CASE
                            WHEN p.contype = 'f' THEN g.relname
                        END AS foreignkey,
                        CASE
                            WHEN p.contype = 'f' THEN p.conkey
                        END AS foreignkey_connnum,
                        CASE
                            WHEN f.atthasdef = 't' THEN pg_get_expr(d.adbin, d.adrelid)
                        END AS default
                    FROM pg_attribute f
                        JOIN pg_class c ON c.oid = f.attrelid
                        JOIN pg_type t ON t.oid = f.atttypid
                        LEFT JOIN pg_attrdef d ON d.adrelid = c.oid AND d.adnum = f.attnum
                        LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
                        LEFT JOIN pg_constraint p ON p.conrelid = c.oid AND f.attnum = ANY (p.conkey)
                        LEFT JOIN pg_class AS g ON p.confrelid = g.oid
                    WHERE c.relkind = 'r'::char
                        AND c.relname = ?
                        AND f.attnum > 0 ORDER BY number
                    ",
                Bind => [ \$Table ],
            );

            while ( my @Row = $DBObject->FetchrowArray() ) {
                my @Names = $DBObject->GetColumnNames();
                my $Field = $Row[1];

                my $Default = $Row[11];
                if ( $Default && $Default =~ /^nextval/ ) {
                    $Default = 'auto_increment';
                }

                $TableStructure{$Table}->{Fields}->{$Field} = {
                    Name    => $Field,
                    NotNull => $Row[3],
                    Type    => $Row[4],
                    Default => $Default,
                };

                # Command above will sometime duplicate the output when fields have indices defined
                #   and this could result in multiple rows per field. Therefore, we create a lookup
                #   hash which can be easily extended with each iteration.
                #
                #   number | name  | attnum | notnull | type   | primarykey | uniquekey | foreignkey
                #  ----------------------------------------------------------------------------------
                #        1 | field |      1 | t       | bigint | t          | f         |               # primary key
                #        1 | field |      1 | t       | bigint | f          | t         |               # unique key
                #        1 | field |      1 | t       | bigint | f          | f         | rel_field     # foreign key
                if (
                    $Row[5] && $Row[5] eq 't'
                    && $Row[6] && $Row[6] eq 'f'
                    )
                {
                    $TableStructure{$Table}->{PrimaryKey}->{$Field} = 1;
                }

                elsif (
                    $Row[5] && $Row[5] eq 'f'
                    && $Row[6] && $Row[6] eq 't'
                    )
                {
                    $TableStructure{$Table}->{UniqueKeys}->{$Field} = 1;
                }

                elsif (
                    $Row[5] && $Row[5] eq 'f'
                    && $Row[6] && $Row[6] eq 'f'
                    && ( $Row[7] || $Row[9] )    # could be either one?!
                    )
                {
                    $TableStructure{$Table}->{Constraints}->{$Field} = $Row[7] || $Row[9];
                }
            }
        }

        # Oracle needs two queries for different kind of information:
        #   - Fields
        #   - Constraints
        elsif ( $DBObject->{'DB::Type'} eq 'oracle' ) {
            $DBObject->Prepare(
                SQL => '
                    SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, NULLABLE
                    FROM ALL_TAB_COLUMNS
                    WHERE OWNER = ? AND TABLE_NAME = ?
                ',
                Bind => [ \uc( $DBObject->{USER} ), \uc($Table) ],
            );

            while ( my @Row = $DBObject->FetchrowArray() ) {
                COLUMN:
                for my $Value (@Row) {
                    next COLUMN if !defined $Value;
                    $TableStructure{$Table}->{Fields}->{ $Row[0] } .= $Value . ' ';
                }
            }

            $DBObject->Prepare(
                SQL => '
                    SELECT CONSTRAINT_NAME, SEARCH_CONDITION, R_OWNER, R_CONSTRAINT_NAME, STATUS
                    FROM USER_CONSTRAINTS
                    WHERE TABLE_NAME = ?
                ',
                Bind => [ \uc($Table) ],
            );

            while ( my @Row = $DBObject->FetchrowArray() ) {
                my $Key = $Row[0];

                # Some constraints have randomly generated names, so we use different field.
                if ( $Key =~ /^SYS_C[0-9]+/ ) {
                    $Key = $Row[1];
                }

                my $Index = 0;

                COLUMN:
                for my $Value (@Row) {
                    next COLUMN if !$Index++;
                    next COLUMN if !defined $Value;
                    $TableStructure{$Table}->{Constraints}->{$Key} .= $Value . ' ';
                }
            }
        }
    }

    return \%TableStructure;
};

my $StructureFresh = $TableStructureGet->();
$Self->True(
    IsHashRefWithData($StructureFresh),
    'Get structure for all tables in database',
);

# Re-initialize test database based on fresh OTRS 5 schema.
$Success = $Helper->ProvideTestDatabase(
    DatabaseXMLFiles => [
        "$Home/scripts/test/sample/DBUpdate/otrs5-schema.xml",
        "$Home/scripts/test/sample/DBUpdate/otrs5-initial_insert.xml",
    ],
);
$Self->True(
    $Success,
    'ProvideTestDatabase - Load and execute OTRS 5 XML files',
);

my $DBUpdateTo6Object = $Kernel::OM->Get('scripts::DBUpdateTo6');

# Run DB update script.
$Success = $DBUpdateTo6Object->Run(
    CommandlineOptions => {
        NonInteractive => 1,
    },
);
$Self->Is(
    $Success,
    1,
    'DBUpdateTo6 ran without problems',
);

my $StructureMigrated = $TableStructureGet->();
$Self->True(
    IsHashRefWithData($StructureMigrated),
    'Get structure for all tables in database',
);

# Finally, compare two structures.
for my $Table ( sort keys %{$StructureFresh} ) {
    $Self->IsDeeply(
        $StructureMigrated->{$Table},
        $StructureFresh->{$Table},
        "Structure for table '$Table', direction A",
    );
}

# Make sure to do it in both directions.
for my $Table ( sort keys %{$StructureMigrated} ) {
    $Self->IsDeeply(
        $StructureMigrated->{$Table},
        $StructureFresh->{$Table},
        "Structure for table '$Table', direction B",
    );
}

# Cleanup is done by TestDatabaseCleanup().

1;
