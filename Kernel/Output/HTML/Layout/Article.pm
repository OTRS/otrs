# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Layout::Article;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Output::HTML::Layout::Article - Helper functions for article rendering.

=head1 PUBLIC INTERFACE

=head2 ArticleFields()

Get article fields as returned by specific article backend.

    my %ArticleFields = $LayoutObject->ArticleFields(
        TicketID  => 123,   # (required)
        ArticleID => 123,   # (required)
    );

Returns article fields hash:

    %ArticleFields = (
        Sender => {                     # mandatory
            Label => 'Sender',
            Value => 'John Smith',
            Prio  => 100,
        },
        Subject => {                    # mandatory
            Label => 'Subject',
            Value => 'Message',
            Prio  => 200,
        },
        ...
    );

=cut

sub ArticleFields {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $BackendObject = $Self->_BackendGet(%Param);

    # Return backend response.
    return $BackendObject->ArticleFields(
        %Param,
    );
}

=head2 ArticlePreview()

Get article content preview as returned by specific article backend.

    my $ArticlePreview = $LayoutObject->ArticlePreview(
        TicketID   => 123,     # (required)
        ArticleID  => 123,     # (required)
        ResultType => 'plain', # (optional) plain|HTML, default: HTML
        MaxLength  => 50,      # (optional) performs trimming (for plain result only)
    );

Returns article preview in scalar form:

    $ArticlePreview = 'Hello, world!';

=cut

sub ArticlePreview {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $BackendObject = $Self->_BackendGet(%Param);

    # Return backend response.
    return $BackendObject->ArticlePreview(
        %Param,
    );
}

=head2 ArticleActions()

Get available article actions as returned by specific article backend.

    my @Actions = $LayoutObject->ArticleActions(
        TicketID  => 123,     # (required)
        ArticleID => 123,     # (required)
    );

Returns article action array:

     @Actions = (
        {
            ItemType              => 'Dropdown',
            DropdownType          => 'Reply',
            StandardResponsesStrg => $StandardResponsesStrg,
            Name                  => 'Reply',
            Class                 => 'AsPopup PopupType_TicketAction',
            Action                => 'AgentTicketCompose',
            FormID                => 'Reply' . $Article{ArticleID},
            ResponseElementID     => 'ResponseID',
            Type                  => $Param{Type},
        },
        {
            ItemType    => 'Link',
            Description => 'Forward article via mail',
            Name        => 'Forward',
            Class       => 'AsPopup PopupType_TicketAction',
            Link =>
                "Action=AgentTicketForward;TicketID=$Ticket{TicketID};ArticleID=$Article{ArticleID}"
        },
        ...
     );

=cut

sub ArticleActions {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $BackendObject = $Self->_BackendGet(%Param);

    # Return backend response.
    return $BackendObject->ArticleActions(
        %Param,
        UserID => $Self->{UserID},
    );
}

=head2 ArticleCustomerRecipientsGet()

Get customer users from an article to use as recipients.

    my @CustomerUserIDs = $LayoutObject->ArticleCustomerRecipientsGet(
        TicketID  => 123,     # (required)
        ArticleID => 123,     # (required)
    );

Returns array of customer user IDs who should receive a message:

    @CustomerUserIDs = (
        'customer-1',
        'customer-2',
        ...
    );

=cut

sub ArticleCustomerRecipientsGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $BackendObject = $Self->_BackendGet(%Param);

    # Return backend response.
    return $BackendObject->ArticleCustomerRecipientsGet(
        %Param,
        UserID => $Self->{UserID},
    );
}

=head2 ArticleQuote()

get body and attach e. g. inline documents and/or attach all attachments to
upload cache

for forward or split, get body and attach all attachments

    my $HTMLBody = $LayoutObject->ArticleQuote(
        TicketID           => 123,
        ArticleID          => 123,
        FormID             => $Self->{FormID},
        UploadCacheObject   => $Self->{UploadCacheObject},
        AttachmentsInclude => 1,
    );

or just for including inline documents to upload cache

    my $HTMLBody = $LayoutObject->ArticleQuote(
        TicketID           => 123,
        ArticleID          => 123,
        FormID             => $Self->{FormID},
        UploadCacheObject  => $Self->{UploadCacheObject},
        AttachmentsInclude => 0,
    );

Both will also work without rich text (if $ConfigObject->Get('Frontend::RichText')
is false), return param will be text/plain instead.

=cut

