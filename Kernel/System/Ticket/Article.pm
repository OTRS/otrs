# --
# Kernel/System/Ticket/Article.pm - global article module for OTRS kernel
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: Article.pm,v 1.230 2009-08-18 19:25:40 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Article;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.230 $) [1];

=head1 NAME

Kernel::System::Ticket::Article - sub module of Kernel::System::Ticket

=head1 SYNOPSIS

All article functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item ArticleCreate()

create an article

    my $ArticleID = $TicketObject->ArticleCreate(
        TicketID         => 123,
        ArticleType      => 'note-internal',                        # email-external|email-internal|phone|fax|...
        SenderType       => 'agent',                                # agent|system|customer
        From             => 'Some Agent <email@example.com>',       # not required but useful
        To               => 'Some Customer A <customer-a@example.com>', # not required but useful
        Cc               => 'Some Customer B <customer-b@example.com>', # not required but useful
        ReplyTo          => 'Some Customer B <customer-b@example.com>', # not required
        Subject          => 'some short description',               # required
        Body             => 'the message text',                     # required
        MessageID        => '<asdasdasd.123@example.com>',          # not required but useful
        InReplyTo        => '<asdasdasd.12@example.com>',           # not required but useful
        References       => '<asdasdasd.1@example.com> <asdasdasd.12@example.com>', # not required but useful
        ContentType      => 'text/plain; charset=ISO-8859-15',      # or optional Charset & MimeType
        HistoryType      => 'OwnerUpdate',                          # EmailCustomer|Move|AddNote|PriorityUpdate|WebRequestCustomer|...
        HistoryComment   => 'Some free text!',
        UserID           => 123,
        NoAgentNotify    => 0,                                      # if you don't want to send agent notifications
        AutoResponseType => 'auto reply'                            # auto reject|auto follow up|auto follow up|auto remove

        ForceNotificationToUserID   => [ 1, 43, 56 ],               # if you want to force somebody
        ExcludeNotificationToUserID => [ 43,56 ],                   # if you want full exclude somebody from notfications,
                                                                    # will also be removed in To: line of article,
                                                                    # higher prio as ForceNotificationToUserID
        ExcludeMuteNotificationToUserID => [ 43,56 ],               # the same as ExcludeNotificationToUserID but only the
                                                                    # sending gets muted, agent will still shown in To:
                                                                    # line of article
    );

example with "Charset & MimeType" and no "ContentType"

    my $ArticleID = $TicketObject->ArticleCreate(
        TicketID         => 123,
        ArticleType      => 'note-internal',                        # email-external|email-internal|phone|fax|...
        SenderType       => 'agent',                                # agent|system|customer
        From             => 'Some Agent <email@example.com>',       # not required but useful
        To               => 'Some Customer A <customer-a@example.com>', # not required but useful
        Subject          => 'some short description',               # required
        Body             => 'the message text',                     # required
        Charset          => 'ISO-8859-15',
        MimeType         => 'text/plain',
        HistoryType      => 'OwnerUpdate',                          # EmailCustomer|Move|AddNote|PriorityUpdate|WebRequestCustomer|...
        HistoryComment   => 'Some free text!',
        UserID           => 123,
    );

=cut

