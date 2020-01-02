# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::DB;
## nofilter(TidyAll::Plugin::OTRS::Perl::Pod::FunctionPod)

use strict;
use warnings;

use DBI;
use List::Util();

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::DateTime',
    'Kernel::System::Storable',
);

our $UseSlaveDB = 0;

=head1 NAME

Kernel::System::DB - global database interface

=head1 DESCRIPTION

All database functions to connect/insert/update/delete/... to a database.

=head1 PUBLIC INTERFACE

=head2 new()

create database object, with database connect..
Usually you do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::DB' => {
            # if you don't supply the following parameters, the ones found in
            # Kernel/Config.pm are used instead:
            DatabaseDSN  => 'DBI:odbc:database=123;host=localhost;',
            DatabaseUser => 'user',
            DatabasePw   => 'somepass',
            Type         => 'mysql',
            Attribute => {
                LongTruncOk => 1,
                LongReadLen => 100*1024,
            },
        },
    );
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # 0=off; 1=updates; 2=+selects; 3=+Connects;
    $Self->{Debug} = $Param{Debug} || 0;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Get config data in following order of significance:
    #   1 - Parameters passed to constructor
    #   2 - Test database configuration
    #   3 - Main database configuration
    $Self->{DSN} =
        $Param{DatabaseDSN} || $ConfigObject->Get('TestDatabaseDSN') || $ConfigObject->Get('DatabaseDSN');
    $Self->{USER} =
        $Param{DatabaseUser} || $ConfigObject->Get('TestDatabaseUser') || $ConfigObject->Get('DatabaseUser');
    $Self->{PW} =
        $Param{DatabasePw} || $ConfigObject->Get('TestDatabasePw') || $ConfigObject->Get('DatabasePw');

    $Self->{IsSlaveDB} = $Param{IsSlaveDB};

    $Self->{SlowLog} = $Param{'Database::SlowLog'}
        || $ConfigObject->Get('Database::SlowLog');

    # decrypt pw (if needed)
    if ( $Self->{PW} =~ /^\{(.*)\}$/ ) {
        $Self->{PW} = $Self->_Decrypt($1);
    }

    # get database type (auto detection)
    if ( $Self->{DSN} =~ /:mysql/i ) {
        $Self->{'DB::Type'} = 'mysql';
    }
    elsif ( $Self->{DSN} =~ /:pg/i ) {
        $Self->{'DB::Type'} = 'postgresql';
    }
    elsif ( $Self->{DSN} =~ /:oracle/i ) {
        $Self->{'DB::Type'} = 'oracle';
    }
    elsif ( $Self->{DSN} =~ /:db2/i ) {
        $Self->{'DB::Type'} = 'db2';
    }
    elsif ( $Self->{DSN} =~ /(mssql|sybase|sql server)/i ) {
        $Self->{'DB::Type'} = 'mssql';
    }

    # get database type (config option)
    if ( $ConfigObject->Get('Database::Type') ) {
        $Self->{'DB::Type'} = $ConfigObject->Get('Database::Type');
    }

    # get database type (overwrite with params)
    if ( $Param{Type} ) {
        $Self->{'DB::Type'} = $Param{Type};
    }

    # load backend module
    if ( $Self->{'DB::Type'} ) {
        my $GenericModule = 'Kernel::System::DB::' . $Self->{'DB::Type'};
        return if !$Kernel::OM->Get('Kernel::System::Main')->Require($GenericModule);
        $Self->{Backend} = $GenericModule->new( %{$Self} );

        # set database functions
        $Self->{Backend}->LoadPreferences();
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'Error',
            Message  => 'Unknown database type! Set option Database::Type in '
                . 'Kernel/Config.pm to (mysql|postgresql|oracle|db2|mssql).',
        );
        return;
    }

    # check/get extra database configuration options
    # (overwrite auto-detection with config options)
    for my $Setting (
        qw(
        Type Limit DirectBlob Attribute QuoteSingle QuoteBack
        Connect Encode CaseSensitive LcaseLikeInLargeText
        )
        )
    {
        if ( defined $Param{$Setting} || defined $ConfigObject->Get("Database::$Setting") )
        {
            $Self->{Backend}->{"DB::$Setting"} = $Param{$Setting}
                // $ConfigObject->Get("Database::$Setting");
        }
    }

    return $Self;
}

=head2 Connect()

to connect to a database

    $DBObject->Connect();

=cut

sub Connect {
    my $Self = shift;

    # check database handle
    if ( $Self->{dbh} ) {

        my $PingTimeout = 10;        # Only ping every 10 seconds (see bug#12383).
        my $CurrentTime = time();    ## no critic

        if ( $CurrentTime - ( $Self->{LastPingTime} // 0 ) < $PingTimeout ) {
            return $Self->{dbh};
        }

        # Ping to see if the connection is still alive.
        if ( $Self->{dbh}->ping() ) {
            $Self->{LastPingTime} = $CurrentTime;
            return $Self->{dbh};
        }

        # Ping failed: cause a reconnect.
        delete $Self->{dbh};
    }

    # debug
    if ( $Self->{Debug} > 2 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'debug',
            Message =>
                "DB.pm->Connect: DSN: $Self->{DSN}, User: $Self->{USER}, Pw: $Self->{PW}, DB Type: $Self->{'DB::Type'};",
        );
    }

    # db connect
    $Self->{dbh} = DBI->connect(
        $Self->{DSN},
        $Self->{USER},
        $Self->{PW},
        $Self->{Backend}->{'DB::Attribute'},
    );

    if ( !$Self->{dbh} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'Error',
            Message  => $DBI::errstr,
        );
        return;
    }

    if ( $Self->{Backend}->{'DB::Connect'} ) {
        $Self->Do( SQL => $Self->{Backend}->{'DB::Connect'} );
    }

    # set utf-8 on for PostgreSQL
    if ( $Self->{Backend}->{'DB::Type'} eq 'postgresql' ) {
        $Self->{dbh}->{pg_enable_utf8} = 1;
    }

    if ( $Self->{SlaveDBObject} ) {
        $Self->{SlaveDBObject}->Connect();
    }

    return $Self->{dbh};
}

=head2 Disconnect()

to disconnect from a database

    $DBObject->Disconnect();

=cut

