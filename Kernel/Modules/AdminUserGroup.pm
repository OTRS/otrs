# --
# Kernel/Modules/AdminUserGroup.pm - to add/update/delete groups <-> users
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminUserGroup.pm,v 1.13 2003-11-19 01:32:04 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminUserGroup;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.13 $';
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
        my %Types = ();
        foreach my $Type (qw(ro move create owner priority state rw)) {
            my %Data = $Self->{GroupObject}->GroupMemberList(
                UserID => $ID,
                Type => $Type,
                Result => 'HASH',
            );
            $Types{$Type} = \%Data;
        }
        $Output .= $Self->MaskAdminUserGroupChangeForm(
            Data => \%GroupData,
            %Types, 
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
        foreach (keys %UserData) {
            # get user data 
            my %User = $Self->{UserObject}->GetUserData(UserID => $_, Cached => 1);
            if ($User{UserFirstname} && $User{UserLastname}) {
                $UserData{$_} .= " ($User{UserFirstname} $User{UserLastname})";
            }
        }
        # get permission list users
        my %Types = ();
        foreach my $Type (qw(ro move create owner priority state rw)) {
            my %Data = $Self->{GroupObject}->GroupMemberList(
                GroupID => $ID,
                Type => $Type,
                Result => 'HASH',
            );
            $Types{$Type} = \%Data;
        }
        # get group data
        my %GroupData = $Self->{GroupObject}->GroupGet(ID => $ID);
        $Output .= $Self->MaskAdminUserGroupChangeForm(
            %Types,
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
        my %Permissions = ();
        foreach (qw(ro move create owner priority state rw)) {
            my @IDs = $Self->{ParamObject}->GetArray(Param => $_);
            $Permissions{$_} = \@IDs;
        }
        # get group data
        my %UserData = $Self->{UserObject}->UserList(Valid => 1);
        my %NewPermission = ();
        foreach (keys %UserData) { 
            foreach my $Permission (keys %Permissions) {
                $NewPermission{$Permission} = 0;
                my @Array = @{$Permissions{$Permission}};
                foreach my $ID (@Array) {
                    if ($_ == $ID) {
                        $NewPermission{$Permission} = 1;
print STDERR "$_: $Permission = 1\n";
                    }
                }
            }
print STDERR "$_:$ID \n";
            $Self->{GroupObject}->GroupMemberAdd(
                UID => $_,
                GID => $ID,
                %NewPermission,
                UserID => $Self->{UserID},
            );
        }
        $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");    
    }
    # groups to user
    elsif ($Self->{Subaction} eq 'ChangeUser') {
        # get new groups
        my %Permissions = ();
        foreach (qw(ro move create owner priority state rw)) {
            my @IDs = $Self->{ParamObject}->GetArray(Param => $_);
            $Permissions{$_} = \@IDs;
        }
        # get group data
        my %GroupData = $Self->{GroupObject}->GroupList(Valid => 1);
        my %NewPermission = ();
        foreach (keys %GroupData) {
            foreach my $Permission (keys %Permissions) {
                $NewPermission{$Permission} = 0;
                my @Array = @{$Permissions{$Permission}};
                foreach my $ID (@Array) {
                    if ($_ == $ID) {
                        $NewPermission{$Permission} = 1;
                    }
                }
            }
            $Self->{GroupObject}->GroupMemberAdd(
                UID => $ID, 
                GID => $_,  
                %NewPermission,
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
        foreach (keys %UserData) {
            # get user data 
            my %User = $Self->{UserObject}->GetUserData(UserID => $_, Cached => 1);
            if ($User{UserFirstname} && $User{UserLastname}) {
                $UserData{$_} .= " ($User{UserFirstname} $User{UserLastname})";
            }
        }
        # get group data
        my %GroupData = $Self->{GroupObject}->GroupList(Valid => 1);
        $Output .= $Self->MaskAdminUserGroupForm(
            GroupData => \%GroupData, 
            UserData => \%UserData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --
sub MaskAdminUserGroupChangeForm {
    my $Self = shift;
    my %Param = @_;
    my %Data = %{$Param{Data}};
    my $BaseLink = $Self->{LayoutObject}->{Baselink};
    my $Type = $Param{Type} || 'User';
    my $NeType = 'Group';
    $NeType = 'User' if ($Type eq 'Group');


    $Param{OptionStrg0} .= "<B>\$Text{\"$Type\"}:</B> <A HREF=\"$BaseLink"."Action=Admin$Type&Subaction=Change&ID=$Param{ID}\">" .
    "$Param{Name}</A> (id=$Param{ID})<BR>";
    $Param{OptionStrg0} .= '<INPUT TYPE="hidden" NAME="ID" VALUE="'.$Param{ID}.'"><BR>';

    $Param{OptionStrg0} .= "<br>\n";
    $Param{OptionStrg0} .= "<table>\n";
    $Param{OptionStrg0} .= "<tr><th>\$Text{\"$NeType\"}</th><th>ro</th><th>move</th><th>create</th><th>owner</th><th>priority</th><th>state</th><th>-</th><th>rw</th></tr>\n";
    foreach (sort {uc($Data{$a}) cmp uc($Data{$b})} keys %Data){
        $Param{OptionStrg0} .= '<tr><td>';
        $Param{OptionStrg0} .= "<a href=\"$BaseLink"."Action=Admin$NeType&Subaction=Change&ID=$_\">$Param{Data}->{$_}</a>";
        my $RoSelected = '';
        if ($Param{ro}->{$_}) {
            $RoSelected = ' checked';
        }
        $Param{OptionStrg0} .= '</td><td align="center">';
        $Param{OptionStrg0} .= '<input type="checkbox" name="ro" value="'.$_."\"$RoSelected>";
        my $MoveSelected = '';
        if ($Param{move}->{$_}) {
            $MoveSelected = ' checked';
        }
        $Param{OptionStrg0} .= '</td><td align="center">';
        $Param{OptionStrg0} .= '<input type="checkbox" name="move" value="'.$_."\"$MoveSelected>";
        my $CreateSelected = '';
        if ($Param{create}->{$_}) {
            $CreateSelected = ' checked';
        }
        $Param{OptionStrg0} .= '</td><td align="center">';
        $Param{OptionStrg0} .= '<input type="checkbox" name="create" value="'.$_."\"$CreateSelected>";
        my $OwnerSelected = '';
        if ($Param{owner}->{$_}) {
            $OwnerSelected = ' checked';
        }
        $Param{OptionStrg0} .= '</td><td align="center">';
        $Param{OptionStrg0} .= '<input type="checkbox" name="owner" value="'.$_."\"$OwnerSelected>";
        my $PrioritySelected = '';
        if ($Param{priority}->{$_}) {
            $PrioritySelected = ' checked';
        }
        $Param{OptionStrg0} .= '</td><td align="center">';
        $Param{OptionStrg0} .= '<input type="checkbox" name="priority" value="'.$_."\"$PrioritySelected>";
        my $StateSelected = '';
        if ($Param{state}->{$_}) {
            $StateSelected = ' checked';
        }
        $Param{OptionStrg0} .= '</td><td align="center">';
        $Param{OptionStrg0} .= '<input type="checkbox" name="state" value="'.$_."\"$StateSelected>";
        $Param{OptionStrg0} .= '</td><td align="center">|';
        my $RwSelected = '';
        if ($Param{rw}->{$_}) {
            $RwSelected = ' checked';
        }
        $Param{OptionStrg0} .= '</td><td align="center">';
        $Param{OptionStrg0} .= '<input type="checkbox" name="rw" value="'.$_."\"$RwSelected>";
        $Param{OptionStrg0} .= '</td></tr>'."\n";
    }
    $Param{OptionStrg0} .= "</table>\n";

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminUserGroupChangeForm', 
        Data => \%Param,
    );
}
# --
sub MaskAdminUserGroupForm {
    my $Self = shift;
    my %Param = @_;
    my $UserData = $Param{UserData};
    my %UserDataTmp = %$UserData;
    my $GroupData = $Param{GroupData};
    my %GroupDataTmp = %$GroupData;
    my $BaseLink = $Self->{LayoutObject}->{Baselink} . "Action=AdminUserGroup&";
    
    foreach (sort {uc($UserDataTmp{$a}) cmp uc($UserDataTmp{$b})} keys %UserDataTmp){
      $Param{UserStrg} .= "<A HREF=\"$BaseLink"."Subaction=User&ID=$_\">$UserDataTmp{$_}</A><BR>";
    }
    foreach (sort {uc($GroupDataTmp{$a}) cmp uc($GroupDataTmp{$b})} keys %GroupDataTmp){
      $Param{GroupStrg} .= "<A HREF=\"$BaseLink"."Subaction=Group&ID=$_\">$GroupDataTmp{$_}</A><BR>";
    }
    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminUserGroupForm', 
        Data => \%Param,
    );
}
# --

1;
