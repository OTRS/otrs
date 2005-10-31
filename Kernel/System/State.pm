# --
# Kernel/System/State.pm - All state related function should be here eventually
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: State.pm,v 1.9 2005-10-31 10:07:03 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::State;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.9 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    # check needed config options
    foreach (qw(Ticket::ViewableStateType Ticket::UnlockStateType)) {
        $Self->{ConfigObject}->Get($_) || die "Need $_ in Kernel/Config.pm!\n";
    }

    return $Self;
}
# --
sub StateAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name ValidID TypeID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # quote params
    foreach (qw(Name Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ValidID TypeID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "INSERT INTO ticket_state (name, valid_id, type_id, comments, " .
        " create_time, create_by, change_time, change_by)" .
        " VALUES " .
        " ('$Param{Name}', $Param{ValidID}, " .
        " $Param{TypeID}, '$Param{Comment}', " .
        " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # get new state id
        my $SQL = "SELECT id FROM ticket_state WHERE name = '$Param{Name}'";
        my $ID = '';
        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $ID = $Row[0];
        }
        return $ID;
    }
    else {
        return;
    }
}
# --
sub StateGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{ID} && !$Param{Name}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ID or Name!");
        return;
    }
    # cache data
    if ($Param{Cache}) {
        if ($Param{Name} && $Self->{"StateGet::$Param{Name}"}) {
            return %{$Self->{"StateGet::$Param{Name}"}};
        }
        elsif ($Param{ID} && $Self->{"StateGet::$Param{ID}"}) {
            return %{$Self->{"StateGet::$Param{ID}"}};
        }
    }
    # sql
    my $SQL = "SELECT ts.id, ts.name, ts.valid_id, ts.comments, ts.type_id, tst.name ".
        " FROM ".
        " ticket_state ts, ticket_state_type tst ".
        " WHERE ".
        " ts.type_id = tst.id ".
        " AND ";
    if ($Param{Name}) {
        $SQL .= " ts.name = '".$Self->{DBObject}->Quote($Param{Name})."'";
    }
    else {
        $SQL .= " ts.id = ".$Self->{DBObject}->Quote($Param{ID}, 'Integer')."";
    }
    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
        my %Data = ();
        while (my @Data = $Self->{DBObject}->FetchrowArray()) {
            %Data = (
                ID => $Data[0],
                Name => $Data[1],
                Comment => $Data[3],
                ValidID => $Data[2],
                TypeID => $Data[4],
                TypeName => $Data[5],
            );
        }
        # cache data
        if ($Param{Name}) {
            $Self->{"StateGet::$Param{Name}"} = \%Data;
        }
        else {
            $Self->{"StateGet::$Param{ID}"} = \%Data;
        }
        # return data
        return %Data;
    }
    else {
        return;
    }
}
# --
sub StateUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID Name ValidID TypeID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # quote params
    foreach (qw(Name Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ID ValidID TypeID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "UPDATE ticket_state SET name = '$Param{Name}', " .
          " comments = '$Param{Comment}', " .
          " type_id = $Param{TypeID}, valid_id = $Param{ValidID}, " .
          " change_time = current_timestamp, change_by = $Param{UserID} " .
          " WHERE id = $Param{ID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}
# --
sub StateGetStatesByType {
    my $Self = shift;
    my %Param = @_;
    my @Name = ();
    my @ID = ();
    my %Data = ();
    # check needed stuff
    foreach (qw(Type Result)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # sql
    my @StateType = ();
    if ($Self->{ConfigObject}->Get('Ticket::'.$Param{Type}.'StateType')) {
        @StateType = @{$Self->{ConfigObject}->Get('Ticket::'.$Param{Type}.'StateType')};
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Type 'Ticket::$Param{Type}StateType' not found in Kernel/Config.pm!",
        );
        die;
    }
    my $SQL = "SELECT ts.id, ts.name, tst.name  ".
        " FROM ".
        " ticket_state ts, ticket_state_type tst ".
        " WHERE ".
        " tst.id = ts.type_id ".
        " AND ".
        " tst.name IN ('${\(join '\', \'', @StateType)}' )".
        " AND ".
        " ts.valid_id IN ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} )";
    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
        while (my @Data = $Self->{DBObject}->FetchrowArray()) {
            push (@Name, $Data[1]);
            push (@ID, $Data[0]);
            $Data{$Data[0]} = $Data[1];
        }
        if ($Param{Result} eq 'Name') {
            return @Name;
        }
        elsif ($Param{Result} eq 'HASH') {
            return %Data;
        }
        else {
            return @ID;
        }
    }
}
# --
sub StateList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{UserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "UserID!");
        return;
    }
    # sql
    my $SQL = "SELECT id, name ".
        " FROM ".
        " ticket_state ".
        " WHERE ".
        " valid_id IN ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} )";
    my %Data = ();
    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Data{$Row[0]} = $Row[1];
        }
        return %Data;
    }
    else {
        return;
    }
}
# --

1;
