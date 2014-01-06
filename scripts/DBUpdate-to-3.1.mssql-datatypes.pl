#!/usr/bin/perl -w
# --
# DBUpdate-to-3.1.mssql-datatypes.pl - update script to migrate data types in the MS-SQL database
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: DBUpdate-to-3.1.mssql-datatypes.pl,v 1.2 2011-11-17 18:02:23 mb Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

use Getopt::Std qw();
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Encode;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::State;
use Kernel::System::SysConfig;
use Kernel::System::XML;
use Kernel::System::DynamicField;
use Kernel::System::Cache;

{

    # get options
    my %Opts;
    Getopt::Std::getopt( 'h', \%Opts );

    if ( exists $Opts{h} ) {
        print <<"EOF";

DBUpdate-to-3.1.mssql-datatypes.pl <Revision $VERSION> - Data type migration script for MS SQL Server databases
Copyright (C) 2001-2011 OTRS AG, http://otrs.org/

EOF
        exit 1;
    }

    print "\nMigration started...\n\n";

    # create common objects
    my $CommonObject = _CommonObjectsBase();

    print "Step 1 of 2: Checking database type... ";
    my $DBType = $CommonObject->{ConfigObject}->Get('Database::Type') || '';
    if ( $DBType ne 'mssql' ) {
        print "This migration script is only needed when you use Microsoft SQL Server.\n";
        print "You are using $DBType. This script is not needed, stopping now.\n\n";
        exit 0;
    }
    else {
        print "OK!\n";
    }

    # do actual upgrade
    print "Step 2 of 2: Creating Upgrade Files... \n\n";
    _DatabaseUpgrade($CommonObject);
    print "done.\n\n";

    print "Now run the generated files in order to complete the data type migration.\n";

    exit 0;
}

sub _CommonObjectsBase {
    my %CommonObject;
    $CommonObject{ConfigObject} = Kernel::Config->new();
    $CommonObject{LogObject}    = Kernel::System::Log->new(
        LogPrefix => 'OTRS-DBUpdate-to-3.1',
        %CommonObject,
    );
    $CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
    $CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
    $CommonObject{TimeObject}   = Kernel::System::Time->new(%CommonObject);
    $CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
    $CommonObject{XMLObject}    = Kernel::System::XML->new(%CommonObject);
    return \%CommonObject;
}

=item _DatabaseUpgrade()

Migrate all fields of type VARCHAR and TEXT to NVARCHAR().

    _DatabaseUpgrade();

=cut

