# --
# Kernel/System/AutoResponse.pm - lib for auto responses
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: AutoResponse.pm,v 1.12 2006-11-02 12:20:52 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::AutoResponse;

use strict;
use Kernel::System::Queue;

use vars qw($VERSION);
$VERSION = '$Revision: 1.12 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get common objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    if (!$Self->{QueueObject}) {
        $Self->{QueueObject} = Kernel::System::Queue->new(%Param);
    }

    return $Self;
}

sub AutoResponseAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name ValidID Response AddressID TypeID Charset UserID Subject)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Name Comment Response Charset Subject)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ValidID TypeID AddressID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "INSERT INTO auto_response " .
        " (name, valid_id, comments, text0, text1, type_id, system_address_id, " .
        " charset,  create_time, create_by, change_time, change_by)" .
        " VALUES " .
        " ('$Param{Name}', $Param{ValidID}, '$Param{Comment}', '$Param{Response}', " .
        " '$Param{Subject}', $Param{TypeID}, $Param{AddressID}, '$Param{Charset}', " .
        " current_timestamp, $Param{UserID}, current_timestamp,  $Param{UserID})";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}

sub AutoResponseGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{ID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ID!");
      return;
    }
    # db quote
    foreach (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "SELECT name, valid_id, comments, text0, text1, " .
        " type_id, system_address_id, charset " .
        " FROM " .
        " auto_response " .
        " WHERE " .
        " id = $Param{ID}";
    if (!$Self->{DBObject}->Prepare(SQL => $SQL)) {
        return;
    }
    if (my @Data = $Self->{DBObject}->FetchrowArray()) {
        my %Data = (
            ID => $Param{ID},
            Name => $Data[0],
            Comment => $Data[2],
            Response => $Data[3],
            ValidID => $Data[1],
            Subject => $Data[4],
            TypeID => $Data[5],
            AddressID => $Data[6],
            Charset => $Data[7],
        );
        return %Data;
    }
    else {
        return;
    }
}

sub AutoResponseUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID Name ValidID Response AddressID Charset UserID Subject)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Name Comment Response Charset Subject)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ID ValidID TypeID AddressID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "UPDATE auto_response SET " .
        " name = '$Param{Name}', " .
        " text0 = '$Param{Response}', " .
        " comments = '$Param{Comment}', " .
        " text1 = '$Param{Subject}', " .
        " type_id = $Param{TypeID}, " .
        " system_address_id = $Param{AddressID}, " .
        " charset = '$Param{Charset}', " .
        " valid_id = $Param{ValidID}, " .
        " change_time = current_timestamp, " .
        " change_by = $Param{UserID} " .
        " WHERE " .
        " id = $Param{ID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}

sub AutoResponseGetByTypeQueueID {
    my $Self = shift;
    my %Param = @_;
    my %Data;
    # check needed stuff
    foreach (qw(QueueID Type)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Type)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(QueueID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # SQL query
    my $SQL = "SELECT ar.text0, ar.text1, ar.charset" .
    " FROM " .
    " auto_response_type art, auto_response ar, queue_auto_response qar ".
    " WHERE " .
    " qar.queue_id = $Param{QueueID} " .
    " AND " .
    " art.id = ar.type_id " .
    " AND " .
    " qar.auto_response_id = ar.id " .
    " AND " .
    " art.name = '$Param{Type}'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{Text} = $Row[0];
        $Data{Subject} = $Row[1];
        $Data{Charset} = $Row[2];
    }
    my %Adresss = $Self->{QueueObject}->GetSystemAddress(
        QueueID => $Param{QueueID},
    );
    # COMPAT: 2.1
    $Data{Realname} = $Adresss{RealName};
    $Data{Address} = $Adresss{Email};
    return (%Adresss, %Data);
}

1;
