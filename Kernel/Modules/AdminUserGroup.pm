# --
# Kernel/Modules/AdminUserGroup.pm - to add/update/delete groups <-> users
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminUserGroup;

use strict;
use warnings;

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
        my %GroupData = $Self->{GroupObject}->GroupList( Valid => 1 );
        my %Types;
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
            my %Data = $Self->{GroupObject}->GroupGroupMemberList(
                UserID => $ID,
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
            ID   => $UserData{UserID},
            Name => "$UserData{UserFirstname} $UserData{UserLastname} ($UserData{UserLogin})",
            Type => 'User',
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
        my %UserData = $Self->{UserObject}->UserList( Valid => 1 );

        # get user name
        for my $UserID ( sort keys %UserData ) {
            my $Name = $Self->{UserObject}->UserName( UserID => $UserID );
            next if !$Name;
            $UserData{$UserID} .= " ($Name)";
        }

        # get permission list users
        my %Types;
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
            my %Data = $Self->{GroupObject}->GroupGroupMemberList(
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
            Data => \%UserData,
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
        my %UserData = $Self->{UserObject}->UserList( Valid => 1 );
        my %NewPermission;
        for my $UserID ( sort keys %UserData ) {
            for my $Permission ( sort keys %Permissions ) {
                $NewPermission{$Permission} = 0;
                my @Array = @{ $Permissions{$Permission} };
                for my $ID (@Array) {
                    if ( $UserID == $ID ) {
                        $NewPermission{$Permission} = 1;
                    }
                }
            }
            $Self->{GroupObject}->GroupMemberAdd(
                UID        => $UserID,
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
    elsif ( $Self->{Subaction} eq 'ChangeUser' ) {

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
                    if ( $GroupID eq $ID ) {
                        $NewPermission{$Permission} = 1;
                    }
                }
            }
            $Self->{GroupObject}->GroupMemberAdd(
                UID        => $ID,
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
    my $Type   = $Param{Type} || 'User';
    my $NeType = $Type eq 'Group' ? 'User' : 'Group';

    my %VisibleType = ( Group => 'Group', User => 'Agent', );

    $Self->{LayoutObject}->Block( Name => 'Overview' );
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );
    $Self->{LayoutObject}->Block( Name => 'ChangeReference', );
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
            my $Mark = $Type eq 'rw' ? "Highlight" : '';
            my $Selected = $Param{$Type}->{$ID} ? ' checked="checked"' : '';

            $Self->{LayoutObject}->Block(
                Name => 'ChangeRowItem',
                Data => {
                    %Param,
                    Mark     => $Mark,
                    Type     => $Type,
                    ID       => $ID,
                    Selected => $Selected,
                    Name     => $Param{Data}->{$ID},
                },
            );
        }
    }

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminUserGroup',
        Data         => \%Param,
    );
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block( Name => 'Overview' );

    # no "actions list" block because no actions now
    #    $Self->{LayoutObject}->Block( Name => 'ActionList' );

    $Self->{LayoutObject}->Block( Name => 'UserFilter' );
    $Self->{LayoutObject}->Block( Name => 'GroupFilter' );
    $Self->{LayoutObject}->Block( Name => 'OverviewResult' );

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
        TemplateFile => 'AdminUserGroup',
        Data         => \%Param,
    );
}

1;