sub ArticleCreate {
    my ( $Self, %Param ) = @_;

    my $ValidID = $Param{ValidID} || 1;
    my $IncomingTime = $Self->{TimeObject}->SystemTime();

    # create ArticleContentPath
    if ( !$Self->{ArticleContentPath} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ArticleContentPath!' );
        return;
    }

    # lockups if no ids!!!
    if ( $Param{ArticleType} && !$Param{ArticleTypeID} ) {
        $Param{ArticleTypeID} = $Self->ArticleTypeLookup( ArticleType => $Param{ArticleType} );
    }
    if ( $Param{SenderType} && !$Param{SenderTypeID} ) {
        $Param{SenderTypeID} = $Self->ArticleSenderTypeLookup( SenderType => $Param{SenderType} );
    }

    # check needed stuff
    for (qw(TicketID UserID ArticleTypeID SenderTypeID HistoryType HistoryComment)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check ContentType vs. Charset & MimeType
    if ( !$Param{ContentType} ) {
        for (qw(Charset MimeType)) {
            if ( !$Param{$_} ) {
                $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
                return;
            }
        }
        $Param{ContentType} = "$Param{MimeType}; charset=$Param{Charset}";
    }
    else {
        for (qw(ContentType)) {
            if ( !$Param{$_} ) {
                $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
                return;
            }
        }
        $Param{Charset} = '';
        if ( $Param{ContentType} =~ /charset=/i ) {
            $Param{Charset} = $Param{ContentType};
            $Param{Charset} =~ s/.+?charset=("|'|)(\w+)/$2/gi;
            $Param{Charset} =~ s/"|'//g;
            $Param{Charset} =~ s/(.+?);.*/$1/g;

        }
        $Param{MimeType} = '';
        if ( $Param{ContentType} =~ /^(\w+\/\w+)/i ) {
            $Param{MimeType} = $1;
            $Param{MimeType} =~ s/"|'//g;
        }
    }

    # add 'no body' if there is no body there!
    my @AttachmentConvert;
    if ( !$Param{Body} ) {
        $Param{Body} = 'No body';
    }

    # process html article
    elsif ( $Param{MimeType} =~ /text\/html/i ) {

        # add html article as attachment
        my $Attach = {
            Content     => $Param{Body},
            ContentType => "text/html; charset=\"$Param{Charset}\"",
            Filename    => 'file-2',
        };
        push @AttachmentConvert, $Attach;

        # get ascii body
        $Param{MimeType} = 'text/plain';
        $Param{ContentType} =~ s/html/plain/i;
        $Param{Body} = $Self->{HTMLUtilsObject}->ToAscii(
            String => $Param{Body},
        );
    }

    # if body isn't text, attach body as attachment (mostly done by OE) :-/
    elsif ( $Param{MimeType} && $Param{MimeType} !~ /\btext\b/i ) {

        # add non text as attachment
        my $FileName = 'unknown';
        if ( $Param{ContentType} =~ /name="(.+?)"/i ) {
            $FileName = $1;
        }
        my $Attach = {
            Content     => $Param{Body},
            ContentType => $Param{ContentType},
            Filename    => $FileName,
        };
        push @{ $Param{Attachment} }, $Attach;

        # set ascii body
        $Param{MimeType}    = 'text/plain';
        $Param{ContentType} = 'text/plain';
        $Param{Body}        = '- no text message => see attachment -';
    }

    # fix some bad stuff from some browsers (Opera)!
    else {
        $Param{Body} =~ s/(\n\r|\r\r\n|\r\n)/\n/g;
    }

    # strip not wanted stuff
    for (qw(From To Cc Subject MessageID InReplyTo References ReplyTo)) {
        if ( defined $Param{$_} ) {
            $Param{$_} =~ s/\n|\r//g;
        }
        else {
            $Param{$_} = '';
        }
    }
    for (qw(InReplyTo References)) {
        next if !$Param{$_};
        $Param{$_} = substr( $Param{$_}, 0, 3800 );
    }

    # do db insert
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO article '
            . '(ticket_id, article_type_id, article_sender_type_id, a_from, a_reply_to, a_to, '
            . 'a_cc, a_subject, a_message_id, a_in_reply_to, a_references, a_body, a_content_type, '
            . 'content_path, valid_id, incoming_time, create_time, create_by, change_time, change_by) '
            . 'VALUES '
            . '(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{TicketID},  \$Param{ArticleTypeID}, \$Param{SenderTypeID},
            \$Param{From},      \$Param{ReplyTo},       \$Param{To},
            \$Param{Cc},        \$Param{Subject},       \$Param{MessageID},
            \$Param{InReplyTo}, \$Param{References},    \$Param{Body},
            \$Param{ContentType}, \$Self->{ArticleContentPath}, \$ValidID,
            \$IncomingTime, \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get article id
    my $ArticleID = $Self->_ArticleGetId(
        TicketID     => $Param{TicketID},
        MessageID    => $Param{MessageID},
        From         => $Param{From},
        Subject      => $Param{Subject},
        IncomingTime => $IncomingTime
    );

    # return if there is not article created
    if ( !$ArticleID ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Can\'t get ArticleID from INSERT!',
        );
        return;
    }

    # add converted attachments
    for my $Attachment (@AttachmentConvert) {
        $Self->ArticleWriteAttachment(
            %{$Attachment},
            ArticleID => $ArticleID,
            UserID    => $Param{UserID},
        );
    }

    # add attachments
    if ( $Param{Attachment} ) {
        for my $Attachment ( @{ $Param{Attachment} } ) {
            $Self->ArticleWriteAttachment(
                %{$Attachment},
                ArticleID => $ArticleID,
                UserID    => $Param{UserID},
            );
        }
    }

    # add history row
    $Self->HistoryAdd(
        ArticleID    => $ArticleID,
        TicketID     => $Param{TicketID},
        CreateUserID => $Param{UserID},
        HistoryType  => $Param{HistoryType},
        Name         => $Param{HistoryComment},
    );

    # ticket event
    $Self->TicketEventHandlerPost(
        Event     => 'ArticleCreate',
        ArticleID => $ArticleID,
        TicketID  => $Param{TicketID},
        UserID    => $Param{UserID},
    );

    # reset escalation if needed
    if ( !$Param{SenderType} ) {
        $Param{SenderType} = $Self->ArticleSenderTypeLookup( SenderTypeID => $Param{SenderTypeID} );
    }
    if ( !$Param{ArticleType} ) {
        $Param{ArticleType} = $Self->ArticleTypeLookup( ArticleTypeID => $Param{ArticleTypeID} );
    }

    # reset escalation time if customer send an update
    if ( $Param{SenderType} eq 'customer' ) {

        # check if latest article comes from customer
        my $LastSender = '';
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT ast.name FROM article art, article_sender_type ast WHERE '
                . ' art.ticket_id = ? AND art.id NOT IN (?) AND '
                . ' art.article_sender_type_id = ast.id ORDER BY art.create_time ASC',
            Bind => [ \$Param{TicketID}, \$ArticleID ],
        );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            if ( $Row[0] ne 'system' ) {
                $LastSender = $Row[0];
            }
        }
        if ( $LastSender eq 'agent' ) {
            $Self->TicketUnlockTimeoutUpdate(
                UnlockTimeout => $Self->{TimeObject}->SystemTime(),
                TicketID      => $Param{TicketID},
                UserID        => $Param{UserID},
            );
        }
    }

    # check if latest article is sent to customer
    elsif (
        $Param{SenderType} eq 'agent'
        && $Param{ArticleType} =~ /email-ext|phone|fax|sms|note-ext/
        )
    {
        $Self->TicketUnlockTimeoutUpdate(
            UnlockTimeout => $Self->{TimeObject}->SystemTime(),
            TicketID      => $Param{TicketID},
            UserID        => $Param{UserID},
        );
    }

    # send auto response
    if ( $Param{AutoResponseType} ) {
        $Self->SendAutoResponse(
            OrigHeader       => $Param{OrigHeader},
            TicketID         => $Param{TicketID},
            UserID           => $Param{UserID},
            AutoResponseType => $Param{AutoResponseType},
        );
    }

    # send no agent notification!?
    return $ArticleID if $Param{NoAgentNotify};

    my %Ticket = $Self->TicketGet( TicketID => $Param{TicketID} );

    # remember already sent agent notifications
    my %AlreadySent = ();

    # remember agent to exclude notifications
    my %DoNotSend = ();
    if ( $Param{ExcludeNotificationToUserID} && ref $Param{ExcludeNotificationToUserID} eq 'ARRAY' )
    {
        for my $UserID ( @{ $Param{ExcludeNotificationToUserID} } ) {
            $DoNotSend{$UserID} = 1;
        }
    }

    # remember agent to exclude notifications / already sent
    my %DoNotSendMute = ();
    if (
        $Param{ExcludeMuteNotificationToUserID}
        && ref $Param{ExcludeMuteNotificationToUserID} eq 'ARRAY'
        )
    {
        for my $UserID ( @{ $Param{ExcludeMuteNotificationToUserID} } ) {
            $DoNotSendMute{$UserID} = 1;
        }
    }

    # send agent notification on ticket create
    if (
        $Param{HistoryType}
        =~ /^(EmailAgent|EmailCustomer|PhoneCallCustomer|WebRequestCustomer|SystemRequest)$/i
        )
    {
        for my $UserID ( $Self->GetSubscribedUserIDsByQueueID( QueueID => $Ticket{QueueID} ) ) {

            # do not send to this user
            next if $DoNotSend{$UserID};

            # check if alreay sent
            next if $AlreadySent{$UserID};

            # check personal settings
            my %UserData = $Self->{UserObject}->GetUserData(
                UserID => $UserID,
                Cached => 1,
                Valid  => 1,
            );
            next if !$UserData{UserSendNewTicketNotification};

            # remember to have sent
            $AlreadySent{$UserID} = 1;

            # do not send to this user (mute)
            next if $DoNotSendMute{$UserID};

            # send notification
            $Self->SendAgentNotification(
                Type                  => $Param{HistoryType},
                RecipientID           => $UserID,
                CustomerMessageParams => {%Param},
                TicketID              => $Param{TicketID},
                Queue                 => $Param{Queue},
                UserID                => $Param{UserID},
            );
        }
    }

    # send agent notification on adding a note
    elsif ( $Param{HistoryType} =~ /^AddNote$/i ) {

        # send notification to owner/responsible/watcher
        my @UserIDs = $Ticket{OwnerID};
        if ( $Self->{ConfigObject}->Get('Ticket::Responsible') ) {
            push @UserIDs, $Ticket{ResponsibleID};
        }
        push @UserIDs, $Self->TicketWatchGet(
            TicketID => $Param{TicketID},
            Notify   => 1,
            Result   => 'ARRAY',
        );
        for my $UserID (@UserIDs) {
            next if !$UserID;
            next if $UserID == 1;
            next if $UserID eq $Param{UserID};

            # do not send to this user
            next if $DoNotSend{$UserID};

            # check if alreay sent
            next if $AlreadySent{$UserID};

            # remember already sent info
            $AlreadySent{$UserID} = 1;

            # do not send to this user (mute)
            next if $DoNotSendMute{$UserID};

            # send notification
            $Self->SendAgentNotification(
                Type                  => $Param{HistoryType},
                RecipientID           => $UserID,
                CustomerMessageParams => {%Param},
                TicketID              => $Param{TicketID},
                Queue                 => $Param{Queue},
                UserID                => $Param{UserID},
            );
        }
    }

    # send agent notification on follow up
    elsif ( $Param{HistoryType} =~ /^FollowUp$/i ) {

        # send agent notification to all agents or only to owner
        if ( $Ticket{OwnerID} == 1 || $Ticket{Lock} eq 'unlock' ) {
            my @OwnerIDs;
            if ( $Self->{ConfigObject}->Get('PostmasterFollowUpOnUnlockAgentNotifyOnlyToOwner') ) {
                @OwnerIDs = ( $Ticket{OwnerID} );
            }
            else {
                @OwnerIDs = $Self->GetSubscribedUserIDsByQueueID( QueueID => $Ticket{QueueID} );
                push @OwnerIDs, $Self->TicketWatchGet(
                    TicketID => $Param{TicketID},
                    Notify   => 1,
                    Result   => 'ARRAY',
                );
            }
            for my $UserID (@OwnerIDs) {
                next if !$UserID;
                next if $UserID == 1;
                next if $UserID eq $Param{UserID};

                # do not send to this user
                next if $DoNotSend{$UserID};

                # check if alreay sent
                next if $AlreadySent{$UserID};

                # check personal settings
                my %UserData = $Self->{UserObject}->GetUserData(
                    UserID => $UserID,
                    Cached => 1,
                    Valid  => 1,
                );
                next if !$UserData{UserSendFollowUpNotification};

                # remember already sent info
                $AlreadySent{$UserID} = 1;

                # do not send to this user (mute)
                next if $DoNotSendMute{$UserID};

                # send notification
                $Self->SendAgentNotification(
                    Type                  => $Param{HistoryType},
                    RecipientID           => $UserID,
                    CustomerMessageParams => {%Param},
                    TicketID              => $Param{TicketID},
                    Queue                 => $Param{Queue},
                    UserID                => $Param{UserID},
                );
            }
        }

        # send owner/responsible/watcher notification the agents who locked the ticket
        else {
            my @UserIDs = $Ticket{OwnerID};
            if ( $Self->{ConfigObject}->Get('Ticket::Responsible') ) {
                push @UserIDs, $Ticket{ResponsibleID};
            }
            push @UserIDs, $Self->TicketWatchGet(
                TicketID => $Param{TicketID},
                Notify   => 1,
                Result   => 'ARRAY',
            );
            for my $UserID (@UserIDs) {
                next if !$UserID;
                next if $UserID == 1;
                next if $UserID eq $Param{UserID};

                # do not send to this user
                next if $DoNotSend{$UserID};

                # check if alreay sent
                next if $AlreadySent{$UserID};

                # check personal settings
                my %UserData = $Self->{UserObject}->GetUserData(
                    UserID => $UserID,
                    Cached => 1,
                    Valid  => 1,
                );
                next if !$UserData{UserSendFollowUpNotification};

                # remember already sent info
                $AlreadySent{$UserID} = 1;

                # do not send to this user (mute)
                next if $DoNotSendMute{$UserID};

                # send notification
                $Self->SendAgentNotification(
                    Type                  => $Param{HistoryType},
                    RecipientID           => $UserID,
                    CustomerMessageParams => {%Param},
                    TicketID              => $Param{TicketID},
                    Queue                 => $Param{Queue},
                    UserID                => $Param{UserID},
                );
            }

            # send the rest of agents follow ups
            for my $UserID ( $Self->GetSubscribedUserIDsByQueueID( QueueID => $Ticket{QueueID} ) ) {
                next if !$UserID;
                next if $UserID == 1;
                next if $UserID eq $Param{UserID};

                # do not send to this user
                next if $DoNotSend{$UserID};

                # check if alreay sent
                next if $AlreadySent{$UserID};

                # check personal settings
                my %UserData = $Self->{UserObject}->GetUserData(
                    UserID => $UserID,
                    Cached => 1,
                    Valid  => 1,
                );
                if (
                    $UserData{UserSendFollowUpNotification}
                    && $UserData{UserSendFollowUpNotification} == 2
                    && $Ticket{OwnerID} ne 1
                    && $Ticket{OwnerID} ne $Param{UserID}
                    && $Ticket{OwnerID} ne $UserData{UserID}
                    )
                {

                    # remember already sent info
                    $AlreadySent{$UserID} = 1;

                    # do not send to this user (mute)
                    next if $DoNotSendMute{$UserID};

                    # send notification
                    $Self->SendAgentNotification(
                        Type                  => $Param{HistoryType},
                        RecipientID           => $UserID,
                        CustomerMessageParams => {%Param},
                        TicketID              => $Param{TicketID},
                        Queue                 => $Param{Queue},
                        UserID                => $Param{UserID},
                    );
                }
            }
        }
    }

    # send forced notifications
    if ( $Param{ForceNotificationToUserID} && ref $Param{ForceNotificationToUserID} eq 'ARRAY' ) {
        for my $UserID ( @{ $Param{ForceNotificationToUserID} } ) {

            # do not send to this user
            next if $DoNotSend{$UserID};

            # check if alreay sent
            next if $AlreadySent{$UserID};

            # remember already sent info
            $AlreadySent{$UserID} = 1;

            # do not send to this user (mute)
            next if $DoNotSendMute{$UserID};

            # send notification
            $Self->SendAgentNotification(
                Type                  => $Param{HistoryType},
                RecipientID           => $UserID,
                CustomerMessageParams => {%Param},
                TicketID              => $Param{TicketID},
                UserID                => $Param{UserID},
            );
        }
    }

    # update note to: field
    if (%AlreadySent) {
        if ( !$Param{ArticleType} ) {
            $Param{ArticleType} = $Self->ArticleTypeLookup(
                ArticleTypeID => $Param{ArticleTypeID},
            );
        }
        if ( $Param{ArticleType} =~ /^note\-/ && $Param{UserID} ne 1 ) {
            my $NewTo = $Param{To} || '';
            for my $UserID ( keys %AlreadySent ) {
                my %UserData = $Self->{UserObject}->GetUserData(
                    UserID => $UserID,
                    Cached => 1,
                    Valid  => 1,
                );
                if ($NewTo) {
                    $NewTo .= ', ';
                }
                $NewTo .= "$UserData{UserFirstname} $UserData{UserLastname} <$UserData{UserEmail}>";
            }
            if ($NewTo) {
                $Self->{DBObject}->Do(
                    SQL => 'UPDATE article SET a_to = ? WHERE id = ?',
                    Bind => [ \$NewTo, \$ArticleID ],
                );
            }
        }
    }

    # return ArticleID
    return $ArticleID;
}

