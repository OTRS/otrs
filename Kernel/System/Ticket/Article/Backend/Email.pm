# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Article::Backend::Email;

use strict;
use warnings;

use Mail::Address;

use Kernel::System::VariableCheck qw(:all);

use parent 'Kernel::System::Ticket::Article::Backend::MIMEBase';

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerUser',
    'Kernel::System::DB',
    'Kernel::System::Email',
    'Kernel::System::HTMLUtils',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::PostMaster::LoopProtection',
    'Kernel::System::State',
    'Kernel::System::TemplateGenerator',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::DateTime',
    'Kernel::System::MailQueue',
);

=head1 NAME

Kernel::System::Ticket::Article::Backend::Email - backend class for email based articles

=head1 DESCRIPTION

This class provides functions to manipulate email based articles in the database.

Inherits from L<Kernel::System::Ticket::Article::Backend::MIMEBase>, please have a look there for its base API,
and below for the additional functions this backend provides.

=head1 PUBLIC INTERFACE

=cut

sub ChannelNameGet {
    return 'Email';
}

=head2 ArticleGetByMessageID()

Return article data by supplied message ID.

    my %Article = $ArticleBackendObject->ArticleGetByMessageID(
        MessageID     => '<13231231.1231231.32131231@example.com>',     # (required)
        DynamicFields => 1,                                             # (optional) To include the dynamic field values for this article on the return structure.
        RealNames     => 1,                                             # (optional) To include the From/To/Cc/Bcc fields with real names.
    );

=cut

sub ArticleGetByMessageID {
    my ( $Self, %Param ) = @_;

    if ( !$Param{MessageID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need MessageID!',
        );
        return;
    }

    my $MD5 = $Kernel::OM->Get('Kernel::System::Main')->MD5sum( String => $Param{MessageID} );

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Get ticket and article ID from meta article table.
    return if !$DBObject->Prepare(
        SQL => '
            SELECT sa.id, sa.ticket_id FROM article sa
            LEFT JOIN article_data_mime sadm ON sa.id = sadm.article_id
            WHERE sadm.a_message_id_md5 = ?
        ',
        Bind  => [ \$MD5 ],
        Limit => 10,
    );

    my $Count = 0;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Param{ArticleID} = $Row[0];
        $Param{TicketID}  = $Row[1];
        $Count++;
    }

    # No reference found.
    return if $Count == 0;
    return if !$Param{TicketID} || !$Param{ArticleID};

    # More than one reference found! That should not happen, since 'a message_id' should be unique!
    if ( $Count > 1 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message =>
                "The MessageID '$Param{MessageID}' is in your database more than one time! That should not happen, since 'a message_id' should be unique!",
        );
        return;
    }

    return $Self->ArticleGet(
        %Param,
    );
}

=head2 ArticleSend()

Send article via email and create article with attachments.

    my $ArticleID = $ArticleBackendObject->ArticleSend(
        TicketID             => 123,                              # (required)
        SenderTypeID         => 1,                                # (required)
                                                                  # or
        SenderType           => 'agent',                          # (required) agent|system|customer
        IsVisibleForCustomer => 1,                                # (required) Is article visible for customer?
        UserID               => 123,                              # (required)

        From        => 'Some Agent <email@example.com>',                       # required
        To          => 'Some Customer A <customer-a@example.com>',             # required if both Cc and Bcc are not present
        Cc          => 'Some Customer B <customer-b@example.com>',             # required if both To and Bcc are not present
        Bcc         => 'Some Customer C <customer-c@example.com>',             # required if both To and Cc are not present
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
        EmailSecurity => {
            Backend     => 'PGP',                       # PGP or SMIME
            Method      => 'Detached',                  # Optional Detached or Inline (defaults to Detached)
            SignKey     => '81877F5E',                  # Optional
            EncryptKeys => [ '81877F5E', '3b630c80' ],  # Optional
        }
        HistoryType    => 'OwnerUpdate',  # Move|AddNote|PriorityUpdate|WebRequestCustomer|...
        HistoryComment => 'Some free text!',
        NoAgentNotify  => 0,            # if you don't want to send agent notifications
    );


    my $ArticleID = $ArticleBackendObject->ArticleSend(                (Backwards compatibility)
        TicketID             => 123,                              # (required)
        SenderTypeID         => 1,                                # (required)
                                                                  # or
        SenderType           => 'agent',                          # (required) agent|system|customer
        IsVisibleForCustomer => 1,                                # (required) Is article visible for customer?
        UserID               => 123,                              # (required)

        From        => 'Some Agent <email@example.com>',                       # required
        To          => 'Some Customer A <customer-a@example.com>',             # required if both Cc and Bcc are not present
        Cc          => 'Some Customer B <customer-b@example.com>',             # required if both To and Bcc are not present
        Bcc         => 'Some Customer C <customer-c@example.com>',             # required if both To and Cc are not present
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
    );

