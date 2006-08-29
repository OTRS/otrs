# --
# Kernel/System/CustomerGroup.pm - All Groups related function should be here eventually
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: CustomerGroup.pm,v 1.8 2006-08-29 17:30:36 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CustomerGroup;

use strict;
use Kernel::System::Group;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.8 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::CustomerGroup - customer group lib

=head1 SYNOPSIS

All customer group functions. E. g. to add groups or to get a member list of a group.

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

    $Self->{GroupObject} = Kernel::System::Group->new(%Param);

    return $Self;
}

=item GroupMemberAdd()

to add a member to a group

  Permission: ro,move_into,priority,create,rw

  my $ID = $Self->{CustomerGroupObject}->GroupMemberAdd(
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
        my $SQL = "DELETE FROM group_customer_user ".
          " WHERE ".
          " group_id = ".$Self->{DBObject}->Quote($Param{GID}).
          " AND ".
          " user_id = '".$Self->{DBObject}->Quote($Param{UID})."' ".
          " AND ".
          " permission_key = '".$Self->{DBObject}->Quote($_)."'";
        $Self->{DBObject}->Do(SQL => $SQL);
        # debug
        if ($Self->{Debug}) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Add UID:$Param{UID} to GID:$Param{GID}, $_:$Param{Permission}->{$_}!",
            );
        }
        # insert new permission
        $SQL = "INSERT INTO group_customer_user ".
          " (user_id, group_id, permission_key, permission_value, ".
          " create_time, create_by, change_time, change_by) ".
          " VALUES ".
          " ('".$Self->{DBObject}->Quote($Param{UID})."', ".
          " ".$Self->{DBObject}->Quote($Param{GID}).", ".
          " '".$Self->{DBObject}->Quote($_)."', ".
          " ".$Self->{DBObject}->Quote($Param{Permission}->{$_}).",".
          " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
        $Self->{DBObject}->Do(SQL => $SQL);
    }
    return 1;
}

=item GroupMemberList()

returns a list of users of a group with ro/move_into/create/owner/priority/rw permissions

  UserID: user id
  GroupID: group id
  Type: ro|move_into|priority|create|rw
  Result: HASH -> returns a hash of key => group id, value => group name
          Name -> returns an array of user names
          ID   -> returns an array of user names
  Example:
  $Self->{CustomerGroupObject}->GroupMemberList(
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
    # check if customer group feature is activ, if not, return all groups
    if (!$Self->{ConfigObject}->Get('CustomerGroupSupport')) {
        # get permissions
        %Data = $Self->{GroupObject}->GroupList(Valid => 1);
        foreach (keys %Data) {
            push (@Name, $Data{$_});
            push (@ID, $_);
        }
    }
    # if it's activ, return just the permitted groups
    my $SQL = "SELECT g.id, g.name, gu.permission_key, gu.permission_value, ".
      " gu.user_id ".
      " FROM ".
      " groups g, group_customer_user gu".
      " WHERE " .
      " g.valid_id IN ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} ) ".
      " AND ".
      " g.id = gu.group_id ".
      " AND ".
      " gu.permission_value = 1 ".
      " AND ".
      " gu.permission_key IN ('".$Self->{DBObject}->Quote($Param{Type})."', 'rw') ".
      " AND ";
    if ($Param{UserID}) {
      $SQL .= " gu.user_id = '".$Self->{DBObject}->Quote($Param{UserID})."'";
    }
    else {
      $SQL .= " gu.group_id = ".$Self->{DBObject}->Quote($Param{GroupID})."";
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
    # add always groups
    if ($Self->{ConfigObject}->Get('CustomerGroupAlwaysGroups')) {
        my %Groups = $Self->{GroupObject}->GroupList(Valid => 1);
        foreach (@{$Self->{ConfigObject}->Get('CustomerGroupAlwaysGroups')}) {
            foreach my $GroupID (keys %Groups) {
                if ($_ eq $Groups{$GroupID} && !$Data{$GroupID}) {
                    $Data{$GroupID} = $_;
                    push (@Name, $_);
                    push (@ID, $GroupID);
                }
            }
        }
    }
    # return type
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

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.8 $ $Date: 2006-08-29 17:30:36 $

=cut
