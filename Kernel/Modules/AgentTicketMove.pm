# --
# Kernel/Modules/AgentTicketMove.pm - move tickets to queues
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: AgentTicketMove.pm,v 1.78.2.7 2011-12-09 12:49:45 des Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketMove;

use strict;
use warnings;

use Kernel::System::State;
use Kernel::System::Web::UploadCache;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.78.2.7 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(ParamObject DBObject TicketObject LayoutObject LogObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }
    $Self->{StateObject}       = Kernel::System::State->new(%Param);
    $Self->{UploadCacheObject} = Kernel::System::Web::UploadCache->new(%Param);

    # get params
    $Self->{TicketUnlock} = $Self->{ParamObject}->GetParam( Param => 'TicketUnlock' );

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Self->{UploadCacheObject}->FormIDCreate();
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TicketID)) {
        if ( !$Self->{$Needed} ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => "Need $Needed!", );
        }
    }

    # check permissions
    my $Access = $Self->{TicketObject}->TicketPermission(
        Type     => 'move',
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need move permissions!",
            WithHeader => 'yes',
        );
    }

    # check if ticket is locked
    if ( $Self->{TicketObject}->TicketLockGet( TicketID => $Self->{TicketID} ) ) {
        my $AccessOk = $Self->{TicketObject}->OwnerCheck(
            TicketID => $Self->{TicketID},
            OwnerID  => $Self->{UserID},
        );
        if ( !$AccessOk ) {
            my $Output = $Self->{LayoutObject}->Header(
                Type => 'Small',
            );
            $Output .= $Self->{LayoutObject}->Warning(
                Message => "Sorry, you need to be the owner to do this action!",
                Comment => 'Please change the owner first.',
            );

            # show back link
            $Self->{LayoutObject}->Block(
                Name => 'TicketBack',
                Data => { %Param, TicketID => $Self->{TicketID} },
            );

            $Output .= $Self->{LayoutObject}->Footer(
                Type => 'Small',
            );
            return $Output;
        }
    }

    # ticket attributes
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

    # get params
    my %GetParam;
    for my $Parameter (
        qw(Subject Body TimeUnits
        NewUserID OldUserID NewStateID NewPriorityID
        UserSelection OwnerAll NoSubmit DestQueueID DestQueue
        )
        )
    {
        $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
    }
    for my $Parameter (qw(Year Month Day Hour Minute)) {
        $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );
    }

    # get ticket free text params
    for my $Count ( 1 .. 16 ) {
        my $Key  = 'TicketFreeKey' . $Count;
        my $Text = 'TicketFreeText' . $Count;
        $GetParam{$Key}  = $Self->{ParamObject}->GetParam( Param => $Key );
        $GetParam{$Text} = $Self->{ParamObject}->GetParam( Param => $Text );
        if ( !defined $GetParam{$Key} && $Ticket{$Key} ) {
            $GetParam{$Key} = $Ticket{$Key};
        }
        if ( !defined $GetParam{$Text} && $Ticket{$Text} ) {
            $GetParam{$Text} = $Ticket{$Text};
        }
    }

    # get ticket free time params
    FREETIMENUMBER:
    for my $FreeTimeNumber ( 1 .. 6 ) {

        # create freetime prefix
        my $FreeTimePrefix = 'TicketFreeTime' . $FreeTimeNumber;

        # get form params
        for my $Type (qw(Used Year Month Day Hour Minute)) {
            $GetParam{ $FreeTimePrefix . $Type }
                = $Self->{ParamObject}->GetParam( Param => $FreeTimePrefix . $Type );
        }

        # set additional params
        $GetParam{ $FreeTimePrefix . 'Optional' } = 1;
        $GetParam{ $FreeTimePrefix . 'Used' } = $GetParam{ $FreeTimePrefix . 'Used' } || 0;
        if ( !$Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $FreeTimeNumber ) ) {
            $GetParam{ $FreeTimePrefix . 'Optional' } = 0;
            $GetParam{ $FreeTimePrefix . 'Used' }     = 1;
        }

        if ( $Self->{Config}->{TicketFreeTime}->{$FreeTimeNumber} == 2 ) {
            $GetParam{ 'TicketFreeTime' . $FreeTimeNumber . 'Required' } = 1;
        }

        # check the timedata
        my $TimeDataComplete = 1;
        TYPE:
        for my $Type (qw(Used Year Month Day Hour Minute)) {
            next TYPE if defined $GetParam{ $FreeTimePrefix . $Type };

            $TimeDataComplete = 0;
            last TYPE;
        }

        next FREETIMENUMBER if $TimeDataComplete;

        if ( !$Ticket{$FreeTimePrefix} ) {

            for my $Type (qw(Used Year Month Day Hour Minute)) {
                delete $GetParam{ $FreeTimePrefix . $Type };
            }

            next FREETIMENUMBER;
        }

        # get freetime data from ticket
        my $TicketFreeTimeString
            = $Self->{TimeObject}->TimeStamp2SystemTime( String => $Ticket{$FreeTimePrefix} );
        my ( $Second, $Minute, $Hour, $Day, $Month, $Year )
            = $Self->{TimeObject}->SystemTime2Date( SystemTime => $TicketFreeTimeString );

        $GetParam{ $FreeTimePrefix . 'UsedFromTicket' } = 1;
        $GetParam{ $FreeTimePrefix . 'Used' }           = 1;
        $GetParam{ $FreeTimePrefix . 'Minute' }         = $Minute;
        $GetParam{ $FreeTimePrefix . 'Hour' }           = $Hour;
        $GetParam{ $FreeTimePrefix . 'Day' }            = $Day;
        $GetParam{ $FreeTimePrefix . 'Month' }          = $Month;
        $GetParam{ $FreeTimePrefix . 'Year' }           = $Year;
    }

    # transform pending time, time stamp based on user time zone
    if (
        defined $GetParam{Year}
        && defined $GetParam{Month}
        && defined $GetParam{Day}
        && defined $GetParam{Hour}
        && defined $GetParam{Minute}
        )
    {
        %GetParam = $Self->{LayoutObject}->TransfromDateSelection(
            %GetParam,
        );
    }

    # transform free time, time stamp based on user time zone
    for my $Count ( 1 .. 6 ) {
        my $Prefix = 'TicketFreeTime' . $Count;
        next if $GetParam{ $Prefix . 'UsedFromTicket' };
        next if !defined $GetParam{ $Prefix . 'Year' };
        next if !defined $GetParam{ $Prefix . 'Month' };
        next if !defined $GetParam{ $Prefix . 'Day' };
        next if !defined $GetParam{ $Prefix . 'Hour' };
        next if !defined $GetParam{ $Prefix . 'Minute' };
        %GetParam = $Self->{LayoutObject}->TransfromDateSelection(
            %GetParam,
            Prefix => $Prefix
        );
    }

    # rewrap body if no rich text is used
    if ( $GetParam{Body} && !$Self->{LayoutObject}->{BrowserRichText} ) {
        my $Size = $Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote') || 70;
        $GetParam{Body} =~ s/(^>.+|.{4,$Size})(?:\s|\z)/$1\n/gm;
    }

    # error handling
    my %Error;

    # distinguish between action concerning attachments and the move action
    my $IsUpload = 0;

    # DestQueueID lookup
    if ( !$GetParam{DestQueueID} && $GetParam{DestQueue} ) {
        $GetParam{DestQueueID} = $Self->{QueueObject}->QueueLookup( Queue => $GetParam{DestQueue} );
    }
    if ( !$GetParam{DestQueueID} ) {
        $Error{DestQueue} = 1;
    }

    # do not submit
    if ( $GetParam{NoSubmit} ) {
        $Error{NoSubmit} = 1;
    }

    # check new/old user selection
    if ( $GetParam{UserSelection} && $GetParam{UserSelection} eq 'Old' ) {
        $GetParam{'UserSelection::Old'} = 'checked';
        if ( $GetParam{OldUserID} ) {
            $GetParam{NewUserID} = $GetParam{OldUserID};
        }
    }
    else {
        $GetParam{'UserSelection::New'} = 'checked';
    }

    # ajax update
    if ( $Self->{Subaction} eq 'AJAXUpdate' ) {
        my $Users = $Self->_GetUsers(
            QueueID  => $GetParam{DestQueueID},
            AllUsers => $GetParam{OwnerAll},
        );
        my $NextStates = $Self->_GetNextStates(
            TicketID => $Self->{TicketID},
            QueueID => $GetParam{DestQueueID} || 1,
        );
        my $NextPriorities = $Self->_GetPriorities(
            TicketID => $Self->{TicketID},
            QueueID => $GetParam{DestQueueID} || 1,
        );

        # get free text config options
        my @TicketFreeTextConfig;
        for my $Count ( 1 .. 16 ) {
            my $Key       = 'TicketFreeKey' . $Count;
            my $Text      = 'TicketFreeText' . $Count;
            my $ConfigKey = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => $Key,
                Action   => $Self->{Action},
                QueueID  => $GetParam{DestQueueID} || 0,
                UserID   => $Self->{UserID},
            );
            if ($ConfigKey) {
                push(
                    @TicketFreeTextConfig,
                    {
                        Name        => $Key,
                        Data        => $ConfigKey,
                        SelectedID  => $GetParam{$Key},
                        Translation => 0,
                        Max         => 100,
                    }
                );
            }
            my $ConfigValue = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => $Text,
                Action   => $Self->{Action},
                QueueID  => $GetParam{DestQueueID} || 0,
                UserID   => $Self->{UserID},
            );
            if ($ConfigValue) {
                push(
                    @TicketFreeTextConfig,
                    {
                        Name        => $Text,
                        Data        => $ConfigValue,
                        SelectedID  => $GetParam{$Text},
                        Translation => 0,
                        Max         => 100,
                    }
                );
            }
        }
        my $JSON = $Self->{LayoutObject}->BuildSelectionJSON(
            [
                {
                    Name         => 'NewUserID',
                    Data         => $Users,
                    SelectedID   => $GetParam{NewUserID},
                    Translation  => 0,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name         => 'NewStateID',
                    Data         => $NextStates,
                    SelectedID   => $GetParam{NewStateID},
                    Translation  => 1,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name         => 'NewPriorityID',
                    Data         => $NextPriorities,
                    SelectedID   => $GetParam{NewPriorityID},
                    Translation  => 1,
                    PossibleNone => 1,
                    Max          => 100,
                },
                @TicketFreeTextConfig,
            ],
        );
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # attachment delete
    for my $Count ( 1 .. 32 ) {
        my $Delete = $Self->{ParamObject}->GetParam( Param => "AttachmentDelete$Count" );
        next if !$Delete;
        $Error{AttachmentDelete} = 1;
        $Self->{UploadCacheObject}->FormIDRemoveFile(
            FormID => $Self->{FormID},
            FileID => $Count,
        );
        $IsUpload = 1;
    }

    # attachment upload
    if ( $Self->{ParamObject}->GetParam( Param => 'AttachmentUpload' ) ) {
        $IsUpload                = 1;
        %Error                   = ();
        $Error{AttachmentUpload} = 1;
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'FileUpload',
            Source => 'string',
        );
        $Self->{UploadCacheObject}->FormIDAddFile(
            FormID => $Self->{FormID},
            %UploadStuff,
        );
    }

    # check for errors
    if ( ( $Self->{Subaction} eq 'MoveTicket' ) && ( !$IsUpload ) ) {
        if ( $GetParam{DestQueueID} eq '' ) {
            $Error{'DestQueueIDInvalid'} = 'ServerError';
        }

        # Body and Subject must both be filled in or both be empty
        if ( $GetParam{Subject} eq '' && $GetParam{Body} ne '' ) {
            $Error{'SubjectInvalid'} = 'ServerError';
        }

        if ( $GetParam{Subject} ne '' && $GetParam{Body} eq '' ) {
            $Error{'BodyInvalid'} = 'ServerError';
        }

        # check time units
        if (
            $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime')
            && $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
            && $GetParam{TimeUnits} eq ''
            )
        {
            $Error{'TimeUnitsInvalid'} = ' ServerError';
        }

        # check pending time
        if ( $GetParam{NewStateID} ) {
            my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                ID => $GetParam{NewStateID},
            );

            # check state type
            if ( $StateData{TypeName} =~ /^pending/i ) {

                # check needed stuff
                for my $TimeParameter (qw(Year Month Day Hour Minute)) {
                    if ( !defined $GetParam{$TimeParameter} ) {
                        $Error{'DateInvalid'} = 'ServerError';
                    }
                }

                # check date
                if ( !$Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 ) ) {
                    $Error{'DateInvalid'} = 'ServerError';
                }
                if (
                    $Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 )
                    < $Self->{TimeObject}->SystemTime()
                    )
                {
                    $Error{'DateInvalid'} = 'ServerError';
                }
            }
        }
    }

    # check errors
    if (%Error) {

        # ticket free text
        my %TicketFreeText;
        for my $Count ( 1 .. 16 ) {
            my $Key  = 'TicketFreeKey' . $Count;
            my $Text = 'TicketFreeText' . $Count;
            $TicketFreeText{$Key} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => $Key,
                Action   => $Self->{Action},
                UserID   => $Self->{UserID},
            );
            $TicketFreeText{$Text} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => $Text,
                Action   => $Self->{Action},
                UserID   => $Self->{UserID},
            );

            # If Key has value 2, this means that the freetextfield is required
            if ( $Self->{Config}->{TicketFreeText}->{$Count} == 2 ) {
                $TicketFreeText{Required}->{$Count} = 1;
            }

            if ( ( $Self->{Subaction} eq 'MoveTicket' ) && ( !$IsUpload ) ) {

                # check required FreeTextField (if configured)
                if (
                    ( $Self->{Config}->{TicketFreeText}->{$Count} == 2 )
                    && ( $GetParam{$Text} eq '' )
                    )
                {
                    $TicketFreeText{Error}->{$Count} = 1;
                }
            }
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => \%GetParam,
        );

        # ticket free time
        my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate( Ticket => \%GetParam );

        my $Output = $Self->{LayoutObject}->Header(
            Type => 'Small',
        );

        # get lock state && write (lock) permissions
        if ( !$Self->{TicketObject}->TicketLockGet( TicketID => $Self->{TicketID} ) ) {

            # set owner
            $Self->{TicketObject}->TicketOwnerSet(
                TicketID  => $Self->{TicketID},
                UserID    => $Self->{UserID},
                NewUserID => $Self->{UserID},
            );

            # set lock
            my $Success = $Self->{TicketObject}->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID}
            );

            # show lock state
            if ($Success) {
                $Self->{LayoutObject}->Block(
                    Name => 'PropertiesLock',
                    Data => { %Param, TicketID => $Self->{TicketID} },
                );
                $Self->{TicketUnlock} = 1;
            }
        }
        else {
            my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Self->{TicketID},
                OwnerID  => $Self->{UserID},
            );
            if ( !$AccessOk ) {
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Sorry, you need to be the owner to do this action!",
                    Comment => 'Please change the owner first.',
                );
                $Output .= $Self->{LayoutObject}->Footer(
                    Type => 'Small',
                );
                return $Output;
            }

            # show back link
            $Self->{LayoutObject}->Block(
                Name => 'TicketBack',
                Data => { %Param, TicketID => $Self->{TicketID} },
            );
        }

        # fetch all queues
        my %MoveQueues = $Self->{TicketObject}->MoveList(
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID},
            Action   => $Self->{Action},
            Type     => 'move_into',
        );

        # get next states
        my $NextStates = $Self->_GetNextStates(
            TicketID => $Self->{TicketID},
            QueueID => $GetParam{DestQueueID} || 1,
        );

        # get next priorities
        my $NextPriorities = $Self->_GetPriorities(
            TicketID => $Self->{TicketID},
            QueueID => $GetParam{DestQueueID} || 1,
        );

        # get old owners
        my @OldUserInfo = $Self->{TicketObject}->TicketOwnerList( TicketID => $Self->{TicketID} );

        # get all attachments meta data
        my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # print change form
        $Output .= $Self->AgentMove(
            OldUser        => \@OldUserInfo,
            Attachments    => \@Attachments,
            MoveQueues     => \%MoveQueues,
            TicketID       => $Self->{TicketID},
            NextStates     => $NextStates,
            NextPriorities => $NextPriorities,
            TicketUnlock   => $Self->{TicketUnlock},
            TimeUnits      => $GetParam{TimeUnits},
            FormID         => $Self->{FormID},
            %Ticket,
            %TicketFreeTextHTML,
            %TicketFreeTimeHTML,
            %GetParam,
            %Error,
        );
        $Output .= $Self->{LayoutObject}->Footer(
            Type => 'Small',
        );
        return $Output;
    }

    # move ticket (send notification if no new owner is selected)
    my $BodyAsText = '';
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $BodyAsText = $Self->{LayoutObject}->RichText2Ascii(
            String => $GetParam{Body} || 0,
        );
    }
    else {
        $BodyAsText = $GetParam{Body} || 0;
    }
    my $Move = $Self->{TicketObject}->TicketQueueSet(
        QueueID            => $GetParam{DestQueueID},
        UserID             => $Self->{UserID},
        TicketID           => $Self->{TicketID},
        SendNoNotification => $GetParam{NewUserID},
        Comment            => $BodyAsText,
    );
    if ( !$Move ) {
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # set priority
    if ( $Self->{Config}->{Priority} && $GetParam{NewPriorityID} ) {
        $Self->{TicketObject}->TicketPrioritySet(
            TicketID   => $Self->{TicketID},
            PriorityID => $GetParam{NewPriorityID},
            UserID     => $Self->{UserID},
        );
    }

    # set state
    if ( $Self->{Config}->{State} && $GetParam{NewStateID} ) {
        $Self->{TicketObject}->TicketStateSet(
            TicketID => $Self->{TicketID},
            StateID  => $GetParam{NewStateID},
            UserID   => $Self->{UserID},
        );

        # unlock the ticket after close
        my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
            ID => $GetParam{NewStateID},
        );

        # set unlock on close
        if ( $StateData{TypeName} =~ /^close/i ) {
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'unlock',
                UserID   => $Self->{UserID},
            );
        }

        # set pending time on pendig state
        elsif ( $StateData{TypeName} =~ /^pending/i ) {

            # set pending time
            $Self->{TicketObject}->TicketPendingTimeSet(
                UserID   => $Self->{UserID},
                TicketID => $Self->{TicketID},
                Year     => $GetParam{Year},
                Month    => $GetParam{Month},
                Day      => $GetParam{Day},
                Hour     => $GetParam{Hour},
                Minute   => $GetParam{Minute},
            );
        }
    }

    # check if new user is given and send notification
    if ( $GetParam{NewUserID} ) {

        # lock
        $Self->{TicketObject}->TicketLockSet(
            TicketID => $Self->{TicketID},
            Lock     => 'lock',
            UserID   => $Self->{UserID},
        );

        # set owner
        $Self->{TicketObject}->TicketOwnerSet(
            TicketID  => $Self->{TicketID},
            UserID    => $Self->{UserID},
            NewUserID => $GetParam{NewUserID},
            Comment   => $BodyAsText,
        );
    }

    # force unlock if no new owner is set and ticket was unlocked
    else {
        if ( $Self->{TicketUnlock} ) {
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'unlock',
                UserID   => $Self->{UserID},
            );
        }
    }

    # add note (send no notification)
    my $ArticleID;

    if ( $GetParam{Body} ) {

        # get pre-loaded attachments
        my @AttachmentData = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );

        # get submitted attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'FileUpload',
            Source => 'String',
        );
        if (%UploadStuff) {
            push @AttachmentData, \%UploadStuff;
        }

        my $MimeType = 'text/plain';
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            $MimeType = 'text/html';

            # remove unused inline images
            my @NewAttachmentData;
            for my $Attachment (@AttachmentData) {
                my $ContentID = $Attachment->{ContentID};
                if ($ContentID) {
                    my $ContentIDHTMLQuote = $Self->{LayoutObject}->Ascii2Html(
                        Text => $ContentID,
                    );
                    next if $GetParam{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
                }

                # remember inline images and normal attachments
                push @NewAttachmentData, \%{$Attachment};
            }
            @AttachmentData = @NewAttachmentData;

            # verify html document
            $GetParam{Body} = $Self->{LayoutObject}->RichTextDocumentComplete(
                String => $GetParam{Body},
            );
        }

        $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID       => $Self->{TicketID},
            ArticleType    => 'note-internal',
            SenderType     => 'agent',
            From           => "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>",
            Subject        => $GetParam{Subject},
            Body           => $GetParam{Body},
            MimeType       => $MimeType,
            Charset        => $Self->{LayoutObject}->{UserCharset},
            UserID         => $Self->{UserID},
            HistoryType    => 'AddNote',
            HistoryComment => '%%Move',
            NoAgentNotify  => 1,
        );
        if ( !$ArticleID ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # write attachments
        for my $Attachment (@AttachmentData) {
            $Self->{TicketObject}->ArticleWriteAttachment(
                %{$Attachment},
                ArticleID => $ArticleID,
                UserID    => $Self->{UserID},
            );
        }

        # remove pre-submitted attachments
        $Self->{UploadCacheObject}->FormIDRemove( FormID => $Self->{FormID} );
    }

    # set ticket free text
    for my $Count ( 1 .. 16 ) {
        my $Key  = 'TicketFreeKey' . $Count;
        my $Text = 'TicketFreeText' . $Count;
        next if !defined $GetParam{$Key};
        $Self->{TicketObject}->TicketFreeTextSet(
            TicketID => $Self->{TicketID},
            Key      => $GetParam{$Key},
            Value    => $GetParam{$Text},
            Counter  => $Count,
            UserID   => $Self->{UserID},
        );
    }

    # set ticket free time
    for my $Count ( 1 .. 6 ) {
        my $Prefix = 'TicketFreeTime' . $Count;
        next if !defined $GetParam{ $Prefix . 'Year' };
        next if !defined $GetParam{ $Prefix . 'Month' };
        next if !defined $GetParam{ $Prefix . 'Day' };
        next if !defined $GetParam{ $Prefix . 'Hour' };
        next if !defined $GetParam{ $Prefix . 'Minute' };

        # set time stamp to NULL if field is not used/checked
        if ( !$GetParam{ $Prefix . 'Used' } ) {
            $GetParam{ $Prefix . 'Year' }   = 0;
            $GetParam{ $Prefix . 'Month' }  = 0;
            $GetParam{ $Prefix . 'Day' }    = 0;
            $GetParam{ $Prefix . 'Hour' }   = 0;
            $GetParam{ $Prefix . 'Minute' } = 0;
        }

        # set free time
        $Self->{TicketObject}->TicketFreeTimeSet(
            %GetParam,
            Prefix   => 'TicketFreeTime',
            TicketID => $Self->{TicketID},
            Counter  => $Count,
            UserID   => $Self->{UserID},
        );
    }

    # time accounting
    if ( $GetParam{TimeUnits} ) {
        $Self->{TicketObject}->TicketAccountTime(
            TicketID  => $Self->{TicketID},
            ArticleID => $ArticleID,
            TimeUnit  => $GetParam{TimeUnits},
            UserID    => $Self->{UserID},
        );
    }

    # check permission for redirect
    my $AccessNew = $Self->{TicketObject}->TicketPermission(
        Type     => 'ro',
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # redirect to last overview if we do not have ro permissions anymore
    if ( !$AccessNew ) {

        # Module directly called
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::MoveType') eq 'form' ) {
            return $Self->{LayoutObject}->Redirect( OP => $Self->{LastScreenOverview} );
        }

        # Module opened in popup
        elsif ( $Self->{ConfigObject}->Get('Ticket::Frontend::MoveType') eq 'link' ) {
            return $Self->{LayoutObject}->PopupClose(
                URL => ( $Self->{LastScreenOverview} || 'Action=AgentDashboard' ),
            );
        }
    }

    # Module directly called
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::MoveType') eq 'form' ) {
        return $Self->{LayoutObject}->Redirect( OP => $Self->{LastScreenView} );
    }

    # Module opened in popup
    elsif ( $Self->{ConfigObject}->Get('Ticket::Frontend::MoveType') eq 'link' ) {
        return $Self->{LayoutObject}->PopupClose(
            URL => ( $Self->{LastScreenView} || 'Action=AgentDashboard' ),
        );
    }
}

