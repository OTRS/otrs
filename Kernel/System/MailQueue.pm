# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::MailQueue;

use strict;
use warnings;

use MIME::Base64;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::EventHandler);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::DB',
    'Kernel::System::DateTime',
    'Kernel::System::Storable',
    'Kernel::System::Ticket::Article',
    'Kernel::System::Email',
    'Kernel::System::CheckItem',
    'Kernel::System::Main',
    'Kernel::System::CommunicationLog',
    'Kernel::System::CommunicationLog::DB',
);

my %DBNames = (
    ID                        => 'id',
    ArticleID                 => 'article_id',
    CommunicationLogMessageID => 'communication_log_object_id',
    Sender                    => 'sender',
    Recipient                 => 'recipient',
    Attempts                  => 'attempts',
    Message                   => 'raw_message',
    DueTime                   => 'due_time',
    LastSMTPCode              => 'last_smtp_code',
    LastSMTPMessage           => 'last_smtp_message',
);

=head1 PUBLIC INTERFACE

=head2 new()

Create a MailQueue object. Do not use it directly, instead use:

    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    $Self->{CheckEmailAddresses} = $Param{CheckEmailAddresses} // 1;

    # init of event handler
    $Self->{EventHandlerTransaction} = 1;
    $Self->EventHandlerInit(
        Config => 'Ticket::EventModulePost',
    );

    return $Self;
}

=head2 Create()

Create a new queue element.

    my $Result = $MailQueue->Create(
        ArticleID       => '...', # optional
        MessageID       => '...', # optional (in case article id was passed this should be also)
        Sender          => '...',
        Recipient       => '...' || [],
        Message         => '...',
        Attempts        => '...', # optional
    );

Returns 1 or undef.

=cut

sub Create {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    $Param{CommunicationLogObject} ||= $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Email',
            Direction => 'Outgoing',
        },
    );

    if ( !$Param{CommunicationLogObject} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Communication log object not started!",
        );

        return;
    }

    if (
        !$Param{CommunicationLogObject}->IsObjectLogOpen(
            ObjectLogType => 'Message',
        )
        )
    {
        $Param{CommunicationLogObject}->ObjectLogStart(
            ObjectLogType => 'Message',
        );
    }

    # Check for required data.
    for my $Argument (qw(Recipient Message)) {
        if ( !$Param{$Argument} ) {

            my $ErrorMessage = "Need $Argument!";

            $LogObject->Log(
                Priority => 'error',
                Message  => $ErrorMessage,
            );

            $Param{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::MailQueue',
                Value         => $ErrorMessage,
            );

            $Self->_SetArticleTransmissionError(
                %Param,
                Message => $ErrorMessage,
            );

            return;
        }
    }

    # Recipient can be a Scalar or ArrayRef
    my $Recipient    = $Param{Recipient} // [];
    my $RecipientRef = ref $Recipient;

    if ( !$RecipientRef ) {
        $Recipient = [ split( ',', $Recipient, ) ];
    }

    my $OnErrorSetArticleTransmissionError = sub {
        my %LocalParam = @_;

        my $Result = $LocalParam{Process}->();

        if ( !$Result ) {
            $Self->_SetArticleTransmissionError(
                %Param,
                Message => $LocalParam{ErrorMessage}
            );
        }

        return $Result;
    };

    # Message should be a Hashref.
    return if !$OnErrorSetArticleTransmissionError->(
        Process => sub {
            return $Self->_CheckValidMessageData(
                Data                   => $Param{Message},
                CommunicationLogObject => $Param{CommunicationLogObject},
            );
        },
        ErrorMessage => 'Error while validating Message data.',
    );

    # Check if sender and recipent are valid email addresses.
    return if !$OnErrorSetArticleTransmissionError->(
        Process => sub {
            return $Self->_CheckValidEmailAddresses(
                ParamName              => 'Sender',
                Addresses              => [ $Param{Sender} ? $Param{Sender} : () ],
                CommunicationLogObject => $Param{CommunicationLogObject},
            );
        },
        ErrorMessage => 'Error while validating Sender email address.',
    );

    return if !$OnErrorSetArticleTransmissionError->(
        Process => sub {
            return $Self->_CheckValidEmailAddresses(
                ParamName              => 'Recipient',
                Addresses              => $Recipient,
                CommunicationLogObject => $Param{CommunicationLogObject},
            );
        },
        ErrorMessage => 'Error while validating Recipient email address.',
    );

    # Check if already exists a mail-queue item for the same article id.
    return if $Self->_IsArticleAlreadyQueued( %Param, );

    my $RecipientStr = join q{,}, @{$Recipient};

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::MailQueue',
        Value         => sprintf(
            "Serializing and saving message (ArticleID: %s, Sender: $Param{Sender}, "
                . "Recipient: $RecipientStr, MessageID: %s)",
            $Param{ArticleID} || '',
            $Param{MessageID} || '',
        ),
    );

    # Serialize Message.
    my $Message = $Self->_SerializeMessage(
        Message => $Param{Message},
    );

    my $InsertResult = $Self->_DBInsert(
        %Param,
        Recipient => $RecipientStr,
        Message   => $Message,
    );
    return if !$InsertResult->{Success} && $InsertResult->{Action} eq 'db-insert';

    $Self->_SetCommunicationLogLookup(
        CommunicationLogObject => $Param{CommunicationLogObject},
        ArticleID              => $Param{ArticleID},
        ID                     => $InsertResult->{ID},
    );

    my $LogMessage = 'Successfully stored message for sending.';

    # Event Notification
    $Self->_SendEventNotification(
        ArticleID => $Param{ArticleID},
        Status    => 'Queued',
        Message   => $LogMessage,
        UserID    => $Param{UserID},
    );

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Info',
        Key           => 'Kernel::System::MailQueue',
        Value         => $LogMessage,
    );

    return 1;
}

