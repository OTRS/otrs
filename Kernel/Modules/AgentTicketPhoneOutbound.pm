# --
# Kernel/Modules/AgentTicketPhoneOutbound.pm - to handle phone calls
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: AgentTicketPhoneOutbound.pm,v 1.69.2.3 2011-08-19 18:50:15 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketPhoneOutbound;

use strict;
use warnings;

use Kernel::System::SystemAddress;
use Kernel::System::CustomerUser;
use Kernel::System::CheckItem;
use Kernel::System::Web::UploadCache;
use Kernel::System::State;
use Mail::Address;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.69.2.3 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject)
        )
    {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    $Self->{SystemAddress}      = Kernel::System::SystemAddress->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{CheckItemObject}    = Kernel::System::CheckItem->new(%Param);
    $Self->{StateObject}        = Kernel::System::State->new(%Param);
    $Self->{UploadCacheObject}  = Kernel::System::Web::UploadCache->new(%Param);

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

    my $OutputNotify = '';

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'Got no TicketID!',
            Comment => 'System Error!',
        );
    }

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

    # check permissions
    my $Access = $Self->{TicketObject}->TicketPermission(
        Type     => $Self->{Config}->{Permission},
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # show lock state
    $OutputNotify .= $Self->{LayoutObject}->Notify(
        Data => $Ticket{TicketNumber} . ': $Text{"Ticket locked!"}',
    );

    # get lock state && write (lock) permissions
    if ( $Self->{Config}->{RequiredLock} ) {
        if ( !$Self->{TicketObject}->TicketLockGet( TicketID => $Self->{TicketID} ) ) {
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID},
            );
            if (
                $Self->{TicketObject}->TicketOwnerSet(
                    TicketID  => $Self->{TicketID},
                    UserID    => $Self->{UserID},
                    NewUserID => $Self->{UserID},
                )
                )
            {

                # show lock state
                $OutputNotify = $Self->{LayoutObject}->Notify(
                    Data => $Ticket{TicketNumber} . ': $Text{"Ticket locked!"}',
                );
            }
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
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'TicketBack',
                    Data => { %Param, TicketID => $Self->{TicketID}, },
                );
            }
        }
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'TicketBack',
            Data => { %Param, %Ticket, },
        );
    }

    # get params
    my %GetParam;
    for my $Key (qw(Body Subject TimeUnits NextStateID Year Month Day Hour Minute)) {
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
    for my $Count ( 1 .. 6 ) {

        # create freetime prefix
        my $FreeTimePrefix = 'TicketFreeTime' . $Count;

        # get form params
        for my $Type (qw(Used Year Month Day Hour Minute)) {
            $GetParam{ $FreeTimePrefix . $Type } = $Self->{ParamObject}->GetParam(
                Param => $FreeTimePrefix . $Type,
            );
        }

        # set additional params
        $GetParam{ $FreeTimePrefix . 'Optional' } = 1;
        $GetParam{ $FreeTimePrefix . 'Used' } = $GetParam{ $FreeTimePrefix . 'Used' } || 0;
        if ( !$Self->{ConfigObject}->Get( 'TicketFreeTimeOptional' . $Count ) ) {
            $GetParam{ $FreeTimePrefix . 'Optional' } = 0;
            $GetParam{ $FreeTimePrefix . 'Used' }     = 1;
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

    if ( !$Self->{Subaction} ) {

        # get ticket info
        my %CustomerData;
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose') ) {
            if ( $Ticket{CustomerUserID} ) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $Ticket{CustomerUserID},
                );
            }
            elsif ( $Ticket{CustomerID} ) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    CustomerID => $Ticket{CustomerID},
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
        my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate( Ticket => \%TicketFreeTime );

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

            # If Key has value 2, this means that the field is required
            if ( $Self->{Config}->{ArticleFreeText}->{$Count} == 2 ) {
                $ArticleFreeText{Required}->{$Count} = 1;
            }

        }
        my %ArticleFreeTextHTML = $Self->{LayoutObject}->TicketArticleFreeText(
            Config => \%ArticleFreeText,
            Article => { %GetParam, %ArticleFreeDefault, },
        );

        # get and format default subject and body
        my $Subject = $Self->{LayoutObject}->Output(
            Template => $Self->{Config}->{Subject} || '',
        );
        my $Body = $Self->{LayoutObject}->Output(
            Template => $Self->{Config}->{Body} || '',
        );
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            $Body = $Self->{LayoutObject}->Ascii2RichText(
                String => $Body,
            );
        }

        # print form ...
        my $Output = $Self->{LayoutObject}->Header(
            Type => 'Small',
        );
        $Output .= $Self->_MaskPhone(
            TicketID     => $Self->{TicketID},
            QueueID      => $Self->{QueueID},
            TicketNumber => $Ticket{TicketNumber},
            Title        => $Ticket{Title},
            NextStates   => $Self->_GetNextStates(),
            CustomerData => \%CustomerData,
            Subject      => $Subject,
            Body         => $Body,
            %TicketFreeTextHTML,
            %TicketFreeTimeHTML,
            %ArticleFreeTextHTML,
        );
        $Output .= $Self->{LayoutObject}->Footer(
            Type => 'Small',
        );
        return $Output;
    }

    # save new phone article to existing ticket
    elsif ( $Self->{Subaction} eq 'Store' ) {
        my %Error;

        # rewrap body if exists
        if ( $Self->{LayoutObject}->{BrowserRichText} && $GetParam{Body} ) {
            $GetParam{Body}
                =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote')})(?:\s|\z)/$1\n/gm;
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

        # check subject
        for my $Key (qw(Body Subject)) {
            if ( !$IsUpload && $GetParam{$Key} eq '' ) {
                $Error{ $Key . 'Invalid' } = 'ServerError';
            }
        }
        if (
            $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime')
            && $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
            )
        {
            if ( !$IsUpload && $GetParam{TimeUnits} eq '' ) {
                $Error{'TimeUnitsInvalid'} = 'ServerError';
            }
        }

        # get all attachments meta data
        my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # check if date is valid
        my %StateData = $Self->{StateObject}->StateGet( ID => $GetParam{NextStateID} );
        if ( $StateData{TypeName} =~ /^pending/i ) {
            if ( !$Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 ) ) {
                if ( $IsUpload == 0 ) {
                    $Error{'DateInvalid'} = ' ServerError';
                }
            }
            if (
                $Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 )
                < $Self->{TimeObject}->SystemTime()
                )
            {
                if ( $IsUpload == 0 ) {
                    $Error{'DateInvalid'} = ' ServerError';
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

            # check required FreeTextField (if configured)
            if (
                $Self->{Config}->{TicketFreeText}->{$Count} == 2
                && $GetParam{$Text} eq ''
                && $IsUpload == 0
                )
            {
                $TicketFreeText{Error}->{$Count} = 1;
            }
        }

        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => \%GetParam,
        );

        # free time
        my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate( Ticket => \%GetParam, );

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

        if (%Error) {

            # get ticket info if ticket id is given
            my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

            # check permissions if it's a existing ticket
            if (
                !$Self->{TicketObject}->TicketPermission(
                    Type     => 'ro',
                    TicketID => $Self->{TicketID},
                    UserID   => $Self->{UserID},
                )
                )
            {

                # error screen, don't show ticket
                return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
            }

            # get ticket info
            my $Tn = $Ticket{TicketNumber};
            my %CustomerData;
            if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose') ) {
                if ( $Ticket{CustomerUserID} ) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        User => $Ticket{CustomerUserID},
                    );
                }
                elsif ( $Ticket{CustomerID} ) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        CustomerID => $Ticket{CustomerID},
                    );
                }
            }

            # header
            my $Output = $Self->{LayoutObject}->Header(
                Type => 'Small',
            );
            $Output .= $OutputNotify;
            $Output .= $Self->_MaskPhone(
                TicketID     => $Self->{TicketID},
                TicketNumber => $Tn,
                NextStates   => $Self->_GetNextStates(),
                CustomerData => \%CustomerData,
                Attachments  => \@Attachments,
                %GetParam,
                %TicketFreeTextHTML,
                %TicketFreeTimeHTML,
                %ArticleFreeTextHTML,
                Errors => \%Error,
            );
            $Output .= $Self->{LayoutObject}->Footer(
                Type => 'Small',
            );
            return $Output;
        }
        else {

            # get pre loaded attachment
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

            my $ArticleID = $Self->{TicketObject}->ArticleCreate(
                TicketID    => $Self->{TicketID},
                ArticleType => $Self->{Config}->{ArticleType},
                SenderType  => $Self->{Config}->{SenderType},
                From        => "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>",
                Subject     => $GetParam{Subject},
                Body        => $GetParam{Body},
                MimeType    => $MimeType,
                Charset     => $Self->{LayoutObject}->{UserCharset},
                UserID      => $Self->{UserID},
                HistoryType => $Self->{Config}->{HistoryType},
                HistoryComment => $Self->{Config}->{HistoryComment} || '%%',
            );

            # show error of creating article
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

            # write attachments
            for my $Attachment (@AttachmentData) {
                $Self->{TicketObject}->ArticleWriteAttachment(
                    %{$Attachment},
                    ArticleID => $ArticleID,
                    UserID    => $Self->{UserID},
                );
            }

            # remove pre submitted attachments
            $Self->{UploadCacheObject}->FormIDRemove( FormID => $Self->{FormID} );

            # set ticket free text
            for my $Count ( 1 .. 16 ) {
                if ( defined $GetParam{"TicketFreeKey$Count"} ) {
                    $Self->{TicketObject}->TicketFreeTextSet(
                        TicketID => $Self->{TicketID},
                        Key      => $GetParam{"TicketFreeKey$Count"},
                        Value    => $GetParam{"TicketFreeText$Count"},
                        Counter  => $Count,
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
                StateID   => $GetParam{NextStateID},
                UserID    => $Self->{UserID},
            );

            # should i set an unlock? yes if the ticket is closed
            my %StateData = $Self->{StateObject}->StateGet( ID => $GetParam{NextStateID} );
            if ( $StateData{TypeName} =~ /^close/i ) {

                # set lock
                $Self->{TicketObject}->TicketLockSet(
                    TicketID => $Self->{TicketID},
                    Lock     => 'unlock',
                    UserID   => $Self->{UserID},
                );
            }

            # set pending time if next state is a pending state
            elsif ( $StateData{TypeName} =~ /^pending/i ) {

                # set pending time
                $Self->{TicketObject}->TicketPendingTimeSet(
                    UserID   => $Self->{UserID},
                    TicketID => $Self->{TicketID},
                    %GetParam,
                );
            }

            # redirect to last screen (e. g. zoom view) and to queue view if
            # the ticket is closed (move to the next task).
            if ( $StateData{TypeName} =~ /^close/i ) {
                return $Self->{LayoutObject}->PopupClose(
                    URL => ( $Self->{LastScreenView} || 'Action=AgentDashboard' ),
                );
            }

            return $Self->{LayoutObject}->PopupClose(
                URL => ( $Self->{LastScreenView} || 'Action=AgentDashboard' ),
            );
        }
    }
    return $Self->{LayoutObject}->ErrorScreen(
        Message => 'No Subaction!!',
        Comment => 'Please contact your administrator',
    );
}

