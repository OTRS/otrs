# --
# Kernel/Modules/AdminUserGroup.pm - to add/update/delete groups <-> users
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminUserGroup.pm,v 1.5 2002-10-25 11:46:00 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminUserGroup;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # allocate new hash for objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $UserID = $Self->{UserID};
    my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
    $Param{NextScreen} = 'AdminUserGroup';

    # permission check
    if (!$Self->{PermissionObject}->Section(UserID => $Self->{UserID}, Section => 'Admin')) {
        $Output .= $Self->{LayoutObject}->NoPermission();
        return $Output;
    }

    # user <-> group 1:n
    if ($Self->{Subaction} eq 'User') {
        $Output .= $Self->{LayoutObject}->Header(Title => 'User <-> Group');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        # get user data 
        my %UserData = $Self->{DBObject}->GetTableData(
                What => "$Self->{ConfigObject}->{DatabaseUserTableUserID}, ".
                        " $Self->{ConfigObject}->{DatabaseUserTableUser}",
                Table => $Self->{ConfigObject}->{DatabaseUserTable},
                Where => "$Self->{ConfigObject}->{DatabaseUserTableUserID} = $ID");
        # get group data
        my %GroupData = $Self->{DBObject}->GetTableData(
                Table => 'groups',
                What => 'id, name',
                Valid => 1);
        my %Data = $Self->{DBObject}->GetTableData(
                Table => 'group_user',
                What => 'group_id, user_id',
                Where => "user_id = $ID");
        $Output .= $Self->{LayoutObject}->AdminUserGroupChangeForm(
                FirstData => \%UserData,
                SecondData => \%GroupData,
                Data => \%Data,	 
                Type => 'User',
            );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # group <-> user n:1
    elsif ($Self->{Subaction} eq 'Group') {
        $Output .= $Self->{LayoutObject}->Header(Title => 'User <-> Group');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        # get user data 
        my %UserData = $Self->{DBObject}->GetTableData(
                What => "$Self->{ConfigObject}->{DatabaseUserTableUserID}, ".
                        " $Self->{ConfigObject}->{DatabaseUserTableUser}",
                Table => $Self->{ConfigObject}->{DatabaseUserTable},
                Valid => 1,
        );
        # get group data
        my %GroupData = $Self->{DBObject}->GetTableData(
                Table => 'groups',
                What => 'id, name',
                Where => "id = $ID",
        );
        my %Data = $Self->{DBObject}->GetTableData(
                Table => 'group_user',
                What => 'user_id, group_id',
                Where => "group_id = $ID",
        );
        $Output .= $Self->{LayoutObject}->AdminUserGroupChangeForm(
                FirstData => \%GroupData,
                SecondData => \%UserData,
                Data => \%Data,
                Type => 'Group',
            );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # add user to groups
    elsif ($Self->{Subaction} eq 'ChangeGroup') {
        my %GetParam;
        my @Params = ('ID');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
            $GetParam{$_} = $Self->{DBObject}->Quote($GetParam{$_}) || '';
        }
        my @NewIDs = $Self->{ParamObject}->GetArray(Param => 'IDs');
        $Self->{DBObject}->Do(SQL => "DELETE FROM group_user WHERE group_id = $ID");

        foreach (@NewIDs) {
          my $SQL = "INSERT INTO group_user (user_id, group_id, create_time, create_by, " .
            " change_time, change_by)" .
            " VALUES " .
            " ( $_, $ID, current_timestamp, $UserID, current_timestamp, $UserID)";
          $Self->{DBObject}->Do(SQL => $SQL);
        }
        $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");    
    }
    # groups to user
    elsif ($Self->{Subaction} eq 'ChangeUser') {
        my %GetParam;
        my @Params = ('ID');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
            $GetParam{$_} = $Self->{DBObject}->Quote($GetParam{$_}) || '';
        }
        my @NewIDs = $Self->{ParamObject}->GetArray(Param => 'IDs');
        $Self->{DBObject}->Do(SQL => "DELETE FROM group_user WHERE user_id = $ID");

        foreach (@NewIDs) {
        my $SQL = "INSERT INTO group_user (user_id, group_id, create_time, create_by, " .
                " change_time, change_by)" .
                " VALUES " .
                " ( $ID, $_, current_timestamp, $UserID, current_timestamp, $UserID)";
             $Self->{DBObject}->Do(SQL => $SQL);
        }
        $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");
    }
    # else ! print form 
    else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'User <-> Group');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        # get user data 
        my %UserData = $Self->{DBObject}->GetTableData(
          What => "$Self->{ConfigObject}->{DatabaseUserTableUserID}, ".
                  " $Self->{ConfigObject}->{DatabaseUserTableUser}",
          Table => $Self->{ConfigObject}->{DatabaseUserTable},
          Valid => 1,
        );
        # get group data
        my %GroupData = $Self->{DBObject}->GetTableData(
                Table => 'groups', 
                What => 'id, name', 
                Valid => 1,
        );
        $Output .= $Self->{LayoutObject}->AdminUserGroupForm(
            GroupData => \%GroupData, 
            UserData => \%UserData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;

