# --
# Kernel/Modules/AdminCustomerUserGroup.pm - to add/update/delete groups <-> users
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminCustomerUserGroup;

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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # ------------------------------------------------------------ #
    # check if feature is active
    # ------------------------------------------------------------ #
    if ( !$ConfigObject->Get('CustomerGroupSupport') ) {
        my $Output .= $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        $Output .= $Self->_Disabled();

        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    my $ParamObject         = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $CustomerUserObject  = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $CustomerGroupObject = $Kernel::OM->Get('Kernel::System::CustomerGroup');
    my $GroupObject         = $Kernel::OM->Get('Kernel::System::Group');

    # set search limit
    my $SearchLimit = 200;

    # ------------------------------------------------------------ #
    # user <-> group 1:n
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'CustomerUser' ) {

        # get user data
        my $ID = $ParamObject->GetParam( Param => 'ID' );
        my %UserData = $CustomerUserObject->CustomerUserDataGet( User => $ID );
        my $CustomerName = $CustomerUserObject->CustomerName( UserLogin => $UserData{UserLogin} );

        # get group data
        my %GroupData = $GroupObject->GroupList( Valid => 1 );
        my %Types;
        for my $Type ( @{ $ConfigObject->Get('System::Customer::Permission') } ) {
            my %Data = $CustomerGroupObject->GroupMemberList(
                UserID => $ID,
                Type   => $Type,
                Result => 'HASH',
            );
            $Types{$Type} = \%Data;
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Self->_Change(
            %Types,
            Data => \%GroupData,
            ID   => $UserData{UserID},
            Name => "$CustomerName ($UserData{UserLogin})",
            Type => 'CustomerUser',
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # group <-> user n:1
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Group' ) {

        # Get params.
        $Param{Subaction} = $ParamObject->GetParam( Param => 'Subaction' );

        $Param{CustomerUserSearch} = $ParamObject->GetParam( Param => "CustomerUserSearch" )
            || '*';

        # get group data
        my $ID = $ParamObject->GetParam( Param => 'ID' );
        my %GroupData = $GroupObject->GroupGet( ID => $ID );

        # search customer user
        my %CustomerUserList = $CustomerUserObject->CustomerSearch(
            Search => $Param{CustomerUserSearch},
        );
        my @CustomerUserKeyList = sort { $CustomerUserList{$a} cmp $CustomerUserList{$b} } keys %CustomerUserList;

        # set max count
        my $MaxCount = @CustomerUserKeyList;
        if ( $MaxCount > $SearchLimit ) {
            $MaxCount = $SearchLimit;
        }

        my %CustomerData;

        # output rows
        for my $Counter ( 1 .. $MaxCount ) {

            # get service
            my %User = $CustomerUserObject->CustomerUserDataGet(
                User => $CustomerUserKeyList[ $Counter - 1 ],
            );
            my $UserName = $CustomerUserObject->CustomerName(
                UserLogin => $CustomerUserKeyList[ $Counter - 1 ]
            );
            my $CustomerUser = "$UserName <$User{UserEmail}> ($User{UserCustomerID})";
            $CustomerData{ $User{UserID} } = $CustomerUser;
        }

        # get permission list users
        my %Types;
        for my $Type ( @{ $ConfigObject->Get('System::Customer::Permission') } ) {
            my %Data = $CustomerGroupObject->GroupMemberList(
                GroupID => $ID,
                Type    => $Type,
                Result  => 'HASH',
            );
            $Types{$Type} = \%Data;
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
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
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add user to groups
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeGroup' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $ID = $ParamObject->GetParam( Param => 'ID' ) || '';

        $Param{CustomerUserSearch} = $ParamObject->GetParam( Param => 'CustomerUserSearch' )
            || '*';

        # get new groups
        my %Permissions;
        for my $Type ( @{ $ConfigObject->Get('System::Customer::Permission') } ) {
            my @IDs = $ParamObject->GetArray( Param => $Type );
            $Permissions{$Type} = \@IDs;
        }

        # get group data
        my %UserData = $CustomerUserObject->CustomerSearch(
            Search => $Param{CustomerUserSearch},
        );

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
            $CustomerGroupObject->GroupMemberAdd(
                UID        => $UserID,
                GID        => $ID,
                Permission => \%NewPermission,
                UserID     => $Self->{UserID},
            );
        }

        # redirect to overview
        return $LayoutObject->Redirect(
            OP =>
                "Action=$Self->{Action};CustomerUserSearch=$Param{CustomerUserSearch}"
        );
    }

    # ------------------------------------------------------------ #
    # groups to user
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeCustomerUser' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $ID = $ParamObject->GetParam( Param => 'ID' );

        $Param{CustomerUserSearch} = $ParamObject->GetParam( Param => 'CustomerUserSearch' )
            || '*';

        # get new groups
        my %Permissions;
        for my $Type ( @{ $ConfigObject->Get('System::Customer::Permission') } ) {
            my @IDs = $ParamObject->GetArray( Param => $Type );
            $Permissions{$Type} = \@IDs;
        }

        # get group data
        my %GroupData = $GroupObject->GroupList( Valid => 1 );
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
            $CustomerGroupObject->GroupMemberAdd(
                UID        => $ID,
                GID        => $GroupID,
                Permission => \%NewPermission,
                UserID     => $Self->{UserID},
            );
        }

        # return to overview
        return $LayoutObject->Redirect(
            OP =>
                "Action=$Self->{Action};CustomerUserSearch=$Param{CustomerUserSearch}"
        );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #

    # get params
    $Param{CustomerUserSearch} = $ParamObject->GetParam( Param => 'CustomerUserSearch' )
        || '*';

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # search customer user
    my %CustomerUserList = $CustomerUserObject->CustomerSearch(
        Search => $Param{CustomerUserSearch},
    );
    my @CustomerUserKeyList = sort { $CustomerUserList{$a} cmp $CustomerUserList{$b} } keys %CustomerUserList;

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
            my %User = $CustomerUserObject->CustomerUserDataGet(
                User => $CustomerUserKeyList[ $Counter - 1 ]
            );
            my $UserName = $CustomerUserObject->CustomerName(
                UserLogin => $CustomerUserKeyList[ $Counter - 1 ]
            );
            $UserRowParam{ $User{UserID} } = "$UserName <$User{UserEmail}> ($User{UserCustomerID})";
        }
    }

    # get group data
    my %GroupData = $GroupObject->GroupList( Valid => 1 );

    $Output .= $Self->_Overview(
        CustomerUserCount   => $CustomerUserCount,
        CustomerUserKeyList => \@CustomerUserKeyList,
        CustomerUserData    => \%UserRowParam,
        GroupData           => \%GroupData,
        SearchLimit         => $SearchLimit,
        CustomerUserSearch  => $Param{CustomerUserSearch},
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my %Data        = %{ $Param{Data} };
    my $Type        = $Param{Type} || 'CustomerUser';
    my $NeType      = $Type eq 'Group' ? 'CustomerUser' : 'Group';
    my %VisibleType = (
        CustomerUser => 'Customer',
        Group        => 'Group',
    );
    my $SearchLimit = $Param{SearchLimit};

    my @ItemList = ();

    # overview
    $LayoutObject->Block( Name => 'Overview' );
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block(
        Name => 'ActionOverview',
        Data => {
            CustomerUserSearch => $Param{CustomerUserSearch},
            }
    );

    if ( $NeType eq 'CustomerUser' ) {
        @ItemList = @{ $Param{ItemList} };

        # output search block
        $LayoutObject->Block(
            Name => 'Search',
            Data => {
                %Param,
                CustomerUserSearch => $Param{CustomerUserSearch},
            },
        );
        $LayoutObject->Block(
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
        $LayoutObject->Block( Name => 'AlwaysGroupsConfig' );

        $LayoutObject->Block( Name => 'Filter' );
    }

    $LayoutObject->Block( Name => 'Note' );

    $LayoutObject->Block(
        Name => 'Change',
        Data => {
            %Param,
            ActionHome    => 'Admin' . $Type,
            VisibleNeType => $VisibleType{$NeType},
            VisibleType   => $VisibleType{$Type},
        },
    );

    $LayoutObject->Block(
        Name => "ChangeHeading$VisibleType{$NeType}",
    );

    TYPE:
    for my $Type ( @{ $ConfigObject->Get('System::Customer::Permission') } ) {
        next TYPE if !$Type;
        my $Mark = $Type eq 'rw' ? "Highlight" : '';
        $LayoutObject->Block(
            Name => 'ChangeHeader',
            Data => {
                %Param,
                Mark => $Mark,
                Type => $Type,
            },
        );
    }

    # check if there are groups/customers
    if ( !%Data ) {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsgList',
            Data => {
                ColSpan => 3,
            },
        );
    }

    if ( $NeType eq 'CustomerUser' ) {

        # output count block
        if ( !@ItemList ) {
            $LayoutObject->Block(
                Name => 'ChangeItemCountLimit',
                Data => {
                    ItemCount => 0,
                },
            );

        }
        elsif ( @ItemList > $SearchLimit ) {
            $LayoutObject->Block(
                Name => 'ChangeItemCountLimit',
                Data => {
                    ItemCount => ">" . $SearchLimit,
                },
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'ChangeItemCount',
                Data => {
                    ItemCount => scalar @ItemList,
                },
            );
        }
    }

    my @CustomerAlwaysGroups = @{ $ConfigObject->Get('CustomerGroupAlwaysGroups') };

    DATAITEM:
    for my $ID ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        next DATAITEM if ( grep /\Q$Param{Data}->{$ID}\E/, @CustomerAlwaysGroups );

        # set output class
        $LayoutObject->Block(
            Name => 'ChangeRow',
            Data => {
                %Param,
                Name   => $Param{Data}->{$ID},
                ID     => $ID,
                NeType => $NeType,
            },
        );

        TYPE:
        for my $Type ( @{ $ConfigObject->Get('System::Customer::Permission') } ) {
            next TYPE if !$Type;
            my $Mark     = $Type eq 'rw'        ? "Highlight"          : '';
            my $Selected = $Param{$Type}->{$ID} ? ' checked="checked"' : '';
            $LayoutObject->Block(
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
        $LayoutObject->Block( Name => 'AlwaysGroups' );

        for my $ID ( 1 .. @CustomerAlwaysGroups ) {
            $LayoutObject->Block(
                Name => 'AlwaysGroupsList',
                Data => {
                    Name => $CustomerAlwaysGroups[ $ID - 1 ],
                },
                )
        }
    }

    $LayoutObject->Block( Name => 'Reference' );

    return $LayoutObject->Output(
        TemplateFile => 'AdminCustomerUserGroup',
        Data         => \%Param,
    );
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $CustomerUserCount   = $Param{CustomerUserCount};
    my @CustomerUserKeyList = @{ $Param{CustomerUserKeyList} };
    my %CustomerUserData    = %{ $Param{CustomerUserData} };
    my %GroupData           = %{ $Param{GroupData} };
    my $SearchLimit         = $Param{SearchLimit};

    $LayoutObject->Block(
        Name => 'Overview',
        Data => {},
    );

    $LayoutObject->Block( Name => 'ActionList' );

    # output search block
    $LayoutObject->Block(
        Name => 'Search',
        Data => \%Param,
    );

    # Output config shutcut to CustomerAlwaysGroups
    $LayoutObject->Block( Name => 'AlwaysGroupsConfig' );

    # output filter and default block
    $LayoutObject->Block(
        Name => 'Filter',
    );

    # output result block
    $LayoutObject->Block(
        Name => 'Result',
        Data => {
            %Param,
        },
    );

    # output customer user count block
    if ( !@CustomerUserKeyList ) {
        $LayoutObject->Block(
            Name => 'ResultCustomerUserCountLimit',
            Data => {
                CustomerUserCount => 0,
            },
        );
        $LayoutObject->Block(
            Name => 'NoDataFoundMsgCustomer',
        );
    }
    elsif ( @CustomerUserKeyList > $SearchLimit ) {
        $LayoutObject->Block(
            Name => 'ResultCustomerUserCountLimit',
            Data => {
                CustomerUserCount => ">" . $SearchLimit,
            },
        );
    }
    else {
        $LayoutObject->Block(
            Name => 'ResultCustomerUserCount',
            Data => {
                CustomerUserCount => scalar @CustomerUserKeyList,
            },
        );
    }

    for my $ID (
        sort { uc( $CustomerUserData{$a} ) cmp uc( $CustomerUserData{$b} ) }
        keys %CustomerUserData
        )
    {

        # output user row block
        $LayoutObject->Block(
            Name => 'List1n',
            Data => {
                %Param,
                ID        => $ID,
                Name      => $CustomerUserData{$ID},
                Subaction => 'CustomerUser',
            },
        );
    }

    my @CustomerAlwaysGroups = @{ $ConfigObject->Get('CustomerGroupAlwaysGroups') };

    if (%GroupData) {
        GROUP:
        for my $ID (
            sort { uc( $GroupData{$a} ) cmp uc( $GroupData{$b} ) }
            keys %GroupData
            )
        {
            next GROUP if ( grep /\Q$GroupData{$ID}\E/, @CustomerAlwaysGroups );

            # output gorup block
            $LayoutObject->Block(
                Name => 'Listn1',
                Data => {
                    %Param,
                    ID        => $ID,
                    Name      => $GroupData{$ID},
                    Subaction => 'Group',
                },
            );
        }
    }
    else {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsgGroup',
            Data => {},
        );
    }

    $LayoutObject->Block( Name => 'AlwaysGroups' );

    for my $ID ( 1 .. @CustomerAlwaysGroups ) {
        $LayoutObject->Block(
            Name => 'AlwaysGroupsList',
            Data => {
                Name => $CustomerAlwaysGroups[ $ID - 1 ],
            },
            )
    }

    # return output
    return $LayoutObject->Output(
        TemplateFile => 'AdminCustomerUserGroup',
        Data         => \%Param,
    );

}

sub _Disabled {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => {},
    );

    $LayoutObject->Block( Name => 'Disabled' );

    # return output
    return $LayoutObject->Output(
        TemplateFile => 'AdminCustomerUserGroup',
        Data         => \%Param,
    );
}
1;