=head2 List()

Get a list of the queue elements.

    my $List = $MailQueue->List(
        ID              => '...' # optional
        ArticleID       => '...' # optional
        Sender          => '...' # optional
        Recipient       => '...' # optional
        Attempts        => '...' # optional
    );

This returns something like:

    my $List = [
        {
            ID                        => '...',
            ArticleID                 => '...',
            Attempts                  => '...',
            Sender                    => '...',
            Recipient                 => ['...'],
            Message                   => '...',
            DueTime                   => '...',
            LastSMTPCode              => '...',
            LastSMTPMessage           => '...',
        },
        ...,
    ]

=cut

sub List {
    my ( $Self, %Param, ) = @_;

    my @SQL = (
        'SELECT id, article_id, attempts, sender, recipient, raw_message',
        ', due_time, last_smtp_code, last_smtp_message',
        'FROM mail_queue',
    );

    my ( $FilterSQL, $Binds ) = $Self->_FiltersSQLAndBinds(%Param);
    if ($FilterSQL) {
        push @SQL, 'WHERE', $FilterSQL;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL    => join( ' ', @SQL ),
        Bind   => $Binds,
        Limit  => $Param{Limit},
        Encode => [ 1, 1, 1, 1, 1, 0 ],
    );

    my @List = ();
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # Deserialize Message.
        my $Message = $Self->_DeserializeMessage(
            Message => $Row[5],
        );

        # Convert DueTime to a DateTimeObject
        my $DueTime = $Row[6];
        if ($DueTime) {
            $DueTime = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $DueTime,
                },
            );
        }

        my %Item = (
            ID              => $Row[0],
            ArticleID       => $Row[1],
            Attempts        => $Row[2],
            Sender          => $Row[3],
            Recipient       => [ split( ',', $Row[4], ) ],
            Message         => $Message,
            DueTime         => $DueTime,
            LastSMTPCode    => $Row[7],
            LastSMTPMessage => $Row[8],
        );

        # Normalize empty string/undef value to undef.
        KEY:
        for my $Key ( sort keys %Item ) {
            my $Value = $Item{$Key};

            next KEY if ref $Value;
            next KEY if defined $Value && length $Value;

            $Item{$Key} = undef;
        }

        push @List, \%Item;
    }

    return \@List;
}

=head2 Get()

Get a queue element.

    my $Item = $MailQueue->Get(
        ID              => '...' # optional
        ArticleID       => '...' # optional
    );

This returns something like:

    $Item = {
        ID                        => '...',
        ArticleID                 => '...',
        Attempts                  => '...',
        Sender                    => '...',
        Recipient                 => ['...'],
        Message                   => '...',
        DueTime                   => '...',
        LastSMTPCode              => '...',
        LastSMTPMessage           => '...',
    };

or and empty hashref if element not found.

=cut

sub Get {
    my ( $Self, %Param, ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # Check for required data.
    if ( !$Param{ID} && !$Param{ArticleID} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Need ID or ArticleID!",
        );
        return;
    }

    my $List = $Self->List(
        ID        => $Param{ID},
        ArticleID => $Param{ArticleID}
    );
    return $List->[0] if IsArrayRefWithData($List);
    return {};
}

=head2 Update()

Update queue elements.

    my $Result = $MailQueue->Update(
        Filters => {},
        Data    => {},
    );

Returns 1 or undef.

=cut

