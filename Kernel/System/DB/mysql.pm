# --
# Kernel/System/DB/mysql.pm - mysql database backend
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: mysql.pm,v 1.8 2006-08-29 17:31:42 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::DB::mysql;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.8 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub LoadPreferences {
    my $Self = shift;
    my %Param = @_;

    # db settings
    $Self->{'DB::Limit'} = 'limit';
    $Self->{'DB::DirectBlob'} = 1;
    $Self->{'DB::QuoteSingle'} = '\\';
    $Self->{'DB::QuoteBack'} = '\\';
    $Self->{'DB::QuoteSemicolon'} = '\\';
    $Self->{'DB::Attribute'} = {};

    # shell setting
    $Self->{'DB::Comment'} = '# ';
    $Self->{'DB::ShellCommit'} = ';';

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
    return ("DROP DATABASE IF EXISTS $Param{Name}");
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
        $Tag = $Self->_TypeTranslation($Tag);
        if ($SQL) {
            $SQL .= ",\n";
        }
        # normal data type
        $SQL .= "    $Tag->{Name} $Tag->{Type}";
        if ($Tag->{Required} =~ /^true$/i) {
            $SQL .= " NOT NULL";
        }
        # auto increment
        if ($Tag->{AutoIncrement} && $Tag->{AutoIncrement} =~ /^true$/i) {
            $SQL .= " AUTO_INCREMENT";
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
    # add index
    foreach my $Name (keys %Index) {
        if ($SQL) {
            $SQL .= ",\n";
        }
        $SQL .= "    INDEX $Name (";
        my @Array = @{$Index{$Name}};
        foreach (0..$#Array) {
            if ($_ > 0) {
                $SQL .= ", ";
            }
            $SQL .= $Array[$_]->{Name};
            if ($Array[$_]->{Size}) {
                $SQL .= "($Array[$_]->{Size})";
            }
        }
        $SQL .= ")";
    }
    $SQL .= "\n";
    push(@Return, $SQLStart.$SQL.$SQLEnd);
    # add indexs
#    foreach my $Name (keys %Index) {
#        push (@Return, $Self->IndexCreate(
#            TableName => $TableName,
#            Name => $Name,
#            Data => $Index{$Name},
#        ));
#    }
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
        $SQL .= "DROP TABLE IF EXISTS $Tag->{Name}";
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
    my $SQL = "CREATE INDEX $Param{Name} ON $Param{TableName} (";
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
    $SQL .= "`$Param{ForeignTableName}($Param{Foreign})`";
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
sub Insert {
    my $Self = shift;
    my @Param = @_;
    my $SQL = '';
    my @Keys = ();
    my @Values = ();
    foreach my $Tag (@Param) {
        if ($Tag->{Tag} eq 'Insert' && $Tag->{TagType} eq 'Start') {
            $SQL = "INSERT INTO $Tag->{Table} "
        }
        if ($Tag->{Tag} eq 'Data' && $Tag->{TagType} eq 'Start') {
            $Tag->{Key} = $Self->Quote($Tag->{Key});
            push (@Keys, $Tag->{Key});
            if ($Tag->{Type} && $Tag->{Type} eq 'Quote') {
                $Tag->{Value} = "'".$Self->Quote($Tag->{Value})."'";
            }
            else {
                $Tag->{Value} = $Self->Quote($Tag->{Value});
            }
            push (@Values, $Tag->{Value});
        }
    }
    my $Key = '';
    foreach (@Keys) {
        if ($Key) {
            $Key .= ",";
        }
        $Key .= $_;
    }
    my $Value = '';
    foreach (@Values) {
        if ($Value) {
            $Value .= ",";
        }
        $Value .= $_;
    }
    $SQL .= "($Key) VALUES ($Value)";
    return ($SQL);
}
sub _TypeTranslation {
    my $Self = shift;
    my $Tag = shift;
    if ($Tag->{Type} =~ /^DATE$/i) {
        $Tag->{Type} = 'DATETIME';
    }
    if ($Tag->{Type} =~ /^VARCHAR$/i) {
        if ($Tag->{Size} > 16777215) {
            $Tag->{Type} = "LONGTEXT";
        }
        elsif ($Tag->{Size} > 65535) {
            $Tag->{Type} = "MEDIUMTEXT";
        }
        elsif ($Tag->{Size} > 255) {
            $Tag->{Type} = "TEXT";
        }
        else {
            $Tag->{Type} = "VARCHAR ($Tag->{Size})";
        }
    }
    if ($Tag->{Type} =~ /^DECIMAL$/i) {
        $Tag->{Type} = "DECIMAL ($Tag->{Size})";
    }
    return $Tag;
}
1;