sub Disconnect {
    my $Self = shift;

    # debug
    if ( $Self->{Debug} > 2 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'debug',
            Message  => 'DB.pm->Disconnect',
        );
    }

    # do disconnect
    if ( $Self->{dbh} ) {
        $Self->{dbh}->disconnect();
        delete $Self->{dbh};
    }

    if ( $Self->{SlaveDBObject} ) {
        $Self->{SlaveDBObject}->Disconnect();
    }

    return 1;
}

=head2 Version()

to get the database version

    my $DBVersion = $DBObject->Version();

    returns: "MySQL 5.1.1";

=cut

sub Version {
    my ( $Self, %Param ) = @_;

    my $Version = 'unknown';

    if ( $Self->{Backend}->{'DB::Version'} ) {
        $Self->Prepare( SQL => $Self->{Backend}->{'DB::Version'} );
        while ( my @Row = $Self->FetchrowArray() ) {
            $Version = $Row[0];
        }
    }

    return $Version;
}

=head2 Quote()

to quote sql parameters

    quote strings, date and time:
    =============================
    my $DBString = $DBObject->Quote( "This isn't a problem!" );

    my $DBString = $DBObject->Quote( "2005-10-27 20:15:01" );

    quote integers:
    ===============
    my $DBString = $DBObject->Quote( 1234, 'Integer' );

    quote numbers (e. g. 1, 1.4, 42342.23424):
    ==========================================
    my $DBString = $DBObject->Quote( 1234, 'Number' );

=cut

sub Quote {
    my ( $Self, $Text, $Type ) = @_;

    # return undef if undef
    return if !defined $Text;

    # quote strings
    if ( !defined $Type ) {
        return ${ $Self->{Backend}->Quote( \$Text ) };
    }

    # quote integers
    if ( $Type eq 'Integer' ) {
        if ( $Text !~ m{\A [+-]? \d{1,16} \z}xms ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Caller   => 1,
                Priority => 'error',
                Message  => "Invalid integer in query '$Text'!",
            );
            return;
        }
        return $Text;
    }

    # quote numbers
    if ( $Type eq 'Number' ) {
        if ( $Text !~ m{ \A [+-]? \d{1,20} (?:\.\d{1,20})? \z}xms ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Caller   => 1,
                Priority => 'error',
                Message  => "Invalid number in query '$Text'!",
            );
            return;
        }
        return $Text;
    }

    # quote like strings
    if ( $Type eq 'Like' ) {
        return ${ $Self->{Backend}->Quote( \$Text, $Type ) };
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Caller   => 1,
        Priority => 'error',
        Message  => "Invalid quote type '$Type'!",
    );

    return;
}

=head2 Error()

to retrieve database errors

    my $ErrorMessage = $DBObject->Error();

=cut

sub Error {
    my $Self = shift;

    return $DBI::errstr;
}

=head2 Do()

to insert, update or delete values

    $DBObject->Do( SQL => "INSERT INTO table (name) VALUES ('dog')" );

    $DBObject->Do( SQL => "DELETE FROM table" );

    you also can use DBI bind values (used for large strings):

    my $Var1 = 'dog1';
    my $Var2 = 'dog2';

    $DBObject->Do(
        SQL  => "INSERT INTO table (name1, name2) VALUES (?, ?)",
        Bind => [ \$Var1, \$Var2 ],
    );

=cut

sub Do {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{SQL} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need SQL!',
        );
        return;
    }

    if ( $Self->{Backend}->{'DB::PreProcessSQL'} ) {
        $Self->{Backend}->PreProcessSQL( \$Param{SQL} );
    }

    # check bind params
    my @Array;
    if ( $Param{Bind} ) {
        for my $Data ( @{ $Param{Bind} } ) {
            if ( ref $Data eq 'SCALAR' ) {
                push @Array, $$Data;
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Caller   => 1,
                    Priority => 'Error',
                    Message  => 'No SCALAR param in Bind!',
                );
                return;
            }
        }
        if ( @Array && $Self->{Backend}->{'DB::PreProcessBindData'} ) {
            $Self->{Backend}->PreProcessBindData( \@Array );
        }
    }

    # Replace current_timestamp with real time stamp.
    # - This avoids time inconsistencies of app and db server
    # - This avoids timestamp problems in Postgresql servers where
    #   the timestamp is sometimes 1 second off the perl timestamp.

    $Param{SQL} =~ s{
        (?<= \s | \( | , )  # lookbehind
        current_timestamp   # replace current_timestamp by 'yyyy-mm-dd hh:mm:ss'
        (?=  \s | \) | , )  # lookahead
    }
    {
        # Only calculate timestamp if it is really needed (on first invocation or if the system time changed)
        #   for performance reasons.
        my $Epoch = time;
        if (!$Self->{TimestampEpoch} || $Self->{TimestampEpoch} != $Epoch) {
            $Self->{TimestampEpoch} = $Epoch;
            $Self->{Timestamp}      = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();
        }
        "'$Self->{Timestamp}'";
    }exmsg;

    # debug
    if ( $Self->{Debug} > 0 ) {
        $Self->{DoCounter}++;
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'debug',
            Message  => "DB.pm->Do ($Self->{DoCounter}) SQL: '$Param{SQL}'",
        );
    }

    return if !$Self->Connect();

    # send sql to database
    if ( !$Self->{dbh}->do( $Param{SQL}, undef, @Array ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'error',
            Message  => "$DBI::errstr, SQL: '$Param{SQL}'",
        );
        return;
    }

    return 1;
}

