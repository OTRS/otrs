# --
# Kernel/Modules/AdminCustomerUser.pm - to add/update/delete customer user and preferences
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminCustomerUser.pm,v 1.9 2004-02-09 01:40:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminCustomerUser;

use strict;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = '$Revision: 1.9 $ ';
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

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $NavBar = '';
    my $Nav = $Self->{ParamObject}->GetParam(Param => 'Nav') || 0;
    my $Source = $Self->{ParamObject}->GetParam(Param => 'Source') || 'CustomerUser';
    # check nav bar
    if (!$Nav) {
        if ($ENV{HTTP_REFERER} && $ENV{HTTP_REFERER} !~ /Admin/) {
            $Nav = 'Agent';
        }
        else {
            $Nav = 'Admin';
        }
    }
    if ($Nav eq 'Admin') {
        $NavBar = $Self->{LayoutObject}->Header(Area => 'Admin', Title => 'Customer User');
        $NavBar .= $Self->{LayoutObject}->AdminNavigationBar();
    }
    else {
        $NavBar = $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Customer User');
        $NavBar .= $Self->{LayoutObject}->NavigationBar();
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
        my $Output = $NavBar.$Self->{LayoutObject}->AdminCustomerUserForm(
            Nav => $Nav,
            UserList => \%UserList,
            SourceList => {$Self->{CustomerUserObject}->CustomerSourceList()},
            Source => $Source,
            %UserData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # update action
    # --
    elsif ($Self->{Subaction} eq 'ChangeAction') {
        # get params
        my %GetParam;
        foreach my $Entry (@{$Self->{ConfigObject}->Get($Source)->{Map}}) {
            $GetParam{$Entry->[0]} = $Self->{ParamObject}->GetParam(Param => $Entry->[0]) || '';
        }
        $GetParam{ID} = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        # update user
        if ($Self->{CustomerUserObject}->CustomerUserUpdate(%GetParam, UserID => $Self->{UserID})) {
            # update preferences
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
                  my $Output .= $NavBar.$Self->{LayoutObject}->Error();
                  $Output .= $Self->{LayoutObject}->Footer();
                  return $Output;
                }
              }
            }
            # redirect
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AdminCustomerUser&Nav=$Nav",
            );
        }
        else {
            my $Output = $NavBar.$Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # --
    # add new user
    # --
    elsif ($Self->{Subaction} eq 'AddAction') {
        # get params
        my %GetParam;
        foreach my $Entry (@{$Self->{ConfigObject}->Get($Source)->{Map}}) {
            $GetParam{$Entry->[0]} = $Self->{ParamObject}->GetParam(Param => $Entry->[0]) || '';
        }
        # add user
        if (my $User = $Self->{CustomerUserObject}->CustomerUserAdd(%GetParam, UserID => $Self->{UserID}, Source => $Source)) {
            # update preferences
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
                  my $Output = $NavBar.$Self->{LayoutObject}->Error();
                  $Output .= $Self->{LayoutObject}->Footer();
                  return $Output;
                }
              }
            }
            # redirect
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AdminCustomerUser&Nav=$Nav",
            );
        }
        else {
            my $Output = $NavBar.$Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # --
    # else ! print form
    # --
    else {
        my %UserList = $Self->{CustomerUserObject}->CustomerUserList(Valid => 0);
        my $Output .= $NavBar.$Self->{LayoutObject}->AdminCustomerUserForm(
            Nav => $Nav,
            UserList => { $Self->{CustomerUserObject}->CustomerUserList(Valid => 0) },
            SourceList => {$Self->{CustomerUserObject}->CustomerSourceList()}, 
            Source => $Source,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;
