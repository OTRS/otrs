# --
# Kernel/System/DB.pm - the global database wrapper to support different databases
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: DB.pm,v 1.47.2.1 2005-12-01 11:07:13 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::DB;

use strict;
use DBI;
use Kernel::System::Time;
use Kernel::System::Encode;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.47.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::DB - global database interface

=head1 SYNOPSIS

All database functions to connect/insert/update/delete/... to a database.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create database object with database connect

  use Kernel::Config;
  use Kernel::System::Log;
  use Kernel::System::DB;

  my $ConfigObject = Kernel::Config->new();
  my $LogObject    = Kernel::System::Log->new(
      ConfigObject => $ConfigObject,
  );

  $DBObject = Kernel::System::DB->new(
      ConfigObject => $ConfigObject,
      LogObject    => $LogObject,
      # if you don't use the follow params, then this are used
      # from Kernel/Config.pm!
      DatabaseDSN  => 'DBI:odbc:database=123;host=localhost;',
      DatabaseUser => 'user',
      DatabasePw   => 'somepass',
      Type         => 'mysql',
      Attribute    => {
          LongTruncOk => 1,
          LongReadLen => 100*1024,
      },
  );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # 0=off; 1=updates; 2=+selects; 3=+Connects;
    $Self->{Debug} = $Param{Debug} || 0;

    # check needed objects
    foreach (qw(ConfigObject LogObject)) {
        if ($Param{$_}) {
            $Self->{$_} = $Param{$_};
        }
        else {
            die "Got no $_!";
        }
    }
    # encode object
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);
    # time object
    $Self->{TimeObject} = Kernel::System::Time->new(%Param);
    # get config data
    $Self->{DSN}  = $Param{DatabaseDSN} || $Self->{ConfigObject}->Get('DatabaseDSN');
    $Self->{USER} = $Param{DatabaseUser} || $Self->{ConfigObject}->Get('DatabaseUser');
    $Self->{PW}   = $Param{DatabasePw} || $Self->{ConfigObject}->Get('DatabasePw');
    # decrypt pw (if needed)
    if ($Self->{PW} =~ /^\{(.*)\}$/) {
        my $Length = length($1)*4;
        $Self->{PW} = pack("h$Length", $1);
        $Self->{PW} = unpack("B$Length", $Self->{PW});
        $Self->{PW} =~ s/1/A/g;
        $Self->{PW} =~ s/0/1/g;
        $Self->{PW} =~ s/A/0/g;
        $Self->{PW} = pack("B$Length", $Self->{PW});
    }
    # get database type (auto detection)
    if ($Self->{DSN} =~ /:mysql/i) {
        $Self->{'DB::Type'} = 'mysql';
    }
    elsif ($Self->{DSN} =~ /:pg/i) {
        $Self->{'DB::Type'} = 'postgresql';
    }
    elsif ($Self->{DSN} =~ /:oracle/i) {
        $Self->{'DB::Type'} = 'oracle';
    }
    elsif ($Self->{DSN} =~ /:sapdb/i) {
        $Self->{'DB::Type'} = 'maxdb';
    }
    elsif ($Self->{DSN} =~ /:maxdb/i) {
        $Self->{'DB::Type'} = 'maxdb';
    }
    elsif ($Self->{DSN} =~ /:db2/i) {
        $Self->{'DB::Type'} = 'db2';
    }

    # get database type (config option)
    if ($Self->{ConfigObject}->Get("Database::Type")) {
        $Self->{'DB::Type'} = $Self->{ConfigObject}->Get("Database::Type");
    }
    # get database type (overwrite with params)
    if ($Param{Type}) {
        $Self->{'DB::Type'} = $Param{Type};
    }

    # load backend module
    if ($Self->{'DB::Type'}) {
        my $GenericModule = "Kernel::System::DB::$Self->{'DB::Type'}";
        if (!eval "require $GenericModule") {
            die "Can't load database backend module $GenericModule! $@";
        }
        @ISA = ($GenericModule);
        # set database functions
        $Self->LoadPreferences();
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'Error',
            Message => "Unknown database type! Set option Database::Type in ".
              "Kernel/Config.pm to (mysql|postgresql|maxdb|oracle|db2|mssql).",
        );
        return;
    }

    # check/get extra database config options
    # (overwrite auto detection with config options)
    foreach (qw(Type Limit DirectBlob Attribute QuoteSingle QuoteBack)) {
        if (defined($Self->{ConfigObject}->Get("Database::$_"))) {
            $Self->{"DB::$_"} = $Self->{ConfigObject}->Get("Database::$_");
        }
    }
    # check/get extra database config options
    # (overwrite with params)
    foreach (qw(Type Limit DirectBlob Attribute QuoteSingle QuoteBack)) {
        if (defined($Param{$_})) {
            $Self->{"DB::$_"} = $Param{$_};
        }
    }
    # do database connect
    if (!$Self->Connect()) {
        return;
    }
    return $Self;
}

