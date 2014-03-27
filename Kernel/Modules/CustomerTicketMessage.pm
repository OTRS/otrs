# --
# Kernel/Modules/CustomerTicketMessage.pm - to handle customer messages
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: CustomerTicketMessage.pm,v 1.83.2.3 2012-02-12 20:16:06 ep Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketMessage;

use strict;
use warnings;

use Kernel::System::Web::UploadCache;
use Kernel::System::SystemAddress;
use Kernel::System::Queue;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.83.2.3 $) [1];

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

    # needed objects
    $Self->{StateObject}       = Kernel::System::State->new(%Param);
    $Self->{SystemAddress}     = Kernel::System::SystemAddress->new(%Param);
    $Self->{QueueObject}       = Kernel::System::Queue->new(%Param);
    $Self->{UploadCacheObject} = Kernel::System::Web::UploadCache->new(%Param);

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

    # get params
    my %GetParam;
    for my $Key (qw( Subject Body PriorityID TypeID ServiceID SLAID Expand Dest)) {
        $GetParam{$Key} = $Self->{ParamObject}->GetParam( Param => $Key );
    }

    # get article free text params
    for my $Count ( 1 .. 3 ) {
        my $Key  = 'ArticleFreeKey' . $Count;
        my $Text = 'ArticleFreeText' . $Count;
        $GetParam{$Key}  = $Self->{ParamObject}->GetParam( Param => $Key );
        $GetParam{$Text} = $Self->{ParamObject}->GetParam( Param => $Text );
    }

    if ( !$Self->{Subaction} ) {

        #Get QueueID for services
        my $QueueDefaultID;
        if ( !$GetParam{Dest} ) {
            my $QueueDefault = $Self->{Config}->{'QueueDefault'} || '';
            if ($QueueDefault) {
                $QueueDefaultID = $Self->{QueueObject}->QueueLookup( Queue => $QueueDefault );
            }
        }

        # get default selections for ticket free text fields
        my %TicketFreeDefault;
        for my $Count ( 1 .. 16 ) {
            my $Key  = 'TicketFreeKey' . $Count;
            my $Text = 'TicketFreeText' . $Count;
            $TicketFreeDefault{$Key}  = $Self->{ConfigObject}->Get( $Key . '::DefaultSelection' );
            $TicketFreeDefault{$Text} = $Self->{ConfigObject}->Get( $Text . '::DefaultSelection' );
        }

        # get free text config options
        my %TicketFreeText;
        for my $Count ( 1 .. 16 ) {
            my $Key  = 'TicketFreeKey' . $Count;
            my $Text = 'TicketFreeText' . $Count;
            $TicketFreeText{$Key} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID       => $Self->{TicketID},
                Action         => $Self->{Action},
                Type           => $Key,
                CustomerUserID => $Self->{UserID},
            );
            $TicketFreeText{$Text} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID       => $Self->{TicketID},
                Action         => $Self->{Action},
                Type           => $Text,
                CustomerUserID => $Self->{UserID},
            );

            # If Key has value 2, this means that the freetextfield is required
            if (
                $Self->{Config}->{TicketFreeText}->{$Count}
                && $Self->{Config}->{TicketFreeText}->{$Count} == 2
                )
            {
                $TicketFreeText{Required}->{$Count} = 1;
            }
        }

        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => \%TicketFreeDefault,
        );

        # get ticket free time params
        my %TicketFreeTime;
        for my $Count ( 1 .. 6 ) {
            for my $Type (qw(Used Year Month Day Hour Minute)) {
                $TicketFreeTime{ "TicketFreeTime" . $Count . $Type }
                    = $Self->{ParamObject}->GetParam( Param => "TicketFreeTime" . $Count . $Type );
            }
            $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Optional' }
                = $Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $Count ) || 0;
            if ( !$Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $Count ) ) {
                $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Used' } = 1;
            }

            if ( $Self->{Config}->{TicketFreeTime}->{$Count} == 2 ) {
                $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Required' } = 1;
            }
        }

        # transform free time, time stamp based on user time zone
        for my $Count ( 1 .. 6 ) {
            my $Prefix = 'TicketFreeTime' . $Count;
            next if !$TicketFreeTime{ $Prefix . 'Year' };
            next if !$TicketFreeTime{ $Prefix . 'Month' };
            next if !$TicketFreeTime{ $Prefix . 'Day' };
            next if !$TicketFreeTime{ $Prefix . 'Hour' };
            next if !$TicketFreeTime{ $Prefix . 'Minute' };
            %TicketFreeTime = $Self->{LayoutObject}->TransfromDateSelection(
                %TicketFreeTime,
                Prefix => $Prefix
            );
        }

        # free time
        my %FreeTime = $Self->{LayoutObject}->CustomerFreeDate(
            %Param,
            Ticket => \%TicketFreeTime,
        );

        # get default selections for article free text fields
        my %ArticleFreeDefault;
        for my $Count ( 1 .. 3 ) {
            my $Key  = 'ArticleFreeKey' . $Count;
            my $Text = 'ArticleFreeText' . $Count;
            $ArticleFreeDefault{$Key}  = $Self->{ConfigObject}->Get( $Key . '::DefaultSelection' );
            $ArticleFreeDefault{$Text} = $Self->{ConfigObject}->Get( $Text . '::DefaultSelection' );
        }

        # get article free text config options
        my %ArticleFreeText;
        for my $Count ( 1 .. 3 ) {
            my $Key  = 'ArticleFreeKey' . $Count;
            my $Text = 'ArticleFreeText' . $Count;
            $ArticleFreeText{$Key} = $Self->{TicketObject}->ArticleFreeTextGet(
                ArticleID      => $Self->{ArticleID},
                Action         => $Self->{Action},
                Type           => $Key,
                CustomerUserID => $Self->{UserID},
            );
            $ArticleFreeText{$Text} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID       => $Self->{TicketID},
                Action         => $Self->{Action},
                Type           => $Text,
                CustomerUserID => $Self->{UserID},
            );

            # If Key has value 2, this means that the freetextfield is required
            if ( $Self->{Config}->{ArticleFreeText}->{$Count} == 2 ) {
                $ArticleFreeText{Required}->{$Count} = 1;
            }
        }

        my %ArticleFreeTextHTML = $Self->{LayoutObject}->TicketArticleFreeText(
            Config  => \%ArticleFreeText,
            Article => {
                %GetParam,
                %ArticleFreeDefault,
            },
        );

        # print form ...
        my $Output .= $Self->{LayoutObject}->CustomerHeader();
        $Output    .= $Self->{LayoutObject}->CustomerNavigationBar();
        $Output    .= $Self->_MaskNew(
            QueueID => $QueueDefaultID,
            %TicketFreeTextHTML,
            %FreeTime,
            %ArticleFreeTextHTML,
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
    elsif ( $Self->{Subaction} eq 'StoreNew' ) {
        my $NextScreen = $Self->{Config}->{NextScreenAfterNewTicket};
        my %Error;

        # get destination queue
        my $Dest = $Self->{ParamObject}->GetParam( Param => 'Dest' ) || '';
        my ( $NewQueueID, $To ) = split( /\|\|/, $Dest );
        if ( !$To ) {
            $NewQueueID = $Self->{ParamObject}->GetParam( Param => 'NewQueueID' ) || '';
            $To = 'System';
        }

        # fallback, if no destination is given
        if ( !$NewQueueID ) {
            my $Queue
                = $Self->{ParamObject}->GetParam( Param => 'Queue' )
                || $Self->{Config}->{'QueueDefault'}
                || '';
            if ($Queue) {
                my $QueueID = $Self->{QueueObject}->QueueLookup( Queue => $Queue );
                $NewQueueID = $QueueID;
                $To         = $Queue;
            }
        }

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
            $IsUpload = 1;
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

        my %TicketFree;
        for my $Count ( 1 .. 16 ) {
            my $Key  = 'TicketFreeKey' . $Count;
            my $Text = 'TicketFreeText' . $Count;
            $TicketFree{$Key}  = $Self->{ParamObject}->GetParam( Param => $Key );
            $TicketFree{$Text} = $Self->{ParamObject}->GetParam( Param => $Text );
        }

        # get free text config options
        my %TicketFreeText;
        for my $Count ( 1 .. 16 ) {
            my $Key  = 'TicketFreeKey' . $Count;
            my $Text = 'TicketFreeText' . $Count;
            $TicketFreeText{$Key} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID       => $Self->{TicketID},
                Action         => $Self->{Action},
                Type           => $Key,
                QueueID        => $NewQueueID || 0,
                ServiceID      => $GetParam{ServiceID} || 0,
                CustomerUserID => $Self->{UserID},
            );
            $TicketFreeText{$Text} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID       => $Self->{TicketID},
                Action         => $Self->{Action},
                Type           => $Text,
                QueueID        => $NewQueueID || 0,
                ServiceID      => $GetParam{ServiceID} || 0,
                CustomerUserID => $Self->{UserID},
            );

            # If Key has value 2, this means that the freetextfield is required
            if ( $Self->{Config}->{TicketFreeText}->{$Count} == 2 ) {
                $TicketFreeText{Required}->{$Count} = 1;
            }

            # check required FreeTextField (if configured)
            if (
                $Self->{Config}->{TicketFreeText}->{$Count} == 2
                && $TicketFree{$Text} eq ''
                && !$GetParam{Expand}
                && $IsUpload == 0
                )
            {
                $TicketFreeText{Error}->{$Count} = 1;
                $Error{$Text} = 'ServerError';
            }
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => \%TicketFree,
        );

        # get ticket free time params
        my %TicketFreeTime;
        for my $Count ( 1 .. 6 ) {
            for my $Type (qw(Used Year Month Day Hour Minute)) {
                $TicketFreeTime{ "TicketFreeTime" . $Count . $Type }
                    = $Self->{ParamObject}->GetParam(
                    Param => "TicketFreeTime" . $Count . $Type,
                    );
            }
            $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Optional' }
                = $Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $Count ) || 0;
            if ( !$Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $Count ) ) {
                $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Used' } = 1;
            }

            if ( $Self->{Config}->{TicketFreeTime}->{$Count} == 2 ) {
                $TicketFreeTime{ 'TicketFreeTime' . $Count . 'Required' } = 1;
            }
        }

        # free time
        my %FreeTime = $Self->{LayoutObject}->CustomerFreeDate(
            %Param,
            Ticket => \%TicketFreeTime,
        );

        # article free text
        my %ArticleFreeText;
        for my $Count ( 1 .. 3 ) {
            my $Key  = 'ArticleFreeKey' . $Count;
            my $Text = 'ArticleFreeText' . $Count;
            $ArticleFreeText{$Key} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID       => $Self->{TicketID},
                Type           => $Key,
                Action         => $Self->{Action},
                CustomerUserID => $Self->{UserID},
            );
            $ArticleFreeText{$Text} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID       => $Self->{TicketID},
                Type           => $Text,
                Action         => $Self->{Action},
                CustomerUserID => $Self->{UserID},
            );

            # If Key has value 2, this means that the field is required
            if ( $Self->{Config}->{ArticleFreeText}->{$Count} == 2 ) {
                $ArticleFreeText{Required}->{$Count} = 1;
            }

            # check required ArticleTextField (if configured)
            if (
                $Self->{Config}->{ArticleFreeText}->{$Count} == 2
                && $GetParam{$Text} eq ''
                && !$GetParam{Expand}
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

        # rewrap body if rich text is used
        if ( $Self->{LayoutObject}->{BrowserRichText} && $GetParam{Body} ) {
            $GetParam{Body}
                =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote')})(?:\s|\z)/$1\n/gm;
        }

        # check queue
        if ( !$NewQueueID && !$IsUpload && !$GetParam{Expand} ) {
            $Error{QueueInvalid} = 'ServerError';
        }

        # check subject
        if ( !$GetParam{Subject} && !$IsUpload ) {
            $Error{SubjectInvalid} = 'ServerError';
        }

        # check body
        if ( !$GetParam{Body} && !$IsUpload ) {
            $Error{BodyInvalid} = 'ServerError';
        }
        if ( $GetParam{Expand} ) {
            %Error = ();
            $Error{Expand} = 1;
        }

        # check type
        if (
            $Self->{ConfigObject}->Get('Ticket::Type')
            && !$GetParam{TypeID}
            && !$IsUpload
            && !$GetParam{Expand}
            )
        {
            $Error{TypeIDInvalid} = 'ServerError';
        }

        if (%Error) {

            # html output
            my $Output .= $Self->{LayoutObject}->CustomerHeader();
            $Output    .= $Self->{LayoutObject}->CustomerNavigationBar();
            $Output    .= $Self->_MaskNew(
                Attachments => \@Attachments,
                %GetParam,
                ToSelected => $Dest,
                QueueID    => $NewQueueID,
                %TicketFreeTextHTML,
                %FreeTime,
                %ArticleFreeTextHTML,
                Errors => \%Error,
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }

        # if customer is not alowed to set priority, set it to default
        if ( !$Self->{Config}->{Priority} ) {
            $GetParam{PriorityID} = '';
            $GetParam{Priority}   = $Self->{Config}->{PriorityDefault};
        }

        # create new ticket, do db insert
        my $TicketID = $Self->{TicketObject}->TicketCreate(
            QueueID      => $NewQueueID,
            TypeID       => $GetParam{TypeID},
            ServiceID    => $GetParam{ServiceID},
            SLAID        => $GetParam{SLAID},
            Title        => $GetParam{Subject},
            PriorityID   => $GetParam{PriorityID},
            Priority     => $GetParam{Priority},
            Lock         => 'unlock',
            State        => $Self->{Config}->{StateDefault},
            CustomerID   => $Self->{UserCustomerID},
            CustomerUser => $Self->{UserLogin},
            OwnerID      => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            UserID       => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
        );

        # set ticket free text
        for my $Count ( 1 .. 16 ) {
            my $Key  = 'TicketFreeKey' . $Count;
            my $Text = 'TicketFreeText' . $Count;
            if ( defined $TicketFree{$Key} ) {
                $Self->{TicketObject}->TicketFreeTextSet(
                    TicketID => $TicketID,
                    Key      => $TicketFree{$Key},
                    Value    => $TicketFree{$Text},
                    Counter  => $Count,
                    UserID   => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                );
            }
        }

        # set ticket free time
        for my $Count ( 1 .. 6 ) {
            my $Prefix = 'TicketFreeTime' . $Count;
            next if !defined $TicketFreeTime{ $Prefix . 'Year' };
            next if !defined $TicketFreeTime{ $Prefix . 'Month' };
            next if !defined $TicketFreeTime{ $Prefix . 'Day' };
            next if !defined $TicketFreeTime{ $Prefix . 'Hour' };
            next if !defined $TicketFreeTime{ $Prefix . 'Minute' };

            # set time stamp to NULL if field is not used/checked
            if ( !$TicketFreeTime{ $Prefix . 'Used' } ) {
                $TicketFreeTime{ $Prefix . 'Year' }   = 0;
                $TicketFreeTime{ $Prefix . 'Month' }  = 0;
                $TicketFreeTime{ $Prefix . 'Day' }    = 0;
                $TicketFreeTime{ $Prefix . 'Hour' }   = 0;
                $TicketFreeTime{ $Prefix . 'Minute' } = 0;
            }

            # set free time
            $Self->{TicketObject}->TicketFreeTimeSet(
                %TicketFreeTime,
                Prefix   => 'TicketFreeTime',
                TicketID => $TicketID,
                Counter  => $Count,
                UserID   => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            );
        }

        my $MimeType = 'text/plain';
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            $MimeType = 'text/html';

            # verify html document
            $GetParam{Body} = $Self->{LayoutObject}->RichTextDocumentComplete(
                String => $GetParam{Body},
            );
        }

        # create article
        my $From      = "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>";
        my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID         => $TicketID,
            ArticleType      => $Self->{Config}->{ArticleType},
            SenderType       => $Self->{Config}->{SenderType},
            From             => $From,
            To               => $To,
            Subject          => $GetParam{Subject},
            Body             => $GetParam{Body},
            MimeType         => $MimeType,
            Charset          => $Self->{LayoutObject}->{UserCharset},
            UserID           => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            HistoryType      => $Self->{Config}->{HistoryType},
            HistoryComment   => $Self->{Config}->{HistoryComment} || '%%',
            AutoResponseType => 'auto reply',
            OrigHeader       => {
                From    => $From,
                To      => $Self->{UserLogin},
                Subject => $GetParam{Subject},
                Body    => $Self->{LayoutObject}->RichText2Ascii( String => $GetParam{Body} ),
            },
            Queue => $Self->{QueueObject}->QueueLookup( QueueID => $NewQueueID ),
        );
        if ( !$ArticleID ) {
            my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
            $Output .= $Self->{LayoutObject}->CustomerError();
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }

        # set article free text
        for my $Count ( 1 .. 3 ) {
            my $Key  = 'ArticleFreeKey' . $Count;
            my $Text = 'ArticleFreeText' . $Count;
            if ( defined $GetParam{$Key} ) {
                $Self->{TicketObject}->ArticleFreeTextSet(
                    TicketID  => $TicketID,
                    ArticleID => $ArticleID,
                    Key       => $GetParam{$Key},
                    Value     => $GetParam{$Text},
                    Counter   => $Count,
                    UserID    => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                );
            }
        }

        # get pre loaded attachment
        my @AttachmentData = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );

        # get submitted attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'file_upload',
            Source => 'String',
        );
        if (%UploadStuff) {
            push @AttachmentData, \%UploadStuff;
        }

        # write attachments
        for my $Attachment (@AttachmentData) {

            # skip, deleted not used inline images
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

            # write existing file to backend
            $Self->{TicketObject}->ArticleWriteAttachment(
                %{$Attachment},
                ArticleID => $ArticleID,
                UserID    => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            );
        }

        # remove pre submitted attachments
        $Self->{UploadCacheObject}->FormIDRemove( FormID => $Self->{FormID} );

        # redirect
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$NextScreen;TicketID=$TicketID",
        );
    }
    my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
    $Output .= $Self->{LayoutObject}->CustomerError(
        Message => 'No Subaction!!',
        Comment => 'Please contact your administrator',
    );
    $Output .= $Self->{LayoutObject}->CustomerFooter();
    return $Output;
}