sub _GetNextStates {
    my ( $Self, %Param ) = @_;

    my %NextStates = $Self->{TicketObject}->TicketStateList(
        TicketID => $Self->{TicketID},
        Action   => $Self->{Action},
        UserID   => $Self->{UserID},
    );
    return \%NextStates;
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
        for my $KeyGroupMember ( keys %AllGroupsMembers ) {
            my $Hit = 0;
            for my $UID (@UserIDs) {
                if ( $UID eq $KeyGroupMember ) {
                    $Hit = 1;
                }
            }
            if ( !$Hit ) {
                delete $AllGroupsMembers{$KeyGroupMember};
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
            Type    => 'rw',
            Result  => 'HASH',
        );
        for my $KeyMember ( keys %MemberList ) {
            $ShownUsers{$KeyMember} = $AllGroupsMembers{$KeyMember};
        }
    }
    return \%ShownUsers;
}

sub _GetTos {
    my ( $Self, %Param ) = @_;

    # check own selection
    my %NewTos;
    if ( $Self->{ConfigObject}->{'Ticket::Frontend::NewQueueOwnSelection'} ) {
        %NewTos = %{ $Self->{ConfigObject}->{'Ticket::Frontend::NewQueueOwnSelection'} };
    }
    else {

        # SelectionType Queue or SystemAddress?
        my %Tos;
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue' ) {
            %Tos = $Self->{TicketObject}->MoveList(
                Type    => 'create',
                Action  => $Self->{Action},
                QueueID => $Self->{QueueID},
                UserID  => $Self->{UserID},
            );
        }
        else {
            %Tos = $Self->{DBObject}->GetTableData(
                Table => 'system_address',
                What  => 'queue_id, id',
                Valid => 1,
                Clamp => 1,
            );
        }

        # get create permission queues
        my %UserGroups = $Self->{GroupObject}->GroupMemberList(
            UserID => $Self->{UserID},
            Type   => 'create',
            Result => 'HASH',
        );
        for my $KeyTo ( keys %Tos ) {
            if ( $UserGroups{ $Self->{QueueObject}->GetQueueGroupID( QueueID => $KeyTo ) } ) {
                $NewTos{$KeyTo} = $Tos{$KeyTo};
            }
        }

        # build selection string
        for my $KeyNewTo ( keys %NewTos ) {
            my %QueueData = $Self->{QueueObject}->QueueGet( ID => $KeyNewTo );
            my $Srting = $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionString')
                || '<Realname> <<Email>> - Queue: <Queue>';
            $Srting =~ s/<Queue>/$QueueData{Name}/g;
            $Srting =~ s/<QueueComment>/$QueueData{Comment}/g;
            if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionType') ne 'Queue' )
            {
                my %SystemAddressData
                    = $Self->{SystemAddress}->SystemAddressGet( ID => $NewTos{$KeyNewTo} );
                $Srting =~ s/<Realname>/$SystemAddressData{Realname}/g;
                $Srting =~ s/<Email>/$SystemAddressData{Name}/g;
            }
            $NewTos{$KeyNewTo} = $Srting;
        }
    }

    # adde empty selection
    $NewTos{''} = '-';
    return \%NewTos;
}

