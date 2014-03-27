# --
# Kernel/Modules/AgentTicketCompose.pm - to compose and send a message
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: AgentTicketCompose.pm,v 1.124.2.10 2012-05-24 23:18:03 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketCompose;

use strict;
use warnings;

use Kernel::System::CheckItem;
use Kernel::System::StdAttachment;
use Kernel::System::State;
use Kernel::System::CustomerUser;
use Kernel::System::Web::UploadCache;
use Kernel::System::SystemAddress;
use Kernel::System::TemplateGenerator;
use Mail::Address;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.124.2.10 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # check all needed objects
    for (qw(TicketObject ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # some new objects
    $Self->{CustomerUserObject}  = Kernel::System::CustomerUser->new(%Param);
    $Self->{CheckItemObject}     = Kernel::System::CheckItem->new(%Param);
    $Self->{StdAttachmentObject} = Kernel::System::StdAttachment->new(%Param);
    $Self->{StateObject}         = Kernel::System::State->new(%Param);
    $Self->{UploadCacheObject}   = Kernel::System::Web::UploadCache->new(%Param);
    $Self->{SystemAddress}       = Kernel::System::SystemAddress->new(%Param);

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
    if ( !$Self->{TicketID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No TicketID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{TicketObject}->TicketPermission(
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

    # get lock state
    my $TicketBackType = 'TicketBack';
    if ( $Self->{Config}->{RequiredLock} ) {
        if ( !$Self->{TicketObject}->TicketLockGet( TicketID => $Self->{TicketID} ) ) {
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID}
            );
            my $Owner = $Self->{TicketObject}->TicketOwnerSet(
                TicketID  => $Self->{TicketID},
                UserID    => $Self->{UserID},
                NewUserID => $Self->{UserID},
            );

            # show lock state
            if ( !$Owner ) {
                return $Self->{LayoutObject}->FatalError();
            }
            $TicketBackType .= 'Undo';
        }
        else {
            my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Self->{TicketID},
                OwnerID  => $Self->{UserID},
            );
            if ( !$AccessOk ) {
                my $Output = $Self->{LayoutObject}->Header(
                    Value => $Ticket{Number},
                    Type  => 'Small',
                );
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => 'Sorry, you need to be the owner to do this action!',
                    Comment => 'Please change the owner first.',
                );
                $Output .= $Self->{LayoutObject}->Footer(
                    Type => 'Small',
                );
                return $Output;
            }
        }
    }

    # get params
    my %GetParam;
    for (
        qw(
        From To Cc Bcc Subject Body InReplyTo References ResponseID ReplyArticleID StateID
        ArticleID TimeUnits Year Month Day Hour Minute FormID ReplyAll
        )
        )
    {
        $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
    }

    # get ticket free text params
    for my $Count ( 1 .. 16 ) {
        my $Key  = 'TicketFreeKey' . $Count;
        my $Text = 'TicketFreeText' . $Count;
        $GetParam{$Key}  = $Self->{ParamObject}->GetParam( Param => $Key );
        $GetParam{$Text} = $Self->{ParamObject}->GetParam( Param => $Text );
    }

    # get ticket free time params
    for my $Count ( 1 .. 6 ) {
        for my $Type (qw(Used Year Month Day Hour Minute)) {
            $GetParam{ 'TicketFreeTime' . $Count . $Type } = $Self->{ParamObject}->GetParam(
                Param => 'TicketFreeTime' . $Count . $Type,
            );
        }
        $GetParam{ 'TicketFreeTime' . $Count . 'Optional' }
            = $Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $Count ) || 0;
        if ( !$Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $Count ) ) {
            $GetParam{ 'TicketFreeTime' . $Count . 'Used' } = 1;
        }

        if ( $Self->{Config}->{TicketFreeTime}->{$Count} == 2 ) {
            $GetParam{ 'TicketFreeTime' . $Count . 'Required' } = 1;
        }
    }

    # get article free text params
    for my $Count ( 1 .. 3 ) {
        my $Key  = 'ArticleFreeKey' . $Count;
        my $Text = 'ArticleFreeText' . $Count;
        $GetParam{$Key}  = $Self->{ParamObject}->GetParam( Param => $Key );
        $GetParam{$Text} = $Self->{ParamObject}->GetParam( Param => $Text );
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

    # send email
    if ( $Self->{Subaction} eq 'SendEmail' ) {

        # get valid state id
        if ( !$GetParam{StateID} ) {
            my %Ticket = $Self->{TicketObject}->TicketGet(
                TicketID => $Self->{TicketID},
                UserID   => 1,
            );
            $GetParam{StateID} = $Ticket{StateID};
        }

        my %StateData = $Self->{TicketObject}->{StateObject}->StateGet( ID => $GetParam{StateID} );

        my %Error;

        # If is an action about attachments
        my $IsUpload = 0;

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

        # get all attachments meta data
        my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # check pending date
        if ( $StateData{TypeName} && $StateData{TypeName} =~ /^pending/i ) {
            if ( !$Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 ) ) {
                if ( !$IsUpload ) {
                    $Error{DateInvalid} = 'ServerError';
                }
            }
            if (
                $Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 )
                < $Self->{TimeObject}->SystemTime()
                )
            {
                if ( !$IsUpload ) {
                    $Error{DateInvalid} = 'ServerError';
                }
            }
        }

        # check some values
        for my $Line (qw(To Cc Bcc)) {
            next if !$GetParam{$Line};
            for my $Email ( Mail::Address->parse( $GetParam{$Line} ) ) {
                if ( !$Self->{CheckItemObject}->CheckEmail( Address => $Email->address() ) ) {
                    if ( $IsUpload == 0 ) {
                        $Error{ $Line . 'Invalid' } = 'ServerError';
                    }
                }
            }
        }

        # check subject
        if ( !$IsUpload && !$GetParam{Subject} ) {
            $Error{SubjectInvalid} = ' ServerError';
        }

        # check body
        if ( !$IsUpload && !$GetParam{Body} ) {
            $Error{BodyInvalid} = ' ServerError';
        }

        # check time units
        if (
            $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime')
            && $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
            && $GetParam{TimeUnits} eq ''
            )
        {
            if ( !$IsUpload ) {
                $Error{TimeUnitsInvalid} = 'ServerError';
            }
        }

        # prepare subject
        my $Tn = $Self->{TicketObject}->TicketNumberLookup( TicketID => $Self->{TicketID} );
        $GetParam{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
            TicketNumber => $Tn,
            Subject => $GetParam{Subject} || '',
        );

        my %ArticleParam;

        # run compose modules
        if ( ref $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') eq 'HASH' )
        {
            my %Jobs = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') };
            for my $Job ( sort keys %Jobs ) {

                # load module
                if ( !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} ) ) {
                    return $Self->{LayoutObject}->FatalError();
                }
                my $Object = $Jobs{$Job}->{Module}->new( %{$Self}, Debug => $Self->{Debug} );

                # get params
                for ( $Object->Option( %GetParam, Config => $Jobs{$Job} ) ) {
                    $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
                }

                # run module
                $Object->Run( %GetParam, Config => $Jobs{$Job} );

                # ticket params
                %ArticleParam = (
                    %ArticleParam,
                    $Object->ArticleOption( %GetParam, Config => $Jobs{$Job} ),
                );

                # get errors
                %Error = (
                    %Error,
                    $Object->Error( %GetParam, Config => $Jobs{$Job} ),
                );
            }
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

            # If Key has value 2, this means that the freetextfield is required
            if ( $Self->{Config}->{TicketFreeText}->{$Count} == 2 ) {
                $TicketFreeText{Required}->{$Count} = 1;
            }

            # check required FreeTextField (if configured)
            if (
                $Self->{Config}->{TicketFreeText}->{$Count} == 2
                && $GetParam{$Text} eq ''
                && $IsUpload == 0
                )
            {
                $TicketFreeText{Error}->{$Count} = 1;
                $Error{$Text} = 'ServerError';
            }
        }

        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => \%GetParam,
        );

        # ticket free time
        my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate(
            %Param,
            Ticket => \%GetParam,
        );

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

            # If Key has value 2, this means that the field is required
            if ( $Self->{Config}->{ArticleFreeText}->{$Count} == 2 ) {
                $ArticleFreeText{Required}->{$Count} = 1;
            }

            # check required ArticleTextField (if configured)
            if (
                $Self->{Config}->{ArticleFreeText}->{$Count} == 2
                && $GetParam{$Text} eq ''
                && $IsUpload == 0
                )
            {
                $ArticleFreeText{Error}->{$Count} = 1;
                $Error{$Text} = 'ServerError';
            }
        }

        my %ArticleFreeTextHTML = $Self->{LayoutObject}->TicketArticleFreeText(
            Config  => \%ArticleFreeText,
            Article => \%GetParam,
        );

        # check if there is an error
        if (%Error) {

            my $Output = $Self->{LayoutObject}->Header(
                Value => $Ticket{TicketNumber},
                Type  => 'Small',
            );
            $GetParam{StandardResponse} = $GetParam{Body};
            $Output .= $Self->_Mask(
                TicketID       => $Self->{TicketID},
                NextStates     => $Self->_GetNextStates(),
                ResponseFormat => $Self->{LayoutObject}->Ascii2Html( Text => $GetParam{Body} ),
                Errors         => \%Error,
                Attachments    => \@Attachments,
                GetParam       => \%GetParam,
                TicketBackType => $TicketBackType,
                %Ticket,
                %TicketFreeTextHTML,
                %TicketFreeTimeHTML,
                %ArticleFreeTextHTML,
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Footer(
                Type => 'Small',
            );
            return $Output;
        }

        # replace <OTRS_TICKET_STATE> with next ticket state name
        if ( $StateData{Name} ) {
            $GetParam{Body} =~ s/<OTRS_TICKET_STATE>/$StateData{Name}/g;
            $GetParam{Body} =~ s/&lt;OTRS_TICKET_STATE&gt;/$StateData{Name}/g;
        }

        # get pre loaded attachments
        my @AttachmentData = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );

        # get submit attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'FileUpload',
            Source => 'String',
        );
        if (%UploadStuff) {
            push @AttachmentData, \%UploadStuff;
        }

        # get recipients
        my $Recipients = '';
        for my $Line (qw(To Cc Bcc)) {
            if ( $GetParam{$Line} ) {
                if ($Recipients) {
                    $Recipients .= ',';
                }
                $Recipients .= $GetParam{$Line};
            }
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

                    # workaround for link encode of rich text editor, see bug#5053
                    my $ContentIDLinkEncode = $Self->{LayoutObject}->LinkEncode($ContentID);
                    $GetParam{Body} =~ s/(ContentID=)$ContentIDLinkEncode/$1$ContentID/g;

                    # ignore attachment if not linked in body
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

        # send email
        my $ArticleID = $Self->{TicketObject}->ArticleSend(
            ArticleType    => 'email-external',
            SenderType     => 'agent',
            TicketID       => $Self->{TicketID},
            HistoryType    => 'SendAnswer',
            HistoryComment => "\%\%$Recipients",
            From           => $GetParam{From},
            To             => $GetParam{To},
            Cc             => $GetParam{Cc},
            Bcc            => $GetParam{Bcc},
            Subject        => $GetParam{Subject},
            UserID         => $Self->{UserID},
            Body           => $GetParam{Body},
            InReplyTo      => $GetParam{InReplyTo},
            References     => $GetParam{References},
            Charset        => $Self->{LayoutObject}->{UserCharset},
            MimeType       => $MimeType,
            Attachment     => \@AttachmentData,
            %ArticleParam,
        );

        # error page
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

        # set ticket free text
        for my $Count ( 1 .. 16 ) {
            my $Key  = 'TicketFreeKey' . $Count;
            my $Text = 'TicketFreeText' . $Count;
            if ( defined $GetParam{$Key} ) {
                $Self->{TicketObject}->TicketFreeTextSet(
                    Key      => $GetParam{$Key},
                    Value    => $GetParam{$Text},
                    Counter  => $Count,
                    TicketID => $Self->{TicketID},
                    UserID   => $Self->{UserID},
                );
            }
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

        # set article free text
        for my $Count ( 1 .. 3 ) {
            my $Key  = 'ArticleFreeKey' . $Count;
            my $Text = 'ArticleFreeText' . $Count;
            if ( defined $GetParam{$Key} ) {
                $Self->{TicketObject}->ArticleFreeTextSet(
                    TicketID  => $Self->{TicketID},
                    ArticleID => $ArticleID,
                    Key       => $GetParam{$Key},
                    Value     => $GetParam{$Text},
                    Counter   => $Count,
                    UserID    => $Self->{UserID},
                );
            }
        }

        # set state
        $Self->{TicketObject}->TicketStateSet(
            TicketID  => $Self->{TicketID},
            ArticleID => $ArticleID,
            StateID   => $GetParam{StateID},
            UserID    => $Self->{UserID},
        );

        # should I set an unlock?
        if ( $StateData{TypeName} =~ /^close/i ) {
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'unlock',
                UserID   => $Self->{UserID},
            );
        }

        # set pending time
        elsif ( $StateData{TypeName} =~ /^pending/i ) {
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

        # log use response id and reply article id (useful for response diagnostics)
        $Self->{TicketObject}->HistoryAdd(
            Name => "ResponseTemplate ($GetParam{ResponseID}/$GetParam{ReplyArticleID}/$ArticleID)",
            HistoryType  => 'Misc',
            TicketID     => $Self->{TicketID},
            CreateUserID => $Self->{UserID},
        );

        # remove pre submited attachments
        $Self->{UploadCacheObject}->FormIDRemove( FormID => $GetParam{FormID} );

        # redirect
        if ( $StateData{TypeName} =~ /^close/i ) {
            return $Self->{LayoutObject}->PopupClose(
                URL => ( $Self->{LastScreenOverview} || 'Action=AgentDashboard' ),
            );
        }

        # load new URL in parent window and close popup
        return $Self->{LayoutObject}->PopupClose(
            URL => "Action=AgentTicketZoom;TicketID=$Self->{TicketID};ArticleID=$ArticleID",
        );
    }
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {

        my @ExtendedData;

        # run compose modules
        if ( ref $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') eq 'HASH' ) {
            my %Jobs = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') };
            for my $Job ( sort keys %Jobs ) {

                # load module
                next if !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} );

                my $Object = $Jobs{$Job}->{Module}->new( %{$Self}, Debug => $Self->{Debug}, );

                # get params
                for my $Parameter ( $Object->Option( %GetParam, Config => $Jobs{$Job} ) ) {
                    $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );
                }

                # run module
                my %Data = $Object->Data( %GetParam, Config => $Jobs{$Job} );

                my $Key = $Object->Option( %GetParam, Config => $Jobs{$Job} );
                if ($Key) {
                    push(
                        @ExtendedData,
                        {
                            Name        => $Key,
                            Data        => \%Data,
                            SelectedID  => $GetParam{$Key},
                            Translation => 1,
                            Max         => 100,
                        }
                    );
                }
            }
        }
        my $JSON = $Self->{LayoutObject}->BuildSelectionJSON(
            [
                @ExtendedData,
            ],
        );
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    else {
        my $Output = $Self->{LayoutObject}->Header(
            Value => $Ticket{TicketNumber},
            Type  => 'Small',
        );

        # add std. attachments to email
        if ( $GetParam{ResponseID} ) {
            my %AllStdAttachments = $Self->{StdAttachmentObject}->StdAttachmentsByResponseID(
                ID => $GetParam{ResponseID},
            );
            for ( sort keys %AllStdAttachments ) {
                my %Data = $Self->{StdAttachmentObject}->StdAttachmentGet( ID => $_ );
                $Self->{UploadCacheObject}->FormIDAddFile(
                    FormID => $Self->{FormID},
                    %Data,
                );
            }
        }

        # get all attachments meta data
        my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # get last customer article or selecte article ...
        my %Data;
        if ( $GetParam{ArticleID} ) {
            %Data = $Self->{TicketObject}->ArticleGet( ArticleID => $GetParam{ArticleID} );
        }
        else {
            %Data = $Self->{TicketObject}->ArticleLastCustomerArticle(
                TicketID => $Self->{TicketID}
            );
        }

        # check article type and replace To with From (in case)
        if ( $Data{SenderType} !~ /customer/ ) {
            my $To   = $Data{To};
            my $From = $Data{From};

            # set OrigFrom for correct email quoteing (xxxx wrote)
            $Data{OrigFrom} = $Data{From};

            # replace From/To, To/From because sender is agent
            $Data{From}    = $To;
            $Data{To}      = $Data{From};
            $Data{ReplyTo} = '';
        }
        else {

            # set OrigFrom for correct email quoteing (xxxx wrote)
            $Data{OrigFrom} = $Data{From};
        }

        # build OrigFromName (to only use the realname)
        $Data{OrigFromName} = $Data{OrigFrom};
        $Data{OrigFromName} =~ s/<.*>|\(.*\)|\"|;|,//g;
        $Data{OrigFromName} =~ s/( $)|(  $)//g;

        # get customer data
        my %Customer;
        if ( $Ticket{CustomerUserID} ) {
            %Customer = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $Ticket{CustomerUserID}
            );
        }

        # get article to quote
        $Data{Body} = $Self->{LayoutObject}->ArticleQuote(
            TicketID          => $Self->{TicketID},
            ArticleID         => $Data{ArticleID},
            FormID            => $Self->{FormID},
            UploadCacheObject => $Self->{UploadCacheObject},
        );

        if ( $Self->{LayoutObject}->{BrowserRichText} ) {

            # prepare body, subject, ReplyTo ...
            # rewrap body if exists
            if ( $Data{Body} ) {
                $Data{Body} =~ s/\t/ /g;
                my $Quote = $Self->{LayoutObject}->Ascii2Html(
                    Text => $Self->{ConfigObject}->Get('Ticket::Frontend::Quote') || '',
                    HTMLResultMode => 1,
                );
                if ($Quote) {

                    # quote text
                    $Data{Body} = "<blockquote type=\"cite\">$Data{Body}</blockquote>\n";

                    # cleanup not compat. tags
                    $Data{Body} = $Self->{LayoutObject}->RichTextDocumentCleanup(
                        String => $Data{Body},
                    );

                }
                else {
                    $Data{Body} = "<br/>" . $Data{Body};

                    if ( $Data{Created} ) {
                        $Data{Body} = $Self->{LayoutObject}->{LanguageObject}->Get('Date') .
                            ": $Data{Created}<br/>" . $Data{Body};
                    }

                    for (qw(Subject ReplyTo Reply-To Cc To From)) {
                        if ( $Data{$_} ) {
                            $Data{Body} = $Self->{LayoutObject}->{LanguageObject}->Get($_) .
                                ": $Data{$_}<br/>" . $Data{Body};
                        }
                    }

                    my $From = $Self->{LayoutObject}->Ascii2RichText(
                        String => $Data{From},
                    );

                    my $MessageFrom = $Self->{LayoutObject}->{LanguageObject}->Get('Message from');
                    my $EndMessage  = $Self->{LayoutObject}->{LanguageObject}->Get('End message');

                    $Data{Body} = "<br/>---- $MessageFrom $From ---<br/><br/>" . $Data{Body};
                    $Data{Body} .= "<br/>---- $EndMessage ---<br/>";
                }
            }
        }
        else {

            # prepare body, subject, ReplyTo ...
            # rewrap body if exists
            if ( $Data{Body} ) {
                $Data{Body} =~ s/\t/ /g;
                my $Quote = $Self->{ConfigObject}->Get('Ticket::Frontend::Quote');
                if ($Quote) {
                    $Data{Body} =~ s/\n/\n$Quote /g;
                    $Data{Body} = "\n$Quote " . $Data{Body};
                }
                else {
                    $Data{Body} = "\n" . $Data{Body};
                    if ( $Data{Created} ) {
                        $Data{Body} = $Self->{LayoutObject}->{LanguageObject}->Get('Date') .
                            ": $Data{Created}\n" . $Data{Body};
                    }

                    for (qw(Subject ReplyTo Reply-To Cc To From)) {
                        if ( $Data{$_} ) {
                            $Data{Body} = $Self->{LayoutObject}->{LanguageObject}->Get($_) .
                                ": $Data{$_}\n" . $Data{Body};
                        }
                    }

                    my $MessageFrom = $Self->{LayoutObject}->{LanguageObject}->Get('Message from');
                    my $EndMessage  = $Self->{LayoutObject}->{LanguageObject}->Get('End message');

                    $Data{Body} = "\n---- $MessageFrom $Data{From} ---\n\n" . $Data{Body};
                    $Data{Body} .= "\n---- $EndMessage ---\n";
                }
            }
        }

        # check if Cc recipients should be used
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ComposeExcludeCcRecipients') ) {
            $Data{Cc} = '';
        }

        # add not local To addresses to Cc
        for my $Email ( Mail::Address->parse( $Data{To} ) ) {
            my $IsLocal = $Self->{SystemAddress}->SystemAddressIsLocalAddress(
                Address => $Email->address(),
            );
            if ( !$IsLocal ) {
                if ( $Data{Cc} ) {
                    $Data{Cc} .= ', ';
                }
                $Data{Cc} .= $Email->format();
            }
        }

        # check ReplyTo
        if ( $Data{ReplyTo} ) {
            $Data{To} = $Data{ReplyTo};
        }
        else {
            $Data{To} = $Data{From};

            # try to remove some wrong text to from line (by way of ...)
            # added by some strange mail programs on bounce
            $Data{To} =~ s/(.+?\<.+?\@.+?\>)\s+\(by\s+way\s+of\s+.+?\)/$1/ig;
        }

        # get to email (just "some@example.com")
        for my $Email ( Mail::Address->parse( $Data{To} ) ) {
            $Data{ToEmail} = $Email->address();
        }

        # only reply to sender
        if ( !$GetParam{ReplyAll} ) {
            $Data{Cc}  = '';
            $Data{Bcc} = '';
        }

        # use customer database email
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ComposeAddCustomerAddress') ) {

            # check if customer is in recipient list
            if ( $Customer{UserEmail} && $Data{ToEmail} !~ /^\Q$Customer{UserEmail}\E$/i ) {

                # replace To with customers database address
                if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ComposeReplaceSenderAddress') ) {
                    $Output .= $Self->{LayoutObject}->Notify(
                        Data => "To: ($Data{To}) replaced with database email!",
                    );
                    $Data{To} = $Customer{UserEmail};
                }

                # add customers database address to Cc
                else {
                    $Output .= $Self->{LayoutObject}->Notify(
                        Data => "Cc: ($Customer{UserEmail}) added database email!",
                    );
                    if ( $Data{Cc} ) {
                        $Data{Cc} .= ', ' . $Customer{UserEmail};
                    }
                    else {
                        $Data{Cc} = $Customer{UserEmail};
                    }
                }
            }
        }

        # find duplicate addresses
        my %Recipient;
        for my $Type (qw(To Cc Bcc)) {
            if ( $Data{$Type} ) {
                my $NewLine = '';
                for my $Email ( Mail::Address->parse( $Data{$Type} ) ) {
                    my $Address = lc $Email->address();

                    # only use email addresses with @ inside
                    if ( $Address && $Address =~ /@/ && !$Recipient{$Address} ) {
                        $Recipient{$Address} = 1;
                        my $IsLocal = $Self->{SystemAddress}->SystemAddressIsLocalAddress(
                            Address => $Address,
                        );
                        if ( !$IsLocal ) {
                            if ($NewLine) {
                                $NewLine .= ', ';
                            }
                            $NewLine .= $Email->format();
                        }
                    }
                }
                $Data{$Type} = $NewLine;
            }
        }

        # get template
        my $TemplateGenerator = Kernel::System::TemplateGenerator->new( %{$Self} );
        my %Response          = $TemplateGenerator->Response(
            TicketID   => $Self->{TicketID},
            ArticleID  => $GetParam{ArticleID},
            ResponseID => $GetParam{ResponseID},
            Data       => \%Data,
            UserID     => $Self->{UserID},
        );

        $Data{Salutation} = $Response{Salutation};
        $Data{Signature}  = $Response{Signature};

        # use key StdResponse to pass the data to the template for legacy reasons,
        #   because existing systems may have it in their configuration as that was
        #   the key used before the internal switch to StandardResponse
        $Data{StdResponse} = $Response{StandardResponse};

        %Data = $TemplateGenerator->Attributes(
            TicketID   => $Self->{TicketID},
            ArticleID  => $GetParam{ArticleID},
            ResponseID => $GetParam{ResponseID},
            Data       => \%Data,
            UserID     => $Self->{UserID},
        );

        my $ResponseFormat = $Self->{ConfigObject}->Get('Ticket::Frontend::ResponseFormat')
            || '$QData{"Salutation"}
