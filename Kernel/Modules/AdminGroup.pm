# --
# AdminGroup.pm - to add/update/delete groups 
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminGroup.pm,v 1.1 2001-12-27 14:17:09 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminGroup;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
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
    foreach ('ParamObject', 'DBObject', 'QueueObject', 'LayoutObject', 'ConfigObject', 'LogObject') {
        die "Got no $_" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    $Param{NextScreen} = 'AdminGroup';

    # permission check
    if (!$Self->{PermissionObject}->Section(UserID => $Self->{UserID}, Section => 'Admin')) {
        $Output .= $Self->{LayoutObject}->NoPermission();
        return $Output;
    }

    # get user data 2 form
    if ($Self->{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        # get user data TODO: comment!!! 
        my $SQL = "SELECT name, valid_id, comment " .
           " FROM " .
           " groups " .
           " WHERE " .
           " id = $ID";
        $Self->{DBObject}->Prepare(SQL => $SQL);
        my @Data = $Self->{DBObject}->FetchrowArray();
        $Output .= $Self->{LayoutObject}->AdminGroupForm(
                ID => $ID,
                Name => $Data[0],
                Comment => $Data[2], 
                ValidID => $Data[1],
            );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # update action
    elsif ($Self->{Subaction} eq 'ChangeAction') {
        my %GetParam;
        my @Params = ('ID', 'Name', 'Comment', 'ValidID');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
            $GetParam{$_} = $Self->{DBObject}->Quote($GetParam{$_}) || '';
            $GetParam{$_} = '' if (!exists $GetParam{$_});
        }
        my $SQL = "UPDATE groups SET name = '$GetParam{Name}', " .
          " comment = '$GetParam{Comment}', " .
          " valid_id = $GetParam{ValidID}, " .
          " change_time = current_timestamp, change_by = $Self->{UserID} " .
          " WHERE id = $GetParam{ID}";
        if ($Self->{DBObject}->Do(SQL => $SQL)) { 
            $Output .= $Self->{LayoutObject}->Redirect(OP => "&Action=$Param{NextScreen}");
        }
        else {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->Error(
                Message => 'DB Error!!',
                Comment => 'Please contact your admin');
        $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # add new user
    elsif ($Self->{Subaction} eq 'AddAction') {
        my %GetParam;
        $GetParam{Pw} = '';
        $GetParam{Pw} = crypt($GetParam{Pw}, $Self->{UserID});
        my @Params = ('Name', 'Comment', 'ValidID');
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
            $GetParam{$_} = $Self->{DBObject}->Quote($GetParam{$_}) || '';
        }
        my $SQL = "INSERT INTO groups (name, valid_id, create_time, create_by, change_time, change_by)" .
		" VALUES " .
		" ('$GetParam{Name}', '$GetParam{Comment}', " .
		" $GetParam{ValidID}, current_timestamp, $Self->{UserID}, current_timestamp, $Self->{UserID})";
        if ($Self->{DBObject}->Do(SQL => $SQL)) {        
             $Output .= $Self->{LayoutObject}->Redirect(OP => "&Action=$Param{NextScreen}");
        }
        else {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->Error(
                Message => 'DB Error!!',
                Comment => 'Please contact your admin');
        $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # else ! print form 
    else {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminGroupForm();
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;