sub _InitSlaveDB {
    my ( $Self, %Param ) = @_;

    # Run only once!
    return $Self->{SlaveDBObject} if $Self->{_InitSlaveDB}++;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $MasterDSN    = $ConfigObject->Get('DatabaseDSN');

    # Don't create slave if we are already in a slave, or if we are not in the master,
    #   such as in an external customer user database handle.
    if ( $Self->{IsSlaveDB} || $MasterDSN ne $Self->{DSN} ) {
        return $Self->{SlaveDBObject};
    }

    my %SlaveConfiguration = (
        %{ $ConfigObject->Get('Core::MirrorDB::AdditionalMirrors') // {} },
        0 => {
            DSN      => $ConfigObject->Get('Core::MirrorDB::DSN'),
            User     => $ConfigObject->Get('Core::MirrorDB::User'),
            Password => $ConfigObject->Get('Core::MirrorDB::Password'),
        }
    );

    return $Self->{SlaveDBObject} if !%SlaveConfiguration;

    SLAVE_INDEX:
    for my $SlaveIndex ( List::Util::shuffle( keys %SlaveConfiguration ) ) {

        my %CurrentSlave = %{ $SlaveConfiguration{$SlaveIndex} // {} };
        next SLAVE_INDEX if !%CurrentSlave;

        # If a slave is configured and it is not already used in the current object
        #   and we are actually in the master connection object: then create a slave.
        if (
            $CurrentSlave{DSN}
            && $CurrentSlave{User}
            && $CurrentSlave{Password}
            )
        {
            my $SlaveDBObject = Kernel::System::DB->new(
                DatabaseDSN  => $CurrentSlave{DSN},
                DatabaseUser => $CurrentSlave{User},
                DatabasePw   => $CurrentSlave{Password},
                IsSlaveDB    => 1,
            );

            if ( $SlaveDBObject->Connect() ) {
                $Self->{SlaveDBObject} = $SlaveDBObject;
                return $Self->{SlaveDBObject};
            }
        }
    }

    # no connect was possible.
    return;
}

=head2 Prepare()

to prepare a SELECT statement

    $DBObject->Prepare(
        SQL   => "SELECT id, name FROM table",
        Limit => 10,
    );

or in case you want just to get row 10 until 30

    $DBObject->Prepare(
        SQL   => "SELECT id, name FROM table",
        Start => 10,
        Limit => 20,
    );

in case you don't want utf-8 encoding for some columns, use this:

    $DBObject->Prepare(
        SQL    => "SELECT id, name, content FROM table",
        Encode => [ 1, 1, 0 ],
    );

you also can use DBI bind values, required for large strings:

    my $Var1 = 'dog1';
    my $Var2 = 'dog2';

    $DBObject->Prepare(
        SQL    => "SELECT id, name, content FROM table WHERE name_a = ? AND name_b = ?",
        Encode => [ 1, 1, 0 ],
        Bind   => [ \$Var1, \$Var2 ],
    );

=cut

sub Prepare {
    my ( $Self, %Param ) = @_;

    my $SQL   = $Param{SQL};
    my $Limit = $Param{Limit} || '';
    my $Start = $Param{Start} || '';

    # check needed stuff
    if ( !$Param{SQL} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need SQL!',
        );
        return;
    }

    if ( $Param{Bind} && ref $Param{Bind} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Bind must be and array reference!',
        );
    }

    $Self->{_PreparedOnSlaveDB} = 0;

    # Route SELECT statements to the DB slave if requested and a slave is configured.
    if (
        $UseSlaveDB
        && !$Self->{IsSlaveDB}
        && $Self->_InitSlaveDB()    # this is very cheap after the first call (cached)
        && $SQL =~ m{\A\s*SELECT}xms
        )
    {
        $Self->{_PreparedOnSlaveDB} = 1;
        return $Self->{SlaveDBObject}->Prepare(%Param);
    }

    if ( defined $Param{Encode} ) {
        $Self->{Encode} = $Param{Encode};
    }
    else {
        $Self->{Encode} = undef;
    }
    $Self->{Limit}        = 0;
    $Self->{LimitStart}   = 0;
    $Self->{LimitCounter} = 0;

    # build final select query
    if ($Limit) {
        if ($Start) {
            $Limit = $Limit + $Start;
            $Self->{LimitStart} = $Start;
        }
        if ( $Self->{Backend}->{'DB::Limit'} eq 'limit' ) {
            $SQL .= " LIMIT $Limit";
        }
        elsif ( $Self->{Backend}->{'DB::Limit'} eq 'top' ) {
            $SQL =~ s{ \A \s* (SELECT ([ ]DISTINCT|)) }{$1 TOP $Limit}xmsi;
        }
        else {
            $Self->{Limit} = $Limit;
        }
    }

    # debug
    if ( $Self->{Debug} > 1 ) {
        $Self->{PrepareCounter}++;
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'debug',
            Message  => "DB.pm->Prepare ($Self->{PrepareCounter}/" . time() . ") SQL: '$SQL'",
        );
    }

    # slow log feature
    my $LogTime;
    if ( $Self->{SlowLog} ) {
        $LogTime = time();
    }

    if ( $Self->{Backend}->{'DB::PreProcessSQL'} ) {
        $Self->{Backend}->PreProcessSQL( \$SQL );
    }

    # check bind params
    my @Array;
    if ( $Param{Bind} ) {
        for my $Data ( @{ $Param{Bind} } ) {
            if ( ref $Data eq 'SCALAR' ) {
                push @Array, $$Data;
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Caller   => 1,
                    Priority => 'Error',
                    Message  => 'No SCALAR param in Bind!',
                );
                return;
            }
        }
        if ( @Array && $Self->{Backend}->{'DB::PreProcessBindData'} ) {
            $Self->{Backend}->PreProcessBindData( \@Array );
        }
    }

    return if !$Self->Connect();

    # do
    if ( !( $Self->{Cursor} = $Self->{dbh}->prepare($SQL) ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'Error',
            Message  => "$DBI::errstr, SQL: '$SQL'",
        );
        return;
    }

    if ( !$Self->{Cursor}->execute(@Array) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'Error',
            Message  => "$DBI::errstr, SQL: '$SQL'",
        );
        return;
    }

    # slow log feature
    if ( $Self->{SlowLog} ) {
        my $LogTimeTaken = time() - $LogTime;
        if ( $LogTimeTaken > 4 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Caller   => 1,
                Priority => 'error',
                Message  => "Slow ($LogTimeTaken s) SQL: '$SQL'",
            );
        }
    }

    return 1;
}

=head2 FetchrowArray()

to process the results of a SELECT statement

    $DBObject->Prepare(
        SQL   => "SELECT id, name FROM table",
        Limit => 10
    );

    while (my @Row = $DBObject->FetchrowArray()) {
        print "$Row[0]:$Row[1]\n";
    }

=cut

