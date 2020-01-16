# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Event::NotificationEvent;

use strict;
use warnings;

use List::Util qw(first);
use Mail::Address;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerUser',
    'Kernel::System::CheckItem',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Email',
    'Kernel::System::Group',
    'Kernel::System::HTMLUtils',
    'Kernel::System::JSON',
    'Kernel::System::Log',
    'Kernel::System::NotificationEvent',
    'Kernel::System::Queue',
    'Kernel::System::SystemAddress',
    'Kernel::System::TemplateGenerator',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::DateTime',
    'Kernel::System::User',
    'Kernel::System::CheckItem',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Event Data Config UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( !$Param{Data}->{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TicketID in Data!',
        );
        return;
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # Loop protection: prevent from running if ArticleSend has already triggered for certain ticket.
    if ( $Param{Event} eq 'ArticleSend' ) {
        return if $TicketObject->{'_NotificationEvent::ArticleSend'}->{ $Param{Data}->{TicketID} }++;
    }

    # return if no notification is active
    return 1 if $TicketObject->{SendNoNotification};

    # return if no ticket exists (e. g. it got deleted)
    my $TicketExists = $TicketObject->TicketNumberLookup(
        TicketID => $Param{Data}->{TicketID},
        UserID   => $Param{UserID},
    );

    return 1 if !$TicketExists;

    # get notification event object
    my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');

    # check if event is affected
    my @IDs = $NotificationEventObject->NotificationEventCheck(
        Event => $Param{Event},
    );

    # return if no notification for event exists
    return 1 if !@IDs;

    # get ticket attribute matches
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        UserID        => $Param{UserID},
        DynamicFields => 1,
    );

    # get dynamic field objects
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    # get dynamic fields
    my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    # create a dynamic field config lookup table
    my %DynamicFieldConfigLookup;
    for my $DynamicFieldConfig ( @{$DynamicFieldList} ) {
        $DynamicFieldConfigLookup{ $DynamicFieldConfig->{Name} } = $DynamicFieldConfig;
    }

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    NOTIFICATION:
    for my $ID (@IDs) {

        my %Notification = $NotificationEventObject->NotificationGet(
            ID => $ID,
        );

        # verify ticket and article conditions
        my $PassFilter = $Self->_NotificationFilter(
            %Param,
            Ticket                   => \%Ticket,
            Notification             => \%Notification,
            DynamicFieldConfigLookup => \%DynamicFieldConfigLookup,
        );
        next NOTIFICATION if !$PassFilter;

        # add attachments only on ArticleCreate or ArticleSend event
        my @Attachments;
        if (
            ( ( $Param{Event} eq 'ArticleCreate' ) || ( $Param{Event} eq 'ArticleSend' ) )
            && $Param{Data}->{ArticleID}
            )
        {

            # add attachments to notification
            if ( $Notification{Data}->{ArticleAttachmentInclude}->[0] ) {

                my $BackendObject = $ArticleObject->BackendForArticle(
                    TicketID  => $Param{Data}->{TicketID},
                    ArticleID => $Param{Data}->{ArticleID},
                );

                my %Index = $BackendObject->ArticleAttachmentIndex(
                    ArticleID        => $Param{Data}->{ArticleID},
                    ExcludePlainText => 1,
                    ExcludeHTMLBody  => 1,
                );
                if (%Index) {
                    FILE_ID:
                    for my $FileID ( sort keys %Index ) {
                        my %Attachment = $BackendObject->ArticleAttachment(
                            ArticleID => $Param{Data}->{ArticleID},
                            FileID    => $FileID,
                        );
                        next FILE_ID if !%Attachment;
                        push @Attachments, \%Attachment;
                    }
                }
            }
        }

        # get recipients
        my @RecipientUsers = $Self->_RecipientsGet(
            %Param,
            Ticket       => \%Ticket,
            Notification => \%Notification,
        );

        my @NotificationBundle;

        # get template generator object
        my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

        # parse all notification tags for each user
        for my $Recipient (@RecipientUsers) {

            my %ReplacedNotification = $TemplateGeneratorObject->NotificationEvent(
                TicketData            => \%Ticket,
                Recipient             => $Recipient,
                Notification          => \%Notification,
                CustomerMessageParams => $Param{Data}->{CustomerMessageParams},
                UserID                => $Param{UserID},
            );

            my $UserNotificationTransport = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
                Data => $Recipient->{NotificationTransport},
            );

            push @NotificationBundle, {
                Recipient                      => $Recipient,
                Notification                   => \%ReplacedNotification,
                RecipientNotificationTransport => $UserNotificationTransport,
            };
        }

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # get notification transport config
        my %TransportConfig = %{ $ConfigObject->Get('Notification::Transport') || {} };

        # remember already sent agent notifications
        my %AlreadySent;

        # loop over transports for each notification
        TRANSPORT:
        for my $Transport ( sort keys %TransportConfig ) {

            # only configured transports for this notification
            if ( !grep { $_ eq $Transport } @{ $Notification{Data}->{Transports} } ) {
                next TRANSPORT;
            }

            next TRANSPORT if !IsHashRefWithData( $TransportConfig{$Transport} );
            next TRANSPORT if !$TransportConfig{$Transport}->{Module};

            # get transport object
            my $TransportObject;
            eval {
                $TransportObject = $Kernel::OM->Get( $TransportConfig{$Transport}->{Module} );
            };

            if ( !$TransportObject ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Could not create a new $TransportConfig{$Transport}->{Module} object!",
                );

                next TRANSPORT;
            }

            if ( ref $TransportObject ne $TransportConfig{$Transport}->{Module} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "$TransportConfig{$Transport}->{Module} object is invalid",
                );

                next TRANSPORT;
            }

            # check if transport is usable
            next TRANSPORT if !$TransportObject->IsUsable();

            BUNDLE:
            for my $Bundle (@NotificationBundle) {

                my $UserPreference = "Notification-$Notification{ID}-$Transport";

                # check if agent should get the notification
                my $AgentSendNotification = 0;
                if ( defined $Bundle->{RecipientNotificationTransport}->{$UserPreference} ) {
                    $AgentSendNotification = $Bundle->{RecipientNotificationTransport}->{$UserPreference};
                }
                elsif ( grep { $_ eq $Transport } @{ $Notification{Data}->{AgentEnabledByDefault} } ) {
                    $AgentSendNotification = 1;
                }
                elsif (
                    !IsArrayRefWithData( $Notification{Data}->{VisibleForAgent} )
                    || (
                        defined $Notification{Data}->{VisibleForAgent}->[0]
                        && !$Notification{Data}->{VisibleForAgent}->[0]
                    )
                    )
                {
                    $AgentSendNotification = 1;
                }

                # skip sending the notification if the agent has disable it in its preferences
                if (
                    IsArrayRefWithData( $Notification{Data}->{VisibleForAgent} )
                    && $Notification{Data}->{VisibleForAgent}->[0]
                    && $Bundle->{Recipient}->{Type} eq 'Agent'
                    && !$AgentSendNotification
                    )
                {
                    next BUNDLE;
                }

                # Check if notification should not send to the customer.
                if (
                    $Bundle->{Recipient}->{Type} eq 'Customer'
                    && $ConfigObject->Get('CustomerNotifyJustToRealCustomer')
                    )
                {

                    # No UserID means it's not a mapped customer.
                    next BUNDLE if !$Bundle->{Recipient}->{UserID};
                }

                my $Success = $Self->_SendRecipientNotification(
                    TicketID              => $Param{Data}->{TicketID},
                    Notification          => $Bundle->{Notification},
                    CustomerMessageParams => $Param{Data}->{CustomerMessageParams} || {},
                    Recipient             => $Bundle->{Recipient},
                    Event                 => $Param{Event},
                    Attachments           => \@Attachments,
                    Transport             => $Transport,
                    TransportObject       => $TransportObject,
                    UserID                => $Param{UserID},
                );

                # remember to have sent
                if ( $Bundle->{Recipient}->{UserID} ) {
                    $AlreadySent{ $Bundle->{Recipient}->{UserID} } = 1;
                }
            }

            # get special recipients specific for each transport
            my @TransportRecipients = $TransportObject->GetTransportRecipients(
                Notification => \%Notification,
                Ticket       => \%Ticket,
            );

            next TRANSPORT if !@TransportRecipients;

            RECIPIENT:
            for my $Recipient (@TransportRecipients) {

                # replace all notification tags for each special recipient
                my %ReplacedNotification = $TemplateGeneratorObject->NotificationEvent(
                    TicketData            => \%Ticket,
                    Recipient             => $Recipient,
                    Notification          => \%Notification,
                    CustomerMessageParams => $Param{Data}->{CustomerMessageParams} || {},
                    UserID                => $Param{UserID},
                );

                my $Success = $Self->_SendRecipientNotification(
                    TicketID              => $Param{Data}->{TicketID},
                    Notification          => \%ReplacedNotification,
                    CustomerMessageParams => $Param{Data}->{CustomerMessageParams} || {},
                    Recipient             => $Recipient,
                    Event                 => $Param{Event},
                    Attachments           => \@Attachments,
                    Transport             => $Transport,
                    TransportObject       => $TransportObject,
                    UserID                => $Param{UserID},
                );
            }
        }
    }

    return 1;
}

