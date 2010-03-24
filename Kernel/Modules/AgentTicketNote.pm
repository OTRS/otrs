# --
# Kernel/Modules/AgentTicketNote.pm - to add notes to a ticket
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketNote.pm,v 1.84 2010-03-24 11:15:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketNote;

use strict;
use warnings;

use Kernel::System::State;
use Kernel::System::Web::UploadCache;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.84 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }
    $Self->{StateObject}       = Kernel::System::State->new(%Param);
    $Self->{UploadCacheObject} = Kernel::System::Web::UploadCache->new(%Param);

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    # get inform user list
    my @InformUserID = $Self->{ParamObject}->GetArray( Param => 'InformUserID' );
    $Self->{InformUserID} = \@InformUserID;

    # get involved user list
    my @InvolvedUserID = $Self->{ParamObject}->GetArray( Param => 'InvolvedUserID' );
    $Self->{InvolvedUserID} = \@InvolvedUserID;

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Self->{UploadCacheObject}->FormIDCreate();
    }

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No TicketID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{TicketObject}->Permission(
        Type     => $Self->{Config}->{Permission},
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );
    $Self->{LayoutObject}->Block(
        Name => 'Properties',
        Data => {
            FormID => $Self->{FormID},
            %Ticket,
            %Param,
        },
    );

    # get lock state
    if ( $Self->{Config}->{RequiredLock} ) {
        if ( !$Self->{TicketObject}->LockIsTicketLocked( TicketID => $Self->{TicketID} ) ) {
            $Self->{TicketObject}->LockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID}
            );
            my $Success = $Self->{TicketObject}->OwnerSet(
                TicketID  => $Self->{TicketID},
                UserID    => $Self->{UserID},
                NewUserID => $Self->{UserID},
            );

            # show lock state
            if ($Success) {
                $Self->{LayoutObject}->Block(
                    Name => 'PropertiesLock',
                    Data => { %Param, TicketID => $Self->{TicketID} },
                );
            }
        }
        else {
            my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Self->{TicketID},
                OwnerID  => $Self->{UserID},
            );
            if ( !$AccessOk ) {
                my $Output = $Self->{LayoutObject}->Header( Value => $Ticket{Number} );
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => 'Sorry, you need to be the owner to do this action!',
                    Comment => 'Please change the owner first.',
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }

            # show back link
            $Self->{LayoutObject}->Block(
                Name => 'TicketBack',
                Data => { %Param, TicketID => $Self->{TicketID} },
            );
        }
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'TicketBack',
            Data => { %Param, %Ticket },
        );
    }

    # get params
    my %GetParam;
    for my $Key (
        qw(
        NewStateID NewPriorityID TimeUnits ArticleTypeID Title Body Subject
        Year Month Day Hour Minute NewOwnerID NewOwnerType OldOwnerID NewResponsibleID
        TypeID ServiceID SLAID Expand
        )
        )
    {
        $GetParam{$Key} = $Self->{ParamObject}->GetParam( Param => $Key );
    }

    # get ticket free text params
    for my $Count ( 1 .. 16 ) {
        my $Key  = 'TicketFreeKey' . $Count;
        my $Text = 'TicketFreeText' . $Count;
        $GetParam{$Key}  = $Self->{ParamObject}->GetParam( Param => $Key );
        $GetParam{$Text} = $Self->{ParamObject}->GetParam( Param => $Text );
    }

    # get ticket free time params
    FREETIMENUMBER:
    for my $FreeTimeNumber ( 1 .. 6 ) {

        # create freetime prefix
        my $FreeTimePrefix = 'TicketFreeTime' . $FreeTimeNumber;

        # get form params
        for my $Type (qw(Used Year Month Day Hour Minute)) {
            $GetParam{ $FreeTimePrefix . $Type } = $Self->{ParamObject}->GetParam(
                Param => $FreeTimePrefix . $Type,
            );
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
        my $TicketFreeTimeString = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Ticket{$FreeTimePrefix},
        );
        my ( $Second, $Minute, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $TicketFreeTimeString,
        );

        $GetParam{ $FreeTimePrefix . 'Used' }   = 1;
        $GetParam{ $FreeTimePrefix . 'Minute' } = $Minute;
        $GetParam{ $FreeTimePrefix . 'Hour' }   = $Hour;
        $GetParam{ $FreeTimePrefix . 'Day' }    = $Day;
        $GetParam{ $FreeTimePrefix . 'Month' }  = $Month;
        $GetParam{ $FreeTimePrefix . 'Year' }   = $Year;
    }

    # get article free text params
    for my $Count ( 1 .. 3 ) {
        my $Key  = 'ArticleFreeKey' . $Count;
        my $Text = 'ArticleFreeText' . $Count;
        $GetParam{$Key}  = $Self->{ParamObject}->GetParam( Param => $Key );
        $GetParam{$Text} = $Self->{ParamObject}->GetParam( Param => $Text );
    }

    # rewrap body if no rich text is used
    if ( $GetParam{Body} && !$Self->{LayoutObject}->{BrowserRichText} ) {
        my $Size = $Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote') || 70;
        $GetParam{Body} =~ s/(^>.+|.{4,$Size})(?:\s|\z)/$1\n/gm;
    }

    if ( $Self->{Subaction} eq 'Store' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # store action
        my %Error;

        # check pending time
        if ( $GetParam{NewStateID} ) {
            my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                ID => $GetParam{NewStateID},
            );

            # check state type
            if ( $StateData{TypeName} =~ /^pending/i ) {

                # check needed stuff
                for (qw(Year Month Day Hour Minute)) {
                    if ( !defined $GetParam{$_} ) {
                        $Error{'Date invalid'} = '* invalid';
                    }
                }

                # check date
                if ( !$Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 ) ) {
                    $Error{'Date invalid'} = '* invalid';
                }
                if (
                    $Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 )
                    < $Self->{TimeObject}->SystemTime()
                    )
                {
                    $Error{'Date invalid'} = '* invalid';
                }
            }
        }
        if ( $Self->{Config}->{Note} ) {

            # check subject
            if ( !$GetParam{Subject} ) {
                $Error{'Subject invalid'} = '* invalid';
            }

            # check body
            if ( !$GetParam{Body} ) {
                $Error{'Body invalid'} = '* invalid';
            }
        }

        # check required FreeTextField (if configured)
        for my $Count ( 1 .. 16 ) {
            next if $Self->{Config}->{TicketFreeText}->{$Count} ne 2;
            next if $GetParam{"TicketFreeText$Count"} ne '';
            $Error{"TicketFreeTextField$Count invalid"} = '* invalid';
        }

        # check if service is selected
        if (
            $Self->{ConfigObject}->Get('Ticket::Service')
            && $GetParam{SLAID}
            && !$GetParam{ServiceID}
            )
        {
            $Error{'Service invalid'} = '* invalid';
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
        }

        # attachment upload
        if ( $Self->{ParamObject}->GetParam( Param => 'AttachmentUpload' ) ) {
            $Error{AttachmentUpload} = 1;
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param  => 'file_upload',
                Source => 'string',
            );
            $Self->{UploadCacheObject}->FormIDAddFile(
                FormID => $Self->{FormID},
                %UploadStuff,
            );
        }

        # get all attachments meta data
        my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # check expand
        if ( $GetParam{Expand} ) {
            %Error = ();
            $Error{Expand} = 1;
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
            }
            my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
                Config => \%TicketFreeText,
                Ticket => \%GetParam,
            );

            # ticket free time
            my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate( Ticket => \%GetParam );

            # article free text
            my %ArticleFreeText;
            for my $Count ( 1 .. 3 ) {
                my $Key  = 'ArticleFreeKey' . $Count;
                my $Text = 'ArticleFreeText' . $Count;
                $ArticleFreeText{$Key} = $Self->{TicketObject}->ArticleFreeTextGet(
                    TicketID => $Self->{TicketID},
                    Type     => $Key,
                    Action   => $Self->{Action},
                    UserID   => $Self->{UserID},
                );
                $ArticleFreeText{$Text} = $Self->{TicketObject}->ArticleFreeTextGet(
                    TicketID => $Self->{TicketID},
                    Type     => $Text,
                    Action   => $Self->{Action},
                    UserID   => $Self->{UserID},
                );
            }
            my %ArticleFreeTextHTML = $Self->{LayoutObject}->TicketArticleFreeText(
                Config  => \%ArticleFreeText,
                Article => \%GetParam,
            );
            my $Output = $Self->{LayoutObject}->Header( Value => $Ticket{TicketNumber} );
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->_Mask(
                Attachments => \@Attachments,
                %Ticket,
                %TicketFreeTextHTML,
                %TicketFreeTimeHTML,
                %ArticleFreeTextHTML,
                %GetParam,
                %Error,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # set new title
        if ( $Self->{Config}->{Title} ) {
            if ( defined $GetParam{Title} ) {
                $Self->{TicketObject}->TicketTitleUpdate(
                    Title    => $GetParam{Title},
                    TicketID => $Self->{TicketID},
                    UserID   => $Self->{UserID},
                );
            }
        }

        # set new type
        if ( $Self->{ConfigObject}->Get('Ticket::Type') && $Self->{Config}->{TicketType} ) {
            if ( $GetParam{TypeID} ) {
                $Self->{TicketObject}->TicketTypeSet(
                    TypeID   => $GetParam{TypeID},
                    TicketID => $Self->{TicketID},
                    UserID   => $Self->{UserID},
                );
            }
        }

        # set new service
        if ( $Self->{ConfigObject}->Get('Ticket::Service') && $Self->{Config}->{Service} ) {
            if ( defined $GetParam{ServiceID} ) {
                $Self->{TicketObject}->TicketServiceSet(
                    ServiceID      => $GetParam{ServiceID},
                    TicketID       => $Self->{TicketID},
                    CustomerUserID => $Ticket{CustomerUserID},
                    UserID         => $Self->{UserID},
                );
            }
            if ( defined $GetParam{SLAID} ) {
                $Self->{TicketObject}->TicketSLASet(
                    SLAID    => $GetParam{SLAID},
                    TicketID => $Self->{TicketID},
                    UserID   => $Self->{UserID},
                );
            }
        }

        # set new owner
        my @NotifyDone;
        if ( $Self->{Config}->{Owner} ) {
            my $BodyText = $Self->{LayoutObject}->RichText2Ascii(
                String => $GetParam{Body} || '',
            );
            if ( $GetParam{NewOwnerType} eq 'Old' && $GetParam{OldOwnerID} ) {
                $Self->{TicketObject}->LockSet(
                    TicketID => $Self->{TicketID},
                    Lock     => 'lock',
                    UserID   => $Self->{UserID},
                );
                my $Success = $Self->{TicketObject}->OwnerSet(
                    TicketID  => $Self->{TicketID},
                    UserID    => $Self->{UserID},
                    NewUserID => $GetParam{OldOwnerID},
                    Comment   => $BodyText,
                );

                # remember to not notify owner twice
                if ( $Success && $Success eq 1 ) {
                    push @NotifyDone, $GetParam{OldOwnerID};
                }
            }
            elsif ( $GetParam{NewOwnerID} ) {
                $Self->{TicketObject}->LockSet(
                    TicketID => $Self->{TicketID},
                    Lock     => 'lock',
                    UserID   => $Self->{UserID},
                );
                my $Success = $Self->{TicketObject}->OwnerSet(
                    TicketID  => $Self->{TicketID},
                    UserID    => $Self->{UserID},
                    NewUserID => $GetParam{NewOwnerID},
                    Comment   => $BodyText,
                );

                # remember to not notify owner twice
                if ( $Success && $Success eq 1 ) {
                    push @NotifyDone, $GetParam{NewOwnerID};
                }
            }
        }

        # set new responsible
        if ( $Self->{Config}->{Responsible} ) {
            if ( $GetParam{NewResponsibleID} ) {
                my $BodyText = $Self->{LayoutObject}->RichText2Ascii(
                    String => $GetParam{Body} || '',
                );
                my $Success = $Self->{TicketObject}->ResponsibleSet(
                    TicketID  => $Self->{TicketID},
                    UserID    => $Self->{UserID},
                    NewUserID => $GetParam{NewResponsibleID},
                    Comment   => $BodyText,
                );

                # remember to not notify responsible twice
                if ( $Success && $Success eq 1 ) {
                    push @NotifyDone, $GetParam{NewResponsibleID};
                }
            }
        }

        # add note
        my $ArticleID = '';
        if ( $Self->{Config}->{Note} ) {
            my $MimeType = 'text/plain';
            if ( $Self->{LayoutObject}->{BrowserRichText} ) {
                $MimeType = 'text/html';

                # verify html document
                $GetParam{Body} = $Self->{LayoutObject}->RichTextDocumentComplete(
                    String => $GetParam{Body},
                );
            }

            my $From = "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>";
            my @NotifyUserIDs = ( @{ $Self->{InformUserID} }, @{ $Self->{InvolvedUserID} } );
            $ArticleID = $Self->{TicketObject}->ArticleCreate(
                TicketID                        => $Self->{TicketID},
                SenderType                      => 'agent',
                From                            => $From,
                MimeType                        => $MimeType,
                Charset                         => $Self->{LayoutObject}->{UserCharset},
                UserID                          => $Self->{UserID},
                HistoryType                     => $Self->{Config}->{HistoryType},
                HistoryComment                  => $Self->{Config}->{HistoryComment},
                ForceNotificationToUserID       => \@NotifyUserIDs,
                ExcludeMuteNotificationToUserID => \@NotifyDone,
                %GetParam,
            );
            if ( !$ArticleID ) {
                return $Self->{LayoutObject}->ErrorScreen();
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

            # get pre loaded attachment
            my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
                FormID => $Self->{FormID},
            );

            # get submit attachment
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param  => 'file_upload',
                Source => 'String',
            );
            if (%UploadStuff) {
                push @Attachments, \%UploadStuff;
            }

            # write attachments
            for my $Attachment (@Attachments) {

                # skip, deleted not used inline images
                my $ContentID = $Attachment->{ContentID};
                if ($ContentID) {
                    my $ContentIDHTMLQuote = $Self->{LayoutObject}->Ascii2Html(
                        Text => $ContentID,
                    );
                    next if $GetParam{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
                }

                # write existing file to backend
                $Self->{TicketObject}->ArticleWriteAttachment(
                    %{$Attachment},
                    ArticleID => $ArticleID,
                    UserID    => $Self->{UserID},
                );
            }

            # remove pre submited attachments
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
            if (
                defined $GetParam{ 'TicketFreeTime' . $Count . 'Year' }
                && defined $GetParam{ 'TicketFreeTime' . $Count . 'Month' }
                && defined $GetParam{ 'TicketFreeTime' . $Count . 'Day' }
                && defined $GetParam{ 'TicketFreeTime' . $Count . 'Hour' }
                && defined $GetParam{ 'TicketFreeTime' . $Count . 'Minute' }
                )
            {

                my %Time;
                $Time{ 'TicketFreeTime' . $Count . 'Year' }    = 0;
                $Time{ 'TicketFreeTime' . $Count . 'Month' }   = 0;
                $Time{ 'TicketFreeTime' . $Count . 'Day' }     = 0;
                $Time{ 'TicketFreeTime' . $Count . 'Hour' }    = 0;
                $Time{ 'TicketFreeTime' . $Count . 'Minute' }  = 0;
                $Time{ 'TicketFreeTime' . $Count . 'Secunde' } = 0;

                # get time stamp based on user time zone
                if ( $GetParam{ 'TicketFreeTime' . $Count . 'Used' } ) {
                    %Time = $Self->{LayoutObject}->TransfromDateSelection(
                        %GetParam,
                        Prefix => 'TicketFreeTime' . $Count
                    );
                }

                # set ticket free time
                $Self->{TicketObject}->TicketFreeTimeSet(
                    %Time,
                    Prefix   => 'TicketFreeTime',
                    TicketID => $Self->{TicketID},
                    Counter  => $Count,
                    UserID   => $Self->{UserID},
                );
            }
        }

        # set article free text
        for my $Count ( 1 .. 3 ) {
            my $Key  = 'ArticleFreeKey' . $Count;
            my $Text = 'ArticleFreeText' . $Count;
            next if !defined $GetParam{$Key};
            $Self->{TicketObject}->ArticleFreeTextSet(
                TicketID  => $Self->{TicketID},
                ArticleID => $ArticleID,
                Key       => $GetParam{$Key},
                Value     => $GetParam{$Text},
                Counter   => $Count,
                UserID    => $Self->{UserID},
            );
        }

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

            # set unlock on close state
            if ( $StateData{TypeName} =~ /^close/i ) {
                $Self->{TicketObject}->LockSet(
                    TicketID => $Self->{TicketID},
                    Lock     => 'unlock',
                    UserID   => $Self->{UserID},
                );
            }

            # set pending time on pendig state
            elsif ( $StateData{TypeName} =~ /^pending/i ) {

                # get time stamp based on user time zone
                my %Time = $Self->{LayoutObject}->TransfromDateSelection(
                    %GetParam,
                );

                # set pending time
                $Self->{TicketObject}->TicketPendingTimeSet(
                    UserID   => $Self->{UserID},
                    TicketID => $Self->{TicketID},
                    %Time,
                );
            }

            # redirect to last screen overview on closed tickets
            if ( $StateData{TypeName} =~ /^close/i ) {
                return $Self->{LayoutObject}->Redirect( OP => $Self->{LastScreenOverview} );
            }
        }

        # redirect
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=AgentTicketZoom;TicketID=$Self->{TicketID};ArticleID=$ArticleID"
        );
    }
    else {

        # fillup configured default vars
        if ( !defined $GetParam{Body} && $Self->{Config}->{Body} ) {
            $GetParam{Body} = $Self->{LayoutObject}->Output(
                Template => $Self->{Config}->{Body},
            );

            # make sure body is rich text
            if ( $Self->{LayoutObject}->{BrowserRichText} ) {
                $GetParam{Body} = $Self->{LayoutObject}->Ascii2RichText(
                    String => $GetParam{Body},
                );
            }
        }
        if ( !defined $GetParam{Subject} && $Self->{Config}->{Subject} ) {
            $GetParam{Subject} = $Self->{LayoutObject}->Output(
                Template => $Self->{Config}->{Subject},
            );
        }

        # get free text config options
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
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Ticket => \%Ticket,
            Config => \%TicketFreeText,
        );

        # ticket free time
        my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate( Ticket => \%GetParam );

        # get default selections
        my %ArticleFreeDefault;
        for my $Count ( 1 .. 3 ) {
            my $Key  = 'ArticleFreeKey' . $Count;
            my $Text = 'ArticleFreeText' . $Count;
            $ArticleFreeDefault{$Key} = $GetParam{$Key}
                || $Self->{ConfigObject}->Get( $Key . '::DefaultSelection' );
            $ArticleFreeDefault{$Text} = $GetParam{$Text}
                || $Self->{ConfigObject}->Get( $Text . '::DefaultSelection' );
        }

        # get article free text config options
        my %ArticleFreeText;
        for my $Count ( 1 .. 3 ) {
            my $Key  = 'ArticleFreeKey' . $Count;
            my $Text = 'ArticleFreeText' . $Count;
            $ArticleFreeText{$Key} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => $Key,
                Action   => $Self->{Action},
                UserID   => $Self->{UserID},
            );
            $ArticleFreeText{$Text} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID => $Self->{TicketID},
                Type     => $Text,
                Action   => $Self->{Action},
                UserID   => $Self->{UserID},
            );
        }
        my %ArticleFreeTextHTML = $Self->{LayoutObject}->TicketArticleFreeText(
            Config  => \%ArticleFreeText,
            Article => \%ArticleFreeDefault,
        );

        # print form ...
        my $Output = $Self->{LayoutObject}->Header( Value => $Ticket{TicketNumber} );
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask(
            %GetParam,
            %Ticket,
            %TicketFreeTextHTML,
            %TicketFreeTimeHTML,
            %ArticleFreeTextHTML,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    # get list type
    my $TreeView = 0;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

    if ( $Self->{Config}->{Title} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Title',
            Data => \%Param,
        );
    }

    # types
    if ( $Self->{ConfigObject}->Get('Ticket::Type') && $Self->{Config}->{TicketType} ) {
        my %Type = $Self->{TicketObject}->TicketTypeList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
        $Param{TypeStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%Type,
            Name         => 'TypeID',
            SelectedID   => $Param{TypeID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            OnChange =>
                "document.compose.Expand.value='3'; document.compose.submit(); return false;",
        );
        $Self->{LayoutObject}->Block(
            Name => 'Type',
            Data => {%Param},
        );
    }

    # services
    if ( $Self->{ConfigObject}->Get('Ticket::Service') && $Self->{Config}->{Service} ) {
        my %Service = ( '', '-' );
        if ( $Ticket{CustomerUserID} ) {
            %Service = $Self->{TicketObject}->TicketServiceList(
                %Param,
                Action         => $Self->{Action},
                CustomerUserID => $Ticket{CustomerUserID},
                UserID         => $Self->{UserID},
            );
        }
        $Param{ServiceStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%Service,
            Name         => 'ServiceID',
            SelectedID   => $Param{ServiceID},
            PossibleNone => 1,
            TreeView     => $TreeView,
            Sort         => 'TreeView',
            Translation  => 0,
            Max          => 200,
            OnChange =>
                "document.compose.Expand.value='3'; document.compose.submit(); return false;",
        );
        $Self->{LayoutObject}->Block(
            Name => 'Service',
            Data => {%Param},
        );
        my %SLA;
        if ( $Param{ServiceID} ) {
            %SLA = $Self->{TicketObject}->TicketSLAList(
                %Param,
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
        }
        $Param{SLAStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%SLA,
            Name         => 'SLAID',
            SelectedID   => $Param{SLAID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            Max          => 200,
            OnChange =>
                "document.compose.Expand.value='3'; document.compose.submit(); return false;",
        );
        $Self->{LayoutObject}->Block(
            Name => 'SLA',
            Data => {%Param},
        );
    }
    if ( $Self->{Config}->{Owner} ) {

        # get user of own groups
        my %ShownUsers;
        my %AllGroupsMembers = $Self->{UserObject}->UserList(
            Type  => 'Long',
            Valid => 1,
        );
        if ( $Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone') ) {
            %ShownUsers = %AllGroupsMembers;
        }
        else {
            my $GID = $Self->{QueueObject}->GetQueueGroupID( QueueID => $Ticket{QueueID} );
            my %MemberList = $Self->{GroupObject}->GroupMemberList(
                GroupID => $GID,
                Type    => 'owner',
                Result  => 'HASH',
                Cached  => 1,
            );
            for my $UserID ( keys %MemberList ) {
                $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
            }
        }

        # get old owner
        my @OldUserInfo = $Self->{TicketObject}->OwnerList( TicketID => $Self->{TicketID} );
        $Param{OwnerStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => \%ShownUsers,
            SelectedID => $Param{NewOwnerID},
            Name       => 'NewOwnerID',
            Size       => 10,
            OnClick    => "change_selected(0)",
        );
        my %UserHash;
        if (@OldUserInfo) {
            my $Counter = 1;
            for my $User ( reverse @OldUserInfo ) {
                next if $UserHash{ $User->{UserID} };
                $UserHash{ $User->{UserID} } = "$Counter: $User->{UserLastname} "
                    . "$User->{UserFirstname} ($User->{UserLogin})";
                $Counter++;
            }
        }
        if ( !%UserHash ) {
            $UserHash{''} = '-';
        }
        my $OldOwnerSelectedID = '';
        if ( $Param{OldOwnerID} ) {
            $OldOwnerSelectedID = $Param{OldOwnerID};
        }
        elsif ( $OldUserInfo[0]->{UserID} ) {
            $OldOwnerSelectedID = $OldUserInfo[0]->{UserID} . '1';
        }

        # build string
        $Param{OldOwnerStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => \%UserHash,
            SelectedID => $OldOwnerSelectedID,
            Name       => 'OldOwnerID',
            OnClick    => "change_selected(2)",
        );
        if ( $Param{NewOwnerType} && $Param{NewOwnerType} eq 'Old' ) {
            $Param{'NewOwnerType::Old'} = 'checked="checked"';
        }
        else {
            $Param{'NewOwnerType::New'} = 'checked="checked"';
        }
        $Self->{LayoutObject}->Block(
            Name => 'OwnerJs',
            Data => \%Param,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Owner',
            Data => \%Param,
        );
    }
    if ( $Self->{Config}->{Responsible} ) {

        # get user of own groups
        my %ShownUsers;
        my %AllGroupsMembers = $Self->{UserObject}->UserList(
            Type  => 'Long',
            Valid => 1,
        );
        if ( $Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone') ) {
            %ShownUsers = %AllGroupsMembers;
        }
        else {
            my $GID = $Self->{QueueObject}->GetQueueGroupID( QueueID => $Ticket{QueueID} );
            my %MemberList = $Self->{GroupObject}->GroupMemberList(
                GroupID => $GID,
                Type    => 'responsible',
                Result  => 'HASH',
                Cached  => 1,
            );
            for my $UserID ( keys %MemberList ) {
                $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
            }
        }

        # get responsible
        $Param{ResponsibleStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => \%ShownUsers,
            SelectedID => $Param{NewResponsibleID} || $Ticket{ResponsibleID},
            Name       => 'NewResponsibleID',
            Size       => 10,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Responsible',
            Data => \%Param,
        );
    }
    if ( $Self->{Config}->{State} ) {
        my %State;
        my %StateList = $Self->{TicketObject}->StateList(
            Action   => $Self->{Action},
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID},
        );
        if ( !$Self->{Config}->{StateDefault} ) {
            $StateList{''} = '-';
        }
        if ( !$Param{NewStateID} ) {
            if ( $Self->{Config}->{StateDefault} ) {
                $State{Selected} = $Self->{Config}->{StateDefault};
            }
        }
        else {
            $State{SelectedID} = $Param{NewStateID};
        }

        # build next states string
        $Param{StateStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => \%StateList,
            Name => 'NewStateID',
            %State,
        );
        $Self->{LayoutObject}->Block(
            Name => 'State',
            Data => \%Param,
        );
        for my $StateID ( sort keys %StateList ) {
            next if !$StateID;
            my %StateData = $Self->{TicketObject}->{StateObject}->StateGet( ID => $StateID );
            if ( $StateData{TypeName} =~ /pending/i ) {
                $Param{DateString} = $Self->{LayoutObject}->BuildDateSelection(
                    Format           => 'DateInputFormatLong',
                    YearPeriodPast   => 0,
                    YearPeriodFuture => 5,
                    DiffTime => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime')
                        || 0,
                    %Param,
                );
                $Self->{LayoutObject}->Block(
                    Name => 'StatePending',
                    Data => \%Param,
                );
                last;
            }
        }
    }

    # get priority
    if ( $Self->{Config}->{Priority} ) {
        my %Priority;
        my %PriorityList = $Self->{TicketObject}->PriorityList(
            UserID   => $Self->{UserID},
            TicketID => $Self->{TicketID},
        );
        if ( !$Self->{Config}->{PriorityDefault} ) {
            $PriorityList{''} = '-';
        }
        if ( !$Param{NewPriorityID} ) {
            if ( $Self->{Config}->{PriorityDefault} ) {
                $Priority{Selected} = $Self->{Config}->{PriorityDefault};
            }
        }
        else {
            $Priority{SelectedID} = $Param{NewPriorityID};
        }
        $Param{PriorityStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => \%PriorityList,
            Name => 'NewPriorityID',
            %Priority,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Priority',
            Data => \%Param,
        );
    }
    if ( $Self->{Config}->{Note} ) {
        $Self->{LayoutObject}->Block(
            Name => 'NoteJs',
            Data => {%Param},
        );
        $Self->{LayoutObject}->Block(
            Name => 'Note',
            Data => {%Param},
        );

        # add rich text editor
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            $Self->{LayoutObject}->Block(
                Name => 'RichText',
                Data => \%Param,
            );
        }

        # agent list
        if ( $Self->{Config}->{InformAgent} ) {
            my %ShownUsers;
            my %AllGroupsMembers = $Self->{UserObject}->UserList(
                Type  => 'Long',
                Valid => 1,
            );
            my $GID = $Self->{QueueObject}->GetQueueGroupID( QueueID => $Ticket{QueueID} );
            my %MemberList = $Self->{GroupObject}->GroupMemberList(
                GroupID => $GID,
                Type    => 'note',
                Result  => 'HASH',
                Cached  => 1,
            );
            for my $UserID ( keys %MemberList ) {
                $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
            }
            $Param{OptionStrg} = $Self->{LayoutObject}->BuildSelection(
                Data       => \%ShownUsers,
                SelectedID => $Self->{InformUserID},
                Name       => 'InformUserID',
                Multiple   => 1,
                Size       => 3,
            );
            $Self->{LayoutObject}->Block(
                Name => 'InformAgent',
                Data => \%Param,
            );
        }

        # get involved
        if ( $Self->{Config}->{InvolvedAgent} ) {
            my @UserIDs = $Self->{TicketObject}->InvolvedAgents( TicketID => $Self->{TicketID} );
            my %UserHash;
            my $Counter = 0;
            for my $User ( reverse @UserIDs ) {
                $Counter++;
                next if $UserHash{ $User->{UserID} };
                $UserHash{ $User->{UserID} } = "$Counter: $User->{UserLastname} "
                    . "$User->{UserFirstname} ($User->{UserLogin})";
            }
            $Param{InvolvedAgentStrg} = $Self->{LayoutObject}->BuildSelection(
                Data       => \%UserHash,
                SelectedID => $Self->{InvolvedUserID},
                Name       => 'InvolvedUserID',
                Multiple   => 1,
                Size       => 3,
            );
            $Self->{LayoutObject}->Block(
                Name => 'InvolvedAgent',
                Data => \%Param,
            );
        }

        # show spell check
        if ( $Self->{LayoutObject}->{BrowserSpellChecker} ) {
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

        # build ArticleTypeID string
        my %ArticleType;
        if ( !$Param{ArticleTypeID} ) {
            $ArticleType{Selected} = $Self->{Config}->{ArticleTypeDefault};
        }
        else {
            $ArticleType{SelectedID} = $Param{ArticleTypeID};
        }

        # get possible notes
        my %DefaultNoteTypes = %{ $Self->{Config}->{ArticleTypes} };
        my %NoteTypes = $Self->{TicketObject}->ArticleTypeList( Result => 'HASH' );
        for ( keys %NoteTypes ) {
            if ( !$DefaultNoteTypes{ $NoteTypes{$_} } ) {
                delete $NoteTypes{$_};
            }
        }
        $Param{ArticleTypeStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => \%NoteTypes,
            Name => 'ArticleTypeID',
            %ArticleType,
        );
        $Self->{LayoutObject}->Block(
            Name => 'ArticleType',
            Data => \%Param,
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
    }

    # ticket free text
    for my $Count ( 1 .. 16 ) {
        next if !$Self->{Config}->{TicketFreeText}->{$Count};
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
    for my $Count ( 1 .. 6 ) {
        next if !$Self->{Config}->{TicketFreeTime}->{$Count};
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

    # article free text
    for my $Count ( 1 .. 3 ) {
        next if !$Self->{Config}->{ArticleFreeText}->{$Count};
        $Self->{LayoutObject}->Block(
            Name => 'ArticleFreeText',
            Data => {
                ArticleFreeKeyField  => $Param{ 'ArticleFreeKeyField' . $Count },
                ArticleFreeTextField => $Param{ 'ArticleFreeTextField' . $Count },
                Count                => $Count,
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'ArticleFreeText' . $Count,
            Data => { %Param, Count => $Count },
        );
    }

    # java script check for required free text fields by form submit
    for my $Key ( keys %{ $Self->{Config}->{TicketFreeText} } ) {
        next if $Self->{Config}->{TicketFreeText}->{$Key} != 2;
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeTextCheckJs',
            Data => {
                TicketFreeTextField => "TicketFreeText$Key",
                TicketFreeKeyField  => "TicketFreeKey$Key",
            },
        );
    }

    # java script check for required free time fields by form submit
    for my $Key ( keys %{ $Self->{Config}->{TicketFreeTime} } ) {
        next if $Self->{Config}->{TicketFreeTime}->{$Key} != 2;
        $Self->{LayoutObject}->Block(
            Name => 'TicketFreeTimeCheckJs',
            Data => {
                TicketFreeTimeCheck => 'TicketFreeTime' . $Key . 'Used',
                TicketFreeTimeField => 'TicketFreeTime' . $Key,
                TicketFreeTimeKey   => $Self->{ConfigObject}->Get( 'TicketFreeTimeKey' . $Key ),
            },
        );
    }

    # get output back
    return $Self->{LayoutObject}->Output( TemplateFile => 'AgentTicketNote', Data => \%Param );
}

1;