sub FetchrowArray {
    my $Self = shift;

    if ( $Self->{_PreparedOnSlaveDB} ) {
        return $Self->{SlaveDBObject}->FetchrowArray();
    }

    # work with cursors if database don't support limit
    if ( !$Self->{Backend}->{'DB::Limit'} && $Self->{Limit} ) {
        if ( $Self->{Limit} <= $Self->{LimitCounter} ) {
            $Self->{Cursor}->finish();
            return;
        }
        $Self->{LimitCounter}++;
    }

    # fetch first not used rows
    if ( $Self->{LimitStart} ) {
        for ( 1 .. $Self->{LimitStart} ) {
            if ( !$Self->{Cursor}->fetchrow_array() ) {
                $Self->{LimitStart} = 0;
                return ();
            }
            $Self->{LimitCounter}++;
        }
        $Self->{LimitStart} = 0;
    }

    # return
    my @Row = $Self->{Cursor}->fetchrow_array();

    if ( !$Self->{Backend}->{'DB::Encode'} ) {
        return @Row;
    }

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # e. g. set utf-8 flag
    my $Counter = 0;
    ELEMENT:
    for my $Element (@Row) {

        next ELEMENT if !defined $Element;

        if ( !defined $Self->{Encode} || ( $Self->{Encode} && $Self->{Encode}->[$Counter] ) ) {
            $EncodeObject->EncodeInput( \$Element );
        }
    }
    continue {
        $Counter++;
    }

    return @Row;
}

=head2 ListTables()

list all tables in the OTRS database.

    my @Tables = $DBObject->ListTables();

On databases like Oracle it could happen that too many tables are listed (all belonging
to the current user), if the user also has permissions for other databases. So this list
should only be used for verification of the presence of expected OTRS tables.

=cut

sub ListTables {
    my $Self = shift;

    my $SQL = $Self->GetDatabaseFunction('ListTables');

    if ( !$SQL ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'Error',
            Message  => "Database driver $Self->{'DB::Type'} does not support ListTables.",
        );
        return;
    }

    my $Success = $Self->Prepare(
        SQL => $SQL,
    );

    return if !$Success;

    my @Tables;
    while ( my @Row = $Self->FetchrowArray() ) {
        push @Tables, lc $Row[0];
    }

    return @Tables;
}

=head2 GetColumnNames()

to retrieve the column names of a database statement

    $DBObject->Prepare(
        SQL   => "SELECT * FROM table",
        Limit => 10
    );

    my @Names = $DBObject->GetColumnNames();

=cut

sub GetColumnNames {
    my $Self = shift;

    my $ColumnNames = $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( $Self->{Cursor}->{NAME} );

    my @Result;
    if ( IsArrayRefWithData($ColumnNames) ) {
        @Result = @{$ColumnNames};
    }

    return @Result;
}

=head2 SelectAll()

returns all available records of a SELECT statement.
In essence, this calls Prepare() and FetchrowArray() to get all records.

    my $ResultAsArrayRef = $DBObject->SelectAll(
        SQL   => "SELECT id, name FROM table",
        Limit => 10
    );

You can pass the same arguments as to the Prepare() method.

Returns undef (if query failed), or an array ref (if query was successful):

  my $ResultAsArrayRef = [
    [ 1, 'itemOne' ],
    [ 2, 'itemTwo' ],
    [ 3, 'itemThree' ],
    [ 4, 'itemFour' ],
  ];

=cut

sub SelectAll {
    my ( $Self, %Param ) = @_;

    return if !$Self->Prepare(%Param);

    my @Records;
    while ( my @Row = $Self->FetchrowArray() ) {
        push @Records, \@Row;
    }
    return \@Records;
}

=head2 GetDatabaseFunction()

to get database functions like

    - Limit
    - DirectBlob
    - QuoteSingle
    - QuoteBack
    - QuoteSemicolon
    - NoLikeInLargeText
    - CurrentTimestamp
    - Encode
    - Comment
    - ShellCommit
    - ShellConnect
    - Connect
    - LikeEscapeString

    my $What = $DBObject->GetDatabaseFunction('DirectBlob');

=cut

sub GetDatabaseFunction {
    my ( $Self, $What ) = @_;

    return $Self->{Backend}->{ 'DB::' . $What };
}

=head2 SQLProcessor()

generate database-specific sql syntax (e. g. CREATE TABLE ...)

    my @SQL = $DBObject->SQLProcessor(
        Database =>
            [
                Tag  => 'TableCreate',
                Name => 'table_name',
            ],
            [
                Tag  => 'Column',
                Name => 'col_name',
                Type => 'VARCHAR',
                Size => 150,
            ],
            [
                Tag  => 'Column',
                Name => 'col_name2',
                Type => 'INTEGER',
            ],
            [
                Tag => 'TableEnd',
            ],
    );

=cut

