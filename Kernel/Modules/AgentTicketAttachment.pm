# --
# Kernel/Modules/AgentTicketAttachment.pm - to get the attachments
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketAttachment.pm,v 1.17 2009-07-20 10:36:04 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketAttachment;

use strict;
use warnings;

use Kernel::System::FileTemp;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.17 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{FileTempObject} = Kernel::System::FileTemp->new(%Param);

    # get ArticleID
    $Self->{ArticleID} = $Self->{ParamObject}->GetParam( Param => 'ArticleID' );
    $Self->{FileID}    = $Self->{ParamObject}->GetParam( Param => 'FileID' );
    $Self->{Viewer}    = $Self->{ParamObject}->GetParam( Param => 'Viewer' ) || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    # check params
    if ( !$Self->{FileID} || !$Self->{ArticleID} ) {
        $Self->{LogObject}->Log(
            Message  => 'FileID and ArticleID are needed!',
            Priority => 'error',
        );
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # check permissions
    my %ArticleData = $Self->{TicketObject}->ArticleGet( ArticleID => $Self->{ArticleID} );
    if ( !$ArticleData{TicketID} ) {
        $Self->{LogObject}->Log(
            Message  => "No TicketID for ArticleID ($Self->{ArticleID})!",
            Priority => 'error',
        );
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # check permissions
    my $Access = $Self->{TicketObject}->Permission(
        Type     => 'ro',
        TicketID => $ArticleData{TicketID},
        UserID   => $Self->{UserID}
    );
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # get a attachment
    my %Data = $Self->{TicketObject}->ArticleAttachment(
        ArticleID => $Self->{ArticleID},
        FileID    => $Self->{FileID},
    );
    if ( !%Data ) {
        $Self->{LogObject}->Log(
            Message  => "No such attacment ($Self->{FileID})! May be an attack!!!",
            Priority => 'error',
        );
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # find viewer for ContentType
    my $Viewer = '';
    if ( $Self->{Viewer} && $Self->{ConfigObject}->Get('MIME-Viewer') ) {
        for ( keys %{ $Self->{ConfigObject}->Get('MIME-Viewer') } ) {
            if ( $Data{ContentType} =~ /^$_/i ) {
                $Viewer = $Self->{ConfigObject}->Get('MIME-Viewer')->{$_};
                $Viewer =~ s/\<OTRS_CONFIG_(.+?)\>/$Self->{ConfigObject}->{$1}/g;
            }
        }
    }

    # show with viewer
    if ( $Self->{Viewer} && $Viewer ) {

        # write tmp file
        my ( $FH, $Filename ) = $Self->{FileTempObject}->TempFile();
        if ( open( DATA, '>', $Filename ) ) {
            print DATA $Data{Content};
            close(DATA);
        }
        else {

            # log error
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Cant write $Filename: $!",
            );
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # use viewer
        my $Content = '';
        if ( open( DATA, "$Viewer $Filename |" ) ) {
            while (<DATA>) {
                $Content .= $_;
            }
            close(DATA);
        }
        else {
            return $Self->{LayoutObject}->FatalError(
                Message => "Can't open: $Viewer $Filename: $!",
            );
        }

        # return new page
        return $Self->{LayoutObject}->Attachment(
            %Data,
            ContentType => 'text/html',
            Content     => $Content,
            Type        => 'inline'
        );
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

        # add html links
        $Data{Content} = $Self->{LayoutObject}->HTMLLinkQuote(
            Text => $Data{Content},
        );

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
            . 'Action=AgentTicketAttachment&Subaction=HTMLView'
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

            # return new runtime url
            '"' . $ContentID . '"';
        }egxi;

        # return html attachment
        return $Self->{LayoutObject}->Attachment(%Data);
    }

    # download it AttachmentDownloadType is configured
    return $Self->{LayoutObject}->Attachment(%Data);
}

1;
