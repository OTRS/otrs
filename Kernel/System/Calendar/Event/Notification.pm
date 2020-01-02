# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Calendar::Event::Notification;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Calendar',
    'Kernel::System::Calendar::Appointment',
    'Kernel::System::DateTime',
    'Kernel::System::Group',
    'Kernel::System::JSON',
    'Kernel::System::Log',
    'Kernel::System::NotificationEvent',
    'Kernel::System::CalendarTemplateGenerator',
    'Kernel::System::Ticket',
    'Kernel::System::User',
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

    if ( !$Param{Data}->{AppointmentID} && !$Param{Data}->{CalendarID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need either CalendarID or AppointmentID in Data!',
        );
        return;
    }

    # get notification event object
    my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');

    # check if event is affected
    my @IDs = $NotificationEventObject->NotificationEventCheck(
        Event => $Param{Event},
    );

    # return if no notification for event exists
    if ( !IsArrayRefWithData( \@IDs ) ) {

        # update the future tasks
        $Self->_FutureTaskUpdate();

        return 1;
    }

    my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
    my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');

    my %Calendar;
    my %Appointment;

    if ( $Param{Data}->{AppointmentID} ) {
        %Appointment = $AppointmentObject->AppointmentGet(
            AppointmentID => $Param{Data}->{AppointmentID},
        );
        %Calendar = $CalendarObject->CalendarGet(
            CalendarID => $Appointment{CalendarID} || $Param{Data}->{CalendarID},
        );
    }
    elsif ( $Param{Data}->{CalendarID} ) {
        %Calendar = $CalendarObject->CalendarGet(
            CalendarID => $Param{Data}->{CalendarID},
        );
    }

    NOTIFICATIONID:
    for my $NotificationID (@IDs) {

        my %Notification = $NotificationEventObject->NotificationGet(
            ID => $NotificationID,
        );

        # verify appointment conditions
        my $PassFilter = $Self->_NotificationFilter(
            %Param,
            Appointment  => \%Appointment,
            Calendar     => \%Calendar,
            Notification => \%Notification,
        );

        next NOTIFICATIONID if !$PassFilter;

        # get recipients
        my @RecipientUsers = $Self->_RecipientsGet(
            %Param,
            Appointment  => \%Appointment,
            Calendar     => \%Calendar,
            Notification => \%Notification,
        );

        my @NotificationBundle;

        # get template generator object;
        my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::CalendarTemplateGenerator');

        # parse all notification tags for each user
        for my $Recipient (@RecipientUsers) {

            my %ReplacedNotification = $TemplateGeneratorObject->NotificationEvent(
                AppointmentID => $Param{Data}->{AppointmentID},
                CalendarID    => $Param{Data}->{CalendarID},
                Recipient     => $Recipient,
                Notification  => \%Notification,
                UserID        => $Param{UserID},
            );

            my $UserNotificationTransport = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
                Data => $Recipient->{AppointmentNotificationTransport},
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
        my %TransportConfig = %{ $ConfigObject->Get('AppointmentNotification::Transport') || {} };

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

                my $Success = $Self->_SendRecipientNotification(
                    AppointmentID => $Appointment{AppointmentID} || '',
                    CalendarID    => $Calendar{CalendarID}       || $Appointment{CalendarID} || '',
                    Notification          => $Bundle->{Notification},
                    CustomerMessageParams => $Param{Data}->{CustomerMessageParams} || {},
                    Recipient             => $Bundle->{Recipient},
                    Event                 => $Param{Event},
                    Transport             => $Transport,
                    TransportObject       => $TransportObject,
                    UserID                => $Param{UserID},
                );

                # remember to have sent
                $AlreadySent{ $Bundle->{Recipient}->{UserID} } = 1;

            }

            # get special recipients specific for each transport
            my @TransportRecipients = $TransportObject->GetTransportRecipients(
                Notification => \%Notification,
            );

            next TRANSPORT if !@TransportRecipients;

            RECIPIENT:
            for my $Recipient (@TransportRecipients) {

                # replace all notification tags for each special recipient
                my %ReplacedNotification = $TemplateGeneratorObject->NotificationEvent(
                    AppointmentID         => $Param{Data}->{AppointmentID},
                    Recipient             => $Recipient,
                    Notification          => \%Notification,
                    CustomerMessageParams => $Param{Data}->{CustomerMessageParams} || {},
                    UserID                => $Param{UserID},
                );

                my $Success = $Self->_SendRecipientNotification(
                    AppointmentID => $Appointment{AppointmentID} || '',
                    CalendarID    => $Calendar{CalendarID}       || $Appointment{CalendarID} || '',
                    Notification          => \%ReplacedNotification,
                    CustomerMessageParams => $Param{Data}->{CustomerMessageParams} || {},
                    Recipient             => $Recipient,
                    Event                 => $Param{Event},
                    Transport             => $Transport,
                    TransportObject       => $TransportObject,
                    UserID                => $Param{UserID},
                );
            }
        }
    }

    # update appointment future tasks
    $Self->_FutureTaskUpdate();

    return 1;
}

