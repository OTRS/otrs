# --
# Kernel/Modules/AdminUser.pm - to add/update/delete user and preferences
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminUser.pm,v 1.13 2003-02-08 15:16:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminUser;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.13 $ ';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject UserObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    $Param{NextScreen} = 'AdminUser';
    # -- 
    # permission check
    # --
    if (!$Self->{PermissionObject}->Section(UserID => $Self->{UserID}, Section => 'Admin')) {
        return $Self->{LayoutObject}->NoPermission();
    }
    # -- 
    # get user data 2 form
    # --
    if ($Self->{Subaction} eq 'Change') {
        my $UserID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        # --
        # get user data
        # --
        my %UserData = $Self->{UserObject}->GetUserData(UserID => $UserID);
        my $Output = $Self->{LayoutObject}->Header(Title => 'User update');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminUserForm(%UserData);
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
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
        $GetParam{Preferences} = $Self->{ParamObject}->GetParam(Param => 'Preferences') || '';
        # --
        # update user
        # --
        if ($Self->{UserObject}->UserUpdate(%GetParam, UserID => $Self->{UserID})) {
            # --
            # update preferences
            # --
            foreach my $Pref (sort keys %{$Self->{ConfigObject}->Get('PreferencesView')}) {
              foreach my $Group (@{$Self->{ConfigObject}->Get('PreferencesView')->{$Pref}}) {
                my $PrefKey = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{PrefKey} || '';
                my $Type = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{Type} || '';
                my $Value = $Self->{ParamObject}->GetParam(Param => "GenericTopic::$PrefKey");
                $Value = defined $Value ? $Value : '';
                if ($Type eq 'Generic' && $PrefKey && !$Self->{UserObject}->SetPreferences(
                  UserID => $GetParam{ID},
                  Key => $PrefKey,
                  Value => $Value,
                )) {
                  my $Output = $Self->{LayoutObject}->Header();
                  $Output .= $Self->{LayoutObject}->AdminNavigationBar();
                  $Output .= $Self->{LayoutObject}->Error();
                  $Output .= $Self->{LayoutObject}->Footer();
                  return $Output;
                }
              }
            }
            # --
            # redirect
            # --
            return $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");
        }
        else {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->AdminNavigationBar();
            $Output .= $Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
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
        $GetParam{Preferences} = $Self->{ParamObject}->GetParam(Param => 'Preferences') || '';
        # --
        # add user
        # --
        if (my $UserID = $Self->{UserObject}->UserAdd(%GetParam, UserID => $Self->{UserID})) {
            # --
            # update preferences
            # --
            foreach my $Pref (sort keys %{$Self->{ConfigObject}->Get('PreferencesView')}) {
              foreach my $Group (@{$Self->{ConfigObject}->Get('PreferencesView')->{$Pref}}) {
                my $PrefKey = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{PrefKey} || '';
                my $Type = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{Type} || '';
                my $Value = $Self->{ParamObject}->GetParam(Param => "GenericTopic::$PrefKey");
                $Value = defined $Value ? $Value : '';
                if ($Type eq 'Generic' && $PrefKey && !$Self->{UserObject}->SetPreferences(
                  UserID => $UserID,
                  Key => $PrefKey,
                  Value => $Value,
                )) {
                  my $Output = $Self->{LayoutObject}->Header();
                  $Output .= $Self->{LayoutObject}->AdminNavigationBar();
                  $Output .= $Self->{LayoutObject}->Error();
                  $Output .= $Self->{LayoutObject}->Footer();
                  return $Output;
                }
              }
            }
            # --
            # redirect
            # --
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AdminUserGroup&Subaction=User&ID=$UserID",
            );
        }
        else {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->AdminNavigationBar();
            $Output .= $Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # --
    # else ! print form
    # --
    else {
        my $Output = $Self->{LayoutObject}->Header(Title => 'User add');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminUserForm();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;
