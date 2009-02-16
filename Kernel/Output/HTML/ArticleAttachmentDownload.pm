# --
# Kernel/Output/HTML/ArticleAttachmentDownload.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: ArticleAttachmentDownload.pm,v 1.9 2009-02-16 11:16:22 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ArticleAttachmentDownload;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

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
    my $Target = '';
    if ( $Type =~ /inline/i ) {
        $Target = 'target="attachment" ';
    }
    return (
        %{ $Param{File} },
        Action => 'Download',
        Link =>
            "\$Env{\"Baselink\"}Action=AgentTicketAttachment&ArticleID=$Param{Article}->{ArticleID}&FileID=$Param{File}->{FileID}",
        Image  => 'disk-s.png',
        Target => $Target,
    );
}

1;
