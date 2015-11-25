# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Article;

use strict;
use warnings;

use POSIX qw(ceil);

use Kernel::System::EmailParser;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

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
        NoAgentNotify    => 0,                                      # if you don't want to send agent notifications
        AutoResponseType => 'auto reply'                            # auto reject|auto follow up|auto reply/new ticket|auto remove

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
        UnlockOnAway     => 1,                                      # Unlock ticket if owner is away
    );

Events:
    ArticleCreate

=cut

sub ArticleCreate {
    my ( $Self, %Param ) = @_;

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    my $ValidID = $Param{ValidID} || 1;
    my $IncomingTime = $TimeObject->SystemTime();

    # create ArticleContentPath
    if ( !$Self->{ArticleContentPath} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleContentPath!'
        );
        return;
    }

    # lookups if no ids are passed
    if ( $Param{ArticleType} && !$Param{ArticleTypeID} ) {
        $Param{ArticleTypeID} = $Self->ArticleTypeLookup( ArticleType => $Param{ArticleType} );
    }
    if ( $Param{SenderType} && !$Param{SenderTypeID} ) {
        $Param{SenderTypeID} = $Self->ArticleSenderTypeLookup( SenderType => $Param{SenderType} );
    }

    # check needed stuff
    for (qw(TicketID UserID ArticleTypeID SenderTypeID HistoryType HistoryComment)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # check ContentType vs. Charset & MimeType
    if ( !$Param{ContentType} ) {
        for (qw(Charset MimeType)) {
            if ( !$Param{$_} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Need $_!"
                );
                return;
            }
        }
        $Param{ContentType} = "$Param{MimeType}; charset=$Param{Charset}";
    }
    else {
        for (qw(ContentType)) {
            if ( !$Param{$_} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Need $_!"
                );
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

    # for the event handler, before any actions have taken place
    my %OldTicketData = $Self->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 1,
    );

    # get html utils object
    my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

    # add 'no body' if there is no body there!
    my @AttachmentConvert;
    if ( !length $Param{Body} ) {    # allow '0' as body
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
        $Param{Body} = $HTMLUtilsObject->ToAscii(
            String => $Param{Body},
        );
    }
    elsif ( $Param{MimeType} && $Param{MimeType} eq "application/json" ) {

        # Keep JSON body unchanged
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
    for my $Attribute (qw(From To Cc Subject MessageID InReplyTo References ReplyTo)) {
        if ( defined $Param{$Attribute} ) {
            $Param{$Attribute} =~ s/\n|\r//g;
        }
        else {
            $Param{$Attribute} = '';
        }
    }
    ATTRIBUTE:
    for my $Attribute (qw(InReplyTo References)) {
        next ATTRIBUTE if !$Param{$Attribute};
        $Param{$Attribute} = substr( $Param{$Attribute}, 0, 3800 );
    }

    # check if this is the first article (for notifications)
    my @Index = $Self->ArticleIndex( TicketID => $Param{TicketID} );
    my $FirstArticle = scalar @Index ? 0 : 1;

    # calculate MD5 of Message ID
    if ( $Param{MessageID} ) {
        $Param{MD5} = $Kernel::OM->Get('Kernel::System::Main')->MD5sum( String => $Param{MessageID} );
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # if the original article body contains just one pasted picture and no text, at this point of
    # the code the body is an empty string, Oracle databases will transform the empty string value
    # to NULL and will try to insert a NULL value in a field that should not be NULL. see bug 7533.
    if (
        $DBObject->GetDatabaseFunction('Type') eq 'oracle'
        && defined $Param{Body}
        && !$Param{Body}
        )
    {
        $Param{Body} = ' ';
    }

    # do db insert
    return if !$DBObject->Do(
        SQL => 'INSERT INTO article '
            . '(ticket_id, article_type_id, article_sender_type_id, a_from, a_reply_to, a_to, '
            . 'a_cc, a_subject, a_message_id, a_message_id_md5, a_in_reply_to, a_references, a_body, a_content_type, '
            . 'content_path, valid_id, incoming_time, create_time, create_by, change_time, change_by) '
            . 'VALUES '
            . '(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{TicketID}, \$Param{ArticleTypeID}, \$Param{SenderTypeID},
            \$Param{From},     \$Param{ReplyTo},       \$Param{To},
            \$Param{Cc},       \$Param{Subject},       \$Param{MessageID},
            \$Param{MD5},
            \$Param{InReplyTo}, \$Param{References}, \$Param{Body},
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Can\'t get ArticleID from INSERT!',
        );
        return;
    }

    # check for base64 encoded images in html body and upload them
    for my $Attachment (@AttachmentConvert) {

        if (
            $Attachment->{ContentType} eq "text/html; charset=\"$Param{Charset}\""
            && $Attachment->{Filename} eq 'file-2'
            )
        {
            $HTMLUtilsObject->EmbeddedImagesExtract(
                DocumentRef    => \$Attachment->{Content},
                AttachmentsRef => \@AttachmentConvert,
            );
        }
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

    $Self->_TicketCacheClear( TicketID => $Param{TicketID} );

    # add history row
    $Self->HistoryAdd(
        ArticleID    => $ArticleID,
        TicketID     => $Param{TicketID},
        CreateUserID => $Param{UserID},
        HistoryType  => $Param{HistoryType},
        Name         => $Param{HistoryComment},
    );

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

    # unlock ticket if the owner is away (and the feature is enabled)
    if (
        $Param{UnlockOnAway}
        && $OldTicketData{Lock} eq 'lock'
        && $ConfigObject->Get('Ticket::UnlockOnAway')
        )
    {
        my %OwnerInfo = $UserObject->GetUserData(
            UserID => $OldTicketData{OwnerID},
        );

        if ( $OwnerInfo{OutOfOfficeMessage} ) {
            $Self->TicketLockSet(
                TicketID => $Param{TicketID},
                Lock     => 'unlock',
                UserID   => $Param{UserID},
            );
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message =>
                    "Ticket [$OldTicketData{TicketNumber}] unlocked, current owner is out of office!",
            );
        }
    }

    # event
    $Self->EventHandler(
        Event => 'ArticleCreate',
        Data  => {
            ArticleID     => $ArticleID,
            TicketID      => $Param{TicketID},
            OldTicketData => \%OldTicketData,
        },
        UserID => $Param{UserID},
    );

    # reset unlock if needed
    if ( !$Param{SenderType} ) {
        $Param{SenderType} = $Self->ArticleSenderTypeLookup( SenderTypeID => $Param{SenderTypeID} );
    }
    if ( !$Param{ArticleType} ) {
        $Param{ArticleType} = $Self->ArticleTypeLookup( ArticleTypeID => $Param{ArticleTypeID} );
    }

    # reset unlock time if customer sent an update
    if ( $Param{SenderType} eq 'customer' ) {

        # check if latest article comes from customer
        my $LastSender = '';
        return if !$DBObject->Prepare(
            SQL => 'SELECT ast.name FROM article art, article_sender_type ast WHERE '
                . ' art.ticket_id = ? AND art.id NOT IN (?) AND '
                . ' art.article_sender_type_id = ast.id ORDER BY art.create_time ASC',
            Bind => [ \$Param{TicketID}, \$ArticleID ],
        );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            if ( $Row[0] ne 'system' ) {
                $LastSender = $Row[0];
            }
        }
        if ( $LastSender eq 'agent' ) {
            $Self->TicketUnlockTimeoutUpdate(
                UnlockTimeout => $TimeObject->SystemTime(),
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
            UnlockTimeout => $TimeObject->SystemTime(),
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

    my %Ticket = $Self->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    # remember agent to exclude notifications
    my @SkipRecipients;
    if ( $Param{ExcludeNotificationToUserID} && ref $Param{ExcludeNotificationToUserID} eq 'ARRAY' )
    {
        for my $UserID ( @{ $Param{ExcludeNotificationToUserID} } ) {
            push @SkipRecipients, $UserID;
        }
    }

    # remember agent to exclude notifications / already sent
    my %DoNotSendMute;
    if (
        $Param{ExcludeMuteNotificationToUserID}
        && ref $Param{ExcludeMuteNotificationToUserID} eq 'ARRAY'
        )
    {
        for my $UserID ( @{ $Param{ExcludeMuteNotificationToUserID} } ) {
            push @SkipRecipients, $UserID;
        }
    }

    my $ExtraRecipients;
    if ( $Param{ForceNotificationToUserID} && ref $Param{ForceNotificationToUserID} eq 'ARRAY' ) {
        $ExtraRecipients = $Param{ForceNotificationToUserID};
    }

    # send agent notification on ticket create
    if (
        $FirstArticle &&
        $Param{HistoryType}
        =~ /^(EmailAgent|EmailCustomer|PhoneCallCustomer|WebRequestCustomer|SystemRequest)$/i
        )
    {
        # trigger notification event
        $Self->EventHandler(
            Event => 'NotificationNewTicket',
            Data  => {
                TicketID              => $Param{TicketID},
                ArticleID             => $ArticleID,
                ArticleType           => $Param{ArticleType},
                Queue                 => $Param{Queue},
                Recipients            => $ExtraRecipients,
                SkipRecipients        => \@SkipRecipients,
                CustomerMessageParams => {%Param},
            },
            UserID => $Param{UserID},
        );
    }

    # send agent notification on adding a note
    elsif ( $Param{HistoryType} =~ /^AddNote$/i ) {

        # trigger notification event
        $Self->EventHandler(
            Event => 'NotificationAddNote',
            Data  => {
                TicketID              => $Param{TicketID},
                ArticleID             => $ArticleID,
                ArticleType           => $Param{ArticleType},
                Queue                 => $Param{Queue},
                Recipients            => $ExtraRecipients,
                SkipRecipients        => \@SkipRecipients,
                CustomerMessageParams => {%Param},
            },
            UserID => $Param{UserID},
        );
    }

    # send agent notification on follow up
    elsif ( $Param{HistoryType} =~ /^FollowUp$/i ) {

        # trigger notification event
        $Self->EventHandler(
            Event => 'NotificationFollowUp',
            Data  => {
                TicketID              => $Param{TicketID},
                ArticleID             => $ArticleID,
                ArticleType           => $Param{ArticleType},
                Queue                 => $Param{Queue},
                Recipients            => $ExtraRecipients,
                SkipRecipients        => \@SkipRecipients,
                CustomerMessageParams => {%Param},
            },
            UserID => $Param{UserID},
        );
    }

    # return ArticleID
    return $ArticleID;
}

=item ArticleGetTicketIDOfMessageID()

get ticket id of given message id

    my $TicketID = $TicketObject->ArticleGetTicketIDOfMessageID(
        MessageID => '<13231231.1231231.32131231@example.com>',
    );

=cut

sub ArticleGetTicketIDOfMessageID {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{MessageID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need MessageID!'
        );
        return;
    }
    my $MD5 = $Kernel::OM->Get('Kernel::System::Main')->MD5sum( String => $Param{MessageID} );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql query
    return if !$DBObject->Prepare(
        SQL   => 'SELECT ticket_id FROM article WHERE a_message_id_md5 = ?',
        Bind  => [ \$MD5 ],
        Limit => 10,
    );

    my $TicketID;
    my $Count = 0;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Count++;
        $TicketID = $Row[0];
    }

    # no reference found
    return if $Count == 0;

    # one found
    return $TicketID if $Count == 1;

    # more than one found! that should not be, a message_id should be unique!
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'notice',
        Message  => "The MessageID '$Param{MessageID}' is in your database "
            . "more than one time! That should not be, a message_id should be unique!",
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID!'
        );
        return;
    }

    # check key
    my $CacheKey = 'ArticleGetContentPath::' . $Param{ArticleID};

    # check cache
    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql query
    return if !$DBObject->Prepare(
        SQL  => 'SELECT content_path FROM article WHERE id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    my $Result;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Result = $Row[0];
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => $Result,
    );

    # return
    return $Result;
}