sub Update {
    my ( $Self, %Param, ) = @_;

    my %Filters = %{ $Param{Filters} || {} };
    my %Data    = %{ $Param{Data}    || {} };

    my $LogError = sub {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => shift,
        );
        return;
    };

    if ( !%Data ) {
        return $LogError->("Need Data!");
    }

    # If we're updating the ArticleID, need to check if is already queued.
    if ( $Data{ArticleID} ) {
        my $ArticleID = $Data{ArticleID};
        my $ToUpdate  = $Self->List(%Filters);
        return if $Self->_IsArticleAlreadyQueued(
            ArticleID              => $ArticleID,
            ToUpdate               => $ToUpdate,
            CommunicationLogObject => $Param{CommunicationLogObject},
        );

        $Self->_SetCommunicationLogLookup(
            CommunicationLogObject => $Param{CommunicationLogObject},
            ArticleID              => $Data{ArticleID},
            ID                     => $ToUpdate->[0]->{ID},
        );
    }

    my @SQL   = ( 'UPDATE mail_queue', );
    my @Binds = ();

    # Build set clause.
    my @SQLSet = ();
    for my $Col ( sort keys %Data ) {
        my $Value = $Data{$Col};

        if ( $Col eq 'Sender' || $Col eq 'Recipient' ) {
            if ( $Col eq 'Recipient' && !ref $Value ) {
                $Value = [ split( ',', $Value, ) ];
            }

            return if !$Self->_CheckValidEmailAddresses(
                ParamName              => $Col,
                Addresses              => $Value,
                CommunicationLogObject => $Param{CommunicationLogObject},
            );

            if ( ref $Value ) {
                $Value = join( ',', @{$Value}, );
            }
        }
        elsif ( $Col eq 'Message' ) {
            return if !$Self->_CheckValidMessageData(
                Data                   => $Value,
                CommunicationLogObject => $Param{CommunicationLogObject},
            );
            $Value = $Self->_SerializeMessage(
                Message => $Value,
            );
        }

        push @SQLSet, sprintf( '%s = ?', $DBNames{$Col} );
        push @Binds,  \$Value;
    }
    push @SQL, 'SET', join( q{, }, @SQLSet );

    # Build where clause.
    my ( $FilterSQL, $FilterBinds ) = $Self->_FiltersSQLAndBinds( %Filters, );

    if ($FilterSQL) {
        push @SQL, 'WHERE', $FilterSQL;
        push @Binds, @{$FilterBinds};
    }

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => join( q{ }, @SQL ),
        Bind => \@Binds,
    );

    return 1;
}

=head2 Delete()

Delete queue elements.

    my $Result = $MailQueue->Delete(
        %Filters,                       # See _FiltersSQLAndBinds
    );

Returns 1 or undef.

=cut

sub Delete {
    my ( $Self, %Param, ) = @_;

    my $DoSetTransmissionArticleError = delete $Param{SetTransmissionArticleError};

    my $List;
    if ($DoSetTransmissionArticleError) {
        $List = $Self->List(%Param);
    }

    my @SQL = ( 'DELETE FROM mail_queue', );

    my ( $FilterSQL, $Binds ) = $Self->_FiltersSQLAndBinds(%Param);
    if ($FilterSQL) {
        push @SQL, 'WHERE', $FilterSQL;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => join( ' ', @SQL ),
        Bind => $Binds,
    );

    return 1 if !$DoSetTransmissionArticleError;

    for my $Item (@$List) {

        $Self->_SetArticleTransmissionError(
            ArticleID => $Item->{ArticleID},
            Message   => $DoSetTransmissionArticleError,
        );

        my $CommunicationLogObject = $Self->_GetCommunicationLog(
            ID => $Item->{ID},
        );

        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => ref $Self,
            Value         => $DoSetTransmissionArticleError,
        );

        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Message',
            Status        => 'Failed',
        );

        $CommunicationLogObject->CommunicationStop( Status => 'Failed' );
    }

    return 1;
}

=head2 Send()

Send/Process a mail queue element/item.

    my $List = $MailQueue->Send(
        ID              => '...',
        Sender          => '...',
        Recipient       => '...',
        Message         => '...',
        Force           => '...' # optional, to force the sending even if isn't time
    );

This returns something like:

    $List = {
        Status  => '(Failed|Pending|Success)',
        Message => '...',                      # undef if success.
    };

=cut

