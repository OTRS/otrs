# --
# Kernel/Modules/AdminCustomerUser.pm - to add/update/delete customer user
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminCustomerUser.pm,v 1.1 2002-10-15 09:30:15 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminCustomerUser;

use strict;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $ ';
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
        my $UserID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        # --
        # get user data
        # --
        my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(UserID => $UserID);
        my $Output = $Self->{LayoutObject}->Header(Title => 'Customer user update');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminCustomerUserForm(%UserData);
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
        foreach (qw(ID Login Pw Email Salutation Firstname Lastname CustomerID ValidID Comment)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        # --
        # update user
        # --
        if ($Self->{CustomerUserObject}->CustomerUserUpdate(%GetParam, UserID => $Self->{UserID})) {
            # --
            # redirect
            # --
            return $Self->{LayoutObject}->Redirect(OP => "&Action=$Param{NextScreen}");
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
        foreach (qw(Login Pw Email Salutation Firstname Lastname CustomerID ValidID Comment)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        # --
        # add user
        # --
        if (my $UserID = $Self->{CustomerUserObject}->CustomerUserAdd(%GetParam, UserID => $Self->{UserID})) {
            # --
            # redirect
            # --
            return $Self->{LayoutObject}->Redirect(
                OP => "&Action=AdminCustomerUser",
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
        $Output .= $Self->{LayoutObject}->AdminCustomerUserForm();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;