=item ArticleSenderTypeList()

get a article sender type list

    my @ArticleSenderTypeList = $TicketObject->ArticleSenderTypeList(
        Result => 'ARRAY', # optional, ARRAY|HASH
    );

=cut

sub ArticleSenderTypeList {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $DBObject    = $Kernel::OM->Get('Kernel::System::DB');
    my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

    return if !$DBObject->Prepare(
        SQL => "SELECT id, name FROM article_sender_type WHERE "
            . "valid_id IN (${\(join ', ', $ValidObject->ValidIDsGet())})",
    );

    my @Array;
    my %Hash;
    while ( my @Row = $DBObject->FetchrowArray() ) {
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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

    # check cache
    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get data
    if ( $Param{SenderType} ) {
        return if !$DBObject->Prepare(
            SQL  => 'SELECT id FROM article_sender_type WHERE name = ?',
            Bind => [ \$Param{SenderType} ],
        );
    }
    else {
        return if !$DBObject->Prepare(
            SQL  => 'SELECT name FROM article_sender_type WHERE id = ?',
            Bind => [ \$Param{SenderTypeID} ],
        );
    }

    # store result
    my $Result;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Result = $Row[0];
    }

    # check if data exists
    if ( !$Result ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Found no SenderType(ID) for $Key!",
        );
        return;
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => $Result,
    );

    return $Result;
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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
        $CacheKey = 'ArticleTypeLookup::ArticleType::' . $Param{ArticleType};
    }
    else {
        $Key      = $Param{ArticleTypeID};
        $CacheKey = 'ArticleTypeLookup::ArticleTypeID::' . $Param{ArticleTypeID};
    }

    # check cache
    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return $Cache if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get data
    if ( $Param{ArticleType} ) {
        return if !$DBObject->Prepare(
            SQL  => 'SELECT id FROM article_type WHERE name = ?',
            Bind => [ \$Param{ArticleType} ],
        );
    }
    else {
        return if !$DBObject->Prepare(
            SQL  => 'SELECT name FROM article_type WHERE id = ?',
            Bind => [ \$Param{ArticleTypeID} ],
        );
    }

    # store result
    my $Result;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Result = $Row[0];
    }

    # check if data exists
    if ( !$Result ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Found no ArticleType(ID) for $Key!",
        );
        return;
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => $Result,
    );

    # return
    return $Result;
}

=item ArticleTypeList()

get a article type list

    my @ArticleTypeList = $TicketObject->ArticleTypeList(
        Result => 'ARRAY', # optional, ARRAY|HASH
    );

    # to get only article types visible for customers
    my @ArticleTypeList = $TicketObject->ArticleTypeList(
        Result => 'ARRAY',    # optional, ARRAY|HASH
        Type   => 'Customer', # optional to get only customer viewable article types
    );

=cut

sub ArticleTypeList {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $DBObject    = $Kernel::OM->Get('Kernel::System::DB');
    my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

    return if !$DBObject->Prepare(
        SQL => "SELECT id, name FROM article_type WHERE "
            . "valid_id IN (${\(join ', ', $ValidObject->ValidIDsGet())})",
    );

    my @Array;
    my %Hash;
    while ( my @Row = $DBObject->FetchrowArray() ) {
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

=item ArticleLastCustomerArticle()

get last customer article

    my %Article = $TicketObject->ArticleLastCustomerArticle(
        TicketID      => 123,
        Extended      => 1,      # 0 or 1, see ArticleGet(),
        DynamicFields => 1,      # 0 or 1, see ArticleGet(),
    );

=cut

sub ArticleLastCustomerArticle {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TicketID!"
        );
        return;
    }

    # get article index
    my @Index = $Self->ArticleIndex(
        TicketID   => $Param{TicketID},
        SenderType => 'customer'
    );

    # get article data
    if (@Index) {
        return $Self->ArticleGet(
            ArticleID     => $Index[-1],
            Extended      => $Param{Extended},
            DynamicFields => $Param{DynamicFields},
        );
    }

    # get whole article index
    @Index = $Self->ArticleIndex( TicketID => $Param{TicketID} );
    return if !@Index;

    # second try, return latest non internal article
    for my $ArticleID ( reverse @Index ) {
        my %Article = $Self->ArticleGet(
            ArticleID     => $ArticleID,
            Extended      => $Param{Extended},
            DynamicFields => $Param{DynamicFields},
        );
        if ( $Article{StateType} eq 'merged' || $Article{ArticleType} !~ /int/ ) {
            return %Article;
        }
    }

    # third try, if we got no internal article, return the latest one
    return $Self->ArticleGet(
        ArticleID     => $Index[-1],
        Extended      => $Param{Extended},
        DynamicFields => $Param{DynamicFields},
    );
}

=item ArticleFirstArticle()

get first article

    my %Article = $TicketObject->ArticleFirstArticle(
        TicketID      => 123,
        DynamicFields => 1,     # 0 or 1, see ArticleGet()
    );