sub _NotificationFilter {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(Ticket Notification DynamicFieldConfigLookup)) {
        return if !$Param{$Needed};
    }

    # set local values
    my %Notification = %{ $Param{Notification} };

    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # get the search article fields to retrieve values for
    my %ArticleSearchableFields = $ArticleObject->ArticleSearchableFieldsList();

    KEY:
    for my $Key ( sort keys %{ $Notification{Data} } ) {

        # TODO: This function here should be fixed to not use hardcoded attribute values!
        # ignore not ticket related attributes
        next KEY if $Key eq 'Recipients';
        next KEY if $Key eq 'SkipRecipients';
        next KEY if $Key eq 'RecipientAgents';
        next KEY if $Key eq 'RecipientGroups';
        next KEY if $Key eq 'RecipientRoles';
        next KEY if $Key eq 'TransportEmailTemplate';
        next KEY if $Key eq 'Events';
        next KEY if $Key eq 'ArticleSenderTypeID';
        next KEY if $Key eq 'ArticleIsVisibleForCustomer';
        next KEY if $Key eq 'ArticleCommunicationChannelID';
        next KEY if $Key eq 'ArticleAttachmentInclude';
        next KEY if $Key eq 'IsVisibleForCustomer';
        next KEY if $Key eq 'Transports';
        next KEY if $Key eq 'OncePerDay';
        next KEY if $Key eq 'VisibleForAgent';
        next KEY if $Key eq 'VisibleForAgentTooltip';
        next KEY if $Key eq 'LanguageID';
        next KEY if $Key eq 'SendOnOutOfOffice';
        next KEY if $Key eq 'AgentEnabledByDefault';
        next KEY if $Key eq 'EmailSecuritySettings';
        next KEY if $Key eq 'EmailSigningCrypting';
        next KEY if $Key eq 'EmailMissingCryptingKeys';
        next KEY if $Key eq 'EmailMissingSigningKeys';
        next KEY if $Key eq 'EmailDefaultSigningKeys';
        next KEY if $Key eq 'NotificationType';

        # ignore article searchable fields
        next KEY if $ArticleSearchableFields{$Key};

        # skip transport related attributes
        if ( $Key =~ m{ \A ( Recipient | Transport ) }xms ) {
            next KEY;
        }

        # check ticket attributes
        next KEY if !defined $Notification{Data}->{$Key};
        next KEY if !defined $Notification{Data}->{$Key}->[0];
        next KEY if !@{ $Notification{Data}->{$Key} };
        my $Match = 0;

        VALUE:
        for my $Value ( @{ $Notification{Data}->{$Key} } ) {

            next VALUE if !defined $Value;

            # check if key is a search dynamic field
            if ( $Key =~ m{\A Search_DynamicField_}xms ) {

                # remove search prefix
                my $DynamicFieldName = $Key;

                $DynamicFieldName =~ s{Search_DynamicField_}{};

                # get the dynamic field config for this field
                my $DynamicFieldConfig = $Param{DynamicFieldConfigLookup}->{$DynamicFieldName};

                next VALUE if !$DynamicFieldConfig;

                my $IsNotificationEventCondition = $DynamicFieldBackendObject->HasBehavior(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Behavior           => 'IsNotificationEventCondition',
                );

                next VALUE if !$IsNotificationEventCondition;

                # Get match value from the dynamic field backend, if applicable (bug#12257).
                my $MatchValue;
                my $SearchFieldParameter = $DynamicFieldBackendObject->SearchFieldParameterBuild(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Profile            => {
                        $Key => $Value,
                    },
                );
                if ( defined $SearchFieldParameter->{Parameter}->{Equals} ) {
                    $MatchValue = $SearchFieldParameter->{Parameter}->{Equals};
                }
                else {
                    $MatchValue = $Value;
                }

                $Match = $DynamicFieldBackendObject->ObjectMatch(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Value              => $MatchValue,
                    ObjectAttributes   => $Param{Ticket},
                );

                last VALUE if $Match;
            }
            else {

                if (
                    $Param{Ticket}->{$Key}
                    && $Value eq $Param{Ticket}->{$Key}
                    )
                {
                    $Match = 1;
                    last VALUE;
                }
            }
        }

        return if !$Match;
    }

    # match article types only on ArticleCreate or ArticleSend event
    if (
        ( ( $Param{Event} eq 'ArticleCreate' ) || ( $Param{Event} eq 'ArticleSend' ) )
        && $Param{Data}->{ArticleID}
        )
    {
        my $BackendObject = $ArticleObject->BackendForArticle(
            TicketID  => $Param{Data}->{TicketID},
            ArticleID => $Param{Data}->{ArticleID},
        );

        my %Article = $BackendObject->ArticleGet(
            TicketID      => $Param{Data}->{TicketID},
            ArticleID     => $Param{Data}->{ArticleID},
            DynamicFields => 0,
        );

        # Check for active article filters:
        #   - SenderTypeID
        #   - IsVisibleForCustomer
        #   - CommunicationChannelID
        ARTICLE_FILTER:
        for my $ArticleFilter (qw(ArticleSenderTypeID ArticleIsVisibleForCustomer ArticleCommunicationChannelID)) {
            next ARTICLE_FILTER if !$Notification{Data}->{$ArticleFilter};

            my $Match = 0;
            VALUE:
            for my $Value ( @{ $Notification{Data}->{$ArticleFilter} } ) {
                next VALUE if !defined $Value;

                my $ArticleField = $ArticleFilter;
                $ArticleField =~ s/^Article//;

                if ( $Value == $Article{$ArticleField} ) {
                    $Match = 1;
                    last VALUE;
                }
            }

            return if !$Match;
        }

        my %ArticleData = $BackendObject->ArticleSearchableContentGet(
            TicketID  => $Param{Data}->{TicketID},
            ArticleID => $Param{Data}->{ArticleID},
            UserID    => $Param{UserID},
        );

        # check article backend fields
        KEY:
        for my $Key ( sort keys %ArticleSearchableFields ) {

            next KEY if !$Notification{Data}->{$Key};

            my $Match = 0;
            VALUE:
            for my $Value ( @{ $Notification{Data}->{$Key} } ) {

                next VALUE if !$Value;

                if ( $ArticleData{$Key}->{String} =~ /\Q$Value\E/i ) {
                    $Match = 1;
                    last VALUE;
                }
            }

            return if !$Match;
        }
    }

    return 1;

}