=item Connect()

to connect to a database

=cut

sub Connect {
    my $Self = shift;
    # debug
    if ($Self->{Debug} > 2) {
        $Self->{LogObject}->Log(
          Caller => 1,
          Priority => 'debug',
          Message => "DB.pm->Connect: DSN: $Self->{DSN}, User: $Self->{USER}, Pw: $Self->{PW}, DB Type: $Self->{'DB::Type'};",
        );
    }
    # db connect
    if (!($Self->{dbh} = DBI->connect("$Self->{DSN}", $Self->{USER}, $Self->{PW}, $Self->{'DB::Attribute'}))) {
        $Self->{LogObject}->Log(
          Caller => 1,
          Priority => 'Error',
          Message => $DBI::errstr,
        );
        return;
    }
    return $Self->{dbh};
}

=item Disconnect()

to disconnect to a database

=cut

sub Disconnect {
    my $Self = shift;
    # debug
    if ($Self->{Debug} > 2) {
        $Self->{LogObject}->Log(
          Caller => 1,
          Priority => 'debug',
          Message => "DB.pm->Disconnect",
        );
    }
    # do disconnect
    $Self->{dbh}->disconnect() if ($Self->{dbh});
    return 1;
}

=item Quote()

to quote sql params

  quote strings:
  ==============
  my $DBString = $DBObject->Quote("This isn't a problem!");

  quote integers:
  ===============
  my $DBString = $DBObject->Quote(1234, 'Integer');

  quote numbers (e. g. 1, 1.4, 42342.23424):
  ==========================================
  my $DBString = $DBObject->Quote(1234, 'Number');

=cut

sub Quote {
    my $Self = shift;
    my $Text = shift;
    my $Type = shift;
    if (!defined $Text) {
        return;
    }

    # do quote integer
    if ($Type && $Type eq 'Integer') {
        if ($Text !~ /^(\+|\-|)\d{1,16}$/) {
            $Self->{LogObject}->Log(
                Caller => 1,
                Priority => 'error',
                Message => "Invalid integer in query '$Text'!",
            );
            return '';
        }
        return $Text;
    }
    # numbers
    elsif ($Type && $Type eq 'Number') {
        if ($Text !~ /^(\+|\-|)(\d{1,20}|\d{1,20}\.\d{1,20})$/) {
            $Self->{LogObject}->Log(
                Caller => 1,
                Priority => 'error',
                Message => "Invalid number in query '$Text'!",
            );
            return '';
        }
        return $Text;
    }
    # do quote string
    elsif (!defined($Type)) {
        if ($Self->{'DB::QuoteBack'}) {
            $Text =~ s/\\/$Self->{'DB::QuoteBack'}\\/g;
        }
        if ($Self->{'DB::QuoteSingle'}) {
            $Text =~ s/'/$Self->{'DB::QuoteSingle'}'/g;
        }
        if ($Self->{'DB::QuoteSemicolon'}) {
            $Text =~ s/;/$Self->{'DB::QuoteSemicolon'};/g;
        }
        return $Text;
    }
    else {
        $Self->{LogObject}->Log(
            Caller => 1,
            Priority => 'error',
            Message => "Invalid quote type '$Type'!",
        );
        return '';
    }
}