=cut

sub ArticleFirstArticle {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TicketID!"
        );
        return;
    }

    # get article index
    my @Index = $Self->ArticleIndex( TicketID => $Param{TicketID} );

    # get article data
    return if !@Index;

    return $Self->ArticleGet(
        ArticleID     => $Index[0],
        Extended      => $Param{Extended},
        DynamicFields => $Param{DynamicFields},
    );
}

=item ArticleIndex()

returns an array with article IDs

    my @ArticleIDs = $TicketObject->ArticleIndex(
        TicketID => 123,
    );

    my @ArticleIDs = $TicketObject->ArticleIndex(
        SenderType => 'customer',                   # optional, to limit to a certain sender type
        TicketID   => 123,
    );

=cut

sub ArticleIndex {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TicketID!'
        );
        return;
    }

    # Only cache known sender types, because the cache keys of
    #   unknown ones cannot be invalidated in _TicketCacheClear().
    my %CacheableSenderTypes = (
        'agent'    => 1,
        'customer' => 1,
        'system'   => 1,
        'ALL'      => 1,
    );

    my $UseCache = $CacheableSenderTypes{ $Param{SenderType} || 'ALL' };

    my $CacheKey = 'ArticleIndex::' . $Param{TicketID} . '::' . ( $Param{SenderType} || 'ALL' );

    if ($UseCache) {
        my $Cached = $Kernel::OM->Get('Kernel::System::Cache')->Get(
            Type => $Self->{CacheType},
            Key  => $CacheKey,
        );

        if ( ref $Cached eq 'ARRAY' ) {
            return @{$Cached};
        }

    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db query
    if ( $Param{SenderType} ) {
        return if !$DBObject->Prepare(
            SQL => '
                SELECT art.id FROM article art, article_sender_type ast
                WHERE art.ticket_id = ?
                    AND art.article_sender_type_id = ast.id
                    AND ast.name = ?
                ORDER BY art.id',
            Bind => [ \$Param{TicketID}, \$Param{SenderType} ],
        );
    }
    else {
        return if !$DBObject->Prepare(
            SQL => '
                SELECT id
                FROM article
                WHERE ticket_id = ?
                ORDER BY id',
            Bind => [ \$Param{TicketID} ],
        );
    }

    my @Index;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @Index, $Row[0];
    }

    if ($UseCache) {
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $Self->{CacheType},
            TTL   => $Self->{CacheTTL},
            Key   => $CacheKey,
            Value => \@Index,
        );
    }

    return @Index;
}

=item ArticleContentIndex()

returns an array with hash ref (hash contains result of ArticleGet())

    my @ArticleBox = $TicketObject->ArticleContentIndex(
        TicketID      => 123,
        DynamicFields => 1,         # 0 or 1, default 1. To include or not the dynamic field values on the return structure.
        UserID        => 1,
        Order         => 'ASC',     # 'ASC' or 'DESC', default 'ASC'
    );

or with "StripPlainBodyAsAttachment => 1" feature to not include first
attachment / body and html body as attachment

    my @ArticleBox = $TicketObject->ArticleContentIndex(
        TicketID                   => 123,
        UserID                     => 1,
        StripPlainBodyAsAttachment => 1,
    );

or with "StripPlainBodyAsAttachment => 2" feature to not include first
attachment / body as attachment (html body will be shown as attachment)

    my @ArticleBox = $TicketObject->ArticleContentIndex(
        TicketID                   => 123,
        UserID                     => 1,
        StripPlainBodyAsAttachment => 2,
    );

returns an array with hash ref (hash contains result of ArticleGet())
only with given article types

    my @ArticleBox = $TicketObject->ArticleContentIndex(
        TicketID    => 123,
        UserID      => 1,
        ArticleType => [ $ArticleType1, $ArticleType2 ],
        # or
        ArticleTypeID => [ $ArticleTypeID1, $ArticleTypeID2 ],
    );

Likewise C<ArticleSenderTypeID> allows filtering of only articles with
the given sender type IDs.

example of how to access the hash ref

    for my $Article (@ArticleBox) {
        print "From: $Article->{From}\n";
    }

Note: If an attachment with html body content is available, the attachment id
is returned as 'AttachmentIDOfHTMLBody' in hash ref.

You can limit the list of returned elements with the C<Page> and C<Limit>
parameters:

    my @ArticleBox = $TicketObject->ArticleContentIndex(
        TicketID    => 123,
        UserID      => 1,
        Limit       => 5,
        Page        => 3,   # get 11th to 16th element
    );

=cut

sub ArticleContentIndex {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my @ArticleBox = $Self->ArticleGet(
        TicketID            => $Param{TicketID},
        ArticleType         => $Param{ArticleType},
        UserID              => $Param{UserID},
        DynamicFields       => $Param{DynamicFields},
        Page                => $Param{Page},
        Limit               => $Param{Limit},
        ArticleTypeID       => $Param{ArticleTypeID},
        ArticleSenderTypeID => $Param{ArticleSenderTypeID},
        Order               => $Param{Order},
    );

    # article attachments of each article
    for my $Article (@ArticleBox) {

        # get attachment index (without attachments)
        my %AtmIndex = $Self->ArticleAttachmentIndex(
            ContentPath                => $Article->{ContentPath},
            ArticleID                  => $Article->{ArticleID},
            StripPlainBodyAsAttachment => $Param{StripPlainBodyAsAttachment},
            Article                    => $Article,
            UserID                     => $Param{UserID},
        );
        $Article->{Atms} = \%AtmIndex;
    }
    return @ArticleBox;
}

=item ArticleGet()

