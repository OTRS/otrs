# --
# Kernel/System/DB/maxdb.pm - maxdb database backend
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: maxdb.pm,v 1.9 2006-11-17 10:21:09 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::DB::maxdb;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.9 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    return $Self;
}

sub LoadPreferences {
    my $Self = shift;
    my %Param = @_;

    # db settings
    $Self->{'DB::Limit'} = 0;
    $Self->{'DB::DirectBlob'} = 0;
    $Self->{'DB::QuoteSingle'} = '\'';
    $Self->{'DB::QuoteBack'} = 0;
    $Self->{'DB::QuoteSemicolon'} = '\'';
    $Self->{'DB::Attribute'} = {
        LongTruncOk => 1,
        LongReadLen => 100*1024,
    };
    $Self->{'DB::CurrentTimestamp'} = 'timestamp';

    # shell setting
    $Self->{'DB::Comment'} = '// ';
    $Self->{'DB::ShellCommit'} = "\n//";

    return 1;
}

sub DatabaseCreate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Name}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Name!");
        return;
    }
    # return SQL
    return ("CREATE DATABASE $Param{Name}");
}

sub DatabaseDrop {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Name}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Name!");
        return;
    }
    # return SQL
    return ("DROP DATABASE $Param{Name}");
}

sub TableCreate {
    my $Self = shift;
    my @Param = @_;
    my $SQLStart = '';
    my $SQLEnd = '';
    my $SQL = '';
    my @Column = ();
    my $TableName = '';
    my $ForeignKey = ();
    my %Foreign = ();
    my $IndexCurrent = ();
    my %Index = ();
    my $UniqCurrent = ();
    my %Uniq = ();
    my $PrimaryKey = '';
    my @Return = ();
    foreach my $Tag (@Param) {
        if ($Tag->{Tag} eq 'Table' && $Tag->{TagType} eq 'Start') {
            $SQLStart .= $Self->{'DB::Comment'}."----------------------------------------------------------\n";
            $SQLStart .= $Self->{'DB::Comment'}." create table $Tag->{Name}\n";
            $SQLStart .= $Self->{'DB::Comment'}."----------------------------------------------------------\n";
        }
        if (($Tag->{Tag} eq 'Table' || $Tag->{Tag} eq 'TableCreate') && $Tag->{TagType} eq 'Start') {
            $SQLStart .= "CREATE TABLE $Tag->{Name} (\n";
            $TableName = $Tag->{Name};
        }
        if (($Tag->{Tag} eq 'Table' || $Tag->{Tag} eq 'TableCreate') && $Tag->{TagType} eq 'End') {
            $SQLEnd .= ")";
        }
        elsif ($Tag->{Tag} eq 'Column' && $Tag->{TagType} eq 'Start') {
            push (@Column, $Tag);
        }
        elsif ($Tag->{Tag} eq 'Index' && $Tag->{TagType} eq 'Start') {
            $IndexCurrent = $Tag->{Name};
        }
        elsif ($Tag->{Tag} eq 'IndexColumn' && $Tag->{TagType} eq 'Start') {
            push (@{$Index{$IndexCurrent}}, $Tag);
        }
        elsif ($Tag->{Tag} eq 'Unique' && $Tag->{TagType} eq 'Start') {
            $UniqCurrent = $Tag->{Name} || $TableName.'_U_'.int(rand(999));
        }
        elsif ($Tag->{Tag} eq 'UniqueColumn' && $Tag->{TagType} eq 'Start') {
            push (@{$Uniq{$UniqCurrent}}, $Tag);
        }
        elsif ($Tag->{Tag} eq 'ForeignKey' && $Tag->{TagType} eq 'Start') {
            $ForeignKey = $Tag->{ForeignTable};
        }
        elsif ($Tag->{Tag} eq 'Reference' && $Tag->{TagType} eq 'Start') {
            push (@{$Foreign{$ForeignKey}}, $Tag);
        }
    }
    foreach my $Tag (@Column) {
        # type translation
        $Tag = $Self->_TypeTranslation($Tag);
        # type translation
        if ($SQL) {
            $SQL .= ",\n";
        }
        # auto increment
        if ($Tag->{AutoIncrement} && $Tag->{AutoIncrement} =~ /^true$/i) {
            $SQL = "    $Tag->{Name} serial";
        }
        # normal data type
        else {
            $SQL .= "    $Tag->{Name} $Tag->{Type}";
            if ($Tag->{Required} =~ /^true$/i) {
                $SQL .= " NOT NULL";
            }
        }
        # add primary key
        if ($Tag->{PrimaryKey} && $Tag->{PrimaryKey} =~ /true/i) {
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
    foreach my $Name (keys %Uniq) {
        if ($SQL) {
            $SQL .= ",\n";
        }
        $SQL .= "    UNIQUE (";
        my @Array = @{$Uniq{$Name}};
        foreach (0..$#Array) {
            if ($_ > 0) {
                $SQL .= ", ";
            }
            $SQL .= $Array[$_]->{Name};
        }
        $SQL .= ")";
    }
    $SQL .= "\n";
    push(@Return, $SQLStart.$SQL.$SQLEnd);
    # add indexs
    foreach my $Name (keys %Index) {
        push (@Return, $Self->IndexCreate(
            TableName => $TableName,
            Name => $Name,
            Data => $Index{$Name},
        ));
    }
    # add uniq
#    foreach my $Name (keys %Uniq) {
#        push (@Return, $Self->UniqueCreate(
#            TableName => $TableName,
#            Name => $Name,
#            Data => $Uniq{$Name},
#        ));
#    }
    # add foreign keys
    foreach my $ForeignKey (keys %Foreign) {
        my @Array = @{$Foreign{$ForeignKey}};
        foreach (0..$#Array) {
            push (@{$Self->{Post}}, $Self->ForeignKeyCreate(
                LocalTableName => $TableName,
                Local => $Array[$_]->{Local},
                ForeignTableName => $ForeignKey,
                Foreign => $Array[$_]->{Foreign},
            ));
        }
    }
    return @Return;
}

sub TableDrop {
    my $Self = shift;
    my @Param = @_;
    my $SQL = '';
    foreach my $Tag (@Param) {
        if ($Tag->{Tag} eq 'Table' && $Tag->{TagType} eq 'Start') {
            $SQL .= $Self->{'DB::Comment'}."----------------------------------------------------------\n";
            $SQL .= $Self->{'DB::Comment'}." drop table $Tag->{Name}\n";
            $SQL .= $Self->{'DB::Comment'}."----------------------------------------------------------\n";
        }
        $SQL .= "DROP TABLE $Tag->{Name}";
        return ($SQL);
    }
    return ();
}

sub TableAlter {
    my $Self = shift;
    my @Param = @_;
    my $SQLStart = '';
    my @SQL = ();
    foreach my $Tag (@Param) {
        if ($Tag->{Tag} eq 'TableAlter' && $Tag->{TagType} eq 'Start') {
            $SQLStart .= "ALTER TABLE $Tag->{Name}";
        }
        elsif ($Tag->{Tag} eq 'ColumnAdd' && $Tag->{TagType} eq 'Start') {
            # Type translation
            $Tag = $Self->_TypeTranslation($Tag);
            # normal data type
            my $SQLEnd = $SQLStart." ADD $Tag->{Name} $Tag->{Type}";
            if ($Tag->{Required} && $Tag->{Required} =~ /^true$/i) {
                $SQLEnd .= " NOT NULL";
            }
            # auto increment
            if ($Tag->{AutoIncrement} && $Tag->{AutoIncrement} =~ /^true$/i) {
                $SQLEnd .= " AUTO_INCREMENT";
            }
            # add primary key
            if ($Tag->{PrimaryKey} && $Tag->{PrimaryKey} =~ /true/i) {
                $SQLEnd .= " PRIMARY KEY($Tag->{Name})";
            }
            push (@SQL, $SQLEnd);
        }
        elsif ($Tag->{Tag} eq 'ColumnChange' && $Tag->{TagType} eq 'Start') {
            # Type translation
            $Tag = $Self->_TypeTranslation($Tag);
            # normal data type
            my $SQLEnd = $SQLStart." CHANGE $Tag->{NameOld} $Tag->{NameNew} $Tag->{Type}";
            if ($Tag->{Required} && $Tag->{Required} =~ /^true$/i) {
                $SQLEnd .= " NOT NULL";
            }
            # auto increment
            if ($Tag->{AutoIncrement} && $Tag->{AutoIncrement} =~ /^true$/i) {
                $SQLEnd .= " AUTO_INCREMENT";
            }
            # add primary key
            if ($Tag->{PrimaryKey} && $Tag->{PrimaryKey} =~ /true/i) {
                $SQLEnd .= " PRIMARY KEY($Tag->{Name})";
            }
            push (@SQL, $SQLEnd);
        }
        elsif ($Tag->{Tag} eq 'ColumnDrop' && $Tag->{TagType} eq 'Start') {
            my $SQLEnd = $SQLStart." DROP $Tag->{Name}";
            push (@SQL, $SQLEnd);
        }
    }
    return @SQL;
}

sub IndexCreate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TableName Name Data)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my $Index = substr($Param{Name}, 0, 20);
    if (length($Index) >= 20) {
         $Index .= int(rand(99));
    }
    my $SQL = "CREATE INDEX $Index ON $Param{TableName} (";
    my @Array = @{$Param{'Data'}};
    foreach (0..$#Array) {
        if ($_ > 0) {
            $SQL .= ", ";
        }
        $SQL .= $Array[$_]->{Name};
        if ($Array[$_]->{Size}) {
#           $SQL .= "($Array[$_]->{Size})";
        }
    }
    $SQL .= ")";
    # return SQL
    return ($SQL);

}