sub AgentMove {
    my ( $Self, %Param ) = @_;

    $Param{DestQueueIDInvalid} = $Param{DestQueueIDInvalid} || '';

    my %Data       = %{ $Param{MoveQueues} };
    my %MoveQueues = %Data;
    my %UsedData;
    my %UserHash;
    if ( $Param{OldUser} ) {
        my $Counter = 1;
        for my $User ( reverse @{ $Param{OldUser} } ) {
            next if $UserHash{ $User->{UserID} };
            $UserHash{ $User->{UserID} } = "$Counter: $User->{UserLastname} "
                . "$User->{UserFirstname} ($User->{UserLogin})";
            $Counter++;
        }
    }
    my $OldUserSelectedID = $Param{OldUserID};
    if ( !$OldUserSelectedID && $Param{OldUser}->[0]->{UserID} ) {
        $OldUserSelectedID = $Param{OldUser}->[0]->{UserID} . '1';
    }

    # build string
    $Param{OldUserStrg} = $Self->{LayoutObject}->BuildSelection(
        Data         => \%UserHash,
        SelectedID   => $OldUserSelectedID,
        Name         => 'OldUserID',
        Translation  => 0,
        PossibleNone => 1,
    );

    # build next states string
    $Param{NextStatesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data         => $Param{NextStates},
        Name         => 'NewStateID',
        SelectedID   => $Param{NewStateID},
        Translation  => 1,
        PossibleNone => 1,
    );

    # build next priority string
    $Param{NextPrioritiesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data         => $Param{NextPriorities},
        Name         => 'NewPriorityID',
        SelectedID   => $Param{NewPriorityID},
        Translation  => 1,
        PossibleNone => 1,
    );

    # build owner string
    $Param{OwnerStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => $Self->_GetUsers(
            QueueID  => $Param{DestQueueID},
            AllUsers => $Param{OwnerAll},
        ),
        Name         => 'NewUserID',
        SelectedID   => $Param{NewUserID},
        Translation  => 0,
        PossibleNone => 1,
    );

    # set state
    if ( $Self->{Config}->{State} ) {
        $Self->{LayoutObject}->Block(
            Name => 'State',
            Data => {%Param},
        );
    }

    for my $StateID ( sort keys %{ $Param{NextStates} } ) {
        next if !$StateID;
        my %StateData = $Self->{TicketObject}->{StateObject}->StateGet( ID => $StateID );
        if ( $StateData{TypeName} =~ /pending/i ) {
            $Param{DateString} = $Self->{LayoutObject}->BuildDateSelection(
                Format           => 'DateInputFormatLong',
                YearPeriodPast   => 0,
                YearPeriodFuture => 5,
                DiffTime         => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime')
                    || 0,
                %Param,
                Class => $Param{DateInvalid} || ' ',
                Validate             => 1,
                ValidateDateInFuture => 1,
            );
            $Self->{LayoutObject}->Block(
                Name => 'StatePending',
                Data => \%Param,
            );
            last;
        }
    }

    # set priority
    if ( $Self->{Config}->{Priority} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Priority',
            Data => {%Param},
        );
    }

    # set move queues
    $Param{MoveQueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => { %MoveQueues, '' => '-' },
        Multiple       => 0,
        Size           => 0,
        Class          => 'Validate_Required' . ' ' . $Param{DestQueueIDInvalid},
        Name           => 'DestQueueID',
        SelectedID     => $Param{DestQueueID},
        OnChangeSubmit => 0,
    );

    # show time accounting box
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime') ) {
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime') ) {
            $Self->{LayoutObject}->Block(
                Name => 'TimeUnitsLabelMandatory',
                Data => \%Param,
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'TimeUnitsLabel',
                Data => \%Param,
            );
        }
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnits',
            Data => {
                %Param,
                TimeUnitsRequired => (
                    $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
                    ? 'Validate_Required'
                    : ''
                ),
                }
        );
    }

    # show spell check
    if ( $Self->{LayoutObject}->{BrowserSpellChecker} ) {
        $Self->{LayoutObject}->Block(
            Name => 'TicketOptions',
            Data => {},
        );
        $Self->{LayoutObject}->Block(
            Name => 'SpellCheck',
            Data => {},
        );
    }

    # show attachments
    for my $Attachment ( @{ $Param{Attachments} } ) {
        next if $Attachment->{ContentID} && $Self->{LayoutObject}->{BrowserRichText};
        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $Attachment,
        );
    }

    # ticket free text
    for my $Count ( 1 .. 16 ) {
        if ( $Self->{Config}->{'TicketFreeText'}->{$Count} ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeText',
                Data => {
                    TicketFreeKeyField  => $Param{ 'TicketFreeKeyField' . $Count },
                    TicketFreeTextField => $Param{ 'TicketFreeTextField' . $Count },
                    Count               => $Count,
                    %Param,
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeText' . $Count,
                Data => { %Param, Count => $Count },
            );
        }
    }
    for my $Count ( 1 .. 6 ) {
        if ( $Self->{Config}->{'TicketFreeTime'}->{$Count} ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTime',
                Data => {
                    TicketFreeTimeKey => $Param{ 'TicketFreeTimeKey' . $Count },
                    TicketFreeTime    => $Param{ 'TicketFreeTime' . $Count },
                    Count             => $Count,
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTime' . $Count,
                Data => { %Param, Count => $Count },
            );
        }
    }

    # fillup configured default vars
    if ( $Param{Body} eq '' && $Self->{Config}->{Body} ) {
        $Param{Body} = $Self->{LayoutObject}->Output(
            Template => $Self->{Config}->{Body},
        );
    }

    if ( $Param{Subject} eq '' && $Self->{Config}->{Subject} ) {
        $Param{Subject} = $Self->{LayoutObject}->Output(
            Template => $Self->{Config}->{Subject},
        );
    }

    # add rich text editor
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {

        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => \%Param,
        );
    }

    return $Self->{LayoutObject}->Output( TemplateFile => 'AgentTicketMove', Data => \%Param );
}

