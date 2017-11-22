# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketArticleContent;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');

    my $TicketID  = $ParamObject->GetParam( Param => 'TicketID' );
    my $ArticleID = $ParamObject->GetParam( Param => 'ArticleID' );

    # check params
    if ( !$ArticleID ) {
        my $Output = $LayoutObject->CustomerHeader( Title => 'Error' );
        $Output .= $LayoutObject->CustomerError(
            Message => Translatable('ArticleID is needed!'),
            Comment => Translatable('Please contact the administrator.'),
        );
        $LogObject->Log(
            Message  => 'ArticleID is needed!',
            Priority => 'error',
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }

    if ( !$TicketID ) {
        my $Output = $LayoutObject->CustomerHeader( Title => 'Error' );
        $Output .= $LayoutObject->CustomerError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'No TicketID for ArticleID (%s)!', $ArticleID ),
            Comment => Translatable('Please contact the administrator.'),
        );
        $LogObject->Log(
            Message  => "No TicketID for ArticleID ($ArticleID)!",
            Priority => 'error',
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    my @ArticleList = $ArticleObject->ArticleList(
        TicketID             => $TicketID,
        ArticleID            => $ArticleID,
        IsVisibleForCustomer => 1,
    );

    my $ArticleBackendObject;
    my %Article;

    ARTICLEMETADATA:
    for my $ArticleMetaData (@ArticleList) {

        next ARTICLEMETADATA if !$ArticleMetaData;
        next ARTICLEMETADATA if !IsHashRefWithData($ArticleMetaData);

        $ArticleBackendObject = $ArticleObject->BackendForArticle( %{$ArticleMetaData} );

        %Article = $ArticleBackendObject->ArticleGet(
            TicketID      => $TicketID,
            ArticleID     => $ArticleMetaData->{ArticleID},
            DynamicFields => 0,
        );
    }

    # check permission
    my $Access = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCustomerPermission(
        Type     => 'ro',
        TicketID => $TicketID,
        UserID   => $Self->{UserID}
    );
    if ( !$Access ) {
        return $LayoutObject->CustomerNoPermission( WithHeader => 'yes' );
    }

    # Render article content.
    my $ArticleContent = $LayoutObject->ArticlePreview(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    );

    if ( !$ArticleContent ) {
        my $Output = $LayoutObject->CustomerHeader( Title => 'Error' );
        $Output .= $LayoutObject->CustomerError(
            Message => $LayoutObject->{LanguageObject}->Translate('HTML body attachment is missing!'),
            Comment => Translatable('Please contact the administrator.'),
        );
        $LogObject->Log(
            Message  => "HTML body attachment is missing! May be an attack!!!",
            Priority => 'error',
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }

    my $ContentType = 'text/html; charset="utf-8"';

    # Match content type of rendered content. This is important, because later this content will be converted to
    #   internal charset (UTF-8) in RichTextDocumentServe(), and this method needs to know original charset.
    #   Please see bug#13367 for more information.
    if ( $ArticleContent =~ /<meta [^>]+ content=(?:"|')?(?<ContentType>[^"'>]+)/ixms ) {
        $ContentType = $+{ContentType};
    }

    my $Content = $LayoutObject->Output(
        Template => '[% Data.HTML %]',
        Data     => {
            HTML => $ArticleContent,
        },
    );

    my %Data = (
        Content            => $Content,
        ContentAlternative => "",
        ContentID          => "",
        ContentType        => $ContentType,
        Disposition        => "inline",
        FilesizeRaw        => bytes::length($Content),
    );

    # set download type to inline
    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => 'AttachmentDownloadType',
        Value => 'inline'
    );

    my $TicketNumber = $Kernel::OM->Get('Kernel::System::Ticket')->TicketNumberLookup(
        TicketID => $TicketID,
    );

    # unset filename for inline viewing
    $Data{Filename} = "Ticket-$TicketNumber-ArticleID-$Article{ArticleID}.html";

    # safety check only on customer article
    my $LoadExternalImages = $ParamObject->GetParam(
        Param => 'LoadExternalImages'
    ) || 0;
    if ( !$LoadExternalImages && $Article{SenderType} ne 'customer' ) {
        $LoadExternalImages = 1;
    }

    # generate base url
    my $URL = 'Action=CustomerTicketAttachment;Subaction=HTMLView'
        . ";ArticleID=$ArticleID;FileID=";

    # replace links to inline images in html content
    my %AtmBox = $ArticleBackendObject->ArticleAttachmentIndex(
        ArticleID => $ArticleID,
    );

    # reformat rich text document to have correct charset and links to
    # inline documents
    %Data = $LayoutObject->RichTextDocumentServe(
        Data               => \%Data,
        URL                => $URL,
        Attachments        => \%AtmBox,
        LoadExternalImages => $LoadExternalImages,
    );

    # return html attachment
    return $LayoutObject->Attachment(
        %Data,
        Sandbox => 1,
    );
}

1;
