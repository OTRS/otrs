# --
# Kernel/System/Group.pm - All Groups related function should be here eventually
# Copyright (C) 2002 Atif Ghaffar <aghaffar@developer.ch>
#               2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Group.pm,v 1.7 2003-03-06 22:11:57 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Group;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.7 $';
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

    return $Self;
}
# --
sub GetGroupIdByName {
    my $Self = shift;
    my %Param = @_;
    my $ID;
    # --
    # check needed stuff
    # --
    if (!$Param{Group}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Group!");
        return;
    }
    # --
    # sql 
    # --
    my $SQL = sprintf ("SELECT id from groups where name='%s'" , $Param{Group});
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while  (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
       $ID=$RowTmp[0];
    }
    return $ID;
}
# --
sub GroupMemberAdd {
    my $Self = shift;
    my %Param = @_;
    my $count;
    # --
    # check needed stuff
    # --
    foreach (qw(UID GID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # sql
    # --
    my $Ro = defined ($Param{Ro}) ? $Param{Ro} : 1;
    my $Rw = defined ($Param{Rw}) ? $Param{Rw} : 1;
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM group_user WHERE group_id = $Param{GID} AND user_id = $Param{UID}",
    );
    if ($Ro || $Rw) {
        my $SQL = "INSERT INTO group_user (user_id, group_id, read, write, ".
          " create_time, create_by, change_time, change_by)".
          " VALUES ".
          " ( $Param{UID}, $Param{GID}, $Ro, $Rw, current_timestamp, ".
          " $Param{UserID}, current_timestamp, $Param{UserID})";
        if ($Self->{DBObject}->Do(SQL => $SQL)) {
            return 1;
        }
        else { 
            return;
        } 
    }
    else {
        return;
    }
} 
# --
sub GroupAdd {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(Name ValidID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # qoute params
    # -- 
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    my $SQL = "INSERT INTO groups (name, comment, valid_id, ".
            " create_time, create_by, change_time, change_by)" .
            " VALUES " .
            " ('$Param{Name}', '$Param{Comment}', " .
            " $Param{ValidID}, current_timestamp, $Param{UserID}, ".
            " current_timestamp, $Param{UserID})";
    
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
      # --
      # get new group id
      # --
      $SQL = "SELECT id ".
        " FROM " .
        " groups " .
        " WHERE " .
        " name = '$Param{Name}'";
      
      my $GroupID = '';
      $Self->{DBObject}->Prepare(SQL => $SQL);
      while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $GroupID = $Row[0];
      }
      
      # --
      # log notice
      # --
      $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "Group: '$Param{Name}' ID: '$GroupID' created successfully ($Param{UserID})!",
      );

      return $GroupID; 
    }
    else {
        return;
    }
}
# --
sub GroupGet {
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
    my $SQL = "SELECT name, valid_id, comment " .
        " FROM " .
        " groups " .
        " WHERE " .
        " id = $Param{ID}";
    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
        my %GroupData = ();
        while (my @Data = $Self->{DBObject}->FetchrowArray()) {
            %GroupData = (
                ID => $Param{ID},
                Name => $Data[0],
                Comment => $Data[2],
                ValidID => $Data[1],
            );
        }
        return %GroupData;
    }
    else {
        return;
    }
}
# --
sub GroupUpdate {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(ID Name ValidID UserID)) {
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
    my $SQL = "UPDATE groups SET name = '$Param{Name}', " .
          " comment = '$Param{Comment}', " .
          " valid_id = $Param{ValidID}, " .
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
sub GroupList {
    my $Self = shift;
    my %Param = @_;
    my $Valid = $Param{Valid} || 0;
    my %Users = $Self->{DBObject}->GetTableData(
        What => 'id, name',
        Table => 'groups', 
        Valid => $Valid,
    );
    return %Users;
}   
# --
sub GroupMemberList {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(Result Type GroupID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my %Users = ();
    my @Name = ();
    my @ID = ();
    my $SQL = "SELECT u.id, u.login, gu.read, gu.write " .
      " FROM " .
      " $Self->{ConfigObject}->{DatabaseUserTable} u, group_user gu".
      " WHERE " .
      " u.valid_id in ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} ) ".
      " AND ". 
      " gu.group_id = $Param{GroupID}".
      " AND " .
      " u.id = gu.user_id ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # read only
        if ($Param{Type} eq 'ro') {
            if ($Row[3] || $Row[2] || (!$Row[2] && !$Row[3])) {
                $Users{$Row[0]} = $Row[1];
                push (@Name, $Row[1]);
                push (@ID, $Row[0]);
            }
        }
        # read/write
        elsif ($Param{Type} eq 'rw') {
            if ($Row[3] || (!$Row[2] && !$Row[3])) {
                $Users{$Row[0]} = $Row[1];
                push (@Name, $Row[1]);
                push (@ID, $Row[0]);
            }
        }
        else {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Type '$Param{Type}' dosn't exist!");
            return;
        }
    }
    if ($Param{Result} && $Param{Result} eq 'ID') {
        return @ID;
    }
    if ($Param{Result} && $Param{Result} eq 'Name') {
        return @Name;
    }
    else {
        return %Users;
    }
}
# --
sub GroupUserList {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(Result Type UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my %Groups = (); 
    my @Name = ();
    my @ID = ();
    my $SQL = "SELECT g.id, g.name, gu.read, gu.write " .
      " FROM " .
      " groups g, group_user gu".
      " WHERE " .
      " g.valid_id in ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} ) ".
      " AND ".
      " gu.user_id = $Param{UserID}".
      " AND " .
      " g.id = gu.group_id ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # read only
        if ($Param{Type} eq 'ro') {
            if ($Row[3] || $Row[2] || (!$Row[2] && !$Row[3])) {
                $Groups{$Row[0]} = $Row[1];
                push (@Name, $Row[1]);
                push (@ID, $Row[0]);
            }
        }
        # read/write
        elsif ($Param{Type} eq 'rw') {
            if ($Row[3] || (!$Row[2] && !$Row[3])) {
                $Groups{$Row[0]} = $Row[1];
                push (@Name, $Row[1]);
                push (@ID, $Row[0]);
            }
        }
        else {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Type '$Param{Type}' dosn't exist!");
            return;
        }
    }
    if ($Param{Result} && $Param{Result} eq 'ID') {
        return @ID;
    }
    if ($Param{Result} && $Param{Result} eq 'Name') {
        return @Name;
    }
    else {
        return %Groups;
    }
}
# --

1;
