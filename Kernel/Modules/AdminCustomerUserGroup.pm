# --
# Kernel/Modules/AdminCustomerUserGroup.pm - to add/update/delete groups <-> users
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

    # set search limit
    my $SearchLimit = 200;

    # ------------------------------------------------------------ #
    # check if feature is active
    # ------------------------------------------------------------ #
    if ( !$Self->{ConfigObject}->Get('CustomerGroupSupport') ) {
        my $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        $Output .= $Self->_Disabled();

        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # user <-> group 1:n
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'CustomerUser' ) {

        # get user data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet( User => $ID );
        my $CustomerName
            = $Self->{CustomerUserObject}->CustomerName( UserLogin => $UserData{UserLogin} );

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
            Name => "$CustomerName ($UserData{UserLogin})",
            Type => 'CustomerUser',
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # group <-> user n:1
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Group' ) {

        # Get params.
        $Param{Subaction} = $Self->{ParamObject}->GetParam( Param => 'Subaction' );

        $Param{CustomerUserSearch} = $Self->{ParamObject}->GetParam( Param => "CustomerUserSearch" )
            || '*';

        # get group data
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );
        my %GroupData = $Self->{GroupObject}->GroupGet( ID => $ID );

        # search customer user
        my %CustomerUserList
            = $Self->{CustomerUserObject}->CustomerSearch( Search => $Param{CustomerUserSearch}, );
        my @CustomerUserKeyList
            = sort { $CustomerUserList{$a} cmp $CustomerUserList{$b} } keys %CustomerUserList;

        # set max count
        my $MaxCount = @CustomerUserKeyList;
        if ( $MaxCount > $SearchLimit ) {
            $MaxCount = $SearchLimit;
        }

        my %CustomerData;

        # output rows
        for my $Counter ( 1 .. $MaxCount ) {

            # get service
            my %User = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $CustomerUserKeyList[ $Counter - 1 ],
            );
            my $UserName = $Self->{CustomerUserObject}->CustomerName(
                UserLogin => $CustomerUserKeyList[ $Counter - 1 ]
            );
            my $CustomerUser = "$UserName <$User{UserEmail}> ($User{UserCustomerID})";
            $CustomerData{ $User{UserID} } = $CustomerUser;
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
            Data               => \%CustomerData,
            ID                 => $GroupData{ID},
            Name               => $GroupData{Name},
            Type               => 'Group',
            SearchLimit        => $SearchLimit,
            ItemList           => \@CustomerUserKeyList,
            CustomerUserSearch => $Param{CustomerUserSearch},
            %Param,
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

        $Param{CustomerUserSearch} = $Self->{ParamObject}->GetParam( Param => 'CustomerUserSearch' )
            || '*';

        # get new groups
        my %Permissions;
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Customer::Permission') } ) {
            my @IDs = $Self->{ParamObject}->GetArray( Param => $Type );
            $Permissions{$Type} = \@IDs;
        }

        # get group data
        my %UserData = $Self->{CustomerUserObject}->CustomerUserList( Valid => 1 );
        my %NewPermission;
        for my $UserID ( sort keys %UserData ) {
            for my $Permission ( sort keys %Permissions ) {
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

        # redirect to overview
        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=$Self->{Action};CustomerUserSearch=$Param{CustomerUserSearch}"
        );
    }

    # ------------------------------------------------------------ #
    # groups to user
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeCustomerUser' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        $Param{CustomerUserSearch} = $Self->{ParamObject}->GetParam( Param => 'CustomerUserSearch' )
            || '*';

        # get new groups
        my %Permissions;
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Customer::Permission') } ) {
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
            $Self->{CustomerGroupObject}->GroupMemberAdd(
                UID        => $ID,
                GID        => $GroupID,
                Permission => \%NewPermission,
                UserID     => $Self->{UserID},
            );
        }

        # return to overview
        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=$Self->{Action};CustomerUserSearch=$Param{CustomerUserSearch}"
        );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #

    # get params
    $Param{CustomerUserSearch} = $Self->{ParamObject}->GetParam( Param => 'CustomerUserSearch' )
        || '*';

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # search customer user
    my %CustomerUserList
        = $Self->{CustomerUserObject}->CustomerSearch( Search => $Param{CustomerUserSearch}, );
    my @CustomerUserKeyList
        = sort { $CustomerUserList{$a} cmp $CustomerUserList{$b} } keys %CustomerUserList;

    # count results
    my $CustomerUserCount = @CustomerUserKeyList;

    #    my $GroupCount      = @GroupList;

    # set max count
    my $MaxCustomerCount = $CustomerUserCount;

    #    my $MaxGroupCount  = $GroupCount;

    if ( $MaxCustomerCount > $SearchLimit ) {
        $MaxCustomerCount = $SearchLimit;
    }

    # output rows
    my %UserRowParam;
    for my $Counter ( 1 .. $MaxCustomerCount ) {

        # set customer user row params
        if ( defined( $CustomerUserKeyList[ $Counter - 1 ] ) ) {

            # Get user details
            my %User = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $CustomerUserKeyList[ $Counter - 1 ]
            );
            my $UserName = $Self->{CustomerUserObject}->CustomerName(
                UserLogin => $CustomerUserKeyList[ $Counter - 1 ]
            );
            $UserRowParam{ $User{UserID} }
                = "$UserName <$User{UserEmail}> ($User{UserCustomerID})";
        }
    }

    # get group data
    my %GroupData = $Self->{GroupObject}->GroupList( Valid => 1 );

    $Output .= $Self->_Overview(
        CustomerUserCount   => $CustomerUserCount,
        CustomerUserKeyList => \@CustomerUserKeyList,
        CustomerUserData    => \%UserRowParam,
        GroupData           => \%GroupData,
        SearchLimit         => $SearchLimit,
        CustomerUserSearch  => $Param{CustomerUserSearch},
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my %Data        = %{ $Param{Data} };
    my $Type        = $Param{Type} || 'CustomerUser';
    my $NeType      = $Type eq 'Group' ? 'CustomerUser' : 'Group';
    my %VisibleType = ( CustomerUser => 'Customer', Group => 'Group', );
    my $SearchLimit = $Param{SearchLimit};

    my @ItemList = ();

    # overview
    $Self->{LayoutObject}->Block( Name => 'Overview' );
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block(
        Name => 'ActionOverview',
        Data => {
            CustomerUserSearch => $Param{CustomerUserSearch},
            }
    );

    if ( $NeType eq 'CustomerUser' ) {
        @ItemList = @{ $Param{ItemList} };

        # output search block
        $Self->{LayoutObject}->Block(
            Name => 'Search',
            Data => {
                %Param,
                CustomerUserSearch => $Param{CustomerUserSearch},
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'SearchChangeGroup',
            Data => {
                %Param,
                Subaction => $Param{Subaction},
                GroupID   => $Param{ID},
            },
        );
    }
    else {

        # Output config shutcut to CustomerAlwaysGroups
        $Self->{LayoutObject}->Block( Name => 'AlwaysGroupsConfig' );

        $Self->{LayoutObject}->Block( Name => 'Filter' );
    }

    $Self->{LayoutObject}->Block( Name => 'Note' );

    $Self->{LayoutObject}->Block(
        Name => 'Change',
        Data => {
            %Param,
            ActionHome    => 'Admin' . $Type,
            VisibleNeType => $VisibleType{$NeType},
            VisibleType   => $VisibleType{$Type},
        },
    );

    $Self->{LayoutObject}->Block(
        Name => "ChangeHeading$VisibleType{$NeType}",
    );

    for my $Type ( @{ $Self->{ConfigObject}->Get('System::Customer::Permission') } ) {
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

    if ( $NeType eq 'CustomerUser' ) {

        # output count block
        if ( !@ItemList ) {
            $Self->{LayoutObject}->Block(
                Name => 'ChangeItemCountLimit',
                Data => { ItemCount => 0, },
            );

            my $ColSpan = "3";

            $Self->{LayoutObject}->Block(
                Name => 'NoDataFoundMsg',
                Data => {
                    ColSpan => $ColSpan,
                },
            );

        }
        elsif ( @ItemList > $SearchLimit ) {
            $Self->{LayoutObject}->Block(
                Name => 'ChangeItemCountLimit',
                Data => { ItemCount => ">" . $SearchLimit, },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'ChangeItemCount',
                Data => { ItemCount => scalar @ItemList, },
            );
        }
    }

    my @CustomerAlwaysGroups = @{ $Self->{ConfigObject}->Get('CustomerGroupAlwaysGroups') };

    DATAITEM:
    for my $ID ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        next DATAITEM if ( grep /\Q$Param{Data}->{$ID}\E/, @CustomerAlwaysGroups );

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

        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Customer::Permission') } ) {
            next if !$Type;
            my $Mark     = $Type eq 'rw'        ? "Highlight"          : '';
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

    if ( $Type eq 'CustomerUser' ) {
        $Self->{LayoutObject}->Block( Name => 'AlwaysGroups' );

        for my $ID ( 1 .. @CustomerAlwaysGroups ) {
            $Self->{LayoutObject}->Block(
                Name => 'AlwaysGroupsList',
                Data => {
                    Name => $CustomerAlwaysGroups[ $ID - 1 ],
                },
                )
        }
    }

    $Self->{LayoutObject}->Block( Name => 'Reference' );

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminCustomerUserGroup',
        Data         => \%Param,
    );
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $CustomerUserCount   = $Param{CustomerUserCount};
    my @CustomerUserKeyList = @{ $Param{CustomerUserKeyList} };
    my %CustomerUserData    = %{ $Param{CustomerUserData} };
    my %GroupData           = %{ $Param{GroupData} };
    my $SearchLimit         = $Param{SearchLimit};

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => {},
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList' );

    # output search block
    $Self->{LayoutObject}->Block(
        Name => 'Search',
        Data => \%Param,
    );

    # Output config shutcut to CustomerAlwaysGroups
    $Self->{LayoutObject}->Block( Name => 'AlwaysGroupsConfig' );

    # output filter and default block
    $Self->{LayoutObject}->Block( Name => 'Filter', );

    # output result block
    $Self->{LayoutObject}->Block(
        Name => 'Result',
        Data => {
            %Param,
        },
    );

    # output customer user count block
    if ( !@CustomerUserKeyList ) {
        $Self->{LayoutObject}->Block(
            Name => 'ResultCustomerUserCountLimit',
            Data => { CustomerUserCount => 0, },
        );
        $Self->{LayoutObject}->Block(
            Name => 'NoDataFoundMsgList',
        );
    }
    elsif ( @CustomerUserKeyList > $SearchLimit ) {
        $Self->{LayoutObject}->Block(
            Name => 'ResultCustomerUserCountLimit',
            Data => { CustomerUserCount => ">" . $SearchLimit, },
        );
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'ResultCustomerUserCount',
            Data => { CustomerUserCount => scalar @CustomerUserKeyList, },
        );
    }

    for my $ID (
        sort { uc( $CustomerUserData{$a} ) cmp uc( $CustomerUserData{$b} ) }
        keys %CustomerUserData
        )
    {

        # output user row block
        $Self->{LayoutObject}->Block(
            Name => 'List1n',
            Data => {
                %Param,
                ID        => $ID,
                Name      => $CustomerUserData{$ID},
                Subaction => 'CustomerUser',
            },
        );
    }

    my @CustomerAlwaysGroups = @{ $Self->{ConfigObject}->Get('CustomerGroupAlwaysGroups') };

    GROUP:
    for my $ID (
        sort { uc( $GroupData{$a} ) cmp uc( $GroupData{$b} ) }
        keys %GroupData
        )
    {
        next GROUP if ( grep /\Q$GroupData{$ID}\E/, @CustomerAlwaysGroups );

        # output gorup block
        $Self->{LayoutObject}->Block(
            Name => 'Listn1',
            Data => {
                %Param,
                ID        => $ID,
                Name      => $GroupData{$ID},
                Subaction => 'Group',
            },
        );
    }

    $Self->{LayoutObject}->Block( Name => 'AlwaysGroups' );

    for my $ID ( 1 .. @CustomerAlwaysGroups ) {
        $Self->{LayoutObject}->Block(
            Name => 'AlwaysGroupsList',
            Data => {
                Name => $CustomerAlwaysGroups[ $ID - 1 ],
            },
            )
    }

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminCustomerUserGroup',
        Data         => \%Param,
    );

}

sub _Disabled {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => {},
    );

    $Self->{LayoutObject}->Block( Name => 'Disabled' );

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminCustomerUserGroup',
        Data         => \%Param,
    );
}
1;
