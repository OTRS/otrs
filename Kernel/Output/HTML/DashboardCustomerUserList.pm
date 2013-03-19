# --
# Kernel/Output/HTML/DashboardCustomerUserList.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardCustomerUserList;

use strict;
use warnings;

use Kernel::System::CustomerUser;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(Config Name ConfigObject LogObject DBObject LayoutObject TicketObject ParamObject UserID GroupObject)
        )
    {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );

    # get current filter
    my $Name = $Self->{ParamObject}->GetParam( Param => 'Name' ) || '';
    my $PreferencesKey = 'UserDashboardCustomerUserListFilter' . $Self->{Name};

    $Self->{PrefKey} = 'UserDashboardPref' . $Self->{Name} . '-Shown';

    $Self->{PageShown} = $Self->{LayoutObject}->{ $Self->{PrefKey} } || $Self->{Config}->{Limit};
    $Self->{StartHit} = int( $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1 );

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    my @Params = (
        {
            Desc  => 'Shown customer users',
            Name  => $Self->{PrefKey},
            Block => 'Option',

            #            Block => 'Input',
            Data => {
                5  => ' 5',
                10 => '10',
                15 => '15',
                20 => '20',
                25 => '25',
            },
            SelectedID  => $Self->{PageShown},
            Translation => 0,
        },
    );

    return @Params;
}

sub Config {
    my ( $Self, %Param ) = @_;

    return (
        %{ $Self->{Config} },

        # remember, do not allow to use page cache
        # (it's not working because of internal filter)
        CacheTTL => undef,
        CacheKey => undef,
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    return if !$Param{CustomerID};

    my $CustomerIDs
        = { $Self->{CustomerUserObject}->CustomerSearch( CustomerID => $Param{CustomerID} ) };

    # add page nav bar
    my $Total = scalar keys %{$CustomerIDs};

    my $LinkPage
        = 'Subaction=Element;Name='
        . $Self->{Name} . ';'
        . 'CustomerID='
        . $Self->{LayoutObject}->LinkEncode( $Param{CustomerID} ) . ';';

    my %PageNav = $Self->{LayoutObject}->PageNavBar(
        StartHit       => $Self->{StartHit},
        PageShown      => $Self->{PageShown},
        AllHits        => $Total || 1,
        Action         => 'Action=' . $Self->{LayoutObject}->{Action},
        Link           => $LinkPage,
        AJAXReplace    => 'Dashboard' . $Self->{Name},
        IDPrefix       => 'Dashboard' . $Self->{Name},
        KeepScriptTags => $Param{AJAX},
    );

    $Self->{LayoutObject}->Block(
        Name => 'ContentLargeCustomerUserListNavBar',
        Data => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %PageNav,
        },
    );

    # check the permission for the SwitchToCustomer feature
    if ( $Self->{ConfigObject}->Get('SwitchToCustomer') ) {

        # get the group id which is allowed to use the switch to customer feature
        my $SwitchToCustomerGroupID = $Self->{GroupObject}->GroupLookup(
            Group => $Self->{ConfigObject}->Get('SwitchToCustomer::PermissionGroup'),
        );

        # get user groups, where the user has the rw privilege
        my %Groups = $Self->{GroupObject}->GroupMemberList(
            UserID => $Self->{UserID},
            Type   => 'rw',
            Result => 'HASH',
        );

        # if the user is a member in this group he can access the feature
        if ( $Groups{$SwitchToCustomerGroupID} ) {

            $Self->{SwitchToCustomerPermission} = 1;

            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultSwitchToCustomer',
            );
        }
    }

    # show add new customer button if there are writable customer backends and if
    # the agent has permission
    my $AddAccess = $Self->{LayoutObject}->Permission(
        Action => 'AdminCustomerUser',
        Type   => 'rw',                  # ro|rw possible
    );

    # get writable data sources
    my %CustomerSource = $Self->{CustomerUserObject}->CustomerSourceList(
        ReadOnly => 0,
    );

    if ( $AddAccess && scalar keys %CustomerSource ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeCustomerUserAdd',
            Data => {
                CustomerID => $Self->{CustomerID},
            },
        );
    }

    my @CustomerKeys
        = sort { lc( $CustomerIDs->{$a} ) cmp lc( $CustomerIDs->{$b} ) } keys %{$CustomerIDs};
    @CustomerKeys = splice @CustomerKeys, $Self->{StartHit} - 1, $Self->{PageShown};

    for my $CustomerKey (@CustomerKeys) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeCustomerUserListRow',
            Data => {
                %Param,
                CustomerKey       => $CustomerKey,
                CustomerListEntry => $CustomerIDs->{$CustomerKey},
            },
        );

        # can edit?
        if ( $AddAccess && scalar keys %CustomerSource ) {
            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeCustomerUserListRowCustomerKeyLink',
                Data => {
                    %Param,
                    CustomerKey       => $CustomerKey,
                    CustomerListEntry => $CustomerIDs->{$CustomerKey},
                },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeCustomerUserListRowCustomerKeyText',
                Data => {
                    %Param,
                    CustomerKey       => $CustomerKey,
                    CustomerListEntry => $CustomerIDs->{$CustomerKey},
                },
            );
        }

        my $CustomerKeySQL = $Self->{DBObject}->QueryStringEscape( QueryString => $CustomerKey );

        my $TicketCountOpen = $Self->{TicketObject}->TicketSearch(
            StateType         => 'Open',
            CustomerUserLogin => $CustomerKeySQL,
            Result            => 'COUNT',
            Permission        => $Self->{Config}->{Permission},
            UserID            => $Self->{UserID},
            CacheTTL          => $Self->{Config}->{CacheTTLLocal} * 60,
        );

        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeCustomerUserListRowCustomerUserTicketsOpen',
            Data => {
                %Param,
                Count          => $TicketCountOpen,
                CustomerKey    => $CustomerKey,
                CustomerKeySQL => $CustomerKeySQL,
            },
        );

        my $TicketCountClosed = $Self->{TicketObject}->TicketSearch(
            StateType         => 'Closed',
            CustomerUserLogin => $CustomerKeySQL,
            Result            => 'COUNT',
            Permission        => $Self->{Config}->{Permission},
            UserID            => $Self->{UserID},
            CacheTTL          => $Self->{Config}->{CacheTTLLocal} * 60,
        );

        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeCustomerUserListRowCustomerUserTicketsClosed',
            Data => {
                %Param,
                Count          => $TicketCountClosed,
                CustomerKey    => $CustomerKey,
                CustomerKeySQL => $CustomerKeySQL,
            },
        );

        if ( $Self->{ConfigObject}->Get('SwitchToCustomer') && $Self->{SwitchToCustomerPermission} )
        {
            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultRowSwitchToCustomer',
                Data => {
                    %Param,
                    Count          => $TicketCountClosed,
                    CustomerKey    => $CustomerKey,
                    CustomerKeySQL => $CustomerKeySQL,
                },
            );
        }
    }

    # show "none" if there are no customers
    if ( !%{$CustomerIDs} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeCustomerUserListNone',
            Data => {},
        );
    }

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardCustomerUserList',
        Data         => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
        },
        KeepScriptTags => $Param{AJAX},
    );

    return $Content;
}

1;
