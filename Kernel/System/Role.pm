# --
# Kernel/System/Role.pm - All role related function
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Role.pm,v 1.1 2004-09-09 11:18:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Role;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Role - role lib

=head1 SYNOPSIS

All role functions. E. g. to add groups to a role.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

  use Kernel::Config;
  use Kernel::System::Log;
  use Kernel::System::DB;
  use Kernel::System::Role;

  my $ConfigObject = Kernel::Config->new();
  my $LogObject    = Kernel::System::Log->new(
      ConfigObject => $ConfigObject,
  );
  my $DBObject = Kernel::System::DB->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
  );
  my $RoleObject = Kernel::System::Role->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
      DBObject => $DBObject,
  );

=cut

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

=item RoleAdd()

to add a new role

  my $ID = $RoleObject->RoleAdd(
      Name => 'example-group',
      ValidID => 1,
      UserID => 123,
  );

=cut

sub RoleAdd {
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
    my $SQL = "INSERT INTO roles (name, comments, valid_id, ".
            " create_time, create_by, change_time, change_by)".
            " VALUES ".
            " ('$Param{Name}', '$Param{Comment}', ".
            " $Param{ValidID}, current_timestamp, $Param{UserID}, ".
            " current_timestamp, $Param{UserID})";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
      # get new group id
      $SQL = "SELECT id ".
        " FROM " .
        " roles " .
        " WHERE " .
        " name = '$Param{Name}'";
      my $RoleID = '';
      $Self->{DBObject}->Prepare(SQL => $SQL);
      while (my @Row = $Self->{DBObject}->FetchrowArray()) {
          $RoleID = $Row[0];
      }

      # log notice
      $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "Role: '$Param{Name}' ID: '$RoleID' created successfully ($Param{UserID})!",
      );
      return $RoleID;
    }
    else {
        return;
    }
}

=item RoleGet()

returns a hash with role data

  %RoleData = $RoleObject->RoleGet(ID => 2);

=cut

sub RoleGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{ID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ID!");
        return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # sql
    my $SQL = "SELECT name, valid_id, comments ".
        " FROM ".
        " roles ".
        " WHERE ".
        " id = $Param{ID}";
    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
        my %RoleData = ();
        while (my @Data = $Self->{DBObject}->FetchrowArray()) {
            %RoleData = (
                ID => $Param{ID},
                Name => $Data[0],
                Comment => $Data[2],
                ValidID => $Data[1],
            );
        }
        return %RoleData;
    }
    else {
        return;
    }
}

=item RoleUpdate()

update of a role

  $RoleObject->RoleUpdate(
      ID => 123,
      Name => 'example-group',
      ValidID => 1,
      UserID => 123,
  );

=cut

sub RoleUpdate {
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
    my $SQL = "UPDATE roles SET name = '$Param{Name}', ".
          " comments = '$Param{Comment}', ".
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

=item RoleList()

returns a hash of all roles

  my %Roles = $RoleObject->GroupList(Valid => 1);

=cut

sub RoleList {
    my $Self = shift;
    my %Param = @_;
    my $Valid = $Param{Valid} || 0;
    my %Roles = $Self->{DBObject}->GetTableData(
        What => 'id, name',
        Table => 'roles',
        Valid => $Valid,
    );
    return %Roles;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.1 $ $Date: 2004-09-09 11:18:24 $

=cut
