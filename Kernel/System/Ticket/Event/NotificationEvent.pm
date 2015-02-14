# --
# Kernel/System/Ticket/Event/NotificationEvent.pm - a event module to send notifications
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::NotificationEvent;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerUser',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Email',
    'Kernel::System::Group',
    'Kernel::System::HTMLUtils',
    'Kernel::System::Log',
    'Kernel::System::NotificationEvent',
    'Kernel::System::Queue',
    'Kernel::System::SystemAddress',
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
    for (qw(Event Data Config UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    for (qw(TicketID)) {
        if ( !$Param{Data}->{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_ in Data!"
            );
            return;
        }
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

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
        Event  => $Param{Event},
        UserID => $Param{UserID},
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
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

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

    NOTIFICATION:
    for my $ID (@IDs) {

        my %Notification = $NotificationEventObject->NotificationGet(
            ID     => $ID,
            UserID => 1,
        );
        next NOTIFICATION if !$Notification{Data};

        KEY:
        for my $Key ( sort keys %{ $Notification{Data} } ) {

            # ignore not ticket related attributes
            next KEY if $Key eq 'Recipients';
            next KEY if $Key eq 'RecipientAgents';
            next KEY if $Key eq 'RecipientGroups';
            next KEY if $Key eq 'RecipientRoles';
            next KEY if $Key eq 'RecipientEmail';
            next KEY if $Key eq 'Events';
            next KEY if $Key eq 'ArticleTypeID';
            next KEY if $Key eq 'ArticleSenderTypeID';
            next KEY if $Key eq 'ArticleSubjectMatch';
            next KEY if $Key eq 'ArticleBodyMatch';
            next KEY if $Key eq 'ArticleAttachmentInclude';
            next KEY if $Key eq 'NotificationArticleTypeID';

            # check ticket attributes
            next KEY if !$Notification{Data}->{$Key};
            next KEY if !@{ $Notification{Data}->{$Key} };
            next KEY if !$Notification{Data}->{$Key}->[0];
            my $Match = 0;

            VALUE:
            for my $Value ( @{ $Notification{Data}->{$Key} } ) {

                next VALUE if !$Value;

                # check if key is a search dynamic field
                if ( $Key =~ m{\A Search_DynamicField_}xms ) {

                    # remove search prefix
                    my $DynamicFieldName = $Key;

                    $DynamicFieldName =~ s{Search_DynamicField_}{};

                    # get the dynamic field config for this field
                    my $DynamicFieldConfig = $DynamicFieldConfigLookup{$DynamicFieldName};

                    next VALUE if !$DynamicFieldConfig;

                    my $IsNotificationEventCondition = $DynamicFieldBackendObject->HasBehavior(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Behavior           => 'IsNotificationEventCondition',
                    );

                    next VALUE if !$IsNotificationEventCondition;

                    $Match = $DynamicFieldBackendObject->ObjectMatch(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Value              => $Value,
                        ObjectAttributes   => \%Ticket,
                    );

                    last VALUE if $Match;
                }
                else {

                    if ( $Value eq $Ticket{$Key} ) {
                        $Match = 1;
                        last VALUE;
                    }
                }
            }

            next NOTIFICATION if !$Match;
        }

        # match article types only on ArticleCreate or ArticleSend event
        my @Attachments;
        if (
            ( ( $Param{Event} eq 'ArticleCreate' ) || ( $Param{Event} eq 'ArticleSend' ) )
            && $Param{Data}->{ArticleID}
            )
        {

            my %Article = $TicketObject->ArticleGet(
                ArticleID     => $Param{Data}->{ArticleID},
                UserID        => $Param{UserID},
                DynamicFields => 0,
            );

            # check article type
            if ( $Notification{Data}->{ArticleTypeID} ) {

                my $Match = 0;
                VALUE:
                for my $Value ( @{ $Notification{Data}->{ArticleTypeID} } ) {

                    next VALUE if !$Value;

                    if ( $Value == $Article{ArticleTypeID} ) {
                        $Match = 1;
                        last VALUE;
                    }
                }

                next NOTIFICATION if !$Match;
            }

            # check article sender type
            if ( $Notification{Data}->{ArticleSenderTypeID} ) {

                my $Match = 0;
                VALUE:
                for my $Value ( @{ $Notification{Data}->{ArticleSenderTypeID} } ) {

                    next VALUE if !$Value;

                    if ( $Value == $Article{SenderTypeID} ) {
                        $Match = 1;
                        last VALUE;
                    }
                }

                next NOTIFICATION if !$Match;
            }

            # check subject & body
            KEY:
            for my $Key (qw( Subject Body )) {

                next KEY if !$Notification{Data}->{ 'Article' . $Key . 'Match' };

                my $Match = 0;
                VALUE:
                for my $Value ( @{ $Notification{Data}->{ 'Article' . $Key . 'Match' } } ) {

                    next VALUE if !$Value;

                    if ( $Article{$Key} =~ /\Q$Value\E/i ) {
                        $Match = 1;
                        last VALUE;
                    }
                }

                next NOTIFICATION if !$Match;
            }

            # add attachments to notification
            if ( $Notification{Data}->{ArticleAttachmentInclude}->[0] ) {
                my %Index = $TicketObject->ArticleAttachmentIndex(
                    ArticleID                  => $Param{Data}->{ArticleID},
                    UserID                     => $Param{UserID},
                    StripPlainBodyAsAttachment => 3,
                );
                if (%Index) {
                    FILE_ID:
                    for my $FileID ( sort keys %Index ) {
                        my %Attachment = $TicketObject->ArticleAttachment(
                            ArticleID => $Param{Data}->{ArticleID},
                            FileID    => $FileID,
                            UserID    => $Param{UserID},
                        );
                        next FILE_ID if !%Attachment;
                        push @Attachments, \%Attachment;
                    }
                }
            }
        }

        # send notification
        $Self->_SendNotificationToRecipients(
            TicketID              => $Param{Data}->{TicketID},
            UserID                => $Param{UserID},
            Notification          => \%Notification,
            CustomerMessageParams => {},
            Event                 => $Param{Event},
            Attachments           => \@Attachments,
        );
    }

    return 1;
}

# Assemble the list of recipients. Agents and customer users can be recipient.
# Call _SendNotification() for each recipient.
sub _SendNotificationToRecipients {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(CustomerMessageParams TicketID UserID Notification)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get old article for quoting
    my %Article = $TicketObject->ArticleLastCustomerArticle(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    # If the ticket has no articles yet, get the raw ticket data
    if ( !%Article ) {
        %Article = $TicketObject->TicketGet(
            TicketID      => $Param{TicketID},
            DynamicFields => 0,
        );
    }

    # get needed objects
    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $GroupObject        = $Kernel::OM->Get('Kernel::System::Group');

    # get recipients by Recipients
    my @Recipients;
    if ( $Param{Notification}->{Data}->{Recipients} ) {

        # get queue object
        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

        RECIPIENT:
        for my $Recipient ( @{ $Param{Notification}->{Data}->{Recipients} } ) {

            if ( $Recipient =~ /^Agent(Owner|Responsible|WritePermissions)$/ ) {

                if ( $Recipient eq 'AgentOwner' ) {
                    push @{ $Param{Notification}->{Data}->{RecipientAgents} }, $Article{OwnerID};
                }
                elsif ( $Recipient eq 'AgentResponsible' ) {
                    push @{ $Param{Notification}->{Data}->{RecipientAgents} },
                        $Article{ResponsibleID};
                }
                elsif ( $Recipient eq 'AgentWritePermissions' ) {
                    my $GroupID = $QueueObject->GetQueueGroupID(
                        QueueID => $Article{QueueID},
                    );
                    my @UserIDs = $GroupObject->GroupMemberList(
                        GroupID => $GroupID,
                        Type    => 'rw',
                        Result  => 'ID',
                    );
                    push @{ $Param{Notification}->{Data}->{RecipientAgents} }, @UserIDs;
                }
            }
            elsif ( $Recipient eq 'Customer' ) {

                my %Recipient;

                # ArticleLastCustomerArticle() returns the lastest customer article but if there
                # is no customer acticle, it returns the latest agent article. In this case
                # notification must not be send to the "From", but to the "To" article field.

                # Check if we actually do have an article
                if ( defined $Article{SenderType} ) {
                    if ( $Article{SenderType} eq 'customer' ) {
                        $Recipient{Email} = $Article{From};
                    }
                    else {
                        $Recipient{Email} = $Article{To};
                    }
                }
                $Recipient{Type} = 'Customer';

                # check if customer notifications should be send
                if (
                    $ConfigObject->Get('CustomerNotifyJustToRealCustomer')
                    && !$Article{CustomerUserID}
                    )
                {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'info',
                        Message  => 'Send no customer notification because no customer is set!',
                    );
                    next RECIPIENT;
                }

                # check customer email
                elsif ( $ConfigObject->Get('CustomerNotifyJustToRealCustomer') ) {

                    my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
                        User => $Article{CustomerUserID},
                    );

                    if ( !$CustomerUser{UserEmail} ) {
                        $Kernel::OM->Get('Kernel::System::Log')->Log(
                            Priority => 'info',
                            Message  => "Send no customer notification because of missing "
                                . "customer email (CustomerUserID=$CustomerUser{CustomerUserID})!",
                        );
                        next RECIPIENT;
                    }
                }

                # get language and send recipient
                $Recipient{Language} = $ConfigObject->Get('DefaultLanguage') || 'en';

                if ( $Article{CustomerUserID} ) {

                    my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
                        User => $Article{CustomerUserID},
                    );
                    if ( $CustomerUser{UserEmail} ) {
                        $Recipient{Email} = $CustomerUser{UserEmail};
                    }

                    # get user language
                    if ( $CustomerUser{UserLanguage} ) {
                        $Recipient{Language} = $CustomerUser{UserLanguage};
                    }
                }

                # check recipients
                if ( !$Recipient{Email} || $Recipient{Email} !~ /@/ ) {
                    next RECIPIENT;
                }

                # get realname
                if ( $Article{CustomerUserID} ) {
                    $Recipient{Realname} = $CustomerUserObject->CustomerName(
                        UserLogin => $Article{CustomerUserID},
                    );
                }
                if ( !$Recipient{Realname} ) {
                    $Recipient{Realname} = $Article{From} || '';
                    $Recipient{Realname} =~ s/<.*>|\(.*\)|\"|;|,//g;
                    $Recipient{Realname} =~ s/( $)|(  $)//g;
                }

                push @Recipients, \%Recipient;
            }
        }
    }

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    # hash to keep track which agents are already receiving this notification
    my %AgentUsed;

    # get recipients by RecipientAgents
    if ( $Param{Notification}->{Data}->{RecipientAgents} ) {

        RECIPIENT:
        for my $Recipient ( @{ $Param{Notification}->{Data}->{RecipientAgents} } ) {

            next RECIPIENT if $Recipient == 1;
            next RECIPIENT if $AgentUsed{$Recipient};

            $AgentUsed{$Recipient} = 1;

            my %User = $UserObject->GetUserData(
                UserID => $Recipient,
                Valid  => 1,
            );
            next RECIPIENT if !%User;

            my %Recipient;

            $Recipient{Email} = $User{UserEmail};
            $Recipient{Type}  = 'Agent';

            push @Recipients, \%Recipient;
        }
    }

    # get recipients by RecipientGroups
    if ( $Param{Notification}->{Data}->{RecipientGroups} ) {

        RECIPIENT:
        for my $Group ( @{ $Param{Notification}->{Data}->{RecipientGroups} } ) {

            my @GroupMemberList = $GroupObject->GroupMemberList(
                Result  => 'ID',
                Type    => 'ro',
                GroupID => $Group,
            );

            GROUPMEMBER:
            for my $Recipient (@GroupMemberList) {

                next GROUPMEMBER if $Recipient == 1;
                next GROUPMEMBER if $AgentUsed{$Recipient};

                $AgentUsed{$Recipient} = 1;

                my %UserData = $UserObject->GetUserData(
                    UserID => $Recipient,
                    Valid  => 1
                );

                if ( $UserData{UserEmail} ) {
                    my %Recipient;
                    $Recipient{Email} = $UserData{UserEmail};
                    $Recipient{Type}  = 'Agent';
                    push @Recipients, \%Recipient;
                }
            }
        }
    }

    # get recipients by RecipientRoles
    if ( $Param{Notification}->{Data}->{RecipientRoles} ) {

        RECIPIENT:
        for my $Role ( @{ $Param{Notification}->{Data}->{RecipientRoles} } ) {

            my @RoleMemberList = $GroupObject->GroupUserRoleMemberList(
                Result => 'ID',
                RoleID => $Role,
            );

            ROLEMEMBER:
            for my $Recipient (@RoleMemberList) {

                next ROLEMEMBER if $Recipient == 1;
                next ROLEMEMBER if $AgentUsed{$Recipient};

                $AgentUsed{$Recipient} = 1;

                my %UserData = $UserObject->GetUserData(
                    UserID => $Recipient,
                    Valid  => 1
                );

                if ( $UserData{UserEmail} ) {
                    my %Recipient;
                    $Recipient{Email} = $UserData{UserEmail};
                    $Recipient{Type}  = 'Agent';
                    push @Recipients, \%Recipient;
                }
            }
        }
    }

    # get recipients by RecipientEmail
    if ( $Param{Notification}->{Data}->{RecipientEmail} ) {
        if ( $Param{Notification}->{Data}->{RecipientEmail}->[0] ) {
            my %Recipient;
            $Recipient{Realname} = '';
            $Recipient{Type}     = 'Customer';
            $Recipient{Email}    = $Param{Notification}->{Data}->{RecipientEmail}->[0];

            # check if we have a specified article type
            if ( $Param{Notification}->{Data}->{NotificationArticleTypeID} ) {
                $Recipient{NotificationArticleType} = $TicketObject->ArticleTypeLookup(
                    ArticleTypeID => $Param{Notification}->{Data}->{NotificationArticleTypeID}->[0]
                ) || 'email-notification-ext';
            }

            # check recipients
            if ( $Recipient{Email} && $Recipient{Email} =~ /@/ ) {
                push @Recipients, \%Recipient;
            }
        }
    }

    # Get current user data
    my %CurrentUser = $UserObject->GetUserData(
        UserID => $Param{UserID},
    );

    # get system address object
    my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');

    RECIPIENT:
    for my $Recipient (@Recipients) {

        if (
            $SystemAddressObject->SystemAddressIsLocalAddress(
                Address => $Recipient->{Email},
            )
            )
        {
            next RECIPIENT;
        }

        # do not send email to self if AgentSelfNotification is set to No
        if (
            !$ConfigObject->Get('AgentSelfNotifyOnAction')
            && lc( $Recipient->{Email} ) eq lc( $CurrentUser{UserEmail} )
            )
        {
            next RECIPIENT;
        }

        # create new array to prevent attachment growth (see bug#5114)
        my @Attachments = @{ $Param{Attachments} };

        $Self->_SendNotification(
            TicketID              => $Param{TicketID},
            UserID                => $Param{UserID},
            Notification          => $Param{Notification},
            CustomerMessageParams => {},
            Recipient             => $Recipient,
            Event                 => $Param{Event},
            Attachments           => \@Attachments,
        );

    }
    return 1;
}

