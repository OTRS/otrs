# --
# Kernel/Modules/CustomerTicketAttachment.pm - to get the attachments
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: CustomerTicketAttachment.pm,v 1.3.4.1 2008-07-24 10:09:14 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::CustomerTicketAttachment;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3.4.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Objects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject UserObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    # get ArticleID
    $Self->{ArticleID} = $Self->{ParamObject}->GetParam(Param => 'ArticleID');
    $Self->{FileID} = $Self->{ParamObject}->GetParam(Param => 'FileID');

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # check params
    if (!$Self->{FileID} || !$Self->{ArticleID}) {
        $Output .= $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
        $Output .= $Self->{LayoutObject}->CustomerError(
            Message => 'FileID and ArticleID are needed!',
            Comment => 'Please contact your admin'
        );
        $Self->{LogObject}->Log(
            Message => 'FileID and ArticleID are needed!',
            Priority => 'error',
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    # check permissions
    my %ArticleData = $Self->{TicketObject}->ArticleGet(ArticleID => $Self->{ArticleID});
    if (!$ArticleData{TicketID}) {
        $Output .= $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
        $Output .= $Self->{LayoutObject}->CustomerError(
            Message => "No TicketID for ArticleID ($Self->{ArticleID})!",
            Comment => 'Please contact your admin'
        );
        $Self->{LogObject}->Log(
            Message => "No TicketID for ArticleID ($Self->{ArticleID})!",
            Priority => 'error',
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
    # check permission
    if (!$Self->{TicketObject}->CustomerPermission(
        Type => 'ro',
        TicketID => $ArticleData{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->CustomerNoPermission(WithHeader => 'yes');
    }

    # geta attachment
    if (my %Data = $Self->{TicketObject}->ArticleAttachment(
        ArticleID => $Self->{ArticleID},
        FileID => $Self->{FileID},
    )) {
        return $Self->{LayoutObject}->Attachment(%Data);
    }
    else {
        $Output .= $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
        $Output .= $Self->{LayoutObject}->CustomerError(
            Message => "No such attacment ($Self->{FileID})!",
            Comment => 'Please contact your admin'
        );
        $Self->{LogObject}->Log(
            Message => "No such attacment ($Self->{FileID})! May be an attack!!!",
            Priority => 'error',
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
}

1;