sub _NotificationFilter {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(Appointment Calendar Notification)) {
        return if !$Param{$Needed};
    }

    # set local values
    my %Notification = %{ $Param{Notification} };

    return if !IsHashRefWithData( $Notification{Data} );

    KEY:
    for my $Key ( sort keys %{ $Notification{Data} } ) {

        # ignore not appointment related attributes
        next KEY if $Key eq 'Recipients';
        next KEY if $Key eq 'SkipRecipients';
        next KEY if $Key eq 'RecipientAgents';
        next KEY if $Key eq 'RecipientGroups';
        next KEY if $Key eq 'RecipientRoles';
        next KEY if $Key eq 'TransportEmailTemplate';
        next KEY if $Key eq 'Events';
        next KEY if $Key eq 'ArticleTypeID';
        next KEY if $Key eq 'ArticleSenderTypeID';
        next KEY if $Key eq 'ArticleSubjectMatch';
        next KEY if $Key eq 'ArticleBodyMatch';
        next KEY if $Key eq 'ArticleAttachmentInclude';
        next KEY if $Key eq 'NotificationArticleTypeID';
        next KEY if $Key eq 'Transports';
        next KEY if $Key eq 'OncePerDay';
        next KEY if $Key eq 'VisibleForAgent';
        next KEY if $Key eq 'VisibleForAgentTooltip';
        next KEY if $Key eq 'LanguageID';
        next KEY if $Key eq 'SendOnOutOfOffice';
        next KEY if $Key eq 'AgentEnabledByDefault';
        next KEY if $Key eq 'NotificationType';

        # check recipient fields from transport methods
        if ( $Key =~ m{\A Recipient}xms ) {
            next KEY;
        }

        # check appointment attributes
        next KEY if !$Notification{Data}->{$Key};
        next KEY if !@{ $Notification{Data}->{$Key} };
        next KEY if !$Notification{Data}->{$Key}->[0];

        my $Match = 0;

        VALUE:
        for my $Value ( @{ $Notification{Data}->{$Key} } ) {

            next VALUE if !$Value;

            if (
                $Key eq 'TeamID'
                || $Key eq 'ResourceID'
                )
            {
                # check for existing object ids in appointment
                next KEY if !IsArrayRefWithData( $Param{Appointment}->{$Key} );

                OBJECTID:
                for my $ObjectID ( @{ $Param{Appointment}->{$Key} } ) {

                    next OBJECTID if !$ObjectID;

                    if ( $Value eq $ObjectID ) {
                        $Match = 1;
                        last VALUE;
                    }
                }
            }
            elsif ( $Key eq 'Title' || $Key eq 'Location' ) {
                if ( defined $Param{Appointment}->{$Key} && $Param{Appointment}->{$Key} =~ m/$Value/i ) {
                    $Match = 1;
                    last VALUE;
                }
            }
            else {

                if ( defined $Param{Appointment}->{$Key} && $Value eq $Param{Appointment}->{$Key} ) {
                    $Match = 1;
                    last VALUE;
                }
            }
        }

        return if !$Match;
    }

    return 1;
}

