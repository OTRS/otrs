# --
# Group.pm - All Groups related function should be here eventually
# Copyright (C) 2002 Atif Ghaffar <aghaffar@developer.ch>
# $Id: Group.pm,v 1.1 2002-06-08 22:49:52 atif Exp $
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Group;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (
       'DBObject', 
       'ConfigObject',
       'LogObject',
    ) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}


# --
sub GetGroups {
    my $Self = shift;
    my %Param = @_;
    my $UserID = $Param{UserID} || return;
    my %Groups = ();

    my $SQL = "SELECT g.id, g.name " .
    " FROM " .
    " groups g, group_user gu".
    " WHERE " .
    " g.valid_id in ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} ) ".
    " AND ".
    " gu.user_id = $UserID".
    " AND " .
    " g.id = gu.group_id ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
         $Groups{$RowTmp[0]} = $RowTmp[1];
    }

    return %Groups;
} 


# --
sub GetGroupIdByName {
    my $Self = shift;
    my %Param = @_;
    my $UserID = $Param{UserID} || return;
    my $id;

    my $SQL = sprintf ("SELECT id from groups where name='%s'" , $Param{Group});
    
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while  (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
       $id=$RowTmp[0];
    }

    return $id;
} 
# --

sub MemberAdd {
   my $Self = shift;
   my %Param = @_;
   my $UserID = $Param{UserID} || return;
   return unless ($Param{UID} && $Param{GID});
   my $SQL="";
   my $count;


   $SQL = sprintf("select count(*) from group_user where user_id=%s and group_id=%s", $Param{UID} , $Param{GID});
   $Self->{DBObject}->Prepare(SQL => $SQL);
   while  (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
      $count=$RowTmp[0];
   }
   return if $count;


   $SQL = "INSERT INTO group_user (user_id, group_id, create_time, create_by, " .
   " change_time, change_by)" .
   " VALUES " .
   " ( $Param{UID}, $Param{GID}, current_timestamp, $UserID, current_timestamp, $UserID)";
   
   $Self->{DBObject}->Do(SQL => $SQL);
} 
# --

sub GroupAdd {
    my $Self = shift;
    my %Param = @_;
    
    # --
    # qoute params
    # -- 
    my @Params = ('Name', 'Comment', 'ValidID');
    foreach (@Params) {
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
      while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $GroupID = $RowTmp[0];
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

1;