$QData{"OrigFrom"} $Text{"wrote"}:
$QData{"Body"}

$QData{"StdResponse"}

$QData{"Signature"}
';

        # make sure body is rich text
        my %DataHTML = %Data;
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            $ResponseFormat = $Self->{LayoutObject}->Ascii2RichText(
                String => $ResponseFormat,
            );

            # restore qdata formatting for Output replacement
            $ResponseFormat =~ s/&quot;/"/gi;

            # html quote to have it correct in edit area
            $ResponseFormat = $Self->{LayoutObject}->Ascii2Html(
                Text => $ResponseFormat,
            );

            # restore qdata formatting for Output replacement
            $ResponseFormat =~ s/&quot;/"/gi;

            # quote all non html content to have it correct in edit area
            for my $Key ( keys %DataHTML ) {
                next if !$DataHTML{$Key};
                next if $Key eq 'Salutation';
                next if $Key eq 'Body';
                next if $Key eq 'StdResponse';
                next if $Key eq 'Signature';
                $DataHTML{$Key} = $Self->{LayoutObject}->Ascii2RichText(
                    String => $DataHTML{$Key},
                );
            }
        }

        # build new repsonse format based on template
        $Data{ResponseFormat} = $Self->{LayoutObject}->Output(
            Template => $ResponseFormat,
            Data => { %Param, %DataHTML },
        );

        # check some values
        my %Error;
        for my $Line (qw(To Cc Bcc)) {
            next if !$Data{$Line};
            for my $Email ( Mail::Address->parse( $Data{$Line} ) ) {
                if ( !$Self->{CheckItemObject}->CheckEmail( Address => $Email->address() ) ) {
                    $Error{ $Line . "Invalid" } = " ServerError"
                }
            }
        }
        if ( $Data{From} ) {
            for my $Email ( Mail::Address->parse( $Data{From} ) ) {
                if ( !$Self->{CheckItemObject}->CheckEmail( Address => $Email->address() ) ) {
                    $Error{"FromInvalid"} .= $Self->{CheckItemObject}->CheckError();
                }
            }
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

            # If Key has value 2, this means that the freetextfield is required
            if ( $Self->{Config}->{TicketFreeText}->{$Count} == 2 ) {
                $TicketFreeText{Required}->{$Count} = 1;
            }
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Ticket => \%Ticket,
            Config => \%TicketFreeText,
        );

        # free time
        my %TicketFreeTime;
        for my $Count ( 1 .. 6 ) {
            $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Optional' }
                = $Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $Count ) || 0;
            $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Used' }
                = $GetParam{ 'TicketFreeTime' . $Count . 'Used' };

            if ( $Ticket{ 'TicketFreeTime' . $Count } ) {
                (
                    $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Secunde' },
                    $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Minute' },
                    $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Hour' },
                    $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Day' },
                    $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Month' },
                    $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Year' }
                    )
                    = $Self->{TimeObject}->SystemTime2Date(
                    SystemTime => $Self->{TimeObject}->TimeStamp2SystemTime(
                        String => $Ticket{ 'TicketFreeTime' . $Count },
                    ),
                    );
                $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Used' } = 1;
            }

            if ( $Self->{Config}->{TicketFreeTime}->{$Count} == 2 ) {
                $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Required' } = 1;
            }

        }
        my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate(
            Ticket => \%TicketFreeTime,
        );

        # get article free text default selections
        my %ArticleFreeDefault;
        for my $Count ( 1 .. 3 ) {
            my $Key  = 'ArticleFreeKey' . $Count;
            my $Text = 'ArticleFreeText' . $Count;
            $ArticleFreeDefault{$Key} = $GetParam{$Key}
                || $Self->{ConfigObject}->Get( $Key . '::DefaultSelection' );
            $ArticleFreeDefault{$Text} = $GetParam{$Text}
                || $Self->{ConfigObject}->Get( $Text . '::DefaultSelection' );
        }

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

            # If Key has value 2, this means that the ArticleFreeText is required
            if ( $Self->{Config}->{ArticleFreeText}->{$Count} == 2 ) {
                $ArticleFreeText{Required}->{$Count} = 1;
            }
        }
        my %ArticleFreeTextHTML = $Self->{LayoutObject}->TicketArticleFreeText(
            Config => \%ArticleFreeText,
            Article => { %GetParam, %ArticleFreeDefault, },
        );

        # build references if exist
        my $References = ( $Data{MessageID} || '' ) . ( $Data{References} || '' );

        # build view ...
        $Output .= $Self->_Mask(
            TicketID       => $Self->{TicketID},
            NextStates     => $Self->_GetNextStates(),
            Attachments    => \@Attachments,
            Errors         => \%Error,
            GetParam       => \%GetParam,
            ResponseID     => $GetParam{ResponseID},
            ReplyArticleID => $GetParam{ArticleID},
            %Ticket,
            %Data,
            InReplyTo      => $Data{MessageID},
            References     => "$References",
            TicketBackType => $TicketBackType,
            %TicketFreeTextHTML,
            %TicketFreeTimeHTML,
            %ArticleFreeTextHTML,
        );
        $Output .= $Self->{LayoutObject}->Footer(
            Type => 'Small',
        );
        return $Output;
    }
}