sub SQLProcessor {
    my ( $Self, %Param ) = @_;

    my @SQL;
    if ( $Param{Database} && ref $Param{Database} eq 'ARRAY' ) {

        # make a deep copy in order to prevent modyfing the input data
        # see also Bug#12764 - Database function SQLProcessor() modifies given parameter data
        # https://bugs.otrs.org/show_bug.cgi?id=12764
        my @Database = @{
            $Kernel::OM->Get('Kernel::System::Storable')->Clone(
                Data => $Param{Database},
            )
        };

        my @Table;
        for my $Tag (@Database) {

            # create table
            if ( $Tag->{Tag} eq 'Table' || $Tag->{Tag} eq 'TableCreate' ) {
                if ( $Tag->{TagType} eq 'Start' ) {
                    $Self->_NameCheck($Tag);
                }
                push @Table, $Tag;
                if ( $Tag->{TagType} eq 'End' ) {
                    push @SQL, $Self->{Backend}->TableCreate(@Table);
                    @Table = ();
                }
            }

            # unique
            elsif (
                $Tag->{Tag} eq 'Unique'
                || $Tag->{Tag} eq 'UniqueCreate'
                || $Tag->{Tag} eq 'UniqueDrop'
                )
            {
                push @Table, $Tag;
            }

            elsif ( $Tag->{Tag} eq 'UniqueColumn' ) {
                push @Table, $Tag;
            }

            # index
            elsif (
                $Tag->{Tag} eq 'Index'
                || $Tag->{Tag} eq 'IndexCreate'
                || $Tag->{Tag} eq 'IndexDrop'
                )
            {
                push @Table, $Tag;
            }

            elsif ( $Tag->{Tag} eq 'IndexColumn' ) {
                push @Table, $Tag;
            }

            # foreign keys
            elsif (
                $Tag->{Tag} eq 'ForeignKey'
                || $Tag->{Tag} eq 'ForeignKeyCreate'
                || $Tag->{Tag} eq 'ForeignKeyDrop'
                )
            {
                push @Table, $Tag;
            }
            elsif ( $Tag->{Tag} eq 'Reference' && $Tag->{TagType} eq 'Start' ) {
                push @Table, $Tag;
            }

            # alter table
            elsif ( $Tag->{Tag} eq 'TableAlter' ) {
                push @Table, $Tag;
                if ( $Tag->{TagType} eq 'End' ) {
                    push @SQL, $Self->{Backend}->TableAlter(@Table);
                    @Table = ();
                }
            }

            # column
            elsif ( $Tag->{Tag} eq 'Column' && $Tag->{TagType} eq 'Start' ) {

                # type check
                $Self->_TypeCheck($Tag);
                push @Table, $Tag;
            }
            elsif ( $Tag->{Tag} eq 'ColumnAdd' && $Tag->{TagType} eq 'Start' ) {

                # type check
                $Self->_TypeCheck($Tag);
                push @Table, $Tag;
            }
            elsif ( $Tag->{Tag} eq 'ColumnChange' && $Tag->{TagType} eq 'Start' ) {

                # type check
                $Self->_TypeCheck($Tag);
                push @Table, $Tag;
            }
            elsif ( $Tag->{Tag} eq 'ColumnDrop' && $Tag->{TagType} eq 'Start' ) {

                # type check
                $Self->_TypeCheck($Tag);
                push @Table, $Tag;
            }

            # drop table
            elsif ( $Tag->{Tag} eq 'TableDrop' && $Tag->{TagType} eq 'Start' ) {
                push @Table, $Tag;
                push @SQL,   $Self->{Backend}->TableDrop(@Table);
                @Table = ();
            }

            # insert
            elsif ( $Tag->{Tag} eq 'Insert' ) {
                push @Table, $Tag;
                if ( $Tag->{TagType} eq 'End' ) {
                    push @Table, $Tag;
                    push @SQL,   $Self->{Backend}->Insert(@Table);
                    @Table = ();
                }
            }
            elsif ( $Tag->{Tag} eq 'Data' && $Tag->{TagType} eq 'Start' ) {
                push @Table, $Tag;
            }
        }
    }

    return @SQL;
}

=head2 SQLProcessorPost()

generate database-specific sql syntax, post data of SQLProcessor(),
e. g. foreign keys

    my @SQL = $DBObject->SQLProcessorPost();

=cut

sub SQLProcessorPost {
    my ( $Self, %Param ) = @_;

    if ( $Self->{Backend}->{Post} ) {
        my @Return = @{ $Self->{Backend}->{Post} };
        undef $Self->{Backend}->{Post};
        return @Return;
    }

    return ();
}

=head2 QueryCondition()

generate SQL condition query based on a search expression

    my $SQL = $DBObject->QueryCondition(
        Key   => 'some_col',
        Value => '(ABC+DEF)',
    );

    add SearchPrefix and SearchSuffix to search, in this case
    for "(ABC*+DEF*)"

    my $SQL = $DBObject->QueryCondition(
        Key          => 'some_col',
        Value        => '(ABC+DEF)',
        SearchPrefix => '',
        SearchSuffix => '*'
        Extended     => 1, # use also " " as "&&", e.g. "bob smith" -> "bob&&smith"
    );

    example of a more complex search condition

    my $SQL = $DBObject->QueryCondition(
        Key   => 'some_col',
        Value => '((ABC&&DEF)&&!GHI)',
    );

    for a earch condition over more columns

    my $SQL = $DBObject->QueryCondition(
        Key   => [ 'some_col_a', 'some_col_b' ],
        Value => '((ABC&&DEF)&&!GHI)',
    );

    Returns the SQL string or "1=0" if the query could not be parsed correctly.

    my $SQL = $DBObject->QueryCondition(
        Key      => [ 'some_col_a', 'some_col_b' ],
        Value    => '((ABC&&DEF)&&!GHI)',
        BindMode => 1,
    );

    return the SQL String with ?-values and a array with values references:

    $BindModeResult = (
        'SQL'    => 'WHERE testa LIKE ? AND testb NOT LIKE ? AND testc = ?'
        'Values' => ['a', 'b', 'c'],
    )

Note that the comparisons are usually performed case insensitively.
Only C<VARCHAR> columns with a size less or equal 3998 are supported,
as for locator objects the functioning of SQL function C<LOWER()> can't
be guaranteed.

=cut

