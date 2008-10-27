# --
# Kernel/Modules/AdminRoleUser.pm - to add/update/delete role <-> users
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminRoleUser.pm,v 1.15 2008-10-27 00:13:15 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AdminRoleUser;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.15 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';

    # user <-> role 1:n
    if ( $Self->{Subaction} eq 'User' ) {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # get user data
        my %UserData = $Self->{UserObject}->GetUserData( UserID => $ID );

        # get group data
        my %RoleData = $Self->{GroupObject}->RoleList( Valid => 1 );

        # get role member
        my %Member = $Self->{GroupObject}->GroupUserRoleMemberList(
            UserID => $ID,
            Result => 'HASH',
        );
        $Output .= $Self->MaskAdminUserGroupChangeForm(
            Selected => \%Member,
            Data     => \%RoleData,
            ID       => $UserData{UserID},
            Name     => $UserData{UserLogin},
            Type     => 'User',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # roles <-> user n:1
    elsif ( $Self->{Subaction} eq 'Role' ) {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # get user data
        my %UserData = $Self->{UserObject}->UserList( Valid => 1 );
        for ( keys %UserData ) {

            # get user data
            my %User = $Self->{UserObject}->GetUserData( UserID => $_, Cached => 1 );
            if ( $User{UserFirstname} && $User{UserLastname} ) {
                $UserData{$_} .= " ($User{UserFirstname} $User{UserLastname})";
            }
        }

        # get group data
        my %RoleData = $Self->{GroupObject}->RoleGet( ID => $ID );

        # get role member
        my %Member = $Self->{GroupObject}->GroupUserRoleMemberList(
            RoleID => $ID,
            Result => 'HASH',
        );
        $Output .= $Self->MaskAdminUserGroupChangeForm(
            Selected => \%Member,
            Data     => \%UserData,
            ID       => $RoleData{ID},
            Name     => $RoleData{Name},
            Type     => 'Role',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # add user to roles
    elsif ( $Self->{Subaction} eq 'ChangeRole' ) {

        # get new role member
        my @IDs = $Self->{ParamObject}->GetArray( Param => 'Role' );

        # get user list
        my %UserData = $Self->{UserObject}->UserList( Valid => 1 );
        for my $UserID ( keys %UserData ) {
            my $Active = 0;
            for (@IDs) {
                if ( $_ eq $UserID ) {
                    $Active = 1;
                }
            }
            $Self->{GroupObject}->GroupUserRoleMemberAdd(
                UID    => $UserID,
                RID    => $ID,
                Active => $Active,
                UserID => $Self->{UserID},
            );
        }
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=AdminRoleUser&Subaction=Role&ID=$ID"
        );
    }

    # roles to users
    elsif ( $Self->{Subaction} eq 'ChangeUser' ) {

        # get new role member
        my @IDs = $Self->{ParamObject}->GetArray( Param => 'User' );

        # get user list
        my %RoleData = $Self->{GroupObject}->RoleList( Valid => 1 );
        for my $RoleID ( keys %RoleData ) {
            my $Active = 0;
            for (@IDs) {
                if ( $_ eq $RoleID ) {
                    $Active = 1;
                }
            }
            $Self->{GroupObject}->GroupUserRoleMemberAdd(
                UID    => $ID,
                RID    => $RoleID,
                Active => $Active,
                UserID => $Self->{UserID},
            );
        }
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=AdminRoleUser&Subaction=User&ID=$ID"
        );
    }

    # else ! print form
    else {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # get user data
        my %UserData = $Self->{UserObject}->UserList( Valid => 1 );
        for ( keys %UserData ) {

            # get user data
            my %User = $Self->{UserObject}->GetUserData( UserID => $_, Cached => 1 );
            if ( $User{UserFirstname} && $User{UserLastname} ) {
                $UserData{$_} .= " ($User{UserFirstname} $User{UserLastname})";
            }
        }

        # get group data
        my %RoleData = $Self->{GroupObject}->RoleList( Valid => 1 );
        $Output .= $Self->MaskAdminUserGroupForm(
            RoleData => \%RoleData,
            UserData => \%UserData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub MaskAdminUserGroupChangeForm {
    my ( $Self, %Param ) = @_;

    my %Data   = %{ $Param{Data} };
    my $Type   = $Param{Type} || 'User';
    my $NeType = 'Role';
    $NeType = 'User' if ( $Type eq 'Role' );
    my $CssClass = 'searchactive';
    for ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        # set output class
        if ( $CssClass && $CssClass eq 'searchactive' ) {
            $CssClass = 'searchpassive';
        }
        else {
            $CssClass = 'searchactive';
        }

        # input box
        my $Selected = '';
        if ( $Param{Selected}->{$_} ) {
            $Selected = ' checked';
        }
        my $Input = '<input type="checkbox" name="' . $Type . '" value="' . $_ . "\"$Selected>";
        $Self->{LayoutObject}->Block(
            Name => 'Row',
            Data => {
                Name     => $Param{Data}->{$_},
                InputBox => $Input,
                Type     => $Type,
                NeType   => $NeType,
                ID       => $_,
                CssClass => $CssClass,
            },
        );
    }

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminRoleUserChangeForm',
        Data => { %Param, NeType => $NeType },
    );
}

sub MaskAdminUserGroupForm {
    my ( $Self, %Param ) = @_;

    my $UserData     = $Param{UserData};
    my %UserDataTmp  = %$UserData;
    my $GroupData    = $Param{RoleData};
    my %GroupDataTmp = %$GroupData;
    my $BaseLink     = $Self->{LayoutObject}->{Baselink} . "Action=AdminRoleUser&";
    for ( sort { uc( $UserDataTmp{$a} ) cmp uc( $UserDataTmp{$b} ) } keys %UserDataTmp ) {
        $UserDataTmp{$_} = $Self->{LayoutObject}->Ascii2Html(
            Text                => $UserDataTmp{$_},
            HTMLQuote           => 1,
            LanguageTranslation => 0,
        ) || '';
        $Param{UserStrg}
            .= "<A HREF=\"$BaseLink" . "Subaction=User&ID=$_\">$UserDataTmp{$_}</A><BR>";
    }
    for ( sort { uc( $GroupDataTmp{$a} ) cmp uc( $GroupDataTmp{$b} ) } keys %GroupDataTmp ) {
        $GroupDataTmp{$_} = $Self->{LayoutObject}->Ascii2Html(
            Text                => $GroupDataTmp{$_},
            HTMLQuote           => 1,
            LanguageTranslation => 0,
        ) || '';
        $Param{RoleStrg}
            .= "<A HREF=\"$BaseLink" . "Subaction=Role&ID=$_\">$GroupDataTmp{$_}</A><BR>";
    }

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminRoleUserForm',
        Data         => \%Param,
    );
}

1;