sub _GetNextStates {
    my ( $Self, %Param ) = @_;

    # get next states
    my %NextStates = $Self->{TicketObject}->TicketStateList(
        Action   => $Self->{Action},
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID},
    );
    return \%NextStates;
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    # build next states string
    $Param{NextStates}->{''} = '-';

    my %State;
    if ( $Param{GetParam}->{StateID} ) {
        $State{SelectedID} = $Param{GetParam}->{StateID};
    }
    else {
        $State{SelectedValue} = $Param{NextState} || $Self->{Config}->{StateDefault};
    }
    $Param{NextStatesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => $Param{NextStates},
        Name => 'StateID',
        %State,
    );

    # build customer search autocomplete field
    my $AutoCompleteConfig
        = $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerSearchAutoComplete');
    $Self->{LayoutObject}->Block(
        Name => 'CustomerSearchAutoComplete',
        Data => {
            ActiveAutoComplete  => $AutoCompleteConfig->{Active},
            minQueryLength      => $AutoCompleteConfig->{MinQueryLength} || 2,
            queryDelay          => $AutoCompleteConfig->{QueryDelay} || 100,
            typeAhead           => $AutoCompleteConfig->{TypeAhead} || 'false',
            maxResultsDisplayed => $AutoCompleteConfig->{MaxResultsDisplayed} || 20,
        },
    );

    # prepare errors!
    if ( $Param{Errors} ) {
        for ( keys %{ $Param{Errors} } ) {
            $Param{$_} = $Self->{LayoutObject}->Ascii2Html( Text => $Param{Errors}->{$_} );
        }
    }

    # pending data string
    $Param{PendingDateString} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Format           => 'DateInputFormatLong',
        YearPeriodPast   => 0,
        YearPeriodFuture => 5,
        DiffTime         => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime') || 0,
        Class            => $Param{Errors}->{DateInvalid} || ' ',
        Validate         => 1,
        ValidateDateInFuture => 1,
    );

    $Self->{LayoutObject}->Block(
        Name => 'Content',
        Data => {
            FormID => $Self->{FormID},
            %Param,
        },
    );

    $Self->{LayoutObject}->Block(
        Name => $Param{TicketBackType},
        Data => {

            #            FormID => $Self->{FormID},
            %Param,
        },
    );

    # run compose modules
    if ( ref $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') eq 'HASH' ) {
        my %Jobs = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule') };
        for my $Job ( sort keys %Jobs ) {

            # load module
            if ( !$Self->{MainObject}->Require( $Jobs{$Job}->{Module} ) ) {
                return $Self->{LayoutObject}->FatalError();
            }
            my $Object = $Jobs{$Job}->{Module}->new( %{$Self}, Debug => $Self->{Debug}, );

            # get params
            for ( sort keys %{ $Param{GetParam} } ) {
                if ( !$Param{GetParam}->{$_} && $Param{$_} ) {
                    $Param{GetParam}->{$_} = $Param{$_};
                }
            }
            for ( $Object->Option( %Param, %{ $Param{GetParam} }, Config => $Jobs{$Job} ) ) {
                $Param{GetParam}->{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
            }

            # run module
            $Object->Run( %Param, %{ $Param{GetParam} }, Config => $Jobs{$Job} );

            # get errors
            %{ $Param{Errors} } = (
                %{ $Param{Errors} },
                $Object->Error( %{ $Param{GetParam} }, Config => $Jobs{$Job} )
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
            Data => { %Param, Count => $Count, },
        );
    }
    for my $Count ( 1 .. 6 ) {
        next if !$Self->{Config}->{TicketFreeTime}->{$Count};
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
            Data => { %Param, Count => $Count, },
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
            Data => { %Param, Count => $Count, },
        );
    }

    # show time accounting box
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime') ) {
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime') ) {
            $Self->{LayoutObject}->Block(
                Name => 'TimeUnitsLabelMandatory',
                Data => \%Param,
            );
            $Param{TimeUnitsRequired} = 'Validate_Required';
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'TimeUnitsLabel',
                Data => \%Param,
            );
            $Param{TimeUnitsRequired} = '';
        }
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnits',
            Data => \%Param,
        );
    }

    my $ShownOptionsBlock;

    # show spell check
    if ( $Self->{LayoutObject}->{BrowserSpellChecker} ) {

        # check if need to call Options block
        if ( !$ShownOptionsBlock ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketOptions',
                Data => {},
            );

            # set flag to "true" in order to prevent calling the Options block again
            $ShownOptionsBlock = 1;
        }

        $Self->{LayoutObject}->Block(
            Name => 'SpellCheck',
            Data => {},
        );
    }

    # show address book
    if ( $Self->{LayoutObject}->{BrowserJavaScriptSupport} ) {

        # check if need to call Options block
        if ( !$ShownOptionsBlock ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketOptions',
                Data => {},
            );

            # set flag to "true" in order to prevent calling the Options block again
            $ShownOptionsBlock = 1;
        }

        $Self->{LayoutObject}->Block(
            Name => 'AddressBook',
            Data => {},
        );
    }

    # add rich text editor
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => \%Param,
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

    # create & return output
    return $Self->{LayoutObject}->Output( TemplateFile => 'AgentTicketCompose', Data => \%Param );
}

1;
