# --
# Kernel/Modules/CustomerTicketAttachment.pm - to get the attachments
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: CustomerTicketAttachment.pm,v 1.13 2009-07-18 15:19:33 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketAttachment;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject UserObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # get ArticleID
    $Self->{ArticleID} = $Self->{ParamObject}->GetParam( Param => 'ArticleID' );
    $Self->{FileID}    = $Self->{ParamObject}->GetParam( Param => 'FileID' );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check params
    if ( !$Self->{FileID} || !$Self->{ArticleID} ) {
        my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
        $Output .= $Self->{LayoutObject}->CustomerError(
            Message => 'FileID and ArticleID are needed!',
            Comment => 'Please contact your admin'
        );
        $Self->{LogObject}->Log(
            Message  => 'FileID and ArticleID are needed!',
            Priority => 'error',
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    # check permissions
    my %ArticleData = $Self->{TicketObject}->ArticleGet( ArticleID => $Self->{ArticleID} );
    if ( !$ArticleData{TicketID} ) {
        my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
        $Output .= $Self->{LayoutObject}->CustomerError(
            Message => "No TicketID for ArticleID ($Self->{ArticleID})!",
            Comment => 'Please contact your admin'
        );
        $Self->{LogObject}->Log(
            Message  => "No TicketID for ArticleID ($Self->{ArticleID})!",
            Priority => 'error',
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    # check permission
    my $Access = $Self->{TicketObject}->CustomerPermission(
        Type     => 'ro',
        TicketID => $ArticleData{TicketID},
        UserID   => $Self->{UserID}
    );
    if ( !$Access ) {
        return $Self->{LayoutObject}->CustomerNoPermission( WithHeader => 'yes' );
    }

    # get attachment
    my %Data = $Self->{TicketObject}->ArticleAttachment(
        ArticleID => $Self->{ArticleID},
        FileID    => $Self->{FileID},
    );
    if ( !%Data ) {
        my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
        $Output .= $Self->{LayoutObject}->CustomerError(
            Message => "No such attachment ($Self->{FileID})!",
            Comment => 'Please contact your admin'
        );
        $Self->{LogObject}->Log(
            Message  => "No such attachment ($Self->{FileID})! May be an attack!!!",
            Priority => 'error',
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    # view attachment for html email
    if ( $Self->{Subaction} eq 'HTMLView' ) {

        # set download type to inline
        $Self->{ConfigObject}->Set( Key => 'AttachmentDownloadType', Value => 'inline' );

        # just return for non-html attachment (e. g. images)
        if ( $Data{ContentType} !~ /text\/html/i ) {
            return $Self->{LayoutObject}->Attachment(%Data);
        }

        # unset filename for inline viewing
        $Data{Filename} = '';

        # make sure encoding is correct (add utf8 flag, because
        # it was a binary attachment)
        $Self->{EncodeObject}->Encode( \$Data{Content} );

        # replace links to inline images in html content
        my %AtmBox = $Self->{TicketObject}->ArticleAttachmentIndex(
            ArticleID => $Self->{ArticleID},
        );

        # build base url for inline images
        my $SessionID = '';
        if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
            $SessionID = '&' . $Self->{SessionName} . '=' . $Self->{SessionID};
        }
        my $AttachmentLink = $Self->{LayoutObject}->{Baselink}
            . 'Action=CustomerTicketAttachment'
            . '&ArticleID='
            . $Self->{ArticleID}
            . $SessionID
            . '&FileID=';

        # replace inline images in content with runtime url to images
        $Data{Content} =~ s{
            "cid:(.*?)"
        }
        {
            my $ContentID = $1;

            # find matching attachment and replace it with runtlime url to image
            for my $AttachmentID ( keys %AtmBox ) {
                next if $AtmBox{$AttachmentID}->{ContentID} !~ /^<$ContentID>$/i;
                $ContentID = $AttachmentLink . $AttachmentID;
                last;
            }

            # return link
            '"' . $ContentID . '"';
        }egxi;

        # return html attachment
        return $Self->{LayoutObject}->Attachment(%Data);
    }

    # download it AttachmentDownloadType is configured
    return $Self->{LayoutObject}->Attachment(%Data);
}

1;