Events:
    ArticleSend

=cut

sub ArticleSend {
    my ( $Self, %Param ) = @_;

    my $ToOrig      = $Param{To}          || '';
    my $Loop        = $Param{Loop}        || 0;
    my $HistoryType = $Param{HistoryType} || 'SendAnswer';

    my $ArticleObject  = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    # Lookup if no ID is passed.
    if ( $Param{SenderType} && !$Param{SenderTypeID} ) {
        $Param{SenderTypeID} = $ArticleObject->ArticleSenderTypeLookup( SenderType => $Param{SenderType} );
    }

    for my $Needed (qw(TicketID UserID SenderTypeID From Body Charset MimeType)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( !defined $Param{IsVisibleForCustomer} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need IsVisibleForCustomer!",
        );
        return;
    }

    # Map ReplyTo into Reply-To if present.
    if ( $Param{ReplyTo} ) {
        $Param{'Reply-To'} = $Param{ReplyTo};
    }

    # Clean up body string.
    $Param{Body} =~ s/(\r\n|\n\r)/\n/g;
    $Param{Body} =~ s/\r/\n/g;

    # initialize parameter for attachments, so that the content pushed into that ref from
    # EmbeddedImagesExtract will stay available
    if ( !$Param{Attachment} ) {
        $Param{Attachment} = [];
    }

    # check for base64 images in body and process them
    $Kernel::OM->Get('Kernel::System::HTMLUtils')->EmbeddedImagesExtract(
        DocumentRef    => \$Param{Body},
        AttachmentsRef => $Param{Attachment},
    );

    # create article
    my $Time      = $DateTimeObject->ToEpoch();
    my $Random    = rand 999999;
    my $FQDN      = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');
    my $MessageID = "<$Time.$Random\@$FQDN>";
    my $ArticleID = $Self->ArticleCreate(
        %Param,
        MessageID => $MessageID,
    );
    return if !$ArticleID;

    # Send the mail
    my $Result = $Kernel::OM->Get('Kernel::System::Email')->Send(
        %Param,
        ArticleID    => $ArticleID,
        'Message-ID' => $MessageID,
    );

    # return if mail wasn't sent
    if ( !$Result->{Success} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Message  => "Impossible to send message to: $Param{'To'} .",
            Priority => 'error',
        );
        return;
    }

    # write article to file system
    my $Plain = $Self->ArticleWritePlain(
        ArticleID => $ArticleID,
        Email     => sprintf( "%s\n%s", $Result->{Data}->{Header}, $Result->{Data}->{Body} ),
        UserID    => $Param{UserID},
    );
    return if !$Plain;

    # log
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message  => sprintf(
            "Queued email to '%s' from '%s'. HistoryType => %s, Subject => %s;",
            $Param{To},
            $Param{From},
            $HistoryType,
            $Param{Subject},
        ),
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

=head2 ArticleBounce()