# send notification to
sub _SendNotification {
    my ( $Self, %Param ) = @_;

    # get html utils object
    my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

    # get notification data
    my %Notification = %{ $Param{Notification} };

    # get recipient data
    my %Recipient = %{ $Param{Recipient} };

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get old article for quoting
    my %Article = $TicketObject->ArticleLastCustomerArticle(
        TicketID      => $Param{TicketID},
        DynamicFields => 1,
    );

    # convert values to html to get correct line breaks etc.
    if ( $Notification{Type} =~ m{text\/html} ) {
        KEY:
        for my $Key ( sort keys %Article ) {
            next KEY if !$Article{$Key};
            $Article{$Key} = $HTMLUtilsObject->ToHTML(
                String => $Article{$Key},
            );
        }
    }

    # get notification texts
    KEY:
    for (qw(Subject Body)) {
        next KEY if $Notification{$_};
        $Notification{$_} = "No CustomerNotification $_ for $Param{Type} found!";
    }

    my $Start = '<';
    my $End   = '>';
    if ( $Notification{Type} =~ m{text\/html} ) {
        $Start = '&lt;';
        $End   = '&gt;';
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # replace config optionsf
    $Notification{Body} =~ s{${Start}OTRS_CONFIG_(.+?)${End}}{$ConfigObject->Get($1)}egx;
    $Notification{Subject} =~ s{<OTRS_CONFIG_(.+?)>}{$ConfigObject->Get($1)}egx;

    # cleanup
    $Notification{Subject} =~ s/<OTRS_CONFIG_.+?>/-/gi;
    $Notification{Body} =~ s/${Start}OTRS_CONFIG_.+?${End}/-/gi;

    # ticket data
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 1,
    );

    # convert values to html to get correct line breaks etc.
    if ( $Notification{Type} =~ m{text\/html} ) {
        KEY:
        for my $Key ( sort keys %Ticket ) {
            next KEY if !$Ticket{$Key};
            $Ticket{$Key} = $HTMLUtilsObject->ToHTML(
                String => $Ticket{$Key},
            );
        }
    }

    # COMPAT
    # use Ticket information as a fallback (if ticket has no Articles)
    my $TicketNumber = $Article{TicketNumber} || $Ticket{TicketNumber};
    $Notification{Body} =~ s/${Start}OTRS_TICKET_ID${End}/$Param{TicketID}/gi;
    $Notification{Body} =~ s/${Start}OTRS_TICKET_NUMBER${End}/$TicketNumber/gi;

    # prepare customer realname
    if ( $Notification{Body} =~ /${Start}OTRS_CUSTOMER_REALNAME${End}/ ) {

        # get customer user object
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        my $RealName = $CustomerUserObject->CustomerName(
            UserLogin => $Ticket{CustomerUserID}
        ) || $Recipient{Realname};

        $Notification{Body} =~ s/${Start}OTRS_CUSTOMER_REALNAME${End}/$RealName/g;
    }

    # get dynamic field objects
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    KEY:
    for my $Key ( sort keys %Ticket ) {

        next KEY if !defined $Ticket{$Key};

        my $DisplayKeyValue = $Ticket{$Key};
        my $DisplayValue    = $Ticket{$Key};

        if ( $Key =~ /^DynamicField_/i ) {

            my $FieldName = $Key;
            $FieldName =~ s/DynamicField_//gi;

            # get dynamic field config
            my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
                Name => $FieldName,
            );

            # get the display value for each dynamic field
            $DisplayValue = $DynamicFieldBackendObject->ValueLookup(
                DynamicFieldConfig => $DynamicField,
                Key                => $Ticket{$Key},
            );

            # get the readable value (value) for each dynamic field
            my $ValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
                DynamicFieldConfig => $DynamicField,
                Value              => $DisplayValue,
            );
            $DisplayValue = $ValueStrg->{Value};

            # get display key value
            my $KeyValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
                DynamicFieldConfig => $DynamicField,
                Value              => $DisplayKeyValue,
            );
            $DisplayKeyValue = $KeyValueStrg->{Value};
        }

        $Notification{Body} =~ s/${Start}OTRS_TICKET_${Key}${End}/$DisplayKeyValue/gi;
        $Notification{Subject} =~ s/<OTRS_TICKET_${Key}>/$DisplayKeyValue/gi;

        $Notification{Body} =~ s/${Start}OTRS_TICKET_${Key}_Value${End}/$DisplayValue/gi;
        $Notification{Subject} =~ s/<OTRS_TICKET_${Key}_Value>/$DisplayValue/gi;
    }

    # cleanup
    $Notification{Subject} =~ s/<OTRS_TICKET_.+?>/-/gi;
    $Notification{Body} =~ s/${Start}OTRS_TICKET_.+?${End}/-/gi;

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    # get current user data
    my %CurrentPreferences = $UserObject->GetUserData(
        UserID        => $Param{UserID},
        NoOutOfOffice => 1,
    );

    # convert values to html to get correct line breaks etc.
    if ( $Notification{Type} =~ m{text\/html} ) {
        KEY:
        for my $Key ( sort keys %CurrentPreferences ) {
            next KEY if !$CurrentPreferences{$Key};
            $CurrentPreferences{$Key} = $HTMLUtilsObject->ToHTML(
                String => $CurrentPreferences{$Key},
            );
        }
    }

    KEY:
    for ( sort keys %CurrentPreferences ) {
        next KEY if !defined $CurrentPreferences{$_};
        $Notification{Body} =~ s/${Start}OTRS_CURRENT_$_${End}/$CurrentPreferences{$_}/gi;
        $Notification{Subject} =~ s/<OTRS_CURRENT_$_>/$CurrentPreferences{$_}/gi;
    }

    # cleanup
    $Notification{Subject} =~ s/<OTRS_CURRENT_.+?>/-/gi;
    $Notification{Body} =~ s/${Start}OTRS_CURRENT_.+?${End}/-/gi;

    # get owner data
    my $OwnerID = $Article{OwnerID};

    # get owner from ticket if there are no articles
    if ( !$OwnerID ) {
        $OwnerID = $Ticket{OwnerID};
    }
    my %OwnerPreferences = $UserObject->GetUserData(
        UserID        => $OwnerID,
        NoOutOfOffice => 1,
    );

    # convert values to html to get correct line breaks etc.
    if ( $Notification{Type} =~ m{text\/html} ) {
        KEY:
        for my $Key ( sort keys %OwnerPreferences ) {
            next KEY if !$OwnerPreferences{$Key};
            $OwnerPreferences{$Key} = $HTMLUtilsObject->ToHTML(
                String => $OwnerPreferences{$Key},
            );
        }
    }

    KEY:
    for ( sort keys %OwnerPreferences ) {
        next KEY if !$OwnerPreferences{$_};
        $Notification{Body} =~ s/${Start}OTRS_OWNER_$_${End}/$OwnerPreferences{$_}/gi;
        $Notification{Subject} =~ s/<OTRS_OWNER_$_>/$OwnerPreferences{$_}/gi;
    }

    # cleanup
    $Notification{Subject} =~ s/<OTRS_OWNER_.+?>/-/gi;
    $Notification{Body} =~ s/${Start}OTRS_OWNER_.+?${End}/-/gi;

    # get responsible data
    my $ResponsibleID = $Article{ResponsibleID};

    # get responsible from ticket if there are no articles
    if ( !$ResponsibleID ) {
        $ResponsibleID = $Ticket{ResponsibleID};
    }

    my %ResponsiblePreferences = $UserObject->GetUserData(
        UserID        => $ResponsibleID,
        NoOutOfOffice => 1,
    );

    # convert values to html to get correct line breaks etc.
    if ( $Notification{Type} =~ m{text\/html} ) {
        KEY:
        for my $Key ( sort keys %ResponsiblePreferences ) {
            next KEY if !$ResponsiblePreferences{$Key};
            $ResponsiblePreferences{$Key} = $HTMLUtilsObject->ToHTML(
                String => $ResponsiblePreferences{$Key},
            );
        }
    }

    KEY:
    for ( sort keys %ResponsiblePreferences ) {
        next KEY if !$ResponsiblePreferences{$_};
        $Notification{Body} =~ s/${Start}OTRS_RESPONSIBLE_$_${End}/$ResponsiblePreferences{$_}/gi;
        $Notification{Subject} =~ s/<OTRS_RESPONSIBLE_$_>/$ResponsiblePreferences{$_}/gi;
    }

    # cleanup
    $Notification{Subject} =~ s/<OTRS_RESPONSIBLE_.+?>/-/gi;
    $Notification{Body} =~ s/${Start}OTRS_RESPONSIBLE_.+?${End}/-/gi;

    # get ref of email params
    my %GetParam = %{ $Param{CustomerMessageParams} };

    # convert values to html to get correct line breaks etc.
    if ( $Notification{Type} =~ m{text\/html} ) {
        KEY:
        for my $Key ( sort keys %GetParam ) {
            next KEY if !$GetParam{$Key};
            $GetParam{$Key} = $HTMLUtilsObject->ToHTML(
                String => $GetParam{$Key},
            );
        }
    }

    KEY:
    for ( sort keys %GetParam ) {

        next KEY if !$GetParam{$_};

        $Notification{Body} =~ s/${Start}OTRS_CUSTOMER_DATA_$_${End}/$GetParam{$_}/gi;
        $Notification{Subject} =~ s/<OTRS_CUSTOMER_DATA_$_>/$GetParam{$_}/gi;
    }

    # get customer data and replace it with <OTRS_CUSTOMER_DATA_...
    if ( $Article{CustomerUserID} ) {

        # get customer user object
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
            User => $Article{CustomerUserID},
        );

        # convert values to html to get correct line breaks etc.
        if ( $Notification{Type} =~ m{text\/html} ) {

            KEY:
            for my $Key ( sort keys %CustomerUser ) {

                next KEY if !$CustomerUser{$Key};

                $CustomerUser{$Key} = $HTMLUtilsObject->ToHTML(
                    String => $CustomerUser{$Key},
                );
            }
        }

        # replace customer stuff with tags
        KEY:
        for ( sort keys %CustomerUser ) {

            next KEY if !$CustomerUser{$_};

            $Notification{Body} =~ s/${Start}OTRS_CUSTOMER_DATA_$_${End}/$CustomerUser{$_}/gi;
            $Notification{Subject} =~ s/<OTRS_CUSTOMER_DATA_$_>/$CustomerUser{$_}/gi;
        }
    }

    # cleanup all not needed <OTRS_CUSTOMER_DATA_ tags
    $Notification{Body} =~ s/${Start}OTRS_CUSTOMER_DATA_.+?${End}/-/gi;
    $Notification{Subject} =~ s/<OTRS_CUSTOMER_DATA_.+?>/-/gi;

    # latest customer and agent article
    my @ArticleBoxAgent = $TicketObject->ArticleGet(
        TicketID      => $Param{TicketID},
        UserID        => $Param{UserID},
        DynamicFields => 0,
    );
    my %ArticleAgent;
    ARTICLE:
    for my $Article ( reverse @ArticleBoxAgent ) {
        next ARTICLE if $Article->{SenderType} ne 'agent';
        %ArticleAgent = %{$Article};
        last ARTICLE;
    }

    # convert values to html to get correct line breaks etc.
    if ( $Notification{Type} =~ m{text\/html} ) {
        KEY:
        for my $Key ( sort keys %ArticleAgent ) {
            next KEY if !$ArticleAgent{$Key};
            $ArticleAgent{$Key} = $HTMLUtilsObject->ToHTML(
                String => $ArticleAgent{$Key},
            );
        }
    }

    my %ArticleContent = (
        'OTRS_CUSTOMER_' => \%Article,
        'OTRS_AGENT_'    => \%ArticleAgent,
    );

    for my $ArticleItem ( sort keys %ArticleContent ) {
        my %Article = %{ $ArticleContent{$ArticleItem} };

        if (%Article) {

            if ( $Article{Body} ) {

                # Use the same line length as HTMLUtils::toAscii to avoid
                #   line length problems.
                $Article{Body} =~ s/(^>.+|.{4,78})(?:\s|\z)/$1\n/gm;
            }

            KEY:
            for my $ArticleKey ( sort keys %Article ) {
                next KEY if !$Article{$ArticleKey};

                $Notification{Body}
                    =~ s/${Start}$ArticleItem$ArticleKey${End}/$Article{$ArticleKey}/gi;
                $Notification{Subject} =~ s/<$ArticleItem$ArticleKey>/$Article{$ArticleKey}/gi;
            }

            # get accounted time
            my $AccountedTime = $TicketObject->ArticleAccountedTimeGet(
                ArticleID => $Article{ArticleID},
            );

            my $MatchString = $ArticleItem . 'TimeUnit';
            $Notification{Body} =~ s/${Start}$MatchString${End}/$AccountedTime/gi;
            $Notification{Subject} =~ s/<$MatchString>/$AccountedTime/gi;

            # prepare subject (insert old subject)
            $Article{Subject} = $TicketObject->TicketSubjectClean(
                TicketNumber => $Article{TicketNumber},
                Subject      => $Article{Subject} || '',
            );

            if ( $Notification{Body} =~ /${Start}$ArticleItem(SUBJECT)\[(.+?)\]${End}/ ) {
                my $SubjectChar = $2;
                my $Subject     = $Article{Subject};
                $Subject =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
                $Notification{Body} =~ s/${Start}$ArticleItem(SUBJECT)\[.+?\]${End}/$Subject/g;
            }
            if ( $Notification{Subject} =~ /<$ArticleItem(SUBJECT)\[(.+?)\]>/ ) {
                my $SubjectChar = $2;
                my $Subject     = $Article{Subject};
                $Subject =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
                $Notification{Subject} =~ s/<$ArticleItem(SUBJECT)\[.+?\]>/$Subject/g;
            }

            $Notification{Subject} = $TicketObject->TicketSubjectBuild(
                TicketNumber => $Article{TicketNumber},
                Subject      => $Notification{Subject} || '',
                Type         => 'New',
            );

            # prepare body (insert old email)
            if ( $Notification{Body} =~ /${Start}$ArticleItem(EMAIL|NOTE|BODY)\[(.+?)\]${End}/g ) {
                my $Line       = $2;
                my @Body       = split( /\n/, $Article{Body} );
                my $NewOldBody = '';
                for ( my $i = 0; $i < $Line; $i++ ) {

                    # 2002-06-14 patch of Pablo Ruiz Garcia
                    # http://lists.otrs.org/pipermail/dev/2002-June/000012.html
                    if ( $#Body >= $i ) {

                        # add no quote char, do it later by using DocumentCleanup()
                        if ( $Notification{Type} =~ m{text\/html} ) {
                            $NewOldBody .= $Body[$i];
                        }

                        # add "> " as quote char
                        else {
                            $NewOldBody .= "> $Body[$i]";
                        }

                        # add new line
                        if ( $i < ( $Line - 1 ) ) {
                            $NewOldBody .= "\n";
                        }
                    }
                }
                chomp $NewOldBody;

                # html quoting of content
                if ( $Notification{Type} =~ m{text\/html} && $NewOldBody ) {

                    # remove trailing new lines
                    for ( 1 .. 10 ) {
                        $NewOldBody =~ s/(<br\/>)\s{0,20}$//gs;
                    }

                    # add quote
                    $NewOldBody = "<blockquote type=\"cite\">$NewOldBody</blockquote>";
                    $NewOldBody = $HTMLUtilsObject->DocumentCleanup(
                        String => $NewOldBody,
                    );
                }

                $Notification{Body}
                    =~ s/${Start}$ArticleItem(EMAIL|NOTE|BODY)\[.+?\]${End}/$NewOldBody/g;
            }
        }

        # cleanup all not needed <OTRS_CUSTOMER_ and <OTRS_AGENT_ tags
        $Notification{Body} =~ s/${Start}$ArticleItem.+?${End}/-/gi;
        $Notification{Subject} =~ s/<$ArticleItem.+?>/-/gi;
    }

    # send notification
    if ( $Recipient{Type} eq 'Agent' ) {

        # get email object
        my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');

        # send notification
        my $From = $ConfigObject->Get('NotificationSenderName') . ' <'
            . $ConfigObject->Get('NotificationSenderEmail') . '>';

        $EmailObject->Send(
            From       => $From,
            To         => $Recipient{Email},
            Subject    => $Notification{Subject},
            MimeType   => $Notification{Type},
            Type       => $Notification{Type},
            Charset    => $Notification{Charset},
            Body       => $Notification{Body},
            Loop       => 1,
            Attachment => $Param{Attachments},
        );

        # write history
        $TicketObject->HistoryAdd(
            TicketID     => $Param{TicketID},
            HistoryType  => 'SendAgentNotification',
            Name         => "\%\%$Notification{Name}\%\%$Recipient{Email}",
            CreateUserID => $Param{UserID},
        );

        # log event
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'info',
            Message  => "Sent agent '$Notification{Name}' notification to '$Recipient{Email}'.",
        );

        # ticket event
        $TicketObject->EventHandler(
            Event => 'ArticleAgentNotification',
            Data  => {
                TicketID => $Param{TicketID},
            },
            UserID => $Param{UserID},
        );
    }
    else {

        # get queue object
        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

        my %Address;

        # set "From" address from Article if exist, otherwise use ticket information, see bug# 9035
        if ( IsHashRefWithData( \%Article ) ) {
            %Address = $QueueObject->GetSystemAddress( QueueID => $Article{QueueID} );
        }
        else {
            %Address = $QueueObject->GetSystemAddress( QueueID => $Ticket{QueueID} );
        }

        my $ArticleType = $Recipient{NotificationArticleType} || 'email-notification-ext';
        my $ArticleID = $TicketObject->ArticleSend(
            ArticleType    => $ArticleType,
            SenderType     => 'system',
            TicketID       => $Param{TicketID},
            HistoryType    => 'SendCustomerNotification',
            HistoryComment => "\%\%$Recipient{Email}",
            From           => "$Address{RealName} <$Address{Email}>",
            To             => $Recipient{Email},
            Subject        => $Notification{Subject},
            Body           => $Notification{Body},
            MimeType       => $Notification{Type},
            Type           => $Notification{Type},
            Charset        => $Notification{Charset},
            UserID         => $Param{UserID},
            Loop           => 1,
            Attachment     => $Param{Attachments},
        );

        # log event
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'info',
            Message  => "Sent customer '$Notification{Name}' notification to '$Recipient{Email}'.",
        );

        # ticket event
        $TicketObject->EventHandler(
            Event => 'ArticleCustomerNotification',
            Data  => {
                TicketID  => $Param{TicketID},
                ArticleID => $Param{ArticleID},
            },
            UserID => $Param{UserID},
        );
    }

    return 1;
}

1;
