# --
# Kernel/Modules/AdminCustomerUser.pm - to add/update/delete customer user and preferences
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminCustomerUser.pm,v 1.5 2003-01-03 16:17:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminCustomerUser;

use strict;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $ ';
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
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject UserObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    $Param{NextScreen} = 'AdminCustomerUser';
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
        my $User = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        # --
        # get user data
        # --
        my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $User);
        my %UserList = $Self->{CustomerUserObject}->CustomerUserList(Valid => 0);
        my $Output = $Self->{LayoutObject}->Header(Title => 'Customer user update');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminCustomerUserForm(%UserData, UserList => \%UserList);
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
        foreach my $Entry (@{$Self->{ConfigObject}->Get('CustomerUser')->{Map}}) {
            $GetParam{$Entry->[0]} = $Self->{ParamObject}->GetParam(Param => $Entry->[0]) || '';
        }
        $GetParam{ID} = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        # --
        # update user
        # --
        if ($Self->{CustomerUserObject}->CustomerUserUpdate(%GetParam, UserID => $Self->{UserID})) {
            # --
            # update preferences
            # --
            foreach my $Pref (sort keys %{$Self->{ConfigObject}->Get('CustomerPreferencesView')}) {
              foreach my $Group (@{$Self->{ConfigObject}->Get('CustomerPreferencesView')->{$Pref}}) {
                my $PrefKey = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{PrefKey} || '';
                my $Type = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{Type} || '';
                my $Value = $Self->{ParamObject}->GetParam(Param => "GenericTopic::$PrefKey");
                $Value = defined $Value ? $Value : '';
                if ($Type eq 'Generic' && $PrefKey && !$Self->{CustomerUserObject}->SetPreferences(
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
        foreach my $Entry (@{$Self->{ConfigObject}->Get('CustomerUser')->{Map}}) {
            $GetParam{$Entry->[0]} = $Self->{ParamObject}->GetParam(Param => $Entry->[0]) || '';
        }
        # --
        # add user
        # --
        if (my $User = $Self->{CustomerUserObject}->CustomerUserAdd(%GetParam, UserID => $Self->{UserID})) {
            # --
            # update preferences
            # --
            foreach my $Pref (sort keys %{$Self->{ConfigObject}->Get('CustomerPreferencesView')}) {
              foreach my $Group (@{$Self->{ConfigObject}->Get('CustomerPreferencesView')->{$Pref}}) {
                my $PrefKey = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{PrefKey} || '';
                my $Type = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{Type} || '';
                my $Value = $Self->{ParamObject}->GetParam(Param => "GenericTopic::$PrefKey");
                $Value = defined $Value ? $Value : '';
                if ($Type eq 'Generic' && $PrefKey && !$Self->{CustomerUserObject}->SetPreferences(
                  UserID => $User, 
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
                OP => "Action=AdminCustomerUser",
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
        my $Output = $Self->{LayoutObject}->Header(Title => 'CustomerUser add');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        my %UserList = $Self->{CustomerUserObject}->CustomerUserList(Valid => 0);
        $Output .= $Self->{LayoutObject}->AdminCustomerUserForm(UserList => \%UserList);
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;