# just for internal use
sub _ArticleGetId {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID MessageID From Subject IncomingTime)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql query
    my @Bind = ( \$Param{TicketID} );
    my $SQL  = 'SELECT id FROM article WHERE ticket_id = ? AND ';
    if ( $Param{MessageID} ) {
        $SQL .= 'a_message_id = ? AND ';
        push @Bind, \$Param{MessageID};
    }
    if ( $Param{From} ) {
        $SQL .= 'a_from = ? AND ';
        push @Bind, \$Param{From};
    }
    if ( $Param{Subject} ) {
        $SQL .= 'a_subject = ? AND ';
        push @Bind, \$Param{Subject};
    }
    $SQL .= ' incoming_time = ?';
    push @Bind, \$Param{IncomingTime};

    # start query
    return if !$Self->{DBObject}->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );
    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    return $ID;
}

=item ArticleGetTicketIDOfMessageID()

get ticket id of given message id

    my $TicketID = $TicketObject->ArticleGetTicketIDOfMessageID(
        MessageID=> '<13231231.1231231.32131231@example.com>',
    );

=cut

sub ArticleGetTicketIDOfMessageID {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{MessageID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need MessageID!' );
        return;
    }

    # sql query
    return if !$Self->{DBObject}->Prepare(
        SQL   => 'SELECT ticket_id FROM article WHERE a_message_id = ?',
        Bind  => [ \$Param{MessageID} ],
        Limit => 10,
    );
    my $TicketID;
    my $Count = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Count++;
        $TicketID = $Row[0];
    }

    # no reference found
    return if $Count == 0;

    # one found
    return $TicketID if $Count == 1;

    # more the one found! that should not be, a message_id should be uniq!
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "The MessageID '$Param{MessageID}' is in your database "
            . "more the one time! That should not be, a message_id should be uniq!",
    );
    return;
}

=item ArticleGetContentPath()

get article content path

    my $Path = $TicketObject->ArticleGetContentPath(
        ArticleID => 123,
    );

=cut

sub ArticleGetContentPath {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ArticleID!' );
        return;
    }

    # check cache
    my $CacheKey = 'ArticleGetContentPath::' . $Param{ArticleID};
    if ( $Self->{$CacheKey} ) {
        return $Self->{$CacheKey};
    }

    # sql query
    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT content_path FROM article WHERE id = ?',
        Bind => [ \$Param{ArticleID} ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Self->{$CacheKey} = $Row[0];
    }

    # return
    return $Self->{$CacheKey};
}

=item ArticleSenderTypeList()

get a article sender type list

    my @ArticleSenderTypeList = $TicketObject->ArticleSenderTypeList(
        Result => 'ARRAY', # optional, ARRAY|HASH
    );

=cut

sub ArticleSenderTypeList {
    my ( $Self, %Param ) = @_;

    return if !$Self->{DBObject}->Prepare(
        SQL => "SELECT id, name FROM article_sender_type WHERE "
            . "valid_id IN (${\(join ', ', $Self->{ValidObject}->ValidIDsGet())})",
    );

    my @Array = ();
    my %Hash;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @Array, $Row[1];
        $Hash{ $Row[0] } = $Row[1];
    }
    if ( $Param{Result} && $Param{Result} eq 'HASH' ) {
        return %Hash;
    }
    return @Array;

}

=item ArticleSenderTypeLookup()

article sender lookup

    my $SenderTypeID = $TicketObject->ArticleSenderTypeLookup(
        SenderType => 'customer', # customer|system|agent
    );

    my $SenderType = $TicketObject->ArticleSenderTypeLookup(
        SenderTypeID => 1,
    );

=cut

sub ArticleSenderTypeLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{SenderType} && !$Param{SenderTypeID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need SenderType or SenderTypeID!',
        );
        return;
    }

    # get key
    my $Key;
    my $CacheKey;
    if ( $Param{SenderType} ) {
        $Key      = $Param{SenderType};
        $CacheKey = 'ArticleSenderTypeLookup::' . $Param{SenderType};
    }
    else {
        $Key      = $Param{SenderTypeID};
        $CacheKey = 'ArticleSenderTypeLookup::' . $Param{SenderTypeID};
    }

    # check if we ask the same request?
    if ( $Self->{$CacheKey} ) {
        return $Self->{$CacheKey};
    }

    # get data
    if ( $Param{SenderType} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL  => 'SELECT id FROM article_sender_type WHERE name = ?',
            Bind => [ \$Param{SenderType} ],
        );
    }
    else {
        return if !$Self->{DBObject}->Prepare(
            SQL  => 'SELECT name FROM article_sender_type WHERE id = ?',
            Bind => [ \$Param{SenderTypeID} ],
        );
    }

    # store result
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Self->{$CacheKey} = $Row[0];
    }

    # check if data exists
    if ( !$Self->{$CacheKey} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Found no SenderType(ID) for $Key!",
        );
        return;
    }

    # return
    return $Self->{$CacheKey};
}

=item ArticleTypeLookup()

article type lookup

    my $ArticleTypeID = $TicketObject->ArticleTypeLookup(
        ArticleType => 'webrequest-customer', # note-internal|...
    );

    my $ArticleType = $TicketObject->ArticleTypeLookup(
        ArticleTypeID => 1,
    );

=cut

sub ArticleTypeLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleType} && !$Param{ArticleTypeID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ArticleType or ArticleTypeID!',
        );
        return;
    }

    # get key
    my $Key;
    my $CacheKey;
    if ( $Param{ArticleType} ) {
        $Key      = $Param{ArticleType};
        $CacheKey = 'ArticleTypeLookup::' . $Param{ArticleType};
    }
    else {
        $Key      = $Param{ArticleTypeID};
        $CacheKey = 'ArticleTypeLookup::' . $Param{ArticleTypeID};
    }

    # check if we ask the same request (cache)?
    if ( $Self->{$CacheKey} ) {
        return $Self->{$CacheKey};
    }

    # get data
    if ( $Param{ArticleType} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL  => 'SELECT id FROM article_type WHERE name = ?',
            Bind => [ \$Param{ArticleType} ],
        );
    }
    else {
        return if !$Self->{DBObject}->Prepare(
            SQL  => 'SELECT name FROM article_type WHERE id = ?',
            Bind => [ \$Param{ArticleTypeID} ],
        );
    }

    # store result
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Self->{$CacheKey} = $Row[0];
    }

    # check if data exists
    if ( !$Self->{$CacheKey} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Found no ArticleType(ID) for $Key!",
        );
        return;
    }

    # return
    return $Self->{$CacheKey};
}

=item ArticleTypeList()

get a article type list

    my @ArticleTypeList = $TicketObject->ArticleTypeList(
        Result => 'ARRAY', # optional, ARRAY|HASH
    );

    # to get just customer shown article types
    my @ArticleTypeList = $TicketObject->ArticleTypeList(
        Result => 'ARRAY',    # optional, ARRAY|HASH
        Type   => 'Customer', # optional to get only customer viewable article types
    );

=cut

sub ArticleTypeList {
    my ( $Self, %Param ) = @_;

    return if !$Self->{DBObject}->Prepare(
        SQL => "SELECT id, name FROM article_type WHERE "
            . "valid_id IN (${\(join ', ', $Self->{ValidObject}->ValidIDsGet())})",
    );
    my @Array;
    my %Hash;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        if ( $Param{Type} && $Param{Type} eq 'Customer' ) {
            if ( $Row[1] !~ /int/i ) {
                push @Array, $Row[1];
                $Hash{ $Row[0] } = $Row[1];
            }
        }
        else {
            push @Array, $Row[1];
            $Hash{ $Row[0] } = $Row[1];
        }
    }
    if ( $Param{Result} && $Param{Result} eq 'HASH' ) {
        return %Hash;
    }
    return @Array;
}

=item ArticleFreeTextGet()

get _possible_ article free text options

Note: the current value is accessible over ArticleGet()

    my $HashRef = $TicketObject->ArticleFreeTextGet(
        Type      => 'ArticleFreeText3',
        ArticleID => 123,
        UserID    => 123, # or CustomerUserID
    );

    my $HashRef = $TicketObject->ArticleFreeTextGet(
        Type   => 'ArticleFreeText3',
        UserID => 123, # or CustomerUserID
    );

    # fill up with existing values
    my $HashRef = $TicketObject->ArticleFreeTextGet(
        Type   => 'ArticleFreeText3',
        FillUp => 1,
        UserID => 123, # or CustomerUserID
    );

=cut

sub ArticleFreeTextGet {
    my ( $Self, %Param ) = @_;

    my $Value = $Param{Value} || '';
    my $Key   = $Param{Key}   || '';

    # check needed stuff
    for (qw(Type)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    if ( !$Param{UserID} && !$Param{CustomerUserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need UserID or CustomerUserID!" );
        return;
    }

    # get config
    my %Data = ();
    if ( ref $Self->{ConfigObject}->Get( $Param{Type} ) eq 'HASH' ) {
        %Data = %{ $Self->{ConfigObject}->Get( $Param{Type} ) };
    }

    # check existing
    if ( $Param{FillUp} ) {
        my $Counter = $Param{Type};
        $Counter =~ s/^.*(\d)$/$1/;
        if ( %Data && $Param{Type} =~ /text/i ) {
            $Self->{DBObject}->Prepare( SQL => "SELECT distinct(a_freetext$Counter) FROM article" );
            while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
                if ( $Row[0] && !$Data{ $Row[0] } ) {
                    $Data{ $Row[0] } = $Row[0];
                }
            }
        }
        elsif (%Data) {
            $Self->{DBObject}->Prepare( SQL => "SELECT distinct(a_freekey$Counter) FROM article" );
            while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
                if ( $Row[0] && !$Data{ $Row[0] } ) {
                    $Data{ $Row[0] } = $Row[0];
                }
            }
        }
    }

    # workflow
    if (
        $Self->TicketAcl(
            %Param,
            ReturnType    => 'Ticket',
            ReturnSubType => $Param{Type},
            Data          => \%Data,
        )
        )
    {
        my %Hash = $Self->TicketAclData();
        return \%Hash;
    }

    # /workflow
    if (%Data) {
        return \%Data;
    }
    else {
        return;
    }
}

