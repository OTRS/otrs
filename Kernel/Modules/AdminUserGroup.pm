# --
# Kernel/Modules/AdminUserGroup.pm - to add/update/delete groups <-> users
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminUserGroup.pm,v 1.9 2003-03-23 21:34:18 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminUserGroup;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.9 $';
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

    # user <-> group 1:n
    if ($Self->{Subaction} eq 'User') {
        $Output .= $Self->{LayoutObject}->Header(Title => 'User <-> Group');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        # get user data 
        my %UserData = $Self->{UserObject}->GetUserData(UserID => $ID);
        # get group data
        my %GroupData = $Self->{GroupObject}->GroupList(Valid => 1);
        my %Read = $Self->{GroupObject}->GroupUserList(
            UserID => $ID,
            Type => 'ro',
            Result => 'HASH',
        );
        my %Write = $Self->{GroupObject}->GroupUserList(
            UserID => $ID,
            Type => 'rw',
            Result => 'HASH',
        );
        $Output .= $Self->{LayoutObject}->AdminUserGroupChangeForm(
            Data => \%GroupData,
            Ro => \%Read,
            Rw => \%Write,
            ID => $UserData{UserID},
            Name => $UserData{UserLogin},
            Type => 'User',
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # group <-> user n:1
    elsif ($Self->{Subaction} eq 'Group') {
        $Output .= $Self->{LayoutObject}->Header(Title => 'User <-> Group');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        # get user data 
        my %UserData = $Self->{UserObject}->UserList(Valid => 1);
        my %Read = $Self->{GroupObject}->GroupMemberList(
            GroupID => $ID,
            Type => 'ro',
            Result => 'HASH',
        );
        my %Write = $Self->{GroupObject}->GroupMemberList(
            GroupID => $ID,
            Type => 'rw',
            Result => 'HASH',
        );
        # get group data
        my %GroupData = $Self->{GroupObject}->GroupGet(ID => $ID);
        $Output .= $Self->{LayoutObject}->AdminUserGroupChangeForm(
            Ro => \%Read,
            Rw => \%Write,
            Data => \%UserData,
            ID => $GroupData{ID},
            Name => $GroupData{Name},
            Type => 'Group',
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # add user to groups
    elsif ($Self->{Subaction} eq 'ChangeGroup') {
        # get new groups
        my @RoIDs = $Self->{ParamObject}->GetArray(Param => 'RoIDs');
        my @RwIDs = $Self->{ParamObject}->GetArray(Param => 'RwIDs');
        # get group data
        my %UserData = $Self->{UserObject}->UserList(Valid => 1);
        foreach (keys %UserData) {
            my $Ro = 0;
            my $Rw = 0;
            foreach my $ID (@RoIDs) {
                if ($_ == $ID) {
                    $Ro = 1;
                }
            }
            foreach my $ID (@RwIDs) {
                if ($_ == $ID) {
                    $Rw = 1;
                }
            }
            $Self->{GroupObject}->GroupMemberAdd(
                UID => $_, 
                GID => $ID,  
                Ro => $Ro, 
                Rw => $Rw,
                UserID => $Self->{UserID},
            );
        }
        $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");    
    }
    # groups to user
    elsif ($Self->{Subaction} eq 'ChangeUser') {
        # get new groups
        my @RoIDs = $Self->{ParamObject}->GetArray(Param => 'RoIDs');
        my @RwIDs = $Self->{ParamObject}->GetArray(Param => 'RwIDs');
        # get group data
        my %GroupData = $Self->{GroupObject}->GroupList(Valid => 1);
        foreach (keys %GroupData) {
            my $Ro = 0;
            my $Rw = 0;
            foreach my $ID (@RoIDs) {
                if ($_ == $ID) {
                    $Ro = 1;
                }
            }
            foreach my $ID (@RwIDs) {
                if ($_ == $ID) {
                    $Rw = 1;
                }
            }
            $Self->{GroupObject}->GroupMemberAdd(
                UID => $ID, 
                GID => $_,  
                Ro => $Ro, 
                Rw => $Rw,
                UserID => $Self->{UserID},
            );
        }
        $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");
    }
    # else ! print form 
    else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'User <-> Group');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        # get user data 
        my %UserData = $Self->{UserObject}->UserList(Valid => 1);
        # get group data
        my %GroupData = $Self->{GroupObject}->GroupList(Valid => 1);
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
