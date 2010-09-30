# --
# Kernel/Modules/CustomerTicketAttachment.pm - to get the attachments
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: CustomerTicketAttachment.pm,v 1.17.2.5 2010-09-30 11:48:45 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketAttachment;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.17.2.5 $) [1];

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

    $Self->{LoadInlineContent} = $Self->{ParamObject}->GetParam( Param => 'LoadInlineContent' )
        || 0;

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
    my %Article = $Self->{TicketObject}->ArticleGet( ArticleID => $Self->{ArticleID} );
    if ( !$Article{TicketID} ) {
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
        TicketID => $Article{TicketID},
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
        $Data{Filename} = "Ticket-$Article{TicketNumber}-ArticleID-$Article{ArticleID}.html";

        # safety check only on customer article
        if ( !$Self->{LoadInlineContent} && $Article{SenderType} ne 'customer' ) {
            $Self->{LoadInlineContent} = 1;
        }

        # get charset and convert content to internal charset
        if ( $Self->{EncodeObject}->EncodeInternalUsed() ) {
            my $Charset = $Data{ContentType};
            $Charset =~ s/.+?charset=("|'|)(\w+)/$2/gi;
            $Charset =~ s/"|'//g;
            $Charset =~ s/(.+?);.*/$1/g;

            # convert charset
            if ($Charset) {
                $Data{Content} = $Self->{EncodeObject}->Convert(
                    Text => $Data{Content},
                    From => $Charset,
                    To   => $Self->{LayoutObject}->{UserCharset},
                );

                # replace charset in content
                $Data{Content}     =~ s/$Charset/utf-8/gi;
                $Data{ContentType} =~ s/$Charset/utf-8/gi;
            }
        }

        # add html links
        $Data{Content} = $Self->{LayoutObject}->HTMLLinkQuote(
            String => $Data{Content},
        );

        # cleanup some html tags to be cross browser compat.
        $Data{Content} = $Self->{LayoutObject}->RichTextDocumentCleanup(
            String => $Data{Content},
        );

        # safety check
        if ( !$Self->{LoadInlineContent} ) {
            $Data{Content} = $Self->RichTextDocumentSafetyCheck(
                String => $Data{Content},
            );
        }

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
            . 'Action=CustomerTicketAttachment&Subaction=HTMLView'
            . '&ArticleID='
            . $Self->{ArticleID}
            . $SessionID
            . '&FileID=';

        # replace inline images in content with runtime url to images
        $Data{Content} =~ s{
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

            # find matching attachment and replace it with runtime url to image
            for my $AttachmentID ( keys %AtmBox ) {
                next if lc $AtmBox{$AttachmentID}->{ContentID} ne lc "<$ContentID>";
                $ContentID = $AttachmentLink . $AttachmentID;
                last;
            }

            # return new runtime url
            $Start . $ContentID . $End;
        }egxi;

        # return html attachment
        return $Self->{LayoutObject}->Attachment(%Data);
    }

    # download it AttachmentDownloadType is configured
    return $Self->{LayoutObject}->Attachment(%Data);
}

=item RichTextDocumentSafetyCheck()

check if content is safety

    $HTMLBody = $LayoutObject->RichTextDocumentSafetyCheck(
        String => $HTMLBody,
    );

=cut

sub RichTextDocumentSafetyCheck {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(String)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # safety check
    my %Safety = $Self->Safety(
        String       => \$Param{String},
        NoApplet     => 1,
        NoObject     => 1,
        NoEmbed      => 1,
        NoIntSrcLoad => 0,
        NoExtSrcLoad => 1,
        NoJavaScript => 1,
        Debug        => $Self->{Debug},
    );

    # return if no safety change has been done
    return $Param{String} if !$Safety{Replaced};

    # generate blocker message
    my $Message = $Self->{LayoutObject}->Output(
        TemplateFile => 'AttachmentBlocker',
    );

    # add it on top of page
    if ( ${ $Safety{String} } =~ /<body.*?/si ) {
        ${ $Safety{String} } =~ s/(<body.*?>)/$1\n$Message/si;
    }

    # add it to end of page
    else {
        ${ $Safety{String} } = $Message . ${ $Safety{String} };
    }

    return ${ $Safety{String} };
}

=item Safety()

To remove/strip active html tags/addons (javascript, applets, embeds and objects)
from html strings.

    my %Safe = $HTMLUtilsObject->Safety(
        String       => $HTMLString,
        NoApplet     => 1,
        NoObject     => 1,
        NoEmbed      => 1,
        NoIntSrcLoad => 0,
        NoExtSrcLoad => 1,
        NoJavaScript => 1,
    );

also string ref is possible

    my %Safe = $HTMLUtilsObject->Safety(
        String       => \$HTMLStringRef,
        NoApplet     => 1,
        NoObject     => 1,
        NoEmbed      => 1,
        NoIntSrcLoad => 0,
        NoExtSrcLoad => 1,
        NoJavaScript => 1,
    );