sub _RecipientsGet {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(Appointment Calendar Notification)) {
        return if !$Param{$Needed};
    }

    # set local values
    my %Notification = %{ $Param{Notification} };
    my %Appointment  = %{ $Param{Appointment} };

    # get needed objects
    my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
    my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');
    my $GroupObject       = $Kernel::OM->Get('Kernel::System::Group');
    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');

    my @RecipientUserIDs;
    my @RecipientUsers;

    # add pre-calculated recipient
    if ( IsArrayRefWithData( $Param{Data}->{Recipients} ) ) {
        push @RecipientUserIDs, @{ $Param{Data}->{Recipients} };
    }

    # remember pre-calculated user recipients for later comparisons
    my %PrecalculatedUserIDs = map { $_ => 1 } @RecipientUserIDs;

    # get recipients by Recipients
    if ( $Notification{Data}->{Recipients} ) {

        RECIPIENT:
        for my $Recipient ( @{ $Notification{Data}->{Recipients} } ) {

            if (
                $Recipient
                =~ /^Appointment(Agents|AgentReadPermissions|AgentWritePermissions)$/
                )
            {
                if ( $Recipient eq 'AppointmentAgents' ) {

                    RESOURCEID:
                    for my $ResourceID ( @{ $Appointment{ResourceID} } ) {

                        next RESOURCEID if !$ResourceID;

                        push @{ $Notification{Data}->{RecipientAgents} }, $ResourceID;
                    }
                }
                elsif ( $Recipient eq 'AppointmentAgentReadPermissions' ) {

                    # get calendar information
                    my %Calendar = $CalendarObject->CalendarGet(
                        CalendarID => $Appointment{CalendarID} || $Param{Calendar}->{CalendarID},
                        UserID     => 1,
                    );

                    # get a list of read access users for the related calendar
                    my %Users = $GroupObject->PermissionGroupGet(
                        GroupID => $Calendar{GroupID},
                        Type    => 'ro',
                    );

                    USERID:
                    for my $UserID ( sort keys %Users ) {

                        next USERID if !$UserID;

                        push @{ $Notification{Data}->{RecipientAgents} }, $UserID;
                    }
                }
                elsif ( $Recipient eq 'AppointmentAgentWritePermissions' ) {

                    # get calendar information
                    my %Calendar = $CalendarObject->CalendarGet(
                        CalendarID => $Appointment{CalendarID} || $Param{Calendar}->{CalendarID},
                        UserID     => 1,
                    );

                    # get a list of read access users for the related calendar
                    my %Users = $GroupObject->PermissionGroupGet(
                        GroupID => $Calendar{GroupID},
                        Type    => 'rw',
                    );

                    USERID:
                    for my $UserID ( sort keys %Users ) {

                        next USERID if !$UserID;

                        push @{ $Notification{Data}->{RecipientAgents} }, $UserID;
                    }
                }
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
            my $StartTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Start,
                },
            );

            my $End = sprintf(
                "%04d-%02d-%02d 23:59:59",
                $User{OutOfOfficeEndYear}, $User{OutOfOfficeEndMonth},
                $User{OutOfOfficeEndDay}
            );
            my $EndTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $End,
                },
            );

            next RECIPIENT if $StartTimeObject < $DateTimeObject && $EndTimeObject > $DateTimeObject;
        }

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
    for my $Needed (qw(UserID Notification Recipient Event Transport TransportObject)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
        }
    }

    my $TransportObject = $Param{TransportObject};

    # send notification to each recipient
    my $Success = $TransportObject->SendNotification(
        AppointmentID         => $Param{AppointmentID},
        CalendarID            => $Param{CalendarID},
        UserID                => $Param{UserID},
        Notification          => $Param{Notification},
        CustomerMessageParams => $Param{CustomerMessageParams},
        Recipient             => $Param{Recipient},
        Event                 => $Param{Event},
        Attachments           => $Param{Attachments},
    );

    return if !$Success;

    my %EventData = %{ $TransportObject->GetTransportEventData() };

    return 1 if !%EventData;

    if ( !$EventData{Event} || !$EventData{Data} || !$EventData{UserID} ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not trigger notification post send event",
        );

        return;
    }

    return 1;
}

sub _FutureTaskUpdate {
    my ( $Self, %Param ) = @_;

    # Get the next upcoming appointment.
    my $Success = $Kernel::OM->Get('Kernel::System::Calendar::Appointment')->AppointmentFutureTasksUpdate();

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not update upcoming appointment data!',
        );
        return;
    }

    return 1;
}

1;