returns article data

    my %Article = $TicketObject->ArticleGet(
        ArticleID     => 123,
        DynamicFields => 1,      # Optional. To include the dynamic field values for this article on the return structure.
        UserID        => 123,
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

    # If DynamicFields => 1 was passed, you'll get an entry like this for each dynamic field:
    DynamicField_X     => 'value_x',

Ticket:
    - see TicketGet() for ticket attributes -

returns articles in array / hash by given ticket id

    my @ArticleIndex = $TicketObject->ArticleGet(
        TicketID => 123,
        UserID   => 123,
    );

returns articles in array / hash by given ticket id but
only requested article types

    my @ArticleIndex = $TicketObject->ArticleGet(
        TicketID      => 123,
        ArticleType   => [ $ArticleType1, $ArticleType2 ],
        # or
        ArticleTypeID => [ $ArticleTypeID1, $ArticleTypeID2 ],
        UserID        => 123,
    );

returns articles in array / hash by given ticket id but
only requested article sender types (could be useful when
trying to exclude autoreplies sent by system sender from
certain views)

    my @ArticleIndex = $TicketObject->ArticleGet(
        TicketID            => 123,
        ArticleSenderType   => [ $ArticleSenderType1, $ArticleSenderType2 ],
        # or
        ArticleSenderTypeID => [ $ArticleSenderTypeID1, $ArticleSenderTypeID2 ],
        UserID              => 123,
    );

to get extended ticket attributes, use param Extended - see TicketGet() for extended attributes -

    my @ArticleIndex = $TicketObject->ArticleGet(
        TicketID => 123,
        UserID   => 123,
        Extended => 1,
    );

to get only a dedicated count you can use Limit and Order attributes

    my @ArticleIndex = $TicketObject->ArticleGet(
        TicketID => 123,
        UserID   => 123,
        Order    => 'DESC', # DESC,ASC - default is ASC
        Limit    => 5,
    );

You can also provide an offset by passing the C<Page> argument. To get the
6th to 10th article, you can say

    my @ArticleIndex = $TicketObject->ArticleGet(
        TicketID => 123,
        UserID   => 123,
        Limit    => 5,
        Page     => 2,
    );

Page numbers start with 1.

=cut

sub ArticleGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} && !$Param{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID or TicketID!'
        );
        return;
    }

    my $FetchDynamicFields = $Param{DynamicFields} ? 1 : 0;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # article type lookup
    my $ArticleTypeSQL = '';
    if ( $Param{ArticleType} && ref $Param{ArticleType} eq 'ARRAY' ) {
        for ( @{ $Param{ArticleType} } ) {
            if ( $Self->ArticleTypeLookup( ArticleType => $_ ) ) {
                if ($ArticleTypeSQL) {
                    $ArticleTypeSQL .= ',';
                }
                $ArticleTypeSQL .= $DBObject->Quote(
                    $Self->ArticleTypeLookup( ArticleType => $_ ),
                    'Integer',
                );
            }
        }
        if ($ArticleTypeSQL) {
            $ArticleTypeSQL = " AND sa.article_type_id IN ($ArticleTypeSQL)";
        }
    }
    my $ArticleTypeIDSQL = '';
    if ( IsArrayRefWithData( $Param{ArticleTypeID} ) ) {
        my $QuotedIDs = join ', ',
            map { $DBObject->Quote( $_, 'Integer' ) }
            @{ $Param{ArticleTypeID} };
        $ArticleTypeIDSQL = " AND sa.article_type_id IN ($QuotedIDs)";
    }

    # sender type lookup
    my $SenderTypeSQL = '';
    if ( $Param{ArticleSenderType} && ref $Param{ArticleSenderType} eq 'ARRAY' ) {
        for ( @{ $Param{ArticleSenderType} } ) {
            if ( $Self->ArticleSenderTypeLookup( SenderType => $_ ) ) {
                if ($SenderTypeSQL) {
                    $SenderTypeSQL .= ',';
                }
                $SenderTypeSQL .= $DBObject->Quote(
                    $Self->ArticleSenderTypeLookup( SenderType => $_ ),
                    'Integer',
                );
            }
        }
        if ($SenderTypeSQL) {
            $SenderTypeSQL = " AND sa.article_sender_type_id IN ($SenderTypeSQL)";
        }
    }

    my $SenderTypeIDSQL;
    if ( IsArrayRefWithData( $Param{ArticleSenderTypeID} ) ) {
        my $QuotedIDs = join ', ',
            map { $DBObject->Quote( $_, 'Integer' ) }
            @{ $Param{ArticleSenderTypeID} };
        $SenderTypeIDSQL = " AND sa.article_sender_type_id IN ($QuotedIDs)";
    }

    # sql query
    my @Content;
    my @Bind;
    my $SQL = '
        SELECT sa.ticket_id, sa.a_from, sa.a_to, sa.a_cc, sa.a_subject,
            sa.a_reply_to, sa.a_message_id, sa.a_in_reply_to, sa.a_references, sa.a_body,
            st.create_time_unix, st.ticket_state_id, st.queue_id, sa.create_time,
            sa.a_content_type, sa.create_by, st.tn, article_sender_type_id, st.customer_id,
            st.until_time, st.ticket_priority_id, st.customer_user_id, st.user_id,
            st.responsible_user_id, sa.article_type_id,
            sa.incoming_time, sa.id,
            st.ticket_lock_id, st.title, st.escalation_update_time,
            st.type_id, st.service_id, st.sla_id, st.escalation_response_time,
            st.escalation_solution_time, st.escalation_time, st.change_time
        FROM article sa
        JOIN ticket st ON sa.ticket_id = st.id
        WHERE ';

    if ( $Param{ArticleID} ) {
        $SQL .= 'sa.id = ?';
        push @Bind, \$Param{ArticleID};
    }
    else {
        $SQL .= 'sa.ticket_id = ?';
        push @Bind, \$Param{TicketID};
    }

    # add article types
    if ($ArticleTypeSQL) {
        $SQL .= $ArticleTypeSQL;
    }
    if ($ArticleTypeIDSQL) {
        $SQL .= $ArticleTypeIDSQL;
    }

    # add sender types
    if ($SenderTypeSQL) {
        $SQL .= $SenderTypeSQL;
    }
    if ($SenderTypeIDSQL) {
        $SQL .= $SenderTypeIDSQL;
    }

    # set order
    if ( $Param{Order} && $Param{Order} eq 'DESC' ) {
        $SQL .= ' ORDER BY sa.create_time DESC, sa.id DESC';
    }
    else {
        $SQL .= ' ORDER BY sa.create_time, sa.id ASC';
    }

    my $Start;

    if ( $Param{Page} ) {
        $Start = $Param{Limit} * ( $Param{Page} - 1 );
    }

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Bind  => \@Bind,
        Limit => $Param{Limit},
        Start => $Start,
    );

    my %Ticket;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        my %Data;
        $Data{TicketID}   = $Row[0];
        $Ticket{TicketID} = $Data{TicketID};
        $Data{From}       = $Row[1];
        $Data{To}         = $Row[2];
        $Data{Cc}         = $Row[3];
        $Data{Subject}    = $Row[4];

        $Data{ReplyTo}    = $Row[5];
        $Data{MessageID}  = $Row[6];
        $Data{InReplyTo}  = $Row[7];
        $Data{References} = $Row[8];
        $Data{Body}       = $Row[9];

        $Ticket{CreateTimeUnix} = $Row[10];
        $Data{StateID}          = $Row[11];
        $Ticket{StateID}        = $Row[11];
        $Data{QueueID}          = $Row[12];
        $Ticket{QueueID}        = $Row[12];
        $Ticket{AgeTimeUnix}    = $TimeObject->SystemTime()
            - $TimeObject->TimeStamp2SystemTime( String => $Row[13] );
        $Ticket{Created} = $TimeObject->SystemTime2TimeStamp( SystemTime => $Ticket{CreateTimeUnix} );
        $Data{ContentType} = $Row[14];

        $Data{CreatedBy}           = $Row[15];
        $Data{TicketNumber}        = $Row[16];
        $Data{SenderTypeID}        = $Row[17];
        $Data{CustomerID}          = $Row[18];
        $Ticket{CustomerID}        = $Row[18];
        $Data{RealTillTimeNotUsed} = $Row[19];

        $Data{PriorityID}       = $Row[20];
        $Ticket{PriorityID}     = $Row[20];
        $Data{CustomerUserID}   = $Row[21];
        $Ticket{CustomerUserID} = $Row[21];
        $Data{OwnerID}          = $Row[22];
        $Ticket{OwnerID}        = $Row[22];
        $Data{ResponsibleID}    = $Row[23] || 1;
        $Ticket{ResponsibleID}  = $Row[23] || 1;
        $Data{ArticleTypeID}    = $Row[24];

        $Data{IncomingTime} = $Row[25];
        $Data{Created}      = $TimeObject->SystemTime2TimeStamp(
            SystemTime => $Row[25],
        );
        $Data{ArticleID}              = $Row[26];
        $Ticket{LockID}               = $Row[27];
        $Data{Title}                  = $Row[28];
        $Ticket{Title}                = $Data{Title};
        $Data{EscalationUpdateTime}   = $Row[29];
        $Ticket{EscalationUpdateTime} = $Data{EscalationUpdateTime};

        $Data{TypeID}                   = $Row[30];
        $Ticket{TypeID}                 = $Row[30];
        $Data{ServiceID}                = $Row[31];
        $Ticket{ServiceID}              = $Row[31];
        $Data{SLAID}                    = $Row[32];
        $Ticket{SLAID}                  = $Row[32];
        $Data{EscalationResponseTime}   = $Row[33];
        $Ticket{EscalationResponseTime} = $Data{EscalationResponseTime};
        $Data{EscalationSolutionTime}   = $Row[34];
        $Ticket{EscalationSolutionTime} = $Data{EscalationSolutionTime};
        $Data{EscalationTime}           = $Row[35];
        $Ticket{EscalationTime}         = $Data{EscalationTime};
        $Ticket{Changed}                = $Row[36];

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

        # fill up dynamic variables
        $Data{Age} = $TimeObject->SystemTime() - $Ticket{CreateTimeUnix};

        # strip not wanted stuff
        RECIPIENT:
        for my $Key (qw(From To Cc Subject)) {
            next RECIPIENT if !$Data{$Key};
            $Data{$Key} =~ s/\n|\r//g;
        }

        push @Content, { %Ticket, %Data };
    }

    # check if need to return dynamic fields
    if ($FetchDynamicFields) {

        # get dynamic field objects
        my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        my $DynamicFieldArticleList = $DynamicFieldObject->DynamicFieldListGet(
            ObjectType => 'Article'
        );

        my $DynamicFieldTicketList = $DynamicFieldObject->DynamicFieldListGet(
            ObjectType => 'Ticket'
        );

        for my $Article (@Content) {
            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{$DynamicFieldArticleList} ) {

                # validate each dynamic field
                next DYNAMICFIELD if !$DynamicFieldConfig;
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
                next DYNAMICFIELD if !IsHashRefWithData( $DynamicFieldConfig->{Config} );

                # get the current value for each dynamic field
                my $Value = $DynamicFieldBackendObject->ValueGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ObjectID           => $Article->{ArticleID},
                );

                # set the dynamic field name and value into the ticket hash
                $Article->{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $Value;
            }

            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{$DynamicFieldTicketList} ) {

                # validate each dynamic field
                next DYNAMICFIELD if !$DynamicFieldConfig;
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
                next DYNAMICFIELD if !IsHashRefWithData( $DynamicFieldConfig->{Config} );

                # get the current value for each dynamic field
                my $Value = $DynamicFieldBackendObject->ValueGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ObjectID           => $Article->{TicketID},
                );

                # set the dynamic field name and value into the ticket hash
                $Article->{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $Value;

                # check if field is TicketFreeKey[1-16], TicketFreeText[1-6] or TicketFreeTime[1-6]
                # Compatibility feature can be removed on further versions
                if (
                    $DynamicFieldConfig->{Name} =~ m{
                        \A
                        (
                            TicketFree
                            (?:
                                (?:Text|Key)
                                (?:1[0-6]|[1-9])
                                |
                                (?:Time [1-6])
                            )
                        )
                        \z
                    }smxi
                    )
                {

                    # Set field for 3.0 and 2.4 compatibility
                    $Article->{ $DynamicFieldConfig->{Name} } = $Value;
                }
            }
        }
    }

    # return if content is empty
    if ( !@Content ) {

        # Log an error only if a specific article was requested and there is no filter active.
        if ( $Param{ArticleID} && !$ArticleTypeSQL && !$SenderTypeSQL ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "No such article for ArticleID ($Param{ArticleID})!",
            );
        }

        return;
    }

    # get type
    $Ticket{Type} = $Kernel::OM->Get('Kernel::System::Type')->TypeLookup(
        TypeID => $Ticket{TypeID} || 1,
    );

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    # get owner
    $Ticket{Owner} = $UserObject->UserLookup(
        UserID => $Ticket{OwnerID},
    );

    # get responsible
    $Ticket{Responsible} = $UserObject->UserLookup(
        UserID => $Ticket{ResponsibleID},
    );

    # get priority
    $Ticket{Priority} = $Kernel::OM->Get('Kernel::System::Priority')->PriorityLookup(
        PriorityID => $Ticket{PriorityID},
    );

    # get lock
    $Ticket{Lock} = $Kernel::OM->Get('Kernel::System::Lock')->LockLookup(
        LockID => $Ticket{LockID},
    );

    # get service
    if ( $Ticket{ServiceID} ) {
        $Ticket{Service} = $Kernel::OM->Get('Kernel::System::Service')->ServiceLookup(
            ServiceID => $Ticket{ServiceID},
        );
    }

    # get sla
    if ( $Ticket{SLAID} ) {
        $Ticket{SLA} = $Kernel::OM->Get('Kernel::System::SLA')->SLALookup(
            SLAID => $Ticket{SLAID},
        );
    }

    # get queue name and other stuff
    my %Queue = $Kernel::OM->Get('Kernel::System::Queue')->QueueGet(
        ID => $Ticket{QueueID},
    );

    # get state info
    my %StateData = $Kernel::OM->Get('Kernel::System::State')->StateGet(
        ID => $Ticket{StateID},
    );

    $Ticket{StateType} = $StateData{TypeName};
    $Ticket{State}     = $StateData{Name};

    # get escalation attributes
    my %Escalation = $Self->TicketEscalationDateCalculation(
        Ticket => \%Ticket,
        UserID => $Param{UserID} || 1,
    );
    for my $Part (@Content) {
        for ( sort keys %Escalation ) {
            $Part->{$_} = $Escalation{$_};
        }
    }

    # do extended lookups
    if ( $Param{Extended} ) {
        my %TicketExtended = $Self->_TicketGetExtended(
            TicketID => $Ticket{TicketID},
            Ticket   => \%Ticket,
        );
        for my $Key ( sort keys %TicketExtended ) {
            $Ticket{$Key} = $TicketExtended{$Key};
        }
        for my $Part (@Content) {
            for ( sort keys %TicketExtended ) {
                $Part->{$_} = $TicketExtended{$_};
            }
        }
    }

    # create email parser object
    my $EmailParser = Kernel::System::EmailParser->new(
        Mode => 'Standalone',
    );

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
            $Part->{UntilTime} = $Part->{RealTillTimeNotUsed} - $TimeObject->SystemTime();
        }
        $Part->{StateType} = $StateData{TypeName};
        $Part->{State}     = $StateData{Name};

        # add real name lines
        RECIPIENT:
        for my $Key (qw( From To Cc)) {
            next RECIPIENT if !$Part->{$Key};

            # check if it's a queue
            if ( $Part->{$Key} !~ /@/ ) {
                $Part->{ $Key . 'Realname' } = $Part->{$Key};
                next RECIPIENT;
            }

            # strip out real names
            my $Realname = '';
            EMAILADDRESS:
            for my $EmailSplit ( $EmailParser->SplitAddressLine( Line => $Part->{$Key} ) ) {
                my $Name = $EmailParser->GetRealname( Email => $EmailSplit );
                if ( !$Name ) {
                    $Name = $EmailParser->GetEmailAddress( Email => $EmailSplit );
                }
                next EMAILADDRESS if !$Name;
                if ($Realname) {
                    $Realname .= ', ';
                }
                $Realname .= $Name;
            }

            $Part->{ $Key . 'Realname' } = $Realname;
        }
    }

    if ( $Param{ArticleID} ) {
        return %{ $Content[0] };
    }
    return @Content;
}

