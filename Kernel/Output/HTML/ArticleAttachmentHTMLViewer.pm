# --
# Kernel/Output/HTML/ArticleAttachmentHTMLViewer.pm
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: ArticleAttachmentHTMLViewer.pm,v 1.3 2006-08-29 17:15:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::ArticleAttachmentHTMLViewer;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID TicketObject ArticleID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(File Article)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # check if config exists
    if ($Self->{ConfigObject}->Get('MIME-Viewer')) {
        foreach (keys %{$Self->{ConfigObject}->Get('MIME-Viewer')}) {
            if ($Param{File}->{ContentType} =~ /^$_/i) {
                return (
                    %{$Param{File}},
                    Action => 'Viewer',
                    Link => "\$Env{\"Baselink\"}Action=AgentTicketAttachment&ArticleID=$Param{Article}->{ArticleID}&FileID=$Param{File}->{FileID}&Viewer=1",
                    Image => 'screen-s.png',
                    Target => 'target="attachment"',
                );
            }
        }
    }
    return ();
}

1;