sub ArticleQuote {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TicketID ArticleID FormID UploadCacheObject)) {
        if ( !$Param{$Needed} ) {
            $Self->FatalError( Message => "Need $Needed!" );
        }
    }

    my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
    my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $ArticleBackendObject = $ArticleObject->BackendForArticle(
        ArticleID => $Param{ArticleID},
        TicketID  => $Param{TicketID}
    );

    # body preparation for plain text processing
    if ( $ConfigObject->Get('Frontend::RichText') ) {

        my $Body = '';

        my %NotInlineAttachments;

        my %QuoteArticle = $ArticleBackendObject->ArticleGet(
            TicketID      => $Param{TicketID},
            ArticleID     => $Param{ArticleID},
            DynamicFields => 0,
        );

        # Get the attachments without message bodies.
        $QuoteArticle{Atms} = {
            $ArticleBackendObject->ArticleAttachmentIndex(
                ArticleID        => $Param{ArticleID},
                ExcludePlainText => 1,
                ExcludeHTMLBody  => 1,
            )
        };

        # Check if there is HTML body attachment.
        my %AttachmentIndexHTMLBody = $ArticleBackendObject->ArticleAttachmentIndex(
            ArticleID    => $Param{ArticleID},
            OnlyHTMLBody => 1,
        );
        my ($HTMLBodyAttachmentID) = sort keys %AttachmentIndexHTMLBody;

        if ($HTMLBodyAttachmentID) {
            my %AttachmentHTML = $ArticleBackendObject->ArticleAttachment(
                TicketID  => $QuoteArticle{TicketID},
                ArticleID => $QuoteArticle{ArticleID},
                FileID    => $HTMLBodyAttachmentID,
            );
            my $Charset = $AttachmentHTML{ContentType} || '';
            $Charset =~ s/.+?charset=("|'|)(\w+)/$2/gi;
            $Charset =~ s/"|'//g;
            $Charset =~ s/(.+?);.*/$1/g;

            # convert html body to correct charset
            $Body = $Kernel::OM->Get('Kernel::System::Encode')->Convert(
                Text  => $AttachmentHTML{Content},
                From  => $Charset,
                To    => $Self->{UserCharset},
                Check => 1,
            );

            # get HTML utils object
            my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

            # add url quoting
            $Body = $HTMLUtilsObject->LinkQuote(
                String => $Body,
            );

            # strip head, body and meta elements
            $Body = $HTMLUtilsObject->DocumentStrip(
                String => $Body,
            );

            # display inline images if exists
            my $SessionID = '';
            if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
                $SessionID = ';' . $Self->{SessionName} . '=' . $Self->{SessionID};
            }
            my $AttachmentLink = $Self->{Baselink}
                . 'Action=PictureUpload'
                . ';FormID='
                . $Param{FormID}
                . $SessionID
                . ';ContentID=';

            # search inline documents in body and add it to upload cache
            my %Attachments = %{ $QuoteArticle{Atms} };
            my %AttachmentAlreadyUsed;
            $Body =~ s{
                (=|"|')cid:(.*?)("|'|>|\/>|\s)
            }
            {
                my $Start= $1;
                my $ContentID = $2;
                my $End = $3;

                # improve html quality
                if ( $Start ne '"' && $Start ne '\'' ) {
                    $Start .= '"';
                }
                if ( $End ne '"' && $End ne '\'' ) {
                    $End = '"' . $End;
                }

                # find attachment to include
                ATMCOUNT:
                for my $AttachmentID ( sort keys %Attachments ) {

                    if ( lc $Attachments{$AttachmentID}->{ContentID} ne lc "<$ContentID>" ) {
                        next ATMCOUNT;
                    }

                    # get whole attachment
                    my %AttachmentPicture = $ArticleBackendObject->ArticleAttachment(
                        TicketID => $Param{TicketID},
                        ArticleID => $Param{ArticleID},
                        FileID    => $AttachmentID,
                    );

                    # content id cleanup
                    $AttachmentPicture{ContentID} =~ s/^<//;
                    $AttachmentPicture{ContentID} =~ s/>$//;

                    # find cid, add attachment URL and remember, file is already uploaded
                    $ContentID = $AttachmentLink . $Self->LinkEncode( $AttachmentPicture{ContentID} );

                    # add to upload cache if not uploaded and remember
                    if (!$AttachmentAlreadyUsed{$AttachmentID}) {

                        # remember
                        $AttachmentAlreadyUsed{$AttachmentID} = 1;

                        # write attachment to upload cache
                        $Param{UploadCacheObject}->FormIDAddFile(
                            FormID      => $Param{FormID},
                            Disposition => 'inline',
                            %{ $Attachments{$AttachmentID} },
                            %AttachmentPicture,
                        );
                    }
                }

                # return link
                $Start . $ContentID . $End;
            }egxi;

            # find inline images using Content-Location instead of Content-ID
            ATTACHMENT:
            for my $AttachmentID ( sort keys %Attachments ) {

                next ATTACHMENT if !$Attachments{$AttachmentID}->{ContentID};

                # get whole attachment
                my %AttachmentPicture = $ArticleBackendObject->ArticleAttachment(
                    TicketID  => $Param{TicketID},
                    ArticleID => $Param{ArticleID},
                    FileID    => $AttachmentID,
                );

                # content id cleanup
                $AttachmentPicture{ContentID} =~ s/^<//;
                $AttachmentPicture{ContentID} =~ s/>$//;

                $Body =~ s{
                    ("|')(\Q$AttachmentPicture{ContentID}\E)("|'|>|\/>|\s)
                }
                {
                    my $Start= $1;
                    my $ContentID = $2;
                    my $End = $3;

                    # find cid, add attachment URL and remember, file is already uploaded
                    $ContentID = $AttachmentLink . $Self->LinkEncode( $AttachmentPicture{ContentID} );

                    # add to upload cache if not uploaded and remember
                    if (!$AttachmentAlreadyUsed{$AttachmentID}) {

                        # remember
                        $AttachmentAlreadyUsed{$AttachmentID} = 1;

                        # write attachment to upload cache
                        $Param{UploadCacheObject}->FormIDAddFile(
                            FormID      => $Param{FormID},
                            Disposition => 'inline',
                            %{ $Attachments{$AttachmentID} },
                            %AttachmentPicture,
                        );
                    }

                    # return link
                    $Start . $ContentID . $End;
                }egxi;
            }

            # find not inline images
            ATTACHMENT:
            for my $AttachmentID ( sort keys %Attachments ) {
                next ATTACHMENT if $AttachmentAlreadyUsed{$AttachmentID};
                $NotInlineAttachments{$AttachmentID} = 1;
            }
        }

        # attach also other attachments on article forward
        if ( $Body && $Param{AttachmentsInclude} ) {
            for my $AttachmentID ( sort keys %NotInlineAttachments ) {
                my %Attachment = $ArticleBackendObject->ArticleAttachment(
                    TicketID  => $Param{TicketID},
                    ArticleID => $Param{ArticleID},
                    FileID    => $AttachmentID,
                );

                # add attachment
                $Param{UploadCacheObject}->FormIDAddFile(
                    FormID => $Param{FormID},
                    %Attachment,
                    Disposition => 'attachment',
                );
            }
        }

        # Fallback for non-MIMEBase articles: get article HTML content if it exists.
        if ( !$Body ) {
            $Body = $Self->ArticlePreview(
                TicketID  => $Param{TicketID},
                ArticleID => $Param{ArticleID},
            );
        }

        return $Body if $Body;
    }

    # as fallback use text body for quote
    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID      => $Param{TicketID},
        ArticleID     => $Param{ArticleID},
        DynamicFields => 0,
    );

    # check if original content isn't text/plain or text/html, don't use it
    if ( !$Article{ContentType} ) {
        $Article{ContentType} = 'text/plain';
    }

    if ( $Article{ContentType} !~ /text\/(plain|html)/i ) {
        $Article{Body}        = '-> no quotable message <-';
        $Article{ContentType} = 'text/plain';
    }
    else {
        $Article{Body} = $Self->WrapPlainText(
            MaxCharacters => $ConfigObject->Get('Ticket::Frontend::TextAreaEmail') || 82,
            PlainText     => $Article{Body},
        );
    }

    # attach attachments
    if ( $Param{AttachmentsInclude} ) {
        my %ArticleIndex = $ArticleBackendObject->ArticleAttachmentIndex(
            ArticleID        => $Param{ArticleID},
            ExcludePlainText => 1,
            ExcludeHTMLBody  => 1,
        );
        for my $Index ( sort keys %ArticleIndex ) {
            my %Attachment = $ArticleBackendObject->ArticleAttachment(
                TicketID  => $Param{TicketID},
                ArticleID => $Param{ArticleID},
                FileID    => $Index,
            );

            # add attachment
            $Param{UploadCacheObject}->FormIDAddFile(
                FormID => $Param{FormID},
                %Attachment,
                Disposition => 'attachment',
            );
        }
    }

    # return body as html
    if ( $ConfigObject->Get('Frontend::RichText') ) {

        $Article{Body} = $Self->Ascii2Html(
            Text           => $Article{Body},
            HTMLResultMode => 1,
            LinkFeature    => 1,
        );
    }

    # return body as plain text
    return $Article{Body};
}

sub _BackendGet {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param);

    # Determine channel name for this article.
    my $ChannelName = $ArticleBackendObject->ChannelNameGet();

    my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
        "Kernel::Output::HTML::Article::$ChannelName",
    );
    return if !$Loaded;

    return $Kernel::OM->Get("Kernel::Output::HTML::Article::$ChannelName");
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