=item ArticleFreeTextSet()

set article free text

    $TicketObject->ArticleFreeTextSet(
        TicketID  => 123,
        ArticleID => 1234,
        Counter   => 1,
        Key       => 'Planet',
        Value     => 'Sun',
        UserID    => 123,
    );

=cut

sub ArticleFreeTextSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID ArticleID UserID Counter)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote for key an value
    $Param{Value} = $Self->{DBObject}->Quote( $Param{Value} ) || '';
    $Param{Key}   = $Self->{DBObject}->Quote( $Param{Key} )   || '';
    for (qw(Counter)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # db update
    return if !$Self->{DBObject}->Do(
        SQL => "UPDATE article SET a_freekey$Param{Counter} = ?, "
            . " a_freetext$Param{Counter} = ?, "
            . " change_time = current_timestamp, change_by = ? "
            . " WHERE id = ?",
        Bind => [ \$Param{Key}, \$Param{Value}, \$Param{UserID}, \$Param{ArticleID} ],
    );

    # ticket event
    $Self->TicketEventHandlerPost(
        Event     => 'ArticleFreeTextUpdate',
        TicketID  => $Param{TicketID},
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );
    return 1;
}

=item ArticleLastCustomerArticle()

get last customer article

    my %Article = $TicketObject->ArticleLastCustomerArticle(
        TicketID => 123,
    );

=cut

sub ArticleLastCustomerArticle {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need TicketID!" );
        return;
    }

    # get article index
    my @Index = $Self->ArticleIndex( TicketID => $Param{TicketID}, SenderType => 'customer' );

    # get article data
    if (@Index) {
        return $Self->ArticleGet( ArticleID => $Index[-1], Extended => $Param{Extended} );
    }

    # get whole article index
    @Index = $Self->ArticleIndex( TicketID => $Param{TicketID} );
    if ( !@Index ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No article found for TicketID $Param{TicketID}!",
        );
        return;
    }

    # second try, return latest non internal article
    for my $ArticleID ( reverse @Index ) {
        my %Article = $Self->ArticleGet( ArticleID => $ArticleID );
        if ( $Article{StateType} eq 'merged' || $Article{ArticleType} !~ /int/ ) {
            return %Article;
        }
    }

    # third try, if we got no internal article, return the latest one
    return $Self->ArticleGet( ArticleID => $Index[-1] );
}

=item ArticleFirstArticle()

get first article

    my %Article = $TicketObject->ArticleFirstArticle(
        TicketID => 123,
    );

=cut

sub ArticleFirstArticle {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need TicketID!" );
        return;
    }

    # get article index
    my @Index = $Self->ArticleIndex( TicketID => $Param{TicketID} );

    # get article data
    if ( !@Index ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No article found for TicketID $Param{TicketID}!",
        );
        return;
    }
    return $Self->ArticleGet( ArticleID => $Index[0], Extended => $Param{Extended} );
}

=item ArticleIndex()

returns an array with article id's

    my @ArticleIDs = $TicketObject->ArticleIndex(
        TicketID => 123,
    );

    my @ArticleIDs = $TicketObject->ArticleIndex(
        SenderType => 'customer',
        TicketID   => 123,
    );

=cut

sub ArticleIndex {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need TicketID!' );
        return;
    }

    # db query
    if ( $Param{SenderType} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT art.id FROM article art, article_sender_type ast WHERE '
                . 'art.ticket_id = ? AND art.article_sender_type_id = ast.id AND '
                . 'ast.name = ? ORDER BY art.id',
            Bind => [ \$Param{TicketID}, \$Param{SenderType} ],
        );
    }
    else {
        return if !$Self->{DBObject}->Prepare(
            SQL  => 'SELECT id FROM article WHERE ticket_id = ? ORDER BY id',
            Bind => [ \$Param{TicketID} ],
        );
    }

    my @Index;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @Index, $Row[0];
    }
    return @Index;
}

=item ArticleContentIndex()

returns an array with hash ref (hash contains result of ArticleGet())

    my @ArticleBox = $TicketObject->ArticleContentIndex(
        TicketID => 123,
    );

or with StripPlainBodyAsAttachment feature to not include
first attachment / body as attachment

    my @ArticleBox = $TicketObject->ArticleContentIndex(
        TicketID                   => 123,
        StripPlainBodyAsAttachment => 1,
    );

returns an array with hash ref (hash contains result of ArticleGet())
only with given article types

    my @ArticleBox = $TicketObject->ArticleContentIndex(
        TicketID    => 123,
        ArticleType => [ $ArticleType1, $ArticleType2 ],
    );

examplie how to access the hash ref

    for my $Article (@ArticleBox) {
        print "From: $Article->{From}\n";
    }

Note: If a attachment with html body content is available, the attachment id
it's given as 'AttachmentIDOfHTMLBody' in hash ref.

=cut

sub ArticleContentIndex {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need TicketID!' );
        return;
    }
    my @ArticleBox = $Self->ArticleGet(
        TicketID    => $Param{TicketID},
        ArticleType => $Param{ArticleType},
    );

    # article attachments of each article
    for my $Article (@ArticleBox) {

        # get attachment index (without attachments)
        my %AtmIndex = $Self->ArticleAttachmentIndex(
            ContentPath => $Article->{ContentPath},
            ArticleID   => $Article->{ArticleID},
        );

        # stript plain attachments and e. g. html attachments
        if ( $Param{StripPlainBodyAsAttachment} ) {

            # plain attachment mime type vs. html attachment mime type check
            # remove plain body, rename html attachment
            my $AttachmentIDPlain = 0;
            my $AttachmentIDHTML  = 0;
            for my $AttachmentID ( keys %AtmIndex ) {
                my %File = %{ $AtmIndex{$AttachmentID} };
                if (
                    $File{Filename} eq 'file-1'
                    && $File{ContentType} =~ /text\/plain/i
                    )
                {
                    $AttachmentIDPlain = $AttachmentID;
                }
                if (
                    $File{Filename} =~ /^file-[12]$/
                    && $File{ContentType} =~ /text\/html/i
                    )
                {
                    $AttachmentIDHTML = $AttachmentID;
                }
            }
            if ($AttachmentIDHTML) {
                delete $AtmIndex{$AttachmentIDPlain};
                delete $AtmIndex{$AttachmentIDHTML};
                $Article->{AttachmentIDOfHTMLBody} = $AttachmentIDHTML;
            }

            # plain body size vs. attched body size check
            # and remove attachment if it's email body
            if ( !$AttachmentIDHTML ) {
                my $AttachmentIDPlain = 0;
                my %AttachmentFilePlain;
                for my $AttachmentID ( keys %AtmIndex ) {
                    my %File = %{ $AtmIndex{$AttachmentID} };

                    # remember, file-1 got defined by parsing if no filename was given
                    if (
                        $File{Filename} eq 'file-1'
                        && $File{ContentType} =~ /text\/plain/i
                        )
                    {
                        $AttachmentIDPlain   = $AttachmentID;
                        %AttachmentFilePlain = %File;
                        last;
                    }
                }

                # plain attachment detected and remove it from attachment index
                if (%AttachmentFilePlain) {

                    # check body size vs. attachment size to be sure
                    my $BodySize = 0;
                    {
                        use bytes;
                        $BodySize = length $Article->{Body};
                        no bytes;
                    }

                    # check size by tolerance of 1.1 factor (because of charset difs)
                    if (
                        $BodySize / 1.1 < $AttachmentFilePlain{FilesizeRaw}
                        && $BodySize * 1.1 > $AttachmentFilePlain{FilesizeRaw}
                        )
                    {
                        delete $AtmIndex{$AttachmentIDPlain};
                    }
                }
            }

        }
        $Article->{Atms} = \%AtmIndex;
    }
    return @ArticleBox;
}

=item ArticleGet()

returns article data

    my %Article = $TicketObject->ArticleGet(
        ArticleID => 123,
        UserID    => 123,
    );

Article:
    ArticleID
    From
    To
    Cc
    Subject
    Body
    ReplyTo
    MessageID
    InReplyTo
    References
    SenderType
    SenderTypeID
    ArticleType
    ArticleTypeID
    ContentType
    Charset
    MimeType
    IncomingTime
    ArticleFreeKey1-3
    ArticleFreeText-3

Ticket:
    - see TicketGet() for ticket attributes-

returns articles in array / hash by given ticket id

    my @ArticleIndex = $TicketObject->ArticleGet(
        TicketID => 123,
        UserID   => 123,
    );

returns articles in array / hash by given ticket id but
only requestet article types

    my @ArticleIndex = $TicketObject->ArticleGet(
        TicketID    => 123,
        ArticleType => [ $ArticleType1, $ArticleType2 ],
        UserID      => 123,
    );

to get extended ticket attributes, use param Extended - see TicketGet() for extended attributes -

    my @ArticleIndex = $TicketObject->ArticleGet(
        TicketID => 123,
        UserID   => 123,
        Extended => 1,
    );

=cut

