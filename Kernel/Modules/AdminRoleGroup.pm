# --
# Kernel/Modules/AdminRoleGroup.pm - to add/update/delete groups <-> users
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminRoleGroup;

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
    # user <-> group 1:n
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Role' ) {

        # get user data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %RoleData = $Self->{GroupObject}->RoleGet( ID => $ID );

        # get group data
        my %GroupData = $Self->{GroupObject}->GroupList( Valid => 1 );
        my %Types;
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
            my %Data = $Self->{GroupObject}->GroupRoleMemberList(
                RoleID => $ID,
                Type   => $Type,
                Result => 'HASH',
            );
            $Types{$Type} = \%Data;
        }

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Change(
            %Types,
            Data => \%GroupData,
            ID   => $RoleData{ID},
            Name => $RoleData{Name},
            Type => 'Role',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # group <-> user n:1
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Group' ) {

        # get group data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %GroupData = $Self->{GroupObject}->GroupGet( ID => $ID );

        # get user list
        my %RoleData = $Self->{GroupObject}->RoleList( Valid => 1 );

        # get permission list users
        my %Types;
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
            my %Data = $Self->{GroupObject}->GroupRoleMemberList(
                GroupID => $ID,
                Type    => $Type,
                Result  => 'HASH',
            );
            $Types{$Type} = \%Data;
        }

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Change(
            %Types,
            Data => \%RoleData,
            ID   => $GroupData{ID},
            Name => $GroupData{Name},
            Type => 'Group',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add user to groups
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeGroup' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';

        # get new groups
        my %Permissions;
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
            my @IDs = $Self->{ParamObject}->GetArray( Param => $Type );
            $Permissions{$Type} = \@IDs;
        }

        # get group data
        my %RoleData = $Self->{GroupObject}->RoleList( Valid => 1 );
        my %NewPermission;
        for my $RoleID ( sort keys %RoleData ) {
            for my $Permission ( sort keys %Permissions ) {
                $NewPermission{$Permission} = 0;
                my @Array = @{ $Permissions{$Permission} };
                for my $ID (@Array) {
                    if ( $RoleID == $ID ) {
                        $NewPermission{$Permission} = 1;
                    }
                }
            }
            $Self->{GroupObject}->GroupRoleMemberAdd(
                RID        => $RoleID,
                GID        => $ID,
                Permission => \%NewPermission,
                UserID     => $Self->{UserID},
            );
        }
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # groups to user
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeRole' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # get new groups
        my %Permissions;
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
            my @IDs = $Self->{ParamObject}->GetArray( Param => $Type );
            $Permissions{$Type} = \@IDs;
        }

        # get group data
        my %GroupData = $Self->{GroupObject}->GroupList( Valid => 1 );
        my %NewPermission;
        for my $GroupID ( sort keys %GroupData ) {
            for my $Permission ( sort keys %Permissions ) {
                $NewPermission{$Permission} = 0;
                my @Array = @{ $Permissions{$Permission} };
                for my $ID (@Array) {
                    if ( $GroupID == $ID ) {
                        $NewPermission{$Permission} = 1;
                    }
                }
            }
            $Self->{GroupObject}->GroupRoleMemberAdd(
                RID        => $ID,
                GID        => $GroupID,
                Permission => \%NewPermission,
                UserID     => $Self->{UserID},
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
    my $Type   = $Param{Type} || 'Role';
    my $NeType = $Type eq 'Group' ? 'Role' : 'Group';

    $Self->{LayoutObject}->Block(
        Name => 'Change',
        Data => {
            %Param,
            ActionHome => 'Admin' . $Type,
            NeType     => $NeType,
        },
    );
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    $Self->{LayoutObject}->Block( Name => "ChangeHeader$NeType" );

    for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
        next if !$Type;
        my $Mark = $Type eq 'rw' ? "Highlight" : '';
        $Self->{LayoutObject}->Block(
            Name => 'ChangeHeader',
            Data => {
                %Param,
                Mark => $Mark,
                Type => $Type,
            },
        );
    }

    for my $ID ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        # set output class
        $Self->{LayoutObject}->Block(
            Name => 'ChangeRow',
            Data => {
                %Param,
                Name   => $Param{Data}->{$ID},
                ID     => $ID,
                NeType => $NeType,
            },
        );
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
            next if !$Type;
            my $Mark     = $Type eq 'rw'        ? "Highlight"          : '';
            my $Selected = $Param{$Type}->{$ID} ? ' checked="checked"' : '';

            $Self->{LayoutObject}->Block(
                Name => 'ChangeRowItem',
                Data => {
                    %Param,
                    Name     => $Param{Data}->{$ID},
                    Mark     => $Mark,
                    Type     => $Type,
                    ID       => $ID,
                    Selected => $Selected,
                },
            );
        }
    }

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminRoleGroup',
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
    my %RoleData = $Self->{GroupObject}->RoleList( Valid => 1 );

    if (%RoleData) {
        for my $RoleID ( sort { uc( $RoleData{$a} ) cmp uc( $RoleData{$b} ) } keys %RoleData ) {

            # set output class
            $Self->{LayoutObject}->Block(
                Name => 'List1n',
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

    # get group data
    my %GroupData = $Self->{GroupObject}->GroupList( Valid => 1 );
    for my $GroupID ( sort { uc( $GroupData{$a} ) cmp uc( $GroupData{$b} ) } keys %GroupData ) {

        # set output class
        $Self->{LayoutObject}->Block(
            Name => 'Listn1',
            Data => {
                Name      => $GroupData{$GroupID},
                Subaction => 'Group',
                ID        => $GroupID,
            },
        );
    }

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminRoleGroup',
        Data         => \%Param,
    );
}

1;
