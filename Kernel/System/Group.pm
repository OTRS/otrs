# --
# Kernel/System/Group.pm - All Groups related function should be here eventually
# Copyright (C) 2002 Atif Ghaffar <aghaffar@developer.ch>
#               2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Group.pm,v 1.5 2003-01-03 00:30:28 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Group;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

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
sub MemberList {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    if (!$Param{Group} && !$Param{GroupID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Got no Group or GroupID!");
        return;
    }
    # --
    # check if we ask the same request?
    # --
    if ($Param{GroupID} && $Self->{"MemberList::$Param{GroupID}"}) {
        return %{$Self->{"MemberList::$Param{GroupID}"}};
    }
    if ($Param{Group} && $Self->{"MemberList::$Param{Group}"}) {
        return %{$Self->{"MemberList::$Param{Group}"}};
    }
    # --
    # get data
    # --
    my %MemberData = ();
    my $SQL = '';
    my $Suffix = '';
    if ($Param{Group}) {
        $Suffix = 'GroupID';
        $SQL = "SELECT gu.user_id, su.$Self->{ConfigObject}->{DatabaseUserTableUser} ".
          " FROM " .
          " group_user gu, groups g, $Self->{ConfigObject}->{DatabaseUserTable} su ".
          " WHERE " .
          " g.id = gu.group_id AND ".
          " su.$Self->{ConfigObject}->{DatabaseUserTableUserID} = gu.user_id AND ".
          " g.name = '$Param{Group}' AND ".
          " su.valid_id in ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} ) ";

    }
    else {
        $Suffix = 'Group';
        $SQL = "SELECT gu.user_id, su.$Self->{ConfigObject}->{DatabaseUserTableUser} ".
          " FROM ".
          " group_user gu, $Self->{ConfigObject}->{DatabaseUserTable} su ".
          " WHERE ".
          " su.$Self->{ConfigObject}->{DatabaseUserTableUserID} = gu.user_id AND ".
          " gu.group_id = $Param{GroupID} AND ".
          " su.valid_id in ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} ) ";
    }
    if (!$Self->{DBObject}->Prepare(SQL => $SQL)) {
        return;
    }
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $MemberData{$Row[0]} = $Row[1];
    }
    # --
    # store result
    # --
    $Self->{"MemberList::$Suffix"} = \%MemberData;
    return %MemberData; 
} 
# --
sub MemberAdd {
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
    my $SQL = sprintf("select count(*) from group_user where user_id=%s and group_id=%s", $Param{UID} , $Param{GID});
    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
       while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
          $count=$Row[0];
       }
       return 1 if $count;

       $SQL = "INSERT INTO group_user (user_id, group_id, create_time, create_by, " .
           " change_time, change_by)" .
           " VALUES " .
           " ( $Param{UID}, $Param{GID}, ".
           " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
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
        my @Data = $Self->{DBObject}->FetchrowArray();
        my %GroupData = (
                ID => $Param{ID},
                Name => $Data[0],
                Comment => $Data[2],
                ValidID => $Data[1],
        );
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

1;