sub _GetUsers {
    my ( $Self, %Param ) = @_;

    # get users
    my %ShownUsers;
    my %AllGroupsMembers = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # just show only users with selected custom queue
    if ( $Param{QueueID} && !$Param{AllUsers} ) {
        my @UserIDs = $Self->{TicketObject}->GetSubscribedUserIDsByQueueID(%Param);
        for my $UserGroupMember ( keys %AllGroupsMembers ) {
            my $Hit = 0;
            for my $UID (@UserIDs) {
                if ( $UID eq $UserGroupMember ) {
                    $Hit = 1;
                }
            }
            if ( !$Hit ) {
                delete $AllGroupsMembers{$UserGroupMember};
            }
        }
    }

    # check show users
    if ( $Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show all users who are rw in the queue group
    elsif ( $Param{QueueID} ) {
        my $GID = $Self->{QueueObject}->GetQueueGroupID( QueueID => $Param{QueueID} );
        my %MemberList = $Self->{GroupObject}->GroupMemberList(
            GroupID => $GID,
            Type    => 'owner',
            Result  => 'HASH',
        );
        for my $MemberUsers ( keys %MemberList ) {
            if ( $AllGroupsMembers{$MemberUsers} ) {
                $ShownUsers{$MemberUsers} = $AllGroupsMembers{$MemberUsers};
            }
        }
    }
    return \%ShownUsers;
}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    # get priority
    my %Priorities;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Priorities = $Self->{TicketObject}->TicketPriorityList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Priorities;
}

sub _GetNextStates {
    my ( $Self, %Param ) = @_;

    my %NextStates;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %NextStates = $Self->{TicketObject}->TicketStateList(
            %Param,
            Type   => 'DefaultNextMove',
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%NextStates;
}

1;
