# --
# Kernel/Modules/AdminRoleUser.pm - to add/update/delete groups <-> users
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AdminRoleUser.pm,v 1.27 2010-04-15 18:06:04 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminRoleUser;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.27 $) [1];

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
    # user <-> group 1:n
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'User' ) {

        # get user data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %UserData = $Self->{UserObject}->GetUserData( UserID => $ID );

        # get group data
        my %RoleData = $Self->{GroupObject}->RoleList( Valid => 1 );

        # get role member
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
            Name     => $UserData{UserLogin},
            Type     => 'User',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # group <-> user n:1
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Role' ) {

        # get group data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %RoleData = $Self->{GroupObject}->RoleGet( ID => $ID );

        # get user list
        my %UserData = $Self->{UserObject}->UserList( Valid => 1 );

        # get user name
        for my $UserID ( keys %UserData ) {
            my $Name = $Self->{UserObject}->UserName( UserID => $UserID );
            next if !$Name;
            $UserData{$UserID} .= " ($Name)";
        }

        # get role member
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
    # add user to groups
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeRole' ) {

        # get new role member
        my @IDs = $Self->{ParamObject}->GetArray( Param => 'Role' );

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # get user list
        my %UserData = $Self->{UserObject}->UserList( Valid => 1 );
        for my $UserID ( keys %UserData ) {
            my $Active = 0;
            for my $RoleID (@IDs) {
                next if $RoleID ne $UserID;
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
    # groups to user
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeUser' ) {

        # get new role member
        my @IDs = $Self->{ParamObject}->GetArray( Param => 'User' );

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # get user list
        my %RoleData = $Self->{GroupObject}->RoleList( Valid => 1 );
        for my $RoleID ( keys %RoleData ) {
            my $Active = 0;
            for my $UserID (@IDs) {
                next if $UserID ne $RoleID;
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

    $Self->{LayoutObject}->Block(
        Name => 'Change',
        Data => {
            %Param,
            ActionHome => 'Admin' . $Type,
            NeType     => $NeType,
        },
    );
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
    for my $UserID ( keys %UserData ) {
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

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminRoleUser',
        Data         => \%Param,
    );
}

1;
