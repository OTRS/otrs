# --
# AdminUser.pm - to add/update/delete user
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminUser.pm,v 1.7 2002-05-14 00:23:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminUser;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $ ';
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
    foreach (
      'ParamObject', 
      'DBObject', 
      'QueueObject', 
      'LayoutObject', 
      'ConfigObject', 
      'LogObject',
      'UserObject',
    ) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    $Param{NextScreen} = 'AdminUser';
    # -- 
    # permission check
    # --
    if (!$Self->{PermissionObject}->Section(UserID => $Self->{UserID}, Section => 'Admin')) {
        $Output .= $Self->{LayoutObject}->NoPermission();
        return $Output;
    }
    # -- 
    # get user data 2 form
    # --
    if ($Self->{Subaction} eq 'Change') {
        my $UserID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        $Output .= $Self->{LayoutObject}->Header(Title => 'User ändern');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        # --
        # get user data
        # --
        my %UserData = $Self->{UserObject}->GetUserData(UserID => $UserID);
        $Output .= $Self->{LayoutObject}->AdminUserForm(%UserData);

        $Output .= $Self->{LayoutObject}->Footer();
    }
    # --
    # update action
    # --
    elsif ($Self->{Subaction} eq 'ChangeAction') {
        # --
        # get params
        # --
        my %GetParam;
        my $UserParamsTmp = $Self->{ConfigObject}->{UserPreferencesMaskUse};
        foreach (my @UserParams = @$UserParamsTmp) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        # --
        # update user
        # --
        if ($Self->{UserObject}->UserUpdate(%GetParam, UserID => $Self->{UserID})) {
            # --
            # pref update db
            # --
            my $UserPrefsTmp = $Self->{ConfigObject}->{UserPreferences};
            my %UserPrefs = %$UserPrefsTmp;
            foreach (keys %UserPrefs) {
              $Self->{UserObject}->SetPreferences(
                UserID => $GetParam{ID},
                Key => $_,
                Value => $Self->{ParamObject}->GetParam(Param => $UserPrefs{$_}) || '',
              );
            }
            # --
            # redirect
            # --
            $Output .= $Self->{LayoutObject}->Redirect(OP => "&Action=$Param{NextScreen}");
        }
        else {
            $Output .= $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->Error(
                Message => 'DB Error!!',
                Comment => 'Please contact your admin',
            );
            $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # --
    # add new user
    # --
    elsif ($Self->{Subaction} eq 'AddAction') {
        # --
        # get params
        # --
        my %GetParam;
        my $UserParamsTmp = $Self->{ConfigObject}->{UserPreferencesMaskUse};
        foreach (my @UserParams = @$UserParamsTmp) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        # --
        # add user
        # --
        if (my $UserID = $Self->{UserObject}->UserAdd(%GetParam, UserID => $Self->{UserID})) {
            # --
            # pref update db
            # --
            my $UserPrefsTmp = $Self->{ConfigObject}->{UserPreferences};
            my %UserPrefs = %$UserPrefsTmp;
            foreach (keys %UserPrefs) {
              $Self->{UserObject}->SetPreferences(
                UserID => $UserID,
                Key => $_,
                Value => $GetParam{$UserPrefs{$_}},
              );
            }
            # --
            # redirect
            # --
            $Output .= $Self->{LayoutObject}->Redirect(OP => "&Action=$Param{NextScreen}");
        }
        else {
            $Output .= $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->AdminNavigationBar();
            $Output .= $Self->{LayoutObject}->Error(
                Message => 'DB Error!!',
                Comment => 'Please contact your admin',
            );
            $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # --
    # else ! print form
    # --
    else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'User add');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminUserForm();
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;
