# --
# Kernel/System/SystemAddress.pm - lib for system addresses
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SystemAddress.pm,v 1.6 2004-02-02 23:27:23 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::SystemAddress;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.6 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
sub SystemAddressAdd {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(Name ValidID Realname QueueID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    # sql
    my $SQL = "INSERT INTO system_address (value0, value1, valid_id, comments, queue_id, " .
        " create_time, create_by, change_time, change_by)" .
        " VALUES " .
        " ('$Param{Name}', '$Param{Realname}', $Param{ValidID}, " .
        " '$Param{Comment}', $Param{QueueID}, " .
        " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        my $Id = 0;
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id FROM system_address WHERE ".
              "value0 = '$Param{Name}' AND value1 = '$Param{Realname}'",
        );
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Id = $Row[0];
        }
        return $Id;
    }
    else {
        return;
    }
}
# --
sub SystemAddressGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{ID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ID!");
      return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    # sql 
    my $SQL = "SELECT value0, value1, comments, valid_id, queue_id ".
        " FROM ".
        " system_address ".
        " WHERE ". 
        " id = $Param{ID}";

    if (!$Self->{DBObject}->Prepare(SQL => $SQL)) {
        return;
    }
    my %Data = ();
    while (my @Data = $Self->{DBObject}->FetchrowArray()) {
        %Data = ( 
            ID => $Param{ID}, 
            Name => $Data[0],
            Realname => $Data[1],
            Comment => $Data[2],
            ValidID => $Data[3],
            QueueID => $Data[4],
        );
    }
    return %Data;
}
# --
sub SystemAddressUpdate {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(ID Name ValidID Realname QueueID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    # sql
    my $SQL = "UPDATE system_address SET value0 = '$Param{Name}', value1 = '$Param{Realname}', " .
        " comments = '$Param{Comment}', valid_id = $Param{ValidID}, " .
        " change_time = current_timestamp, change_by = $Param{UserID}, queue_id = $Param{QueueID} " .
        " WHERE id = $Param{ID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}
# --
sub SystemAddressIsLocalAddress {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Address)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    # sql 
    my $SQL = "SELECT value0, value1, comments, valid_id, queue_id ".
        " FROM ".
        " system_address ".
        " WHERE ". 
        " valid_id IN ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} )";
#        " AND ".
#        " value0 LIKE '$Param{Address}'";

    if (!$Self->{DBObject}->Prepare(SQL => $SQL)) {
        return;
    }
    my $Hit = 0; 
    $Param{Address} =~ s/\\/\\\\/g;
    $Param{Address} =~ s/\+/\\\+/g;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        if ($Row[0] =~ /^$Param{Address}$/i) {
            $Hit = 1;
        }
    }
    return $Hit;
}
# --

1;
