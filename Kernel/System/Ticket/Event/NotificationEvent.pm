# --
# Kernel/System/Ticket/Event/NotificationEvent.pm - a event module to send notifications
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: NotificationEvent.pm,v 1.2 2009-05-19 11:08:22 martin Exp $
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
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(ConfigObject TicketObject LogObject UserObject CustomerUserObject SendmailObject QueueObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{NotificationEventObject} = Kernel::System::NotificationEvent->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID Event Config UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if event is affected
    my @IDs = $Self->{NotificationEventObject}->NotificationEventCheck(
        Event  => $Param{Event},
        UserID => 1,
    );

    return 1 if !@IDs;

    # get ticket attribute matches
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID => $Param{TicketID},
        UserID   => $Param{UserID},
    );
    NOTIFICATION:
    for my $ID (@IDs) {
        my %Notification = $Self->{NotificationEventObject}->NotificationGet(
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
        if ( $Param{Event} eq 'ArticleCreate' && $Param{ArticleID} ) {
            my %Article = $Self->{TicketObject}->ArticleGet(
                ArticleID => $Param{ArticleID},
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
            for my $Key ( qw( Subject Body ) ) {
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
        }

        # send notification
        $Self->SendCustomerNotification(
            TicketID              => $Param{TicketID},
            UserID                => $Param{UserID},
            Notification          => \%Notification,
            CustomerMessageParams => {},
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
    my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle( TicketID => $Param{TicketID} );

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
        return;
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
            return;
        }
    }

    # get language and send recipient
    my $Language = $Self->{ConfigObject}->Get('DefaultLanguage') || 'en';
    if ( $Article{CustomerUserID} ) {
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $Article{CustomerUserID},
        );
        if ( $CustomerUser{UserEmail} ) {
            $Article{From} = $CustomerUser{UserEmail};
        }

        # get user language
        if ( $CustomerUser{UserLanguage} ) {
            $Language = $CustomerUser{UserLanguage};
        }
    }

    # check recipients
    if ( !$Article{From} || $Article{From} !~ /@/ ) {
        return;
    }

    # get notification data
    #    my %Notification = $Self->{NotificationObject}->NotificationGet(
    #        Name => $Language . '::Customer::' . $Param{Type},
    #    );
    my %Notification = %{ $Param{Notification} };

    # get notify texts
    for (qw(Subject Body)) {
        if ( !$Notification{$_} ) {
            $Notification{$_} = "No CustomerNotification $_ for $Param{Type} found!";
        }
    }

    # prepare customer realname
    if ( $Notification{Body} =~ /<OTRS_CUSTOMER_REALNAME>/ ) {

        # get realname
        my $From = '';
        if ( $Article{CustomerUserID} ) {
            $From = $Self->{CustomerUserObject}->CustomerName(
                UserLogin => $Article{CustomerUserID},
            );
        }
        if ( !$From ) {
            $From = $Notification{From} || '';
            $From =~ s/<.*>|\(.*\)|\"|;|,//g;
            $From =~ s/( $)|(  $)//g;
        }
        $Notification{Body} =~ s/<OTRS_CUSTOMER_REALNAME>/$From/g;
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
    $Notification{Body} =~ s/<OTRS_QUEUE>/$Param{Queue}/gi if ( $Param{Queue} );

    # ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );
    for ( keys %Ticket ) {
        if ( defined $Ticket{$_} ) {
            $Notification{Body}    =~ s/<OTRS_TICKET_$_>/$Ticket{$_}/gi;
            $Notification{Subject} =~ s/<OTRS_TICKET_$_>/$Ticket{$_}/gi;
        }
    }

    # cleanup
    $Notification{Subject} =~ s/<OTRS_TICKET_.+?>/-/gi;
    $Notification{Body}    =~ s/<OTRS_TICKET_.+?>/-/gi;

    # get current user data
    my %CurrentPreferences = $Self->{UserObject}->GetUserData( UserID => $Param{UserID} );
    for ( keys %CurrentPreferences ) {
        if ( $CurrentPreferences{$_} ) {
            $Notification{Body}    =~ s/<OTRS_CURRENT_$_>/$CurrentPreferences{$_}/gi;
            $Notification{Subject} =~ s/<OTRS_CURRENT_$_>/$CurrentPreferences{$_}/gi;
        }
    }

    # cleanup
    $Notification{Subject} =~ s/<OTRS_CURRENT_.+?>/-/gi;
    $Notification{Body}    =~ s/<OTRS_CURRENT_.+?>/-/gi;

    # get owner data
    my %OwnerPreferences = $Self->{UserObject}->GetUserData( UserID => $Article{OwnerID}, );
    for ( keys %OwnerPreferences ) {
        if ( $OwnerPreferences{$_} ) {
            $Notification{Body}    =~ s/<OTRS_OWNER_$_>/$OwnerPreferences{$_}/gi;
            $Notification{Subject} =~ s/<OTRS_OWNER_$_>/$OwnerPreferences{$_}/gi;
        }
    }

    # cleanup
    $Notification{Subject} =~ s/<OTRS_OWNER_.+?>/-/gi;
    $Notification{Body}    =~ s/<OTRS_OWNER_.+?>/-/gi;

    # get responsible data
    my %ResponsiblePreferences = $Self->{UserObject}->GetUserData(
        UserID => $Article{ResponsibleID},
    );
    for ( keys %ResponsiblePreferences ) {
        if ( $ResponsiblePreferences{$_} ) {
            $Notification{Body}    =~ s/<OTRS_RESPONSIBLE_$_>/$ResponsiblePreferences{$_}/gi;
            $Notification{Subject} =~ s/<OTRS_RESPONSIBLE_$_>/$ResponsiblePreferences{$_}/gi;
        }
    }

    # cleanup
    $Notification{Subject} =~ s/<OTRS_RESPONSIBLE_.+?>/-/gi;
    $Notification{Body}    =~ s/<OTRS_RESPONSIBLE_.+?>/-/gi;

    # get ref of email params
    my %GetParam = %{ $Param{CustomerMessageParams} };
    for ( keys %GetParam ) {
        if ( $GetParam{$_} ) {
            $Notification{Body}    =~ s/<OTRS_CUSTOMER_DATA_$_>/$GetParam{$_}/gi;
            $Notification{Subject} =~ s/<OTRS_CUSTOMER_DATA_$_>/$GetParam{$_}/gi;
        }
    }

    # get customer data and replace it with <OTRS_CUSTOMER_DATA_...
    if ( $Article{CustomerUserID} ) {
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $Article{CustomerUserID},
        );

        # replace customer stuff with tags
        for ( keys %CustomerUser ) {
            if ( $CustomerUser{$_} ) {
                $Notification{Body}    =~ s/<OTRS_CUSTOMER_DATA_$_>/$CustomerUser{$_}/gi;
                $Notification{Subject} =~ s/<OTRS_CUSTOMER_DATA_$_>/$CustomerUser{$_}/gi;
            }
        }
    }

    # cleanup all not needed <OTRS_CUSTOMER_DATA_ tags
    $Notification{Body}    =~ s/<OTRS_CUSTOMER_DATA_.+?>/-/gi;
    $Notification{Subject} =~ s/<OTRS_CUSTOMER_DATA_.+?>/-/gi;

    # latest customer and agent article
    my @ArticleBoxAgent = $Self->{TicketObject}->ArticleGet(
        TicketID => $Param{TicketID},
        UserID         => $Param{UserID},
    );
    my %ArticleAgent;
    for my $Article ( reverse @ArticleBoxAgent ) {
        next if $Article->{SenderType} ne 'agent';
        %ArticleAgent = %{ $Article };
        last;
    }

    my %ArticleContent = (
        'OTRS_CUSTOMER_' => \%Article,
        'OTRS_AGENT_'    => \%ArticleAgent,
    );

    for my $ArticleItem ( sort keys %ArticleContent ) {
        my %Article = %{ $ArticleContent{$ArticleItem} };

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
        if ( $Notification{Subject} =~ /<$ArticleItem(SUBJECT)\[(.+?)\]>/ ) {
            my $SubjectChar = $2;
            $Article{Subject}      =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
            $Notification{Subject} =~ s/<$ArticleItem(SUBJECT)\[.+?\]>/$Article{Subject}/g;
        }
        $Notification{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
            TicketNumber => $Article{TicketNumber},
            Subject => $Notification{Subject} || '',
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

        # cleanup all not needed <OTRS_CUSTOMER_ and <OTRS_AGENT_ tags
        $Notification{Body}    =~ s/<$ArticleItem.+?>/-/gi;
        $Notification{Subject} =~ s/<$ArticleItem.+?>/-/gi;
    }

    # send notify
    my %Address = $Self->{QueueObject}->GetSystemAddress( QueueID => $Article{QueueID} );
    $Self->{TicketObject}->ArticleSend(
        ArticleType    => 'email-notification-ext',
        SenderType     => 'system',
        TicketID       => $Param{TicketID},
        HistoryType    => 'SendCustomerNotification',
        HistoryComment => "\%\%$Article{From}",
        From           => "$Address{RealName} <$Address{Email}>",
        To             => $Article{From},
        Subject        => $Notification{Subject},
        Body           => $Notification{Body},
        MimeType       => 'text/plain',
        Type           => 'text/plain',
        Charset        => $Notification{Charset},
        UserID         => $Param{UserID},
        Loop           => 1,
    );

    # log event
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "Sent customer '$Param{Type}' notification to '$Article{From}'.",
    );

    # ticket event
    $Self->{TicketObject}->TicketEventHandlerPost(
        Event    => 'ArticleCustomerNotification',
        TicketID => $Param{TicketID},
        UserID   => $Param{UserID},
    );

    return 1;
}

1;
