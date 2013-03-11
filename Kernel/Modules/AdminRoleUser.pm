# --
# Kernel/Modules/AdminRoleUser.pm - to add/update/delete roles <-> users
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminRoleUser;

use strict;
use warnings;

use vars qw($VERSION);

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

    # ------------------------------------------------------------ #
    # user <-> role 1:n  interface to assign roles to an user
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'User' ) {

        # get user data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %UserData = $Self->{UserObject}->GetUserData( UserID => $ID );

        # get role list
        my %RoleData = $Self->{GroupObject}->RoleList( Valid => 1 );

        # get roles in which the user is a member
        my %Member = $Self->{GroupObject}->GroupUserRoleMemberList(
            UserID => $ID,
            Result => 'HASH',
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%RoleData,
            ID       => $UserData{UserID},
            Name     => "$UserData{UserFirstname} $UserData{UserLastname} ($UserData{UserLogin})",
            Type     => 'User',
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # role <-> user n:1  interface to assign users to a role
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Role' ) {

        # get role data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %RoleData = $Self->{GroupObject}->RoleGet( ID => $ID );

        # get user list, with the full name in the value
        my %UserData = $Self->{UserObject}->UserList( Valid => 1 );
        for my $UserID ( sort keys %UserData ) {
            my $Name = $Self->{UserObject}->UserName( UserID => $UserID );
            next if !$Name;
            $UserData{$UserID} .= " ($Name)";
        }

        # get members of the the role
        my %Member = $Self->{GroupObject}->GroupUserRoleMemberList(
            RoleID => $ID,
            Result => 'HASH',
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%UserData,
            ID       => $RoleData{ID},
            Name     => $RoleData{Name},
            Type     => 'Role',
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # add or remove users to a role
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeRole' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # to be set members of the role
        my @IDs = $Self->{ParamObject}->GetArray( Param => 'Role' );

        # get the role id
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # get user list
        my %UserData = $Self->{UserObject}->UserList( Valid => 1 );

        # add or remove user from roles
        for my $UserID ( sort keys %UserData ) {
            my $Active = 0;
            for my $MemberOfRole (@IDs) {
                next if $MemberOfRole ne $UserID;
                $Active = 1;
                last;
            }
            $Self->{GroupObject}->GroupUserRoleMemberAdd(
                UID    => $UserID,
                RID    => $ID,
                Active => $Active,
                UserID => $Self->{UserID},
            );
        }

        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # add or remove roles for a user
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeUser' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # to be set roles of the user
        my @IDs = $Self->{ParamObject}->GetArray( Param => 'User' );

        # get user id
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # get role list
        my %RoleData = $Self->{GroupObject}->RoleList( Valid => 1 );

        # add or remove user from roles
        for my $RoleID ( sort keys %RoleData ) {
            my $Active = 0;
            for my $RoleOfMember (@IDs) {
                next if $RoleOfMember ne $RoleID;
                $Active = 1;
                last;
            }
            $Self->{GroupObject}->GroupUserRoleMemberAdd(
                UID    => $ID,
                RID    => $RoleID,
                Active => $Active,
                UserID => $Self->{UserID},
            );
        }

        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->_Overview();
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my %Data   = %{ $Param{Data} };
    my $Type   = $Param{Type} || 'User';
    my $NeType = $Type eq 'Role' ? 'User' : 'Role';

    my %VisibleType = ( Role => 'Role', User => 'Agent' );

    $Self->{LayoutObject}->Block(
        Name => 'Change',
        Data => {
            %Param,
            ActionHome    => 'Admin' . $Type,
            NeType        => $NeType,
            VisibleType   => $VisibleType{$Type},
            VisibleNeType => $VisibleType{$NeType},
        },
    );

    $Self->{LayoutObject}->Block( Name => "ChangeHeader$VisibleType{$NeType}" );

    $Self->{LayoutObject}->Block(
        Name => 'ChangeHeader',
        Data => {
            %Param,
            Type   => $Type,
            NeType => $NeType,
        },
    );

    for my $ID ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        # set output class
        my $Selected = $Param{Selected}->{$ID} ? ' checked="checked"' : '';

        $Self->{LayoutObject}->Block(
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

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminRoleUser',
        Data         => \%Param,
    );
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => {},
    );

    # get user list
    my %UserData = $Self->{UserObject}->UserList( Valid => 1 );

    # get user name
    for my $UserID ( sort keys %UserData ) {
        my $Name = $Self->{UserObject}->UserName( UserID => $UserID );
        next if !$Name;
        $UserData{$UserID} .= " ($Name)";
    }
    for my $UserID ( sort { uc( $UserData{$a} ) cmp uc( $UserData{$b} ) } keys %UserData ) {

        # set output class
        $Self->{LayoutObject}->Block(
            Name => 'List1n',
            Data => {
                Name      => $UserData{$UserID},
                Subaction => 'User',
                ID        => $UserID,
            },
        );
    }

    # get group data
    my %RoleData = $Self->{GroupObject}->RoleList( Valid => 1 );
    if (%RoleData) {
        for my $RoleID ( sort { uc( $RoleData{$a} ) cmp uc( $RoleData{$b} ) } keys %RoleData ) {

            # set output class
            $Self->{LayoutObject}->Block(
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
        $Self->{LayoutObject}->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminRoleUser',
        Data         => \%Param,
    );
}

1;
