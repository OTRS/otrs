# --
# Kernel/Output/HTML/ArticleAttachmentDownload.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: ArticleAttachmentDownload.pm,v 1.15.2.1 2013-01-02 13:02:46 mn Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ArticleAttachmentDownload;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.15.2.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject UserID TicketObject ArticleID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(File Article)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # download type
    my $Type = $Self->{ConfigObject}->Get('AttachmentDownloadType') || 'attachment';

    # if attachment will be forced to download, don't open a new download window!
    my $Target = 'target="AttachmentWindow" ';
    if ( $Type =~ /inline/i ) {
        $Target = 'target="attachment" ';
    }

    # include Filename in URL because of encoding problems with IIS/IE
    my $EncodedFilename = $Self->{LayoutObject}->LinkEncode( $Param{File}->{Filename} || '' );

    return (
        %{ $Param{File} },
        Action => 'Download',
        Link =>
            "\$Env{\"CGIHandle\"}/$EncodedFilename?Action=AgentTicketAttachment;ArticleID=$Param{Article}->{ArticleID};FileID=$Param{File}->{FileID}",
        Image  => 'disk-s.png',
        Target => $Target,
    );
}

1;
