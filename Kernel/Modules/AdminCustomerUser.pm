# --
# Kernel/Modules/AdminCustomerUser.pm - to add/update/delete customer user and preferences
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminCustomerUser.pm,v 1.22 2004-04-28 22:26:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminCustomerUser;

use strict;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = '$Revision: 1.22 $ ';
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
    my $Search = $Self->{ParamObject}->GetParam(Param => 'Search');
    my $AddedUID = $Self->{ParamObject}->GetParam(Param => 'AddedUID') || '';

    my %UserList = ();
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
    elsif ($Nav eq 'None') {
        $NavBar = $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Customer User', Type => 'Small');
    }
    else {
        $NavBar = $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Customer User');
        # get user lock data
        my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
        # build NavigationBar 
        $NavBar .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
    }
    # add notify
    if ($AddedUID) {
        my $OnClick = '';
        if ($Nav eq 'None') {
            $OnClick = " onclick=\"updateMessage('$AddedUID')\"";
        }
        $NavBar .= $Self->{LayoutObject}->Notify(
            Info => $Self->{LayoutObject}->{LanguageObject}->Get('Added User "%s"", "'.$AddedUID).
            " ( <a href=\"?Action=AgentPhone&Subaction=StoreNew&ExpandCustomerName=2&CustomerUser=$AddedUID\"$OnClick>".$Self->{LayoutObject}->{LanguageObject}->Get('PhoneView')."</a>".
            " - <a href=\"?Action=AgentEmail&Subaction=StoreNew&ExpandCustomerName=2&CustomerUser=$AddedUID\"$OnClick>".$Self->{LayoutObject}->{LanguageObject}->Get('Compose Email')."</a> )!",
        );
    }
    # search user list
    if ($Search) {
        %UserList = $Self->{CustomerUserObject}->CustomerSearch(
            Valid => 0,
            Search => $Search,
        );
    }
    # build user result list
    my $Link = '';
    if (%UserList) {
        foreach (sort keys %UserList) {
            my $AddLink = '';
            if ($Nav eq 'None') {
                $AddLink = "<a href=\"\" onclick=\"updateMessage('$_')\">\$Text{\"Take this Customer\"}</a>";
            }
            else {
                $AddLink = $_;
            }
            $Link .= "<tr><td valign='top'>$AddLink</td><td valign='top'><a href=\"\$Env{\"Baselink\"}Action=AdminCustomerUser&Subaction=Change&ID=$_&Search=".$Self->{LayoutObject}->LinkEncode($Search)."&Nav=$Nav\">".$Self->{LayoutObject}->Ascii2Html(Text => $UserList{$_}, Max => 45)."</a></td></tr>";
        }
    }
    # get user data 2 form
    if ($Self->{Subaction} eq 'Change') {
        my $User = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        # get user data
        my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $User);
        my $Output = $NavBar.$Self->{LayoutObject}->AdminCustomerUserForm(
            Nav => $Nav,
            UserLinkList => $Link,
            SourceList => {$Self->{CustomerUserObject}->CustomerSourceList()},
            Source => $Source,
            Search => $Search,
            %UserData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # update action
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
                OP => "Action=AdminCustomerUser&Nav=$Nav&Search=$Search",
            );
        }
        else {
            my $Output = $NavBar.$Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # search
    elsif ($Self->{Subaction} eq 'Search') {
        my $Output .= $NavBar.$Self->{LayoutObject}->AdminCustomerUserForm(
            Nav => $Nav,
            UserLinkList => $Link,
            SourceList => {$Self->{CustomerUserObject}->CustomerSourceList()}, 
            Search => $Search,
            Source => $Source,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # add new user
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
                OP => "Action=AdminCustomerUser&Nav=$Nav&Search=$Search&AddedUID=$User",
            );
        }
        else {
            my $Output = $NavBar.$Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # else ! print form
    else {
        my $Output .= $NavBar.$Self->{LayoutObject}->AdminCustomerUserForm(
            Nav => $Nav,
            UserLinkList => $Link,
            SourceList => {$Self->{CustomerUserObject}->CustomerSourceList()}, 
            Search => $Search,
            Source => $Source,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;
