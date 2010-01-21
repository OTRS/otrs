# --
# Kernel/Modules/AdminCustomerUserGroup.pm - to add/update/delete groups <-> users
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AdminCustomerUserGroup.pm,v 1.29 2010-01-21 00:05:33 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminCustomerUserGroup;

use strict;
use warnings;

use Kernel::System::CustomerUser;
use Kernel::System::CustomerGroup;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.29 $) [1];

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

    # needed objects
    $Self->{CustomerUserObject}  = Kernel::System::CustomerUser->new(%Param);
    $Self->{CustomerGroupObject} = Kernel::System::CustomerGroup->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # check if feature is active
    # ------------------------------------------------------------ #
    if ( !$Self->{ConfigObject}->Get('CustomerGroupSupport') ) {
        my $Output .= $Self->{LayoutObject}->Header();
        $Output    .= $Self->{LayoutObject}->NavigationBar();
        $Output    .= $Self->{LayoutObject}->Warning(
            Message => 'Sorry, feature not active!',
            Comment =>
                'CustomerGroupSupport needs to be active in Kernel/Config.pm, read more about this feature in the documentation. Take care!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # user <-> group 1:n
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'User' ) {

        # get user data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet( User => $ID );

        # get group data
        my %GroupData = $Self->{GroupObject}->GroupList( Valid => 1 );
        my %Types;
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Customer::Permission') } ) {
            my %Data = $Self->{CustomerGroupObject}->GroupMemberList(
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
            Name => $UserData{UserLogin},
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
        my %UserData = $Self->{CustomerUserObject}->CustomerUserList( Valid => 1 );

        # get user name
        for my $UserID ( keys %UserData ) {
            my %User = $Self->{CustomerUserObject}->CustomerUserDataGet( User => $UserID );
            next if !%User;
            $UserData{$UserID} .= " ($User{UserFirstname} $User{UserLastname})";
        }

        # get permission list users
        my %Types;
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Customer::Permission') } ) {
            my %Data = $Self->{CustomerGroupObject}->GroupMemberList(
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

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';

        # get new groups
        my %Permissions;
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Customer::Permission') } ) {
            my @IDs = $Self->{ParamObject}->GetArray( Param => $Type );
            $Permissions{$Type} = \@IDs;
        }

        # get group data
        my %UserData = $Self->{CustomerUserObject}->CustomerUserList( Valid => 1 );
        my %NewPermission;
        for my $UserID ( keys %UserData ) {
            for my $Permission ( keys %Permissions ) {
                $NewPermission{$Permission} = 0;
                my @Array = @{ $Permissions{$Permission} };
                for my $ID (@Array) {
                    if ( $UserID eq $ID ) {
                        $NewPermission{$Permission} = 1;
                    }
                }
            }
            $Self->{CustomerGroupObject}->GroupMemberAdd(
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

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # get new groups
        my %Permissions;
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Customer::Permission') } ) {
            my @IDs = $Self->{ParamObject}->GetArray( Param => $Type );
            $Permissions{$Type} = \@IDs;
        }

        # get group data
        my %GroupData = $Self->{GroupObject}->GroupList( Valid => 1 );
        my %NewPermission;
        for my $GroupID ( keys %GroupData ) {
            for my $Permission ( keys %Permissions ) {
                $NewPermission{$Permission} = 0;
                my @Array = @{ $Permissions{$Permission} };
                for my $ID (@Array) {
                    if ( $GroupID eq $ID ) {
                        $NewPermission{$Permission} = 1;
                    }
                }
            }
            $Self->{CustomerGroupObject}->GroupMemberAdd(
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

    $Self->{LayoutObject}->Block(
        Name => 'Change',
        Data => {
            %Param,
            ActionHome => 'Admin' . $Type,
            NeType     => $NeType,
        },
    );
    for my $Type ( @{ $Self->{ConfigObject}->Get('System::Customer::Permission') } ) {
        next if !$Type;
        my $Mark = $Type eq 'rw' ? " | " : '';
        $Self->{LayoutObject}->Block(
            Name => 'ChangeHeader',
            Data => {
                %Param,
                Mark => $Mark,
                Type => $Type,
            },
        );
    }

    my $CssClass = 'searchpassive';
    for my $ID ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        # set output class
        $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';
        $Self->{LayoutObject}->Block(
            Name => 'ChangeRow',
            Data => {
                %Param,
                CssClass => $CssClass,
                Name     => $Param{Data}->{$ID},
                ID       => $ID,
                NeType   => $NeType,
            },
        );
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Customer::Permission') } ) {
            next if !$Type;
            my $Mark = $Type eq 'rw' ? " | " : '';
            my $Selected = $Param{$Type}->{$ID} ? ' checked="checked"' : '';

            $Self->{LayoutObject}->Block(
                Name => 'ChangeRowItem',
                Data => {
                    %Param,
                    Mark     => $Mark,
                    Type     => $Type,
                    ID       => $ID,
                    Selected => $Selected,
                },
            );
        }
    }

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminCustomerUserGroupForm',
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
    my %UserData = $Self->{CustomerUserObject}->CustomerUserList( Valid => 1 );

    # get user name
    for my $UserID ( keys %UserData ) {
        my %User = $Self->{CustomerUserObject}->CustomerUserDataGet( User => $UserID );
        next if !%User;
        $UserData{$UserID} .= " ($User{UserFirstname} $User{UserLastname})";
    }
    my $CssClass = 'searchpassive';
    for my $UserID ( sort { uc( $UserData{$a} ) cmp uc( $UserData{$b} ) } keys %UserData ) {

        # set output class
        $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';
        $Self->{LayoutObject}->Block(
            Name => 'List1n',
            Data => {
                Name      => $UserData{$UserID},
                Subaction => 'User',
                ID        => $UserID,
                CssClass  => $CssClass,
            },
        );
    }

    # get group data
    $CssClass = 'searchpassive';
    my %GroupData = $Self->{GroupObject}->GroupList( Valid => 1 );
    for my $GroupID ( sort { uc( $GroupData{$a} ) cmp uc( $GroupData{$b} ) } keys %GroupData ) {

        # set output class
        $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive';
        $Self->{LayoutObject}->Block(
            Name => 'Listn1',
            Data => {
                Name      => $GroupData{$GroupID},
                Subaction => 'Group',
                ID        => $GroupID,
                CssClass  => $CssClass,
            },
        );
    }

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminCustomerUserGroupForm',
        Data         => \%Param,
    );
}

1;
