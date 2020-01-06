# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminCustomerGroup;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsHashRefWithData);
use Kernel::Language qw(Translatable);

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
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        $Output .= $Self->_Disabled();

        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    my $ParamObject           = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
    my $CustomerGroupObject   = $Kernel::OM->Get('Kernel::System::CustomerGroup');
    my $GroupObject           = $Kernel::OM->Get('Kernel::System::Group');

    # set search limit
    my $SearchLimit = 200;

    # get permission contexts
    my $ContextConfig = $ConfigObject->Get('CustomerGroupPermissionContext');

    # throw an error if no context found
    if ( !IsHashRefWithData($ContextConfig) ) {
        return $LayoutObject->FatalError(
            Message =>
                Translatable("No configuration for 'CustomerGroupPermissionContext' found!")
                . ' '
                . Translatable('Please check system configuration.'),
        );
    }

    my @Contexts;
    my %ContextLookup;
    for my $Key ( sort keys %{$ContextConfig} ) {
        my $Context = $ContextConfig->{$Key}->{Value};

        # throw an error if no value present
        if ( !$Context ) {
            return $LayoutObject->FatalError(
                Message =>
                    Translatable('Invalid permission context configuration:')
                    . " 'CustomerGroupPermissionContext' -> '$Key'. "
                    . Translatable('Please check system configuration.'),
            );
        }

        push @Contexts, $Context;
        $ContextLookup{$Context} = $ContextConfig->{$Key};
    }

    $Param{CustomerSearch} = $ParamObject->GetParam( Param => "CustomerSearch" ) || '*';

    # ------------------------------------------------------------ #
    # customer <-> group 1:n
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Customer' ) {

        # get user data
        my $ID                  = $ParamObject->GetParam( Param => 'ID' );
        my %CustomerCompany     = $CustomerCompanyObject->CustomerCompanyGet( CustomerID => $ID );
        my $CustomerCompanyName = $CustomerCompany{CustomerCompanyName};

        # get group data
        my %GroupData = $GroupObject->GroupList( Valid => 1 );
        my %Types;
        for my $Context (@Contexts) {
            for my $Type ( @{ $ConfigObject->Get('System::Customer::Permission') } ) {
                my %Data = $CustomerGroupObject->GroupCustomerList(
                    CustomerID => $ID,
                    Type       => $Type,
                    Context    => $Context,
                    Result     => 'HASH',
                );
                $Types{$Context}->{$Type} = \%Data;
            }
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Self->_Change(
            %Types,
            Data           => \%GroupData,
            ID             => $ID,
            Name           => $CustomerCompanyName,
            Type           => 'Customer',
            CustomerSearch => $Param{CustomerSearch},
            Contexts       => \@Contexts,
            ContextLookup  => \%ContextLookup,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # group <-> customer n:1
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Group' ) {

        # Get params.
        $Param{Subaction} = $ParamObject->GetParam( Param => 'Subaction' );

        # get group data
        my $ID        = $ParamObject->GetParam( Param => 'ID' );
        my %GroupData = $GroupObject->GroupGet( ID => $ID );

        # search customers
        my %CustomerList = $CustomerCompanyObject->CustomerCompanyList(
            Search => $Param{CustomerSearch},
        );
        my @CustomerKeyList = sort keys %CustomerList;

        # set max count
        my $MaxCount = @CustomerKeyList;
        if ( $MaxCount > $SearchLimit ) {
            $MaxCount = $SearchLimit;
        }

        my %CustomerData;

        # output rows
        for my $Counter ( 1 .. $MaxCount ) {
            $CustomerData{ $CustomerKeyList[ $Counter - 1 ] } = $CustomerList{ $CustomerKeyList[ $Counter - 1 ] };
        }

        # get permission list users
        my %Types;
        for my $Context (@Contexts) {
            for my $Type ( @{ $ConfigObject->Get('System::Customer::Permission') } ) {
                my %Data = $CustomerGroupObject->GroupCustomerList(
                    GroupID => $ID,
                    Type    => $Type,
                    Context => $Context,
                    Result  => 'HASH',
                );
                $Types{$Context}->{$Type} = \%Data;
            }
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Self->_Change(
            %Types,
            Data           => \%CustomerData,
            ID             => $GroupData{ID},
            Name           => $GroupData{Name},
            Type           => 'Group',
            SearchLimit    => $SearchLimit,
            ItemList       => \@CustomerKeyList,
            CustomerSearch => $Param{CustomerSearch},
            Contexts       => \@Contexts,
            ContextLookup  => \%ContextLookup,
            %Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add customer to groups
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeGroup' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $ID = $ParamObject->GetParam( Param => 'ID' ) || '';

        # get customer data
        my %CustomerList = $CustomerCompanyObject->CustomerCompanyList(
            Search => $Param{CustomerSearch},
        );

        # get new groups
        for my $Context (@Contexts) {
            my %Permissions;
            for my $Type ( @{ $ConfigObject->Get('System::Customer::Permission') } ) {
                my @IDs = $ParamObject->GetArray( Param => "${Context}_${Type}" );
                $Permissions{$Context}->{$Type} = \@IDs;
            }

            my %NewPermission;
            for my $CustomerID ( sort keys %CustomerList ) {
                for my $Permission ( sort keys %{ $Permissions{$Context} } ) {
                    $NewPermission{$Context}->{$Permission} = 0;
                    my @Array = @{ $Permissions{$Context}->{$Permission} };
                    for my $ID (@Array) {
                        if ( $CustomerID eq $ID ) {
                            $NewPermission{$Context}->{$Permission} = 1;
                        }
                    }
                }

                $CustomerGroupObject->GroupCustomerAdd(
                    CustomerID => $CustomerID,
                    GID        => $ID,
                    Permission => \%NewPermission,
                    UserID     => $Self->{UserID},
                );
            }
        }

        # If the user would like to continue editing the group relations for customer
        #   just redirect to the edit screen and otherwise return to relations overview.
        if (
            defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
            && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
            )
        {
            return $LayoutObject->Redirect(
                OP =>
                    "Action=$Self->{Action};Subaction=Group;ID=$ID;CustomerSearch=$Param{CustomerSearch}"
            );
        }
        else {

            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action};CustomerSearch=$Param{CustomerSearch}"
            );
        }
    }

    # ------------------------------------------------------------ #
    # groups to customer
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeCustomer' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $ID = $ParamObject->GetParam( Param => 'ID' );

        # get group data
        my %GroupData = $GroupObject->GroupList( Valid => 1 );

        # get new groups
        for my $Context (@Contexts) {
            my %Permissions;
            for my $Type ( @{ $ConfigObject->Get('System::Customer::Permission') } ) {
                my @IDs = $ParamObject->GetArray( Param => "${Context}_${Type}" );
                $Permissions{$Context}->{$Type} = \@IDs;
            }

            my %NewPermission;
            for my $GroupID ( sort keys %GroupData ) {
                for my $Permission ( sort keys %{ $Permissions{$Context} } ) {
                    $NewPermission{$Context}->{$Permission} = 0;
                    my @Array = @{ $Permissions{$Context}->{$Permission} };
                    for my $ID (@Array) {
                        if ( $GroupID eq $ID ) {
                            $NewPermission{$Context}->{$Permission} = 1;
                        }
                    }
                }

                $CustomerGroupObject->GroupCustomerAdd(
                    CustomerID => $ID,
                    GID        => $GroupID,
                    Permission => \%NewPermission,
                    UserID     => $Self->{UserID},
                );
            }
        }

        # If the user would like to continue editing the customer relations for group
        #   just redirect to the edit screen and otherwise return to relations overview.
        if (
            defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
            && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
            )
        {
            return $LayoutObject->Redirect(
                OP =>
                    "Action=$Self->{Action};Subaction=Customer;ID=$ID;CustomerSearch=$Param{CustomerSearch}"
            );
        }
        else {

            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action};CustomerSearch=$Param{CustomerSearch}"
            );
        }
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # search customers
    my %CustomerList = $CustomerCompanyObject->CustomerCompanyList(
        Search => $Param{CustomerSearch},
    );
    my @CustomerKeyList = sort keys %CustomerList;

    # count results
    my $CustomerCount = @CustomerKeyList;

    # set max count
    my $MaxCustomerCount = $CustomerCount;

    if ( $MaxCustomerCount > $SearchLimit ) {
        $MaxCustomerCount = $SearchLimit;
    }

    # output rows
    my %CustomerData;
    for my $Counter ( 1 .. $MaxCustomerCount ) {
        $CustomerData{ $CustomerKeyList[ $Counter - 1 ] } = $CustomerList{ $CustomerKeyList[ $Counter - 1 ] };
    }

    # get group data
    my %GroupData = $GroupObject->GroupList( Valid => 1 );

    $Output .= $Self->_Overview(
        CustomerCount   => $CustomerCount,
        CustomerKeyList => \@CustomerKeyList,
        CustomerData    => \%CustomerData,
        GroupData       => \%GroupData,
        SearchLimit     => $SearchLimit,
        CustomerSearch  => $Param{CustomerSearch},
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my %Data        = %{ $Param{Data} };
    my $Type        = $Param{Type} || 'Customer';
    my $NeType      = $Type eq 'Group' ? 'Customer' : 'Group';
    my %VisibleType = (
        Customer => 'Customer',
        Group    => 'Group',
    );
    my $SearchLimit   = $Param{SearchLimit};
    my %ContextLookup = %{ $Param{ContextLookup} };
    my @Contexts      = @{ $Param{Contexts} };

    my @ItemList = ();

    if ( $VisibleType{$NeType} eq 'Customer' ) {
        $Param{BreadcrumbTitle} = "Change Customer Relations for Group";
    }
    else {
        $Param{BreadcrumbTitle} = "Change Group Relations for Customer";
    }

    # overview
    $LayoutObject->Block(
        Name => 'Overview',
        Data => {
            %Param,
            OverviewLink => $Self->{Action} . ';CustomerSearch=' . $Param{CustomerSearch},
        },
    );
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block(
        Name => 'ActionOverview',
        Data => {
            CustomerSearch => $Param{CustomerSearch},
        },
    );

    if ( $NeType eq 'Customer' ) {
        @ItemList = @{ $Param{ItemList} };

        # output search block
        $LayoutObject->Block(
            Name => 'Search',
            Data => {
                %Param,
                CustomerSearch => $Param{CustomerSearch},
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

        # output config shortcut to CustomerAlwaysGroups
        $LayoutObject->Block( Name => 'AlwaysGroupsConfig' );

        $LayoutObject->Block( Name => 'Filter' );
    }

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
        Name => 'ChangeHeading' . $NeType,
    );

    my @GroupPermissions;

    for my $Context (@Contexts) {

        TYPE:
        my $TypeCount = 0;
        for my $Type ( @{ $ConfigObject->Get('System::Customer::Permission') } ) {
            next TYPE if !$Type;
            my $Mark = $Type eq 'rw' ? "Highlight" : '';

            push @GroupPermissions, "${Context}_${Type}";
            $TypeCount++;

            $LayoutObject->Block(
                Name => 'ChangeHeader',
                Data => {
                    %{ $Param{$Context} },
                    Context => $Context,
                    Mark    => $Mark,
                    Type    => $Type,
                },
            );
        }

        $LayoutObject->Block(
            Name => 'ChangeHeaderContextName',
            Data => {
                %{ $Param{$Context} },
                Count => $TypeCount,
                Name  => $ContextLookup{$Context}->{Name},
            },
        );
    }

    # set group permissions
    $LayoutObject->AddJSData(
        Key   => 'RelationItems',
        Value => \@GroupPermissions,
    );

    # check if there are groups/customers
    if ( !%Data ) {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsgList',
            Data => {
                ColSpan => 3,
            },
        );
    }

    if ( $NeType eq 'Customer' ) {

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

    my @CustomerAlwaysGroups = @{ $ConfigObject->Get('CustomerGroupCompanyAlwaysGroups') };

    DATAITEM:
    for my $ID ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        next DATAITEM if ( grep {m/\Q$Param{Data}->{$ID}\E/} @CustomerAlwaysGroups );

        # set output class
        $LayoutObject->Block(
            Name => 'ChangeRow',
            Data => {
                %Param,
                ActionHome => 'Admin' . ( $NeType eq 'Customer' ? 'CustomerCompany' : $NeType ),
                Name       => $Param{Data}->{$ID},
                ID         => $ID,
                NeType     => $NeType,
            },
        );

        for my $Context (@Contexts) {

            TYPE:
            for my $Type ( @{ $ConfigObject->Get('System::Customer::Permission') } ) {
                next TYPE if !$Type;
                my $Mark     = $Type eq 'rw'                    ? "Highlight"          : '';
                my $Selected = $Param{$Context}->{$Type}->{$ID} ? ' checked="checked"' : '';
                $LayoutObject->Block(
                    Name => 'ChangeRowItem',
                    Data => {
                        %{ $Param{$Context} },
                        Mark     => $Mark,
                        Type     => $Type,
                        Context  => $Context,
                        ID       => $ID,
                        Selected => $Selected,
                        Name     => $Param{Data}->{$ID},
                    },
                );
            }
        }
    }

    if ( $Type eq 'Customer' ) {
        $LayoutObject->Block( Name => 'AlwaysGroups' );

        for my $ID ( 1 .. @CustomerAlwaysGroups ) {
            $LayoutObject->Block(
                Name => 'AlwaysGroupsList',
                Data => {
                    Name => $CustomerAlwaysGroups[ $ID - 1 ],
                },
            );
        }
    }

    $LayoutObject->Block(
        Name => 'Reference',
        Data => {
            Contexts      => \@Contexts,
            ContextLookup => \%ContextLookup,
        },
    );

    return $LayoutObject->Output(
        TemplateFile => 'AdminCustomerGroup',
        Data         => \%Param,
    );
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $CustomerCount   = $Param{CustomerCount};
    my @CustomerKeyList = @{ $Param{CustomerKeyList} };
    my %CustomerData    = %{ $Param{CustomerData} };
    my %GroupData       = %{ $Param{GroupData} };
    my $SearchLimit     = $Param{SearchLimit};

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
    if ( !@CustomerKeyList ) {
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
    elsif ( @CustomerKeyList > $SearchLimit ) {
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
                CustomerCount => scalar @CustomerKeyList,
            },
        );
    }

    for my $ID (
        sort { uc( $CustomerData{$a} ) cmp uc( $CustomerData{$b} ) }
        keys %CustomerData
        )
    {

        # output user row block
        $LayoutObject->Block(
            Name => 'List1n',
            Data => {
                %Param,
                ID        => $ID,
                Name      => $CustomerData{$ID},
                Subaction => 'Customer',
            },
        );
    }

    my @CustomerAlwaysGroups = @{ $ConfigObject->Get('CustomerGroupCompanyAlwaysGroups') };

    if (%GroupData) {
        GROUP:
        for my $ID (
            sort { uc( $GroupData{$a} ) cmp uc( $GroupData{$b} ) }
            keys %GroupData
            )
        {
            next GROUP if ( grep {m/\Q$GroupData{$ID}\E/} @CustomerAlwaysGroups );

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
        );
    }

    # return output
    return $LayoutObject->Output(
        TemplateFile => 'AdminCustomerGroup',
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
        TemplateFile => 'AdminCustomerGroup',
        Data         => \%Param,
    );
}

1;