=item ArticleCount()

Returns the number of articles for a ticket, possibly filtered by
ArticleSenderTypeID and ArticleTypeID

    my $ArticleCount = $TicketID->ArticleCount(
        TicketID            => 123,
        ArticleTypeID       => [1, 2], # optional
        ArticleSenderTypeID => [1, 2], # optional
    );

If the argument C<UpToArticleID> is given, only articles that would normally
shown before (and including) this article are shown; C<Order> (which can
be C<ASC> or C<DESC>) controls whether ascending or descending order is used.

=cut

sub ArticleCount {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TicketID!'
        );
        return;
    }

    my $SQL  = 'SELECT COUNT(id) FROM article WHERE ticket_id = ?';
    my @Bind = ( \$Param{TicketID} );
    if ( IsArrayRefWithData( $Param{ArticleTypeID} ) ) {
        $SQL .= sprintf ' AND article_type_id IN (%s) ',
            join ', ', ('?') x @{ $Param{ArticleTypeID} };
        push @Bind, map { \$_ } @{ $Param{ArticleTypeID} };
    }
    if ( IsArrayRefWithData( $Param{ArticleSenderTypeID} ) ) {
        $SQL .= sprintf ' AND article_sender_type_id IN (%s) ',
            join ', ', ('?') x @{ $Param{ArticleSenderTypeID} };
        push @Bind, map { \$_ } @{ $Param{ArticleSenderTypeID} };
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( defined $Param{UpToArticleID} ) {

        $DBObject->Prepare(
            SQL  => 'SELECT create_time FROM article WHERE id = ?',
            Bind => [ \$Param{UpToArticleID} ],
        );

        my $CreateTime;

        while ( my @Row = $DBObject->FetchrowArray() ) {
            $CreateTime = $Row[0];
        }

        if ( !defined $CreateTime ) {
            return 0;
        }

        my $Op = ( $Param{Order} // 'ASC' ) eq 'DESC' ? '>' : '<';

        $SQL .= " AND (create_time $Op ? OR (create_time = ? AND id $Op= ?))";
        push @Bind, \$CreateTime, \$CreateTime, \$Param{UpToArticleID};
    }

    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind
    );

    my $Count;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Count = $Row[0];
    }

    return $Count;
}

=item ArticlePage()

Get the page number of a given article when pagination is active

    my $Page = $TicketObject->ArticlePage(
        TicketID            => 123,
        ArticleID           => 4242,
        RowsPerPage         => 20,
        ArticleTypeID       => [1, 2], # optional
        ArticleSenderTypeID => [1],    # optional
        Order               => 'DESC', # optional, 'ASC' or 'DESC'
    );

=cut

sub ArticlePage {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ArticleID TicketID RowsPerPage)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my $Count = $Self->ArticleCount(
        TicketID            => $Param{TicketID},
        UpToArticleID       => $Param{ArticleID},
        ArticleSenderTypeID => $Param{ArticleSenderTypeID},
        ArticleTypeID       => $Param{ArticleTypeID},
        Order               => $Param{Order},
    );

    return ceil( $Count / $Param{RowsPerPage} );
}