returns

    my %Safe = (
        String   => $HTMLString, # modified html string (scalar or ref)
        Replaced => 1,           # 1|0 - info if something got replaced
    );

=cut

sub Safety {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(String)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $String = $Param{String} || '';

    # check ref
    my $StringScalar;
    if ( !ref $String ) {
        $StringScalar = $String;
        $String       = \$StringScalar;
    }

    my %Safety;

    # remove script tags
    if ( $Param{NoJavaScript} ) {
        ${$String} =~ s{
            <scrip.+?>(.+?)</script>
        }
        {
            $Safety{Replaced} = 1;
            if ($Param{Debug}) {
                " # removed script tags # ";
            }
            else {
                '';
            }
        }segxim;
    }

    # remove <applet> tags
    if ( $Param{NoApplet} ) {
        ${$String} =~ s{
            <apple.+?>(.+?)</applet>
        }
        {
            $Safety{Replaced} = 1;
            if ($Param{Debug}) {
                " # removed applet tags # ";
            }
            else {
                '';
            }
        }segxim;
    }

    # remove <Object> tags
    if ( $Param{NoObject} ) {
        ${$String} =~ s{
            <objec.+?>(.+?)</object>
        }
        {
            $Safety{Replaced} = 1;
            if ($Param{Debug}) {
                " # removed object tags # ";
            }
            else {
                '';
            }
        }segxim;
    }

    # remove style/javascript parts
    if ( $Param{NoJavaScript} ) {
        ${$String} =~ s{
            <style.+?javascript(.+?|)>(.*)</style>
        }
        {
            $Safety{Replaced} = 1;
            if ($Param{Debug}) {
                " # removed javascript style tag # ";
            }
            else {
                '';
            }
        }segxim;
    }

    # check each html tag
    ${$String} =~ s{
        (<.+?>)
    }
    {
        my $Tag = $1;
        if ($Param{NoJavaScript}) {
            # remove on action sub tags
            $Tag =~ s{
                \s(on.{4,10}=(".+?"|'.+?'|.+?))
            }
            {
                $Safety{Replaced} = 1;
                if ($Param{Debug}) {
                    " # removed java script on action ($1) # ";
                }
                else {
                    '';
                }
            }segxim;

            # remove entities sub tags
            $Tag =~ s{
                (&\{.+?\})
            }
            {
                $Safety{Replaced} = 1;
                if ($Param{Debug}) {
                    " # removed java script entities tag ($1) # ";
                }
                else {
                    '';
                }
            }segxim;

            # remove javascript in a href links or src links
            $Tag =~ s{
                (<(a\shref|src)=)("javascript.+?"|'javascript.+?'|javascript.+?)(\s>|>|.+?>)
            }
            {
                $Safety{Replaced} = 1;
                if ($Param{Debug}) {
                    " # removed java script # ";
                }
                else {
                    "$1$4";
                }
            }segxim;

            # remove link javascript tags
            $Tag =~ s{
                (<(a\shref|src)=)("javascript.+?"|'javascript.+?'|javascript.+?)(\s>|>|.+?>)
            }
            {
                $Safety{Replaced} = 1;
                if ($Param{Debug}) {
                    " # removed java script # ";
                }
                else {
                    "$1$4";
                }
            }segxim;

            # remove link javascript tags
            $Tag =~ s{
                (<link.+?javascript(.+?|)>)
            }
            {
                $Safety{Replaced} = 1;
                " # removed javascript link tag # ";
            }segxim;
        }

        # remove <embed> tags
        if ($Param{NoEmbed}) {
            $Tag =~ s{
                (<embed\s(.+?)>)
            }
            {
                $Safety{Replaced} = 1;
                if ($Param{Debug}) {
                    " # removed embed tag ($1) # ";
                }
                else {
                    '';
                }
            }segxim;
        }

        # remove load tags
        if ($Param{NoIntSrcLoad} || $Param{NoExtSrcLoad}) {
            $Tag =~ s{
                (<(.+?)\ssrc=(.+?)(\s.+?|)>)
            }
            {
                my $URL = $3;
                if ($Param{NoIntSrcLoad} || ($Param{NoExtSrcLoad} && $URL =~ /(http|ftp|https):\//i)) {
                    $Safety{Replaced} = 1;
                    if ($Param{Debug}) {
                        " # blocked '$URL' # ";
                    }
                    else {
                       '';
                    }
                }
                else {
                    $1;
                }
            }segxim;
        }

        # replace original tag with clean tag
        $Tag;
    }segxim;

    # check ref && return result like called
    if ($StringScalar) {
        $Safety{String} = ${$String};
    }
    else {
        $Safety{String} = $String;
    }
    return %Safety;
}

1;