sub ArticleGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} && !$Param{TicketID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ArticleID or TicketID!' );
        return;
    }

    # article type lookup
    my $ArticleTypeSQL = '';
    if ( $Param{ArticleType} && ref $Param{ArticleType} eq 'ARRAY' ) {
        for ( @{ $Param{ArticleType} } ) {
            if ( $Self->ArticleTypeLookup( ArticleType => $_ ) ) {
                if ($ArticleTypeSQL) {
                    $ArticleTypeSQL .= ',';
                }
                $ArticleTypeSQL .= $Self->{DBObject}->Quote(
                    $Self->ArticleTypeLookup( ArticleType => $_ ),
                    'Integer',
                );
            }
        }
        if ($ArticleTypeSQL) {
            $ArticleTypeSQL = " AND sa.article_type_id IN ($ArticleTypeSQL)";
        }
    }

    # sql query
    my @Content = ();
    my @Bind;
    my $SQL = 'SELECT sa.ticket_id, sa.a_from, sa.a_to, sa.a_cc, sa.a_subject, '
        . ' sa.a_reply_to, sa.a_message_id, sa.a_in_reply_to, sa.a_references, sa.a_body, '
        . ' st.create_time_unix, st.ticket_state_id, st.queue_id, sa.create_time, '
        . ' sa.a_content_type, sa.create_by, st.tn, article_sender_type_id, st.customer_id, '
        . ' st.until_time, st.ticket_priority_id, st.customer_user_id, st.user_id, '
        . ' st.responsible_user_id, sa.article_type_id, '
        . ' sa.a_freekey1, sa.a_freetext1, sa.a_freekey2, sa.a_freetext2, '
        . ' sa.a_freekey3, sa.a_freetext3, st.ticket_answered, '
        . ' sa.incoming_time, sa.id, '
        . ' st.freekey1, st.freetext1, st.freekey2, st.freetext2,'
        . ' st.freekey3, st.freetext3, st.freekey4, st.freetext4,'
        . ' st.freekey5, st.freetext5, st.freekey6, st.freetext6,'
        . ' st.freekey7, st.freetext7, st.freekey8, st.freetext8, '
        . ' st.freekey9, st.freetext9, st.freekey10, st.freetext10, '
        . ' st.freekey11, st.freetext11, st.freekey12, st.freetext12, '
        . ' st.freekey13, st.freetext13, st.freekey14, st.freetext14, '
        . ' st.freekey15, st.freetext15, st.freekey16, st.freetext16, '
        . ' st.ticket_lock_id, st.title, st.escalation_update_time, '
        . ' st.freetime1 , st.freetime2, st.freetime3, st.freetime4, st.freetime5, st.freetime6, '
        . ' st.type_id, st.service_id, st.sla_id, st.escalation_response_time, '
        . ' st.escalation_solution_time, st.escalation_time, st.change_time '
        . ' FROM article sa, ticket st WHERE ';

    if ( $Param{ArticleID} ) {
        $SQL .= 'sa.id = ?';
        push @Bind, \$Param{ArticleID};
    }
    else {
        $SQL .= 'sa.ticket_id = ?';
        push @Bind, \$Param{TicketID};
    }
    $SQL .= ' AND sa.ticket_id = st.id ';

    # add article types
    if ($ArticleTypeSQL) {
        $SQL .= $ArticleTypeSQL;
    }
    $SQL .= ' ORDER BY sa.create_time, sa.id ASC';

    $Self->{DBObject}->Prepare( SQL => $SQL, Bind => \@Bind );
    my %Ticket = ();
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %Data;
        $Data{ArticleID}                = $Row[33];
        $Data{TicketID}                 = $Row[0];
        $Ticket{TicketID}               = $Data{TicketID};
        $Data{Title}                    = $Row[67];
        $Ticket{Title}                  = $Data{Title};
        $Data{EscalationTime}           = $Row[80];
        $Ticket{EscalationTime}         = $Data{EscalationTime};
        $Data{EscalationUpdateTime}     = $Row[68];
        $Ticket{EscalationUpdateTime}   = $Data{EscalationUpdateTime};
        $Data{EscalationResponseTime}   = $Row[78];
        $Ticket{EscalationResponseTime} = $Data{EscalationResponseTime};
        $Data{EscalationSolutionTime}   = $Row[79];
        $Ticket{EscalationSolutionTime} = $Data{EscalationSolutionTime};
        $Data{From}                     = $Row[1];
        $Data{To}                       = $Row[2];
        $Data{Cc}                       = $Row[3];
        $Data{Subject}                  = $Row[4];
        $Data{ReplyTo}                  = $Row[5];
        $Data{MessageID}                = $Row[6];
        $Data{InReplyTo}                = $Row[7];
        $Data{References}               = $Row[8];
        $Data{Body}                     = $Row[9];
        $Data{Age}                      = $Self->{TimeObject}->SystemTime() - $Row[10];
        $Ticket{CreateTimeUnix}         = $Row[10];
        $Ticket{Created}    = $Self->{TimeObject}->SystemTime2TimeStamp( SystemTime => $Row[10] );
        $Data{PriorityID}   = $Row[20];
        $Ticket{PriorityID} = $Row[20];
        $Data{StateID}      = $Row[11];
        $Ticket{StateID}    = $Row[11];
        $Data{QueueID}      = $Row[12];
        $Ticket{QueueID}    = $Row[12];
        $Data{Created}      = $Self->{TimeObject}->SystemTime2TimeStamp( SystemTime => $Row[32] );
        $Data{ContentType}  = $Row[14];
        $Data{CreatedBy}    = $Row[15];
        $Data{TicketNumber} = $Row[16];
        $Data{SenderTypeID} = $Row[17];
        $Ticket{Changed}    = $Row[81];

        if ( $Data{ContentType} && $Data{ContentType} =~ /charset=/i ) {
            $Data{Charset} = $Data{ContentType};
            $Data{Charset} =~ s/.+?charset=("|'|)(\w+)/$2/gi;
            $Data{Charset} =~ s/"|'//g;
            $Data{Charset} =~ s/(.+?);.*/$1/g;

        }
        else {
            $Data{Charset} = '';
        }

        # compat.
        $Data{ContentCharset} = $Data{Charset};

        if ( $Data{ContentType} && $Data{ContentType} =~ /^(\w+\/\w+)/i ) {
            $Data{MimeType} = $1;
            $Data{MimeType} =~ s/"|'//g;
        }
        else {
            $Data{MimeType} = '';
        }
        $Data{CustomerUserID}      = $Row[21];
        $Ticket{CustomerUserID}    = $Row[21];
        $Data{CustomerID}          = $Row[18];
        $Ticket{CustomerID}        = $Row[18];
        $Data{OwnerID}             = $Row[22];
        $Ticket{OwnerID}           = $Row[22];
        $Data{ResponsibleID}       = $Row[23] || 1;
        $Ticket{ResponsibleID}     = $Row[23] || 1;
        $Data{ArticleTypeID}       = $Row[24];
        $Data{ArticleFreeKey1}     = $Row[25];
        $Data{ArticleFreeText1}    = $Row[26];
        $Data{ArticleFreeKey2}     = $Row[27];
        $Data{ArticleFreeText2}    = $Row[28];
        $Data{ArticleFreeKey3}     = $Row[29];
        $Data{ArticleFreeText3}    = $Row[30];
        $Data{TicketFreeKey1}      = $Row[34];
        $Data{TicketFreeText1}     = $Row[35];
        $Data{TicketFreeKey2}      = $Row[36];
        $Data{TicketFreeText2}     = $Row[37];
        $Data{TicketFreeKey3}      = $Row[38];
        $Data{TicketFreeText3}     = $Row[39];
        $Data{TicketFreeKey4}      = $Row[40];
        $Data{TicketFreeText4}     = $Row[41];
        $Data{TicketFreeKey5}      = $Row[42];
        $Data{TicketFreeText5}     = $Row[43];
        $Data{TicketFreeKey6}      = $Row[44];
        $Data{TicketFreeText6}     = $Row[45];
        $Data{TicketFreeKey7}      = $Row[46];
        $Data{TicketFreeText7}     = $Row[47];
        $Data{TicketFreeKey8}      = $Row[48];
        $Data{TicketFreeText8}     = $Row[49];
        $Data{TicketFreeKey9}      = $Row[50];
        $Data{TicketFreeText9}     = $Row[51];
        $Data{TicketFreeKey10}     = $Row[52];
        $Data{TicketFreeText10}    = $Row[53];
        $Data{TicketFreeKey11}     = $Row[54];
        $Data{TicketFreeText11}    = $Row[55];
        $Data{TicketFreeKey12}     = $Row[56];
        $Data{TicketFreeText12}    = $Row[57];
        $Data{TicketFreeKey13}     = $Row[58];
        $Data{TicketFreeText13}    = $Row[59];
        $Data{TicketFreeKey14}     = $Row[60];
        $Data{TicketFreeText14}    = $Row[61];
        $Data{TicketFreeKey15}     = $Row[62];
        $Data{TicketFreeText15}    = $Row[63];
        $Data{TicketFreeKey16}     = $Row[64];
        $Data{TicketFreeText16}    = $Row[65];
        $Data{TicketFreeTime1}     = $Row[69];
        $Data{TicketFreeTime2}     = $Row[70];
        $Data{TicketFreeTime3}     = $Row[71];
        $Data{TicketFreeTime4}     = $Row[72];
        $Data{TicketFreeTime5}     = $Row[73];
        $Data{TicketFreeTime6}     = $Row[74];
        $Data{IncomingTime}        = $Row[32];
        $Data{RealTillTimeNotUsed} = $Row[19];
        $Ticket{LockID}            = $Row[66];
        $Data{TypeID}              = $Row[75];
        $Ticket{TypeID}            = $Row[75];
        $Data{ServiceID}           = $Row[76];
        $Ticket{ServiceID}         = $Row[76];
        $Data{SLAID}               = $Row[77];
        $Ticket{SLAID}             = $Row[77];

        # strip not wanted stuff
        for (qw(From To Cc Subject)) {
            $Data{$_} =~ s/\n|\r//g if ( $Data{$_} );
        }

        # cleanup time stamps (some databases are using e. g. 2008-02-25 22:03:00.000000
        # and 0000-00-00 00:00:00 time stamps)
        for my $Time ( 1 .. 6 ) {
            if ( $Data{ 'TicketFreeTime' . $Time } ) {
                if ( $Data{ 'TicketFreeTime' . $Time } eq '0000-00-00 00:00:00' ) {
                    $Data{ 'TicketFreeTime' . $Time } = '';
                    next;
                }
                $Data{ 'TicketFreeTime' . $Time }
                    =~ s/^(\d\d\d\d-\d\d-\d\d\s\d\d:\d\d:\d\d)\..+?$/$1/;
            }
        }

        push @Content, { %Ticket, %Data };
    }

    # return if content is empty
    if ( !@Content ) {

        # log only if there is not article type filter to be sure that there is no article
        if ( !$ArticleTypeSQL ) {
            if ( $Param{ArticleID} ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "No such article for ArticleID ($Param{ArticleID})!",
                );
            }
            elsif ( $Param{TicketID} ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "No such article for TicketID ($Param{TicketID})!",
                );
            }
        }
        return;
    }

    # get type
    $Ticket{Type} = $Self->{TypeObject}->TypeLookup( TypeID => $Ticket{TypeID} || 1 );

    # get owner
    $Ticket{Owner} = $Self->{UserObject}->UserLookup( UserID => $Ticket{OwnerID} );

    # get responsible
    $Ticket{Responsible} = $Self->{UserObject}->UserLookup( UserID => $Ticket{ResponsibleID} );

    # get priority
    $Ticket{Priority} = $Self->{PriorityObject}->PriorityLookup(
        PriorityID => $Ticket{PriorityID},
    );

    # get lock
    $Ticket{Lock} = $Self->{LockObject}->LockLookup( LockID => $Ticket{LockID} );

    # get service
    if ( $Ticket{ServiceID} ) {
        $Ticket{Service} = $Self->{ServiceObject}->ServiceLookup( ServiceID => $Ticket{ServiceID} );
    }

    # get sla
    if ( $Ticket{SLAID} ) {
        $Ticket{SLA} = $Self->{SLAObject}->SLALookup( SLAID => $Ticket{SLAID} );
    }

    # get queue name and other stuff
    my %Queue = $Self->{QueueObject}->QueueGet( ID => $Ticket{QueueID} );

    # get state info
    my %StateData = $Self->{StateObject}->StateGet( ID => $Ticket{StateID} );
    $Ticket{StateType} = $StateData{TypeName};
    $Ticket{State}     = $StateData{Name};

    # get esclation attributes
    my %Escalation = $Self->TicketEscalationDateCalculation(
        Ticket => \%Ticket,
        UserID => $Param{UserID} || 1,
    );
    for my $Part (@Content) {
        for ( keys %Escalation ) {
            $Part->{$_} = $Escalation{$_};
        }
    }

    # do extended lookups
    if ( $Param{Extended} ) {
        my %TicketExtended = $Self->_TicketGetExtended(
            TicketID => $Ticket{TicketID},
            Ticket   => \%Ticket,
        );
        for my $Key ( keys %TicketExtended ) {
            $Ticket{$Key} = $TicketExtended{$Key};
        }
        for my $Part (@Content) {
            for ( keys %TicketExtended ) {
                $Part->{$_} = $TicketExtended{$_};
            }
        }
    }

    # article stuff
    for my $Part (@Content) {

        # get type
        $Part->{Type} = $Ticket{Type};

        # get owner
        $Part->{Owner} = $Ticket{Owner};

        # get responsible
        $Part->{Responsible} = $Ticket{Responsible};

        # get sender type
        $Part->{SenderType} = $Self->ArticleSenderTypeLookup(
            SenderTypeID => $Part->{SenderTypeID},
        );

        # get article type
        $Part->{ArticleType} = $Self->ArticleTypeLookup(
            ArticleTypeID => $Part->{ArticleTypeID},
        );

        # get priority name
        $Part->{Priority} = $Ticket{Priority};
        $Part->{LockID}   = $Ticket{LockID};
        $Part->{Lock}     = $Ticket{Lock};
        $Part->{Queue}    = $Queue{Name};
        $Part->{Service}  = $Ticket{Service} || '';
        $Part->{SLA}      = $Ticket{SLA} || '';
        if ( !$Part->{RealTillTimeNotUsed} || $StateData{TypeName} !~ /^pending/i ) {
            $Part->{UntilTime} = 0;
        }
        else {
            $Part->{UntilTime} = $Part->{RealTillTimeNotUsed} - $Self->{TimeObject}->SystemTime();
        }
        $Part->{StateType} = $StateData{TypeName};
        $Part->{State}     = $StateData{Name};
    }

    if ( $Param{ArticleID} ) {
        return %{ $Content[0] };
    }
    else {
        return @Content;
    }
}

