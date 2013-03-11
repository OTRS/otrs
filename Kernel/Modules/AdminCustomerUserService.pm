# --
# Kernel/Modules/AdminCustomerUserService.pm - to add/update/delete customerusers <-> services
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminCustomerUserService;

use strict;
use warnings;

use Kernel::System::CustomerUser;
use Kernel::System::Service;
use Kernel::System::Valid;

use vars qw($VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Needed (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{ServiceObject}      = Kernel::System::Service->new(%Param);
    $Self->{ValidObject}        = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %VisibleType = ( CustomerUserLogin => 'Customer', Service => 'Service', );

    # set search limit
    my $SearchLimit = 200;

    # ------------------------------------------------------------ #
    # allocate customer user
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'AllocateCustomerUser' ) {

        # get params
        $Param{CustomerUserLogin} = $Self->{ParamObject}->GetParam( Param => 'CustomerUserLogin' )
            || '<DEFAULT>';
        $Param{CustomerUserSearch} = $Self->{ParamObject}->GetParam( Param => 'CustomerUserSearch' )
            || '*';

        # output header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # get service member
        my %ServiceMemberList = $Self->{ServiceObject}->CustomerUserServiceMemberList(
            CustomerUserLogin => $Param{CustomerUserLogin},
            Result            => 'HASH',
            DefaultServices   => 0,
        );

        # List services.
        my %ServiceData = $Self->{ServiceObject}->ServiceList(
            UserID => $Self->{UserID},
        );

        if ( $Param{CustomerUserLogin} eq '<DEFAULT>' ) {
            $Param{Name} = q{};
        }
        else {
            $Param{Name}
                = $Self->{CustomerUserObject}
                ->CustomerName( UserLogin => $Param{CustomerUserLogin} )
                . " ($Param{CustomerUserLogin})";
        }

        $Output .= $Self->_Change(
            ID                 => $Param{CustomerUserLogin},
            Name               => $Param{Name},
            Data               => \%ServiceData,
            Selected           => \%ServiceMemberList,
            CustomerUserSearch => $Param{CustomerUserSearch},
            ServiceSearch      => $Param{ServiceSearch},
            SearchLimit        => $SearchLimit,
            Type               => 'CustomerUser',
        );

        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # allocate service
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AllocateService' ) {

        # get params
        $Param{ServiceID} = $Self->{ParamObject}->GetParam( Param => "ServiceID" );

        $Param{Subaction} = $Self->{ParamObject}->GetParam( Param => 'Subaction' );

        $Param{CustomerUserSearch} = $Self->{ParamObject}->GetParam( Param => "CustomerUserSearch" )
            || '*';

        # output header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # get service
        my %Service = $Self->{ServiceObject}->ServiceGet(
            ServiceID => $Param{ServiceID},
            UserID    => $Self->{UserID},
        );

        # get customer user member
        my %CustomerUserMemberList = $Self->{ServiceObject}->CustomerUserServiceMemberList(
            ServiceID       => $Param{ServiceID},
            Result          => 'HASH',
            DefaultServices => 0,
        );

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

        $Output .= $Self->_Change(
            ID                 => $Param{ServiceID},
            Name               => $Service{Name},
            ItemList           => \@CustomerUserKeyList,
            Data               => \%CustomerData,
            Selected           => \%CustomerUserMemberList,
            CustomerUserSearch => $Param{CustomerUserSearch},
            SearchLimit        => $SearchLimit,
            Type               => 'Service',
            %Param,
        );

        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # allocate customer user save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AllocateCustomerUserSave' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get params
        $Param{CustomerUserLogin} = $Self->{ParamObject}->GetParam( Param => 'ID' );

        $Param{CustomerUserSearch} = $Self->{ParamObject}->GetParam( Param => 'CustomerUserSearch' )
            || '*';

        my @ServiceIDsSelected = $Self->{ParamObject}->GetArray( Param => 'ItemsSelected' );
        my @ServiceIDsAll      = $Self->{ParamObject}->GetArray( Param => 'ItemsAll' );

        # create hash with selected ids
        my %ServiceIDSelected = map { $_ => 1 } @ServiceIDsSelected;

        # check all used service ids
        for my $ServiceID (@ServiceIDsAll) {
            my $Active = $ServiceIDSelected{$ServiceID} ? 1 : 0;

            # set customer user service member
            $Self->{ServiceObject}->CustomerUserServiceMemberAdd(
                CustomerUserLogin => $Param{CustomerUserLogin},
                ServiceID         => $ServiceID,
                Active            => $Active,
                UserID            => $Self->{UserID},
            );
        }

        # redirect to overview
        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=$Self->{Action};CustomerUserSearch=$Param{CustomerUserSearch}"
        );
    }

    # ------------------------------------------------------------ #
    # allocate service save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AllocateServiceSave' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get params
        $Param{ServiceID} = $Self->{ParamObject}->GetParam( Param => "ID" );

        $Param{CustomerUserSearch} = $Self->{ParamObject}->GetParam( Param => 'CustomerUserSearch' )
            || '*';

        my @CustomerUserLoginsSelected
            = $Self->{ParamObject}->GetArray( Param => 'ItemsSelected' );
        my @CustomerUserLoginsAll
            = $Self->{ParamObject}->GetArray( Param => 'ItemsAll' );

        # create hash with selected customer users
        my %CustomerUserLoginsSelected;
        for my $CustomerUserLogin (@CustomerUserLoginsSelected) {
            $CustomerUserLoginsSelected{$CustomerUserLogin} = 1;
        }

        # check all used customer users
        for my $CustomerUserLogin (@CustomerUserLoginsAll) {
            my $Active = $CustomerUserLoginsSelected{$CustomerUserLogin} ? 1 : 0;

            # set customer user service member
            $Self->{ServiceObject}->CustomerUserServiceMemberAdd(
                CustomerUserLogin => $CustomerUserLogin,
                ServiceID         => $Param{ServiceID},
                Active            => $Active,
                UserID            => $Self->{UserID},
            );
        }

        # redirect to overview
        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=$Self->{Action};CustomerUserSearch=$Param{CustomerUserSearch}"
        );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {

        # get params
        $Param{CustomerUserSearch} = $Self->{ParamObject}->GetParam( Param => 'CustomerUserSearch' )
            || '*';

        # output header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # search customer user
        my %CustomerUserList
            = $Self->{CustomerUserObject}->CustomerSearch( Search => $Param{CustomerUserSearch}, );
        my @CustomerUserKeyList
            = sort { $CustomerUserList{$a} cmp $CustomerUserList{$b} } keys %CustomerUserList;

        # count results
        my $CustomerUserCount = @CustomerUserKeyList;

        # set max count
        my $MaxCustomerCount = $CustomerUserCount;

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

        my %ServiceData = $Self->{ServiceObject}->ServiceList(
            UserID => $Self->{UserID},
        );

        $Output .= $Self->_Overview(
            CustomerUserCount   => $CustomerUserCount,
            CustomerUserKeyList => \@CustomerUserKeyList,
            CustomerUserData    => \%UserRowParam,
            ServiceData         => \%ServiceData,
            SearchLimit         => $SearchLimit,
            CustomerUserSearch  => $Param{CustomerUserSearch},
        );

        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my $SearchLimit = $Param{SearchLimit};
    my %Data        = %{ $Param{Data} };
    my $Type        = $Param{Type} || 'CustomerUser';
    my $NeType      = $Type eq 'Service' ? 'CustomerUser' : 'Service';
    my %VisibleType = ( CustomerUser => 'Customer', Service => 'Service', );
    my %Subaction   = ( CustomerUser => 'Change', Service => 'ServiceEdit', );
    my %IDStrg      = ( CustomerUser => 'ID', Service => 'ServiceID', );

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
            Name => 'SearchAllocateService',
            Data => {
                %Param,
                Subaction => $Param{Subaction},
                ServiceID => $Param{ServiceID},
            },
        );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'Filter' );
    }

    $Self->{LayoutObject}->Block(
        Name => 'AllocateItem',
        Data => {
            ID              => $Param{ID},
            ActionHome      => 'Admin' . $Type,
            Type            => $Type,
            NeType          => $NeType,
            VisibleType     => $VisibleType{$Type},
            VisibleNeType   => $VisibleType{$NeType},
            SubactionHeader => $Subaction{$Type},
            IDHeaderStrg    => $IDStrg{$Type},
            %Param,
        },
    );

    $Self->{LayoutObject}->Block( Name => "AllocateItemHeader$VisibleType{$NeType}" );

    if ( $NeType eq 'CustomerUser' ) {

        # output count block
        if ( !@ItemList ) {
            $Self->{LayoutObject}->Block(
                Name => 'AllocateItemCountLimit',
                Data => { ItemCount => 0, },
            );

            my $ColSpan = "2";

            $Self->{LayoutObject}->Block(
                Name => 'NoDataFoundMsg',
                Data => {
                    ColSpan => $ColSpan,
                },
            );
        }
        elsif ( @ItemList > $SearchLimit ) {
            $Self->{LayoutObject}->Block(
                Name => 'AllocateItemCountLimit',
                Data => { ItemCount => ">" . $SearchLimit, },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'AllocateItemCount',
                Data => { ItemCount => scalar @ItemList, },
            );
        }
    }

    # Service sorting.
    my %ServiceData;
    if ( $NeType eq 'Service' ) {
        %ServiceData = %Data;

        # add suffix for correct sorting
        for my $DataKey ( sort keys %Data ) {
            $Data{$DataKey} .= '::';
        }

    }

    # output rows
    for my $ID ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        # set checked
        my $Checked = $Param{Selected}->{$ID} ? "checked='checked'" : '';

        # Recover original Service Name
        if ( $NeType eq 'Service' ) {
            $Data{$ID} = $ServiceData{$ID};
        }

        # output row block
        $Self->{LayoutObject}->Block(
            Name => 'AllocateItemRow',
            Data => {
                ActionNeHome => 'Admin' . $NeType,
                Name         => $Data{$ID},
                ID           => $ID,
                Checked      => $Checked,
                SubactionRow => $Subaction{$NeType},
                IDRowStrg    => $IDStrg{$NeType},

            },
        );
    }

    # generate output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminCustomerUserService',
        Data         => \%Param,
    );
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $CustomerUserCount   = $Param{CustomerUserCount};
    my @CustomerUserKeyList = @{ $Param{CustomerUserKeyList} };
    my $SearchLimit         = $Param{SearchLimit};
    my %CustomerUserData    = %{ $Param{CustomerUserData} };
    my %ServiceData         = %{ $Param{ServiceData} };

    $Self->{LayoutObject}->Block( Name => 'Overview' );
    $Self->{LayoutObject}->Block( Name => 'ActionList' );

    # output search block
    $Self->{LayoutObject}->Block(
        Name => 'Search',
        Data => {
            %Param,
            CustomerUserSearch => $Param{CustomerUserSearch},
        },
    );
    $Self->{LayoutObject}->Block( Name => 'Default', );

    # output filter and default block
    $Self->{LayoutObject}->Block( Name => 'Filter', );

    # output result block
    $Self->{LayoutObject}->Block(
        Name => 'Result',
        Data => {
            %Param,
            CustomerUserCount => $CustomerUserCount,
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
            Name => 'ResultUserRow',
            Data => {
                %Param,
                ID   => $ID,
                Name => $CustomerUserData{$ID},
            },
        );
    }

    my %ServiceDataSort = %ServiceData;

    # add suffix for correct sorting
    for my $ServiceDataKey ( sort keys %ServiceDataSort ) {
        $ServiceDataSort{$ServiceDataKey} .= '::';
    }

    for my $ID (
        sort { uc( $ServiceDataSort{$a} ) cmp uc( $ServiceDataSort{$b} ) }
        keys %ServiceDataSort
        )
    {

        # output service row block
        $Self->{LayoutObject}->Block(
            Name => 'ResultServiceRow',
            Data => {
                %Param,
                ID   => $ID,
                Name => $ServiceData{$ID},
            },
        );
    }

    # generate output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminCustomerUserService',
        Data         => \%Param,
    );
}
1;
