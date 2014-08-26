# --
# Kernel/Output/HTML/DashboardCustomerUserList.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardCustomerUserList;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(Config Name UserID)) {
        die "Got no $Needed!" if ( !$Self->{$Needed} );
    }

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get current filter
    my $Name = $Self->{ParamObject}->GetParam( Param => 'Name' ) || '';
    my $PreferencesKey = 'UserDashboardCustomerUserListFilter' . $Self->{Name};

    $Self->{PrefKey} = 'UserDashboardPref' . $Self->{Name} . '-Shown';

    $Self->{PageShown} = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{ $Self->{PrefKey} }
        || $Self->{Config}->{Limit};
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

    # get customer user object
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    my $CustomerIDs
        = { $CustomerUserObject->CustomerSearch( CustomerID => $Param{CustomerID} ) };

    # add page nav bar
    my $Total = scalar keys %{$CustomerIDs};

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

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

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check the permission for the SwitchToCustomer feature
    if ( $ConfigObject->Get('SwitchToCustomer') ) {

        # get group object
        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

        # get the group id which is allowed to use the switch to customer feature
        my $SwitchToCustomerGroupID = $Self->{GroupObject}->GroupLookup(
            Group => $ConfigObject->Get('SwitchToCustomer::PermissionGroup'),
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
    my %CustomerSource = $CustomerUserObject->CustomerSourceList(
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

    # get the permission for the phone ticket creation
    my $NewAgentTicketPhonePermission = $Self->{LayoutObject}->Permission(
        Action => 'AgentTicketPhone',
        Type   => 'rw',
    );

    # check the permission for the phone ticket creation
    if ($NewAgentTicketPhonePermission) {
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResultNewAgentTicketPhone',
        );
    }

    # get the permission for the email ticket creation
    my $NewAgentTicketEmailPermission = $Self->{LayoutObject}->Permission(
        Action => 'AgentTicketEmail',
        Type   => 'rw',
    );

    # check the permission for the email ticket creation
    if ($NewAgentTicketEmailPermission) {
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResultNewAgentTicketEmail',
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

        # do we need to show the chat link?
        # should only be visible if
        # 1. chat is active
        # 2. current user has access to the chat
        # 3. this customer user is online
        my $ChatStartingAgentsGroup
            = $Self->{ConfigObject}->Get('ChatEngine::PermissionGroup::ChatStartingAgents');

        if (
            $Self->{ConfigObject}->Get('ChatEngine::Active')
            && $Self->{LayoutObject}->{"UserIsGroup[$ChatStartingAgentsGroup]"}
            && $Self->{ConfigObject}->Get('ChatEngine::ChatDirection::AgentToCustomer')
            )
        {

            # check if this customer is actually online
            my @Sessions         = $Self->{SessionObject}->GetAllSessionIDs();
            my $CustomerIsOnline = 0;

            SESSIONID:
            for my $SessionID (@Sessions) {

                next SESSIONID if !$SessionID;

                # get session data
                my %Data = $Self->{SessionObject}->GetSessionIDData( SessionID => $SessionID );

                next SESSIONID if !%Data;
                next SESSIONID if !$Data{UserID};
                next SESSIONID if $Data{UserID} ne $CustomerKey;

                $CustomerIsOnline = 1;
            }

            if ($CustomerIsOnline) {

                my $UserFullname = $Self->{CustomerUserObject}->CustomerName(
                    UserLogin => $CustomerKey,
                );

                $Self->{LayoutObject}->Block(
                    Name => 'ContentLargeCustomerUserListRowCustomerKeyChatStart',
                    Data => {
                        UserFullname => $UserFullname,
                        UserID       => $CustomerKey,
                    },
                );
            }
        }

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my $TicketCountOpen = $Self->{TicketObject}->TicketSearch(
            StateType            => 'Open',
            CustomerUserLoginRaw => $CustomerKey,
            Result               => 'COUNT',
            Permission           => $Self->{Config}->{Permission},
            UserID               => $Self->{UserID},
            CacheTTL             => $Self->{Config}->{CacheTTLLocal} * 60,
        );

        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeCustomerUserListRowCustomerUserTicketsOpen',
            Data => {
                %Param,
                Count       => $TicketCountOpen,
                CustomerKey => $CustomerKey,
            },
        );

        my $TicketCountClosed = $Self->{TicketObject}->TicketSearch(
            StateType            => 'Closed',
            CustomerUserLoginRaw => $CustomerKey,
            Result               => 'COUNT',
            Permission           => $Self->{Config}->{Permission},
            UserID               => $Self->{UserID},
            CacheTTL             => $Self->{Config}->{CacheTTLLocal} * 60,
        );

        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeCustomerUserListRowCustomerUserTicketsClosed',
            Data => {
                %Param,
                Count       => $TicketCountClosed,
                CustomerKey => $CustomerKey,
            },
        );

        # check the permission for the phone ticket creation
        if ($NewAgentTicketPhonePermission) {
            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeCustomerUserListNewAgentTicketPhone',
                Data => {
                    %Param,
                    CustomerKey       => $CustomerKey,
                    CustomerListEntry => $CustomerIDs->{$CustomerKey},
                },
            );
        }

        # check the permission for the email ticket creation
        if ($NewAgentTicketEmailPermission) {
            $Self->{LayoutObject}->Block(
                Name => 'ContentLargeCustomerUserListNewAgentTicketEmail',
                Data => {
                    %Param,
                    CustomerKey       => $CustomerKey,
                    CustomerListEntry => $CustomerIDs->{$CustomerKey},
                },
            );
        }

        if ( $ConfigObject->Get('SwitchToCustomer') && $Self->{SwitchToCustomerPermission} )
        {
            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultRowSwitchToCustomer',
                Data => {
                    %Param,
                    Count       => $TicketCountClosed,
                    CustomerKey => $CustomerKey,
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

    # check for refresh time
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
        my $NameHTML = $Self->{Name};
        $NameHTML =~ s{-}{_}xmsg;
        $Self->{LayoutObject}->Block(
            Name => 'ContentLargeTicketGenericRefresh',
            Data => {
                %{ $Self->{Config} },
                Name        => $Self->{Name},
                NameHTML    => $NameHTML,
                RefreshTime => $Refresh,
                CustomerID  => $Param{CustomerID},
            },
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