=item ArticleUpdate()

update a article item

Note: Key "Body", "Subject", "From", "To", "Cc", "ArticleType" or "SenderType" is implemented.

    $TicketObject->ArticleUpdate(
        ArticleID => 123,
        Key       => 'Body',
        Value     => 'New Body',
        UserID    => 123,
        TicketID  => 123,
    );

    $TicketObject->ArticleUpdate(
        ArticleID => 123,
        Key       => 'ArticleType',
        Value     => 'email-internal',
        UserID    => 123,
        TicketID  => 123,
    );

=cut

sub ArticleUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID UserID Key TicketID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check needed stuff
    if ( !defined $Param{Value} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Value!' );
        return;
    }

    # lookup for ArticleType
    if ( $Param{Key} eq 'ArticleType' ) {
        $Param{Key}   = 'ArticleTypeID';
        $Param{Value} = $Self->ArticleTypeLookup(
            ArticleType => $Param{Value},
        );
    }

    # lookup for SenderType
    if ( $Param{Key} eq 'SenderType' ) {
        $Param{Key}   = 'SenderTypeID';
        $Param{Value} = $Self->ArticleSenderTypeLookup(
            SenderType => $Param{Value},
        );
    }

    # map
    my %Map = (
        Body          => 'a_body',
        Subject       => 'a_subject',
        From          => 'a_from',
        To            => 'a_to',
        Cc            => 'a_cc',
        ArticleTypeID => 'article_type_id',
        SenderTypeID  => 'article_sender_type_id',
    );

    # db update
    return if !$Self->{DBObject}->Do(
        SQL => "UPDATE article SET $Map{$Param{Key}} = ?, "
            . "change_time = current_timestamp, change_by = ? WHERE id = ?",
        Bind => [ \$Param{Value}, \$Param{UserID}, \$Param{ArticleID} ],
    );

    # ticket event
    $Self->TicketEventHandlerPost(
        Event     => 'ArticleUpdate',
        TicketID  => $Param{TicketID},
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );
    return 1;
}

=item ArticleSend()

send article via email and create article with attachments

    my $ArticleID = $TicketObject->ArticleSend(
        TicketID    => 123,
        ArticleType => 'note-internal',                                        # email-external|email-internal|phone|fax|...
        SenderType  => 'agent',                                                # agent|system|customer
        From        => 'Some Agent <email@example.com>',                       # not required but useful
        To          => 'Some Customer A <customer-a@example.com>',             # not required but useful
        Cc          => 'Some Customer B <customer-b@example.com>',             # not required but useful
        ReplyTo     => 'Some Customer B <customer-b@example.com>',             # not required
        Subject     => 'some short description',                               # required
        Body        => 'the message text',                                     # required
        InReplyTo   => '<asdasdasd.12@example.com>',                           # not required but useful
        References  => '<asdasdasd.1@example.com> <asdasdasd.12@example.com>', # not required but useful
        Charset     => 'iso-8859-15'
        MimeType    => 'text/plain',
        Loop        => 0, # 1|0 used for bulk emails
        Attachment => [
            {
                Content     => $Content,
                ContentType => $ContentType,
                Filename    => 'lala.txt',
            },
            {
                Content     => $Content,
                ContentType => $ContentType,
                Filename    => 'lala1.txt',
            },
        ],
        Sign => {
            Type    => 'PGP',
            SubType => 'Inline|Detached',
            Key     => '81877F5E',
            Type    => 'SMIME',
            Key     => '3b630c80',
        },
        Crypt => {
            Type    => 'PGP',
            SubType => 'Inline|Detached',
            Key     => '81877F5E',
            Type    => 'SMIME',
            Key     => '3b630c80',
        },
        HistoryType    => 'OwnerUpdate',  # Move|AddNote|PriorityUpdate|WebRequestCustomer|...
        HistoryComment => 'Some free text!',
        NoAgentNotify  => 0,            # if you don't want to send agent notifications
        UserID         => 123,
    );

=cut

sub ArticleSend {
    my ( $Self, %Param ) = @_;

    my $ToOrig      = $Param{To}          || '';
    my $Loop        = $Param{Loop}        || 0;
    my $HistoryType = $Param{HistoryType} || 'SendAnswer';

    # check needed stuff
    for (qw(TicketID UserID From Body Charset MimeType)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    if ( !$Param{ArticleType} && !$Param{ArticleTypeID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ArticleType or ArticleTypeID!',
        );
        return;
    }
    if ( !$Param{SenderType} && !$Param{SenderTypeID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need SenderType or SenderTypeID!',
        );
        return;
    }

    # clean up
    $Param{Body} =~ s/(\r\n|\n\r)/\n/g;
    $Param{Body} =~ s/\r/\n/g;

    # create article
    my $Time      = $Self->{TimeObject}->SystemTime();
    my $Random    = rand 999999;
    my $FQDN      = $Self->{ConfigObject}->Get('FQDN');
    my $MessageID = "<$Time.$Random.$Param{TicketID}.$Param{UserID}\@$FQDN>";
    my $ArticleID = $Self->ArticleCreate(
        %Param,
        MessageID => $MessageID,
    );
    return if !$ArticleID;

    # send mail
    my ( $HeadRef, $BodyRef ) = $Self->{SendmailObject}->Send(
        'Message-ID' => $MessageID,
        %Param,
    );

    # return if no mail was able to send
    if ( !$HeadRef || !$BodyRef ) {
        return;
    }

    # write article to fs
    my $Plain = $Self->ArticleWritePlain(
        ArticleID => $ArticleID,
        Email     => ${$HeadRef} . "\n" . ${$BodyRef},
        UserID    => $Param{UserID}
    );
    return if !$Plain;

    # log
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "Sent email to '$ToOrig' from '$Param{From}'. "
            . "HistoryType => $HistoryType, Subject => $Param{Subject};",
    );

    # ticket event
    $Self->TicketEventHandlerPost(
        Event     => 'ArticleSend',
        TicketID  => $Param{TicketID},
        ArticleID => $ArticleID,
        UserID    => $Param{UserID},
    );
    return $ArticleID;
}