=begin Internal:

=cut

sub _ArticleGetId {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID MessageID From Subject IncomingTime)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
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
    $SQL .= ' incoming_time = ? ORDER BY id DESC';
    push @Bind, \$Param{IncomingTime};

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # start query
    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Bind  => \@Bind,
        Limit => 1,
    );

    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }

    return $ID;
}

=end Internal:

=item ArticleUpdate()

update an article

Note: Keys "Body", "Subject", "From", "To", "Cc", "ReplyTo", "ArticleType" and "SenderType" are implemented.

    my $Success = $TicketObject->ArticleUpdate(
        ArticleID => 123,
        Key       => 'Body',
        Value     => 'New Body',
        UserID    => 123,
        TicketID  => 123,
    );

    my $Success = $TicketObject->ArticleUpdate(
        ArticleID => 123,
        Key       => 'ArticleType',
        Value     => 'email-internal',
        UserID    => 123,
        TicketID  => 123,
    );

Events:
    ArticleUpdate

=cut

sub ArticleUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID UserID Key TicketID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # check needed stuff
    if ( !defined $Param{Value} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Value!'
        );
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
        ReplyTo       => 'a_reply_to',
        To            => 'a_to',
        Cc            => 'a_cc',
        ArticleTypeID => 'article_type_id',
        SenderTypeID  => 'article_sender_type_id',
    );

    # db update
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => "UPDATE article SET $Map{$Param{Key}} = ?, "
            . "change_time = current_timestamp, change_by = ? WHERE id = ?",
        Bind => [ \$Param{Value}, \$Param{UserID}, \$Param{ArticleID} ],
    );

    $Self->_TicketCacheClear( TicketID => $Param{TicketID} );

    # event
    $Self->EventHandler(
        Event => 'ArticleUpdate',
        Data  => {
            TicketID  => $Param{TicketID},
            ArticleID => $Param{ArticleID},
        },
        UserID => $Param{UserID},
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
        ReplyTo     => 'Some Customer B <customer-b@example.com>',             # not required, is possible to use 'Reply-To' instead
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

Events:
    ArticleSend

=cut

sub ArticleSend {
    my ( $Self, %Param ) = @_;

    my $ToOrig      = $Param{To}          || '';
    my $Loop        = $Param{Loop}        || 0;
    my $HistoryType = $Param{HistoryType} || 'SendAnswer';

    # check needed stuff
    for (qw(TicketID UserID From Body Charset MimeType)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    if ( !$Param{ArticleType} && !$Param{ArticleTypeID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleType or ArticleTypeID!',
        );
        return;
    }
    if ( !$Param{SenderType} && !$Param{SenderTypeID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need SenderType or SenderTypeID!',
        );
        return;
    }

    # map ReplyTo into Reply-To if present
    if ( $Param{ReplyTo} ) {
        $Param{'Reply-To'} = $Param{ReplyTo};
    }

    # clean up
    $Param{Body} =~ s/(\r\n|\n\r)/\n/g;
    $Param{Body} =~ s/\r/\n/g;

    # check for base64 images in body and process them
    $Kernel::OM->Get('Kernel::System::HTMLUtils')->EmbeddedImagesExtract(
        DocumentRef    => \$Param{Body},
        AttachmentsRef => $Param{Attachment} || [],
    );

    # create article
    my $Time      = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();
    my $Random    = rand 999999;
    my $FQDN      = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');
    my $MessageID = "<$Time.$Random.$Param{TicketID}.$Param{UserID}\@$FQDN>";
    my $ArticleID = $Self->ArticleCreate(
        %Param,
        MessageID => $MessageID,
    );
    return if !$ArticleID;

    # send mail
    my ( $HeadRef, $BodyRef ) = $Kernel::OM->Get('Kernel::System::Email')->Send(
        'Message-ID' => $MessageID,
        %Param,
    );

    # return if no mail was able to send
    if ( !$HeadRef || !$BodyRef ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Message  => "Impossible to send message to: $Param{'To'} .",
            Priority => 'error',
        );
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
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message  => "Sent email to '$ToOrig' from '$Param{From}'. "
            . "HistoryType => $HistoryType, Subject => $Param{Subject};",
    );

    # event
    $Self->EventHandler(
        Event => 'ArticleSend',
        Data  => {
            TicketID  => $Param{TicketID},
            ArticleID => $ArticleID,
        },
        UserID => $Param{UserID},
    );

    return $ArticleID;
}

=item ArticleBounce()

bounce an article

    my $Success = $TicketObject->ArticleBounce(
        From      => 'some@example.com',
        To        => 'webmaster@example.com',
        TicketID  => 123,
        ArticleID => 123,
        UserID    => 123,
    );

Events:
    ArticleBounce

=cut

sub ArticleBounce {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID ArticleID From To UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # create message id
    my $Time         = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();
    my $Random       = rand 999999;
    my $FQDN         = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');
    my $NewMessageID = "<$Time.$Random.$Param{TicketID}.0.$Param{UserID}\@$FQDN>";
    my $Email        = $Self->ArticlePlain( ArticleID => $Param{ArticleID} );

    # check if plain email exists
    if ( !$Email ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such plain article for ArticleID ($Param{ArticleID})!",
        );
        return;
    }

    # pipe all into sendmail
    return if !$Kernel::OM->Get('Kernel::System::Email')->Bounce(
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

    # event
    $Self->EventHandler(
        Event => 'ArticleBounce',
        Data  => {
            TicketID  => $Param{TicketID},
            ArticleID => $Param{ArticleID},
        },
        UserID => $Param{UserID},
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

Events:
    ArticleAutoResponse

=cut

sub SendAutoResponse {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID UserID OrigHeader AutoResponseType)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # return if no notification is active
    return 1 if $Self->{SendNoNotification};

    # get orig email header
    my %OrigHeader = %{ $Param{OrigHeader} };

    # get ticket
    my %Ticket = $Self->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,                  # not needed here, TemplateGenerator will fetch the ticket on its own
    );

    # get auto default responses
    my %AutoResponse = $Kernel::OM->Get('Kernel::System::TemplateGenerator')->AutoResponse(
        TicketID         => $Param{TicketID},
        AutoResponseType => $Param{AutoResponseType},
        OrigHeader       => $Param{OrigHeader},
        UserID           => $Param{UserID},
    );

    # return if no valid auto response exists
    return if !$AutoResponse{Text};
    return if !$AutoResponse{SenderRealname};
    return if !$AutoResponse{SenderAddress};

    # send if notification should be sent (not for closed tickets)!?
    my %State = $Kernel::OM->Get('Kernel::System::State')->StateGet( ID => $Ticket{StateID} );
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

    # log that no auto response was sent!
    if ( $OrigHeader{'X-OTRS-Loop'} ) {

        # add history row
        $Self->HistoryAdd(
            TicketID    => $Param{TicketID},
            HistoryType => 'Misc',
            Name        => "Sent no auto-response because the sender doesn't want "
                . "an auto-response (e. g. loop or precedence header)",
            CreateUserID => $Param{UserID},
        );
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'info',
            Message  => "Sent no '$Param{AutoResponseType}' for Ticket ["
                . "$Ticket{TicketNumber}] ($OrigHeader{From}) because the "
                . "sender doesn't want an auto-response (e. g. loop or precedence header)"
        );
        return;
    }

    # check reply to for auto response recipient
    if ( $OrigHeader{ReplyTo} ) {
        $OrigHeader{From} = $OrigHeader{ReplyTo};
    }

    # get loop protection object
    my $LoopProtectionObject = $Kernel::OM->Get('Kernel::System::PostMaster::LoopProtection');

    # create email parser object
    my $EmailParser = Kernel::System::EmailParser->new(
        Mode => 'Standalone',
    );

    my @AutoReplyAddresses;
    my @Addresses = $EmailParser->SplitAddressLine( Line => $OrigHeader{From} );
    ADDRESS:
    for my $Address (@Addresses) {
        my $Email = $EmailParser->GetEmailAddress( Email => $Address );
        if ( !$Email ) {

            # add it to ticket history
            $Self->HistoryAdd(
                TicketID     => $Param{TicketID},
                CreateUserID => $Param{UserID},
                HistoryType  => 'Misc',
                Name         => "Sent no auto response to '$Address' - no valid email address.",
            );

            # log
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => "Sent no auto response to '$Address' because of invalid address.",
            );
            next ADDRESS;

        }
        if ( !$LoopProtectionObject->Check( To => $Email ) ) {

            # add history row
            $Self->HistoryAdd(
                TicketID     => $Param{TicketID},
                HistoryType  => 'LoopProtection',
                Name         => "\%\%$Email",
                CreateUserID => $Param{UserID},
            );

            # log
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => "Sent no '$Param{AutoResponseType}' for Ticket ["
                    . "$Ticket{TicketNumber}] ($Email) because of loop protection."
            );
            next ADDRESS;
        }
        else {

            # increase loop count
            return if !$LoopProtectionObject->SendEmail( To => $Email );
        }

        # check if sender is e. g. MAILER-DAEMON or Postmaster
        my $NoAutoRegExp = $Kernel::OM->Get('Kernel::Config')->Get('SendNoAutoResponseRegExp');
        if ( $Email =~ /$NoAutoRegExp/i ) {

            # add it to ticket history
            $Self->HistoryAdd(
                TicketID     => $Param{TicketID},
                CreateUserID => $Param{UserID},
                HistoryType  => 'Misc',
                Name         => "Sent no auto response to '$Email', SendNoAutoResponseRegExp matched.",
            );

            # log
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'info',
                Message  => "Sent no auto response to '$Email' because config"
                    . " option SendNoAutoResponseRegExp (/$NoAutoRegExp/i) matched.",
            );
            next ADDRESS;
        }

        push @AutoReplyAddresses, $Address;
    }

    my $AutoReplyAddresses = join( ', ', @AutoReplyAddresses );
    my $Cc;

    # also send CC to customer user if customer user id is used and addresses do not match
    if ( $Ticket{CustomerUserID} ) {

        my %CustomerUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $Ticket{CustomerUserID},
        );

        if ( $CustomerUser{UserEmail} && $OrigHeader{From} !~ /\Q$CustomerUser{UserEmail}\E/i ) {
            $Cc = $CustomerUser{UserEmail};
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

    if ( !@AutoReplyAddresses && !$Cc ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'info',
            Message  => "No auto response addresses for Ticket [$Ticket{TicketNumber}]"
                . " (TicketID=$Param{TicketID})."
        );
        return;
    }

    # send email
    my $ArticleID = $Self->ArticleSend(
        ArticleType    => 'email-external',
        SenderType     => 'system',
        TicketID       => $Param{TicketID},
        HistoryType    => $HistoryType,
        HistoryComment => "\%\%$AutoReplyAddresses",
        From           => "$AutoResponse{SenderRealname} <$AutoResponse{SenderAddress}>",
        To             => $AutoReplyAddresses,
        Cc             => $Cc,
        Charset        => 'utf-8',
        MimeType       => $AutoResponse{ContentType},
        Subject        => $AutoResponse{Subject},
        Body           => $AutoResponse{Text},
        InReplyTo      => $OrigHeader{'Message-ID'},
        Loop           => 1,
        UserID         => $Param{UserID},
    );

    # log
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message  => "Sent auto response ($HistoryType) for Ticket [$Ticket{TicketNumber}]"
            . " (TicketID=$Param{TicketID}, ArticleID=$ArticleID) to '$AutoReplyAddresses'."
    );

    # event
    $Self->EventHandler(
        Event => 'ArticleAutoResponse',
        Data  => {
            TicketID => $Param{TicketID},
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=item ArticleFlagSet()

set article flags

    my $Success = $TicketObject->ArticleFlagSet(
        ArticleID => 123,
        Key       => 'Seen',
        Value     => 1,
        UserID    => 123,
    );

Events:
    ArticleFlagSet

=cut

sub ArticleFlagSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID Key Value UserID)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my %Flag = $Self->ArticleFlagGet(%Param);

    # check if set is needed
    return 1 if defined $Flag{ $Param{Key} } && $Flag{ $Param{Key} } eq $Param{Value};

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # set flag
    return if !$DBObject->Do(
        SQL => '
            DELETE FROM article_flag
            WHERE article_id = ?
                AND article_key = ?
                AND create_by = ?',
        Bind => [ \$Param{ArticleID}, \$Param{Key}, \$Param{UserID} ],
    );
    return if !$DBObject->Do(
        SQL => 'INSERT INTO article_flag
            (article_id, article_key, article_value, create_time, create_by)
            VALUES (?, ?, ?, current_timestamp, ?)',
        Bind => [ \$Param{ArticleID}, \$Param{Key}, \$Param{Value}, \$Param{UserID} ],
    );

    # event
    my %Article = $Self->ArticleGet(
        ArticleID     => $Param{ArticleID},
        UserID        => $Param{UserID},
        DynamicFields => 0,
    );
    $Self->EventHandler(
        Event => 'ArticleFlagSet',
        Data  => {
            TicketID  => $Article{TicketID},
            ArticleID => $Param{ArticleID},
            Key       => $Param{Key},
            Value     => $Param{Value},
            UserID    => $Param{UserID},
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=item ArticleFlagDelete()

delete article flag

    my $Success = $TicketObject->ArticleFlagDelete(
        ArticleID => 123,
        Key       => 'seen',
        UserID    => 123,
    );

    my $Success = $TicketObject->ArticleFlagDelete(
        ArticleID => 123,
        Key       => 'seen',
        AllUsers  => 1,         # delete for all users
    );

Events:
    ArticleFlagDelete

=cut

sub ArticleFlagDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID Key)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    if ( !$Param{AllUsers} && !$Param{UserID} ) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need AllUsers or UserID!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $Param{AllUsers} ) {
        return if !$DBObject->Do(
            SQL => '
                DELETE FROM article_flag
                WHERE article_id = ?
                    AND article_key = ?',
            Bind => [ \$Param{ArticleID}, \$Param{Key} ],
        );
    }
    else {
        return if !$DBObject->Do(
            SQL => '
                DELETE FROM article_flag
                WHERE article_id = ?
                    AND create_by = ?
                    AND article_key = ?',
            Bind => [ \$Param{ArticleID}, \$Param{UserID}, \$Param{Key} ],
        );

        # event
        my %Article = $Self->ArticleGet(
            ArticleID     => $Param{ArticleID},
            UserID        => $Param{UserID},
            DynamicFields => 0,
        );

        $Self->EventHandler(
            Event => 'ArticleFlagDelete',
            Data  => {
                TicketID  => $Article{TicketID},
                ArticleID => $Param{ArticleID},
                Key       => $Param{Key},
                UserID    => $Param{UserID},
            },
            UserID => $Param{UserID},
        );
    }

    return 1;
}

