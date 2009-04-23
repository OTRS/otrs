# --
# Kernel/Modules/CustomerTicketAttachment.pm - to get the attachments
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: CustomerTicketAttachment.pm,v 1.12 2009-04-23 13:47:27 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketAttachment;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.12 $) [1];

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

    my $Output = '';

    # check params
    if ( !$Self->{FileID} || !$Self->{ArticleID} ) {
        $Output .= $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
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
        $Output .= $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
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
    if (
        !$Self->{TicketObject}->CustomerPermission(
            Type     => 'ro',
            TicketID => $ArticleData{TicketID},
            UserID   => $Self->{UserID}
        )
        )
    {

        # error screen, don't show ticket
        return $Self->{LayoutObject}->CustomerNoPermission( WithHeader => 'yes' );
    }

    # get attachment
    if (
        my %Data = $Self->{TicketObject}->ArticleAttachment(
            ArticleID => $Self->{ArticleID},
            FileID    => $Self->{FileID},
        )
        )
    {

        # regular output
        return $Self->{LayoutObject}->Attachment(%Data) if
            !$Self->{Subaction}
                || $Self->{Subaction} ne 'inline';

        # non-html attachment
        return $Self->{LayoutObject}->Attachment(%Data) if
            $Data{ContentType} !~ /html/i;

        # inline attachment view
        $Data{Filename} = '';

        # make sure encoding is correct
        $Self->{EncodeObject}->Encode(
            \$Data{Content},
        );

        # replace links to inline images if exists
        my %AtmBox = $Self->{TicketObject}->ArticleAttachmentIndex(
            ArticleID => $Self->{ArticleID},
        );
        my $SessionID = '';
        if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
            $SessionID = "&" . $Self->{SessionName} . "=" . $Self->{SessionID};
        }
        my $AttachmentLink = $Self->{LayoutObject}->{Baselink}
            . 'Action=CustomerTicketAttachment'
            . '&ArticleID='
            . $Self->{ArticleID}
            . $SessionID
            . '&FileID=';
        $Data{Content} =~ s{
            "cid:(.*?)"
        }
        {
            my $ContentID = $1;
            ATMCOUNT:
            for my $AtmCount ( keys %AtmBox ) {
                next ATMCOUNT if $AtmBox{$AtmCount}{ContentID} !~ /^<$ContentID>$/;
                $ContentID = $AttachmentLink . $AtmCount;
                last ATMCOUNT;
            }

            # return link
            '"' . $ContentID . '"';
        }egxi;

        # return html attachment
        $Self->{ConfigObject}->Set( Key => 'AttachmentDownloadType', Value => 'inline' );
        return $Self->{LayoutObject}->Attachment(%Data);
    }
    else {
        $Output .= $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
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
}

1;
