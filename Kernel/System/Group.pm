# --
# Kernel/System/Group.pm - All Groups related function should be here eventually
# Copyright (C) 2002 Atif Ghaffar <aghaffar@developer.ch>
#               2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Group.pm,v 1.14 2004-01-04 13:45:19 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Group;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.14 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Group - group lib

=head1 SYNOPSIS

All group functions. E. g. to add groups or to get a member list of a group.

=head1 PUBLIC INTERFACE

=over 4

=cut

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
# just for compat!
sub GetGroupIdByName {
    my $Self = shift;
    my %Param = @_;
    my $ID;
    # check needed stuff
    if (!$Param{Group}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Group!");
        return;
    }
    # sql 
    my $SQL = sprintf ("SELECT id from groups where name='%s'" , $Param{Group});
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while  (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
       $ID=$RowTmp[0];
    }
    return $ID;
}
# --

=item GroupMemberAdd()

to add a member to a group
  
  Permission: ro,move_into,priority,create,rw 

  my $ID = $Self->{GroupObject}->GroupMemberAdd(
      GID => 12,
      UID => 6,
      Permission => {
          ro => 1,
          move_into => 1,
          create => 1,
          owner => 1,
          priority => 0,
          rw => 0,
      },
      UserID => 123,
  );

=cut

sub GroupMemberAdd {
    my $Self = shift;
    my %Param = @_;
    my $count;
    # check needed stuff
    foreach (qw(UID GID UserID Permission)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # update permission 
    foreach (keys %{$Param{Permission}}) {
        # delete existing permission
        my $SQL = "DELETE FROM group_user ".
          " WHERE ".
          " group_id = $Param{GID} ".
          " AND ".
          " user_id = $Param{UID} ".
          " AND ".
          " permission_key = '$_'";
        $Self->{DBObject}->Do(SQL => $SQL);
        # debug
        if ($Self->{Debug}) {
            $Self->{LogObject}->Log(
                Priority => 'error', 
                Message => "Add UID:$Param{UID} to GID:$Param{GID}, $_:$Param{Permission}->{$_}!",
            );
        }
        # insert new permission
        $SQL = "INSERT INTO group_user ".
          " (user_id, group_id, permission_key, permission_value, ".
          " create_time, create_by, change_time, change_by) ".
          " VALUES ".
          " ($Param{UID}, $Param{GID}, '$_', $Param{Permission}->{$_},".
          " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
        $Self->{DBObject}->Do(SQL => $SQL);
    }
    return 1;
} 
# --

=item GroupAdd()

to add a group

  my $ID = $Self->{GroupObject}->GroupAdd(
      Name => 'example-group',
      ValidID => 1,
      UserID => 123,
  );

=cut

sub GroupAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name ValidID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # qoute params
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    my $SQL = "INSERT INTO groups (name, comment, valid_id, ".
            " create_time, create_by, change_time, change_by)".
            " VALUES ".
            " ('$Param{Name}', '$Param{Comment}', ".
            " $Param{ValidID}, current_timestamp, $Param{UserID}, ".
            " current_timestamp, $Param{UserID})";
    
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
      # get new group id
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
      
      # log notice
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

=item GroupGet()

returns a hash with group data

  %GroupData = $Self->{GroupObject}->GroupGet(ID => 2);

=cut

sub GroupGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{ID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ID!");
        return;
    }
    # sql 
    my $SQL = "SELECT name, valid_id, comment ".
        " FROM ".
        " groups ".
        " WHERE ".
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

=item GroupUpdate()

update of a group 

  $Self->{GroupObject}->GroupUpdate(
      ID => 123,
      Name => 'example-group',
      ValidID => 1,
      UserID => 123,
  );

=cut

sub GroupUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID Name ValidID UserID)) {
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
    my $SQL = "UPDATE groups SET name = '$Param{Name}', ".
          " comment = '$Param{Comment}', ".
          " valid_id = $Param{ValidID}, ".
          " change_time = current_timestamp, change_by = $Param{UserID} ".
          " WHERE id = $Param{ID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}
# --

=item GroupList()

returns a hash of all groups

  my %Groups = $Self->{GroupObject}->GroupList(Valid => 1);

=cut

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

=item GroupMemberList()

returns a list of users of a group with ro/move_into/create/owner/priority/rw permissions 

  UserID: user id
  GroupID: group id
  Type: ro|move_into|priority|create|rw
  Result: HASH -> returns a hash of key => group id, value => group name
          Name -> returns an array of user names
          ID   -> returns an array of user names
  Example:
  $Self->{GroupObject}->GroupMemberList(
      UserID => $ID,
      Type => 'move_into',
      Result => 'HASH',
  );

=cut

sub GroupMemberList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Result Type)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    if (!$Param{UserID} && !$Param{GroupID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need UserID or GroupID!");
        return;
    }
    my %Data = (); 
    my @Name = ();
    my @ID = ();
    my $SQL = "SELECT g.id, g.name, gu.permission_key, gu.permission_value, ".
      " gu.user_id ".
      " FROM ".
      " groups g, group_user gu".
      " WHERE " .
      " g.valid_id in ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} ) ".
      " AND ".
      " g.id = gu.group_id ".
      " AND ".
      " gu.permission_value = 1 ".
      " AND ".
      " gu.permission_key IN ('$Param{Type}', 'rw') ".
      " AND ";
    if ($Param{UserID}) {
      $SQL .= " gu.user_id = $Param{UserID}";
    }
    else {
      $SQL .= " gu.group_id = $Param{GroupID}";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my $Key = '';
        my $Value = '';
        if ($Param{UserID}) {
            $Key = $Row[0];
            $Value = $Row[1];
        }
        else {
            $Key = $Row[4];
            $Value = $Row[1];
        }
        # get permissions
        $Data{$Key} = $Value;
        push (@Name, $Value);
        push (@ID, $Key);
    }
    if ($Param{Result} && $Param{Result} eq 'ID') {
        return @ID;
    }
    if ($Param{Result} && $Param{Result} eq 'Name') {
        return @Name;
    }
    else {
        return %Data;
    }
}
# --
1;

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).  

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.14 $ $Date: 2004-01-04 13:45:19 $

=cut
