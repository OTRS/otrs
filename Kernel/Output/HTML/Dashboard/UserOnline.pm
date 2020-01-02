# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Dashboard::UserOnline;

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
    my $PreferencesKey = 'UserDashboardUserOnlineFilter' . $Self->{Name};
    if ( $Self->{Name} eq $Name ) {
        $Self->{Filter} = $ParamObject->GetParam( Param => 'Filter' ) || '';
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # remember filter
    if ( $Self->{Filter} ) {

        # update session
        $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => $PreferencesKey,
            Value     => $Self->{Filter},
        );

        # update preferences
        if ( !$ConfigObject->Get('DemoSystem') ) {
            $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
                UserID => $Self->{UserID},
                Key    => $PreferencesKey,
                Value  => $Self->{Filter},
            );
        }
    }

    if ( !$Self->{Filter} ) {
        $Self->{Filter} = $Self->{$PreferencesKey} || $Self->{Config}->{Filter} || 'Agent';
    }

    $Self->{PrefKey} = 'UserDashboardPref' . $Self->{Name} . '-Shown';

    $Self->{PageShown} = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{ $Self->{PrefKey} }
        || $Self->{Config}->{Limit} || 10;

    $Self->{StartHit} = int( $ParamObject->GetParam( Param => 'StartHit' ) || 1 );

    $Self->{CacheKey} = $Self->{Name} . '::' . $Self->{Filter};

    # get configuration for the full name order for user names
    # and append it to the cache key to make sure, that the
    # correct data will be displayed every time
    my $FirstnameLastNameOrder = $ConfigObject->Get('FirstnameLastnameOrder') || 0;
    $Self->{CacheKey} .= '::' . $FirstnameLastNameOrder;

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    my @Params = (
        {
            Desc  => Translatable('Shown'),
            Name  => $Self->{PrefKey},
            Block => 'Option',
            Data  => {
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

        CanRefresh => 1,

        # remember, do not allow to use page cache
        # (it's not working because of internal filter)
        CacheKey => undef,
        CacheTTL => undef,
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
    my $UserObject    = $Kernel::OM->Get('Kernel::System::User');

    # Get the session max idle time in seconds.
    my $SessionMaxIdleTime = $ConfigObject->Get('SessionMaxIdleTime') || 0;

    my $SortBy = $Self->{Config}->{SortBy} || 'UserFullname';

    my $Online = {
        User => {
            Agent    => {},
            Customer => {},
        },
        UserCount => {
            Agent    => 0,
            Customer => 0,
        },
        UserData => {
            Agent    => {},
            Customer => {},
        },
    };

    # Get all session ids, to generate the logged-in user list.
    my @Sessions = $SessionObject->GetAllSessionIDs();

    my $CurSystemDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $SystemTime              = $CurSystemDateTimeObject->ToEpoch();

    SESSIONID:
    for my $SessionID (@Sessions) {

        next SESSIONID if !$SessionID;

        # get session data
        my %Data = $SessionObject->GetSessionIDData( SessionID => $SessionID );

        next SESSIONID if !%Data;
        next SESSIONID if !$Data{UserID};

        # use agent instead of user
        my %AgentData;
        if ( $Data{UserType} eq 'User' ) {
            $Data{UserType} = 'Agent';

            # get user data
            %AgentData = $UserObject->GetUserData(
                UserID        => $Data{UserID},
                NoOutOfOffice => 1,
            );
        }
        else {
            $Data{UserFullname} ||= $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerName(
                UserLogin => $Data{UserLogin},
            );
        }

        # Skip session, if no last request exists.
        next SESSIONID if !$Data{UserLastRequest};

        # Check the last request / idle time, only if the user is not already shown.
        if ( !$Online->{User}->{ $Data{UserType} }->{ $Data{UserID} } ) {
            next SESSIONID if $Data{UserLastRequest} + $SessionMaxIdleTime < $SystemTime;

            # Count only unique agents and customers, please see bug#13429 for more information.
            $Online->{UserCount}->{ $Data{UserType} }++;
        }

        # Remember the user data, if the user not already exists in the online list or the last request time is newer.
        if (
            !$Online->{User}->{ $Data{UserType} }->{ $Data{UserID} }
            || $Online->{UserData}->{ $Data{UserType} }->{ $Data{UserID} }->{UserLastRequest} < $Data{UserLastRequest}
            )
        {
            $Online->{User}->{ $Data{UserType} }->{ $Data{UserID} }     = $Data{$SortBy};
            $Online->{UserData}->{ $Data{UserType} }->{ $Data{UserID} } = { %Data, %AgentData };
        }
    }

    # Set the selected css class for the current filter ('Agents' or 'Customers').
    my %Summary;
    $Summary{ $Self->{Filter} . '::Selected' } = 'Selected';

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Generate the output block for the filter bar.
    $LayoutObject->Block(
        Name => 'ContentSmallUserOnlineFilter',
        Data => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %{ $Online->{UserCount} },
            %Summary,
        },
    );

    # Add the page nav bar block to the output.
    my $Total    = $Online->{UserCount}->{ $Self->{Filter} } || 0;
    my $LinkPage = 'Subaction=Element;Name=' . $Self->{Name} . ';Filter=' . $Self->{Filter} . ';';
    my %PageNav  = $LayoutObject->PageNavBar(
        StartHit    => $Self->{StartHit},
        PageShown   => $Self->{PageShown},
        AllHits     => $Total || 1,
        Action      => 'Action=' . $LayoutObject->{Action},
        Link        => $LinkPage,
        WindowSize  => 5,
        AJAXReplace => 'Dashboard' . $Self->{Name},
        IDPrefix    => 'Dashboard' . $Self->{Name},
        AJAX        => $Param{AJAX},
    );

    $LayoutObject->Block(
        Name => 'ContentSmallTicketGenericFilterNavBar',
        Data => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %PageNav,
        },
    );

    # Show agent and ustomer user in the widget.
    my %OnlineUser = %{ $Online->{User}->{ $Self->{Filter} } };
    my %OnlineData = %{ $Online->{UserData}->{ $Self->{Filter} } };
    my $Count      = 0;
    my $Limit      = $LayoutObject->{ $Self->{PrefKey} } || $Self->{Config}->{Limit};

    # Check if agent has permission to start chats with the listed users
    my $EnableChat               = 1;
    my $ChatStartingAgentsGroup  = $ConfigObject->Get('ChatEngine::PermissionGroup::ChatStartingAgents') || 'users';
    my $ChatReceivingAgentsGroup = $ConfigObject->Get('ChatEngine::PermissionGroup::ChatReceivingAgents') || 'users';

    my $ChatStartingAgentsGroupPermission = $Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
        UserID    => $Self->{UserID},
        GroupName => $ChatStartingAgentsGroup,
        Type      => 'rw',
    );

    if ( !$ConfigObject->Get('ChatEngine::Active') || !$ChatStartingAgentsGroupPermission ) {
        $EnableChat = 0;
    }
    if ( $EnableChat && $Self->{Filter} eq 'Agent' && !$ConfigObject->Get('ChatEngine::ChatDirection::AgentToAgent') ) {
        $EnableChat = 0;
    }
    if (
        $EnableChat
        && $Self->{Filter} eq 'Customer'
        && !$ConfigObject->Get('ChatEngine::ChatDirection::AgentToCustomer')
        )
    {
        $EnableChat = 0;
    }

    my $VideoChatEnabled               = 0;
    my $VideoChatAgentsGroup           = $ConfigObject->Get('ChatEngine::PermissionGroup::VideoChatAgents') || 'users';
    my $VideoChatAgentsGroupPermission = $Kernel::OM->Get('Kernel::System::Group')->PermissionCheck(
        UserID    => $Self->{UserID},
        GroupName => $VideoChatAgentsGroup,
        Type      => 'rw',
    );

    # Enable the video chat feature if system is entitled and agent is a member of configured group.
    if ( $ConfigObject->Get('ChatEngine::Active') && $VideoChatAgentsGroupPermission ) {
        if ( $Kernel::OM->Get('Kernel::System::Main')->Require( 'Kernel::System::VideoChat', Silent => 1 ) ) {
            $VideoChatEnabled = $Kernel::OM->Get('Kernel::System::VideoChat')->IsEnabled();
        }
    }

    # Online thresholds for agents and customers (default 5 min).
    my $OnlineThreshold = (
        $Self->{Filter} eq 'Agent'
        ? $Kernel::OM->Get('Kernel::Config')->Get('SessionAgentOnlineThreshold')
        : $Kernel::OM->Get('Kernel::Config')->Get('SessionCustomerOnlineThreshold')
        )
        || 5;

    # Translate the diffrent user state descriptions.
    my $UserOfflineDescription = $LayoutObject->{LanguageObject}->Translate('User is currently offline.');
    my $UserActiveDescription  = $LayoutObject->{LanguageObject}->Translate('User is currently active.');
    my $UserAwayDescription    = $LayoutObject->{LanguageObject}->Translate('User was inactive for a while.');
    my $UserUnavailableDescription
        = $LayoutObject->{LanguageObject}->Translate('User set their status to unavailable.');

    USERID:
    for my $UserID ( sort { $OnlineUser{$a} cmp $OnlineUser{$b} } keys %OnlineUser ) {

        $Count++;

        next USERID if !$UserID;
        next USERID if $Count < $Self->{StartHit};
        last USERID if $Count >= ( $Self->{StartHit} + $Self->{PageShown} );

        my $UserData           = $OnlineData{$UserID};
        my $AgentEnableChat    = 0;
        my $CustomerEnableChat = 0;
        my $ChatAccess         = 0;
        my $VideoChatAvailable = 0;
        my $VideoChatSupport   = 0;

        # Set Default status to active, because a offline user is not visible in the list.
        my $UserState            = Translatable('Active');
        my $UserStateDescription = $UserActiveDescription;

        # We also need to check if the receiving agent has chat permissions.
        if ( $EnableChat && $Self->{Filter} eq 'Agent' ) {

            my %UserGroups = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
                UserID => $UserData->{UserID},
                Type   => 'rw',
            );

            my %UserGroupsReverse = reverse %UserGroups;
            $ChatAccess = $UserGroupsReverse{$ChatReceivingAgentsGroup} ? 1 : 0;

            my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                UserID => $UserID,
            );
            $VideoChatSupport = $User{VideoChatHasWebRTC};

            # Check agents availability.
            if ($ChatAccess) {
                my $AgentChatAvailability = $Kernel::OM->Get('Kernel::System::Chat')->AgentAvailabilityGet(
                    UserID   => $UserID,
                    External => 0,
                );

                if ( $AgentChatAvailability == 3 ) {
                    $UserState            = Translatable('Active');
                    $AgentEnableChat      = 1;
                    $UserStateDescription = $UserActiveDescription;
                    $VideoChatAvailable   = 1;
                }
                elsif ( $AgentChatAvailability == 2 ) {
                    $UserState            = Translatable('Away');
                    $AgentEnableChat      = 1;
                    $UserStateDescription = $UserAwayDescription;
                }
                elsif ( $AgentChatAvailability == 1 ) {
                    $UserState            = Translatable('Unavailable');
                    $UserStateDescription = $UserUnavailableDescription;
                }
            }
        }
        elsif ($EnableChat) {
            $ChatAccess = 1;

            my $CustomerChatAvailability = $Kernel::OM->Get('Kernel::System::Chat')->CustomerAvailabilityGet(
                UserID => $UserData->{UserID},
            );

            my %CustomerUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
                User => $UserID,
            );
            $VideoChatSupport = 1 if $CustomerUser{VideoChatHasWebRTC};

            if ( $CustomerChatAvailability == 3 ) {
                $UserState            = Translatable('Active');
                $CustomerEnableChat   = 1;
                $UserStateDescription = $UserActiveDescription;
                $VideoChatAvailable   = 1;
            }
            elsif ( $CustomerChatAvailability == 2 ) {
                $UserState            = Translatable('Away');
                $CustomerEnableChat   = 1;
                $UserStateDescription = $UserAwayDescription;
            }
        }
        else {
            if ( $UserData->{UserLastRequest} + ( 60 * $OnlineThreshold ) < $SystemTime ) {
                $UserState            = Translatable('Away');
                $UserStateDescription = $UserAwayDescription;
            }
        }

        $LayoutObject->Block(
            Name => 'ContentSmallUserOnlineRow',
            Data => {
                %{$UserData},
                ChatAccess           => $ChatAccess,
                AgentEnableChat      => $AgentEnableChat,
                CustomerEnableChat   => $CustomerEnableChat,
                UserState            => $UserState,
                UserStateDescription => $UserStateDescription,
                VideoChatEnabled     => $VideoChatEnabled,
                VideoChatAvailable   => $VideoChatAvailable,
                VideoChatSupport     => $VideoChatSupport,
            },
        );

        if ( $Self->{Config}->{ShowEmail} ) {
            $LayoutObject->Block(
                Name => 'ContentSmallUserOnlineRowEmail',
                Data => $UserData,
            );
        }

        next USERID if !$UserData->{OutOfOffice};

        my $CreateOutOfOfficeDTObject = sub {
            my $Type = shift;

            my $DTString = sprintf(
                '%04d-%02d-%02d ' . ( $Type eq 'End' ? '23:59:59' : '00:00:00' ),
                $UserData->{"OutOfOffice${Type}Year"},
                $UserData->{"OutOfOffice${Type}Month"},
                $UserData->{"OutOfOffice${Type}Day"}
            );

            return $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $DTString,
                },
            );
        };

        my $OOOStartDTObject = $CreateOutOfOfficeDTObject->('Start');
        my $OOOEndDTObject   = $CreateOutOfOfficeDTObject->('End');

        next USERID if $OOOStartDTObject > $CurSystemDateTimeObject || $OOOEndDTObject < $CurSystemDateTimeObject;

        $LayoutObject->Block(
            Name => 'ContentSmallUserOnlineRowOutOfOffice',
        );
    }

    if ( !%OnlineUser ) {
        $LayoutObject->Block(
            Name => 'ContentSmallUserOnlineNone',
        );
    }

    # check for refresh time
    my $Refresh  = 30;              # 30 seconds
    my $NameHTML = $Self->{Name};
    $NameHTML =~ s{-}{_}xmsg;

    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardUserOnline',
        Data         => {
            %{ $Self->{Config} },
            Name        => $Self->{Name},
            NameHTML    => $NameHTML,
            RefreshTime => $Refresh,
        },
        AJAX => $Param{AJAX},
    );

    # send data to JS
    $LayoutObject->AddJSData(
        Key   => 'UserOnline',
        Value => {
            Name        => $Self->{Name},
            NameHTML    => $NameHTML,
            RefreshTime => $Refresh,
        },
    );

    return $Content;
}

1;
