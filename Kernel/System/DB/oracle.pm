# --
# Kernel/System/DB/oracle.pm - oracle database backend
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: oracle.pm,v 1.9 2005-11-29 21:23:42 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::DB::oracle;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.9 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub LoadPreferences {
    my $Self = shift;
    my %Param = @_;

    # db settings
    $Self->{'DB::Limit'} = 0;
    $Self->{'DB::DirectBlob'} = 0;
    $Self->{'DB::QuoteSingle'} = '\'';
    $Self->{'DB::QuoteBack'} = 0;
    $Self->{'DB::QuoteSemicolon'} = '';
    $Self->{'DB::Attribute'} = {
        LongTruncOk => 1,
        LongReadLen => 4*1024*1024,
    };

    # shell setting
    $Self->{'DB::Comment'} = '-- ';
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
    my @Return2 = ();
    foreach my $Tag (@Param) {
        if ($Tag->{Tag} eq 'Table' && $Tag->{TagType} eq 'Start') {
            $SQLStart .= $Self->{'DB::Comment'}."----------------------------------------------------------\n";
            $SQLStart .= $Self->{'DB::Comment'}." create table $Tag->{Name}\n";
            $SQLStart .= $Self->{'DB::Comment'}."----------------------------------------------------------\n";
        }
        if (($Tag->{Tag} eq 'Table' || $Tag->{Tag} eq 'TableCreate') && $Tag->{TagType} eq 'Start') {
            push (@Return, "DROP TABLE $Tag->{Name} CASCADE CONSTRAINTS");
            $SQLStart .= "CREATE TABLE $Tag->{Name} (\n";
            $TableName = $Tag->{Name};
        }
        if (($Tag->{Tag} eq 'Table' || $Tag->{Tag} eq 'TableCreate') && $Tag->{TagType} eq 'End') {
            $SQLEnd .= "\n)";
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
        # Type translation
        if ($Tag->{Type} =~ /^DATE$/i) {
#            $Tag->{Type} = 'DATETIME';
        }
        if ($Tag->{Type} =~ /^integer$/i) {
            $Tag->{Type} = 'NUMBER';
        }
        if ($Tag->{Type} =~ /^smallint$/i) {
            $Tag->{Type} = 'NUMBER (5, 0)';
        }
        if ($Tag->{Type} =~ /^bigint$/i) {
            $Tag->{Type} = 'NUMBER (20, 0)';
        }
        if ($Tag->{Type} =~ /^longblob$/i) {
            $Tag->{Type} = 'CLOB';
        }
        if ($Tag->{Type} =~ /^VARCHAR$/i) {
            $Tag->{Type} = "VARCHAR2 ($Tag->{Size})";
            if ($Tag->{Size}  > 4000) {
                $Tag->{Type} = "CLOB";
            }
        }
        if ($Tag->{Type} =~ /^DECIMAL$/i) {
            $Tag->{Type} = "DECIMAL ($Tag->{Size})";
        }
        if ($SQL) {
            $SQL .= ",\n";
        }
        # normal data type
        $SQL .= "    $Tag->{Name} $Tag->{Type}";
        if ($Tag->{Required} =~ /^true$/i) {
            $SQL .= " NOT NULL";
        }
        # add primary key
        my $Constraint = $TableName;
        if (length($Constraint) > 26) {
            $Constraint = substr($Constraint, 0, 24);
            $Constraint .= int(rand(99));
        }
        if ($Tag->{PrimaryKey} && $Tag->{PrimaryKey} =~ /true/i) {
            push (@Return2, "ALTER TABLE $TableName ADD CONSTRAINT $Constraint"."_PK PRIMARY KEY ($Tag->{Name})");
        }
        # auto increment
        if ($Tag->{AutoIncrement} && $Tag->{AutoIncrement} =~ /^true$/i) {
            my $Shell = '';
            if ($Self->{ConfigObject}->Get('Database::ShellOutput')) {
                $Shell = "/\n--";
            }
            push (@Return2, "DROP SEQUENCE $Constraint"."_seq");
            push (@Return2, "CREATE SEQUENCE $Constraint"."_seq");
            push (@Return2, "CREATE OR REPLACE TRIGGER $Constraint"."_s_t\nbefore insert on $TableName\nfor each row\nbegin\n    select $Constraint"."_seq.nextval\n    into :new.$Tag->{Name}\n    from dual;\nend;\n$Shell");
        }
    }
    # add uniq
    my $UniqCunter = 0;
    foreach my $Name (keys %Uniq) {
        $UniqCunter++;
        if ($SQL) {
            $SQL .= ",\n";
        }
        $SQL .= "    CONSTRAINT $TableName"."_U_$UniqCunter UNIQUE (";
        my @Array = @{$Uniq{$Name}};
        foreach (0..$#Array) {
            if ($_ > 0) {
                $SQL .= ", ";
            }
            $SQL .= $Array[$_]->{Name};
        }
        $SQL .= ")";
    }
    push(@Return, $SQLStart.$SQL.$SQLEnd, @Return2);
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
    my $Index = $Param{Name};
    if (length($Index) > 30) {
        $Index = substr($Index, 0, 28);
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
    my $ForeignKey = "fk_$Param{LocalTableName}_$Param{Local}_$Param{Foreign}";
    if (length($ForeignKey) > 30) {
        $ForeignKey = substr($ForeignKey, 0, 28);
        $ForeignKey .= int(rand(99));
    }
    my $SQL = "ALTER TABLE $Param{LocalTableName} ADD CONSTRAINT $ForeignKey FOREIGN KEY (";
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
    my $SQL = "ALTER TABLE $Param{TableName} DISABLE CONSTRAINT $Param{Name}";
    return ($SQL);
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
1;