sub Send {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # Check for required data.
    for my $Argument (qw(ID Recipient Message)) {
        if ( !$Param{$Argument} ) {
            return {
                Status  => 'Failed',
                Message => "Need $Argument.",
            };
        }
    }

    # Message should be a HashRef
    if ( !IsHashRefWithData( $Param{Message} ) ) {
        return {
            Status  => 'Failed',
            Message => 'Invalid Message, should be a HashRef!',
        };
    }

    # Check for message required data.
    for my $Argument (qw(Header Body)) {
        if ( !$Param{Message}->{$Argument} ) {
            return {
                Status  => 'Failed',
                Message => "Need Message - $Argument!",
            };
        }
    }

    # Lookup for the communication id for the processing mail-queue item.
    $Param{CommunicationLogObject} = $Self->_GetCommunicationLog( %Param, );
    $Param{CommunicationID}        = $Param{CommunicationLogObject}->CommunicationIDGet();

    # If DueTime is bigger than current time, skip, it is not time to run yet.
    my $CurrentSysDTObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $DueTime            = $Param{DueTime};
    if ( !( delete $Param{Force} ) && $DueTime && $DueTime > $CurrentSysDTObject ) {

        my $LogMessage = sprintf(
            q{Resending pause still active for message with id "%s", please wait until "%s"!},
            $Param{ID},
            $DueTime->ToString(),
        );

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::MailQueue',
            Value         => $LogMessage,
        );

        return {
            Status  => 'Pending',
            Message => $LogMessage,
        };
    }

    $Param{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Info',
        Key           => 'Kernel::System::MailQueue',
        Value         => "Sending queued message with id '$Param{ID}'.",
    );

    my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');
    my $Result      = $EmailObject->SendExecute(
        From                   => $Param{Sender},
        To                     => $Param{Recipient},
        Header                 => $Param{Message}->{Header},
        Body                   => $Param{Message}->{Body},
        CommunicationLogObject => $Param{CommunicationLogObject},
    );

    if ( $Result->{Success} ) {
        $Self->_SendSuccess(
            Item => \%Param,
        );
        return { Status => 'Success' };
    }

    $Self->_SendError(
        Item       => \%Param,
        SendResult => $Result,
    );

    return {
        Status  => 'Failed',
        Message => 'Sending has Failed.'
    };
}

=head1 PRIVATE INTERFACE

=head2 _SendSuccess()

This method is called after a MailQueue item is successfully sent.
It clears the item from the MailQueue, closes the communication log and
triggers a Event Notification.

    my $Result = $Object->_SendSuccess(
        Item => {
            ID                        => ...,
            ArticleID                 => ..., # optional
            UserID                    => ...,
            CommunicationLogObject    => ...,
        }
    );

Returns 1 or undef.

=cut

sub _SendSuccess {
    my ( $Self, %Param, ) = @_;

    my $LogError = sub {
        my $LogObject = $Kernel::OM->Get('Kernel::System::Log');
        $LogObject->Log(
            Priority => 'error',
            Message  => shift,
        );
        return;
    };

    my $Result;

    my $Item = $Param{Item};

    # Delete queue element/item.
    $Result = $Self->Delete(
        ID => $Item->{ID},
    );

    if ( !$Result ) {

        my $LogMessage = sprintf(
            'Error while deleting message with id "%s" from mail queue!',
            $Item->{ID},
        );

        $LogError->($LogMessage);

        $Item->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::MailQueue',
            Value         => $LogMessage,
        );
    }

    $Item->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Info',
        Key           => 'Kernel::System::MailQueue',
        Value         => 'Message successfully sent!',
    );

    $Item->{CommunicationLogObject}->ObjectLogStop(
        ObjectLogType => 'Message',
        Status        => 'Successful',
    );

    $Result = $Item->{CommunicationLogObject}->CommunicationStop(
        Status => 'Successful',
    );

    if ( !$Result ) {
        $LogError->(
            sprintf(
                'Error while closing the communication "%s"!',
                $Item->{CommunicationLogObject}->CommunicationIDGet(),
            ),
        );
    }

    if ( $Item->{ArticleID} ) {

        # Event Notification
        $Self->_SendEventNotification(
            ArticleID => $Item->{ArticleID},
            Status    => 'Sent',
            Message   => 'Mail successfully sent.',
            UserID    => $Item->{UserID},
        );
    }

    return 1;
}

=head2 _SendError()

Handles Send errors.
Situations where the mail queue item is deleted:
    - SMTP 5?? errors codes, considered permanent errors.
    - reached maximum attempts

    $Object->_SendError(
        Item       => ...,
        SendResult => ...,
    );

This always returns undef.

=cut

