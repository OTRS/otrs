# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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
    my $Name = $ParamObject->GetParam( Param => 'Name' ) || '';
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

    my $SessionMaxIdleTime = $Kernel::OM->Get('Kernel::Config')->Get('SessionMaxIdleTime');

    # get config settings
    my $SortBy = $Self->{Config}->{SortBy} || 'UserFullname';

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # get current time-stamp
    my $Time = $TimeObject->SystemTime();

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

    # get database object
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

    # get session ids
    my @Sessions = $SessionObject->GetAllSessionIDs();

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

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
            $Data{UserFullname}
                ||= $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerName(
                UserLogin => $Data{UserLogin},
                );
        }

        # only show if not already shown
        next SESSIONID if $Online->{User}->{ $Data{UserType} }->{ $Data{UserID} };

        # check last request time / idle time out
        next SESSIONID if !$Data{UserLastRequest};
        next SESSIONID if $Data{UserLastRequest} + $SessionMaxIdleTime < $Time;

        # remember user and data
        $Online->{User}->{ $Data{UserType} }->{ $Data{UserID} } = $Data{$SortBy};
        $Online->{UserCount}->{ $Data{UserType} }++;
        $Online->{UserData}->{ $Data{UserType} }->{ $Data{UserID} } = { %Data, %AgentData };
    }

    # set css class
    my %Summary;
    $Summary{ $Self->{Filter} . '::Selected' } = 'Selected';

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # filter bar
    $LayoutObject->Block(
        Name => 'ContentSmallUserOnlineFilter',
        Data => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %{ $Online->{UserCount} },
            %Summary,
        },
    );

    # add page nav bar
    my $Total    = $Online->{UserCount}->{ $Self->{Filter} } || 0;
    my $LinkPage = 'Subaction=Element;Name=' . $Self->{Name} . ';Filter=' . $Self->{Filter} . ';';
    my %PageNav  = $LayoutObject->PageNavBar(
        StartHit       => $Self->{StartHit},
        PageShown      => $Self->{PageShown},
        AllHits        => $Total || 1,
        Action         => 'Action=' . $LayoutObject->{Action},
        Link           => $LinkPage,
        WindowSize     => 5,
        AJAXReplace    => 'Dashboard' . $Self->{Name},
        IDPrefix       => 'Dashboard' . $Self->{Name},
        KeepScriptTags => $Param{AJAX},
    );

    $LayoutObject->Block(
        Name => 'ContentSmallTicketGenericFilterNavBar',
        Data => {
            %{ $Self->{Config} },
            Name => $Self->{Name},
            %PageNav,
        },
    );

    # show agent/customer
    my %OnlineUser = %{ $Online->{User}->{ $Self->{Filter} } };
    my %OnlineData = %{ $Online->{UserData}->{ $Self->{Filter} } };
    my $Count      = 0;
    my $Limit      = $LayoutObject->{ $Self->{PrefKey} } || $Self->{Config}->{Limit};

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Check if agent has permission to start chats with the listed users
    my $EnableChat               = 1;
    my $ChatStartingAgentsGroup  = $ConfigObject->Get('ChatEngine::PermissionGroup::ChatStartingAgents') || 'users';
    my $ChatReceivingAgentsGroup = $ConfigObject->Get('ChatEngine::PermissionGroup::ChatReceivingAgents') || 'users';

    if (
        !$ConfigObject->Get('ChatEngine::Active')
        || !defined $LayoutObject->{"UserIsGroup[$ChatStartingAgentsGroup]"}
        || $LayoutObject->{"UserIsGroup[$ChatStartingAgentsGroup]"} ne 'Yes'
        )
    {
        $EnableChat = 0;
    }
    if (
        $EnableChat
        && $Self->{Filter} eq 'Agent'
        && !$ConfigObject->Get('ChatEngine::ChatDirection::AgentToAgent')
        )
    {
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

    my $VideoChatEnabled = 0;
    my $VideoChatAgentsGroup = $ConfigObject->Get('ChatEngine::PermissionGroup::VideoChatAgents') || 'users';

    # Enable the video chat feature if system is entitled and agent is a member of configured group.
    if (
        $ConfigObject->Get('ChatEngine::Active')
        && defined $LayoutObject->{"UserIsGroup[$VideoChatAgentsGroup]"}
        && $LayoutObject->{"UserIsGroup[$VideoChatAgentsGroup]"} eq 'Yes'
        )
    {
        if ( $Kernel::OM->Get('Kernel::System::Main')->Require( 'Kernel::System::VideoChat', Silent => 1 ) ) {
            $VideoChatEnabled = $Kernel::OM->Get('Kernel::System::VideoChat')->IsEnabled();
        }
    }

    USERID:
    for my $UserID ( sort { $OnlineUser{$a} cmp $OnlineUser{$b} } keys %OnlineUser ) {

        $Count++;

        next USERID if !$UserID;
        next USERID if $Count < $Self->{StartHit};
        last USERID if $Count >= ( $Self->{StartHit} + $Self->{PageShown} );

        # extract user data
        my $UserData           = $OnlineData{$UserID};
        my $AgentEnableChat    = 0;
        my $CustomerEnableChat = 0;
        my $ChatAccess         = 0;
        my $VideoChatAvailable = 0;
        my $VideoChatSupport   = 0;

        # Default status
        my $UserState            = Translatable('Offline');
        my $UserStateDescription = $LayoutObject->{LanguageObject}->Translate('User is currently offline.');

        # we also need to check if the receiving agent has chat permissions
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

            # Check agents availability
            if ($ChatAccess) {
                my $AgentChatAvailability = $Kernel::OM->Get('Kernel::System::Chat')->AgentAvailabilityGet(
                    UserID   => $UserID,
                    External => 0,
                );

                if ( $AgentChatAvailability == 3 ) {
                    $UserState            = Translatable('Active');
                    $AgentEnableChat      = 1;
                    $UserStateDescription = $LayoutObject->{LanguageObject}->Translate('User is currently active.');
                    $VideoChatAvailable   = 1;
                }
                elsif ( $AgentChatAvailability == 2 ) {
                    $UserState       = Translatable('Away');
                    $AgentEnableChat = 1;
                    $UserStateDescription
                        = $LayoutObject->{LanguageObject}->Translate('User was inactive for a while.');
                }
                elsif ( $AgentChatAvailability == 1 ) {
                    $UserState = Translatable('Unavailable');
                    $UserStateDescription
                        = $LayoutObject->{LanguageObject}->Translate('User set their status to unavailable.');
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
                $UserStateDescription = $LayoutObject->{LanguageObject}->Translate('User is currently active.');
                $VideoChatAvailable   = 1;
            }
            elsif ( $CustomerChatAvailability == 2 ) {
                $UserState            = Translatable('Away');
                $CustomerEnableChat   = 1;
                $UserStateDescription = $LayoutObject->{LanguageObject}->Translate('User was inactive for a while.');
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

        my $Start = sprintf(
            "%04d-%02d-%02d 00:00:00",
            $UserData->{OutOfOfficeStartYear}, $UserData->{OutOfOfficeStartMonth},
            $UserData->{OutOfOfficeStartDay}
        );
        my $TimeStart = $TimeObject->TimeStamp2SystemTime(
            String => $Start,
        );
        my $End = sprintf(
            "%04d-%02d-%02d 23:59:59",
            $UserData->{OutOfOfficeEndYear}, $UserData->{OutOfOfficeEndMonth},
            $UserData->{OutOfOfficeEndDay}
        );
        my $TimeEnd = $TimeObject->TimeStamp2SystemTime(
            String => $End,
        );

        next USERID if $TimeStart > $Time || $TimeEnd < $Time;

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
        KeepScriptTags => $Param{AJAX},
    );

    return $Content;
}

1;
