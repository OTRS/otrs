# --
# Kernel/Modules/AdminCustomerUserGroup.pm - to add/update/delete groups <-> users
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: AdminCustomerUserGroup.pm,v 1.7.2.1 2006-09-27 08:37:19 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminCustomerUserGroup;

use strict;
use Kernel::System::CustomerUser;
use Kernel::System::CustomerGroup;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7.2.1 $';
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

    # needed objects
    $Self->{'CustomerUserObject'} = Kernel::System::CustomerUser->new(%Param);
    $Self->{'CustomerGroupObject'} = Kernel::System::CustomerGroup->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $UserID = $Self->{UserID};
    my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
    $Param{NextScreen} = 'AdminCustomerUserGroup';

    # check if feature is active
    if (!$Self->{ConfigObject}->Get('CustomerGroupSupport')) {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Warning(
            Message => 'Sorry, feature not active!',
            Comment => 'CustomerGroupSupport needs to be active in Kernel/Config.pm, read more about this feature in the documentation. Take care!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # user <-> group 1:n
    if ($Self->{Subaction} eq 'User') {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        # get user data
        my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $ID);
        # get group data
        my %GroupData = $Self->{GroupObject}->GroupList(Valid => 1);
        my %Types = ();
        foreach my $Type (@{$Self->{ConfigObject}->Get('System::Customer::Permission')}) {
            my %Data = $Self->{CustomerGroupObject}->GroupMemberList(
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
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        # get user data
        my %UserData = $Self->{CustomerUserObject}->CustomerUserList(Valid => 1);
        foreach (keys %UserData) {
            # get user data
            my %User = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $_, Cached => 1);
            if ($User{UserFirstname} && $User{UserLastname}) {
                $UserData{$_} .= " ($User{UserFirstname} $User{UserLastname})";
            }
        }
        # get permission list users
        my %Types = ();
        foreach my $Type (@{$Self->{ConfigObject}->Get('System::Customer::Permission')}) {
            my %Data = $Self->{CustomerGroupObject}->GroupMemberList(
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
        foreach (@{$Self->{ConfigObject}->Get('System::Customer::Permission')}) {
            my @IDs = $Self->{ParamObject}->GetArray(Param => $_);
            $Permissions{$_} = \@IDs;
        }
        # get group data
        my %UserData = $Self->{CustomerUserObject}->CustomerUserList(Valid => 1);
        my %NewPermission = ();
        foreach (keys %UserData) {
            foreach my $Permission (keys %Permissions) {
                $NewPermission{$Permission} = 0;
                my @Array = @{$Permissions{$Permission}};
                foreach my $ID (@Array) {
                    if ($_ eq $ID) {
                        $NewPermission{$Permission} = 1;
                    }
                }
            }
            $Self->{CustomerGroupObject}->GroupMemberAdd(
                UID => $_,
                GID => $ID,
                Permission => { %NewPermission },
                UserID => $Self->{UserID},
            );
        }
        $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");
    }
    # groups to user
    elsif ($Self->{Subaction} eq 'ChangeUser') {
        # get new groups
        my %Permissions = ();
        foreach (@{$Self->{ConfigObject}->Get('System::Customer::Permission')}) {
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
            $Self->{CustomerGroupObject}->GroupMemberAdd(
                UID => $ID,
                GID => $_,
                Permission => { %NewPermission },
                UserID => $Self->{UserID},
            );
        }
        $Output .= $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");
    }
    # else ! print form
    else {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        # get user data
        my %UserData = $Self->{CustomerUserObject}->CustomerUserList(Valid => 1);
        foreach (keys %UserData) {
            # get user data
            my %User = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $_, Cached => 1);
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
    my $Type = $Param{Type} || 'CustomerUser';
    my $NeType = 'Group';
    $NeType = 'User' if ($Type eq 'Group');


    $Param{OptionStrg0} .= "<B>\$Text{\"$Type\"}:</B> <A HREF=\"$BaseLink"."Action=Admin$Type&Subaction=Change&ID=$Param{ID}\">" .
    "$Param{Name}</A> (id=$Param{ID})<BR>";
    $Param{OptionStrg0} .= '<INPUT TYPE="hidden" NAME="ID" VALUE="'.$Param{ID}.'"><BR>';

    $Param{OptionStrg0} .= "<br>\n";
    $Param{OptionStrg0} .= "<table>\n";
    $Param{OptionStrg0} .= "<tr><th>\$Text{\"$NeType\"}</th>";
    foreach (@{$Self->{ConfigObject}->Get('System::Customer::Permission')}) {
        $Param{OptionStrg0} .= "<th>$_</th>";
    }
    $Param{OptionStrg0} .= "</tr>\n";
    foreach (sort {uc($Data{$a}) cmp uc($Data{$b})} keys %Data){
        $Param{OptionStrg0} .= '<tr><td>';
        $Param{OptionStrg0} .= "<a href=\"$BaseLink"."Action=Admin$NeType&Subaction=Change&ID=$_\">$Param{Data}->{$_}</a></td>";
        foreach my $Type (@{$Self->{ConfigObject}->Get('System::Customer::Permission')}) {
            my $Selected = '';
            if ($Param{$Type}->{$_}) {
                $Selected = ' checked';
            }
            $Param{OptionStrg0} .= '<td align="center">';
            if ($Type eq 'rw') {
                $Param{OptionStrg0} .= " | ";
            }
            $Param{OptionStrg0} .= '<input type="checkbox" name="'.$Type.'" value="'.$_."\"$Selected> </td>";

        }
        $Param{OptionStrg0} .= '</tr>'."\n";
    }
    $Param{OptionStrg0} .= "</table>\n";

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminCustomerUserGroupChangeForm',
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
    my $BaseLink = $Self->{LayoutObject}->{Baselink} . "Action=AdminCustomerUserGroup&";

    foreach (sort {uc($UserDataTmp{$a}) cmp uc($UserDataTmp{$b})} keys %UserDataTmp){
      $Param{UserStrg} .= "<A HREF=\"$BaseLink"."Subaction=User&ID=$_\">$UserDataTmp{$_}</A><BR>";
    }
    foreach (sort {uc($GroupDataTmp{$a}) cmp uc($GroupDataTmp{$b})} keys %GroupDataTmp){
      $Param{GroupStrg} .= "<A HREF=\"$BaseLink"."Subaction=Group&ID=$_\">$GroupDataTmp{$_}</A><BR>";
    }
    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminCustomerUserGroupForm',
        Data => \%Param,
    );
}
# --

1;