sub _RecipientsGet {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(Ticket Notification)) {
        return if !$Param{$Needed};
    }

    # set local values
    my %Notification = %{ $Param{Notification} };
    my %Ticket       = %{ $Param{Ticket} };

    # get needed objects
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my @RecipientUserIDs;
    my @RecipientUsers;
    my @RecipientUserEmails;

    # add pre-calculated recipient
    if ( IsArrayRefWithData( $Param{Data}->{Recipients} ) ) {
        push @RecipientUserIDs, @{ $Param{Data}->{Recipients} };
    }

    # remember pre-calculated user recipients for later comparisons
    my %PrecalculatedUserIDs = map { $_ => 1 } @RecipientUserIDs;

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # get recipients by Recipients
    if ( $Notification{Data}->{Recipients} ) {

        # get needed objects
        my $QueueObject         = $Kernel::OM->Get('Kernel::System::Queue');
        my $CustomerUserObject  = $Kernel::OM->Get('Kernel::System::CustomerUser');
        my $CheckItemObject     = $Kernel::OM->Get('Kernel::System::CheckItem');
        my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');
        my $UserObject          = $Kernel::OM->Get('Kernel::System::User');

        RECIPIENT:
        for my $Recipient ( @{ $Notification{Data}->{Recipients} } ) {

            if (
                $Recipient
                =~ /^Agent(Owner|Responsible|Watcher|WritePermissions|MyQueues|MyServices|MyQueuesMyServices|CreateBy)$/
                )
            {
                if ( $Recipient eq 'AgentOwner' ) {
                    push @{ $Notification{Data}->{RecipientAgents} }, $Ticket{OwnerID};
                }
                elsif ( $Recipient eq 'AgentResponsible' ) {

                    # add the responsible agent to the notification list
                    if ( $ConfigObject->Get('Ticket::Responsible') && $Ticket{ResponsibleID} ) {

                        push @{ $Notification{Data}->{RecipientAgents} },
                            $Ticket{ResponsibleID};
                    }
                }
                elsif ( $Recipient eq 'AgentWatcher' ) {

                    # is not needed to check Ticket::Watcher,
                    # its checked on TicketWatchGet function
                    push @{ $Notification{Data}->{RecipientAgents} }, $TicketObject->TicketWatchGet(
                        TicketID => $Param{Data}->{TicketID},
                        Result   => 'ARRAY',
                    );
                }
                elsif ( $Recipient eq 'AgentWritePermissions' ) {

                    my $GroupID = $QueueObject->GetQueueGroupID(
                        QueueID => $Ticket{QueueID},
                    );

                    my %UserList = $GroupObject->PermissionGroupUserGet(
                        GroupID => $GroupID,
                        Type    => 'rw',
                        UserID  => $Param{UserID},
                    );

                    my %RoleList = $GroupObject->PermissionGroupRoleGet(
                        GroupID => $GroupID,
                        Type    => 'rw',
                    );
                    for my $RoleID ( sort keys %RoleList ) {
                        my %RoleUserList = $GroupObject->PermissionRoleUserGet(
                            RoleID => $RoleID,
                        );
                        %UserList = ( %RoleUserList, %UserList );
                    }

                    my @UserIDs = sort keys %UserList;

                    push @{ $Notification{Data}->{RecipientAgents} }, @UserIDs;
                }
                elsif ( $Recipient eq 'AgentMyQueues' ) {

                    # get subscribed users
                    my %MyQueuesUserIDs = map { $_ => 1 } $TicketObject->GetSubscribedUserIDsByQueueID(
                        QueueID => $Ticket{QueueID}
                    );

                    my @UserIDs = sort keys %MyQueuesUserIDs;

                    push @{ $Notification{Data}->{RecipientAgents} }, @UserIDs;
                }
                elsif ( $Recipient eq 'AgentMyServices' ) {

                    # get subscribed users
                    my %MyServicesUserIDs;
                    if ( $Ticket{ServiceID} ) {
                        %MyServicesUserIDs = map { $_ => 1 } $TicketObject->GetSubscribedUserIDsByServiceID(
                            ServiceID => $Ticket{ServiceID},
                        );
                    }

                    my @UserIDs = sort keys %MyServicesUserIDs;

                    push @{ $Notification{Data}->{RecipientAgents} }, @UserIDs;
                }
                elsif ( $Recipient eq 'AgentMyQueuesMyServices' ) {

                    # get subscribed users
                    my %MyQueuesUserIDs = map { $_ => 1 } $TicketObject->GetSubscribedUserIDsByQueueID(
                        QueueID => $Ticket{QueueID}
                    );

                    # get subscribed users
                    my %MyServicesUserIDs;
                    if ( $Ticket{ServiceID} ) {
                        %MyServicesUserIDs = map { $_ => 1 } $TicketObject->GetSubscribedUserIDsByServiceID(
                            ServiceID => $Ticket{ServiceID},
                        );
                    }

                    # combine both subscribed users list (this will also remove duplicates)
                    my %SubscribedUserIDs = ( %MyQueuesUserIDs, %MyServicesUserIDs );

                    for my $UserID ( sort keys %SubscribedUserIDs ) {
                        if ( !$MyQueuesUserIDs{$UserID} || !$MyServicesUserIDs{$UserID} ) {
                            delete $SubscribedUserIDs{$UserID};
                        }
                    }

                    my @UserIDs = sort keys %SubscribedUserIDs;

                    push @{ $Notification{Data}->{RecipientAgents} }, @UserIDs;
                }
                elsif ( $Recipient eq 'AgentCreateBy' ) {

                    # Check if the first article was created by an agent.
                    my @Articles = $ArticleObject->ArticleList(
                        TicketID   => $Param{Data}->{TicketID},
                        SenderType => 'agent',
                        OnlyFirst  => 1,
                    );

                    if ( $Articles[0] && $Articles[0]->{ArticleNumber} == 1 ) {
                        push @{ $Notification{Data}->{RecipientAgents} }, $Ticket{CreateBy};
                    }

                }
            }

            # Other OTRS packages might add other kind of recipients that are normally handled by
            #   other modules then an elsif condition here is useful.
            elsif ( $Recipient eq 'Customer' ) {

                # Get last article from customer.
                my @CustomerArticles = $ArticleObject->ArticleList(
                    TicketID   => $Param{Data}->{TicketID},
                    SenderType => 'customer',
                    OnlyLast   => 1,
                );

                my %CustomerArticle;

                ARTICLE:
                for my $Article (@CustomerArticles) {
                    next ARTICLE if !$Article->{ArticleID};

                    %CustomerArticle = $ArticleObject->BackendForArticle( %{$Article} )->ArticleGet(
                        %{$Article},
                        DynamicFields => 0,
                    );
                }

                my %Article = %CustomerArticle;

                # If the ticket has no customer article, get the last agent article.
                if ( !%CustomerArticle ) {

                    # Get last article from agent.
                    my @AgentArticles = $ArticleObject->ArticleList(
                        TicketID   => $Param{Data}->{TicketID},
                        SenderType => 'agent',
                        OnlyLast   => 1,
                    );

                    my %AgentArticle;

                    ARTICLE:
                    for my $Article (@AgentArticles) {
                        next ARTICLE if !$Article->{ArticleID};

                        %AgentArticle = $ArticleObject->BackendForArticle( %{$Article} )->ArticleGet(
                            %{$Article},
                            DynamicFields => 0,
                        );
                    }

                    %Article = %AgentArticle;
                }

                # Get raw ticket data.
                my %Ticket = $TicketObject->TicketGet(
                    TicketID      => $Param{Data}->{TicketID},
                    DynamicFields => 0,
                );

                my %Recipient;

                # When there is no customer article, last agent article will be used. In this case notification must not
                #   be sent to the "From", but to the "To" article field.

                # Check if we actually do have an article.
                if ( defined $Article{SenderType} ) {
                    if ( $Article{SenderType} eq 'customer' ) {
                        $Recipient{UserEmail} = $Article{From};
                    }
                    else {
                        $Recipient{UserEmail} = $Article{To};
                    }
                }
                $Recipient{Type} = 'Customer';

                # check if customer notifications should be send
                if (
                    $ConfigObject->Get('CustomerNotifyJustToRealCustomer')
                    && !$Ticket{CustomerUserID}
                    )
                {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'info',
                        Message  => 'Send no customer notification because no customer is set!',
                    );
                    next RECIPIENT;
                }

                # get language and send recipient
                $Recipient{Language} = $ConfigObject->Get('DefaultLanguage') || 'en';

                if ( $Ticket{CustomerUserID} ) {

                    my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
                        User => $Ticket{CustomerUserID},

                    );

                    # Check if customer user is email address, in case it is not stored in system
                    if (
                        !IsHashRefWithData( \%CustomerUser )
                        && !$ConfigObject->Get('CustomerNotifyJustToRealCustomer')
                        && $Kernel::OM->Get('Kernel::System::CheckItem')
                        ->CheckEmail( Address => $Ticket{CustomerUserID} )
                        )
                    {
                        $Recipient{UserEmail} = $Ticket{CustomerUserID};
                    }
                    else {

                        # join Recipient data with CustomerUser data
                        %Recipient = ( %Recipient, %CustomerUser );
                    }

                    # get user language
                    if ( $CustomerUser{UserLanguage} ) {
                        $Recipient{Language} = $CustomerUser{UserLanguage};
                    }
                }

                # get real name
                if ( $Ticket{CustomerUserID} ) {
                    $Recipient{Realname} = $CustomerUserObject->CustomerName(
                        UserLogin => $Ticket{CustomerUserID},
                    );
                }
                if ( !$Recipient{Realname} ) {
                    $Recipient{Realname} = $Article{From} || '';
                    $Recipient{Realname} =~ s/<.*>|\(.*\)|\"|;|,//g;
                    $Recipient{Realname} =~ s/( $)|(  $)//g;
                }

                # Skip notification if email address is already used by other groups.
                next RECIPIENT if grep { $_ eq $Recipient{UserEmail} } @RecipientUserEmails;

                # Push Email Addresses into array to prevent multiple notifications.
                push @RecipientUserEmails, $Recipient{UserEmail};

                push @RecipientUsers, \%Recipient;
            }
            elsif ( $Recipient eq 'AllRecipientsFirstArticle' || $Recipient eq 'AllRecipientsLastArticle' ) {

                my $SystemSenderType = $ArticleObject->ArticleSenderTypeLookup( SenderType => 'system' );

                my %Article;
                my @MetaArticles = grep { $_->{SenderTypeID} ne $SystemSenderType } $ArticleObject->ArticleList(
                    TicketID => $Param{Data}->{TicketID},
                );

                # Get the first or the last article.
                if ( $Recipient eq 'AllRecipientsFirstArticle' ) {
                    @MetaArticles = splice @MetaArticles, 0, 1;
                }
                elsif ( $Recipient eq 'AllRecipientsLastArticle' ) {
                    @MetaArticles = splice @MetaArticles, -1, 1;
                }

                if (@MetaArticles) {
                    my $ArticleBackend = $ArticleObject->BackendForArticle( %{ $MetaArticles[0] } );
                    if ( $ArticleBackend->ChannelNameGet() ne 'Email' ) {
                        next RECIPIENT;

                    }
                    %Article = $ArticleBackend->ArticleGet(
                        %{ $MetaArticles[0] },
                        DynamicFields => 0,
                    );
                }

                if ( !%Article ) {
                    next RECIPIENT;
                }

                my %Recipient;
                my @AllRecipients;
                my @TmpRecipients;
                my @TmpRecipientAgents;
                my @RecipientAgents;

                # Get recipient agents to prevent multiple notifications
                if ( IsArrayRefWithData( $Notification{Data}->{RecipientAgents} ) ) {
                    @RecipientAgents = @{ $Notification{Data}->{RecipientAgents} };
                }

                if (@RecipientAgents) {
                    for my $UserID (@RecipientAgents) {

                        my %User = $UserObject->GetUserData(
                            UserID => $UserID,
                        );

                        push @TmpRecipientAgents, $User{UserEmail};
                    }
                }

                # Get all recipients from the article.
                ALLRECIPIENTS:
                for my $Header (qw(From To Cc)) {

                    next ALLRECIPIENTS if !$Article{$Header};

                    push @TmpRecipients, split ',', $Article{$Header};
                }

                # Loop through recipients.
                EMAIL:
                for my $Email ( Mail::Address->parse(@TmpRecipients) ) {

                    # Skip notification if email address is already used by other groups.
                    next EMAIL if grep { $_ eq $Email->address() } @RecipientUserEmails;

                    # Validate email address.
                    my $Valid = $CheckItemObject->CheckEmail(
                        Address => $Email->address(),
                    );

                    # Skip invalid.
                    next EMAIL if !$Valid;

                    # Check if email address is a local.
                    my $IsLocal = $SystemAddressObject->SystemAddressIsLocalAddress(
                        Address => $Email->address(),
                    );

                    # Skip local email address.
                    next EMAIL if $IsLocal;

                    # Skip email addresses from agents selected by other groups.
                    next EMAIL if grep { $_ eq $Email->address() } @TmpRecipientAgents;

                    push @AllRecipients, $Email->address();

                    # Push Email Addresses into array to prevent multiple notifications.
                    push @RecipientUserEmails, $Email->address();
                }

                # Merge recipients.
                $Recipient{UserEmail} = join( ',', @AllRecipients );

                $Recipient{Type} = 'Customer';

                # Get user language.
                $Recipient{Language} = $ConfigObject->Get('DefaultLanguage') || 'en';

                push @RecipientUsers, \%Recipient;
            }
        }
    }

    # add recipient agents
    if ( IsArrayRefWithData( $Notification{Data}->{RecipientAgents} ) ) {
        push @RecipientUserIDs, @{ $Notification{Data}->{RecipientAgents} };
    }

    # hash to keep track which agents are already receiving this notification
    my %AgentUsed = map { $_ => 1 } @RecipientUserIDs;

    # get recipients by RecipientGroups
    if ( $Notification{Data}->{RecipientGroups} ) {

        RECIPIENT:
        for my $GroupID ( @{ $Notification{Data}->{RecipientGroups} } ) {

            my %GroupMemberList = $GroupObject->PermissionGroupUserGet(
                GroupID => $GroupID,
                Type    => 'ro',
            );

            GROUPMEMBER:
            for my $UserID ( sort keys %GroupMemberList ) {

                next GROUPMEMBER if $UserID == 1;
                next GROUPMEMBER if $AgentUsed{$UserID};

                $AgentUsed{$UserID} = 1;

                push @RecipientUserIDs, $UserID;
            }
        }
    }

    # get recipients by RecipientRoles
    if ( $Notification{Data}->{RecipientRoles} ) {

        RECIPIENT:
        for my $RoleID ( @{ $Notification{Data}->{RecipientRoles} } ) {

            my %RoleMemberList = $GroupObject->PermissionRoleUserGet(
                RoleID => $RoleID,
            );

            ROLEMEMBER:
            for my $UserID ( sort keys %RoleMemberList ) {

                next ROLEMEMBER if $UserID == 1;
                next ROLEMEMBER if $AgentUsed{$UserID};

                $AgentUsed{$UserID} = 1;

                push @RecipientUserIDs, $UserID;
            }
        }
    }

    # get needed objects
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    my %SkipRecipients;
    if ( IsArrayRefWithData( $Param{Data}->{SkipRecipients} ) ) {
        %SkipRecipients = map { $_ => 1 } @{ $Param{Data}->{SkipRecipients} };
    }

    # agent 1 should not receive notifications
    $SkipRecipients{'1'} = 1;

    # remove recipients should not receive a notification
    @RecipientUserIDs = grep { !$SkipRecipients{$_} } @RecipientUserIDs;

    # get valid users list
    my %ValidUsersList = $UserObject->UserList(
        Type          => 'Short',
        Valid         => 1,
        NoOutOfOffice => 0,
    );

    # remove invalid users
    @RecipientUserIDs = grep { $ValidUsersList{$_} } @RecipientUserIDs;

    # remove duplicated
    my %TempRecipientUserIDs = map { $_ => 1 } @RecipientUserIDs;
    @RecipientUserIDs = sort keys %TempRecipientUserIDs;

    # get time object
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    # get all data for recipients as they should be needed by all notification transports
    RECIPIENT:
    for my $UserID (@RecipientUserIDs) {

        my %User = $UserObject->GetUserData(
            UserID => $UserID,
            Valid  => 1,
        );
        next RECIPIENT if !%User;

        # skip user that triggers the event (it should not be notified) but only if it is not
        #   a pre-calculated recipient
        if (
            !$ConfigObject->Get('AgentSelfNotifyOnAction')
            && $User{UserID} == $Param{UserID}
            && !$PrecalculatedUserIDs{ $Param{UserID} }
            )
        {
            next RECIPIENT;
        }

        # skip users out of the office if configured
        if ( !$Notification{Data}->{SendOnOutOfOffice} && $User{OutOfOffice} ) {
            my $Start = sprintf(
                "%04d-%02d-%02d 00:00:00",
                $User{OutOfOfficeStartYear}, $User{OutOfOfficeStartMonth},
                $User{OutOfOfficeStartDay}
            );
            my $TimeStart = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Start,
                }
            );
            my $End = sprintf(
                "%04d-%02d-%02d 23:59:59",
                $User{OutOfOfficeEndYear}, $User{OutOfOfficeEndMonth},
                $User{OutOfOfficeEndDay}
            );
            my $TimeEnd = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $End,
                }
            );

            next RECIPIENT if $TimeStart < $DateTimeObject && $TimeEnd > $DateTimeObject;
        }

        # skip users with out ro permissions
        my $Permission = $TicketObject->TicketPermission(
            Type     => 'ro',
            TicketID => $Ticket{TicketID},
            UserID   => $User{UserID}
        );

        # Additional permissions for notes.
        # Please see bug#14917 for more information.
        if ( !$Permission && $Param{Event} eq 'NotificationAddNote' ) {
            $Permission = $TicketObject->TicketPermission(
                Type     => 'note',
                TicketID => $Ticket{TicketID},
                UserID   => $User{UserID}
            );
        }

        next RECIPIENT if !$Permission;

        # skip PostMasterUserID
        my $PostmasterUserID = $ConfigObject->Get('PostmasterUserID') || 1;
        next RECIPIENT if $User{UserID} == $PostmasterUserID;

        $User{Type} = 'Agent';

        push @RecipientUsers, \%User;
    }

    return @RecipientUsers;
}