sub _SendError {
    my ( $Self, %Param, ) = @_;

    my $LogError = sub {
        my $LogObject = $Kernel::OM->Get('Kernel::System::Log');
        $LogObject->Log(
            Priority => 'error',
            Message  => shift,
        );
        return;
    };

    my $Result;
    my $Config     = $Kernel::OM->Get('Kernel::Config')->Get('MailQueue');
    my $SendResult = $Param{SendResult};

    my $Item            = $Param{Item};
    my $ItemAttempts    = $Item->{Attempts} + 1;
    my $ItemMaxAttempts = $Config->{ItemMaxAttempts};

    $Item->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Error',
        Key           => 'Kernel::System::MailQueue',
        Value         => "Message could not be sent! Error message: $SendResult->{ErrorMessage}",
    );

    # If is a permanent error or reach the maximum attempts, remove the element from the queue.
    if (
        ( $SendResult->{SMTPError} && $SendResult->{Code} && substr( $SendResult->{Code}, 0, 1 ) == 5 ) ||
        ( $ItemAttempts >= $ItemMaxAttempts )
        )
    {
        $Self->_SetArticleTransmissionError(
            ArticleID              => $Item->{ArticleID},
            Message                => $SendResult->{ErrorMessage},
            CommunicationLogObject => $Item->{CommunicationLogObject},
        );

        $Item->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::MailQueue',
            Value => "Permanent sending problem or we reached the sending attempt limit. Message will be removed",
        );

        # Delete mail queue element/item.
        $Result = $Self->Delete(
            ID => $Item->{ID},
        );
        if ( !$Result ) {

            my $LogMessage = sprintf(
                'Error while deleting the mail-queue item "%s"!',
                $Item->{ID},
            );

            $LogError->($LogMessage);

            $Item->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::MailQueue',
                Value         => $LogMessage,
            );
        }

        $Item->{CommunicationLogObject}->ObjectLogStop(
            ObjectLogType => 'Message',
            Status        => 'Failed',
        );

        # Set Communication as failed.
        $Result = $Item->{CommunicationLogObject}->CommunicationStop(
            Status => 'Failed',
        );

        if ( !$Result ) {
            $LogError->(
                sprintf(
                    'Error while closing the communication "%s" as failed!',
                    $Item->{CommunicationLogObject}->CommunicationIDGet(),
                ),
            );
        }

        return;
    }

    # Temporary errors, update due time, last-smtp-code and last-smtp-message.

    my $MinutesToIncrement = $Config->{IncrementAttemptDelayInMinutes} || 1;
    my $CurrentSysDTObject = $Kernel::OM->Create('Kernel::System::DateTime');

    # Calcule next attempt datetime.
    my $NextAttempt = $CurrentSysDTObject->Clone();
    $NextAttempt->Add( Minutes => $ItemAttempts * $MinutesToIncrement );

    # Update mail-queue with attempt and smtp code and message.
    my %UpdateData = (
        Attempts => $ItemAttempts,
        DueTime  => $NextAttempt->ToString(),
    );

    if ( $SendResult->{SMTPError} ) {
        %UpdateData = (
            %UpdateData,
            LastSMTPCode    => $SendResult->{Code},
            LastSMTPMessage => $SendResult->{ErrorMessage},
        );
    }

    $Item->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Error',
        Key           => 'Kernel::System::MailQueue',
        Value         => 'Temporary problem returned from server, requeuing message for sending. Message: '
            . sprintf(
            "SMTPCode: %s, ErrorMessage: $SendResult->{ErrorMessage}",
            $SendResult->{Code} ? $SendResult->{Code} : '-'
            ),
    );

    $Result = $Self->Update(
        Filters => {
            ID => $Item->{ID},
        },
        Data => \%UpdateData,
    );

    if ( !$Result ) {

        my $LogMessage = sprintf(
            'Error while updating mail queue element "%s" with "%s"!',
            $Item->{ID},
            join( ', ', map { $_ . '=' . $UpdateData{$_} } sort keys %UpdateData ),
        );

        $LogError->($LogMessage);

        $Item->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::MailQueue',
            Value         => $LogMessage,
        );
    }

    return;
}

=head2 _SetArticleTransmissionError()

Creates or Updates the Article Transmission Error record with the error message.
Then, fires a Notification Event.

    my $Result = $Object->_SetArticleTransmissionError(
        ArticleID                 => ...,
        Message                   => ...,
        MessageID                 => ...,
        UserID                    => ...,
        ForceUpdate               => ...,
        CommunicationLogObject    => ...,
    );

Returns 1 or undef.

=cut

sub _SetArticleTransmissionError {
    my ( $Self, %Param, ) = @_;

    my $ArticleID = $Param{ArticleID};
    return 1 if !$ArticleID;

    my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $ArticleBackendObject = $ArticleObject->BackendForChannel(
        ChannelName => 'Email',
    );

    my $TicketID = $ArticleObject->TicketIDLookup( ArticleID => $ArticleID );

    if ( $Param{ForceUpdate} || $ArticleBackendObject->ArticleGetTransmissionError( ArticleID => $ArticleID ) ) {

        my $Result = $ArticleBackendObject->ArticleUpdateTransmissionError(
            ArticleID => $ArticleID,
            Message   => $Param{Message},
        );

        if ( !$Result ) {

            my $ErrorMessage = sprintf(
                'Error while updating transmission error for article "%s"!',
                $ArticleID,
            );

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $ErrorMessage,
            );

            $Param{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::MailQueue',
                Value         => $ErrorMessage,
            );

            # Event Notification
            $Self->_SendEventNotification(
                ArticleID => $ArticleID,
                Status    => 'Error',
                Message   => $ErrorMessage,
                UserID    => $Param{UserID},
            );

            return;
        }

        # Event Notification
        $Self->_SendEventNotification(
            ArticleID => $ArticleID,
            Status    => 'Error',
            Message   => $Param{Message},
            UserID    => $Param{UserID},
        );

        return 1;
    }

    my $Result = $ArticleBackendObject->ArticleCreateTransmissionError(
        ArticleID => $ArticleID,
        MessageID => $Param{MessageID},
        Message   => $Param{Message},
    );

    if ( !$Result ) {

        my $ErrorMessage = sprintf(
            'Error while creating transmission error for article "%s"!',
            $ArticleID,
        );

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $ErrorMessage,
        );

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::MailQueue',
            Value         => $ErrorMessage,
        );

        # Event Notification
        $Self->_SendEventNotification(
            ArticleID => $ArticleID,
            Status    => 'Error',
            Message   => $ErrorMessage,
            UserID    => $Param{UserID},
        );

        return;

    }

    # Event Notification
    $Self->_SendEventNotification(
        ArticleID => $ArticleID,
        Status    => 'Error',
        Message   => $Param{Message},
        UserID    => $Param{UserID},
    );
    return 1;
}

