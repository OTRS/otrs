# --
# Kernel/Modules/AdminRoleUser.pm - to add/update/delete roles <-> users
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminRoleUser;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $UserObject   = $Kernel::OM->Get('Kernel::System::User');
    my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');

    # ------------------------------------------------------------ #
    # user <-> role 1:n  interface to assign roles to an user
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'User' ) {

        # get user data
        my $ID = $ParamObject->GetParam( Param => 'ID' );
        my %UserData = $UserObject->GetUserData( UserID => $ID );

        # get role list
        my %RoleData = $GroupObject->RoleList( Valid => 1 );

        # get roles in which the user is a member
        my %Member = $GroupObject->PermissionUserRoleGet(
            UserID => $ID,
        );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%RoleData,
            ID       => $UserData{UserID},
            Name     => "$UserData{UserFirstname} $UserData{UserLastname} ($UserData{UserLogin})",
            Type     => 'User',
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # role <-> user n:1  interface to assign users to a role
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Role' ) {

        # get role data
        my $ID = $ParamObject->GetParam( Param => 'ID' );
        my %RoleData = $GroupObject->RoleGet( ID => $ID );

        # get user list, with the full name in the value
        my %UserData = $UserObject->UserList( Valid => 1 );
        USERID:
        for my $UserID ( sort keys %UserData ) {
            my $Name = $UserObject->UserName( UserID => $UserID );
            next USERID if !$Name;
            $UserData{$UserID} .= " ($Name)";
        }

        # get members of the the role
        my %Member = $GroupObject->PermissionRoleUserGet(
            RoleID => $ID,
        );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%UserData,
            ID       => $RoleData{ID},
            Name     => $RoleData{Name},
            Type     => 'Role',
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # add or remove users to a role
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeRole' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # to be set members of the role
        my @IDs = $ParamObject->GetArray( Param => 'Role' );

        # get the role id
        my $ID = $ParamObject->GetParam( Param => 'ID' );

        # get user list
        my %UserData = $UserObject->UserList( Valid => 1 );

        # add or remove user from roles
        for my $UserID ( sort keys %UserData ) {
            my $Active = 0;
            MEMBER_OF_ROLE:
            for my $MemberOfRole (@IDs) {
                next MEMBER_OF_ROLE if $MemberOfRole ne $UserID;
                $Active = 1;
                last MEMBER_OF_ROLE;
            }
            $GroupObject->PermissionRoleUserAdd(
                UID    => $UserID,
                RID    => $ID,
                Active => $Active,
                UserID => $Self->{UserID},
            );
        }

        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # add or remove roles for a user
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeUser' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # to be set roles of the user
        my @IDs = $ParamObject->GetArray( Param => 'User' );

        # get user id
        my $ID = $ParamObject->GetParam( Param => 'ID' );

        # get role list
        my %RoleData = $GroupObject->RoleList( Valid => 1 );

        # add or remove user from roles
        for my $RoleID ( sort keys %RoleData ) {
            my $Active = 0;
            ROLE_OF_MEMBER:
            for my $RoleOfMember (@IDs) {
                next ROLE_OF_MEMBER if $RoleOfMember ne $RoleID;
                $Active = 1;
                last ROLE_OF_MEMBER;
            }
            $GroupObject->PermissionRoleUserAdd(
                UID    => $ID,
                RID    => $RoleID,
                Active => $Active,
                UserID => $Self->{UserID},
            );
        }

        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $Self->_Overview();
    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my %Data   = %{ $Param{Data} };
    my $Type   = $Param{Type} || 'User';
    my $NeType = $Type eq 'Role' ? 'User' : 'Role';

    my %VisibleType = (
        Role => 'Role',
        User => 'Agent'
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Change',
        Data => {
            %Param,
            ActionHome    => 'Admin' . $Type,
            NeType        => $NeType,
            VisibleType   => $VisibleType{$Type},
            VisibleNeType => $VisibleType{$NeType},
        },
    );

    $LayoutObject->Block( Name => "ChangeHeader$VisibleType{$NeType}" );

    $LayoutObject->Block(
        Name => 'ChangeHeader',
        Data => {
            %Param,
            Type   => $Type,
            NeType => $NeType,
        },
    );

    # check if there are roles
    if ( $NeType eq 'Role' ) {
        if ( !%Data ) {
            $LayoutObject->Block(
                Name => 'NoDataFoundMsgList',
                Data => {
                    ColSpan => 2,
                },
            );
        }
    }

    for my $ID ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        # set output class
        my $Selected = $Param{Selected}->{$ID} ? ' checked="checked"' : '';

        $LayoutObject->Block(
            Name => 'ChangeRow',
            Data => {
                %Param,
                Name     => $Param{Data}->{$ID},
                NeType   => $NeType,
                Type     => $Type,
                ID       => $ID,
                Selected => $Selected,
            },
        );
    }

    return $LayoutObject->Output(
        TemplateFile => 'AdminRoleUser',
        Data         => \%Param,
    );
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => {},
    );

    # get user list
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
    my %UserData = $UserObject->UserList( Valid => 1 );

    # get user name
    USERID:
    for my $UserID ( sort keys %UserData ) {
        my $Name = $UserObject->UserName( UserID => $UserID );
        next USERID if !$Name;
        $UserData{$UserID} .= " ($Name)";
    }
    for my $UserID ( sort { uc( $UserData{$a} ) cmp uc( $UserData{$b} ) } keys %UserData ) {

        # set output class
        $LayoutObject->Block(
            Name => 'List1n',
            Data => {
                Name      => $UserData{$UserID},
                Subaction => 'User',
                ID        => $UserID,
            },
        );
    }

    # get group data
    my %RoleData = $Kernel::OM->Get('Kernel::System::Group')->RoleList( Valid => 1 );
    if (%RoleData) {
        for my $RoleID ( sort { uc( $RoleData{$a} ) cmp uc( $RoleData{$b} ) } keys %RoleData ) {

            # set output class
            $LayoutObject->Block(
                Name => 'Listn1',
                Data => {
                    Name      => $RoleData{$RoleID},
                    Subaction => 'Role',
                    ID        => $RoleID,
                },
            );
        }
    }
    else {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }

    # return output
    return $LayoutObject->Output(
        TemplateFile => 'AdminRoleUser',
        Data         => \%Param,
    );
}

1;
