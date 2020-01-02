# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminCustomerUserCustomer;

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

    my $LayoutObject          = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject           = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $CustomerUserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');

    # set search limit
    my $SearchLimit = 200;

    $Param{Search} = $ParamObject->GetParam( Param => 'Search' ) || '*';

    # ------------------------------------------------------------ #
    # user <-> customer 1:n
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'CustomerUser' ) {

        # get params
        $Param{Subaction} = $ParamObject->GetParam( Param => 'Subaction' );

        # get user data
        my $ID           = $ParamObject->GetParam( Param => 'ID' );
        my %UserData     = $CustomerUserObject->CustomerUserDataGet( User => $ID );
        my $CustomerName = $CustomerUserObject->CustomerName( UserLogin => $UserData{UserLogin} );

        # search customers
        my %CustomerList = $CustomerCompanyObject->CustomerCompanyList(
            Search => $Param{Search},
        );
        my @CustomerKeyList = sort keys %CustomerList;

        # output rows
        my $ItemsShown = 0;
        my %CustomerData;
        CUSTOMER:
        for my $Customer (@CustomerKeyList) {

            # exclude customer (= primary CustomerID) of selected customer user
            next CUSTOMER if $UserData{UserCustomerID} eq $Customer;

            # check and remember if we have more results than shown
            ++$ItemsShown;
            if ( $ItemsShown > $SearchLimit ) {
                last CUSTOMER;
            }

            $CustomerData{$Customer} = $CustomerList{$Customer};
        }

        # get member list
        my @MemberCustomerIDs = $CustomerUserObject->CustomerUserCustomerMemberList(
            CustomerUserID => $ID,
        );
        my %MemberCustomerIDs = map { $_ => 1 } @MemberCustomerIDs;

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Self->_Change(
            Selected    => \%MemberCustomerIDs,
            Data        => \%CustomerData,
            ID          => $UserData{UserID},
            Name        => "$CustomerName ($UserData{UserLogin})",
            Type        => 'CustomerUser',
            SearchLimit => $SearchLimit,
            ItemsShown  => $ItemsShown,
            Search      => $Param{Search},
            %Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # customer <-> user n:1
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Customer' ) {

        # get params
        $Param{Subaction} = $ParamObject->GetParam( Param => 'Subaction' );

        # get customer data
        my $ID                  = $ParamObject->GetParam( Param => 'ID' );
        my %CustomerCompany     = $CustomerCompanyObject->CustomerCompanyGet( CustomerID => $ID );
        my $CustomerCompanyName = $CustomerCompany{CustomerCompanyName};

        # search customer user
        my %CustomerUserList = $CustomerUserObject->CustomerSearch(
            Search => $Param{Search},
        );
        my @CustomerUserKeyList = sort { $CustomerUserList{$a} cmp $CustomerUserList{$b} } keys %CustomerUserList;

        # output rows
        my $ItemsShown = 0;
        my %CustomerUserData;
        CUSTOMERUSER:
        for my $CustomerUser (@CustomerUserKeyList) {

            # get customer user
            my %User = $CustomerUserObject->CustomerUserDataGet(
                User => $CustomerUser,
            );
            next CUSTOMERUSER if !%User;

            # exclude customer users where customer (= primary CustomerID)
            #   equals selected customer
            next CUSTOMERUSER if $User{UserCustomerID} eq $ID;

            # check if we have more results than shown
            ++$ItemsShown;
            if ( $ItemsShown > $SearchLimit ) {
                last CUSTOMERUSER;
            }

            my $UserName = $CustomerUserObject->CustomerName(
                UserLogin => $CustomerUser,
            );
            $CustomerUserData{ $User{UserID} } =
                "$UserName <$User{UserEmail}> ($User{UserCustomerID})";
        }

        # get member list
        my @CustomerUsers = $CustomerUserObject->CustomerUserCustomerMemberList(
            CustomerID => $ID,
        );
        my %MemberCustomerUsers = map { $_ => 1 } @CustomerUsers;

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Self->_Change(
            Selected    => \%MemberCustomerUsers,
            Data        => \%CustomerUserData,
            ID          => $ID,
            Name        => $CustomerCompanyName,
            Type        => 'Customer',
            SearchLimit => $SearchLimit,
            ItemsShown  => $ItemsShown,
            Search      => $Param{Search},
            %Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add user to groups
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeCustomer' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get new customer users
        my @CustomerUsersSelected = $ParamObject->GetArray( Param => 'ItemsSelected' );
        my @CustomerUsersAll      = $ParamObject->GetArray( Param => 'ItemsAll' );

        my $CustomerID = $ParamObject->GetParam( Param => 'ID' ) || '';

        # create hash with selected customer users
        my %CustomerUsersSelected = map { $_ => 1 } @CustomerUsersSelected;

        # check all used customer users
        for my $CustomerUserID (@CustomerUsersAll) {
            my $Active = $CustomerUsersSelected{$CustomerUserID} ? 1 : 0;

            # set customer user as a member of company
            $CustomerUserObject->CustomerUserCustomerMemberAdd(
                CustomerUserID => $CustomerUserID,
                CustomerID     => $CustomerID,
                Active         => $Active,
                UserID         => $Self->{UserID},
            );
        }

        # If the user would like to continue editing the customer relations for customer user
        #   just redirect to the edit screen and otherwise return to relations overview.
        if (
            defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
            && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
            )
        {
            return $LayoutObject->Redirect(
                OP =>
                    "Action=$Self->{Action};Subaction=Customer;ID=$CustomerID;Search=$Param{Search}"
            );
        }
        else {

            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action};Search=$Param{Search}"
            );
        }
    }

    # ------------------------------------------------------------ #
    # groups to user
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeCustomerUser' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get new customer companies
        my @CustomersSelected = $ParamObject->GetArray( Param => 'ItemsSelected' );
        my @CustomersAll      = $ParamObject->GetArray( Param => 'ItemsAll' );

        my $CustomerUserID = $ParamObject->GetParam( Param => 'ID' );

        # create hash with selected customer companies
        my %CustomersSelected = map { $_ => 1 } @CustomersSelected;

        # check all used customer companies
        for my $CustomerID (@CustomersAll) {
            my $Active = $CustomersSelected{$CustomerID} ? 1 : 0;

            # set customer user as a member of company
            $CustomerUserObject->CustomerUserCustomerMemberAdd(
                CustomerUserID => $CustomerUserID,
                CustomerID     => $CustomerID,
                Active         => $Active,
                UserID         => $Self->{UserID},
            );
        }

        # If the user would like to continue editing the customer user relations for customer
        #   just redirect to the edit screen and otherwise return to relations overview.
        if (
            defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
            && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
            )
        {
            return $LayoutObject->Redirect(
                OP =>
                    "Action=$Self->{Action};Subaction=CustomerUser;ID=$CustomerUserID;Search=$Param{Search}"
            );
        }
        else {

            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action};Search=$Param{Search}"
            );
        }
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # search customer user
    my %CustomerUserList = $CustomerUserObject->CustomerSearch(
        Search => $Param{Search},
    );
    my @CustomerUserKeyList = sort { $CustomerUserList{$a} cmp $CustomerUserList{$b} } keys %CustomerUserList;

    # output rows
    my $CustomerUsersShown = 0;
    my %CustomerUserData;
    CUSTOMERUSER:
    for my $CustomerUser (@CustomerUserKeyList) {

        # get customer user
        my %User = $CustomerUserObject->CustomerUserDataGet(
            User => $CustomerUser,
        );
        next CUSTOMERUSER if !%User;

        # check if we have more results than shown
        ++$CustomerUsersShown;
        if ( $CustomerUsersShown > $SearchLimit ) {
            last CUSTOMERUSER;
        }

        my $UserName = $CustomerUserObject->CustomerName(
            UserLogin => $CustomerUser,
        );
        $CustomerUserData{ $User{UserID} } =
            "$UserName <$User{UserEmail}> ($User{UserCustomerID})";
    }

    # search customers
    my %CustomerList = $CustomerCompanyObject->CustomerCompanyList(
        Search => $Param{Search},
    );
    my @CustomerKeyList = sort keys %CustomerList;

    # output rows
    my $CustomersShown = 0;
    my %CustomerData;
    CUSTOMER:
    for my $Customer (@CustomerKeyList) {

        # check and remember if we have more results than shown
        ++$CustomersShown;
        if ( $CustomersShown > $SearchLimit ) {
            last CUSTOMER;
        }

        $CustomerData{$Customer} = $CustomerList{$Customer};
    }

    $Output .= $Self->_Overview(
        CustomerUserData   => \%CustomerUserData,
        CustomerData       => \%CustomerData,
        SearchLimit        => $SearchLimit,
        CustomersShown     => $CustomersShown,
        CustomerUsersShown => $CustomerUsersShown,
        Search             => $Param{Search},
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data        = %{ $Param{Data} };
    my $Type        = $Param{Type} || 'CustomerUser';
    my $NeType      = $Type eq 'Customer' ? 'CustomerUser' : 'Customer';
    my %VisibleType = (
        CustomerUser => 'Customer User',
        Customer     => 'Customer',
    );

    my $SearchLimit = $Param{SearchLimit};
    my $ItemsShown  = $Param{ItemsShown};

    if ( $VisibleType{$NeType} eq 'Customer' ) {
        $Param{BreadcrumbTitle} = "Change Customer Relations for Customer User";
    }
    else {
        $Param{BreadcrumbTitle} = "Change Customer User Relations for Customer";
    }

    # overview
    $LayoutObject->Block(
        Name => 'Overview',
        Data => {
            %Param,
            OverviewLink => $Self->{Action} . ';Search=' . $Param{Search},
        },
    );
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block(
        Name => 'ActionOverview',
        Data => {
            Search => $Param{Search},
        },
    );

    # output search block
    $LayoutObject->Block(
        Name => 'Search',
        Data => {
            %Param,
            Search => $Param{Search},
        },
    );

    $LayoutObject->Block(
        Name => 'SearchChange',
        Data => {
            %Param,
            Subaction => $Param{Subaction},
        },
    );

    $LayoutObject->Block( Name => 'Note' );

    $LayoutObject->Block(
        Name => 'Change',
        Data => {
            %Param,
            ActionHome    => 'Admin' . ( $Type eq 'Customer' ? 'CustomerCompany' : $Type ),
            VisibleNeType => $VisibleType{$NeType},
            VisibleType   => $VisibleType{$Type},
        },
    );

    $LayoutObject->Block(
        Name => 'ChangeHeading' . $Type,
    );

    # set group permissions
    $LayoutObject->AddJSData(
        Key   => 'RelationItems',
        Value => [$Type],
    );

    # check if there are customer users/customers
    if ( !%Data ) {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsgList',
            Data => {
                ColSpan => 2,
            },
        );
    }

    # output count block
    if ( !$ItemsShown ) {
        $LayoutObject->Block(
            Name => 'ChangeItemCountLimit',
            Data => {
                ItemCount => 0,
            },
        );

    }
    elsif ( $ItemsShown > $SearchLimit ) {
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
                ItemCount => $ItemsShown,
            },
        );
    }

    $LayoutObject->Block(
        Name => 'ChangeHeader',
        Data => {
            %Param,
            Type          => $Type,
            NeType        => $NeType,
            VisibleType   => $VisibleType{$Type},
            VisibleNeType => $VisibleType{$NeType},
        },
    );

    for my $ID ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        # set output class
        my $Selected = $Param{Selected}->{$ID} ? ' checked="checked"' : '';

        $LayoutObject->Block(
            Name => 'ChangeRow',
            Data => {
                %Param,
                ActionHome    => 'Admin' . ( $NeType eq 'Customer' ? 'CustomerCompany' : $NeType ),
                Name          => $Param{Data}->{$ID},
                NeType        => $NeType,
                Type          => $Type,
                ID            => $ID,
                Selected      => $Selected,
                VisibleType   => $VisibleType{$Type},
                VisibleNeType => $VisibleType{$NeType},
            },
        );
    }

    return $LayoutObject->Output(
        TemplateFile => 'AdminCustomerUserCustomer',
        Data         => \%Param,
    );
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %CustomerUserData = %{ $Param{CustomerUserData} };

    my %CustomerData = %{ $Param{CustomerData} };

    my $SearchLimit        = $Param{SearchLimit};
    my $CustomersShown     = $Param{CustomersShown};
    my $CustomerUsersShown = $Param{CustomerUsersShown};

    $LayoutObject->Block(
        Name => 'Overview',
        Data => {},
    );

    $LayoutObject->Block( Name => 'ActionList' );

    # output search customer user block
    $LayoutObject->Block(
        Name => 'Search',
        Data => \%Param,
    );

    # output result block
    $LayoutObject->Block(
        Name => 'Result',
        Data => {
            %Param,
        },
    );

    # output customer user count block
    if ( !$CustomerUsersShown ) {
        $LayoutObject->Block(
            Name => 'ResultCustomerUserCountLimit',
            Data => {
                CustomerUserCount => 0,
            },
        );
        $LayoutObject->Block(
            Name => 'NoDataFoundMsgCustomerUser',
        );
    }
    elsif ( $CustomerUsersShown > $SearchLimit ) {
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
                CustomerUserCount => $CustomerUsersShown,
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

    # output customer user count block
    if ( !$CustomersShown ) {
        $LayoutObject->Block(
            Name => 'ResultCustomerCountLimit',
            Data => {
                CustomerCount => 0,
            },
        );
        $LayoutObject->Block(
            Name => 'NoDataFoundMsgCustomer',
        );
    }
    elsif ( $CustomersShown > $SearchLimit ) {
        $LayoutObject->Block(
            Name => 'ResultCustomerCountLimit',
            Data => {
                CustomerCount => ">" . $SearchLimit,
            },
        );
    }
    else {
        $LayoutObject->Block(
            Name => 'ResultCustomerCount',
            Data => {
                CustomerCount => $CustomersShown,
            },
        );
    }

    for my $ID (
        sort { uc( $CustomerData{$a} ) cmp uc( $CustomerData{$b} ) }
        keys %CustomerData
        )
    {

        # output customer row block
        $LayoutObject->Block(
            Name => 'Listn1',
            Data => {
                %Param,
                ID        => $ID,
                Name      => $CustomerData{$ID},
                Subaction => 'Customer',
            },
        );
    }

    # return output
    return $LayoutObject->Output(
        TemplateFile => 'AdminCustomerUserCustomer',
        Data         => \%Param,
    );

}

1;