=head2 _SendEventNotification()

Formats a Notification and asks Event Handler to send it.

    my $Result = $Object->_SendEventNotification(
        ArticleID => ...,
        Status    => "Queued|Sent|Error",
        Message   => ...,
        UserID    => ...,
    );

This returns something like:

    my $Result = {
        Status  => 'Failed',
        Message => 'Need ArticleID'
    };

in case of missing or invalid arguments, or the status of the EventHandler call.

=cut

sub _SendEventNotification {
    my ( $Self, %Param ) = @_;

    # Check for required data.
    for my $Argument (qw(ArticleID Status Message)) {
        if ( !$Param{$Argument} ) {
            return {
                Status  => 'Failed',
                Message => "Need $Argument.",
            };
        }
    }

    if ( $Param{Status} !~ m{Queued|Sent|Error} ) {
        return {
            Status  => 'Failed',
            Message => 'Status unknown.',
        };
    }

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $TicketID      = $ArticleObject->TicketIDLookup( ArticleID => $Param{ArticleID} );

    my $PostMasterUserID = $Kernel::OM->Get('Kernel::Config')->Get('PostmasterUserID') || 1;

    # Event Notification
    return $Self->EventHandler(
        Event => 'ArticleEmailSending' . $Param{Status},
        Data  => {
            ArticleID => $Param{ArticleID},
            Status    => $Param{Status},
            TicketID  => $TicketID,
            Message   => $Param{Message},
        },
        Transaction => 1,
        UserID      => $PostMasterUserID,
    );
}

=head2 _FiltersSQLAndBinds()

Build the filter sql and associated binds.

    my ( $FilterSQL, $Binds ) = $MailQueue->_FiltersSQLAndBinds(
        ID              => '...' # optional
        ArticleID       => '...' # optional
        CommunicationID => '...' # optional
        Sender          => '...' # optional
        Recipient       => '...' # optional
        Attempts        => '...' # optional
    );

This returns something like:

    $FilterSQL = '...';
    $Binds     = \[...];

=cut

sub _FiltersSQLAndBinds {
    my ( $Self, %Param ) = @_;

    my %PossibleFilters = (
        ID        => {},
        ArticleID => {},

        #CommunicationID           => {},
        #CommunicationLogMessageID => {},
        Sender => {
            Fulltext => 1,
        },
        Attempts  => {},
        Recipient => {
            Fulltext => 1,
        },
        LastSMTPCode    => {},
        LastSMTPMessage => {
            Fulltext => 1,
        },
    );

    my @FilterFields = ();
    my @Bind         = ();

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    POSSIBLE_FILTER:
    for my $PossibleFilter ( sort keys %PossibleFilters ) {
        my $Value = $Param{$PossibleFilter};
        if ( !defined $Value || !length $Value ) {
            next POSSIBLE_FILTER;
        }

        my $PossibleFilterConfig = $PossibleFilters{$PossibleFilter};
        my $FilterDBName         = $DBNames{$PossibleFilter};
        if ( $PossibleFilterConfig->{Fulltext} ) {
            my $WhereClause = $DBObject->QueryCondition(
                Key          => $FilterDBName,
                Value        => $Value,
                SearchPrefix => '*',
                SearchSuffix => '*',
                Extended     => 1,               # use also " " as "&&", e.g. "bob smith" -> "bob&&smith"
            );

            push @FilterFields, $WhereClause;

            next POSSIBLE_FILTER;
        }

        push @FilterFields, sprintf( '(%s = ?)', $FilterDBName );
        push @Bind,         \$Value;
    }

    my $FinalFilterSQL = join ' AND ', @FilterFields;

    return ( $FinalFilterSQL, \@Bind );
}

=head2 _CheckValidEmailAddresses()

Check if the provided email address(es) is valid.

    my $IsValid = $MailQueue->_CheckValidEmailAddresses(
        ParamName => '...'       # name of the parameter that we are checking
        Addresses => '...' || [] # email addresses to validate
    );