sub _MaskPhone {
    my ( $Self, %Param ) = @_;

    $Param{FormID} = $Self->{FormID};

    # build next states string
    my %Selected;
    if ( $Param{NextStateID} ) {
        $Selected{SelectedID} = $Param{NextStateID};
    }
    elsif ( $Self->{Config}->{State} ) {
        $Selected{SelectedValue} = $Self->{Config}->{State};
    }
    else {
        $Param{NextStates}->{''} = '-';
    }
    $Param{NextStatesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => $Param{NextStates},
        Name => 'NextStateID',
        %Selected,
    );

    # customer info string
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose') ) {
        $Param{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
            Data => $Param{CustomerData},
            Max  => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoComposeMaxSize'),
        );
        $Self->{LayoutObject}->Block(
            Name => 'CustomerTable',
            Data => \%Param,
        );
    }

    # pending data string
    $Param{PendingDateString} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Format           => 'DateInputFormatLong',
        YearPeriodPast   => 0,
        YearPeriodFuture => 5,
        DiffTime         => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime') || 0,
        Class            => $Param{Errors}->{DateInvalid},
        Validate         => 1,
        ValidateDateInFuture => 1,
    );

    # do html quoting
    for my $Parameter (qw(From To Cc)) {
        $Param{$Parameter} = $Self->{LayoutObject}->Ascii2Html( Text => $Param{$Parameter} ) || '';
    }

    # prepare errors!
    if ( $Param{Errors} ) {
        for my $KeyError ( keys %{ $Param{Errors} } ) {
            $Param{$KeyError}
                = '* ' . $Self->{LayoutObject}->Ascii2Html( Text => $Param{Errors}->{$KeyError} );
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

    # add rich text editor
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => \%Param,
        );
    }

    # get output back
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketPhoneOutbound',
        Data         => \%Param,
    );
}

1;