sub QueryCondition {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Key Value)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get like escape string needed for some databases (e.g. oracle)
    my $LikeEscapeString = $Self->GetDatabaseFunction('LikeEscapeString');

    # search prefix/suffix check
    my $SearchPrefix  = $Param{SearchPrefix}  || '';
    my $SearchSuffix  = $Param{SearchSuffix}  || '';
    my $CaseSensitive = $Param{CaseSensitive} || 0;
    my $BindMode      = $Param{BindMode}      || 0;
    my @BindValues;

    # remove leading/trailing spaces
    $Param{Value} =~ s/^\s+//g;
    $Param{Value} =~ s/\s+$//g;

    # add base brackets
    if ( $Param{Value} !~ /^(?<!\\)\(/ || $Param{Value} !~ /(?<!\\)\)$/ ) {
        $Param{Value} = '(' . $Param{Value} . ')';
    }

    # quote ".+?" expressions
    # for example ("some and me" AND !some), so "some and me" is used for search 1:1
    my $Count = 0;
    my %Expression;
    $Param{Value} =~ s{
        "(.+?)"
    }
    {
        $Count++;
        my $Item = $1;
        $Expression{"###$Count###"} = $Item;
        "###$Count###";
    }egx;

    # remove empty parentheses
    $Param{Value} =~ s/(?<!\\)\(\s*(?<!\\)\)//g;

    # remove double spaces
    $Param{Value} =~ s/\s+/ /g;

    # replace + by &&
    $Param{Value} =~ s/\+/&&/g;

    # replace AND by &&
    $Param{Value} =~ s/(\s|(?<!\\)\)|(?<!\\)\()AND(\s|(?<!\\)\(|(?<!\\)\))/$1&&$2/g;

    # replace OR by ||
    $Param{Value} =~ s/(\s|(?<!\\)\)|(?<!\\)\()OR(\s|(?<!\\)\(|(?<!\\)\))/$1||$2/g;

    # replace * with % (for SQL)
    $Param{Value} =~ s/\*/%/g;

    # remove double %% (also if there is only whitespace in between)
    $Param{Value} =~ s/%\s*%/%/g;

    # replace '%!%' by '!%' (done if * is added by search frontend)
    $Param{Value} =~ s/\%!\%/!%/g;

    # replace '%!' by '!%' (done if * is added by search frontend)
    $Param{Value} =~ s/\%!/!%/g;

    # remove leading/trailing conditions
    $Param{Value} =~ s/(&&|\|\|)(?<!\\)\)$/)/g;
    $Param{Value} =~ s/^(?<!\\)\((&&|\|\|)/(/g;

    # clean up not needed spaces in condistions
    # removed spaces examples
    # [SPACE](, [SPACE]), [SPACE]|, [SPACE]&
    # example not removed spaces
    # [SPACE]\\(, [SPACE]\\), [SPACE]\\&
    $Param{Value} =~ s{(
        \s
        (
              (?<!\\) \(
            | (?<!\\) \)
            |         \|
            | (?<!\\) &
        )
    )}{$2}xg;

    # removed spaces examples
    # )[SPACE], )[SPACE], |[SPACE], &[SPACE]
    # example not removed spaces
    # \\([SPACE], \\)[SPACE], \\&[SPACE]
    $Param{Value} =~ s{(
        (
              (?<!\\) \(
            | (?<!\\) \)
            |         \|
            | (?<!\\) &
        )
        \s
    )}{$2}xg;

    # use extended condition mode
    # 1. replace " " by "&&"
    if ( $Param{Extended} ) {
        $Param{Value} =~ s/\s/&&/g;
    }

    # get col.
    my @Keys;
    if ( ref $Param{Key} eq 'ARRAY' ) {
        @Keys = @{ $Param{Key} };
    }
    else {
        @Keys = ( $Param{Key} );
    }

    # for syntax check
    my $Open  = 0;
    my $Close = 0;

    # for processing
    my @Array     = split( //, $Param{Value} );
    my $SQL       = '';
    my $Word      = '';
    my $Not       = 0;
    my $Backslash = 0;

    my $SpecialCharacters = $Self->_SpecialCharactersGet();

    POSITION:
    for my $Position ( 0 .. $#Array ) {

        # find word
        if ($Backslash) {
            $Word .= $Array[$Position];
            $Backslash = 0;
            next POSITION;
        }

        # remember if next token is a part of word
        elsif (
            $Array[$Position] eq '\\'
            && $Position < $#Array
            && (
                $SpecialCharacters->{ $Array[ $Position + 1 ] }
                || $Array[ $Position + 1 ] eq '\\'
            )
            )
        {
            $Backslash = 1;
            next POSITION;
        }

        # remember if it's a NOT condition
        elsif ( $Word eq '' && $Array[$Position] eq '!' ) {
            $Not = 1;
            next POSITION;
        }
        elsif ( $Array[$Position] eq '&' ) {
            if ( $Position >= 1 && $Array[ $Position - 1 ] eq '&' ) {
                next POSITION;
            }
            if ( $Position == $#Array || $Array[ $Position + 1 ] ne '&' ) {
                $Word .= $Array[$Position];
                next POSITION;
            }
        }
        elsif ( $Array[$Position] eq '|' ) {
            if ( $Position >= 1 && $Array[ $Position - 1 ] eq '|' ) {
                next POSITION;
            }
            if ( $Position == $#Array || $Array[ $Position + 1 ] ne '|' ) {
                $Word .= $Array[$Position];
                next POSITION;
            }
        }
        elsif ( !$SpecialCharacters->{ $Array[$Position] } ) {
            $Word .= $Array[$Position];
            next POSITION;
        }

        # if word exists, do something with it
        if ( $Word ne '' ) {

            # remove escape characters from $Word
            $Word =~ s{\\}{}smxg;

            # replace word if it's an "some expression" expression
            if ( $Expression{$Word} ) {
                $Word = $Expression{$Word};
            }

            # database quote
            $Word = $SearchPrefix . $Word . $SearchSuffix;
            $Word =~ s/\*/%/g;
            $Word =~ s/%%/%/g;
            $Word =~ s/%%/%/g;

            # perform quoting depending on query type (only if not in bind mode)
            if ( !$BindMode ) {
                if ( $Word =~ m/%/ ) {
                    $Word = $Self->Quote( $Word, 'Like' );
                }
                else {
                    $Word = $Self->Quote($Word);
                }
            }

            # if it's a NOT LIKE condition
            if ($Not) {
                $Not = 0;

                my $SQLA;
                for my $Key (@Keys) {
                    if ($SQLA) {
                        $SQLA .= ' AND ';
                    }

                    # check if like is used
                    my $Type = 'NOT LIKE';
                    if ( $Word !~ m/%/ ) {
                        $Type = '!=';
                    }

                    my $WordSQL = $Word;
                    if ($BindMode) {
                        $WordSQL = "?";
                    }
                    else {
                        $WordSQL = "'" . $WordSQL . "'";
                    }

        # check if database supports LIKE in large text types
        # the first condition is a little bit opaque
        # CaseSensitive of the database defines, if the database handles case sensitivity or not
        # and the parameter $CaseSensitive defines, if the customer database should do case sensitive statements or not.
        # so if the database dont support case sensitivity or the configuration of the customer database want to do this
        # then we prevent the LOWER() statements.
                    if ( !$Self->GetDatabaseFunction('CaseSensitive') || $CaseSensitive ) {
                        $SQLA .= "$Key $Type $WordSQL";
                    }
                    elsif ( $Self->GetDatabaseFunction('LcaseLikeInLargeText') ) {
                        $SQLA .= "LCASE($Key) $Type LCASE($WordSQL)";
                    }
                    else {
                        $SQLA .= "LOWER($Key) $Type LOWER($WordSQL)";
                    }

                    if ( $Type eq 'NOT LIKE' ) {
                        $SQLA .= " $LikeEscapeString";
                    }

                    if ($BindMode) {
                        push @BindValues, $Word;
                    }
                }
                $SQL .= '(' . $SQLA . ') ';
            }

            # if it's a LIKE condition
            else {
                my $SQLA;
                for my $Key (@Keys) {
                    if ($SQLA) {
                        $SQLA .= ' OR ';
                    }

                    # check if like is used
                    my $Type = 'LIKE';
                    if ( $Word !~ m/%/ ) {
                        $Type = '=';
                    }

                    my $WordSQL = $Word;
                    if ($BindMode) {
                        $WordSQL = "?";
                    }
                    else {
                        $WordSQL = "'" . $WordSQL . "'";
                    }

        # check if database supports LIKE in large text types
        # the first condition is a little bit opaque
        # CaseSensitive of the database defines, if the database handles case sensitivity or not
        # and the parameter $CaseSensitive defines, if the customer database should do case sensitive statements or not.
        # so if the database dont support case sensitivity or the configuration of the customer database want to do this
        # then we prevent the LOWER() statements.
                    if ( !$Self->GetDatabaseFunction('CaseSensitive') || $CaseSensitive ) {
                        $SQLA .= "$Key $Type $WordSQL";
                    }
                    elsif ( $Self->GetDatabaseFunction('LcaseLikeInLargeText') ) {
                        $SQLA .= "LCASE($Key) $Type LCASE($WordSQL)";
                    }
                    else {
                        $SQLA .= "LOWER($Key) $Type LOWER($WordSQL)";
                    }

                    if ( $Type eq 'LIKE' ) {
                        $SQLA .= " $LikeEscapeString";
                    }

                    if ($BindMode) {
                        push @BindValues, $Word;
                    }
                }
                $SQL .= '(' . $SQLA . ') ';
            }

            # reset word
            $Word = '';
        }

        # check AND and OR conditions
        if ( $Array[ $Position + 1 ] ) {

            # if it's an AND condition
            if ( $Array[$Position] eq '&' && $Array[ $Position + 1 ] eq '&' ) {
                if ( $SQL =~ m/ OR $/ ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'notice',
                        Message =>
                            "Invalid condition '$Param{Value}', simultaneous usage both AND and OR conditions!",
                    );
                    return "1=0";
                }
                elsif ( $SQL !~ m/ AND $/ ) {
                    $SQL .= ' AND ';
                }
            }

            # if it's an OR condition
            elsif ( $Array[$Position] eq '|' && $Array[ $Position + 1 ] eq '|' ) {
                if ( $SQL =~ m/ AND $/ ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'notice',
                        Message =>
                            "Invalid condition '$Param{Value}', simultaneous usage both AND and OR conditions!",
                    );
                    return "1=0";
                }
                elsif ( $SQL !~ m/ OR $/ ) {
                    $SQL .= ' OR ';
                }
            }
        }

        # add ( or ) for query
        if ( $Array[$Position] eq '(' ) {
            if ( $SQL ne '' && $SQL !~ /(?: (?:AND|OR) |\(\s*)$/ ) {
                $SQL .= ' AND ';
            }
            $SQL .= $Array[$Position];

            # remember for syntax check
            $Open++;
        }
        if ( $Array[$Position] eq ')' ) {
            $SQL .= $Array[$Position];
            if (
                $Position < $#Array
                && ( $Position > $#Array - 1 || $Array[ $Position + 1 ] ne ')' )
                && (
                    $Position > $#Array - 2
                    || $Array[ $Position + 1 ] ne '&'
                    || $Array[ $Position + 2 ] ne '&'
                )
                && (
                    $Position > $#Array - 2
                    || $Array[ $Position + 1 ] ne '|'
                    || $Array[ $Position + 2 ] ne '|'
                )
                )
            {
                $SQL .= ' AND ';
            }

            # remember for syntax check
            $Close++;
        }
    }

    # check syntax
    if ( $Open != $Close ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Invalid condition '$Param{Value}', $Open open and $Close close!",
        );
        if ($BindMode) {
            return (
                'SQL'    => "1=0",
                'Values' => [],
            );
        }
        return "1=0";
    }

    if ($BindMode) {
        my $BindRefList = [ map { \$_ } @BindValues ];
        return (
            'SQL'    => $SQL,
            'Values' => $BindRefList,
        );
    }

    return $SQL;
}

=head2 QueryInCondition()

Generate a SQL IN condition query based on the given table key and values.

    my $SQL = $DBObject->QueryInCondition(
        Key       => 'table.column',
        Values    => [ 1, 2, 3, 4, 5, 6 ],
        QuoteType => '(undef|Integer|Number)',
        BindMode  => (0|1),
        Negate    => (0|1),
    );

Returns the SQL string:

    my $SQL = "ticket_id IN (1, 2, 3, 4, 5, 6)"

Return a separated IN condition for more then C<MaxParamCountForInCondition> values:

    my $SQL = "( ticket_id IN ( 1, 2, 3, 4, 5, 6 ... ) OR ticket_id IN ( ... ) )"

Return the SQL String with ?-values and a array with values references in bind mode:

    $BindModeResult = (
        'SQL'    => 'ticket_id IN (?, ?, ?, ?, ?, ?)',
        'Values' => [1, 2, 3, 4, 5, 6],
    );

    or

    $BindModeResult = (
        'SQL'    => '( ticket_id IN (?, ?, ?, ?, ?, ?) OR ticket_id IN ( ?, ... ) )',
        'Values' => [1, 2, 3, 4, 5, 6, ... ],
    );

Returns the SQL string for a negated in condition:

    my $SQL = "ticket_id NOT IN (1, 2, 3, 4, 5, 6)"

    or

    my $SQL = "( ticket_id NOT IN ( 1, 2, 3, 4, 5, 6 ... ) AND ticket_id NOT IN ( ... ) )"

=cut

sub QueryInCondition {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Key} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Key!",
        );
        return;
    }

    if ( !IsArrayRefWithData( $Param{Values} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Values!",
        );
        return;
    }

    if ( $Param{QuoteType} && $Param{QuoteType} eq 'Like' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "QuoteType 'Like' is not allowed for 'IN' conditions!",
        );
        return;
    }

    $Param{Negate}   //= 0;
    $Param{BindMode} //= 0;

    # Set the flag for string because of the other handling in the sql statement with strings.
    my $IsString;
    if ( !$Param{QuoteType} ) {
        $IsString = 1;
    }

    my @Values = @{ $Param{Values} };

    # Perform quoting depending on given quote type (only if not in bind mode)
    if ( !$Param{BindMode} ) {

        # Sort the values to cache the SQL query.
        if ($IsString) {
            @Values = sort { $a cmp $b } @Values;
        }
        else {
            @Values = sort { $a <=> $b } @Values;
        }

        @Values = map { $Self->Quote( $_, $Param{QuoteType} ) } @Values;

        # Something went wrong during the quoting, if the count is not equal.
        return if scalar @Values != scalar @{ $Param{Values} };
    }

    # Set the correct operator and connector (only needed for splitted conditions).
    my $Operator  = 'IN';
    my $Connector = 'OR';

    if ( $Param{Negate} ) {
        $Operator  = 'NOT IN';
        $Connector = 'AND';
    }

    my @SQLStrings;
    my @BindValues;

    # Split IN statement with more than the defined 'MaxParamCountForInCondition' elements in more
    # then one statements combined with OR, because some databases e.g. oracle doesn't support more
    # than 1000 elements for one IN statement.
    while ( scalar @Values ) {

        my @ValuesPart;
        if ( $Self->GetDatabaseFunction('MaxParamCountForInCondition') ) {
            @ValuesPart = splice @Values, 0, $Self->GetDatabaseFunction('MaxParamCountForInCondition');
        }
        else {
            @ValuesPart = splice @Values;
        }

        my $ValueString;
        if ( $Param{BindMode} ) {
            $ValueString = join ', ', ('?') x scalar @ValuesPart;
            push @BindValues, @ValuesPart;
        }
        elsif ($IsString) {
            $ValueString = join ', ', map {"'$_'"} @ValuesPart;
        }
        else {
            $ValueString = join ', ', @ValuesPart;
        }

        push @SQLStrings, "$Param{Key} $Operator ($ValueString)";
    }

    my $SQL = join " $Connector ", @SQLStrings;

    if ( scalar @SQLStrings > 1 ) {
        $SQL = '( ' . $SQL . ' )';
    }

    if ( $Param{BindMode} ) {
        my $BindRefList = [ map { \$_ } @BindValues ];
        return (
            'SQL'    => $SQL,
            'Values' => $BindRefList,
        );
    }
    return $SQL;
}

