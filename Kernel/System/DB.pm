# --
# Kernel/System/DB.pm - the global database wrapper to support different databases 
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: DB.pm,v 1.28 2003-07-07 13:46:11 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::DB;

use strict;
use DBI;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.28 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
   
    # allocate new hash for object 
    my $Self = {}; 
    bless ($Self, $Type);

    # 0=off; 1=updates; 2=+selects; 3=+Connects;
    $Self->{Debug} = 0;

    # check needed objects
    foreach (qw(ConfigObject LogObject)) {
        if ($Param{$_}) {
            $Self->{$_} = $Param{$_};
        }
        else {
            die "Got no $_!";
        }
    } 
    # get config data
    $Self->{DSN}  = $Param{DatabaseDSN} || $Self->{ConfigObject}->Get('DatabaseDSN');
    $Self->{USER} = $Param{DatabaseUser} || $Self->{ConfigObject}->Get('DatabaseUser');
    $Self->{PW}   = $Param{DatabasePw} || $Self->{ConfigObject}->Get('DatabasePw');
    # get database type (auto detection)
    if ($Self->{DSN} =~ /:mysql/i) {
        $Self->{'DB::Type'} = 'mysql';
    }
    elsif ($Self->{DSN} =~ /:Pg/i) {
        $Self->{'DB::Type'} = 'postgresql';
    }
    elsif ($Self->{DSN} =~ /:db2/i) {
        $Self->{'DB::Type'} = 'db2';
    }
    elsif ($Self->{DSN} =~ /:odbc/i) {
        $Self->{'DB::Type'} = 'odbc';
    }
    else {
        $Self->{'DB::Type'} = 'generic';
    }
    # get database type (config option)
    if ($Self->{ConfigObject}->Get("Database::Type")) {
        $Self->{'DB::Type'} = $Self->{ConfigObject}->Get("Database::Type");
    }
    # set database functions
    if ($Self->{'DB::Type'} eq 'mysql') {
        $Self->{'DB::Limit'} = 'limit';
        $Self->{'DB::DirectBlob'} = 1;
        $Self->{'DB::QuoteSignle'} = '\\';
        $Self->{'DB::QuoteBack'} = '\\';
        $Self->{'DB::Attribute'} = {};
    }
    elsif ($Self->{'DB::Type'} eq 'postgresql') {
        $Self->{'DB::Limit'} = 'limit';
        $Self->{'DB::DirectBlob'} = 0;
        $Self->{'DB::QuoteSignle'} = '\\';
        $Self->{'DB::QuoteBack'} = '\\';
        $Self->{'DB::Attribute'} = {};
    }
    elsif ($Self->{'DB::Type'} eq 'db2') {
        $Self->{'DB::Limit'} = 'fetch';
        $Self->{'DB::DirectBlob'} = 0;
        $Self->{'DB::QuoteSignle'} = '\\';
        $Self->{'DB::QuoteBack'} = '\\';
        $Self->{'DB::Attribute'} = {};
    }
    elsif ($Self->{'DB::Type'} eq 'sapdb') {
        $Self->{'DB::Limit'} = 0;
        $Self->{'DB::DirectBlob'} = 0;
        $Self->{'DB::QuoteSignle'} = '\'';
        $Self->{'DB::QuoteBack'} = '';
        $Self->{'DB::Attribute'} = {
            LongTruncOk => 1,
            LongReadLen => 100*1024,
        };
        $Self->{'DB::CurrentTimestamp'} = 'timestamp';
    }
    elsif ($Self->{'DB::Type'} eq 'generic') {
        $Self->{'DB::QuoteSignle'} = '\\';
        $Self->{'DB::QuoteBack'} = '\\';
        $Self->{'DB::Limit'} = 0;
        $Self->{'DB::DirectBlob'} = 0;
        $Self->{'DB::Attribute'} = {
            LongTruncOk => 1,
            LongReadLen => 100*1024,
        };
    }
    else {
        $Self->{LogObject}->Log(
          Priority => 'Error',
          Message => "Unknown database type $Self->{'DB::Type'}! Set config ".
              "option DB::Type to (mysql|postgresql|db2|sapdb|generic)"
        );
        return;
    }
    # check/get extra database config options
    # (overwrite auto detection)
    foreach (qw(Type Limit DirectBlob Attribute QuoteSingle QuoteBack)) {
        if (defined($Self->{ConfigObject}->Get("Database::$_"))) {
            $Self->{"DB::$_"} = $Self->{ConfigObject}->Get("Database::$_");
        }
    }
    # do database connect 
    if (!$Self->Connect()) {
        return;
    }
    return $Self;
}
# --
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
# --
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
# --
sub GetDatabaseFunction {
    my $Self = shift;
    my $What = shift;
    return $Self->{'DB::'.$What};
}
# --
sub Quote {
    my $Self = shift;
    my $Text = shift;
    if (!defined $Text) {
        return;
    }
    # do quote
    if ($Self->{'DB::QuoteBack'}) {
        $Text =~ s/\\/$Self->{'DB::QuoteBack'}\\/g;
    }
    if ($Self->{'DB::QuoteSignle'}) {
        $Text =~ s/'/$Self->{'DB::QuoteSignle'}'/g;
    }
    return $Text;
}
# --
sub Do {
    my $Self = shift;
    my %Param = @_;
    my $SQL = $Param{SQL};
    # debug
    if ($Self->{Debug} > 0) {
        $Self->{DoCounter}++;
        $Self->{LogObject}->Log(
          Caller => 1,
          Priority => 'debug',
          Message => "DB.pm->Do ($Self->{DoCounter}) SQL: '$SQL'",
        );
    }
    # doing
    if ($Self->{'DB::CurrentTimestamp'}) {
        $SQL =~ s/current_timestamp/$Self->{'DB::CurrentTimestamp'}/g;
    }
    if (!$Self->{dbh}->do($SQL)) {
        $Self->{LogObject}->Log(
          Caller => 1,
          Priority => 'Error',
          Message => "$DBI::errstr, SQL: '$SQL'",
        );
        return;
    }
    return 1;
}
# --
sub Prepare {
    my $Self = shift;
    my %Param = @_;
    my $SQL = $Param{SQL};
    my $Limit = $Param{Limit} || '';
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
# --
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
    return $Self->{Curser}->fetchrow_array();
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
# --
sub Error {
    my $Self = shift;
    return $DBI::errstr;
}
# --
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
# --
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
# --
sub DESTROY {
    my $Self = shift;
    $Self->Disconnect();
}
# --

1;