=item ArticleFlagGet()

get article flags

    my %Flags = $TicketObject->ArticleFlagGet(
        ArticleID => 123,
        UserID    => 123,
    );

=cut

sub ArticleFlagGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql query
    return if !$DBObject->Prepare(
        SQL => '
            SELECT article_key, article_value
            FROM article_flag
            WHERE article_id = ?
                AND create_by = ?',
        Bind  => [ \$Param{ArticleID}, \$Param{UserID} ],
        Limit => 1500,
    );

    my %Flag;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Flag{ $Row[0] } = $Row[1];
    }

    return %Flag;
}

=item ArticleFlagsOfTicketGet()

get all article flags of a ticket

    my %Flags = $TicketObject->ArticleFlagsOfTicketGet(
        TicketID  => 123,
        UserID    => 123,
    );

    returns (
        123 => {                    # ArticleID
            'Seen'  => 1,
            'Other' => 'something',
        },
    )

=cut

sub ArticleFlagsOfTicketGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql query
    return if !$DBObject->Prepare(
        SQL => '
            SELECT article.id, article_flag.article_key, article_flag.article_value
            FROM article_flag, article
            WHERE article.id = article_flag.article_id
                AND article.ticket_id = ?
                AND article_flag.create_by = ?',
        Bind  => [ \$Param{TicketID}, \$Param{UserID} ],
        Limit => 1500,
    );

    my %Flag;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Flag{ $Row[0] }->{ $Row[1] } = $Row[2];
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID!'
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db query
    return if !$DBObject->Prepare(
        SQL  => 'SELECT time_unit FROM time_accounting WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    my $AccountedTime = 0;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Row[0] =~ s/,/./g;
        $AccountedTime = $AccountedTime + $Row[0];
    }

    return $AccountedTime;
}

=item ArticleAccountedTimeDelete()