=head2 QueryStringEscape()

escapes special characters within a query string

    my $QueryStringEscaped = $DBObject->QueryStringEscape(
        QueryString => 'customer with (brackets) and & and -',
    );

    Result would be a string in which all special characters are escaped.
    Special characters are those which are returned by _SpecialCharactersGet().

    $QueryStringEscaped = 'customer with \(brackets\) and \& and \-';

=cut

sub QueryStringEscape {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(QueryString)) {
        if ( !defined $Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!"
            );
            return;
        }
    }

    # Merge all special characters into one string, separated by \\
    my $SpecialCharacters = '\\' . join '\\', keys %{ $Self->_SpecialCharactersGet() };

    # Use above string of special characters as character class
    # note: already escaped special characters won't be escaped again
    $Param{QueryString} =~ s{(?<!\\)([$SpecialCharacters])}{\\$1}smxg;

    return $Param{QueryString};
}

=head2 Ping()

checks if the database is reachable

    my $Success = $DBObject->Ping(
        AutoConnect => 0,  # default 1
    );

=cut

sub Ping {
    my ( $Self, %Param ) = @_;

    # debug
    if ( $Self->{Debug} > 2 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'debug',
            Message  => 'DB.pm->Ping',
        );
    }

    if ( !defined $Param{AutoConnect} || $Param{AutoConnect} ) {
        return if !$Self->Connect();
    }
    else {
        return if !$Self->{dbh};
    }

    return $Self->{dbh}->ping();
}

