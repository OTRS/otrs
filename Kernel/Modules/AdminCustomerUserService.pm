# --
# Kernel/Modules/AdminCustomerUserService.pm - to add/update/delete customerusers <-> services
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AdminCustomerUserService.pm,v 1.1 2007-06-12 15:06:31 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminCustomerUserService;

use strict;
use Kernel::System::CustomerUser;
use Kernel::System::Service;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }
    # needed objects
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{ServiceObject} = Kernel::System::Service->new(%Param);

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $ID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';

    # user <-> service 1:n
    if ($Self->{Subaction} eq 'CustomerUser') {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        # get user data
        my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $ID);
        # get service data
        my %ServiceData = $Self->{ServiceObject}->ServiceList(
            Valid => 1,
            UserID => $Self->{UserID},
        );
        # get service member
        my %Member = $Self->{ServiceObject}->CustomerUserServiceMemberList(
            CustomerUserLogin => $ID,
            Result => 'HASH',
        );
        $Output .= $Self->MaskAdminUserServiceChangeForm(
            Selected => \%Member,
            Data => \%ServiceData,
            ID => $UserData{UserID},
            Name => $UserData{UserLogin},
            Type => 'CustomerUser',
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # user <-> service n:1
    elsif ($Self->{Subaction} eq 'Service') {
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
        # get service data
        my %ServiceData = $Self->{ServiceObject}->ServiceGet(
            ServiceID => $ID,
            UserID => $Self->{UserID},
        );
        # get service member
        my %Member = $Self->{ServiceObject}->CustomerUserServiceMemberList(
            ServiceID => $ID,
            Result => 'HASH',
        );
        $Output .= $Self->MaskAdminUserServiceChangeForm(
            Selected => \%Member,
            Data => \%UserData,
            ID => $ServiceData{ServiceID},
            Name => $ServiceData{Name},
            Type => 'Service',
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # add user to services
    elsif ($Self->{Subaction} eq 'ChangeCustomerUser') {
        # get new service member
        my @IDs = $Self->{ParamObject}->GetArray(Param => 'Service');
        # get service data
        my %ServiceData = $Self->{ServiceObject}->ServiceList(
            Valid => 1,
            UserID => $Self->{UserID},
        );
        foreach my $ServiceID (keys %ServiceData) {
            my $Active = 0;
            foreach (@IDs) {
                if ($_ eq $ServiceID) {
                    $Active = 1;
                }
            }
            $Self->{ServiceObject}->CustomerUserServiceMemberAdd(
                CustomerUserLogin => $ID,
                ServiceID => $ServiceID,
                Active => $Active,
                UserID => $Self->{UserID},
            );
        }
        return $Self->{LayoutObject}->Redirect(OP => "Action=AdminCustomerUserService&Subaction=CustomerUser&ID=$ID");
    }
    # services to users
    elsif ($Self->{Subaction} eq 'ChangeService') {
        # get new service member
        my @IDs = $Self->{ParamObject}->GetArray(Param => 'CustomerUser');
        # get user list
        my %UserData = $Self->{CustomerUserObject}->CustomerUserList(Valid => 1);
        foreach my $CoustomerUserLogin (keys %UserData) {
            my $Active = 0;
            foreach (@IDs) {
                if ($_ eq $CoustomerUserLogin) {
                    $Active = 1;
                }
            }
            $Self->{ServiceObject}->CustomerUserServiceMemberAdd(
                CustomerUserLogin => $CoustomerUserLogin,
                ServiceID => $ID,
                Active => $Active,
                UserID => $Self->{UserID},
            );
        }
        return $Self->{LayoutObject}->Redirect(OP => "Action=AdminCustomerUserService&Subaction=Service&ID=$ID");
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
        # get service data
        my %ServiceData = $Self->{ServiceObject}->ServiceList(
            Valid => 1,
            UserID => $Self->{UserID},
        );
        $Output .= $Self->MaskAdminUserServiceForm(
            ServiceData => \%ServiceData,
            UserData => \%UserData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}

sub MaskAdminUserServiceChangeForm {
    my $Self = shift;
    my %Param = @_;
    my %Data = %{$Param{Data}};
    my $Type = $Param{Type} || 'CustomerUser';
    my $NeType = 'Service';
    $NeType = 'CustomerUser' if ($Type eq 'Service');

    foreach (sort {uc($Data{$a}) cmp uc($Data{$b})} keys %Data) {
        # input box
        my $Selected = '';
        if ($Param{Selected}->{$_}) {
            $Selected = ' checked';
        }
        my $Input = '<input type="checkbox" name="'.$NeType.'" value="'.$_."\"$Selected>";
        if ($Type eq 'Service') {
            $Self->{LayoutObject}->Block(
                Name => 'CustomerUserRow',
                Data => {
                    Name => $Param{Data}->{$_},
                    InputBox => $Input,
                    Type => $Type,
                    NeType => $NeType,
                    ID => $_,
                },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'ServiceRow',
                Data => {
                    Name => $Param{Data}->{$_},
                    InputBox => $Input,
                    Type => $Type,
                    NeType => $NeType,
                    ID => $_,
                },
            );
        }
    }
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminCustomerUserServiceChangeForm',
        Data => {
            %Param,
            NeType => $NeType,
        },
    );
}

sub MaskAdminUserServiceForm {
    my $Self = shift;
    my %Param = @_;
    my $UserData = $Param{UserData};
    my %UserDataTmp = %{$UserData};
    my $ServiceData = $Param{ServiceData};
    my %ServiceDataTmp = %{$ServiceData};
    my $BaseLink = $Self->{LayoutObject}->{Baselink} . "Action=AdminCustomerUserService&";

    foreach (sort {uc($UserDataTmp{$a}) cmp uc($UserDataTmp{$b})} keys %UserDataTmp) {
        $Param{UserStrg} .= "<a href=\"$BaseLink"."Subaction=CustomerUser&ID=$_\">$UserDataTmp{$_}</a><br>";
    }
    foreach (sort {uc($ServiceDataTmp{$a}) cmp uc($ServiceDataTmp{$b})} keys %ServiceDataTmp) {
        $Param{ServiceStrg} .= "<a href=\"$BaseLink"."Subaction=Service&ID=$_\">$ServiceDataTmp{$_}</a><br>";
    }
    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminCustomerUserServiceForm',
        Data => \%Param,
    );
}

1;