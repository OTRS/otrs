# --
# Kernel/System/AutoResponse.pm - lib for auto responses
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AutoResponse.pm,v 1.3 2002-09-20 11:02:56 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::AutoResponse;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub AutoResponseAdd {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(Name ValidID Response AddressID TypeID CharsetID UserID Subject)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # db quote
    # --
    foreach (keys %Param) {
            $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    # --
    # sql
    # --
    my $SQL = "INSERT INTO auto_response " .
        " (name, valid_id, comment, text0, text1, type_id, system_address_id, " .
        " charset_id,  create_time, create_by, change_time, change_by)" .
        " VALUES " .
        " ('$Param{Name}', $Param{ValidID}, '$Param{Comment}', '$Param{Response}', " .
        " '$Param{Subject}', $Param{TypeID}, $Param{AddressID}, $Param{CharsetID}, " .
        " current_timestamp, $Param{UserID}, current_timestamp,  $Param{UserID})";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}
# --
sub AutoResponseGet {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    if (!$Param{ID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ID!");
      return;
    }
    # --
    # sql 
    # --
    my $SQL = "SELECT name, valid_id, comment, text0, text1, " .
        " type_id, system_address_id, charset_id " .
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
            CharsetID => $Data[7],
        );
        return %Data;
    }
    else { 
        return;
    }
}
# --
sub AutoResponseUpdate {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(ID Name ValidID Response AddressID CharsetID UserID Subject)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # db quote
    # --
    foreach (keys %Param) {
            $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    # --
    # sql
    # --
    my $SQL = "UPDATE auto_response SET " .
        " name = '$Param{Name}', " .
        " text0 = '$Param{Response}', " .
        " comment = '$Param{Comment}', " .
        " text1 = '$Param{Subject}', " .
        " type_id = $Param{TypeID}, " .
        " system_address_id = $Param{AddressID}, " .
        " charset_id = $Param{CharsetID}, " .
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
# --
sub AutoResponseGetByTypeQueueID {
    my $Self = shift;
    my %Param = @_;
    my %Data;
    # --
    # check needed stuff
    # --
    foreach (qw(QueueID Type)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # SQL query
    # --
    my $SQL = "SELECT ar.text0, sa.value0, sa.value1, ar.text1, ch.charset" .
    " FROM " .
    " auto_response_type art, auto_response ar, queue_auto_response qar, ".
    " system_address sa, charset ch " .
    " WHERE " .
    " qar.queue_id = $Param{QueueID} " .
    " AND " .
    " art.id = ar.type_id " .
    " AND " .
    " qar.auto_response_id = ar.id " .
    " AND " .
    " ar.system_address_id = sa.id" .
    " AND " .
    " ar.charset_id = ch.id ".
    " AND " .
    " art.name = '$Param{Type}'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Data{Text} = $RowTmp[0];
        $Data{Address} = $RowTmp[1];
        $Data{Realname} = $RowTmp[2];
        $Data{Subject} = $RowTmp[3];
        $Data{Charset} = $RowTmp[4];
    }
    return %Data;
}
# --

1;
