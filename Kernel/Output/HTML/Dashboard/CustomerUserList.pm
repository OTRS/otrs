# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Dashboard::CustomerUserList;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed parameters
    for my $Needed (qw(Config Name UserID)) {
        die "Got no $Needed!" if ( !$Self->{$Needed} );
    }

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get current filter
    my $Name           = $ParamObject->GetParam( Param => 'Name' ) || '';
    my $PreferencesKey = 'UserDashboardCustomerUserListFilter' . $Self->{Name};

    $Self->{PrefKey} = 'UserDashboardPref' . $Self->{Name} . '-Shown';

    $Self->{PageShown} = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{ $Self->{PrefKey} }
        || $Self->{Config}->{Limit};

    $Self->{StartHit} = int( $ParamObject->GetParam( Param => 'StartHit' ) || 1 );

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    my @Params = (
        {
            Desc  => Translatable('Shown customer users'),
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

    my $CustomerIDs = { $CustomerUserObject->CustomerSearch( CustomerIDRaw => $Param{CustomerID} ) };

    # add page nav bar
    my $Total = scalar keys %{$CustomerIDs};

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $LinkPage = 'Subaction=Element;Name='
        . $Self->{Name} . ';'
        . 'CustomerID='
        . $LayoutObject->LinkEncode( $Param{CustomerID} ) . ';';

    my %PageNav = $LayoutObject->PageNavBar(
        StartHit    => $Self->{StartHit},
        PageShown   => $Self->{PageShown},
        AllHits     => $Total || 1,
        Action      => 'Action=' . $LayoutObject->{Action},
        Link        => $LinkPage,
        AJAXReplace => 'Dashboard' . $Self->{Name},
        IDPrefix    => 'Dashboard' . $Self->{Name},
        AJAX        => $Param{AJAX},
    );

    $LayoutObject->Block(
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
        my $SwitchToCustomerGroupID = $GroupObject->GroupLookup(
            Group => $ConfigObject->Get('SwitchToCustomer::PermissionGroup'),
        );

        # get user groups, where the user has the rw privilege
        my %Groups = $GroupObject->PermissionUserGet(
            UserID => $Self->{UserID},
            Type   => 'rw',
        );

        # if the user is a member in this group he can access the feature
        if ( $Groups{$SwitchToCustomerGroupID} ) {

            $Self->{SwitchToCustomerPermission} = 1;

            $LayoutObject->Block(
                Name => 'OverviewResultSwitchToCustomer',
            );
        }
    }

    # Show add new customer button if:
    #   - The agent has permission to use the module
    #   - There are writable customer backends
    my $AddAccess;

    TYPE:
    for my $Permission (qw(ro rw)) {
        $AddAccess = $LayoutObject->Permission(
            Action => 'AdminCustomerUser',
            Type   => $Permission,
        );
        last TYPE if $AddAccess;
    }

    # Get writable data sources.
    my %CustomerSource = $CustomerUserObject->CustomerSourceList(
        ReadOnly => 0,
    );

    if ( $AddAccess && scalar keys %CustomerSource ) {
        $LayoutObject->Block(
            Name => 'ContentLargeCustomerUserAdd',
            Data => {
                CustomerID => $Self->{CustomerID},
            },
        );

        $Self->{EditCustomerPermission} = 1;
    }

    # get the permission for the phone ticket creation
    my $NewAgentTicketPhonePermission = $LayoutObject->Permission(
        Action => 'AgentTicketPhone',
        Type   => 'rw',
    );

    # check the permission for the phone ticket creation
    if ($NewAgentTicketPhonePermission) {
        $LayoutObject->Block(
            Name => 'OverviewResultNewAgentTicketPhone',
        );
    }

    # get the permission for the email ticket creation
    my $NewAgentTicketEmailPermission = $LayoutObject->Permission(
        Action => 'AgentTicketEmail',
        Type   => 'rw',
    );

    # check the permission for the email ticket creation
    if ($NewAgentTicketEmailPermission) {
        $LayoutObject->Block(
            Name => 'OverviewResultNewAgentTicketEmail',
        );
    }

    my @CustomerKeys = sort { lc( $CustomerIDs->{$a} ) cmp lc( $CustomerIDs->{$b} ) } keys %{$CustomerIDs};
    @CustomerKeys = splice @CustomerKeys, $Self->{StartHit} - 1, $Self->{PageShown};

    for my $CustomerKey (@CustomerKeys) {
        $LayoutObject->Block(
            Name => 'ContentLargeCustomerUserListRow',
            Data => {
                %Param,
                EditCustomerPermission => $Self->{EditCustomerPermission},
                CustomerKey            => $CustomerKey,
                CustomerListEntry      => $CustomerIDs->{$CustomerKey},
            },
        );

        if ( $ConfigObject->Get('ChatEngine::Active') ) {

            # Check if agent has permission to start chats with the customer users.
            my $EnableChat = 1;
            my $ChatStartingAgentsGroup
                = $ConfigObject->Get('ChatEngine::PermissionGroup::ChatStartingAgents') || 'users';
            my $ChatStartingAgentsGroupPermission = $Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
                UserID    => $Self->{UserID},
                GroupName => $ChatStartingAgentsGroup,
                Type      => 'rw',
            );

            if ( !$ChatStartingAgentsGroupPermission ) {
                $EnableChat = 0;
            }
            if (
                $EnableChat
                && !$ConfigObject->Get('ChatEngine::ChatDirection::AgentToCustomer')
                )
            {
                $EnableChat = 0;
            }

            if ($EnableChat) {
                my $VideoChatEnabled = 0;
                my $VideoChatAgentsGroup
                    = $ConfigObject->Get('ChatEngine::PermissionGroup::VideoChatAgents') || 'users';
                my $VideoChatAgentsGroupPermission = $Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
                    UserID    => $Self->{UserID},
                    GroupName => $VideoChatAgentsGroup,
                    Type      => 'rw',
                );

                # Enable the video chat feature if system is entitled and agent is a member of configured group.
                if ($VideoChatAgentsGroupPermission) {
                    if ( $Kernel::OM->Get('Kernel::System::Main')->Require( 'Kernel::System::VideoChat', Silent => 1 ) )
                    {
                        $VideoChatEnabled = $Kernel::OM->Get('Kernel::System::VideoChat')->IsEnabled();
                    }
                }

                my $CustomerEnableChat = 0;
                my $ChatAccess         = 0;
                my $VideoChatAvailable = 0;
                my $VideoChatSupport   = 0;

                # Default status is offline.
                my $UserState            = Translatable('Offline');
                my $UserStateDescription = $LayoutObject->{LanguageObject}->Translate('User is currently offline.');

                my $CustomerChatAvailability = $Kernel::OM->Get('Kernel::System::Chat')->CustomerAvailabilityGet(
                    UserID => $CustomerKey,
                );

                my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

                my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
                    User => $CustomerKey,
                );
                $CustomerUser{UserFullname} = $CustomerUserObject->CustomerName(
                    UserLogin => $CustomerKey,
                );
                $VideoChatSupport = 1 if $CustomerUser{VideoChatHasWebRTC};

                if ( $CustomerChatAvailability == 3 ) {
                    $UserState            = Translatable('Active');
                    $CustomerEnableChat   = 1;
                    $UserStateDescription = $LayoutObject->{LanguageObject}->Translate('User is currently active.');
                    $VideoChatAvailable   = 1;
                }
                elsif ( $CustomerChatAvailability == 2 ) {
                    $UserState          = Translatable('Away');
                    $CustomerEnableChat = 1;
                    $UserStateDescription
                        = $LayoutObject->{LanguageObject}->Translate('User was inactive for a while.');
                }

                $LayoutObject->Block(
                    Name => 'ContentLargeCustomerUserListRowUserStatus',
                    Data => {
                        %CustomerUser,
                        UserState            => $UserState,
                        UserStateDescription => $UserStateDescription,
                    },
                );

                if (
                    $CustomerEnableChat
                    && $ConfigObject->Get('Ticket::Agent::StartChatWOTicket')
                    )
                {
                    $LayoutObject->Block(
                        Name => 'ContentLargeCustomerUserListRowChatIcons',
                        Data => {
                            %CustomerUser,
                            VideoChatEnabled   => $VideoChatEnabled,
                            VideoChatAvailable => $VideoChatAvailable,
                            VideoChatSupport   => $VideoChatSupport,
                        },
                    );
                }
            }
        }

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my $TicketCountOpen = $TicketObject->TicketSearch(
            StateType            => 'Open',
            CustomerUserLoginRaw => $CustomerKey,
            Result               => 'COUNT',
            Permission           => $Self->{Config}->{Permission},
            UserID               => $Self->{UserID},
            CacheTTL             => $Self->{Config}->{CacheTTLLocal} * 60,
        ) || 0;

        my $CustomerKeySQL = $Kernel::OM->Get('Kernel::System::DB')->QueryStringEscape( QueryString => $CustomerKey );

        $LayoutObject->Block(
            Name => 'ContentLargeCustomerUserListRowCustomerUserTicketsOpen',
            Data => {
                %Param,
                Count          => $TicketCountOpen,
                CustomerKey    => $CustomerKey,
                CustomerKeySQL => $CustomerKeySQL,
            },
        );

        my $TicketCountClosed = $TicketObject->TicketSearch(
            StateType            => 'Closed',
            CustomerUserLoginRaw => $CustomerKey,
            Result               => 'COUNT',
            Permission           => $Self->{Config}->{Permission},
            UserID               => $Self->{UserID},
            CacheTTL             => $Self->{Config}->{CacheTTLLocal} * 60,
        ) || 0;

        $LayoutObject->Block(
            Name => 'ContentLargeCustomerUserListRowCustomerUserTicketsClosed',
            Data => {
                %Param,
                Count          => $TicketCountClosed,
                CustomerKey    => $CustomerKey,
                CustomerKeySQL => $CustomerKeySQL,
            },
        );

        # check the permission for the phone ticket creation
        if ($NewAgentTicketPhonePermission) {
            $LayoutObject->Block(
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
            $LayoutObject->Block(
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
            $LayoutObject->Block(
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
        $LayoutObject->Block(
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

        # send data to JS
        $LayoutObject->AddJSData(
            Key   => 'CustomerUserListRefresh',
            Value => {
                %{ $Self->{Config} },
                Name        => $Self->{Name},
                NameHTML    => $NameHTML,
                RefreshTime => $Refresh,
                CustomerID  => $Param{CustomerID},
            },
        );
    }

    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardCustomerUserList',
        Data         => {
            %{ $Self->{Config} },
            EditCustomerPermission => $Self->{EditCustomerPermission},
            Name                   => $Self->{Name},
        },
        AJAX => $Param{AJAX},
    );

    return $Content;
}

1;