sub _MaskNew {
    my ( $Self, %Param ) = @_;

    $Param{FormID} = $Self->{FormID};
    $Param{Errors}->{QueueInvalid} = $Param{Errors}->{QueueInvalid} || '';

    # get list type
    my $TreeView = 0;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    if ( $Self->{Config}->{Queue} ) {

        # check own selection
        my %NewTos = ( '', '-' );
        my $Module = $Self->{ConfigObject}->Get('CustomerPanel::NewTicketQueueSelectionModule')
            || 'Kernel::Output::HTML::CustomerNewTicketQueueSelectionGeneric';
        if ( $Self->{MainObject}->Require($Module) ) {
            my $Object = $Module->new( %{$Self}, Debug => $Self->{Debug}, );

            # log loaded module
            if ( $Self->{Debug} > 1 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "Module: $Module loaded!",
                );
            }
            %NewTos = ( $Object->Run( Env => $Self ), ( '', => '-' ) );
        }
        else {
            return $Self->{LayoutObject}->FatalError();
        }

        # build to string
        if (%NewTos) {
            for ( keys %NewTos ) {
                $NewTos{"$_||$NewTos{$_}"} = $NewTos{$_};
                delete $NewTos{$_};
            }
        }
        $Param{ToStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Data       => \%NewTos,
            Multiple   => 0,
            Size       => 0,
            Name       => 'Dest',
            Class      => "Validate_Required " . $Param{Errors}->{QueueInvalid},
            SelectedID => $Param{ToSelected},
        );
        $Self->{LayoutObject}->Block(
            Name => 'Queue',
            Data => {
                %Param,
                QueueInvalid => $Param{Errors}->{QueueInvalid},
            },
        );

    }

    # get priority
    if ( $Self->{Config}->{Priority} ) {
        my %Priorities = $Self->{TicketObject}->TicketPriorityList(
            %Param,
            CustomerUserID => $Self->{UserID},
            Action         => $Self->{Action},
        );

        # build priority string
        my %PrioritySelected;
        if ( $Param{PriorityID} ) {
            $PrioritySelected{SelectedID} = $Param{PriorityID};
        }
        else {
            $PrioritySelected{SelectedValue} = $Self->{Config}->{PriorityDefault} || '3 normal';
        }
        $Param{PriorityStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => \%Priorities,
            Name => 'PriorityID',
            %PrioritySelected,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Priority',
            Data => \%Param,
        );
    }

    # types
    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
        my %Type = $Self->{TicketObject}->TicketTypeList(
            %Param,
            Action         => $Self->{Action},
            CustomerUserID => $Self->{UserID},
        );
        $Param{TypeStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%Type,
            Name         => 'TypeID',
            SelectedID   => $Param{TypeID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            Class        => "Validate_Required " . ( $Param{Errors}->{TypeIDInvalid} || '' ),
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketType',
            Data => {
                %Param,
                TypeIDInvalid => $Param{Errors}->{TypeIDInvalid},
                }
        );
    }

    # services
    if ( $Self->{ConfigObject}->Get('Ticket::Service') && $Self->{Config}->{Service} ) {
        my %Service;
        if ( $Param{QueueID} || $Param{TicketID} ) {
            %Service = $Self->{TicketObject}->TicketServiceList(
                %Param,
                Action         => $Self->{Action},
                CustomerUserID => $Self->{UserID},
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
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketService',
            Data => \%Param,
        );
        my %SLA;
        if ( $Self->{Config}->{SLA} ) {
            if ( $Param{ServiceID} ) {
                %SLA = $Self->{TicketObject}->TicketSLAList(
                    %Param,
                    Action         => $Self->{Action},
                    CustomerUserID => $Self->{UserID},
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
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketSLA',
                Data => \%Param,
            );
        }
    }

    # prepare errors
    if ( $Param{Errors} ) {
        for ( keys %{ $Param{Errors} } ) {
            $Param{$_} = $Param{Errors}->{$_};
        }
    }

    # ticket free text
    for my $Count ( 1 .. 16 ) {
        next if !$Self->{Config}->{TicketFreeText}->{$Count};
        $Self->{LayoutObject}->Block(
            Name => 'FreeText',
            Data => {
                TicketFreeKeyField  => $Param{ 'TicketFreeKeyField' . $Count },
                TicketFreeTextField => $Param{ 'TicketFreeTextField' . $Count },
                Count               => $Count,
                ServerError         => $Param{Errors}->{ 'TicketFreeText' . $Count },
                %Param,
            },
        );
    }

    # ticket free time
    for my $Count ( 1 .. 6 ) {
        next if !$Self->{Config}->{TicketFreeTime}->{$Count};
        $Self->{LayoutObject}->Block(
            Name => 'FreeTime',
            Data => {
                TicketFreeTimeKey => $Param{ 'TicketFreeTimeKey' . $Count },
                TicketFreeTime    => $Param{ 'TicketFreeTime' . $Count },
                Count             => $Count,
            },
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
                ServerError          => $Param{Errors}->{ 'ArticleFreeText' . $Count },
                %Param,
            },
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

   #    # java script check for required free time fields by form submit
   #    for my $Key ( keys %{ $Self->{Config}->{TicketFreeTime} } ) {
   #        next if $Self->{Config}->{TicketFreeTime}->{$Key} != 2;
   #        $Self->{LayoutObject}->Block(
   #            Name => 'TicketFreeTimeCheckJs',
   #            Data => {
   #                TicketFreeTimeCheck => 'TicketFreeTime' . $Key . 'Used',
   #                TicketFreeTimeField => 'TicketFreeTime' . $Key,
   #                TicketFreeTimeKey   => $Self->{ConfigObject}->Get( 'TicketFreeTimeKey' . $Key ),
   #            },
   #        );
   #    }

    # add rich text editor
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => \%Param,
        );
    }

    # get output back
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerTicketMessage',
        Data         => \%Param,
    );
}

1;