sub _SendRecipientNotification {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TicketID UserID Notification Recipient Event Transport TransportObject)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
        }
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # check if the notification needs to be sent just one time per day
    if ( $Param{Notification}->{Data}->{OncePerDay} && $Param{Recipient}->{UserLogin} ) {

        # get ticket history
        my @HistoryLines = $TicketObject->HistoryGet(
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
        );

        # get last notification sent ticket history entry for this transport and this user
        my $LastNotificationHistory;
        if ( defined $Param{Recipient}->{Source} && $Param{Recipient}->{Source} eq 'CustomerUser' ) {
            $LastNotificationHistory = first {
                $_->{HistoryType} eq 'SendCustomerNotification'
                    && $_->{Name} eq
                    "\%\%$Param{Recipient}->{UserEmail}"
            }
            reverse @HistoryLines;
        }
        else {
            $LastNotificationHistory = first {
                $_->{HistoryType} eq 'SendAgentNotification'
                    && $_->{Name} eq
                    "\%\%$Param{Notification}->{Name}\%\%$Param{Recipient}->{UserLogin}\%\%$Param{Transport}"
            }
            reverse @HistoryLines;
        }

        if ( $LastNotificationHistory && $LastNotificationHistory->{CreateTime} ) {

            my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

            my $LastNotificationDateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $LastNotificationHistory->{CreateTime},
                },
            );

            # do not send the notification if it has been sent already today
            if (
                $DateTimeObject->Format( Format => "%Y-%m-%d" ) eq
                $LastNotificationDateTimeObject->Format( Format => "%Y-%m-%d" )
                )
            {
                return;
            }
        }
    }

    my $TransportObject = $Param{TransportObject};

    # send notification to each recipient
    my $Success = $TransportObject->SendNotification(
        TicketID              => $Param{TicketID},
        UserID                => $Param{UserID},
        Notification          => $Param{Notification},
        CustomerMessageParams => $Param{CustomerMessageParams},
        Recipient             => $Param{Recipient},
        Event                 => $Param{Event},
        Attachments           => $Param{Attachments},
    );

    return if !$Success;

    if (
        $Param{Recipient}->{Type} eq 'Agent'
        && $Param{Recipient}->{UserLogin}
        )
    {

        # write history
        $TicketObject->HistoryAdd(
            TicketID     => $Param{TicketID},
            HistoryType  => 'SendAgentNotification',
            Name         => "\%\%$Param{Notification}->{Name}\%\%$Param{Recipient}->{UserLogin}\%\%$Param{Transport}",
            CreateUserID => $Param{UserID},
        );
    }

    my %EventData = %{ $TransportObject->GetTransportEventData() };

    return 1 if !%EventData;

    if ( !$EventData{Event} || !$EventData{Data} || !$EventData{UserID} ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not trigger notification post send event",
        );

        return;
    }

    # ticket event
    $TicketObject->EventHandler(
        %EventData,
    );

    return 1;
}

1;
