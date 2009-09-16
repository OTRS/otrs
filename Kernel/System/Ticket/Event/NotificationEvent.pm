# --
# Kernel/System/Ticket/Event/NotificationEvent.pm - a event module to send notifications
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: NotificationEvent.pm,v 1.10 2009-09-16 08:59:37 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::NotificationEvent;
use strict;
use warnings;

use Kernel::System::NotificationEvent;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(DBObject ConfigObject TicketObject LogObject TimeObject UserObject CustomerUserObject SendmailObject QueueObject GroupObject MainObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Event Data Config UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    for (qw(TicketID)) {
        if ( !$Param{Data}->{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_ in Data!" );
            return;
        }
    }

    # return of no ticket exists (e. g. it got deleted)
    my $TicketExists = $Self->{TicketObject}->TicketNumberLookup(
        TicketID => $Param{Data}->{TicketID},
        UserID   => $Param{UserID},
    );
    return 1 if !$TicketExists;

    # check if event is affected
    my $NotificationEventObject = Kernel::System::NotificationEvent->new( %{$Self} );
    my @IDs                     = $NotificationEventObject->NotificationEventCheck(
        Event  => $Param{Event},
        UserID => $Param{UserID},
    );

    # return if no notification for event exists
    return 1 if !@IDs;

    # get ticket attribute matches
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID => $Param{Data}->{TicketID},
        UserID   => $Param{UserID},
    );

    NOTIFICATION:
    for my $ID (@IDs) {
        my %Notification = $NotificationEventObject->NotificationGet(
            ID     => $ID,
            UserID => 1,
        );
        next NOTIFICATION if !$Notification{Data};
        for my $Key ( keys %{ $Notification{Data} } ) {

            # ignore not ticket related attributes
            next if $Key eq 'Recipients';
            next if $Key eq 'RecipientAgents';
            next if $Key eq 'RecipientEmail';
            next if $Key eq 'Events';
            next if $Key eq 'ArticleTypeID';
            next if $Key eq 'ArticleSubjectMatch';
            next if $Key eq 'ArticleBodyMatch';
            next if $Key eq 'ArticleAttachmentInclude';

            # check ticket attributes
            next if !$Notification{Data}->{$Key};
            next if !@{ $Notification{Data}->{$Key} };
            next if !$Notification{Data}->{$Key}->[0];
            my $Match = 0;
            VALUE:
            for my $Value ( @{ $Notification{Data}->{$Key} } ) {
                next VALUE if !$Value;
                if ( $Value eq $Ticket{$Key} ) {
                    $Match = 1;
                    last;
                }
            }
            next NOTIFICATION if !$Match;
        }

        # match article types only on ArticleCreate event
        my @Attachments;
        if ( $Param{Event} eq 'ArticleCreate' && $Param{Data}->{ArticleID} ) {
            my %Article = $Self->{TicketObject}->ArticleGet(
                ArticleID => $Param{Data}->{ArticleID},
                UserID    => $Param{UserID},
            );

            # check article type
            if ( $Notification{Data}->{ArticleTypeID} ) {
                my $Match = 0;
                VALUE:
                for my $Value ( @{ $Notification{Data}->{ArticleTypeID} } ) {
                    next VALUE if !$Value;
                    if ( $Value == $Article{ArticleTypeID} ) {
                        $Match = 1;
                        last;
                    }
                }
                next NOTIFICATION if !$Match;
            }

            # check subject & body
            for my $Key (qw( Subject Body )) {
                next if !$Notification{Data}->{ 'Article' . $Key . 'Match' };
                my $Match = 0;
                VALUE:
                for my $Value ( @{ $Notification{Data}->{ 'Article' . $Key . 'Match' } } ) {
                    next VALUE if !$Value;
                    if ( $Article{$Key} =~ /\Q$Value\E/i ) {
                        $Match = 1;
                        last;
                    }
                }
                next NOTIFICATION if !$Match;
            }

            # add attachments to notification
            if ( $Notification{Data}->{ArticleAttachmentInclude} ) {
                my %Index = $Self->{TicketObject}->ArticleAttachmentIndex(
                    ArticleID => $Param{Data}->{ArticleID},
                    UserID    => $Param{UserID},
                );
                if (%Index) {
                    for my $FileID ( sort keys %Index ) {
                        my %Attachment = $Self->{TicketObject}->ArticleAttachment(
                            ArticleID => $Param{Data}->{ArticleID},
                            FileID    => $FileID,
                            UserID    => $Param{UserID},
                        );
                        next if !%Attachment;
                        push @Attachments, \%Attachment;
                    }
                }
            }
        }

        # send notification
        $Self->SendCustomerNotification(
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

sub SendCustomerNotification {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(CustomerMessageParams TicketID UserID Notification)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get old article for quoteing
    my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(
        TicketID => $Param{TicketID},
    );

    # get recipients by Recipients
    my @Recipients;
    if ( $Param{Notification}->{Data}->{Recipients} ) {
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
                    my $GroupID = $Self->{QueueObject}->GetQueueGroupID(
                        QueueID => $Article{QueueID},
                    );
                    my @UserIDs = $Self->{GroupObject}->GroupMemberList(
                        GroupID => $GroupID,
                        Type    => 'rw',
                        Result  => 'ARRAY',
                    );
                    push @{ $Param{Notification}->{Data}->{RecipientAgents} }, @UserIDs;
                }
            }
            elsif ( $Recipient eq 'Customer' ) {
                my %Recipient;

                $Recipient{Email} = $Article{From};
                $Recipient{Type}  = 'Customer';

                # check if customer notifications should be send
                if (
                    $Self->{ConfigObject}->Get('CustomerNotifyJustToRealCustomer')
                    && !$Article{CustomerUserID}
                    )
                {
                    $Self->{LogObject}->Log(
                        Priority => 'notice',
                        Message  => 'Send no customer notification because no customer is set!',
                    );
                    next RECIPIENT;
                }

                # check customer email
                elsif ( $Self->{ConfigObject}->Get('CustomerNotifyJustToRealCustomer') ) {
                    my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        User => $Article{CustomerUserID},
                    );
                    if ( !$CustomerUser{UserEmail} ) {
                        $Self->{LogObject}->Log(
                            Priority => 'notice',
                            Message  => "Send no customer notification because of missing "
                                . "customer email (CustomerUserID=$CustomerUser{CustomerUserID})!",
                        );
                        next RECIPIENT;
                    }
                }

                # get language and send recipient
                $Recipient{Language} = $Self->{ConfigObject}->Get('DefaultLanguage') || 'en';
                if ( $Article{CustomerUserID} ) {
                    my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
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
                    $Recipient{Realname} = $Self->{CustomerUserObject}->CustomerName(
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

    # get recipients by RecipientAgents
    if ( $Param{Notification}->{Data}->{RecipientAgents} ) {
        my %AgentUsed;
        RECIPIENT:
        for my $Recipient ( @{ $Param{Notification}->{Data}->{RecipientAgents} } ) {
            next if $Recipient == 1;
            next if $AgentUsed{$Recipient};
            $AgentUsed{$Recipient} = 1;

            my %User = $Self->{UserObject}->GetUserData(
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

    # get recipients by RecipientEmail
    if ( $Param{Notification}->{Data}->{RecipientEmail} ) {
        if ( $Param{Notification}->{Data}->{RecipientEmail}->[0] ) {
            my %Recipient;
            $Recipient{Realname} = '';
            $Recipient{Type}     = 'Customer';
            $Recipient{Email}    = $Param{Notification}->{Data}->{RecipientEmail}->[0];

            # check recipients
            if ( $Recipient{Email} && $Recipient{Email} =~ /@/ ) {
                push @Recipients, \%Recipient;
            }
        }
    }

    for my $Recipient (@Recipients) {
        $Self->_SendCustomerNotification(
            TicketID              => $Param{TicketID},
            UserID                => $Param{UserID},
            Notification          => $Param{Notification},
            CustomerMessageParams => {},
            Recipient             => $Recipient,
            Event                 => $Param{Event},
            Attachments           => $Param{Attachments},
        );
    }
    return 1;
}

sub _SendCustomerNotification {
    my ( $Self, %Param ) = @_;

    # get notification data
    my %Notification = %{ $Param{Notification} };

    # get recipient data
    my %Recipient = %{ $Param{Recipient} };

    # get old article for quoteing
    my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(
        TicketID => $Param{TicketID},
    );

    # get notify texts
    for (qw(Subject Body)) {
        next if $Notification{$_};
        $Notification{$_} = "No CustomerNotification $_ for $Param{Type} found!";
    }

    # prepare customer realname
    if ( $Notification{Body} =~ /<OTRS_CUSTOMER_REALNAME>/ && $Recipient{Realname} ) {
        $Notification{Body} =~ s/<OTRS_CUSTOMER_REALNAME>/$Recipient{Realname}/g;
    }

    # replace config options
    $Notification{Body}    =~ s{<OTRS_CONFIG_(.+?)>}{$Self->{ConfigObject}->Get($1)}egx;
    $Notification{Subject} =~ s{<OTRS_CONFIG_(.+?)>}{$Self->{ConfigObject}->Get($1)}egx;

    # cleanup
    $Notification{Subject} =~ s/<OTRS_CONFIG_.+?>/-/gi;
    $Notification{Body}    =~ s/<OTRS_CONFIG_.+?>/-/gi;

    # COMPAT
    $Notification{Body} =~ s/<OTRS_TICKET_ID>/$Param{TicketID}/gi;
    $Notification{Body} =~ s/<OTRS_TICKET_NUMBER>/$Article{TicketNumber}/gi;

    # ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );
    for ( keys %Ticket ) {
        next if !defined $Ticket{$_};
        $Notification{Body}    =~ s/<OTRS_TICKET_$_>/$Ticket{$_}/gi;
        $Notification{Subject} =~ s/<OTRS_TICKET_$_>/$Ticket{$_}/gi;
    }

    # cleanup
    $Notification{Subject} =~ s/<OTRS_TICKET_.+?>/-/gi;
    $Notification{Body}    =~ s/<OTRS_TICKET_.+?>/-/gi;

    # get current user data
    my %CurrentPreferences = $Self->{UserObject}->GetUserData( UserID => $Param{UserID} );
    for ( keys %CurrentPreferences ) {
        next if !defined $CurrentPreferences{$_};
        $Notification{Body}    =~ s/<OTRS_CURRENT_$_>/$CurrentPreferences{$_}/gi;
        $Notification{Subject} =~ s/<OTRS_CURRENT_$_>/$CurrentPreferences{$_}/gi;
    }

    # cleanup
    $Notification{Subject} =~ s/<OTRS_CURRENT_.+?>/-/gi;
    $Notification{Body}    =~ s/<OTRS_CURRENT_.+?>/-/gi;

    # get owner data
    my %OwnerPreferences = $Self->{UserObject}->GetUserData( UserID => $Article{OwnerID}, );
    for ( keys %OwnerPreferences ) {
        next if !$OwnerPreferences{$_};
        $Notification{Body}    =~ s/<OTRS_OWNER_$_>/$OwnerPreferences{$_}/gi;
        $Notification{Subject} =~ s/<OTRS_OWNER_$_>/$OwnerPreferences{$_}/gi;
    }

    # cleanup
    $Notification{Subject} =~ s/<OTRS_OWNER_.+?>/-/gi;
    $Notification{Body}    =~ s/<OTRS_OWNER_.+?>/-/gi;

    # get responsible data
    my %ResponsiblePreferences = $Self->{UserObject}->GetUserData(
        UserID => $Article{ResponsibleID},
    );
    for ( keys %ResponsiblePreferences ) {
        next if !$ResponsiblePreferences{$_};
        $Notification{Body}    =~ s/<OTRS_RESPONSIBLE_$_>/$ResponsiblePreferences{$_}/gi;
        $Notification{Subject} =~ s/<OTRS_RESPONSIBLE_$_>/$ResponsiblePreferences{$_}/gi;
    }

    # cleanup
    $Notification{Subject} =~ s/<OTRS_RESPONSIBLE_.+?>/-/gi;
    $Notification{Body}    =~ s/<OTRS_RESPONSIBLE_.+?>/-/gi;

    # get ref of email params
    my %GetParam = %{ $Param{CustomerMessageParams} };
    for ( keys %GetParam ) {
        next if !$GetParam{$_};
        $Notification{Body}    =~ s/<OTRS_CUSTOMER_DATA_$_>/$GetParam{$_}/gi;
        $Notification{Subject} =~ s/<OTRS_CUSTOMER_DATA_$_>/$GetParam{$_}/gi;
    }

    # get customer data and replace it with <OTRS_CUSTOMER_DATA_...
    if ( $Article{CustomerUserID} ) {
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $Article{CustomerUserID},
        );

        # replace customer stuff with tags
        for ( keys %CustomerUser ) {
            next if !$CustomerUser{$_};
            $Notification{Body}    =~ s/<OTRS_CUSTOMER_DATA_$_>/$CustomerUser{$_}/gi;
            $Notification{Subject} =~ s/<OTRS_CUSTOMER_DATA_$_>/$CustomerUser{$_}/gi;
        }
    }

    # cleanup all not needed <OTRS_CUSTOMER_DATA_ tags
    $Notification{Body}    =~ s/<OTRS_CUSTOMER_DATA_.+?>/-/gi;
    $Notification{Subject} =~ s/<OTRS_CUSTOMER_DATA_.+?>/-/gi;

    # latest customer and agent article
    my @ArticleBoxAgent = $Self->{TicketObject}->ArticleGet(
        TicketID => $Param{TicketID},
        UserID   => $Param{UserID},
    );
    my %ArticleAgent;
    for my $Article ( reverse @ArticleBoxAgent ) {
        next if $Article->{SenderType} ne 'agent';
        %ArticleAgent = %{$Article};
        last;
    }

    my %ArticleContent = (
        'OTRS_CUSTOMER_' => \%Article,
        'OTRS_AGENT_'    => \%ArticleAgent,
    );

    for my $ArticleItem ( sort keys %ArticleContent ) {
        my %Article = %{ $ArticleContent{$ArticleItem} };

        if (%Article) {
            if ( $Article{Body} ) {
                $Article{Body} =~ s/(^>.+|.{4,72})(?:\s|\z)/$1\n/gm;
            }
            for ( keys %Article ) {
                next if !$Article{$_};
                $Notification{Body}    =~ s/<$ArticleItem$_>/$Article{$_}/gi;
                $Notification{Subject} =~ s/<$ArticleItem$_>/$Article{$_}/gi;
            }

            # prepare subject (insert old subject)
            $Article{Subject} = $Self->{TicketObject}->TicketSubjectClean(
                TicketNumber => $Article{TicketNumber},
                Subject => $Article{Subject} || '',
            );
            for my $Type (qw(Subject Body)) {
                if ( $Notification{$Type} =~ /<$ArticleItem(SUBJECT)\[(.+?)\]>/ ) {
                    my $SubjectChar = $2;
                    my $Subject     = $Article{Subject};
                    $Subject =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
                    $Notification{$Type} =~ s/<$ArticleItem(SUBJECT)\[.+?\]>/$Subject/g;
                }
            }
            $Notification{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
                TicketNumber => $Article{TicketNumber},
                Subject      => $Notification{Subject} || '',
                Type         => 'New',
            );

            # prepare body (insert old email)
            if ( $Notification{Body} =~ /<$ArticleItem(EMAIL|NOTE|BODY)\[(.+?)\]>/g ) {
                my $Line       = $2;
                my @Body       = split( /\n/, $Article{Body} );
                my $NewOldBody = '';
                for ( my $i = 0; $i < $Line; $i++ ) {

                    # 2002-06-14 patch of Pablo Ruiz Garcia
                    # http://lists.otrs.org/pipermail/dev/2002-June/000012.html
                    if ( $#Body >= $i ) {
                        $NewOldBody .= "> $Body[$i]\n";
                    }
                }
                chomp $NewOldBody;
                $Notification{Body} =~ s/<$ArticleItem(EMAIL|NOTE|BODY)\[.+?\]>/$NewOldBody/g;
            }
        }

        # cleanup all not needed <OTRS_CUSTOMER_ and <OTRS_AGENT_ tags
        $Notification{Body}    =~ s/<$ArticleItem.+?>/-/gi;
        $Notification{Subject} =~ s/<$ArticleItem.+?>/-/gi;
    }

    # send notify
    if ( $Recipient{Type} eq 'Agent' ) {

        # send notify
        my $From = $Self->{ConfigObject}->Get('NotificationSenderName') . ' <'
            . $Self->{ConfigObject}->Get('NotificationSenderEmail') . '>';
        $Self->{SendmailObject}->Send(
            From       => $From,
            To         => $Recipient{Email},
            Subject    => $Notification{Subject},
            MimeType   => 'text/plain',
            Type       => 'text/plain',
            Charset    => $Notification{Charset},
            Body       => $Notification{Body},
            Loop       => 1,
            Attachment => $Param{Attachments},
        );

        # write history
        $Self->{TicketObject}->HistoryAdd(
            TicketID     => $Param{TicketID},
            HistoryType  => 'SendAgentNotification',
            Name         => "\%\%$Notification{Name}\%\%$Recipient{Email}",
            CreateUserID => $Param{UserID},
        );

        # log event
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Sent agent '$Notification{Name}' notification to '$Recipient{Email}'.",
        );

        # ticket event
        $Self->{TicketObject}->EventHandler(
            Event => 'ArticleAgentNotification',
            Data  => {
                TicketID => $Param{TicketID},
            },
            UserID => $Param{UserID},
        );
    }
    else {
        my %Address = $Self->{QueueObject}->GetSystemAddress( QueueID => $Article{QueueID} );
        my $ArticleID = $Self->{TicketObject}->ArticleSend(
            ArticleType    => 'email-notification-ext',
            SenderType     => 'system',
            TicketID       => $Param{TicketID},
            HistoryType    => 'SendCustomerNotification',
            HistoryComment => "\%\%$Recipient{Email}",
            From           => "$Address{RealName} <$Address{Email}>",
            To             => $Recipient{Email},
            Subject        => $Notification{Subject},
            Body           => $Notification{Body},
            MimeType       => 'text/plain',
            Type           => 'text/plain',
            Charset        => $Notification{Charset},
            UserID         => $Param{UserID},
            Loop           => 1,
            Attachment     => $Param{Attachments},
        );

        # log event
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Sent customer '$Notification{Name}' notification to '$Recipient{Email}'.",
        );

        # ticket event
        $Self->{TicketObject}->EventHandler(
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
