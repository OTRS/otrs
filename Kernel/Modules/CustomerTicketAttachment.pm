# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketAttachment;

use strict;
use warnings;

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
    my $ArticleID    = $ParamObject->GetParam( Param => 'ArticleID' );
    my $FileID       = $ParamObject->GetParam( Param => 'FileID' );
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');

    # check params
    if ( !$FileID || !$ArticleID ) {
        my $Output = $LayoutObject->CustomerHeader( Title => 'Error' );
        $Output .= $LayoutObject->CustomerError(
            Message => 'FileID and ArticleID are needed!',
            Comment => 'Please contact your administrator'
        );
        $LogObject->Log(
            Message  => 'FileID and ArticleID are needed!',
            Priority => 'error',
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # check permissions
    my %Article = $TicketObject->ArticleGet(
        ArticleID     => $ArticleID,
        DynamicFields => 0,
    );

    if ( !$Article{TicketID} ) {
        my $Output = $LayoutObject->CustomerHeader( Title => 'Error' );
        $Output .= $LayoutObject->CustomerError(
            Message => "No TicketID for ArticleID ($ArticleID)!",
            Comment => 'Please contact your administrator'
        );
        $LogObject->Log(
            Message  => "No TicketID for ArticleID ($ArticleID)!",
            Priority => 'error',
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }

    # check permission
    my $Access = $TicketObject->TicketCustomerPermission(
        Type     => 'ro',
        TicketID => $Article{TicketID},
        UserID   => $Self->{UserID}
    );
    if ( !$Access ) {
        return $LayoutObject->CustomerNoPermission( WithHeader => 'yes' );
    }

    # get attachment
    my %Data = $TicketObject->ArticleAttachment(
        ArticleID => $ArticleID,
        FileID    => $FileID,
        UserID    => $Self->{UserID},
    );
    if ( !%Data ) {
        my $Output = $LayoutObject->CustomerHeader( Title => 'Error' );
        $Output .= $LayoutObject->CustomerError(
            Message => "No such attachment ($FileID)!",
            Comment => 'Please contact your administrator'
        );
        $LogObject->Log(
            Message  => "No such attachment ($FileID)! May be an attack!!!",
            Priority => 'error',
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }

    # view attachment for html email
    if ( $Self->{Subaction} eq 'HTMLView' ) {

        # set download type to inline
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => 'AttachmentDownloadType',
            Value => 'inline'
        );

        # just return for non-html attachment (e. g. images)
        if ( $Data{ContentType} !~ /text\/html/i ) {
            return $LayoutObject->Attachment(%Data);
        }

        # unset filename for inline viewing
        $Data{Filename} = "Ticket-$Article{TicketNumber}-ArticleID-$Article{ArticleID}.html";

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
        my %AtmBox = $TicketObject->ArticleAttachmentIndex(
            ArticleID => $ArticleID,
            UserID    => $Self->{UserID},
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
        return $LayoutObject->Attachment(%Data);
    }

    # download it AttachmentDownloadType is configured
    return $LayoutObject->Attachment(%Data);
}

1;