sub _DatabaseUpgrade {
    my $CommonObject = shift;
    my @DropStatements;
    my @UpgradeStatements;
    my @CreateStatements;

    # select all indexes that need to be removed
    my $IndexSQL = "SELECT i.name, tao.name, icc.name"
        . " FROM sys.indexes AS i"
        . " INNER JOIN sys.objects AS tao ON i.object_id = tao.object_id"
        . " INNER JOIN sys.index_columns AS ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id"
        . " INNER JOIN sys.columns AS icc ON ic.column_id = icc.column_id AND ic.object_id = icc.object_id"
        . " INNER JOIN information_schema.columns on table_name = tao.name AND column_name = icc.name"
        . " WHERE data_type = 'TEXT' OR data_type = 'VARCHAR'"
        . " AND i.is_unique_constraint = 0"
        . " AND i.type = 2"
        ;

    return if !$CommonObject->{DBObject}->Prepare( SQL => $IndexSQL );
    my %Indexes;
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
        $Indexes{ $Row[0] }->{Table} = $Row[1];
        my @IndexColumns;
        @IndexColumns = @{ $Indexes{ $Row[0] }->{Columns} } if $Indexes{ $Row[0] }->{Columns};
        push( @IndexColumns, $Row[2] );
        $Indexes{ $Row[0] }->{Columns} = \@IndexColumns;
    }

    for my $Index ( keys %Indexes ) {
        print "Processing index $Index...\n";
        push @DropStatements, "DROP INDEX $Index ON $Indexes{$Index}->{Table};";

        my $Columns = join( ', ', @{ $Indexes{$Index}->{Columns} } );
        push @CreateStatements, "CREATE INDEX $Index ON $Indexes{$Index}->{Table}($Columns);";
    }

    # select all primary key constraints that need to be removed
    my $PKSQL = "SELECT i.name, tao.name, icc.name"
        . " FROM sys.indexes AS i"
        . " INNER JOIN sys.objects AS tao ON i.object_id = tao.object_id"
        . " INNER JOIN sys.index_columns AS ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id"
        . " INNER JOIN sys.columns AS icc ON ic.column_id = icc.column_id AND ic.object_id = icc.object_id"
        . " INNER JOIN information_schema.columns on table_name = tao.name AND column_name = icc.name"
        . " WHERE data_type = 'TEXT' OR data_type = 'VARCHAR'"
        . " AND is_unique_constraint = 0"
        . " AND i.type = 1"
        ;

    return if !$CommonObject->{DBObject}->Prepare( SQL => $PKSQL );
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
        push @DropStatements,   "ALTER TABLE $Row[1] DROP CONSTRAINT $Row[0];";
        push @CreateStatements, "ALTER TABLE $Row[1] ADD CONSTRAINT $Row[0] PRIMARY KEY ($Row[2]);";
    }

    # select all unique constraints that need to be removed
    my $UCSQL = "SELECT i.name, tao.name, icc.name"
        . " FROM sys.indexes AS i"
        . " INNER JOIN sys.objects AS tao ON i.object_id = tao.object_id"
        . " INNER JOIN sys.index_columns AS ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id"
        . " INNER JOIN sys.columns AS icc ON ic.column_id = icc.column_id AND ic.object_id = icc.object_id"
        . " INNER JOIN information_schema.columns on table_name = tao.name AND column_name = icc.name"
        . " WHERE data_type = 'TEXT' OR data_type = 'VARCHAR'"
        . " AND is_unique_constraint = 1"
        ;

    return if !$CommonObject->{DBObject}->Prepare( SQL => $UCSQL );
    my %UniqueConstraints;
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
        $UniqueConstraints{ $Row[0] }->{Table} = $Row[1];
        my @IndexColumns;
        @IndexColumns = @{ $UniqueConstraints{ $Row[0] }->{Columns} }
            if $UniqueConstraints{ $Row[0] }->{Columns};
        push( @IndexColumns, $Row[2] );
        $UniqueConstraints{ $Row[0] }->{Columns} = \@IndexColumns;
    }

    for my $UniqueConstraint ( keys %UniqueConstraints ) {
        print "Processing unique constraint $UniqueConstraint...\n";
        push @DropStatements,
            "ALTER TABLE $UniqueConstraints{$UniqueConstraint}->{Table} DROP CONSTRAINT $UniqueConstraint;";

        my $Columns = join( ', ', @{ $UniqueConstraints{$UniqueConstraint}->{Columns} } );
        push @CreateStatements,
            "ALTER TABLE $UniqueConstraints{$UniqueConstraint}->{Table} ADD CONSTRAINT $UniqueConstraint UNIQUE ($Columns);";
    }

    # create ALTER TABLE statements for all fields that need to be updated
    my $SQL = "SELECT table_name, column_name, data_type,"
        . " character_maximum_length, is_nullable"
        . " FROM information_schema.columns"
        . " WHERE data_type = 'TEXT' OR data_type = 'VARCHAR'";

    return if !$CommonObject->{DBObject}->Prepare( SQL => $SQL );
    my @Columns;
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {
        push @Columns, {
            'Table'    => $Row[0],
            'Column'   => $Row[1],
            'DataType' => $Row[2],
            'Size'     => $Row[3],
            'Null'     => $Row[4],
            }
    }
    for my $Column (@Columns) {
        if ( $Column->{Null} eq 'YES' ) {
            $Column->{Nullable} = 'NULL';
        }
        else {
            $Column->{Nullable} = 'NOT NULL';
        }

        if ( $Column->{DataType} eq 'TEXT' || $Column->{Size} > 4000 ) {
            $Column->{Size} = 'MAX';
        }
        push @UpgradeStatements,
            "ALTER TABLE $Column->{Table} ALTER COLUMN $Column->{Column} NVARCHAR($Column->{Size}) $Column->{Nullable};";
    }

    _CreateFile(
        $CommonObject,
        Name => 'mssql-datatype-upgrade-step1.sql',
        Data => \@DropStatements
    );
    _CreateFile(
        $CommonObject,
        Name => 'mssql-datatype-upgrade-step2.sql',
        Data => \@UpgradeStatements
    );
    _CreateFile(
        $CommonObject,
        Name => 'mssql-datatype-upgrade-step3.sql',
        Data => \@CreateStatements
    );

    return 1;
}

=item _CreateFile()

Create files in the Database Update directory with the SQL Commands for this database.

    _CreateFile($CommonObject,
        Name     => 'Foo',    # name of the file
        Content  => $Content, # array ref to content
    );

=cut

sub _CreateFile {
    my ( $CommonObject, %Param ) = @_;

    my $Location = $CommonObject->{ConfigObject}->Get('Home') . '/scripts/database/update';
    my $Content = join( "\n", @{ $Param{Data} } );

    my $File = $CommonObject->{MainObject}->FileWrite(
        Directory  => $Location,
        Filename   => $Param{Name},
        Content    => \$Content,
        Mode       => 'utf8',
        Type       => 'Local',
        Permission => '644',
    );
    print "File $Param{Name} created in $Location.\n";
    return 1;
}
1;