=item Error()

to get database errors back

  my $ErrorMessage = $DBObject->Error();

=cut

sub Error {
    my $Self = shift;
    return $DBI::errstr;
}

=item Do()

to insert, update or delete something

  $DBObject->Do(SQL => "INSERT INTO table (name) VALUES ('dog')");

  $DBObject->Do(SQL => "DELETE FROM table");


  you also can use DBI bind values (used for large strings):

  my $Var1 = 'dog1';
  my $Var2 = 'dog2';

  $DBObject->Do(
      SQL => "INSERT INTO table (name1, name2) VALUES (?, ?)",
      Bind => [\$Var1, \$Var2],
  );

=cut

sub Do {
    my $Self = shift;
    my %Param = @_;
    my @Array = ();
    # check needed stuff
    if (!$Param{SQL}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need SQL!");
        return;
    }
    # check bind params
    if ($Param{Bind}) {
        foreach my $Data (@{$Param{Bind}}) {
            if (ref($Data) eq 'SCALAR') {
                push(@Array, $$Data);
            }
            else  {
                $Self->{LogObject}->Log(
                    Caller => 1,
                    Priority => 'Error',
                    Message => "No SCALAR param in Bind!",
                );
                return;
            }
        }
    }
    if (!$Self->{ConfigObject}->Get('TimeZone')) {
        # doing timestamp workaround (if needed)
        if ($Self->{'DB::CurrentTimestamp'}) {
            $Param{SQL} =~ s/current_timestamp/$Self->{'DB::CurrentTimestamp'}/g;
        }
    }
    else {
        # replace current_timestamp
        my $Timestamp = $Self->{TimeObject}->CurrentTimestamp();
        $Param{SQL} =~ s/(\s|\(|,| )current_timestamp(\s|\)|,| )/$1'$Timestamp'$2/g;
    }
    # debug
    if ($Self->{Debug} > 0) {
        $Self->{DoCounter}++;
        $Self->{LogObject}->Log(
          Caller => 1,
          Priority => 'debug',
          Message => "DB.pm->Do ($Self->{DoCounter}) SQL: '$Param{SQL}'",
        );
    }
    # send sql to database
    if (!$Self->{dbh}->do($Param{SQL}, undef, @Array)) {
        $Self->{LogObject}->Log(
          Caller => 1,
          Priority => 'Error',
          Message => "$DBI::errstr, SQL: '$Param{SQL}'",
        );
        return;
    }
    return 1;
}

=item Prepare()

to send a select something to the database

  $DBObject->Prepare(
      SQL => "SELECT id, name FROM table",
      Limit => 10
  );

=cut

sub Prepare {
    my $Self = shift;
    my %Param = @_;
    my $SQL = $Param{SQL};
    my $Limit = $Param{Limit} || '';
    # check needed stuff
    if (!$Param{SQL}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need SQL!");
        return;
    }
    $Self->{Limit} = 0;
    $Self->{LimitCounter} = 0;
    # build finally select query
    if ($Limit) {
        if ($Self->{'DB::Limit'} eq 'limit') {
            $SQL .= " LIMIT $Limit";
        }
        elsif ($Self->{'DB::Limit'} eq 'fetch') {
            $SQL .= " fetch $Limit first row";
        }
        else {
            $Self->{Limit} = $Limit;
        }
    }
    # debug
    if ($Self->{Debug} > 1) {
        $Self->{PrepareCounter}++;
        $Self->{LogObject}->Log(
          Caller => 1,
          Priority => 'debug',
          Message => "DB.pm->Prepare ($Self->{PrepareCounter}/".time().") SQL: '$SQL'",
        );
    }
    # do
    if (!($Self->{Curser} = $Self->{dbh}->prepare($SQL))) {
        $Self->{LogObject}->Log(
          Caller => 1,
          Priority => 'Error',
          Message => "$DBI::errstr, SQL: '$SQL'",
        );
        return;
    }
    if (!$Self->{Curser}->execute()) {
        $Self->{LogObject}->Log(
          Caller => 1,
          Priority => 'Error',
          Message => "$DBI::errstr, SQL: '$SQL'",
        );
        return;
    }
    return 1;
}

