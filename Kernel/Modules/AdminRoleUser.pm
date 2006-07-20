# --
# Kernel/Modules/AdminRoleUser.pm - to add/update/delete role <-> users
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminRoleUser.pm,v 1.7 2006-07-20 17:04:39 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminRoleUser;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
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
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }
    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';

    # user <-> role 1:n
    if ($Self->{Subaction} eq 'User') {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        # get user data
        my %UserData = $Self->{UserObject}->GetUserData(UserID => $ID);
        # get group data
        my %RoleData = $Self->{GroupObject}->RoleList(Valid => 1);
        # get role member
        my %Member = $Self->{GroupObject}->GroupUserRoleMemberList(
            UserID => $ID,
            Result => 'HASH',
        );
        $Output .= $Self->MaskAdminUserGroupChangeForm(
            Selected => \%Member,
            Data => \%RoleData,
            ID => $UserData{UserID},
            Name => $UserData{UserLogin},
            Type => 'User',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # roles <-> user n:1
    elsif ($Self->{Subaction} eq 'Role') {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        # get user data
        my %UserData = $Self->{UserObject}->UserList(Valid => 1);
        foreach (keys %UserData) {
            # get user data
            my %User = $Self->{UserObject}->GetUserData(UserID => $_, Cached => 1);
            if ($User{UserFirstname} && $User{UserLastname}) {
                $UserData{$_} .= " ($User{UserFirstname} $User{UserLastname})";
            }
        }
        # get group data
        my %RoleData = $Self->{GroupObject}->RoleGet(ID => $ID);
        # get role member
        my %Member = $Self->{GroupObject}->GroupUserRoleMemberList(
            RoleID => $ID,
            Result => 'HASH',
        );
        $Output .= $Self->MaskAdminUserGroupChangeForm(
            Selected => \%Member,
            Data => \%UserData,
            ID => $RoleData{ID},
            Name => $RoleData{Name},
            Type => 'Role',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # add user to roles
    elsif ($Self->{Subaction} eq 'ChangeRole') {
        # get new role member
        my @IDs = $Self->{ParamObject}->GetArray(Param => 'Role');
        # get user list
        my %UserData = $Self->{UserObject}->UserList(Valid => 1);
        foreach my $UserID (keys %UserData) {
            my $Active = 0;
            foreach (@IDs) {
                if ($_ eq $UserID) {
                    $Active = 1;
                }
            }
            $Self->{GroupObject}->GroupUserRoleMemberAdd(
                UID => $UserID,
                RID => $ID,
                Active => $Active,
                UserID => $Self->{UserID},
            );
        }
        return $Self->{LayoutObject}->Redirect(OP => "Action=AdminRoleUser&Subaction=Role&ID=$ID");
    }
    # roles to users
    elsif ($Self->{Subaction} eq 'ChangeUser') {
        # get new role member
        my @IDs = $Self->{ParamObject}->GetArray(Param => 'User');
        # get user list
        my %RoleData = $Self->{GroupObject}->RoleList(Valid => 1);
        foreach my $RoleID (keys %RoleData) {
            my $Active = 0;
            foreach (@IDs) {
                if ($_ eq $RoleID) {
                    $Active = 1;
                }
            }
            $Self->{GroupObject}->GroupUserRoleMemberAdd(
                UID => $ID,
                RID => $RoleID,
                Active => $Active,
                UserID => $Self->{UserID},
            );
        }
        return $Self->{LayoutObject}->Redirect(OP => "Action=AdminRoleUser&Subaction=User&ID=$ID");
    }
    # else ! print form
    else {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        # get user data
        my %UserData = $Self->{UserObject}->UserList(Valid => 1);
        foreach (keys %UserData) {
            # get user data
            my %User = $Self->{UserObject}->GetUserData(UserID => $_, Cached => 1);
            if ($User{UserFirstname} && $User{UserLastname}) {
                $UserData{$_} .= " ($User{UserFirstname} $User{UserLastname})";
            }
        }
        # get group data
        my %RoleData = $Self->{GroupObject}->RoleList(Valid => 1);
        $Output .= $Self->MaskAdminUserGroupForm(
            RoleData => \%RoleData,
            UserData => \%UserData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --
sub MaskAdminUserGroupChangeForm {
    my $Self = shift;
    my %Param = @_;
    my %Data = %{$Param{Data}};
    my $Type = $Param{Type} || 'User';
    my $NeType = 'Role';
    $NeType = 'User' if ($Type eq 'Role');

    foreach (sort {uc($Data{$a}) cmp uc($Data{$b})} keys %Data){
        # input box
        my $Selected = '';
        if ($Param{Selected}->{$_}) {
            $Selected = ' checked';
        }
        my $Input = '<input type="checkbox" name="'.$Type.'" value="'.$_."\"$Selected>";
        $Self->{LayoutObject}->Block(
            Name => 'Row',
            Data => {
                Name => $Param{Data}->{$_},
                InputBox => $Input,
                Type => $Type,
                NeType => $NeType,
                ID => $_,
            },
        );
    }

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminRoleUserChangeForm',
        Data => {%Param, NeType => $NeType},
    );
}
# --
sub MaskAdminUserGroupForm {
    my $Self = shift;
    my %Param = @_;
    my $UserData = $Param{UserData};
    my %UserDataTmp = %$UserData;
    my $GroupData = $Param{RoleData};
    my %GroupDataTmp = %$GroupData;
    my $BaseLink = $Self->{LayoutObject}->{Baselink} . "Action=AdminRoleUser&";

    foreach (sort {uc($UserDataTmp{$a}) cmp uc($UserDataTmp{$b})} keys %UserDataTmp){
        $UserDataTmp{$_} = $Self->{LayoutObject}->Ascii2Html(
            Text => $UserDataTmp{$_},
            HTMLQuote => 1,
            LanguageTranslation => 0,
        ) || '';
        $Param{UserStrg} .= "<A HREF=\"$BaseLink"."Subaction=User&ID=$_\">$UserDataTmp{$_}</A><BR>";
    }
    foreach (sort {uc($GroupDataTmp{$a}) cmp uc($GroupDataTmp{$b})} keys %GroupDataTmp){
        $GroupDataTmp{$_} = $Self->{LayoutObject}->Ascii2Html(
            Text => $GroupDataTmp{$_},
            HTMLQuote => 1,
            LanguageTranslation => 0,
        ) || '';
        $Param{RoleStrg} .= "<A HREF=\"$BaseLink"."Subaction=Role&ID=$_\">$GroupDataTmp{$_}</A><BR>";
    }
    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminRoleUserForm',
        Data => \%Param,
    );
}
# --

1;
