# --
# Kernel/Modules/AgentTicketMove.pm - move tickets to queues
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketMove.pm,v 1.21 2008-06-25 22:48:27 martin Exp $
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
$VERSION = qw($Revision: 1.21 $) [1];

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

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID)) {
        if ( !$Self->{$_} ) {

            # error page
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

    # get params
    my %GetParam = ();
    for (
        qw(Subject Body TimeUnits
        NewUserID OldUserID NewStateID
        UserSelection ExpandQueueUsers NoSubmit DestQueueID DestQueue
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
    my %Error = ();
    if ( $GetParam{AttachmentUpload} ) {
        $Error{AttachmentUpload} = 1;
    }

    # check subject if body exists
    if ( $GetParam{Body} && !$GetParam{Subject} ) {
        $Error{'Subject invalid'} = 'invalid';
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

    # ticket attributes
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

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

    # move queue
    if (%Error) {
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
        my %NextStates = $Self->{TicketObject}->StateList(
            Type     => 'DefaultNextMove',
            Action   => $Self->{Action},
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID},
        );
        $NextStates{''} = '-';

        # get old owners
        my @OldUserInfo = $Self->{TicketObject}->OwnerList( TicketID => $Self->{TicketID} );

        # get lod queues
        my @OldQueue = $Self->{TicketObject}->MoveQueueList( TicketID => $Self->{TicketID} );

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
        my @Attachments
            = $Self->{UploadCachObject}->FormIDGetAllFilesMeta( FormID => $Self->{FormID} );

        # print change form
        $Output .= $Self->AgentMove(
            OldQueue     => \@OldQueue,
            OldUser      => \@OldUserInfo,
            Attachments  => \@Attachments,
            MoveQueues   => \%MoveQueues,
            TicketID     => $Self->{TicketID},
            NextStates   => \%NextStates,
            TicketUnlock => $Self->{TicketUnlock},
            TimeUnits    => $GetParam{TimeUnits},
            FormID       => $Self->{FormID},
            %Error,
            %GetParam,
            %Ticket,
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

        # set state
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::MoveSetState') && $GetParam{NewStateID} )
        {
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
    my @OldQueue      = @{ $Param{OldQueue} };
    my $LatestQueueID = '';
    if ( $#OldQueue >= 1 ) {
        $LatestQueueID = $OldQueue[ $#OldQueue - 1 ] || '';
    }
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
    if ( !%UserHash ) {
        $UserHash{''} = '-';
    }
    my $OldUserSelectedID = $Param{OldUserID};
    if ( !$OldUserSelectedID && $Param{OldUser}->[0]->{UserID} ) {
        $OldUserSelectedID = $Param{OldUser}->[0]->{UserID} . '1';
    }

    # build string
    $Param{OldUserStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => \%UserHash,
        SelectedID => $OldUserSelectedID,
        Name       => 'OldUserID',
        OnClick    => "change_selected(2)",
    );

    # build next states string
    $Param{NextStatesStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => $Param{NextStates},
        Name       => 'NewStateID',
        SelectedID => $Param{NewStateID},
    );

    # build owner string
    $Param{OwnerStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Self->_GetUsers(
            QueueID  => $Param{DestQueueID},
            AllUsers => $Param{ExpandQueueUsers}
        ),
        Name       => 'NewUserID',
        SelectedID => $Param{NewUserID},
        OnClick    => "change_selected(0)",
    );
    if ( $LatestQueueID && $MoveQueues{$LatestQueueID} ) {
        $Param{LatestQueue} = '$Text{"Latest Queue!"} "' . $MoveQueues{$LatestQueueID} . '"';
    }

    # set state
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::MoveSetState') ) {
        $Self->{LayoutObject}->Block(
            Name => 'State',
            Data => {%Param},
        );
    }
    $Param{MoveQueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => { %MoveQueues, '' => '-' },
        Multiple       => 0,
        Size           => 0,
        Name           => 'DestQueueID',
        SelectedID     => $Param{DestQueueID},
        OnChangeSubmit => 0,
        OnChange =>
            "document.compose.NoSubmit.value='1'; document.compose.submit(); return false;",
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
            $ShownUsers{$_} = $AllGroupsMembers{$_};
        }
    }
    $ShownUsers{''} = '-';
    return \%ShownUsers;
}

1;