=item FetchrowArray()

to get a select return

  $DBObject->Prepare(
      SQL => "SELECT id, name FROM table",
      Limit => 10
  );

  while (my @Row = $DBObject->FetchrowArray()) {
      print "$Row[0]:$Row[1]\n";
  }

=cut

sub FetchrowArray {
    my $Self = shift;
    # work with cursers if database don't support limit
    if (!$Self->{'DB::Limit'} && $Self->{Limit}) {
        if ($Self->{Limit} <= $Self->{LimitCounter}) {
            $Self->{Curser}->finish();
            return;
        }
        $Self->{LimitCounter}++;
    }
    # return
    my @Row = $Self->{Curser}->fetchrow_array();
    # e. g. set utf-8 flag
    foreach (@Row) {
         $Self->{EncodeObject}->Encode(\$_);
    }
    return @Row;
}
# --
# _should_ not used because of database incompat.
sub FetchrowHashref {
    my $Self = shift;
    # work with cursers if database don't support limit
    if (!$Self->{'DB::Limit'} && $Self->{Limit}) {
        if ($Self->{Limit} <= $Self->{LimitCounter}) {
            $Self->{Curser}->finish();
            return;
        }
        $Self->{LimitCounter}++;
    }
    # return
    return $Self->{Curser}->fetchrow_hashref();
}

=item GetDatabaseFunction()

to get database functions like Limit, DirectBlob, ...

  my $What = $DBObject->GetDatabaseFunction('DirectBlob');

=cut

sub GetDatabaseFunction {
    my $Self = shift;
    my $What = shift;
    return $Self->{'DB::'.$What};
}

=item SQLProcessor()

generate database based sql syntax (e. g. CREATE TABLE ...)

  my @SQL = $DBObject->SQLProcessor(
    Database =>
      [
         Tag => 'TableCreate',
         Name => 'table_name',
      ],
      [
         Tag => 'Column',
         Name => 'col_name',
         Type => 'VARCHAR',
         Size => 150,
      ],
      [
         Tag => 'Column',
         Name => 'col_name2',
         Type => 'INTERGER',
      ],
      [
         Tag => 'TableEnd',
      ],
  );

=cut

sub SQLProcessor {
    my $Self = shift;
    my %Param = @_;
    my @SQL = ();
    if ($Param{Database} && ref($Param{Database}) eq 'ARRAY') {
        my @Table = ();
        foreach my $Tag (@{$Param{Database}}) {
#            print STDERR "$Tag->{Tag} $Tag->{TagType}------\n";
            if (($Tag->{Tag} eq 'Table' || $Tag->{Tag} eq 'TableCreate') && $Tag->{TagType} eq 'Start') {
                push (@Table, $Tag);
            }
            elsif (($Tag->{Tag} eq 'Table' || $Tag->{Tag} eq 'TableCreate') && $Tag->{TagType} eq 'End') {
                push (@Table, $Tag);
                push (@SQL, $Self->TableCreate(@Table));
                @Table = ();
            }
            elsif ($Tag->{Tag} eq 'Column' && $Tag->{TagType} eq 'Start') {
                push (@Table, $Tag);
            }
            elsif ($Tag->{Tag} eq 'Unique' && $Tag->{TagType} eq 'Start') {
                push (@Table, $Tag);
            }
            elsif ($Tag->{Tag} eq 'UniqueColumn' && $Tag->{TagType} eq 'Start') {
                push (@Table, $Tag);
            }
            elsif ($Tag->{Tag} eq 'Index' && $Tag->{TagType} eq 'Start') {
                push (@Table, $Tag);
            }
            elsif ($Tag->{Tag} eq 'IndexColumn' && $Tag->{TagType} eq 'Start') {
                push (@Table, $Tag);
            }
            elsif ($Tag->{Tag} eq 'ForeignKey' && $Tag->{TagType} eq 'Start') {
                push (@Table, $Tag);
            }
            elsif ($Tag->{Tag} eq 'Reference' && $Tag->{TagType} eq 'Start') {
                push (@Table, $Tag);
            }
            elsif ($Tag->{Tag} eq 'TableDrop' && $Tag->{TagType} eq 'Start') {
                push (@Table, $Tag);
                push (@SQL, $Self->TableDrop(@Table));
                @Table = ();
            }
            elsif ($Tag->{Tag} eq 'Insert' && $Tag->{TagType} eq 'Start') {
                push (@Table, $Tag);
            }
            elsif ($Tag->{Tag} eq 'Data' && $Tag->{TagType} eq 'Start') {
                push (@Table, $Tag);
            }
            elsif ($Tag->{Tag} eq 'Insert' && $Tag->{TagType} eq 'End') {
                push (@Table, $Tag);
                push (@SQL, $Self->Insert(@Table));
                @Table = ();
            }
        }
    }
    return @SQL;
}

