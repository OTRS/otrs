# --
# Kernel/Modules/AdminCustomerUserService.pm - to add/update/delete customerusers <-> services
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AdminCustomerUserService.pm,v 1.14 2010-04-26 17:39:50 dz Exp $
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
$VERSION = qw($Revision: 1.14 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
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
        $Param{ServiceSearch} = $Self->{ParamObject}->GetParam( Param => 'ServiceSearch' ) || '*';

        # output header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # overview
        $Self->{LayoutObject}->Block( Name => 'Overview' );
        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

        # output search block
        $Self->{LayoutObject}->Block(
            Name => 'Search',
            Data => {
                %Param,
                CustomerUserSearch => $Param{CustomerUserSearch},
                ServiceSearch      => $Param{ServiceSearch},
            },
        );

        # get service member
        my %ServiceMemberList = $Self->{ServiceObject}->CustomerUserServiceMemberList(
            CustomerUserLogin => $Param{CustomerUserLogin},
            Result            => 'HASH',
            DefaultServices   => 0,
        );

        # search services
        my @ServiceList = $Self->{ServiceObject}->ServiceSearch(
            Name   => $Param{ServiceSearch},
            Limit  => $SearchLimit + 1,
            UserID => $Self->{UserID},
        );

        # set max count
        my $MaxCount = @ServiceList;
        if ( $MaxCount > $SearchLimit ) {
            $MaxCount = $SearchLimit;
        }

        # output allocate block
        $Self->{LayoutObject}->Block(
            Name => 'AllocateCustomerUser',
            Data => {
                CustomerUser => $Param{CustomerUserLogin},
                ServiceCount => @ServiceList || 0,
                %Param,

                Type          => 'CustomerUserLogin',
                NeType        => 'Service',
                VisibleType   => $VisibleType{CustomerUserLogin},
                VisibleNeType => $VisibleType{Service},

            },
        );

        # output count block
        if ( !@ServiceList ) {
            $Self->{LayoutObject}->Block(
                Name => 'AllocateCustomerUserServiceCountLimit',
                Data => { ServiceCount => 0, },
            );
        }
        elsif ( @ServiceList > $SearchLimit ) {
            $Self->{LayoutObject}->Block(
                Name => 'AllocateCustomerUserServiceCountLimit',
                Data => { ServiceCount => ">" . $SearchLimit, },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'AllocateCustomerUserServiceCount',
                Data => { ServiceCount => scalar @ServiceList, },
            );
        }

        # output rows
        for my $Counter ( 1 .. $MaxCount ) {

            # get service
            my %Service = $Self->{ServiceObject}->ServiceGet(
                ServiceID => $ServiceList[ $Counter - 1 ],
                UserID    => $Self->{UserID},
            );

            # set checked
            my $Checked = $ServiceMemberList{ $Service{ServiceID} } ? "checked='checked'" : '';

            # output row block
            $Self->{LayoutObject}->Block(
                Name => 'AllocateCustomerUserRow',
                Data => {
                    Service   => $Service{Name},
                    ServiceID => $Service{ServiceID},
                    Checked   => $Checked,
                },
            );
        }

        # generate output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminCustomerUserService',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # allocate service
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AllocateService' ) {

        # get params
        $Param{ServiceID}          = $Self->{ParamObject}->GetParam( Param => "ServiceID" );
        $Param{CustomerUserSearch} = $Self->{ParamObject}->GetParam( Param => "CustomerUserSearch" )
            || '*';
        $Param{ServiceSearch} = $Self->{ParamObject}->GetParam( Param => "ServiceSearch" ) || '*';

        # output header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # overview
        $Self->{LayoutObject}->Block( Name => 'Overview' );
        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

        # output search block
        $Self->{LayoutObject}->Block(
            Name => 'Search',
            Data => {
                %Param,
                CustomerUserSearch => $Param{CustomerUserSearch},
                ServiceSearch      => $Param{ServiceSearch},
            },
        );

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

        # output allocate block
        $Self->{LayoutObject}->Block(
            Name => 'AllocateService',
            Data => {
                Service => $Service{Name},
                CustomerUserCount => @CustomerUserKeyList || 0,
                %Param,

                Type          => 'Service',
                NeType        => 'CustomerUserLogin',
                VisibleType   => $VisibleType{'Service'},
                VisibleNeType => $VisibleType{'CustomerUserLogin'},

            },
        );

        # output count block
        if ( !@CustomerUserKeyList ) {
            $Self->{LayoutObject}->Block(
                Name => 'AllocateServiceCustomerUserCountLimit',
                Data => { CustomerUserCount => 0, },
            );
        }
        elsif ( @CustomerUserKeyList > $SearchLimit ) {
            $Self->{LayoutObject}->Block(
                Name => 'AllocateServiceCustomerUserCountLimit',
                Data => { CustomerUserCount => ">" . $SearchLimit, },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'AllocateServiceCustomerUserCount',
                Data => { CustomerUserCount => scalar @CustomerUserKeyList, },
            );
        }

        # output rows
        for my $Counter ( 1 .. $MaxCount ) {

            # set checked
            my $Checked
                = $CustomerUserMemberList{ $CustomerUserKeyList[ $Counter - 1 ] }
                ? "checked='checked'"
                : '';

            # output row block

            my %User = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $CustomerUserKeyList[ $Counter - 1 ]
            );
            my $UserName = $Self->{CustomerUserObject}->CustomerName(
                UserLogin => $CustomerUserKeyList[ $Counter - 1 ]
            );
            my $CustomerUser = "$UserName <$User{UserEmail}> ($User{UserCustomerID})";

            $Self->{LayoutObject}->Block(
                Name => 'AllocateServiceRow',
                Data => {
                    CustomerUserLogin => $CustomerUserKeyList[ $Counter - 1 ],
                    CustomerUser      => $CustomerUser,
                    Checked           => $Checked,
                },
            );
        }

        # generate output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminCustomerUserService',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # allocate customer user save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AllocateCustomerUserSave' ) {

        # get params
        $Param{CustomerUserLogin}  = $Self->{ParamObject}->GetParam( Param => 'CustomerUserLogin' );
        $Param{CustomerUserSearch} = $Self->{ParamObject}->GetParam( Param => 'CustomerUserSearch' )
            || '*';
        $Param{ServiceSearch} = $Self->{ParamObject}->GetParam( Param => 'ServiceSearch' ) || '*';
        my @ServiceIDsSelected = $Self->{ParamObject}->GetArray( Param => 'ServiceIDsSelected' );
        my @ServiceIDsAll      = $Self->{ParamObject}->GetArray( Param => 'ServiceIDsAll' );

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
                "Action=$Self->{Action};CustomerUserSearch=$Param{CustomerUserSearch};ServiceSearch=$Param{ServiceSearch}"
        );
    }

    # ------------------------------------------------------------ #
    # allocate service save
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AllocateServiceSave' ) {

        # get params
        $Param{ServiceID}          = $Self->{ParamObject}->GetParam( Param => 'ServiceID' );
        $Param{CustomerUserSearch} = $Self->{ParamObject}->GetParam( Param => 'CustomerUserSearch' )
            || '*';
        $Param{ServiceSearch} = $Self->{ParamObject}->GetParam( Param => 'ServiceSearch' ) || '*';
        my @CustomerUserLoginsSelected
            = $Self->{ParamObject}->GetArray( Param => 'CustomerUserLoginsSelected' );
        my @CustomerUserLoginsAll
            = $Self->{ParamObject}->GetArray( Param => 'CustomerUserLoginsAll' );

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
                "Action=$Self->{Action};CustomerUserSearch=$Param{CustomerUserSearch};ServiceSearch=$Param{ServiceSearch}"
        );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {

        # get params
        $Param{CustomerUserSearch} = $Self->{ParamObject}->GetParam( Param => 'CustomerUserSearch' )
            || '*';
        $Param{ServiceSearch} = $Self->{ParamObject}->GetParam( Param => 'ServiceSearch' ) || '*';

        # output header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        $Self->{LayoutObject}->Block( Name => 'Overview' );
        $Self->{LayoutObject}->Block( Name => 'ActionList' );

        # output search block
        $Self->{LayoutObject}->Block(
            Name => 'Search',
            Data => %Param,
        );

        # output default block
        $Self->{LayoutObject}->Block( Name => 'Default', );

        # search customer user
        my %CustomerUserList
            = $Self->{CustomerUserObject}->CustomerSearch( Search => $Param{CustomerUserSearch}, );
        my @CustomerUserKeyList
            = sort { $CustomerUserList{$a} cmp $CustomerUserList{$b} } keys %CustomerUserList;

        # search services
        my @ServiceList = $Self->{ServiceObject}->ServiceSearch(
            Name   => $Param{ServiceSearch},
            Limit  => $SearchLimit + 1,
            UserID => $Self->{UserID},
        );

        # count results
        my $CustomerUserCount = @CustomerUserKeyList;
        my $ServiceCount      = @ServiceList;

        # set max count
        my $MaxCustomerCount = $CustomerUserCount;
        my $MaxServiceCount  = $ServiceCount;

        if ( $MaxCustomerCount > $SearchLimit ) {
            $MaxCustomerCount = $SearchLimit;
        }

        if ( $MaxServiceCount > $SearchLimit ) {
            $MaxServiceCount = $SearchLimit;
        }

        # output result block
        $Self->{LayoutObject}->Block(
            Name => 'Result',
            Data => {
                %Param,
                CustomerUserCount => $CustomerUserCount,
                ServiceCount      => $ServiceCount,
            },
        );

        # output customer user count block
        if ( !@CustomerUserKeyList ) {
            $Self->{LayoutObject}->Block(
                Name => 'ResultCustomerUserCountLimit',
                Data => { CustomerUserCount => 0, },
            );
            $Self->{LayoutObject}->Block(
                Name => 'NoCustomersFoundMsg',
                Data => { CustomerUserCount => 0, },
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

        # output service count block
        if ( !@ServiceList ) {
            $Self->{LayoutObject}->Block(
                Name => 'ResultServiceCountLimit',
                Data => { ServiceCount => 0, },
            );
            $Self->{LayoutObject}->Block(
                Name => 'NoServicesFoundMsg',
                Data => { CustomerUserCount => 0, },
            );
        }
        elsif ( @ServiceList > $SearchLimit ) {
            $Self->{LayoutObject}->Block(
                Name => 'ResultServiceCountLimit',
                Data => { ServiceCount => ">" . $SearchLimit, },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'ResultServiceCount',
                Data => { ServiceCount => scalar @ServiceList, },
            );
        }

        # output rows
        for my $Counter ( 1 .. $MaxCustomerCount ) {

            my %UserRowParam;

            # set customer user row params
            if ( defined( $CustomerUserKeyList[ $Counter - 1 ] ) ) {
                $UserRowParam{CustomerUserLogin} = $CustomerUserKeyList[ $Counter - 1 ];

                # Get user details
                my %User = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $CustomerUserKeyList[ $Counter - 1 ]
                );
                my $UserName = $Self->{CustomerUserObject}->CustomerName(
                    UserLogin => $CustomerUserKeyList[ $Counter - 1 ]
                );
                $UserRowParam{CustomerUser}
                    = "$UserName <$User{UserEmail}> ($User{UserCustomerID})";
            }

            # output user row block
            $Self->{LayoutObject}->Block(
                Name => 'ResultUserRow',
                Data => { %Param, %UserRowParam, },
            );
        }

        for my $Counter ( 1 .. $MaxServiceCount ) {

            my %ServiceRowParam;

            # set service row params
            if ( $ServiceList[ $Counter - 1 ] ) {
                my %Service = $Self->{ServiceObject}->ServiceGet(
                    ServiceID => $ServiceList[ $Counter - 1 ],
                    UserID    => $Self->{UserID},
                );
                $ServiceRowParam{ServiceID} = $Service{ServiceID};
                $ServiceRowParam{Service}   = $Service{Name};
            }

            # output service row block
            $Self->{LayoutObject}->Block(
                Name => 'ResultServiceRow',
                Data => { %Param, %ServiceRowParam, },
            );
        }

        # generate output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminCustomerUserService',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
}

1;