=item ArticleBounce()

bounce an article

    $TicketObject->ArticleBounce(
        From      => 'some@example.com',
        To        => 'webmaster@example.com',
        TicketID  => 123,
        ArticleID => 123,
        UserID    => 123,
    );

=cut

sub ArticleBounce {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID ArticleID From To UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # create message id
    my $Time         = $Self->{TimeObject}->SystemTime();
    my $Random       = rand 999999;
    my $FQDN         = $Self->{ConfigObject}->Get('FQDN');
    my $NewMessageID = "<$Time.$Random.$Param{TicketID}.0.$Param{UserID}\@$FQDN>";
    my $Email        = $Self->ArticlePlain( ArticleID => $Param{ArticleID} );

    # check if plain email exists
    if ( !$Email ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "No such plain article for ArticleID ($Param{ArticleID})!",
        );
        return;
    }

    # pipe all into sendmail
    return if !$Self->{SendmailObject}->Bounce(
        MessageID => $NewMessageID,
        From      => $Param{From},
        To        => $Param{To},
        Email     => $Email,
    );

    # write history
    my $HistoryType = $Param{HistoryType} || 'Bounce';
    $Self->HistoryAdd(
        TicketID     => $Param{TicketID},
        ArticleID    => $Param{ArticleID},
        HistoryType  => $HistoryType,
        Name         => "\%\%$Param{To}",
        CreateUserID => $Param{UserID},
    );

    # ticket event
    $Self->TicketEventHandlerPost(
        Event    => 'ArticleBounce',
        TicketID => $Param{TicketID},
        UserID   => $Param{UserID},
    );
    return 1;
}

=item SendAgentNotification()

send an agent notification via email

    $TicketObject->SendAgentNotification(
        TicketID    => 123,
        CustomerMessageParams => {
            SomeParams => 'For the message!',
        },
        Type        => 'Move', # notification types, see database
        RecipientID => $UserID,
        UserID      => 123,
    );

=cut

sub SendAgentNotification {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(CustomerMessageParams TicketID Type RecipientID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # compat Type
    if (
        $Param{Type}
        =~ /(EmailAgent|EmailCustomer|PhoneCallCustomer|WebRequestCustomer|SystemRequest)/
        )
    {
        $Param{Type} = 'NewTicket';
    }

    # get recipient
    my %User = $Self->{UserObject}->GetUserData(
        UserID => $Param{RecipientID},
        Cached => 1,
        Valid  => 1,
    );

    # check recipients
    return if !$User{UserEmail};
    return if $User{UserEmail} !~ /@/;

    my $TemplateGeneratorObject = Kernel::System::TemplateGenerator->new(
        DBObject           => $Self->{DBObject},
        ConfigObject       => $Self->{ConfigObject},
        EncodeObject       => $Self->{EncodeObject},
        LogObject          => $Self->{LogObject},
        CustomerUserObject => $Self->{CustomerUserObject},
        QueueObject        => $Self->{QueueObject},
        UserObject         => $Self->{UserObject},
        TicketObject       => $Self,
    );

    my %Notification = $TemplateGeneratorObject->NotificationAgent(
        Type                  => $Param{Type},
        TicketID              => $Param{TicketID},
        CustomerMessageParams => $Param{CustomerMessageParams},
        RecipientID           => $Param{RecipientID},
        UserID                => $Param{UserID},
    );

    # send notify
    $Self->{SendmailObject}->Send(
        From => $Self->{ConfigObject}->Get('NotificationSenderName') . ' <'
            . $Self->{ConfigObject}->Get('NotificationSenderEmail') . '>',
        To       => $User{UserEmail},
        Subject  => $Notification{Subject},
        MimeType => $Notification{ContentType} || 'text/plain',
        Charset  => $Notification{Charset},
        Body     => $Notification{Body},
        Loop     => 1,
    );

    # write history
    $Self->HistoryAdd(
        TicketID     => $Param{TicketID},
        HistoryType  => 'SendAgentNotification',
        Name         => "\%\%$Param{Type}\%\%$User{UserEmail}",
        CreateUserID => $Param{UserID},
    );

    # log event
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "Sent agent '$Param{Type}' notification to '$User{UserEmail}'.",
    );

    # ticket event
    $Self->TicketEventHandlerPost(
        Event    => 'ArticleAgentNotification',
        TicketID => $Param{TicketID},
        UserID   => $Param{UserID},
    );

    return 1;
}

=item SendCustomerNotification()

send a customer notification via email

    my $ArticleID = $TicketObject->SendCustomerNotification(
        Type => 'Move', # notification types, see database
        CustomerMessageParams => {
            SomeParams => 'For the message!',
        },
        TicketID => 123,
        UserID   => 123,
    );

=cut

sub SendCustomerNotification {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(CustomerMessageParams TicketID UserID Type)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get old article for quoteing
    my %Article = $Self->ArticleLastCustomerArticle( TicketID => $Param{TicketID} );

    # check if notification should be send
    my %Queue = $Self->{QueueObject}->QueueGet( ID => $Article{QueueID} );
    if ( $Param{Type} =~ /^StateUpdate$/ && !$Queue{StateNotify} ) {

        # need no notification
        return;
    }
    elsif ( $Param{Type} =~ /^OwnerUpdate$/ && !$Queue{OwnerNotify} ) {

        # need no notification
        return;
    }
    elsif ( $Param{Type} =~ /^QueueUpdate$/ && !$Queue{MoveNotify} ) {

        # need no notification
        return;
    }
    elsif ( $Param{Type} =~ /^LockUpdate$/ && !$Queue{LockNotify} ) {

        # need no notification
        return;
    }

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
    my %Notification = $Self->{NotificationObject}->NotificationGet(
        Name => $Language . '::Customer::' . $Param{Type},
    );

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
    my %Ticket = $Self->TicketGet( TicketID => $Param{TicketID} );
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

    # format body
    $Article{Body} =~ s/(^>.+|.{4,72})(?:\s|\z)/$1\n/gm if ( $Article{Body} );
    for ( keys %Article ) {
        if ( $Article{$_} ) {
            $Notification{Body}    =~ s/<OTRS_CUSTOMER_$_>/$Article{$_}/gi;
            $Notification{Subject} =~ s/<OTRS_CUSTOMER_$_>/$Article{$_}/gi;
        }
    }

    # prepare subject (insert old subject)
    $Article{Subject} = $Self->TicketSubjectClean(
        TicketNumber => $Article{TicketNumber},
        Subject => $Article{Subject} || '',
    );
    if ( $Notification{Subject} =~ /<OTRS_CUSTOMER_SUBJECT\[(.+?)\]>/ ) {
        my $SubjectChar = $1;
        $Article{Subject}      =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
        $Notification{Subject} =~ s/<OTRS_CUSTOMER_SUBJECT\[.+?\]>/$Article{Subject}/g;
    }
    $Notification{Subject} = $Self->TicketSubjectBuild(
        TicketNumber => $Article{TicketNumber},
        Subject => $Notification{Subject} || '',
    );

    # prepare body (insert old email)
    if ( $Notification{Body} =~ /<OTRS_CUSTOMER_EMAIL\[(.+?)\]>/g ) {
        my $Line       = $1;
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
        $Notification{Body} =~ s/<OTRS_CUSTOMER_EMAIL\[.+?\]>/$NewOldBody/g;
    }

    # cleanup all not needed <OTRS_CUSTOMER_ tags
    $Notification{Body}    =~ s/<OTRS_CUSTOMER_.+?>/-/gi;
    $Notification{Subject} =~ s/<OTRS_CUSTOMER_.+?>/-/gi;

    # send notify
    my %Address = $Self->{QueueObject}->GetSystemAddress( QueueID => $Article{QueueID} );
    $Self->ArticleSend(
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
    $Self->TicketEventHandlerPost(
        Event    => 'ArticleCustomerNotification',
        TicketID => $Param{TicketID},
        UserID   => $Param{UserID},
    );

    return 1;
}

=item SendAutoResponse()

send an auto response to a customer via email

    my $ArticleID = $TicketObject->SendAutoResponse(
        TicketID         => 123,
        AutoResponseType => 'auto reply',
        OrigHeader       => {
            From    => 'some@example.com',
            Subject => 'For the message!',
        },
        UserID          => 123,
    );

=cut

sub SendAutoResponse {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID UserID OrigHeader AutoResponseType)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my %Ticket = $Self->TicketGet( TicketID => $Param{TicketID} );

    # get auto default responses
    my $TemplateGeneratorObject = Kernel::System::TemplateGenerator->new(
        DBObject           => $Self->{DBObject},
        EncodeObject       => $Self->{EncodeObject},
        ConfigObject       => $Self->{ConfigObject},
        LogObject          => $Self->{LogObject},
        CustomerUserObject => $Self->{CustomerUserObject},
        QueueObject        => $Self->{QueueObject},
        UserObject         => $Self->{UserObject},
        TicketObject       => $Self,
    );
    my %AutoResponse = $TemplateGeneratorObject->AutoResponse(
        TicketID         => $Param{TicketID},
        AutoResponseType => $Param{AutoResponseType},
        OrigHeader       => $Param{OrigHeader},
        UserID           => $Param{UserID},
    );

    return
        if !$AutoResponse{Text} || !$AutoResponse{SenderRealname} || !$AutoResponse{SenderAddress};

    # send if notification should be sent (not for closed tickets)!?
    my %State = $Self->{StateObject}->StateGet( ID => $Ticket{StateID} );
    if (
        $Param{AutoResponseType} eq 'auto reply'
        && ( $State{TypeName} eq 'closed' || $State{TypeName} eq 'removed' )
        )
    {

        # add history row
        $Self->HistoryAdd(
            TicketID    => $Param{TicketID},
            HistoryType => 'Misc',
            Name        => "Sent no auto response or agent notification because ticket is "
                . "state-type '$State{TypeName}'!",
            CreateUserID => $Param{UserID},
        );

        # return
        return;
    }

    # get orig email header
    my %OrigHeader = %{ $Param{OrigHeader} };

    # log that no auto response was sent!
    if ( $OrigHeader{'X-OTRS-Loop'} ) {

        # add history row
        $Self->HistoryAdd(
            TicketID    => $Param{TicketID},
            HistoryType => 'Misc',
            Name        => "Sent no auto-response because the sender doesn't want "
                . "a auto-response (e. g. loop or precedence header)",
            CreateUserID => $Param{UserID},
        );
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Sent no '$Param{AutoResponseType}' for Ticket ["
                . "$Ticket{TicketNumber}] ($OrigHeader{From}) because the "
                . "sender doesn't want a auto-response (e. g. loop or precedence header)"
        );
        return;
    }

    # check / loop protection!
    if ( !$Self->{LoopProtectionObject}->Check( To => $OrigHeader{From} ) ) {

        # add history row
        $Self->HistoryAdd(
            TicketID     => $Param{TicketID},
            HistoryType  => 'LoopProtection',
            Name         => "\%\%$OrigHeader{From}",
            CreateUserID => $Param{UserID},
        );

        # do log
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Sent no '$Param{AutoResponseType}' for Ticket ["
                . "$Ticket{TicketNumber}] ($OrigHeader{From}) "
        );
        return;
    }

    # return if loop count has reached
    return if !$Self->{LoopProtectionObject}->SendEmail( To => $OrigHeader{From} );

    # check reply to for auto response recipient
    if ( $OrigHeader{ReplyTo} ) {
        $OrigHeader{From} = $OrigHeader{ReplyTo};
    }

    # check if sender has an valid email address
    if ( $OrigHeader{From} !~ /@/ ) {

        # add it to ticket history
        $Self->HistoryAdd(
            TicketID     => $Param{TicketID},
            CreateUserID => $Param{UserID},
            HistoryType  => 'Misc',
            Name         => 'Sent not auto response, no valid email in From.',
        );

        # log
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Sent not auto response to '$OrigHeader{From}' because of"
                . " invalid From address",
        );
        return 1;
    }

    # check if sender is e. g. MAILDER-DAEMON or Postmaster
    my $NoAutoRegExp = $Self->{ConfigObject}->Get('SendNoAutoResponseRegExp');
    if ( $OrigHeader{From} =~ /$NoAutoRegExp/i ) {

        # add it to ticket history
        $Self->HistoryAdd(
            TicketID     => $Param{TicketID},
            CreateUserID => $Param{UserID},
            HistoryType  => 'Misc',
            Name         => 'Sent not auto response, SendNoAutoResponseRegExp is matching.',
        );

        # log
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Sent not auto response to '$OrigHeader{From}' because config"
                . " option SendNoAutoResponseRegExp (/$NoAutoRegExp/i) is matching!",
        );
        return 1;
    }

    # set new To address if customer user id is used
    my $Cc    = '';
    my $ToAll = $OrigHeader{From};
    if ( $Ticket{CustomerUserID} ) {
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $Ticket{CustomerUserID},
        );
        if ( $CustomerUser{UserEmail} && $OrigHeader{From} !~ /\Q$CustomerUser{UserEmail}\E/i ) {
            $Cc = $CustomerUser{UserEmail};
            $ToAll .= ', ' . $Cc;
        }
    }

    # get history type
    my $HistoryType;
    if ( $Param{AutoResponseType} =~ /^auto follow up$/i ) {
        $HistoryType = 'SendAutoFollowUp';
    }
    elsif ( $Param{AutoResponseType} =~ /^auto reply$/i ) {
        $HistoryType = 'SendAutoReply';
    }
    elsif ( $Param{AutoResponseType} =~ /^auto reply\/new ticket$/i ) {
        $HistoryType = 'SendAutoReply';
    }
    elsif ( $Param{AutoResponseType} =~ /^auto reject$/i ) {
        $HistoryType = 'SendAutoReject';
    }
    else {
        $HistoryType = 'Misc';
    }

    # send email
    my $ArticleID = $Self->ArticleSend(
        ArticleType    => 'email-external',
        SenderType     => 'system',
        TicketID       => $Param{TicketID},
        HistoryType    => $HistoryType,
        HistoryComment => "\%\%$ToAll",
        From           => "$AutoResponse{SenderRealname} <$AutoResponse{SenderAddress}>",
        To             => $OrigHeader{From},
        Cc             => $Cc,
        Charset        => $AutoResponse{Charset},
        MimeType       => $AutoResponse{ContentType},
        Subject        => $AutoResponse{Subject},
        Body           => $AutoResponse{Text},
        InReplyTo      => $OrigHeader{'Message-ID'},
        Loop           => 1,
        UserID         => $Param{UserID},
    );

    # log
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "Sent auto response ($HistoryType) for Ticket [$Ticket{TicketNumber}]"
            . " (TicketID=$Param{TicketID}, ArticleID=$ArticleID) to '$ToAll'."
    );

    # ticket event
    $Self->TicketEventHandlerPost(
        Event    => 'ArticleAutoResponse',
        TicketID => $Param{TicketID},
        UserID   => $Param{UserID},
    );

    return 1;
}