Returns 1 or undef.

=cut

sub _CheckValidEmailAddresses {
    my ( $Self, %Param ) = @_;

    return 1 if !$Self->{CheckEmailAddresses};

    my $ParamName = $Param{ParamName};
    my $Addresses = $Param{Addresses};

    if ( !ref $Addresses ) {
        $Addresses = [$Addresses];
    }

    my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

    ADDRESS:
    for my $Address ( @{$Addresses} ) {

        next ADDRESS if $CheckItemObject->CheckEmail(
            Address => $Address,
        );

        my $ErrorMessage = sprintf(
            'Invalid email address %s - %s: %s',
            $ParamName,
            $Address,
            $CheckItemObject->CheckError(),
        );

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $ErrorMessage,
        );

        if ( $Param{CommunicationLogObject} ) {
            $Param{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::MailQueue',
                Value         => $ErrorMessage,
            );
        }

        $Self->_SetArticleTransmissionError(
            %Param,
            Message => $ErrorMessage,
        );

        return;
    }

    return 1;
}

=head2 _CheckValidMessageData()

Check if the provided data is a non-empty hash-ref.

    my $IsValid = $MailQueue->_CheckValidMessageData(
        Data => {...}
    );

Returns 1 or undef.

=cut

sub _CheckValidMessageData {
    my ( $Self, %Param ) = @_;

    my $Data = $Param{Data};

    if ( !IsHashRefWithData($Data) ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Received no message data to check.',
        );

        if ( $Param{CommunicationLogObject} ) {
            $Param{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::MailQueue',
                Value         => 'Received no message data to check.',
            );
        }

        return;
    }

    return 1;
}

=head2 _SerializeMessage()

Serialize a simple perl structure to be save in the database.

Returns an encoded or a storable string.

=cut

sub _SerializeMessage {
    my ( $Self, %Param ) = @_;

    my $DBObject       = $Kernel::OM->Get('Kernel::System::DB');
    my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');
    my $Message        = $StorableObject->Serialize(
        Data => $Param{Message},
    );
    if ( !$DBObject->GetDatabaseFunction('DirectBlob') ) {
        $Message = encode_base64( $Message, );
    }

    return $Message;
}

=head2 _DeserializeMessage()

Deserialize a simple perl structure to the original format.

=cut

sub _DeserializeMessage {
    my ( $Self, %Param ) = @_;

    my $DBObject       = $Kernel::OM->Get('Kernel::System::DB');
    my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');
    my $Message        = $Param{Message};
    if ( !$DBObject->GetDatabaseFunction('DirectBlob') ) {
        $Message = decode_base64( $Message, );
    }

    return $StorableObject->Deserialize(
        Data => $Message,
    );
}

=head2 _IsArticleAlreadyQueued()

Checks if the article is already queued.

Returns 1 or undef.

=cut

sub _IsArticleAlreadyQueued {
    my ( $Self, %Param ) = @_;

    my $ArticleID = $Param{ArticleID};
    return if !$ArticleID;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    my $AddCommunicationLog = sub {
        return if !$Param{CommunicationLogObject};

        my %LocalParam             = @_;
        my $CommunicationLogObject = $Param{CommunicationLogObject};
        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Message',
            Key           => ref($Self),
            Value         => $LocalParam{Message},
            Priority      => $LocalParam{Priority},
        );
        return;
    };

    # On Error consider as queued, do not try to insert or update.
    my $Error = sub {
        $AddCommunicationLog->(
            Message  => shift,
            Priority => 'Error',
        );

        return 1;
    };

    my $ErrorWhileChecking = sub {
        return $Error->(
            sprintf(
                "Error while checking if the article '%s' is already queued!",
                $ArticleID,
            ),
        );
    };

    my $ErrorAlreadQueued = sub {
        return $Error->(
            sprintf(
                "The article '%s' is already queued!",
                $ArticleID,
            ),
        );
    };

    # Get the queue item for the article.
    my $List = $Self->List(
        ArticleID => $ArticleID,
    );
    if ( !$List ) {
        return $ErrorWhileChecking->();
    }

    # If it's an update get the records that will be updated.
    my $ToUpdate = $Param{ToUpdate};
    if ($ToUpdate) {
        return $ErrorWhileChecking->() if !$ToUpdate;

        my $TotalToUpdate = scalar @{$ToUpdate};
        if ( $TotalToUpdate > 1 ) {
            return $Error->(
                "Trying to set the same ArticleID to multiple queue elements!",
            );
        }

        if ( $TotalToUpdate == 1 && @{$List} && $List->[0]->{ID} != $ToUpdate->[0]->{ID} ) {
            return $ErrorAlreadQueued->();
        }

        return;
    }

    # It's an insert, this means if the List has records, the article is already queued.
    if ( @{$List} ) {
        return $ErrorAlreadQueued->();
    }

    return;
}

