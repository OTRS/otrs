# --
# Kernel/Modules/AgentTicketMove.pm - move tickets to queues
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketMove.pm,v 1.22 2008-07-01 22:31:43 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentTicketMove;

use strict;
use warnings;

use Kernel::System::State;
use Kernel::System::Web::UploadCache;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.22 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }
    $Self->{StateObject}      = Kernel::System::State->new(%Param);
    $Self->{UploadCachObject} = Kernel::System::Web::UploadCache->new(%Param);

    # get params
    $Self->{TicketUnlock} = $Self->{ParamObject}->GetParam( Param => 'TicketUnlock' );

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Self->{UploadCachObject}->FormIDCreate();
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID)) {
        if ( !$Self->{$_} ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => "Need $_!", );
        }
    }

    # check permissions
    if (
        !$Self->{TicketObject}->Permission(
            Type     => 'move',
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID}
        )
        )
    {

        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # check if ticket is locked
    if ( $Self->{TicketObject}->LockIsTicketLocked( TicketID => $Self->{TicketID} ) ) {
        my $AccessOk = $Self->{TicketObject}->OwnerCheck(
            TicketID => $Self->{TicketID},
            OwnerID  => $Self->{UserID},
        );
        if ( !$AccessOk ) {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->Warning(
                Message => "Sorry, you need to be the owner to do this action!",
                Comment => 'Please change the owner first.',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'TicketBack',
                Data => { %Param, TicketID => $Self->{TicketID}, },
            );
        }
    }

    # ticket attributes
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

    # get params
    my %GetParam = ();
    for (
        qw(Subject Body TimeUnits
        NewUserID OldUserID NewStateID NewPriorityID
        UserSelection OwnerAll NoSubmit DestQueueID DestQueue
        AttachmentUpload
        AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
        AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
        AttachmentDelete9 AttachmentDelete10 AttachmentDelete11 AttachmentDelete12
        AttachmentDelete13 AttachmentDelete14 AttachmentDelete15 AttachmentDelete16
        )
        )
    {
        $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
    }

    # get ticket free text params
    for ( 1 .. 16 ) {
        $GetParam{"TicketFreeKey$_"} = $Self->{ParamObject}->GetParam( Param => "TicketFreeKey$_" );
        $GetParam{"TicketFreeText$_"}
            = $Self->{ParamObject}->GetParam( Param => "TicketFreeText$_" );
        if ( !defined $GetParam{"TicketFreeKey$_"} && $Ticket{"TicketFreeKey$_"} ) {
            $GetParam{"TicketFreeKey$_"} = $Ticket{"TicketFreeKey$_"};
        }
        if ( !defined $GetParam{"TicketFreeText$_"} && $Ticket{"TicketFreeText$_"} ) {
            $GetParam{"TicketFreeText$_"} = $Ticket{"TicketFreeText$_"};
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

        $GetParam{ $FreeTimePrefix . 'Used' }   = 1;
        $GetParam{ $FreeTimePrefix . 'Minute' } = $Minute;
        $GetParam{ $FreeTimePrefix . 'Hour' }   = $Hour;
        $GetParam{ $FreeTimePrefix . 'Day' }    = $Day;
        $GetParam{ $FreeTimePrefix . 'Month' }  = $Month;
        $GetParam{ $FreeTimePrefix . 'Year' }   = $Year;
    }

    # error handling
    my %Error = ();
    if ( $GetParam{AttachmentUpload} ) {
        $Error{AttachmentUpload} = 1;
    }

    # check subject if body exists
    if ( $GetParam{Body} && !$GetParam{Subject} ) {
        $Error{'Subject invalid'} = 'invalid';
    }

    # check required FreeTextField (if configured)
    for ( 1 .. 16 ) {
        if (
            $Self->{Config}->{'TicketFreeText'}->{$_} == 2
            && $GetParam{"TicketFreeText$_"} eq ''
            )
        {
            $Error{"TicketFreeTextField$_ invalid"} = '* invalid';
        }
    }

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
            QueueID  => $GetParam{DestQueueID} || 1,
        );
        my $NextPriorities = $Self->_GetPriorities(
            TicketID => $Self->{TicketID},
            QueueID  => $GetParam{DestQueueID} || 1,
        );
        # get free text config options
        my @TicketFreeTextConfig = ();
        for ( 1 .. 16 ) {
            my $ConfigKey = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => "TicketFreeKey$_",
                Action   => $Self->{Action},
                QueueID  => $GetParam{DestQueueID} || 0,
                UserID   => $Self->{UserID},
            );
            if ($ConfigKey) {
                push(
                    @TicketFreeTextConfig,
                    {
                        Name        => "TicketFreeKey$_",
                        Data        => $ConfigKey,
                        SelectedID  => $GetParam{"TicketFreeKey$_"},
                        Translation => 0,
                        Max         => 100,
                    }
                );
            }
            my $ConfigValue = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => "TicketFreeText$_",
                Action   => $Self->{Action},
                QueueID  => $GetParam{DestQueueID} || 0,
                UserID   => $Self->{UserID},
            );
            if ($ConfigValue) {
                push(
                    @TicketFreeTextConfig,
                    {
                        Name        => "TicketFreeText$_",
                        Data        => $ConfigValue,
                        SelectedID  => $GetParam{"TicketFreeText$_"},
                        Translation => 0,
                        Max         => 100,
                    }
                );
            }
        }
        my $JSON = $Self->{LayoutObject}->BuildJSON(
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
            ContentType => 'text/plain; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # move queue
    if (%Error) {
        # ticket free text
        my %TicketFreeText = ();
        for ( 1 .. 16 ) {
            $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => "TicketFreeKey$_",
                Action   => $Self->{Action},
                UserID   => $Self->{UserID},
            );
            $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => "TicketFreeText$_",
                Action   => $Self->{Action},
                UserID   => $Self->{UserID},
            );
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => \%GetParam,
        );

        # ticket free time
        my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate( Ticket => \%GetParam );

        my $Output = $Self->{LayoutObject}->Header();

        # get lock state && write (lock) permissions
        if ( !$Self->{TicketObject}->LockIsTicketLocked( TicketID => $Self->{TicketID} ) ) {

            # set owner
            $Self->{TicketObject}->OwnerSet(
                TicketID  => $Self->{TicketID},
                UserID    => $Self->{UserID},
                NewUserID => $Self->{UserID},
            );

            # set lock
            if (
                $Self->{TicketObject}->LockSet(
                    TicketID => $Self->{TicketID},
                    Lock     => 'lock',
                    UserID   => $Self->{UserID}
                )
                )
            {

                # show lock state
                $Self->{LayoutObject}->Block(
                    Name => 'PropertiesLock',
                    Data => { %Param, TicketID => $Self->{TicketID} },
                );
                $Self->{TicketUnlock} = 1;
            }
        }
        else {
            my ( $OwnerID, $OwnerLogin )
                = $Self->{TicketObject}->OwnerCheck( TicketID => $Self->{TicketID} );
            if ( $OwnerID != $Self->{UserID} ) {
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Sorry, the current owner is $OwnerLogin!",
                    Comment => 'Please change the owner first.',
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
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
            QueueID  => $GetParam{DestQueueID} || 1,
        );

        # get next priorities
        my $NextPriorities = $Self->_GetPriorities(
            TicketID => $Self->{TicketID},
            QueueID  => $GetParam{DestQueueID} || 1,
        );

        # get old owners
        my @OldUserInfo = $Self->{TicketObject}->OwnerList( TicketID => $Self->{TicketID} );

        # attachment delete
        for ( 1 .. 16 ) {
            if ( $GetParam{"AttachmentDelete$_"} ) {
                $Error{AttachmentDelete} = 1;
                $Self->{UploadCachObject}->FormIDRemoveFile(
                    FormID => $Self->{FormID},
                    FileID => $_,
                );
            }
        }

        # attachment upload
        if ( $GetParam{AttachmentUpload} ) {
            $Error{AttachmentUpload} = 1;
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param  => "file_upload",
                Source => 'string',
            );
            $Self->{UploadCachObject}->FormIDAddFile(
                FormID => $Self->{FormID},
                %UploadStuff,
            );
        }

        # get all attachments meta data
        my @Attachments = $Self->{UploadCachObject}->FormIDGetAllFilesMeta(
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
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    elsif (
        $Self->{TicketObject}->MoveTicket(
            QueueID            => $GetParam{DestQueueID},
            UserID             => $Self->{UserID},
            TicketID           => $Self->{TicketID},
            SendNoNotification => $GetParam{NewUserID},
            Comment            => $GetParam{Body} || '',
        )
        )
    {

        # set priority
        if ( $Self->{Config}->{Priority} && $GetParam{NewPriorityID} ) {
            $Self->{TicketObject}->PrioritySet(
                TicketID   => $Self->{TicketID},
                PriorityID => $GetParam{NewPriorityID},
                UserID     => $Self->{UserID},
            );
        }

        # set state
        if ( $Self->{Config}->{State} && $GetParam{NewStateID} ) {
            $Self->{TicketObject}->StateSet(
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
                $Self->{TicketObject}->LockSet(
                    TicketID => $Self->{TicketID},
                    Lock     => 'unlock',
                    UserID   => $Self->{UserID},
                );
            }
        }

        # check if new user is given
        if ( $GetParam{NewUserID} ) {

            # lock
            $Self->{TicketObject}->LockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID},
            );

            # set owner
            $Self->{TicketObject}->OwnerSet(
                TicketID  => $Self->{TicketID},
                UserID    => $Self->{UserID},
                NewUserID => $GetParam{NewUserID},
                Comment   => $GetParam{Comment} || '',
            );
        }
        else {

            # unlock
            if ( $Self->{TicketUnlock} ) {
                $Self->{TicketObject}->LockSet(
                    TicketID => $Self->{TicketID},
                    Lock     => 'unlock',
                    UserID   => $Self->{UserID},
                );
            }
        }

        # add note
        my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );
        my $ArticleID;
        if ( $GetParam{Body} ) {
            $ArticleID = $Self->{TicketObject}->ArticleCreate(
                TicketID    => $Self->{TicketID},
                ArticleType => 'note-internal',
                SenderType  => 'agent',
                From        => "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>",
                Subject     => $GetParam{Subject},
                Body        => $GetParam{Body},
                ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
                UserID      => $Self->{UserID},
                HistoryType => 'AddNote',
                HistoryComment => '%%Move',
                NoAgentNotify  => 1,
            );

            # get pre loaded attachment
            my @AttachmentData = $Self->{UploadCachObject}->FormIDGetAllFilesData(
                FormID => $Self->{FormID},
            );
            for my $Ref (@AttachmentData) {
                $Self->{TicketObject}->ArticleWriteAttachment(
                    %{$Ref},
                    ArticleID => $ArticleID,
                    UserID    => $Self->{UserID},
                );
            }

            # get submit attachment
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param  => 'file_upload',
                Source => 'String',
            );
            if (%UploadStuff) {
                $Self->{TicketObject}->ArticleWriteAttachment(
                    %UploadStuff,
                    ArticleID => $ArticleID,
                    UserID    => $Self->{UserID},
                );
            }

            # remove pre submited attachments
            $Self->{UploadCachObject}->FormIDRemove( FormID => $Self->{FormID} );
        }

        # set ticket free text
        for ( 1 .. 16 ) {
            if ( defined( $GetParam{"TicketFreeKey$_"} ) ) {
                $Self->{TicketObject}->TicketFreeTextSet(
                    TicketID => $Self->{TicketID},
                    Key      => $GetParam{"TicketFreeKey$_"},
                    Value    => $GetParam{"TicketFreeText$_"},
                    Counter  => $_,
                    UserID   => $Self->{UserID},
                );
            }
        }

        # set ticket free time
        for ( 1 .. 6 ) {
            if (
                defined( $GetParam{ "TicketFreeTime" . $_ . "Year" } )
                && defined( $GetParam{ "TicketFreeTime" . $_ . "Month" } )
                && defined( $GetParam{ "TicketFreeTime" . $_ . "Day" } )
                && defined( $GetParam{ "TicketFreeTime" . $_ . "Hour" } )
                && defined( $GetParam{ "TicketFreeTime" . $_ . "Minute" } )
                )
            {
                my %Time;
                $Time{ "TicketFreeTime" . $_ . "Year" }    = 0;
                $Time{ "TicketFreeTime" . $_ . "Month" }   = 0;
                $Time{ "TicketFreeTime" . $_ . "Day" }     = 0;
                $Time{ "TicketFreeTime" . $_ . "Hour" }    = 0;
                $Time{ "TicketFreeTime" . $_ . "Minute" }  = 0;
                $Time{ "TicketFreeTime" . $_ . "Secunde" } = 0;

                if ( $GetParam{ "TicketFreeTime" . $_ . "Used" } ) {
                    %Time = $Self->{LayoutObject}->TransfromDateSelection(
                        %GetParam, Prefix => "TicketFreeTime" . $_
                    );
                }
                $Self->{TicketObject}->TicketFreeTimeSet(
                    %Time,
                    Prefix   => "TicketFreeTime",
                    TicketID => $Self->{TicketID},
                    Counter  => $_,
                    UserID   => $Self->{UserID},
                );
            }
        }

        # time accounting
        if ( $GetParam{TimeUnits} ) {
            $Self->{TicketObject}->TicketAccountTime(
                TicketID  => $Self->{TicketID},
                ArticleID => $ArticleID || '',
                TimeUnit  => $GetParam{TimeUnits},
                UserID    => $Self->{UserID},
            );
        }

        # redirect
        return $Self->{LayoutObject}->Redirect( OP => $Self->{LastScreenView} );
    }
    else {

        # error?!
        my $Output = $Self->{LayoutObject}->Header( Title => 'Warning' );
        $Output .= $Self->{LayoutObject}->Warning(
            Comment => 'Please contact your admin',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub AgentMove {
    my ( $Self, %Param ) = @_;

    my %Data          = %{ $Param{MoveQueues} };
    my %MoveQueues    = %Data;
    my %UsedData      = ();
    my %UserHash      = ();
    if ( $Param{OldUser} ) {
        my $Counter = 0;
        for my $User ( reverse @{ $Param{OldUser} } ) {
            if ($Counter) {
                if ( !$UserHash{ $User->{UserID} } ) {
                    $UserHash{ $User->{UserID} } = "$Counter: $User->{UserLastname} "
                        . "$User->{UserFirstname} ($User->{UserLogin})";
                }
            }
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
        OnClick      => "change_selected(2)",
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
            AllUsers => $Param{OwnerAll}
        ),
        Name         => 'NewUserID',
        SelectedID   => $Param{NewUserID},
        Translation  => 0,
        PossibleNone => 1,
        OnClick      => "change_selected(0)",
    );

    # set state
    if ( $Self->{Config}->{State} ) {
        $Self->{LayoutObject}->Block(
            Name => 'State',
            Data => {%Param},
        );
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
        Name           => 'DestQueueID',
        SelectedID     => $Param{DestQueueID},
        OnChangeSubmit => 0,
        OnChange =>
            "document.compose.NoSubmit.value='1'; document.compose.submit(); return false;",
            Ajax => {
                Update => [
                    'NewUserID',
                    'NewStateID',
                    'NewPriorityID',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Depend => [
                    'TicketID',
                    'DestQueueID',
                    'NewUserID',
                    'OwnerAll',
                    'NewStateID',
                    'NewPriorityID',
                    'TicketFreeText1',
                    'TicketFreeText2',
                    'TicketFreeText3',
                    'TicketFreeText4',
                    'TicketFreeText5',
                    'TicketFreeText6',
                    'TicketFreeText7',
                    'TicketFreeText8',
                    'TicketFreeText9',
                    'TicketFreeText10',
                    'TicketFreeText11',
                    'TicketFreeText12',
                    'TicketFreeText13',
                    'TicketFreeText14',
                    'TicketFreeText15',
                    'TicketFreeText16',
                ],
                Subaction => 'AJAXUpdate',
        },
    );

    # show time accounting box
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime') ) {
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnitsJs',
            Data => \%Param,
        );
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnits',
            Data => \%Param,
        );
    }

    # show spell check
    if (
        $Self->{ConfigObject}->Get('SpellChecker')
        && $Self->{LayoutObject}->{BrowserJavaScriptSupport}
        )
    {
        $Self->{LayoutObject}->Block(
            Name => 'SpellCheck',
            Data => {},
        );
    }

    # show attachments
    for my $DataRef ( @{ $Param{Attachments} } ) {
        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $DataRef,
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
                    TicketFreeTimeKey => $Self->{ConfigObject}->Get( 'TicketFreeTimeKey' . $Count ),
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

    # java script check for required free text fields by form submit
    for my $Key ( keys %{ $Self->{Config}->{TicketFreeText} } ) {
        if ( $Self->{Config}->{TicketFreeText}->{$Key} == 2 ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTextCheckJs',
                Data => {
                    TicketFreeTextField => "TicketFreeText$Key",
                    TicketFreeKeyField  => "TicketFreeKey$Key",
                },
            );
        }
    }

    # java script check for required free time fields by form submit
    for my $Key ( keys %{ $Self->{Config}->{TicketFreeTime} } ) {
        if ( $Self->{Config}->{TicketFreeTime}->{$Key} == 2 ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTimeCheckJs',
                Data => {
                    TicketFreeTimeCheck => 'TicketFreeTime' . $Key . 'Used',
                    TicketFreeTimeField => 'TicketFreeTime' . $Key,
                    TicketFreeTimeKey   => $Self->{ConfigObject}->Get( 'TicketFreeTimeKey' . $Key ),
                },
            );
        }
    }

    return $Self->{LayoutObject}->Output( TemplateFile => 'AgentTicketMove', Data => \%Param );
}