=item ArticleFlagSet()

set article flags

    $TicketObject->ArticleFlagSet(
        ArticleID => 123,
        Flag      => 'seen',
        UserID    => 123,
    );

=cut

sub ArticleFlagSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID Flag UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my %Flag = $Self->ArticleFlagGet(%Param);

    # check if set is needed
    if ( defined $Flag{ $Param{Flag} } ) {
        return 1;
    }

    # set falg
    $Self->{DBObject}->Do(
        SQL => 'INSERT INTO article_flag '
            . ' (article_id, article_flag, create_time, create_by) '
            . ' VALUES (?, ?, current_timestamp, ?)',
        Bind => [ \$Param{ArticleID}, \$Param{Flag}, \$Param{UserID} ],
    );

    # ticket event
    my %Article = $Self->ArticleGet(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );
    $Self->TicketEventHandlerPost(
        Event     => 'ArticleFlagSet',
        TicketID  => $Article{TicketID},
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    return 1;
}

=item ArticleFlagDelete()

delete article flags

    $TicketObject->ArticleFlagDelete(
        ArticleID => 123,
        Flag      => 'seen',
        UserID    => 123,
    );

=cut

sub ArticleFlagDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID Flag UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # do db insert
    $Self->{DBObject}->Do(
        SQL => 'DELETE FROM article_flag WHERE article_id = ? AND '
            . 'create_by = ? AND article_flag = ?',
        Bind => [ \$Param{ArticleID}, \$Param{UserID}, \$Param{Flag} ],
    );

    # ticket event
    my %Article = $Self->ArticleGet(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );
    $Self->TicketEventHandlerPost(
        Event     => 'ArticleFlagDelete',
        TicketID  => $Article{TicketID},
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );
    return 1;
}

=item ArticleFlagGet()

get article flags

    my %Article = $TicketObject->ArticleFlagGet(
        ArticleID => 123,
        UserID    => 123,
    );

=cut

sub ArticleFlagGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql query
    return if !$Self->{DBObject}->Prepare(
        SQL   => 'SELECT article_flag FROM article_flag WHERE article_id = ? AND create_by = ?',
        Bind  => [ \$Param{ArticleID}, \$Param{UserID} ],
        Limit => 1500,
    );
    my %Flag;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Flag{ $Row[0] } = 1;
    }
    return %Flag;
}

=item ArticleAccountedTimeGet()

returns the accounted time of a article.

    my $AccountedTime = $TicketObject->ArticleAccountedTimeGet(
        ArticleID => $ArticleID,
    );

=cut

sub ArticleAccountedTimeGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ArticleID!' );
        return;
    }

    # db query
    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT time_unit FROM time_accounting WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );
    my $AccountedTime = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Row[0] =~ s/,/./g;
        $AccountedTime = $AccountedTime + $Row[0];
    }
    return $AccountedTime;
}

=item ArticleAccountedTimeDelete()

delete accounted time of article

    $TicketObject->ArticleAccountedTimeDelete(
        ArticleID => $ArticleID,
    );

=cut

sub ArticleAccountedTimeDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ArticleID!' );
        return;
    }

    # db query
    return $Self->{DBObject}->Do(
        SQL  => 'DELETE FROM time_accounting WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );
}

1;

# the following is the pod for Kernel/System/Ticket/ArticleStorage*.pm

=item ArticleDelete()

delete all article, attachments and plain message of a ticket

    $TicketObject->ArticleDelete(
        ArticleID => 123,
        UserID    => 123,
    );

=item ArticleDeletePlain()

delete a artile plain message

    $TicketObject->ArticleDeletePlain(
        ArticleID => 123,
        UserID    => 123,
    );

=item ArticleDeleteAttachment()

delete all attachments of an article

    $TicketObject->ArticleDeleteAttachment(
        ArticleID => 123,
        UserID    => 123,
    );

=item ArticleWritePlain()

write an plain email to storage

    $TicketObject->ArticleWritePlain(
        ArticleID => 123,
        Email     => $EmailAsString,
        UserID    => 123,
    );

=item ArticlePlain()

get plain message/email

    my $PlainMessage = $TicketObject->ArticlePlain(
        ArticleID => 123,
        UserID    => 123,
    );

=item ArticleWriteAttachment()

write an article attachment to storage

    $TicketObject->ArticleWriteAttachment(
        Content            => $ContentAsString,
        ContentType        => 'text/html; charset="iso-8859-15"',
        Filename           => 'lala.html',
        ContentID          => 'cid-1234', # optional
        ContentAlternative => 0,          # optional, alternative content to shown as body
        ArticleID          => 123,
        UserID             => 123,
    );

=item ArticleAttachmentIndex()

get article attachment index as hash (ID => hashref (Filename, Filesize, ContentID (if exists), ContentAlternative(if exists) ))

    my %Index = $TicketObject->ArticleAttachmentIndex(
        ArticleID => 123,
        UserID    => 123,
    );

=item ArticleAttachment()

get article attachment (Content, ContentType, Filename and optional ContentID, ContentAlternative)

    my %Attachment = $TicketObject->ArticleAttachment(
        ArticleID => 123,
        FileID    => 1,
        UserID    => 123,
    );

=cut

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.230 $ $Date: 2009-08-18 19:25:40 $

=cut