=head2 _DBInsert()

Inserts a new record in the table and returns the newly record id.
Returns a number (id of the new record inserted) or undef.

=cut

sub _DBInsert {
    my ( $Self, %Param, ) = @_;

    my $Error   = sub { return { @_, Success => 0 }; };
    my $Success = sub { return { @_, Success => 1 } };

    my $InsertFingerprint = sprintf(
        '%s-%s',
        $$,
        $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
            Length => 32,
        ),
    );
    my @Cols  = qw(article_id attempts sender recipient raw_message insert_fingerprint);
    my @Binds = (
        \$Param{ArticleID},
        \( $Param{Attempts} || 0 ),
        \$Param{Sender},
        \$Param{Recipient},
        \$Param{Message},
        \$InsertFingerprint,
    );

    if ( $Param{ID} ) {
        unshift @Cols,  'id';
        unshift @Binds, \$Param{ID};
    }

    my @Placeholders = map {'?'} @Cols;

    push @Cols, 'create_time';

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $Result   = $DBObject->Do(
        SQL => sprintf( '
            INSERT INTO mail_queue(%s)
            VALUES(%s, current_timestamp )
        ', join( ',', @Cols ), join( ',', @Placeholders ) ),
        Bind => \@Binds,
    );

    if ( !$Result ) {

        $Param{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::MailQueue',
            Value         => "Could not save serialized message data: $Param{Message}",
        );

        $Self->_SetArticleTransmissionError(
            %Param,
            Message => 'Error while creating the mail queue element!',
        );

        return $Error->(
            Action => 'db-insert',
        );
    }

    # Get the newly inserted record to get the id.
    return $Error->(
        Action => 'get-id',
    ) if !$DBObject->Prepare(
        SQL  => 'SELECT id FROM mail_queue WHERE insert_fingerprint = ?',
        Bind => [ \$InsertFingerprint ],
    );

    my @Row = $DBObject->FetchrowArray();
    return $Success->(
        ID => $Row[0],
    );
}

=head2 _CreateCommunicationLogLookup()

Creates the mail-queue item communication-log message association.
It will also create the association for the article if any ArticleID was passed.
Returns 1 always.

=cut

sub _SetCommunicationLogLookup {
    my ( $Self, %Param, ) = @_;

    my $CommunicationLogObject = $Param{CommunicationLogObject};
    if ( $Param{ID} ) {
        $CommunicationLogObject->ObjectLookupSet(
            ObjectLogType    => 'Message',
            TargetObjectType => 'MailQueueItem',
            TargetObjectID   => $Param{ID},
        );
    }

    # If ArticleID is present, set also a lookup for it.
    if ( $Param{ArticleID} ) {
        $CommunicationLogObject->ObjectLookupSet(
            ObjectLogType    => 'Message',
            TargetObjectType => 'Article',
            TargetObjectID   => $Param{ArticleID},
        );
    }

    return 1;
}

=head2 _GetCommunicationLog()

Get the communication log associated to the queue item, if not found, creates a new one.

    my $CommunicationLog = $Self->_GetCommunicationLog(
        ID => '...' # mail-queue item ID
    );

Returns communication-log object.

=cut

sub _GetCommunicationLog {
    my ( $Self, %Param, ) = @_;

    my $CommunicationLogDBObj = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my $LookupInfo            = $CommunicationLogDBObj->ObjectLookupGet(
        ObjectLogType    => 'Message',
        TargetObjectType => 'MailQueueItem',
        TargetObjectID   => $Param{ID},
    );

    # IF for any reason we can't get the lookup information (error or no record found),
    #   lets create a new communication log and communication log message.
    if ( !$LookupInfo || !%{$LookupInfo} ) {
        my $CommunicationLogObject = $Kernel::OM->Create(
            'Kernel::System::CommunicationLog',
            ObjectParams => {
                Transport => 'Email',
                Direction => 'Outgoing',
            },
        );

        $CommunicationLogObject->ObjectLogStart(
            ObjectLogType => 'Message',
        );

        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Message',
            Key           => ref($Self),
            Value         => sprintf(
                q{It wasn't possible to recover the communication for queued ID "%s".},
                $Param{ID},
            ),
        );

        # Set the new mail-queue item communication-log lookup.
        my $ComLookupUpdated = $CommunicationLogObject->ObjectLookupSet(
            ObjectLogType    => 'Message',
            TargetObjectType => 'MailQueueItem',
            TargetObjectID   => $Param{ID},
        );
        if ( !$ComLookupUpdated ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'Error',
                Message  => 'Error while updating the communication message for ID: ' . $Param{ID},
            );
        }

        return $CommunicationLogObject;
    }

    return $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            ObjectLogID => $LookupInfo->{ObjectLogID},
        },
    );
}

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut

1;