sub _GetUsers {
    my ( $Self, %Param ) = @_;

    # get users
    my %ShownUsers       = ();
    my %AllGroupsMembers = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # just show only users with selected custom queue
    if ( $Param{QueueID} && !$Param{AllUsers} ) {
        my @UserIDs = $Self->{TicketObject}->GetSubscribedUserIDsByQueueID(%Param);
        for ( keys %AllGroupsMembers ) {
            my $Hit = 0;
            for my $UID (@UserIDs) {
                if ( $UID eq $_ ) {
                    $Hit = 1;
                }
            }
            if ( !$Hit ) {
                delete $AllGroupsMembers{$_};
            }
        }
    }

    # show all system users
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
            Cached  => 1,
        );
        for ( keys %MemberList ) {
            if ( $AllGroupsMembers{$_} ) {
                $ShownUsers{$_} = $AllGroupsMembers{$_};
            }
        }
    }
    return \%ShownUsers;
}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    my %Priorities = ();

    # get priority
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Priorities = $Self->{TicketObject}->PriorityList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Priorities;
}

sub _GetNextStates {
    my ( $Self, %Param ) = @_;

    my %NextStates = ();
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %NextStates = $Self->{TicketObject}->StateList(
            %Param,
            Type   => 'DefaultNextMove',
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%NextStates;
}

1;