sub IndexDrop {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TableName Name)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my $SQL = "DROP INDEX $Param{Name}";
    return ($SQL);
}

sub ForeignKeyCreate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(LocalTableName Local ForeignTableName Foreign)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my $SQL = "ALTER TABLE $Param{LocalTableName} ADD FOREIGN KEY (";
    $SQL .= "$Param{Local}) REFERENCES ";
    $SQL .= "$Param{ForeignTableName}($Param{Foreign})";
    # return SQL
    return ($SQL);
}

sub ForeignKeyDrop {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TableName Name)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
#    my $SQL = "ALTER TABLE $Param{TableName} DROP CONSTRAINT $Param{Name}";
#    return ($SQL);
}

sub UniqueCreate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TableName Name Data)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my $SQL = "ALTER TABLE $Param{TableName} ADD CONSTRAINT $Param{Name} UNIQUE (";
    my @Array = @{$Param{'Data'}};
    foreach (0..$#Array) {
        if ($_ > 0) {
            $SQL .= ", ";
        }
        $SQL .= $Array[$_]->{Name};
    }
    $SQL .= ")";
    # return SQL
    return ($SQL);

}

sub UniqueDrop {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TableName Name)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my $SQL = "ALTER TABLE $Param{TableName} DROP CONSTRAINT $Param{Name}";
    return ($SQL);
}

sub _TypeTranslation {
    my $Self = shift;
    my $Tag = shift;
    # type translation
    if ($Tag->{Type} =~ /^DATE$/i) {
        $Tag->{Type} = 'timestamp';
    }
    # performance option
    elsif ($Tag->{Type} =~ /^longblob$/i) {
        $Tag->{Type} = 'LONG';
    }
    elsif ($Tag->{Type} =~ /^VARCHAR$/i) {
        $Tag->{Type} = "VARCHAR ($Tag->{Size})";
        if ($Tag->{Size} >= 4000) {
            $Tag->{Type} = "LONG";
        }
    }
    elsif ($Tag->{Type} =~ /^DECIMAL$/i) {
        $Tag->{Type} = "DECIMAL ($Tag->{Size})";
    }
    return $Tag;
}
1;