Bounce an article.

    my $Success = $ArticleBackendObject->ArticleBounce(
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

    for my $Item (qw(TicketID ArticleID From To UserID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );
            return;
        }
    }

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    # create message id
    my $Time         = $DateTimeObject->ToEpoch();
    my $Random       = rand 999999;
    my $FQDN         = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');
    my $NewMessageID = "<$Time.$Random.0\@$FQDN>";
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
    my $BounceSent = $Kernel::OM->Get('Kernel::System::Email')->Bounce(
        'Message-ID' => $NewMessageID,
        From         => $Param{From},
        To           => $Param{To},
        Email        => $Email,
    );

    return if !$BounceSent->{Success};

    # write history
    my $HistoryType = $Param{HistoryType} || 'Bounce';
    $Kernel::OM->Get('Kernel::System::Ticket')->HistoryAdd(
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

=head2 SendAutoResponse()

Send an auto response to a customer via email.

    my $ArticleID = $ArticleBackendObject->SendAutoResponse(
        TicketID         => 123,
        AutoResponseType => 'auto reply',
        OrigHeader       => {
            From    => 'some@example.com',
            Subject => 'For the message!',
        },
        UserID => 123,
    );

Events:
    ArticleAutoResponse

=cut

sub SendAutoResponse {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(TicketID UserID OrigHeader AutoResponseType)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );
            return;
        }
    }

    # return if no notification is active
    return 1 if $Self->{SendNoNotification};

    # get orig email header
    my %OrigHeader = %{ $Param{OrigHeader} };

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get ticket
    my %Ticket = $TicketObject->TicketGet(
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
        $TicketObject->HistoryAdd(
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
    if ( $OrigHeader{'X-OTRS-Loop'} && $OrigHeader{'X-OTRS-Loop'} !~ /^(false|no)$/i ) {

        # add history row
        $TicketObject->HistoryAdd(
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
            $TicketObject->HistoryAdd(
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
            $TicketObject->HistoryAdd(
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
            $TicketObject->HistoryAdd(
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

        if (
            $CustomerUser{UserEmail}
            && $OrigHeader{From} !~ /\Q$CustomerUser{UserEmail}\E/i
            && $Param{IsVisibleForCustomer}
            )
        {
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

    # Format sender realname and address because it maybe contains comma or other special symbols (see bug#13130).
    my $From = Mail::Address->new( $AutoResponse{SenderRealname} // '', $AutoResponse{SenderAddress} );

    # send email
    my $ArticleID = $Self->ArticleSend(
        IsVisibleForCustomer => 1,
        SenderType           => 'system',
        TicketID             => $Param{TicketID},
        HistoryType          => $HistoryType,
        HistoryComment       => "\%\%$AutoReplyAddresses",
        From                 => $From->format(),
        To                   => $AutoReplyAddresses,
        Cc                   => $Cc,
        Charset              => 'utf-8',
        MimeType             => $AutoResponse{ContentType},
        Subject              => $AutoResponse{Subject},
        Body                 => $AutoResponse{Text},
        InReplyTo            => $OrigHeader{'Message-ID'},
        Loop                 => 1,
        UserID               => $Param{UserID},
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

=head2 ArticleTransmissionStatus()

Get the transmission status for one article.

    my $TransmissionStatus = $ArticleBackendObject->ArticleTransmissionStatus(
        ArticleID => 123,   # required
    );

This returns something like:

    $TransmissionStatus = {
        ArticleID  => 123,
        MessageID  => 456,
        Message    => 'Descriptive message of last communication',  # only in case of failed status
        CreateTime => '2017-01-01 12:34:56',
        Status     => [Processing|Failed],
        Attempts   => 1,                                            # only in case of processing status
        DueTime    => '2017-01-02 12:34:56',                        # only in case of processing status
    }

=cut

sub ArticleTransmissionStatus {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID',
        );
        return;
    }

    my $Result = $Self->ArticleGetTransmissionError( %Param, );
    return $Result if $Result && %{$Result};

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL =>
            'SELECT article_id, create_time, attempts, due_time FROM mail_queue WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    if ( my @Row = $DBObject->FetchrowArray() ) {
        return {
            ArticleID  => $Row[0],
            CreateTime => $Row[1],
            Attempts   => $Row[2],
            DueTime    => $Row[3],
            Status     => 'Processing',
        };
    }

    return;
}

=head2 ArticleCreateTransmissionError()

Creates a Transmission Error entry for one article.

    my $Success = $ArticleBackendObject->ArticleCreateTransmissionError(
        ArticleID => 123,                   # Required
        MessageID => 456,                   # Optional
        Message   => '',                    # Optional
    );

=cut

sub ArticleCreateTransmissionError {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Field (qw{ArticleID}) {
        if ( !$Param{$Field} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need ${Field}!"
            );
            return;
        }
    }

    my $SQL = 'INSERT INTO article_data_mime_send_error(';

    my @Fields;
    my @Bind;

    my %MapDB = (
        ArticleID => 'article_id',
        MessageID => 'message_id',
        Message   => 'log_message',
    );

    my @PlaceHolder;

    for my $Field ( sort keys %MapDB ) {
        if ( IsStringWithData( $Param{$Field} ) ) {
            push @Fields,      $MapDB{$Field};
            push @PlaceHolder, '?';
            push @Bind,        \$Param{$Field};
        }
    }
    push @Fields, 'create_time';

    $SQL .= join( ', ', @Fields )
        . ') values(';

    $SQL .= join ', ', @PlaceHolder;

    $SQL .= ', current_timestamp)';

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    return 1;
}

=head2 ArticleGetTransmissionError()

Get the Transmission Error entry for a given article.

    my %TransmissionError = $ArticleBackendObject->ArticleGetTransmissionError(
        ArticleID => 123,   # Required
    );

    Returns:
    {
        ArticleID  => 123,
        MessageID  => 456,
        Message    => 'Descriptive message of last communication',
        CreateTime => '2017-01-01 01:02:03',
        Status     => 'Failed',
    }
    or undef in case of failure to retrive a record from the database.

=cut

sub ArticleGetTransmissionError {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need ArticleID!"
        );
        return;
    }

    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # can't open article, try database
    return if !$DBObject->Prepare(
        SQL =>
            'SELECT article_id, message_id, log_message, create_time FROM article_data_mime_send_error WHERE article_id = ?',
        Bind => [ \$Param{ArticleID} ],
    );

    my @Row = $DBObject->FetchrowArray();
    if (@Row) {
        return {
            'ArticleID'  => $Row[0],
            'MessageID'  => $Row[1],
            'Message'    => $Row[2],
            'CreateTime' => $Row[3],
            'Status'     => 'Failed',
        };
    }

    return;
}

=head2 ArticleUpdateTransmissionError()

Updates the Transmission Error.

    my $Result = $ArticleBackendObject->ArticleUpdateTransmissionError(
        ArticleID => 123,                           # Required
        MessageID => 456,                           # Optional
        Message   => 'Short descriptive message',   # Optional
    );

Returns 1 on Success, undef on failure.

=cut

sub ArticleUpdateTransmissionError {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need ArticleID!"
        );
        return;
    }

    my @FieldsToUpdate;
    my @Bind;

    if ( IsStringWithData( $Param{MessageID} ) ) {
        push @FieldsToUpdate, 'message_id = ?';
        push @Bind,           \$Param{MessageID};
    }

    if ( IsStringWithData( $Param{Message} ) ) {
        push @FieldsToUpdate, 'log_message = ?';
        push @Bind,           \$Param{Message};
    }

    return if !scalar @Bind;

    my $SQL = 'UPDATE article_data_mime_send_error SET '
        . join( ', ', @FieldsToUpdate )
        . ' WHERE article_id = ?';

    push @Bind, \$Param{ArticleID};

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # db update
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