=item SQLProcessorPost()

generate database based sql syntax, post data of SQLProcessor(),
e. g. foreign keys

  my @SQL = $DBObject->SQLProcessorPost();

=cut

sub SQLProcessorPost {
    my $Self = shift;
    my %Param = @_;
    my @SQL = ();
    if ($Self->{Post}) {
        my @Return = @{$Self->{Post}};
        undef $Self->{Post};
        return @Return;
    }
    else {
        return ();
    }
}

=item GetTableData()

to get table data back in a hash

  my %Users = $DBObject->GetTableData(
      What => 'id, name',
      Table => 'groups',
  );

=cut

sub GetTableData {
    my $Self = shift;
    my %Param = @_;
    my $Table = $Param{Table};
    my $What = $Param{What};
    my $Whare = $Param{Where} || '';
    my $Valid = $Param{Valid} || '';
    my $Clamp = $Param{Clamp} || '';
    my %Data;
    my $SQL = "SELECT $What FROM $Table ";
    $SQL .= " WHERE " . $Whare if ($Whare);
    $SQL .= " WHERE valid_id in ( ${\(join ', ', $Self->GetValidIDs())} )" if ((!$Whare) && ($Valid));
    $Self->Prepare(SQL => $SQL);
    while (my @Row = $Self->FetchrowArray()) {
        if ($Row[3]) {
            if ($Clamp) {
                $Data{$Row[0]} = "$Row[1] $Row[2] ($Row[3])";
            }
            else {
                $Data{$Row[0]} = "$Row[1] $Row[2] $Row[3]";
            }
        }
        elsif ($Row[2]) {
            if ($Clamp) {
                $Data{$Row[0]} = "$Row[1] ( $Row[2] )";
            }
            else {
                $Data{$Row[0]} = "$Row[1] $Row[2]";
            }
        }
        else {
            $Data{$Row[0]} = $Row[1];
        }
    }
    return %Data;
}

sub GetValidIDs {
    my $Self = shift;
    my %Param = @_;
    my @ValidIDs;
    if ($Self->{ValidIDs}) {
        my $ValidIDsTmp = $Self->{ValidIDs};
        @ValidIDs = @$ValidIDsTmp;
    }
    else {
        $Self->Prepare(SQL => "SELECT id FROM valid WHERE name = 'valid'");
        while (my @RowTmp = $Self->FetchrowArray()) {
            push(@ValidIDs, $RowTmp[0]);
        }
        $Self->{ValidIDs} = \@ValidIDs;
    }
    return @ValidIDs;
}

sub DESTROY {
    my $Self = shift;
    $Self->Disconnect();
}
1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.47.2.1 $ $Date: 2005-12-01 11:07:13 $

=cut