delete accounted time of article

    my $Success = $TicketObject->ArticleAccountedTimeDelete(
        ArticleID => $ArticleID,
    );

=cut

sub ArticleAccountedTimeDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID!'
        );
        return;
    }

    # db query
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM time_accounting WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    return 1;
}

1;

# the following is the pod for Kernel/System/Ticket/ArticleStorage*.pm

=item ArticleDelete()

delete an article, its plain message, and all attachments

    my $Success = $TicketObject->ArticleDelete(
        ArticleID => 123,
        UserID    => 123,
    );

=item ArticleDeletePlain()

delete a plain article

    my $Success = $TicketObject->ArticleDeletePlain(
        ArticleID => 123,
        UserID    => 123,
    );

=item ArticleDeleteAttachment()

delete all attachments of an article

    my $Success = $TicketObject->ArticleDeleteAttachment(
        ArticleID => 123,
        UserID    => 123,
    );

=item ArticleWritePlain()

write a plain email to storage

    my $Success = $TicketObject->ArticleWritePlain(
        ArticleID => 123,
        Email     => $EmailAsString,
        UserID    => 123,
    );

=item ArticlePlain()

get plain article/email

    my $PlainMessage = $TicketObject->ArticlePlain(
        ArticleID => 123,
        UserID    => 123,
    );

=item ArticleWriteAttachment()

write an article attachment to storage

    my $Success = $TicketObject->ArticleWriteAttachment(
        Content            => $ContentAsString,
        ContentType        => 'text/html; charset="iso-8859-15"',
        Filename           => 'lala.html',
        ContentID          => 'cid-1234',   # optional
        ContentAlternative => 0,            # optional, alternative content to shown as body
        Disposition        => 'attachment', # or 'inline'
        ArticleID          => 123,
        UserID             => 123,
    );

You also can use "Force => 1" to not check if a filename already exists, it force to use the given file name. Otherwise a new file name like "oldfile-2.html" is used.

=item ArticleAttachment()

get article attachment (Content, ContentType, Filename and optional ContentID, ContentAlternative)

    my %Attachment = $TicketObject->ArticleAttachment(
        ArticleID => 123,
        FileID    => 1,   # as returned by ArticleAttachmentIndex
        UserID    => 123,
    );

returns:

    my %Attachment = (
        Content            => "xxxx",     # actual attachment contents
        ContentAlternative => "",
        ContentID          => "",
        ContentType        => "application/pdf",
        Filename           => "StdAttachment-Test1.pdf",
        Filesize           => "4.6 KBytes",
        FilesizeRaw        => 4722,
        Disposition        => 'attachment',
    );

=item ArticleAttachmentIndex()

get article attachment index as hash

 (ID => hashref (Filename, Filesize, ContentID (if exists), ContentAlternative(if exists) ))

    my %Index = $TicketObject->ArticleAttachmentIndex(
        ArticleID => 123,
        UserID    => 123,
    );

or with "StripPlainBodyAsAttachment => 1" feature to not include first
attachment (not include text body, html body as attachment and inline attachments)

    my %Index = $TicketObject->ArticleAttachmentIndex(
        ArticleID                  => 123,
        UserID                     => 123,
        Article                    => \%Article,
        StripPlainBodyAsAttachment => 1,
    );

or with "StripPlainBodyAsAttachment => 2" feature to not include first
attachment (not include text body as attachment)

    my %Index = $TicketObject->ArticleAttachmentIndex(
        ArticleID                  => 123,
        UserID                     => 123,
        Article                    => \%Article,
        StripPlainBodyAsAttachment => 2,
    );

or with "StripPlainBodyAsAttachment => 3" feature to not include first
attachment (not include text body and html body as attachment)

    my %Index = $TicketObject->ArticleAttachmentIndex(
        ArticleID                  => 123,
        UserID                     => 123,
        Article                    => \%Article,
        StripPlainBodyAsAttachment => 3,
    );

returns:

    my %Index = {
        '1' => {
            ContentAlternative => '',
            ContentID          => '',
            Filesize           => '4.6 KBytes',
            ContentType        => 'application/pdf',
            Filename           => 'StdAttachment-Test1.pdf',
            FilesizeRaw        => 4722,
            Disposition        => attachment,
        },
        '2' => {
            ContentAlternative => '',
            ContentID          => '',
            Filesize           => '183 Bytes',
            ContentType        => 'text/html; charset="utf-8"',
            Filename           => 'file-2',
            FilesizeRaw        => 183,
            Disposition        => attachment,
        },
    };

=cut

sub ArticleAttachmentIndex {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ArticleID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # get attachment index from backend
    my %Attachments = $Self->ArticleAttachmentIndexRaw(%Param);

    # stript plain attachments and e. g. html attachments
    if ( $Param{StripPlainBodyAsAttachment} && $Param{Article} ) {

        # plain attachment mime type vs. html attachment mime type check
        # remove plain body, rename html attachment
        my $AttachmentIDPlain = 0;
        my $AttachmentIDHTML  = 0;
        for my $AttachmentID ( sort keys %Attachments ) {
            my %File = %{ $Attachments{$AttachmentID} };

            # find plain attachment
            if (
                !$AttachmentIDPlain
                &&
                $File{Filename} eq 'file-1'
                && $File{ContentType} =~ /text\/plain/i
                )
            {
                $AttachmentIDPlain = $AttachmentID;
            }

            # find html attachment
            #  o file-[12], is plain+html attachment
            #  o file-1.html, is only html attachment
            if (
                !$AttachmentIDHTML
                &&
                ( $File{Filename} =~ /^file-[12]$/ || $File{Filename} eq 'file-1.html' )
                && $File{ContentType} =~ /text\/html/i
                )
            {
                $AttachmentIDHTML = $AttachmentID;
            }
        }
        if ($AttachmentIDHTML) {
            delete $Attachments{$AttachmentIDPlain};

            # remove any files with content-id from attachment list and listed in html body
            if ( $Param{StripPlainBodyAsAttachment} eq 1 ) {

                # get html body
                my %Attachment = $Self->ArticleAttachment(
                    ArticleID => $Param{ArticleID},
                    FileID    => $AttachmentIDHTML,
                    UserID    => $Param{UserID},
                );

                ATTACHMENT:
                for my $AttachmentID ( sort keys %Attachments ) {
                    my %File = %{ $Attachments{$AttachmentID} };
                    next ATTACHMENT if !$File{ContentID};

                    # content id cleanup
                    $File{ContentID} =~ s/^<//;
                    $File{ContentID} =~ s/>$//;
                    if (
                        $File{ContentID}
                        && $Attachment{Content} =~ /\Q$File{ContentID}\E/i
                        && $File{Disposition} eq 'inline'
                        )
                    {
                        delete $Attachments{$AttachmentID};
                    }
                }
            }

            # only strip html body attachment by "1" or "3"
            if (
                $Param{StripPlainBodyAsAttachment} eq 1
                || $Param{StripPlainBodyAsAttachment} eq 3
                )
            {
                delete $Attachments{$AttachmentIDHTML};
            }
            $Param{Article}->{AttachmentIDOfHTMLBody} = $AttachmentIDHTML;
        }

        # plain body size vs. attched body size check
        # and remove attachment if it's email body
        if ( !$AttachmentIDHTML ) {
            my $AttachmentIDPlain = 0;
            my %AttachmentFilePlain;
            ATTACHMENT_ID:
            for my $AttachmentID ( sort keys %Attachments ) {
                my %File = %{ $Attachments{$AttachmentID} };

                # remember, file-1 got defined by parsing if no filename was given
                if (
                    $File{Filename} eq 'file-1'
                    && $File{ContentType} =~ /text\/plain/i
                    )
                {
                    $AttachmentIDPlain   = $AttachmentID;
                    %AttachmentFilePlain = %File;
                    last ATTACHMENT_ID;
                }
            }

            # plain attachment detected and remove it from attachment index
            if (%AttachmentFilePlain) {

                # check body size vs. attachment size to be sure
                my $BodySize = bytes::length( $Param{Article}->{Body} );

                # check size by tolerance of 1.1 factor (because of charset difs)
                if (
                    $BodySize / 1.1 < $AttachmentFilePlain{FilesizeRaw}
                    && $BodySize * 1.1 > $AttachmentFilePlain{FilesizeRaw}
                    )
                {
                    delete $Attachments{$AttachmentIDPlain};
                }
            }
        }
    }

    return %Attachments;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
