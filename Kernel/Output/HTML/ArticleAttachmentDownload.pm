# --
# Kernel/Output/HTML/ArticleAttachmentDownload.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: ArticleAttachmentDownload.pm,v 1.6 2007-09-29 10:49:44 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::ArticleAttachmentDownload;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

sub new {
    my $Type  = shift;
    my %Param = @_;

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
    my $Self  = shift;
    my %Param = @_;

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