=begin Internal:

=cut

sub _Decrypt {
    my ( $Self, $Pw ) = @_;

    my $Length = length($Pw) * 4;
    $Pw = pack "h$Length", $1;
    $Pw = unpack "B$Length", $Pw;
    $Pw =~ s/1/A/g;
    $Pw =~ s/0/1/g;
    $Pw =~ s/A/0/g;
    $Pw = pack "B$Length", $Pw;

    return $Pw;
}

sub _Encrypt {
    my ( $Self, $Pw ) = @_;

    my $Length = length($Pw) * 8;
    chomp $Pw;

    # get bit code
    my $T = unpack( "B$Length", $Pw );

    # crypt bit code
    $T =~ s/1/A/g;
    $T =~ s/0/1/g;
    $T =~ s/A/0/g;

    # get ascii code
    $T = pack( "B$Length", $T );

    # get hex code
    my $H = unpack( "h$Length", $T );

    return $H;
}

sub _TypeCheck {
    my ( $Self, $Tag ) = @_;

    if (
        $Tag->{Type}
        && $Tag->{Type} !~ /^(DATE|SMALLINT|BIGINT|INTEGER|DECIMAL|VARCHAR|LONGBLOB)$/i
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'Error',
            Message  => "Unknown data type '$Tag->{Type}'!",
        );
    }

    return 1;
}

sub _NameCheck {
    my ( $Self, $Tag ) = @_;

    if ( $Tag->{Name} && length $Tag->{Name} > 30 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'Error',
            Message  => "Table names should not have more the 30 chars ($Tag->{Name})!",
        );
    }

    return 1;
}

sub _SpecialCharactersGet {
    my ( $Self, %Param ) = @_;

    my %SpecialCharacter = (
        '(' => 1,
        ')' => 1,
        '&' => 1,
        '|' => 1,
    );

    return \%SpecialCharacter;
}

sub DESTROY {
    my $Self = shift;

    # cleanup open statement handle if there is any and then disconnect from DB
    if ( $Self->{Cursor} ) {
        $Self->{Cursor}->finish();
    }
    $Self->Disconnect();

    return 1;
}

1;

=end Internal:

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
